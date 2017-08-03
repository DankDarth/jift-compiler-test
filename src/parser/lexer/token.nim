

type
  TokenType* = enum
    ttIdentifier,
    ttInteger,
    ttNumber,
    ttLeftSquare, ttRightSquare,
    ttLeftCurly, ttRightCurly,
    ttLeftBracket, ttRightBracket,
    ttComma,
    ttBoolean,
    ttText,
    ttInvert,
    ttPlus, ttMinus, ttAsterisk, ttSlash, ttPercent,
    ttShiftLeft, ttShiftRight,
    ttLess, ttGreater, ttLessEquals, ttGreaterEquals, ttEquals, ttNotEquals,
    ttInfer, ttAssign,
    ttPlusAssign, ttMinusAssign, ttAsteriskAssign, ttSlashAssign, ttPercentAssign,
    ttColon, ttDot, ttTo
    ttType,
    ttFunc, ttStruct,
    ttIf, ttFor, ttWhile, ttLoop,
    ttBreak, ttContinue, ttReturn,
    ttLine,
    ttEof

  Token* = object
    id*: TokenType
    row*: int
    column*: int
    value*: string
