

type
  TokenType* = enum
    ttIdentifier,
    ttBlank,
    ttBinaryInteger, ttInteger, ttHexInteger,
    ttBinaryNumber, ttNumber, ttHexNumber,
    ttLeftSquare, ttRightSquare,
    ttLeftCurly, ttRightCurly,
    ttLeftBracket, ttRightBracket,
    ttComma,
    ttBoolean,
    ttText,
    ttInvert,
    ttPlus, ttMinus, ttAsterisk, ttSlash, ttPercent,
    ttShiftLeft, ttShiftRight,
    ttBitwiseAnd, ttBitwiseOr, ttBitwiseXor,
    ttLogicalAnd, ttLogicalOr,
    ttLess, ttGreater, ttLessEquals, ttGreaterEquals, ttEquals, ttNotEquals,
    ttInfer, ttAssign,
    ttPlusAssign, ttMinusAssign, ttAsteriskAssign, ttSlashAssign, ttPercentAssign,
    ttShiftLeftAssign, ttShiftRightAssign,
    ttBitwiseAndAssign, ttBitwiseOrAssign, ttBitwiseXorAssign,
    ttColon, ttDot, ttTo
    ttType,
    ttFunc, ttStruct,
    ttIf, ttMatch, ttFor, ttWhile, ttLoop,
    ttBreak, ttContinue, ttReturn,
    ttLine,
    ttEof

  Token* = object
    id*: TokenType
    row*: int
    column*: int
    value*: string
