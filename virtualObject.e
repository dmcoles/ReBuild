OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/virtual','virtual',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen'

EXPORT ENUM VIRTGAD_SCROLLER,
      VIRTGAD_OK, VIRTGAD_CHILD, VIRTGAD_CANCEL
      

CONST NUM_VIRTUAL_GADS=VIRTGAD_CANCEL+1

EXPORT OBJECT virtualObject OF reactionObject
  scroller:CHAR
ENDOBJECT

OBJECT virtualSettingsForm OF reactionForm
PRIVATE
  virtualObject:PTR TO virtualObject
ENDOBJECT

PROC create() OF virtualSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_VIRTUAL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_VIRTUAL_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Virtual Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 60,
    WA_WIDTH, 260,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 60,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
    WA_PUBSCREEN, 0,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,

    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,

      LAYOUT_ADDCHILD, self.gadgetList[ VIRTGAD_SCROLLER ]:=CheckBoxObject,
        GA_ID, VIRTGAD_SCROLLER,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_TEXT, 'Scroller',
        ->CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
      CheckBoxEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ VIRTGAD_OK ]:=ButtonObject,
          GA_ID, VIRTGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ VIRTGAD_CHILD ]:=ButtonObject,
          GA_ID, VIRTGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ VIRTGAD_CANCEL ]:=ButtonObject,
          GA_ID, VIRTGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[VIRTGAD_CHILD]:={editChildSettings}
  self.gadgetActions[VIRTGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[VIRTGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF virtualSettingsForm
  self:=nself
  self.setBusy()
  self.virtualObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF virtualSettingsForm

  END self.gadgetList[NUM_VIRTUAL_GADS]
  END self.gadgetActions[NUM_VIRTUAL_GADS]
ENDPROC

PROC editSettings(comp:PTR TO virtualObject) OF virtualSettingsForm
  DEF res

  self.virtualObject:=comp
    
  SetGadgetAttrsA(self.gadgetList[ VIRTGAD_SCROLLER ],0,0,[CHECKBOX_CHECKED,comp.scroller,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.scroller:=Gets(self.gadgetList[ VIRTGAD_SCROLLER ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF virtualObject
  self.previewObject:=0
  IF (virtualbase)
    self.previewObject:=NewObjectA( Virtual_GetClass(), NIL,[TAG_IGNORE,0,
        VIRTUALA_SCROLLER, self.scroller,
    TAG_END])
  ENDIF
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

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
    CHILD_NOMINALSIZE, self.nominalSize,
    CHILD_WEIGHTMINIMUM, self.weightMinimum,
    IF self.weightBar THEN LAYOUT_WEIGHTBAR ELSE TAG_IGNORE, 1,
    TAG_END]
ENDPROC

EXPORT PROC create(parent) OF virtualObject
  self.type:=TYPE_VIRTUAL
  SUPER self.create(parent)
  self.scroller:=TRUE
  self.libsused:=[TYPE_VIRTUAL]
ENDPROC

EXPORT PROC editSettings() OF virtualObject
  DEF editForm:PTR TO virtualSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF virtualObject
  RETURN 'Virtual'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF virtualObject IS
[
  makeProp(scroller,FIELDTYPE_CHAR)
]

EXPORT PROC allowChildren() OF virtualObject IS 1

EXPORT PROC addChildTag() OF virtualObject IS VIRTUALA_CONTENTS

EXPORT PROC removeChildTag() OF virtualObject IS VIRTUALA_CONTENTS

EXPORT PROC addImageTag() OF virtualObject IS VIRTUALA_CONTENTS

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF virtualObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.scroller=FALSE THEN srcGen.componentProperty('VIRTUALA_Scroller','FALSE',FALSE)
ENDPROC

EXPORT PROC hasCreateMacro() OF virtualObject IS FALSE ->create macro was missing from EVO modules

EXPORT PROC getTypeEndName() OF virtualObject
  RETURN 'End'
ENDPROC

EXPORT PROC createVirtualObject(parent)
  DEF virtual:PTR TO virtualObject
  
  NEW virtual.create(parent)
ENDPROC virtual


