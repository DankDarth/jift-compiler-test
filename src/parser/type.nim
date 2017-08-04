import sequtils

type
  TypeId* = enum
    tU8, tU16, tU32, tU64
    tI8, tI16, tI32, tI64
    tF32, tF64,
    tUSize, tISize,
    tGeneric
  
  BaseType* = ref object of RootObj
  
  SingularType* = ref object of BaseType
    typeId*: TypeId

  ArrayType* = ref object of BaseType
    elements*: seq[BaseType]
  
  FunctionType* = ref object of BaseType
    inputs*: seq[BaseType]
    outputs*: seq[BaseType]
 
method toString*(self: BaseType): string {.base.} = ""
