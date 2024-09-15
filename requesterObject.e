OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string','gadgets/string',
        'chooser','gadgets/chooser',
        'gadgets/checkbox','checkbox',
        'gadgets/listbrowser','listbrowser',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec/lists','exec/nodes',
        'requester','classes/requester'

  MODULE '*reactionObject','*reactionForm','*sourcegen','*stringlist','*baseStreamer','*requesterItemObject'

EXPORT ENUM REQGAD_LIST, REQGAD_ADD, REQGAD_EDIT, REQGAD_DELETE, REQGAD_OK, REQGAD_CANCEL
CONST NUM_REQ_GADS=REQGAD_CANCEL+1

EXPORT OBJECT requesterObject OF reactionObject
ENDOBJECT

EXPORT PROC create(parent) OF requesterObject
  DEF strlist:PTR TO stringlist
  self.type:=TYPE_REQUESTER
  SUPER self.create(parent)
  AstrCopy(self.name,'')
  AstrCopy(self.ident,'Requesters')
ENDPROC

EXPORT PROC getTypeName() OF requesterObject
  RETURN 'Requester'
ENDPROC

EXPORT PROC allowChildren() OF requesterObject IS -1

EXPORT PROC serialiseData() OF requesterObject IS
[
  0,0,FIELDTYPE_CHAR    //dummy field since we dont have any
]

EXPORT PROC createRequesterObject(parent)
  DEF requester:PTR TO requesterObject
  
  NEW requester.create(parent)
ENDPROC requester


