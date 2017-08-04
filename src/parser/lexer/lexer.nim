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

proc error(msg: string, offset: int = 0) =
  position += 1

  while source.find("\n", position) != position and position < len(source):
    line.add(source[position])

    position += 1
  
  column -= len(line)
  line = line.strip(trailing = false)
  column += len(line)
  line = line.strip()
  
  var rowString = strutils.intToStr(row)

  echo "Error:"
  
  echo rowString, " | ", line
  echo strutils.repeat('~', len(rowString) + column + offset + 2), '^'
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
  
  result = Token(id: ttEof, row: row, column: column, value: "")
  
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
      of "true", "false":
        result.id = ttBoolean
      of "u8", "i8", "u16", "i16", "u32", "i32", "f32", "f64", "usize", "isize":
        result.id = ttType
      of "struct":
        result.id = ttStruct
      of "func":
        result.id = ttFunc
      of "if":
        result.id = ttIf
      of "match":
        result.id = ttMatch
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
    result.value.add(character)

    if character == '0':
      advance()

      if character == 'b':
        advance()

        result.id = ttBinaryInteger
        
        result.value = ""

        if character != '0' and character != '1':
          error("expected a binary digit after `0b`")

        while character in {'0', '1', '_'}:
          if character != '_':
            result.value.add(character)

          advance()

        if character == '.':
          result.value.add(character)

          advance()

          if character in {'0', '1'}:
            result.id = ttBinaryNumber
            
            while character in {'0', '1'}:
              result.value.add(character)

              advance()
          else:
            error("expected a binary digit after the dot")

        return
      elif character == 'x':
        advance()

        result.id = ttHexInteger

        result.value = ""
        
        if not character.isDigit() and not (character in {'a'..'f', 'A'..'F'}):
          error("expected a hexadecimal digit after `0x`")

        while character.isDigit() or character in {'a'..'f', 'A'..'F', '_'}:
          if character != '_':
            result.value.add(character)

          advance()

        if character == '.':
          result.value.add(character)

          advance()

          if character.isDigit() or character in {'a'..'f', 'A'..'F', '_'}:
            result.id = ttHexNumber

            while character.isDigit() or character in {'a'..'f', 'A'..'F', '_'}:
              result.value.add(character)

              advance()
          else:
            error("expected a hexadecimal digit after the dot")
        
        return
    else:
      advance()
     
    while character.isDigit() or character == '_':
      if character != '_':
        result.value.add(character)

      advance()
    
    result.id = ttInteger

    if character == '.':
      result.id = ttNumber

      result.value.add(character)
      
      advance()
      
      if character.isDigit():
        while character.isDigit() or character == '_':
          if character != '_':
            result.value.add(character)
          
          advance()
      else:
        error("expected digit after dot")

    return
  
  case character:
    of '_':
      advance()

      result.id = ttBlank
      result.value = "_"
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
      
      if character.isDigit():
        error("expected digit before dot", -1)
      
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
      
      case character:
        of '=':
          advance()

          result.id = ttSlashAssign
          result.value = "/="
        of '/':
          advance()

          while source.find("\n", position) != position:
            advance()

          if source.find("\n", position) == position:
            advance()

          result = getToken()
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
          
          if character == '=':
            advance()

            result.id = ttShiftLeftAssign
            result.value = "<<="
          else:
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
          
          if character == '=':
            advance()

            result.id = ttShiftRightAssign
            result.value = ">>="
          else:          
            result.id = ttShiftRight
            result.value = ">>"
        else:
          result.id = ttGreater
          result.value = ">"
    of '&':
      advance()
      
      case character:
        of '=':
          advance()

          result.id = ttBitwiseAndAssign
          result.value = "&="
        of '&':
          advance()

          result.id = ttLogicalAnd
          result.value = "&&"
        else:
          result.id = ttBitwiseAnd
          result.value = "&"
    of '|':
      advance()
      
      case character:
        of '=':
          advance()

          result.id = ttBitwiseOrAssign
          result.value = "|="
        of '|':
          advance()

          result.id = ttLogicalOr
          result.value = "||"
        else:
          result.id = ttBitwiseOr
          result.value = "|"
    of '^':
      advance()
      
      if character == '=':
        advance()

        result.id = ttBitwiseXorAssign
        result.value = "^="
      else:
        result.id = ttBitwiseXor
        result.value = "^"
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
  var
    token = getToken()
    tokens = @[token] 
  
  while token.id != ttEof:
    token = getToken()

    tokens.add(token)
  
  for t in tokens:
    echo t.id, " ", t.value

proc init*(newSource: string) =
  line = ""
  row = 1
  column = 1
  source = newSource
  position = 0
  character = source[0]

  line.add(character)
