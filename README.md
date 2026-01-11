# Matchtags

## Highlights matching html/xml tags in Neovim:

<img width="895" height="436" alt="image" src="https://github.com/user-attachments/assets/7adb90df-44fd-4f2b-9377-0a74bcf6efb2" />

_can easily handle large files_

#### Installation Using lazy.nvim:
```lua
return {
  "tribhuwan-kumar/matchtags",
  init = function()
    vim.g.load_matchtags = 1
    vim.g.matchtags_filetypes = {
      html = 1,
      xhtml = 1,
      xml = 1,
      jinja = 1,
      php = 1,
      vue = 1,
      svelte = 1,
      javascriptreact = 1,
      typescriptreact = 1,
      eruby = 1,
    }
  end,
}
```

#### Installation using vimplug:
```vim
Plug 'tribhuwan-kumar/matchtags'
```

#### Enable or disable:
```vim
let g:load_matchtags = 1
```

#### Define filetypes of highlights:
```vim
  let g:matchtags_filetypes = {
        \ 'html' : 1,
        \ 'xhtml' : 1,
        \ 'xml' : 1,
        \ 'jinja' : 1,
        \ 'php' : 1,
        \ 'vue' : 1,
        \ 'svelte' : 1,
        \ 'javascriptreact' : 1,
        \ 'typescriptreact' : 1,
        \ 'eruby': 1,
        \ }
```
