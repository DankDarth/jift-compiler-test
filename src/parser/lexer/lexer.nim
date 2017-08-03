import strutils
import system

from token import TokenType
from token import Token


var
  line: string
  row: int
  column: int
  source: string
  position: int
  character: char

proc error(msg: string) =
  position += 1

  while source.find("\n", position) != position and position < len(source):
    line.add(source[position])

    position += 1
          
  var rowString = strutils.intToStr(row)

  echo "Error:"
  
  echo rowString, " | ", line
  echo strutils.repeat('~', len(rowString) + column + 2), '^'
  echo msg

  quit()

proc advance() =
  if source.find("\n", position) == position:
    line = ""
    row += 1
    column = 0
  
  position += 1
  column += 1

  if position >= len(source):
    character = cast[char](0)
  else:
    character = source[position]
    
    if source.find("\n", position) != position:
      line.add(character)
  
proc getToken(): Token =
  while character in [' ', '\t']:
    advance()
  
  result = Token(id: ttEof, row: 0, column: 0, value: "")
  
  if source.find("\n", position) == position:
    result.id = ttLine

    position += len("\n")

    if position >= len(source):
      character = cast[char](0)
    else:
      character = source[position]

    return
  
  if character in strutils.Letters:
    result.value.add(character)
    
    advance()

    while character.isAlphaNumeric() or character == '_':
      result.value.add(character)
      
      advance()
    
    case result.value:
      of "u8", "i8", "u16", "i16", "u32", "i32", "f32", "f64", "usize", "isize":
        result.id = ttType
      of "struct":
        result.id = ttStruct
      of "func":
        result.id = ttFunc
      of "if":
        result.id = ttIf
      of "for":
        result.id = ttFor
      of "while":
        result.id = ttWhile
      of "loop":
        result.id = ttLoop
      of "break":
        result.id = ttBreak
      of "continue":
        result.id = ttContinue
      of "return":
        result.id = ttReturn
      else:
        result.id = ttIdentifier

    return
    
  if character.isDigit():
    while character.isDigit():
      result.value.add(character)

      advance()
    
    result.id = ttInteger

    if character == '.':
      result.id = ttNumber

      result.value.add(character)
      
      advance()
      
      if character.isDigit():
        while character.isDigit():
          result.value.add(character)
          
          advance()
      else:
        error("expected digit after dot")

    return
  
  case character:
    of '[':
      advance()
      
      result.id = ttLeftSquare
      result.value = "["
    of ']':
      advance()
      
      result.id = ttRightSquare
      result.value = "]"
    of '{':
      advance()

      result.id = ttLeftCurly
      result.value = "{"
    of '}':
      advance()

      result.id = ttRightCurly
      result.value = "}"
    of '(':
      advance()

      result.id = ttLeftCurly
      result.value = "("
    of ')':
      advance()

      result.id = ttRightCurly
      result.value = ")"
    of ',':
      advance()

      result.id = ttComma
      result.value = ","
    of '.':
      advance()

      result.id = ttDot
      result.value = "."
    of ':':
      advance()

      if character == '=':
        advance()

        result.id = ttInfer
        result.value = ":="
      else:
        result.id = ttColon
        result.value = ":"
    of '+':
      advance()

      if character == '=':
        advance()

        result.id = ttPlusAssign
        result.value = "+="
      else:
        result.id = ttPlus
        result.value = "+"
    of '-':
      advance()
      
      case character:
        of '>':
          advance()
          
          result.id = ttTo
          result.value = "->"
        of '=':
          advance()

          result.id = ttMinusAssign
          result.value = "-="
        else:
          result.id = ttMinus
          result.value = "-"
    of '*':
      advance()
      
      if character == '=':
        advance()

        result.id = ttAsteriskAssign
        result.value = "*="
      else:
        result.id = ttAsterisk
        result.value = "*"
    of '/':
      advance()
      
      if character == '=':
        advance()
        
        result.id = ttSlashAssign
        result.value = "/="
      else:
        result.id = ttSlash
        result.value = "/"
    of '%':
      advance()
      
      if character == '%':
        advance()

        result.id = ttPercentAssign
        result.value = "%="
      else:
        result.id = ttPercent
        result.value = "%"
    of '<':
      advance()
      
      case character:
        of '=':
          advance()

          result.id = ttLessEquals
          result.value = "<="
        of '<':
          advance()

          result.id = ttShiftLeft
          result.value = "<<"
        else:
          result.id = ttLess
          result.value = "<"
    of '>':
      advance()
      
      case character:
        of '=':
          advance()

          result.id = ttGreaterEquals
          result.value = ">="
        of '>':
          advance()

          result.id = ttShiftRight
          result.value = ">>"
        else:
          result.id = ttGreater
          result.value = ">"
    of '=':
      advance()

      if character == '=':
        advance()

        result.id = ttEquals
        result.value = "=="
      else:
        result.id = ttAssign
        result.value = "="
    of '!':
      advance()

      if character == '=':
        advance()

        result.id = ttNotEquals
        result.value = "!="
      else:
        result.id = ttInvert
        result.value = "!"
    else:
      return

proc printTokens*() =
  var token = getToken()
  
  while token.id != ttEof:
    echo token.id, " ", token.value

    token = getToken()
  
  echo token.id, " ", token.value

proc init*(newSource: string) =
  line = ""
  row = 1
  column = 1
  source = newSource
  position = 0
  character = source[0]

  line.add(character)
