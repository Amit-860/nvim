-- This Lua function for Neovim helps extract the SQL query and its
-- associated file name based on your specified format.
-- It assumes:
-- 1. A file name is on a line by itself.
-- 2. The query follows immediately after the file name.
-- 3. The entire block (file name + query) is delimited by empty lines.

-- Define global variables to store the last retrieved filename and query.
vim.g.LastRetrievedFilename = ""
vim.g.LastRetrievedQuery = ""

local M = {}

-- Helper function to trim leading and trailing whitespace from a string
local function trim_string(s)
    -- The pattern "%s*(.-)%s*$" matches:
    -- %s* - zero or more whitespace characters at the beginning
    -- (.-)  - non-greedily captures any characters (the actual content)
    -- %s*$  - zero or more whitespace characters at the end
    -- The `or ""` ensures that if the string is just whitespace, it returns an empty string, not nil.
    return s:match("^%s*(.-)%s*$") or ""
end

local function removeCaseInsensitivePrefix(s, prefix)
    local lowerS = string.lower(s)
    local lowerPrefix = string.lower(prefix)

    -- Check if the string starts with the prefix (case-insensitive)
    -- We use string.sub(lowerS, 1, #lowerPrefix) to check only the beginning
    if string.sub(lowerS, 1, #lowerPrefix) == lowerPrefix then
        -- If it matches, return the substring starting after the prefix
        return string.sub(s, #prefix + 1)
    else
        -- Otherwise, return the original string
        return s
    end
end

--- Retrieves the SQL query and its associated file name under the cursor.
-- It expects a format where a filename is on a line, followed by the query,
-- and these blocks are separated by empty lines.
-- @return table A table with 'filename' (string) and 'query' (string) fields.
--               Returns { filename = "", query = "" } if no valid block is found.
function M.get_current_query_with_file_name()
    local bufnr = vim.api.nvim_get_current_buf()
    local current_line_num, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local total_lines = vim.api.nvim_buf_line_count(bufnr)

    local block_start_line = current_line_num
    local block_end_line = current_line_num

    -- --- Find the effective start of the current *entire block* (filename + query) ---
    -- Iterate upwards from the current line to find the first non-empty line
    -- of the current logical block. This block starts after an empty line or at the beginning of the file.
    while block_start_line > 1 do
        local prev_line_content =
            vim.api.nvim_buf_get_lines(bufnr, block_start_line - 2, block_start_line - 1, false)[1]
        if trim_string(prev_line_content) == "" then
            break -- Found an empty line above, so the block starts here (or on the current line).
        end
        block_start_line = block_start_line - 1
    end

    -- --- Find the effective end of the current *entire block* (filename + query) ---
    -- Iterate downwards from the current line to find the last non-empty line
    -- of the current logical block. This block ends before an empty line or at the end of the file.
    while block_end_line < total_lines do
        local next_line_content = vim.api.nvim_buf_get_lines(bufnr, block_end_line, block_end_line + 1, false)[1]
        if trim_string(next_line_content) == "" then
            break -- Found an empty line below, so the block ends on the current line.
        end
        block_end_line = block_end_line + 1
    end

    -- Get all lines for the identified block (including filename and query lines)
    -- nvim_buf_get_lines uses 0-indexed start and exclusive end.
    local raw_block_lines = vim.api.nvim_buf_get_lines(bufnr, block_start_line - 1, block_end_line, false)

    local filename = ""
    local query_lines = {}
    local found_first_non_empty = false

    -- Iterate through the raw block lines to separate filename and query
    for _, line in ipairs(raw_block_lines) do
        local trimmed_line = trim_string(line)
        if trimmed_line ~= "" then
            if not found_first_non_empty then
                -- The very first non-empty line in the block is considered the filename
                if string.find(trimmed_line, "file ") or string.find(trimmed_line, "File ") then
                    filename = removeCaseInsensitivePrefix(trimmed_line, "file ")
                else
                    -- Subsequent non-empty lines are part of the query
                    table.insert(query_lines, trimmed_line)
                end
                found_first_non_empty = true
            else
                -- Subsequent non-empty lines are part of the query
                table.insert(query_lines, trimmed_line)
            end
        end
    end

    local query_text = table.concat(query_lines, "\n")

    -- Store the retrieved data in global variables for easy access from Neovim
    vim.g.LastRetrievedFilename = filename
    vim.g.LastRetrievedQuery = query_text

    return { filename = filename, query = query_text }
end

-- Expose the module
return M
