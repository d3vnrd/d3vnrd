-- remember to include this line otherwise colors_name always return nil
vim.cmd.highlight 'clear'
if vim.fn.exists 'syntax_on' then
    vim.cmd.syntax 'reset'
end

vim.g.colors_name = 'eerie'

require('theme').create {
    base00 = '#101010',
    base01 = '#252525',
    base02 = '#b9b9b9',
    base0R = '#c4746e',
    base0G = '#8a9a7b',
    base0B = '#8ba4b0',
    base0Y = '#c4b28a',
    base0P = '#a292a3',
    base0C = '#8ea4a2',

    base10 = '#464646',
    base11 = '#525252',
    base12 = '#e3e3e3',
    base1R = '#E46876',
    base1G = '#87a987',
    base1B = '#7FB4CA',
    base1Y = '#E6C384',
    base1P = '#938AA9',
    base1C = '#7AA89F',
}
