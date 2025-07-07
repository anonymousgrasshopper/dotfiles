if exists('b:current_syntax')
  unlet b:current_syntax
endif

syn include @tex syntax/tex.vim
syn region markdownMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex,@NoSpell keepend
syn region markdownMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex,@NoSpell keepend

let b:current_syntax = 'markdown'
