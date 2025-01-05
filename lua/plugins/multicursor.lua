return {
    "jake-stewart/multicursor.nvim",
    keys = {
        "<M-up>",
        "<M-down>",
        "<leader>cc",
        "<leader>cn",
        "<leader>cN",
        "<leader>cA",
    },
    config = function()
        local mc = require("multicursor-nvim")

        mc.setup()

        local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        set({ "n", "v" }, "<M-up>", function()
            mc.lineAddCursor(-1)
        end)
        set({ "n", "v" }, "<M-down>", function()
            mc.lineAddCursor(1)
        end)
        set({ "n", "v" }, "<up>", function()
            mc.lineSkipCursor(-1)
        end)
        set({ "n", "v" }, "<down>", function()
            mc.lineSkipCursor(1)
        end)

        -- Add or skip adding a new cursor by matching word/selection
        set({ "n", "v" }, "<leader>cn", function()
            mc.matchAddCursor(1)
        end, { desc = "matchAddCursor[1]" })
        set({ "n", "v" }, "<leader>cs", function()
            mc.matchSkipCursor(1)
        end, { desc = "matchSkipCursor[1]" })
        set({ "n", "v" }, "<leader>cN", function()
            mc.matchAddCursor(-1)
        end, { desc = "matchAddCursor[-1]" })
        set({ "n", "v" }, "<leader>cS", function()
            mc.matchSkipCursor(-1)
        end, { desc = "matchSkipCursor[-1]" })

        -- Add all matches in the document
        set({ "n", "v" }, "<leader>cA", mc.matchAllAddCursors, { desc = "matchAllAddCursors" })

        -- You can also add cursors with any motion you prefer:
        set("n", "<leader>cc", function()
            mc.addCursor()
        end, { desc = "addCursor" })
        -- set("n", "<leader><right>", function()
        --     mc.skipCursor("w")
        -- end)

        -- Rotate the main cursor.
        set({ "n", "v" }, "<left>", mc.nextCursor)
        set({ "n", "v" }, "<right>", mc.prevCursor)

        -- Delete the main cursor.
        set({ "n", "v" }, "<leader>cd", mc.deleteCursor, { desc = "deleteCursor" })

        -- Add and remove cursors with control + left click.
        set("n", "<c-leftmouse>", mc.handleMouse)

        -- Easy way to add and remove cursors using the main cursor.
        set({ "n", "v" }, "<c-q>", mc.toggleCursor)

        -- Clone every cursor and disable the originals.
        -- set({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

        set("n", "<esc>", function()
            if not mc.cursorsEnabled() then
                mc.enableCursors()
            elseif mc.hasCursors() then
                mc.clearCursors()
            else
                -- Default <esc> handler.
            end
        end)

        -- bring back cursors if you accidentally clear them
        set("n", "<leader>cr", mc.restoreCursors, { desc = "restoreCursors" })

        -- Align cursor columns.
        set("n", "<leader>ca", mc.alignCursors, { desc = "alignCursors" })

        -- Split visual selections by regex.
        set("v", "S", mc.splitCursors)

        -- Append/insert for each line of visual selections.
        set("v", "I", mc.insertVisual)
        set("v", "A", mc.appendVisual)

        -- match new cursors within visual selections by regex.
        set("v", "M", mc.matchCursors)

        -- Rotate visual selection contents.
        set("v", "<leader>ct", function()
            mc.transposeCursors(1)
        end, { desc = "transposeCursors[1]" })
        set("v", "<leader>cT", function()
            mc.transposeCursors(-1)
        end, { desc = "transposeCursors[-1]" })

        -- Jumplist support
        set({ "v", "n" }, "<c-i>", mc.jumpForward)
        set({ "v", "n" }, "<c-o>", mc.jumpBackward)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { link = "Cursor" })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn" })
        hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
}
