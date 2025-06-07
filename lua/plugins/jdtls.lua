return {
    {
        "mfussenegger/nvim-jdtls",
        cond = not vim.g.vscode,
        ft = "java",
    },
    {
        "JavaHello/spring-boot.nvim",
        cond = not vim.g.vscode,
        ft = "java",
        dependencies = {
            "mfussenegger/nvim-jdtls",
        },
    },
}
