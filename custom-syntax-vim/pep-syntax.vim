" Vim syntax file
" Language: Pep8
" Maintainer: Brian Normant
" Latest Revision: 19 September 2024

syntax case ignore
" literals
syntax region String start=/"/ skip=/\\"/ end=/"/
syntax region Character start=/'/ skip=/\\'/ end=/'/
syntax match Special /\\[nrt\\"]/ contained
syntax match Special /\\0x[0-9A-Fa-f]+/ contained
" numbers
syntax match Number /\v\d+/
syntax match Number /\v0x[0-9a-fA-F]+/
syntax match Number /\v0b[01]+/
" keyword
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
syntax match PreProc /\v\.\w+/
syntax match Identifier /[a-f_]+:/
syntax match Constant /\v,\zs[idxsf]{1,3}/
" comments
syntax match Comment /;;.*/
syntax match Todo /;:.*/
syntax match Error /;[^;:].*/

syntax case match
