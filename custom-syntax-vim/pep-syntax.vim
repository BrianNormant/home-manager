" Vim syntax file
" Language: Pep8
" Maintainer: Brian Normant
" Latest Revision: 19 September 2024

" literals
syntax region String start=/"/ skip=/\\"/ end=/"/ contains=pepEscaped
syntax region Character start=/'/ skip=/\\'/ end=/'/ contains=pepEscaped
syntax match pepEscaped /\\[nrtx\\"]/ display
syntax match pepEscaped /\\0\?x[0-9A-Fa-f]\+/ display
" numbers
syntax match Number "\([a-zA-Z_\.]\+\d*\)\@<!\d\+"
syntax match Number "\([a-zA-Z_\.]\+\d*\)\@<!0x[0-9a-fA-F]\+"
syntax match Number "\([a-zA-Z_\.]\+\d*\)\@<!0b[01]\+"
" keyword

syntax case ignore
syntax keyword Type lda ldx ldbytea ldbytex
syntax keyword Type sta stx stbytea stbytex
syntax keyword Type adda addx addsp
syntax keyword Type suba subx subsp
syntax keyword Type nega anda ora
syntax keyword Type negx andx orx
syntax keyword Type asra asla asrx aslx
syntax keyword Type rora rola rorx rolx
syntax keyword Type charo stro deci
syntax keyword Type cpa cpx
syntax keyword Type br breq brnq brlt brgt
syntax keyword Type call ret stop
syntax keyword Type movspa movflga
syntax case match
syntax match PreProc /\v\.\w+/
syntax match Identifier /[a-z0-9A-Z_]\+:/
syntax match Constant /\v,\zs[idxsf]{1,3}/
" comments
syntax match Comment /;[^;:].*/
syntax match Error /;;.*/
syntax match Todo /;:.*/

hi def link pepEscaped	Special
