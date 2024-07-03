OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/colorwheel','colorwheel',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen','*validator'

EXPORT ENUM CWHEELGAD_IDENT, CWHEELGAD_BEVELBOX,
      CWHEELGAD_OK, CWHEELGAD_CHILD, CWHEELGAD_CANCEL
      

CONST NUM_CWHEEL_GADS=CWHEELGAD_CANCEL+1

EXPORT OBJECT colorWheelObject OF reactionObject
  bevelBox:CHAR
ENDOBJECT

OBJECT colorWheelSettingsForm OF reactionForm
PRIVATE
  colorWheelObject:PTR TO colorWheelObject
ENDOBJECT

PROC create() OF colorWheelSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_CWHEEL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_CWHEEL_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'ColorWheel Attribute Setting',
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

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ CWHEELGAD_IDENT ]:=StringObject,
          GA_ID, CWHEELGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ CWHEELGAD_BEVELBOX ]:=CheckBoxObject,
          GA_ID, CWHEELGAD_BEVELBOX,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Bevel Box',
          ->CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ CWHEELGAD_OK ]:=ButtonObject,
          GA_ID, CWHEELGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ CWHEELGAD_CHILD ]:=ButtonObject,
          GA_ID, CWHEELGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ CWHEELGAD_CANCEL ]:=ButtonObject,
          GA_ID, CWHEELGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[CWHEELGAD_CHILD]:={editChildSettings}
  self.gadgetActions[CWHEELGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[CWHEELGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF colorWheelSettingsForm
  self:=nself
  self.setBusy()
  self.colorWheelObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF colorWheelSettingsForm

  END self.gadgetList[NUM_CWHEEL_GADS]
  END self.gadgetActions[NUM_CWHEEL_GADS]
ENDPROC

EXPORT PROC canClose(modalRes) OF colorWheelSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.colorWheelObject,CWHEELGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO colorWheelObject) OF colorWheelSettingsForm
  DEF res

  self.colorWheelObject:=comp
    
  SetGadgetAttrsA(self.gadgetList[ CWHEELGAD_BEVELBOX ],0,0,[CHECKBOX_CHECKED,comp.bevelBox,0]) 
  SetGadgetAttrsA(self.gadgetList[ CWHEELGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ CWHEELGAD_IDENT ],STRINGA_TEXTVAL))
    comp.bevelBox:=Gets(self.gadgetList[ CWHEELGAD_BEVELBOX ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF colorWheelObject
  self.previewObject:=0
  IF (colorwheelbase)
    self.previewObject:=ColorWheelObject,
        WHEEL_SCREEN, scr,
        WHEEL_BEVELBOX, self.bevelBox,
      ColorWheelEnd
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

EXPORT PROC create(parent) OF colorWheelObject
  self.type:=TYPE_COLORWHEEL
  SUPER self.create(parent)
  self.bevelBox:=0
  self.libsused:=[TYPE_COLORWHEEL]
ENDPROC

EXPORT PROC editSettings() OF colorWheelObject
  DEF editForm:PTR TO colorWheelSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF colorWheelObject
  RETURN 'ColorWheel'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF colorWheelObject IS
[
  makeProp(bevelBox,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF colorWheelObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  srcGen.componentProperty('WHEEL_Screen','gScreen',FALSE) 
  IF self.bevelBox THEN srcGen.componentProperty('WHEEL_BevelBox','TRUE',FALSE)
ENDPROC

EXPORT PROC libNameCreate() OF colorWheelObject IS 'colorwheel.gadget'

EXPORT PROC createColorWheelObject(parent)
  DEF colorWheel:PTR TO colorWheelObject
  
  NEW colorWheel.create(parent)
ENDPROC colorWheel


