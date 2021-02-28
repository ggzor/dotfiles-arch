if !exists('g:vscode')

"" NightOwl config
function UseNightOwl()
  colorscheme night-owl
  let g:rainbow#blacklist = [248, 253, 10, 15, 222, 229, 74, 121]

  hi MatchParen guibg='#253b4e'
  hi ColorColumn guibg='#78808b'
  hi LineNr guibg=bg guifg='#354c60'
  hi CursorLineNR guifg='#88a2ba'
  hi NonText guifg='#253b4e'
  hi VertSplit guifg='#091f30'
  highlight EndOfBuffer guifg=bg guibg=bg

  " Better diff colors
  hi DiffAdd guifg=NONE guibg='#243b37'
  hi DiffChange guifg=NONE guibg='#243b37'
  hi DiffText guifg=NONE guibg='#476047'

  hi DiffOldAdd guifg=NONE guibg='#382430'
  hi DiffOldChange guifg=NONE guibg='#382430'
  hi DiffOldText guifg=NONE guibg='#6f323a'

  hi GitGutterAdd guifg='#9CCC65' guibg=NONE
  hi GitGutterChange guifg='#e2b93d' guibg=NONE
  hi GitGutterDelete guifg='#EF5350' guibg=NONE
  hi GitGutterChangeDeleteLine guifg='blue' guibg=NONE

  hi DiffDelete guifg='#00121f' guibg='#00121f'

  hi CursorLine guibg='#00121f'
  hi CursorColumn guibg=NONE guifg=NONE

  hi ShowMotion_CharSearchGroup gui=bold guibg=NONE guifg=red

  let g:lightline.colorscheme = 'nightowl'
  call RefreshLightline()
endfunction

"" Papercolor config
function UsePaperColorLight()
  set background=light
  colorscheme PaperColor
  let g:lightline.colorscheme = 'PaperColor'
  call RefreshLightline()
endfunction

function RefreshTheme()
  if g:theme == "nightowl"
      call UseNightOwl()
  endif
  if g:theme == "papercolorlight"
    call UsePaperColorLight()
  endif
  if g:theme == "tokyonight"
    let g:lightline.colorscheme = 'tokyonight'
    let g:palenight_terminal_italics=1
    let g:tokyonight_style = 'storm'
    colorscheme tokyonight
    call RefreshLightline()
  endif
endfunction

augroup zau-theme-custom
  autocmd!
  autocmd ColorScheme * call RefreshTheme()
augroup END

call RefreshTheme()


" Do not change foreground in visual mode
highlight Visual guifg=NONE ctermfg=NONE
endif

" Theme corrections
let s:violet = { "gui": "#c792ea" }
let s:purple = { "gui": "#c792ea" }
let s:yellow = { "gui": "#ecc48d" }
let s:blue = { "gui": "#82aaff" }
let s:white = { "gui": "#c792ea" }
let s:cyan = { "gui": "#7fdbca" }
let s:dark_yellow = { "gui": "#c792ea" }
let s:dark_red = { "gui": "#c792ea" }
let s:green = { "gui": "#addb67" }
let s:orange = { "gui": "#f78c6c" }
let s:red = { "gui": "#ef5350" }
let s:grey = { "gui": "#637777" }
let s:none = { "gui": "#d6deeb" }

" Foregrounds
let s:blue_fg = { "fg": s:blue }
let s:blue_fg_italic = { "fg": s:blue, "gui": "italic" }

let s:purple_fg = { "fg": s:purple }
let s:purple_fg_italic = { "fg": s:purple , "gui": "italic" }

let s:orange_fg = { "fg": s:orange }
let s:orange_fg_italic = { "fg": s:orange, "gui": "italic" }

let s:cyan_fg = { "fg": s:cyan }
let s:cyan_fg_italic = { "fg": s:cyan, "gui": "italic" }

let s:red_fg = { "fg": s:red }
let s:red_fg_italic = { "fg": s:red, "gui": "italic" }

let s:green_fg = { "fg": s:green }
let s:green_fg_italic = { "fg": s:green, "gui": "italic" }

let s:yellow_fg = { "fg": s:yellow }
let s:yellow_fg_italic = { "fg": s:yellow, "gui": "italic" }

" Combinations
" TODO: Make something
let s:purple_25 = { "gui": "#333558" }

function! s:h(group, style)
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
    \ "gui="     (has_key(a:style, "gui")   ? a:style.gui      : "NONE")
    "\ "ctermfg=" . l:ctermfg
    "\ "ctermbg=" . l:ctermbg
    "\ "cterm="   (has_key(a:style, "cterm") ? a:style.cterm    : "NONE")
endfunction

call s:h("HighlightedyankRegion", { "bg": { "gui": "#3c4241" } })

" Defaults
call s:h("Constant", s:orange_fg)
call s:h("String", s:yellow_fg)
call s:h("Character", s:orange_fg)
call s:h("Number", s:orange_fg)
call s:h("Boolean", s:red_fg)
call s:h("Float", s:orange_fg)

call s:h("Identifier", s:cyan_fg)
call s:h("Function", s:cyan_fg_italic)

call s:h("Statement", s:purple_fg_italic)
call s:h("Conditional", s:purple_fg_italic)
call s:h("Repeat", s:purple_fg_italic)
call s:h("Label", s:purple_fg_italic)
call s:h("Operator", s:purple_fg)
call s:h("Keyword", s:purple_fg_italic)
call s:h("Exception", s:purple_fg_italic)

call s:h("PreProc", s:purple_fg_italic)
call s:h("Include", s:purple_fg_italic)
call s:h("Define", s:purple_fg_italic)
call s:h("Macro", s:purple_fg_italic)
call s:h("PreCondit", s:purple_fg_italic)

call s:h("Type", s:purple_fg_italic)
call s:h("StorageClass", s:purple_fg_italic)
call s:h("Structure", s:purple_fg_italic)
call s:h("Typedef", s:purple_fg_italic)

call s:h("Special", s:orange_fg)
call s:h("SpecialChar", s:orange_fg)
call s:h("Tag", s:orange_fg)
call s:h("Delimiter", s:orange_fg)
call s:h("SpecialComment", { "fg": s:purple, "gui":"bold" })
call s:h("Debug", s:purple_fg_italic)

call s:h("Todo", { "fg": s:purple, "bg": s:purple_25, "gui":"bold" })

call s:h("Search", { "bg": { "gui": "#2c476f" } })
call s:h("IncSearch", { "gui": "bold", "bg": { "gui": "#6285c9" } })

" Idris
call s:h("idrisType", s:green_fg)
call s:h("idrisOperators", s:cyan_fg)

" JS
call s:h("jsAll", s:purple_fg)
call s:h("jsArguments", s:purple_fg)
call s:h("jsArrowFuncArgs", s:purple_fg)
call s:h("jsArrowFunction", s:purple_fg)
call s:h("jsAsyncKeyword", s:purple_fg_italic)
call s:h("jsBlock", s:purple_fg)
call s:h("jsBlockLabel", s:purple_fg)
call s:h("jsBlockLabelKey", s:purple_fg)
call s:h("jsBooleanFalse", { "fg": s:red })
call s:h("jsBooleanTrue", { "fg": s:red })
call s:h("jsBraces", { "fg": s:none })
call s:h("jsBracket", { "fg": s:none })
call s:h("jsBrackets", { "fg": s:none })
call s:h("jsBranch", { "fg": s:none })
call s:h("jsBuiltins", s:purple_fg)
call s:h("jsCatch", s:purple_fg)
call s:h("jsCharacter", s:purple_fg)
call s:h("jsClassBlock", s:purple_fg)
call s:h("jsClassBraces", { "fg": s:none })
call s:h("jsClassDefinition", { "fg": s:yellow })
call s:h("jsClassFuncName", { "fg": s:blue, "gui": "italic" })
call s:h("jsClassKeyword", s:purple_fg)
call s:h("jsClassMethodType", s:purple_fg_italic)
call s:h("jsClassNoise", s:purple_fg)
call s:h("jsClassProperty", { "fg": s:cyan })
call s:h("jsClassPropertyComputed", s:purple_fg)
call s:h("jsClassStringKey", s:purple_fg)
call s:h("jsClassValue", s:purple_fg)
call s:h("jsComment", { "fg": s:grey, "gui": "italic" })
call s:h("jsCommentClass", { "fg": s:grey, "gui": "italic" })
call s:h("jsCommentFunction", { "fg": s:grey, "gui": "italic" })
call s:h("jsCommentIfElse", { "fg": s:grey, "gui": "italic" })
call s:h("jsCommentRepeat", { "fg": s:grey, "gui": "italic" })
call s:h("jsCommentTodo", s:purple_fg)
call s:h("jsConditional", s:purple_fg_italic)
call s:h("jsCssStyles", s:purple_fg)
call s:h("jsDecorator", s:purple_fg)
call s:h("jsDecoratorFunction", s:purple_fg)
call s:h("jsDestructuringArray", s:purple_fg)
call s:h("jsDestructuringAssignment", s:purple_fg)
call s:h("jsDestructuringBlock", s:purple_fg)
call s:h("jsDestructuringBraces", { "fg": s:none })
call s:h("jsDestructuringNoise", s:purple_fg)
call s:h("jsDestructuringProperty", s:purple_fg)
call s:h("jsDestructuringPropertyComputed", s:purple_fg)
call s:h("jsDestructuringPropertyValue", s:purple_fg)
call s:h("jsDestructuringValue", s:purple_fg)
call s:h("jsDestructuringValueAssignment", s:purple_fg)
call s:h("jsDo", s:purple_fg)
call s:h("jsDomElemAttrs", s:purple_fg)
call s:h("jsDomElemFuncs", s:purple_fg)
call s:h("jsDomErrNo", { "fg": s:yellow })
call s:h("jsDomNodeConsts", s:purple_fg)
call s:h("jsDot", s:purple_fg)
call s:h("jsEnvComment", { "fg": s:grey, "gui": "italic" })
call s:h("jsError", s:purple_fg)
call s:h("jsException", s:purple_fg_italic)
call s:h("jsExceptions", { "fg": s:yellow })
call s:h("jsExport", s:purple_fg)
call s:h("jsExportDefault", s:purple_fg)
call s:h("jsExportDefaultGroup", s:purple_fg)
call s:h("jsExpression", s:purple_fg)
call s:h("jsExtendsKeyword", s:purple_fg_italic)
call s:h("jsFinally", s:purple_fg)
call s:h("jsFinallyBlock", s:purple_fg)
call s:h("jsFinallyBraces", { "fg": s:none })
call s:h("jsFloat", { "fg": s:orange })
call s:h("jsFlowArgumentDef", s:purple_fg)
call s:h("jsFlowClassDef", s:purple_fg)
call s:h("jsFlowClassFunctionGroup", s:purple_fg)
call s:h("jsFlowClassGroup", s:purple_fg)
call s:h("jsFlowDefinition", s:purple_fg)
call s:h("jsFlowFunctionGroup", s:purple_fg)
call s:h("jsFlowImportType", s:purple_fg)
call s:h("jsFlowReturn", s:purple_fg)
call s:h("jsFlowTypeKeyword", s:purple_fg)
call s:h("jsFlowTypeStatement", s:purple_fg)
call s:h("jsForAwait", s:purple_fg_italic)
call s:h("jsFrom", s:purple_fg)
call s:h("jsFuncArgCommas", s:purple_fg)
call s:h("jsFuncArgExpression", s:purple_fg)
call s:h("jsFuncArgOperator", s:purple_fg)
call s:h("jsFuncArgs", { "fg": s:none })
call s:h("jsFuncBlock", { "fg": s:none })
call s:h("jsFuncBraces", { "fg": s:none })
call s:h("jsFuncCall", { "fg": s:blue, "gui": "italic" })
call s:h("jsFuncName", { "fg": s:blue, "gui": "italic" })
call s:h("jsFuncParens", { "fg": s:none })
call s:h("jsFunction", s:purple_fg)
call s:h("jsFunctionKey", s:purple_fg)
call s:h("jsFutureKeys", s:purple_fg)
call s:h("jsGenerator", s:purple_fg)
call s:h("jsGlobalNodeObjects", { "fg": s:cyan, "gui": "italic" })
call s:h("jsGlobalObjects", { "fg": s:cyan, "gui": "italic" })
call s:h("jsHtmlElemAttrs", s:purple_fg)
call s:h("jsHtmlElemFuncs", s:purple_fg)
call s:h("jsHtmlEvents", s:purple_fg)
call s:h("jsIfElseBlock", s:purple_fg)
call s:h("jsIfElseBraces", { "fg": s:none })
call s:h("jsImport", s:purple_fg)
call s:h("jsLabel", s:purple_fg)
call s:h("jsModuleAs", s:purple_fg)
call s:h("jsModuleAsterisk", s:purple_fg)
call s:h("jsModuleBraces", { "fg": s:none })
call s:h("jsModuleComma", s:purple_fg)
call s:h("jsModuleGroup", s:purple_fg)
call s:h("jsModuleKeyword", s:purple_fg)
call s:h("jsNan", s:purple_fg)
call s:h("jsNoise", { "fg": s:none })
call s:h("jsNull", s:purple_fg)
call s:h("jsNumber", { "fg": s:orange })
call s:h("jsObject", s:purple_fg)
call s:h("jsObjectBraces", { "fg": s:none })
call s:h("jsObjectColon", s:purple_fg)
call s:h("jsObjectFuncName", s:purple_fg)
call s:h("jsObjectKey", s:purple_fg)
call s:h("jsObjectKeyComputed", s:purple_fg)
call s:h("jsObjectKeyString", s:purple_fg)
call s:h("jsObjectMethodType", s:purple_fg)
call s:h("jsObjectProp", { "fg": s:cyan })
call s:h("jsObjectSeparator", s:purple_fg)
call s:h("jsObjectShorthandProp", s:purple_fg)
call s:h("jsObjectStringKey", s:purple_fg)
call s:h("jsObjectValue", { "fg": s:none })
call s:h("jsOf", s:purple_fg)
call s:h("jsOperator", s:purple_fg)
call s:h("jsOperatorKeyword", { "fg": s:cyan })
call s:h("jsParen", { "fg": s:none })
call s:h("jsParenCatch", { "fg": s:none })
call s:h("jsParenDecorator", { "fg": s:none })
call s:h("jsParenIfElse", { "fg": s:none })
call s:h("jsParenRepeat", { "fg": s:none })
call s:h("jsParenSwitch", { "fg": s:none })
call s:h("jsParens", { "fg": s:none })
call s:h("jsParensCatch", { "fg": s:none })
call s:h("jsParensDecorator", { "fg": s:none })
call s:h("jsParensError", { "fg": s:none })
call s:h("jsParensIfElse", { "fg": s:none })
call s:h("jsParensRepeat", { "fg": s:none })
call s:h("jsParensSwitch", { "fg": s:none })
call s:h("jsPrototype", s:purple_fg)
call s:h("jsRegexpBackRef", s:purple_fg)
call s:h("jsRegexpBoundary", s:purple_fg)
call s:h("jsRegexpCharClass", s:purple_fg)
call s:h("jsRegexpGroup", s:purple_fg)
call s:h("jsRegexpMod", s:purple_fg)
call s:h("jsRegexpOr", s:purple_fg)
call s:h("jsRegexpQuantifier", s:purple_fg)
call s:h("jsRegexpSpecial", s:purple_fg)
call s:h("jsRegexpString", s:purple_fg)
call s:h("jsRepeat", s:purple_fg_italic)
call s:h("jsRepeatBlock", s:purple_fg)
call s:h("jsRepeatBraces", { "fg": s:none })
call s:h("jsRestExpression", s:purple_fg)
call s:h("jsRestOperator", s:purple_fg)
call s:h("jsReturn", s:purple_fg_italic)
call s:h("jsSpecial", s:purple_fg)
call s:h("jsSpreadExpression", s:purple_fg)
call s:h("jsSpreadOperator", s:purple_fg)
call s:h("jsStatement", s:purple_fg_italic)
call s:h("jsStorageClass", { "fg": s:purple})
call s:h("jsString", { "fg": s:yellow })
call s:h("jsSuper", s:purple_fg)
call s:h("jsSwitchBlock", s:purple_fg)
call s:h("jsSwitchBraces", { "fg": s:none })
call s:h("jsSwitchCase", s:purple_fg)
call s:h("jsSwitchColon", s:purple_fg)
call s:h("jsTaggedTemplate", s:purple_fg)
call s:h("jsTemplateBraces", { "fg": s:red })
call s:h("jsTemplateExpression", { "fg": s:none })
call s:h("jsTemplateString", { "fg": s:green })
call s:h("jsTernaryIf", s:purple_fg)
call s:h("jsTernaryIfOperator", s:purple_fg)
call s:h("jsThis", { "fg": s:cyan })
call s:h("jsTry", s:purple_fg)
call s:h("jsTryCatchBlock", s:purple_fg)
call s:h("jsTryCatchBraces", { "fg": s:none })
call s:h("jsUndefined", s:purple_fg)
call s:h("jsVariableDef", {})

" Personal extras
call s:h("jsExtendedClass", { "fg": s:green })

" Python
let g:python_highlight_all = 1

call s:h("pythonBuiltinFunc", s:green_fg)
call s:h("pythonBuiltinType", s:green_fg)
call s:h("pythonClassName", s:yellow_fg)
call s:h("pythonDecorator", s:green_fg)
call s:h("pythonDefine", s:purple_fg)
call s:h("pythonDot", s:purple_fg)
call s:h("pythonDottedName", s:green_fg)
call s:h("pythonFunctionCall", s:blue_fg_italic)
call s:h("pythonFunction", s:blue_fg_italic)
call s:h("pythonNone", s:red_fg)
call s:h("pythonStrInterpStartEnd", s:red_fg_italic)
call s:h("pythonStrPrefix", s:purple_fg_italic)

" Vimscript
call s:h("vimOption", s:)

" Rainbow parentheses
let g:rainbow_conf = {
  \	'guifgs': [s:orange.gui, s:violet.gui, s:green.gui],
  \	'separately': {
  \		'markdown': {
  \			'parentheses_options': 'containedin=markdownCode contained'
  \		},
  \		'haskell': {
  \			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold']
  \		},
  \		'vim': {
  \			'parentheses_options': 'containedin=vimFuncBody',
  \		},
  \		'perl': {
  \			'syn_name_prefix': 'perlBlockFoldRainbow',
  \		},
  \		'stylus': {
  \			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'],
  \		},
  \	}
  \}
