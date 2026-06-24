syntax match ScriptSpeaker '^[^:]\+:' contains=@NoSpell
highlight link ScriptSpeaker Identifier

syntax match ScriptDirection '^\[.*\]$'
highlight link ScriptDirection Comment
