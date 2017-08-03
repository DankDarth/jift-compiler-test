
type
  TypeId = enum
    tU8, tU16, tU32, tU64
    tI8, tI16, tI32, tI64
    tF32, tF64,
    tUSize, tISize,
    tGeneric
  
  BaseType = ref object of RootObj
  
  SingularType = ref object of BaseType
    typeId: TypeId

proc toString[T](gen: T): string


