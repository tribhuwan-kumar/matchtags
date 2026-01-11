# Matchtags

## Highlights matching html/xml tags in Neovim

<img width="956" height="227" alt="image" src="https://github.com/user-attachments/assets/15c89c13-3fb2-4139-b08a-fe41c633cad7" />

_can easily handle large files_


#### Installation using vimplug
```vim
Plug 'tribhuwan-kumar/matchtags'
```

#### Enable or disable:
```vim
let g:load_matchtags = 1 or 0
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
