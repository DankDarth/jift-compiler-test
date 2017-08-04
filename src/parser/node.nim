import lists

from lexer/token import TokenType
from lexer/token import Token

from type import BaseType

type
  BaseNode* = ref object of RootObj
    token*: Token

  FactorNode* = ref object of BaseNode
    typeNode*: BaseType 

method toString*(self: BaseNode): string {.base.} = ""
