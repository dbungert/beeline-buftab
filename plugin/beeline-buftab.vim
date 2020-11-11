" tabline with trim if the number of tabs is too many for our window
set tabline=%!beeline#buftab#tablinetrim()

" simpler tabline algorithm that falls apart if window is not wide enough
" set tabline=%!beeline#buftab#tabline()
