OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'images/led',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen','*colourPicker','*validator'

EXPORT DEF ledbase

EXPORT ENUM LEDGAD_IDENT, LEDGAD_FGPEN,LEDGAD_BGPEN,LEDGAD_WIDTH,LEDGAD_HEIGHT,LEDGAD_COLON,
          LEDGAD_NEGATIVE,LEDGAD_SIGNED,LEDGAD_TIME,LEDGAD_HEX,
      LEDGAD_OK, LEDGAD_CHILD, LEDGAD_CANCEL

CONST NUM_LED_GADS=LEDGAD_CANCEL+1

EXPORT OBJECT ledObject OF reactionObject
  fgPen:INT
  bgPen:INT
  width:INT
  height:INT
  colon:CHAR
  negative:CHAR
  signed:CHAR
  time:CHAR
  hex:CHAR
ENDOBJECT

OBJECT ledSettingsForm OF reactionForm
PRIVATE
  ledObject:PTR TO ledObject
  tmpFgPen:INT
  tmpBgPen:INT
ENDOBJECT

PROC create() OF ledSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_LED_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_LED_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'LED Attribute Setting',
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

      LAYOUT_ADDCHILD, self.gadgetList[ LEDGAD_IDENT ]:=StringObject,
        GA_ID, LEDGAD_IDENT,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Identifier',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LEDGAD_FGPEN ]:=ButtonObject,
          GA_ID, LEDGAD_FGPEN,
          GA_TEXT, 'ForegroundPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LEDGAD_BGPEN ]:=ButtonObject,
          GA_ID, LEDGAD_BGPEN,
          GA_TEXT, 'BackgroundPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LEDGAD_WIDTH ]:=IntegerObject,
          GA_ID, LEDGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LEDGAD_HEIGHT ]:=IntegerObject,
          GA_ID, LEDGAD_HEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Height',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LEDGAD_HEX ]:=CheckBoxObject,
          GA_ID, LEDGAD_HEX,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Hexadecimal',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LEDGAD_NEGATIVE ]:=CheckBoxObject,
          GA_ID, LEDGAD_NEGATIVE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Negative',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LEDGAD_SIGNED ]:=CheckBoxObject,
          GA_ID, LEDGAD_SIGNED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Signed',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LEDGAD_TIME ]:=CheckBoxObject,
          GA_ID, LEDGAD_TIME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Time',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LEDGAD_COLON ]:=CheckBoxObject,
          GA_ID, LEDGAD_COLON,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Colon',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LEDGAD_OK ]:=ButtonObject,
          GA_ID, LEDGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LEDGAD_CHILD ]:=ButtonObject,
          GA_ID, LEDGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LEDGAD_CANCEL ]:=ButtonObject,
          GA_ID, LEDGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[LEDGAD_FGPEN]:={selectPen}
  self.gadgetActions[LEDGAD_BGPEN]:={selectPen}
  self.gadgetActions[LEDGAD_CHILD]:={editChildSettings}
  self.gadgetActions[LEDGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[LEDGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF ledSettingsForm
  self:=nself
  self.setBusy()
  self.ledObject.editChildSettings()
  self.clearBusy()
ENDPROC


PROC selectPen(nself,gadget,id,code) OF ledSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE LEDGAD_FGPEN
      colourProp:={self.tmpFgPen}
    CASE LEDGAD_BGPEN
      colourProp:={self.tmpBgPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC end() OF ledSettingsForm

  END self.gadgetList[NUM_LED_GADS]
  END self.gadgetActions[NUM_LED_GADS]
ENDPROC

EXPORT PROC canClose(modalRes) OF ledSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.ledObject,LEDGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO ledObject) OF ledSettingsForm
  DEF res

  self.ledObject:=comp
    
  self.tmpFgPen:=comp.fgPen
  self.tmpBgPen:=comp.bgPen

  SetGadgetAttrsA(self.gadgetList[ LEDGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ LEDGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0]) 
  SetGadgetAttrsA(self.gadgetList[ LEDGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0]) 
  SetGadgetAttrsA(self.gadgetList[ LEDGAD_COLON ],0,0,[CHECKBOX_CHECKED,comp.colon,0]) 
  SetGadgetAttrsA(self.gadgetList[ LEDGAD_NEGATIVE ],0,0,[CHECKBOX_CHECKED,comp.negative,0]) 
  SetGadgetAttrsA(self.gadgetList[ LEDGAD_SIGNED ],0,0,[CHECKBOX_CHECKED,comp.signed,0]) 
  SetGadgetAttrsA(self.gadgetList[ LEDGAD_TIME ],0,0,[CHECKBOX_CHECKED,comp.time,0]) 
  SetGadgetAttrsA(self.gadgetList[ LEDGAD_HEX ],0,0,[CHECKBOX_CHECKED,comp.hex,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.fgPen:=self.tmpFgPen
    comp.bgPen:=self.tmpBgPen
  
    AstrCopy(comp.ident,Gets(self.gadgetList[ LEDGAD_IDENT ],STRINGA_TEXTVAL))
    comp.width:=Gets(self.gadgetList[ LEDGAD_WIDTH ],INTEGER_NUMBER)   
    comp.height:=Gets(self.gadgetList[ LEDGAD_HEIGHT ],INTEGER_NUMBER)   
    comp.colon:=Gets(self.gadgetList[ LEDGAD_COLON ],CHECKBOX_CHECKED)   
    comp.negative:=Gets(self.gadgetList[ LEDGAD_NEGATIVE ],CHECKBOX_CHECKED)   
    comp.signed:=Gets(self.gadgetList[ LEDGAD_SIGNED ],CHECKBOX_CHECKED)   
    comp.time:=Gets(self.gadgetList[ LEDGAD_TIME ],CHECKBOX_CHECKED)   
    comp.hex:=Gets(self.gadgetList[ LEDGAD_HEX ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF ledObject
  self.previewObject:=0
  IF (ledbase)
    self.previewObject:=LedObject,
      IA_FGPEN, self.fgPen,
      IA_BGPEN, self.bgPen,
      IA_WIDTH, self.width,
      IA_HEIGHT, self.height,
      SYSIA_DRAWINFO, self.drawInfo,
      LED_COLON, self.colon,
      LED_NEGATIVE, self.negative,
      LED_SIGNED, self.signed,
      LED_TIME, self.time,
      LED_HEXADECIMAL, self.hex,
      LED_PAIRS,4,
      LED_VALUES, [12,34,56,78]:INT,
    LedEnd
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

EXPORT PROC create(parent) OF ledObject
  self.type:=TYPE_LED
  SUPER self.create(parent)
  self.fgPen:=-1
  self.bgPen:=-1
  self.width:=50
  self.height:=20
  self.colon:=0
  self.negative:=0
  self.signed:=0
  self.time:=TRUE
  self.hex:=FALSE
  self.libsused:=[TYPE_LED]
ENDPROC

EXPORT PROC editSettings() OF ledObject
  DEF editForm:PTR TO ledSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF ledObject
  RETURN 'Led'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF ledObject IS
[
  makeProp(fgPen,FIELDTYPE_INT),
  makeProp(bgPen,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(colon,FIELDTYPE_CHAR),
  makeProp(negative,FIELDTYPE_CHAR),
  makeProp(signed,FIELDTYPE_CHAR),
  makeProp(time,FIELDTYPE_CHAR),
  makeProp(hex,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF ledObject
  IF self.fgPen<>-1 THEN srcGen.componentPropertyInt('IA_FGPen',self.fgPen)
  IF self.bgPen<>-1 THEN srcGen.componentPropertyInt('IA_BGPen',self.bgPen)
  srcGen.componentPropertyInt('IA_Width',self.width)
  srcGen.componentPropertyInt('IA_Height',self.height)
  srcGen.componentProperty('SYSIA_DrawInfo','gDrawInfo',FALSE)
  IF self.colon THEN srcGen.componentProperty('LED_Colon','TRUE',FALSE)
  IF self.negative THEN srcGen.componentProperty('LED_Negative','TRUE',FALSE)
  IF self.signed THEN srcGen.componentProperty('LED_Signed','TRUE',FALSE)
  IF self.time=FALSE THEN srcGen.componentProperty('LED_Time','FALSE',FALSE)
  IF self.hex THEN srcGen.componentProperty('LED_Hexadecimal','TRUE',FALSE)
  srcGen.componentPropertyInt('LED_Pairs',4)
  IF srcGen.type=CSOURCE_GEN
    srcGen.componentProperty('LED_Values','ledValues',FALSE)
  ELSE
    srcGen.componentProperty('LED_Values','[12,34,56,78]:INT',FALSE)
  ENDIF

  /*srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  srcGen.componentProperty('WHEEL_Screen','gScreen',FALSE) 
  IF self.bevelBox THEN srcGen.componentProperty('WHEEL_BevelBox','TRUE',FALSE)*/
ENDPROC

EXPORT PROC isImage() OF ledObject IS TRUE

EXPORT PROC libNameCreate() OF ledObject IS 'led.image'

EXPORT PROC createLedObject(parent)
  DEF led:PTR TO ledObject
  
  NEW led.create(parent)
ENDPROC led


