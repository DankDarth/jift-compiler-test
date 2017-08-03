import os
import system
import streams

import parser/parser
import parser/lexer/lexer

if paramCount() < 1:
  echo "Error, missing input files."
  echo "jiftc [input]"
  
  quit()

var file = newFileStream(paramStr(1), fmRead)
var source = ""

if isNil(file):
  echo "Failed to read `", paramStr(1), "`."
  
  quit()
else:
  source = file.readAll()

lexer.init(source)
lexer.printTokens()
