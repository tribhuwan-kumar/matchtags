if exists("g:load_matchtags") || &cp
  finish
endif
let g:load_matchtags = 1

if !exists('g:matchtags_filetypes')
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
endif

highlight default link MatchTag MatchParen

let s:mta_match_id = 0

function! s:Cleanup()
  if s:mta_match_id > 0
    try
      call matchdelete(s:mta_match_id)
    catch /.*/
    endtry
    let s:mta_match_id = 0
  endif
endfunction

function! s:HighlightTags(locs)
  call s:Cleanup()
  if empty(a:locs) | return | endif

  let [l:open_ln, l:open_col, l:close_ln, l:close_col, l:tag_name] = a:locs

  let l:safe_tag = escape(l:tag_name, ' \.+*?^$[]')

  let l:pat_open = '\%' . l:open_ln . 'l\%' . l:open_col . 'c<\zs' . l:safe_tag . '\>\c'
  let l:pat_close = '\%' . l:close_ln . 'l\%' . l:close_col . 'c</\zs' . l:safe_tag . '\>\c'

  let l:full_pat = l:pat_open . '\|' . l:pat_close

  try
    let s:mta_match_id = matchadd('MatchTag', l:full_pat, 10)
  catch /.*/
  endtry
endfunction

function! s:GetEnclosingTags()
  let l:view = winsaveview()
  let l:original_cursor = getpos('.')
  let l:prev_open = search('<', 'bcnW', line('.'))
  let l:prev_close = search('>', 'bcnW', line('.'))

  if l:prev_open > 0 && l:prev_open > l:prev_close

    call cursor(line('.'), l:prev_open)
    let l:tag_start_text = getline('.')[col('.')-1 : ]

    call cursor(l:original_cursor[1], l:original_cursor[2])

    if l:tag_start_text =~? '^</'
      call cursor(line('.'), l:prev_open - 1)
    else
      call search('>', 'cW', line('.'))
      call cursor(line('.'), col('.') + 1)
    endif
  endif

  let l:stopline = max([1, line('.') - 2000])
  let l:maxline = line('w$') + 100
  let l:cursor_ln = l:original_cursor[1]
  let l:cursor_col = l:original_cursor[2]

  let l:tag_name_pat = '[a-zA-Z_:][a-zA-Z0-9_:.-]*'

  while 1
    let l:found_ln = search('<\zs' . l:tag_name_pat, 'bW', l:stopline)
    if l:found_ln == 0 | break | endif

    let l:tag_name_start_col = col('.')
    let l:tag_pos_col = l:tag_name_start_col - 1
    let l:tag_name = matchstr(getline('.'), '^'.l:tag_name_pat, col('.')-1)

    if l:tag_pos_col > 1
      let l:line_text = getline(l:found_ln)
      if l:line_text[l:tag_pos_col - 2] == '/'
        continue
      endif
    endif

    if synIDattr(synID(l:found_ln, l:tag_name_start_col, 0), "name") =~? 'comment\|string'
      continue
    endif

    call cursor(l:found_ln, l:tag_pos_col)

    let l:start_pat = '<\c' . l:tag_name . '\>'
    let l:end_pat = '</\c' . l:tag_name . '\_s*>'
    let l:esc_tag_name = escape(l:tag_name, '.')

    let l:skip_expr = 'synIDattr(synID(line("."), col("."), 0), "name") =~? "comment\\|string"'
    let l:skip_expr .= ' || getline(".")[col(".")-1 : ] =~? "^<'.l:esc_tag_name.'[^>]*/>"'
    let l:close_pos = searchpairpos(l:start_pat, '', l:end_pat, 'W', l:skip_expr, 0, l:maxline)

    if l:close_pos[0] > 0
      let l:c_ln = l:close_pos[0]
      let l:c_col = l:close_pos[1]
      call cursor(l:c_ln, l:c_col)
      let l:c_end_col = search('>', 'cnW', l:c_ln)
      if l:c_end_col == 0 | let l:c_end_col = 99999 | endif

      if (l:c_ln > l:cursor_ln) || (l:c_ln == l:cursor_ln && l:c_end_col >= l:cursor_col)
        call winrestview(l:view)
        return [l:found_ln, l:tag_pos_col, l:c_ln, l:c_col, l:tag_name]
      endif
    endif

    call cursor(l:found_ln, l:tag_pos_col)
  endwhile

  call winrestview(l:view)
  return []
endfunction

function! s:UpdateMatch()
  if !has_key(g:matchtags_filetypes, &ft)
    return
  endif
  let l:locs = s:GetEnclosingTags()
  call s:HighlightTags(l:locs)
endfunction

augroup MatchTagAlways
  autocmd!
  autocmd CursorMoved,CursorMovedI,BufEnter,WinEnter * call s:UpdateMatch()
  autocmd BufLeave * call s:Cleanup()
augroup END

