OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros','space','gadgets/layout'

  MODULE '*reactionObject','*reactionForm'


EXPORT OBJECT spaceObject OF reactionObject
ENDOBJECT

EXPORT PROC createPreviewObject(scr) OF spaceObject
  self.previewObject:=SpaceObject, SpaceEnd
  self.previewChildAttrs:=[
    LAYOUT_MODIFYCHILD, self.previewObject,
    CHILD_NOMINALSIZE, self.nominalSize,
    CHILD_NODISPOSE, FALSE,
    CHILD_MINWIDTH, self.minWidth,
    CHILD_MINHEIGHT, self.minHeight,
    CHILD_MAXWIDTH, self.maxWidth,
    CHILD_MAXHEIGHT, self.maxHeight,
    CHILD_WEIGHTEDWIDTH, self.weightedWidth,
    CHILD_WEIGHTEDHEIGHT,self.weightedHeight,
    CHILD_SCALEWIDTH, self.scaleWidth,
    CHILD_SCALEHEIGHT, self.scaleHeight,
    TAG_END]  
ENDPROC

EXPORT PROC create(parent) OF spaceObject
  self.type:=TYPE_SPACE
  SUPER self.create(parent)

  self.libused:=LIB_SPACE
ENDPROC

EXPORT PROC editSettings() OF spaceObject IS TRUE

EXPORT PROC serialiseData() OF spaceObject IS
[
0,0,0
]

EXPORT PROC getTypeName() OF spaceObject
  RETURN 'Space'
ENDPROC

EXPORT PROC createSpaceObject(parent)
  DEF space:PTR TO spaceObject
  
  NEW space.create(parent)
ENDPROC space
