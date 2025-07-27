-- Colorscheme (#colorscheme)
return {
    'RRethy/base16-nvim',
    priority = 1000,
    config = function()
        require('base16-colorscheme').setup {
            -- Grayscale
            base00 = '#101010',
            base01 = '#252525',
            base02 = '#464646',
            base03 = '#525252',
            base04 = '#ababab',
            base05 = '#b9b9b9',
            base06 = '#e3e3e3',
            base07 = '#f7f7f7',

            -- Dragon
            base08 = '#c4746e',
            base09 = '#e46876',
            base0A = '#c4b28a',
            base0B = '#8a9a7b',
            base0C = '#8ea4a2',
            base0D = '#8ba4b0',
            base0E = '#a292a3',
            base0F = '#7aa89f',
        }
    end,
}
