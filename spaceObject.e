OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros','space','gadgets/layout'

  MODULE '*reactionObject','*reactionForm'


EXPORT OBJECT spaceObject OF reactionObject
ENDOBJECT

EXPORT PROC createPreviewObject(scr) OF spaceObject
  self.previewObject:=SpaceObject, SpaceEnd

  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

  self.makePreviewChildAttrs(0)
ENDPROC

EXPORT PROC create(parent) OF spaceObject
  self.type:=TYPE_SPACE
  SUPER self.create(parent)

  self.libsused:=[TYPE_SPACE]
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
