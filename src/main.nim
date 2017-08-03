import streams

import parser/parser
import parser/lexer/lexer

var file = newFileStream("input.txt", fmRead)
var source = ""

if not isNil(file):
  source = file.readAll()

lexer.init(source)
lexer.printTokens()
