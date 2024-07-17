return {
    -- JQ utility
    event = "VeryLazy",
    dir = vim.fn.expand("./../jq_utils.lua"),
    config = function()
        require("local.jq")
    end
}
