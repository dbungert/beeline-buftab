" vim: sw=8 ts=8 noet :

let s:hlstart = '%#TabLineSel#'
let s:hlend = '%#TabLine#'
let s:hllen = len(s:hlstart.s:hlend)

" Enumerate titles of buffers, and highlight title of current buffer
" Returns [list of titles, index in list of current buffer]
" current buffer index uses 1 for first item in list
function! s:enum_titles_w_highlight()
	let titles = []
	let idx = 1
	let cur = -1
	for b in range(1, bufnr("$"))
		if !buflisted(b)
			continue
		endif

		let title = pathshorten(bufname(b))

		if empty(title)
			let title = '[special]'
		endif

		if bufnr('%') == b
			let cur = idx
			let title = s:hlstart.title.s:hlend
		endif
		call add(titles, title)
		let idx = idx + 1
	endfor
	return [titles, cur]
endfunction

" Basic algorithm, falls flat when there are too many tabs.
function! beeline#buftab#tabline()
	return join(s:enum_titles_w_highlight()[0])
endfunction

" Drop tabs from view if too many.
function! beeline#buftab#tablinetrim()
	let [titles, cur] = s:enum_titles_w_highlight()
	let sfront = ''
	let sback = ''

	let tabline = join(titles)
	while strwidth(tabline) - s:hllen > winwidth(0)
		" remove tabs if line is too wide
		let tabline = ''
		if cur > 2 || (cur == len(titles) && cur > 1)
			" Start by removing tabs from the front if we are the
			" 3rd tab or later.  Also remove from front if current
			" tab is the last in the list.
			call remove(titles, 0)
			let cur = cur - 1
			let sfront = '< '
		elseif cur < len(titles)
			" Once we've removed all tabs we can from the front,
			" remove from the back.
			call remove(titles, -1)
			let sback = ' >'
		else
			" It's just us.  Nobody else to prune.
			" Or some defective behavior.
			return join(titles)
		endif

		let tabline = sfront . join(titles) . sback
	endwhile

	return tabline
endfunction
