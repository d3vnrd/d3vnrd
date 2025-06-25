<h3 align="center"> T|mpLab's Neovim Config </h3>

### Chapter 1: Lua - The foundation

- Write something about lua its origin, why it was chosen to be neovim config language
- Mechanism over policy? - Tjdevries
- Including some basic things one needs to know about lua programming language to start with Neovim

Variables, Functions, Loops, Data structures, Modules, etc.

<h4 align="center">Loops</h4>
<p></p>

```lua
local rand_list = { 'apple', 'orange', 'banana' }

for i = 1, #rand_list do
    print(i, rand_list[i])
end

--[[
    return:
     1 apple
     2 orange
     3 banana
--]]

for i, v in ipairs(rand_list) do -- think ipairs as a pair of index and value
    print(i, v)
end
-- return same as above

local rand_map = { apple = 10, orange = 5, banana = 3 }
for k, v in pairs(rand_map) do -- think pairs as a pair of key and value
    print(k, v)
end
```

<h4 align="center">Function</h4>

```lua
-- multiple return
local return_four_values = functions()
  return 1, 2, 3, 4
end

first, second, last = returns_four_values()
print(first)
print(second)
print(last)
-- the '4' did not get assigned hence it is discarded
```

<h4 align="center">Condition</h4>

```lua
local function action(x)
  if x then
    print("x is truthy") -- when x = true; 0; {}
  else
    print("x is falsey") -- when x = false; nil
```

<h4 align="center">Modules</h4>

There isn't anything special about modules, they are just simply files!

```lua
-- foo.lua
local M = {}
M.cool_func = functions() end
return M
```

```lua
-- bar.lua
local foo = require 'foo' -- assume foo.lua and bar.lua are in the same directories
foo.cool_func()
```

<h4 align="center">Metatables</h4>

A thing that contains information about a table

```lua
__add()
__index()
__newindex(self, key, value)
__call(self, ...)
```

### Chapter 2: Runtime path

See :helper rtp for more information

This repo use the following rtp:

- `after/ftplugin`
- `doc`
- `lua`
- `lsp`
- `plugin`

<h3>LSP</h3>

LSP stands for Language Server Protocol. It's a protocol that helpers editors
and language tooling communicate in a standardized fashion.

In general, you have a "server" which is some tool built to understand a particular
language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
(sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
processes that communicate with some "client" - in this case, Neovim!

LSP provides Neovim with features like: - Go to definition - Find references - Autocompletion - Symbol Search - and more!

Thus, Language Servers are external programs that must be installed separately from
Neovim. This is where `mason` and related plugins come into play.

If you're wondering about lsp vs treesitter, you can check out the wonderfully
and elegantly composed helper section, `:helper lsp-vs-treesitter`

Check `:helper lsp` for more information about the expected workflow with lsp

New Neovim version 0.11+ added new vim.lsp APIs that support natively LSP config, these include: - vim.lsp.config() - vim.lsp.enable() ~ Already have builtin FileType detection
