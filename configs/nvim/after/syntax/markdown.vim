if exists('b:current_syntax')
  unlet b:current_syntax
endif

" math zones
syn include @tex syntax/tex.vim
syn region markdownMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex,@NoSpell keepend
syn region markdownMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex,@NoSpell keepend

" %% comment
syn region markdownComment start="\\\@<!%%" end="%%" skip="\\%" contains=@Comment,@Spell keepend
highlight link markdownComment Comment

let b:current_syntax = 'markdown'
