return {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    dependencies = 'nvim-lua/plenary.nvim',

    keys = {
        { '-', mode = { 'n', 'v' }, '<cmd>Yazi<cr>', desc = 'Open yazi at the current file' },
        { '<leader>e', '<cmd>Yazi cwd<cr>', desc = "Open the file manager in nvim's working directory" },
    },

    opts = {
        open_for_directories = true,
        floating_window_scaling_factor = 0.8,
        yazi_floating_window_border = 'none',
    },
}
