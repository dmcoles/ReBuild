OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'gadgets/string','string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen'

EXPORT ENUM STRGAD_NAME, STRGAD_MAXCHARS, STRGAD_VALUE,STRGAD_MINVISIBLE,
      STRGAD_DISABLED, STRGAD_READONLY, STRGAD_TABCYCLE, STRGAD_REPLACEMODE,
      STRGAD_OK, STRGAD_CHILD, STRGAD_CANCEL
      

CONST NUM_STR_GADS=STRGAD_CANCEL+1

EXPORT OBJECT stringObject OF reactionObject
  maxChars:CHAR
  value[80]:ARRAY OF CHAR
  minVisible:INT
  disabled:CHAR
  readOnly:CHAR
  tabCycle:CHAR
  replaceMode:CHAR
ENDOBJECT

OBJECT stringSettingsForm OF reactionForm
PRIVATE
  stringObject:PTR TO stringObject
ENDOBJECT

PROC create() OF stringSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_STR_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_STR_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'String Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
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

        LAYOUT_ADDCHILD, self.gadgetList[ STRGAD_NAME ]:=StringObject,
          GA_ID, STRGAD_NAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'String _Name',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ STRGAD_MAXCHARS ]:=IntegerObject,
          GA_ID, STRGAD_MAXCHARS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 3,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 255,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxCha_rs',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ STRGAD_VALUE ]:=StringObject,
        GA_ID, STRGAD_VALUE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'String _Value',
      LabelEnd,
      
      LAYOUT_ADDCHILD,  self.gadgetList[ STRGAD_MINVISIBLE ]:=IntegerObject,
        GA_ID, STRGAD_MINVISIBLE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        INTEGER_MAXCHARS, 3,
        INTEGER_MINIMUM, 0,
        INTEGER_MAXIMUM, 999,
      IntegerEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'MinVisible',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ STRGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, STRGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ STRGAD_READONLY ]:=CheckBoxObject,
          GA_ID, STRGAD_READONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_ReadOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ STRGAD_TABCYCLE ]:=CheckBoxObject,
          GA_ID, STRGAD_TABCYCLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_TabCycle',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ STRGAD_REPLACEMODE ]:=CheckBoxObject,
          GA_ID, STRGAD_REPLACEMODE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Replace_Mode',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ STRGAD_OK ]:=ButtonObject,
          GA_ID, STRGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ STRGAD_CHILD ]:=ButtonObject,
          GA_ID, STRGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ STRGAD_CANCEL ]:=ButtonObject,
          GA_ID, STRGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[STRGAD_CHILD]:={editChildSettings}
  self.gadgetActions[STRGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[STRGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF stringSettingsForm
  self:=nself
  self.setBusy()
  self.stringObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF stringSettingsForm
  END self.gadgetList[NUM_STR_GADS]
  END self.gadgetActions[NUM_STR_GADS]
ENDPROC

PROC editSettings(comp:PTR TO stringObject) OF stringSettingsForm
  DEF res

  self.stringObject:=comp

  SetGadgetAttrsA(self.gadgetList[ STRGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ STRGAD_MAXCHARS ],0,0,[INTEGER_NUMBER,comp.maxChars,0])
  SetGadgetAttrsA(self.gadgetList[ STRGAD_VALUE ],0,0,[STRINGA_TEXTVAL,comp.value,0])
  SetGadgetAttrsA(self.gadgetList[ STRGAD_MINVISIBLE ],0,0,[INTEGER_NUMBER,comp.minVisible,0])
  SetGadgetAttrsA(self.gadgetList[ STRGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 
  SetGadgetAttrsA(self.gadgetList[ STRGAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ STRGAD_TABCYCLE ],0,0,[CHECKBOX_CHECKED,comp.tabCycle,0]) 
  SetGadgetAttrsA(self.gadgetList[ STRGAD_REPLACEMODE ],0,0,[CHECKBOX_CHECKED,comp.replaceMode,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ STRGAD_NAME ],STRINGA_TEXTVAL))
    comp.maxChars:=Gets(self.gadgetList[ STRGAD_MAXCHARS ],INTEGER_NUMBER)
    AstrCopy(comp.value,Gets(self.gadgetList[ STRGAD_VALUE ],STRINGA_TEXTVAL))
    comp.minVisible:=Gets(self.gadgetList[ STRGAD_MINVISIBLE ],INTEGER_NUMBER)
    comp.disabled:=Gets(self.gadgetList[ STRGAD_DISABLED ],CHECKBOX_CHECKED)
    comp.readOnly:=Gets(self.gadgetList[ STRGAD_READONLY ],CHECKBOX_CHECKED)
    comp.tabCycle:=Gets(self.gadgetList[ STRGAD_TABCYCLE ],CHECKBOX_CHECKED)
    comp.replaceMode:=Gets(self.gadgetList[ STRGAD_REPLACEMODE ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF stringObject
  self.previewObject:=StringObject,
    GA_RELVERIFY, TRUE,
    GA_TABCYCLE, self.tabCycle,
    STRINGA_TEXTVAL, self.value,
    STRINGA_MAXCHARS, self.maxChars,
    STRINGA_MINVISIBLE, self.minVisible,
    GA_DISABLED, self.disabled,
    GA_READONLY, self.readOnly,
    STRINGA_REPLACEMODE, self.replaceMode,
  StringEnd
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

  IF StrLen(self.name)>0
    self.previewChildAttrs:=[
          LAYOUT_MODIFYCHILD, self.previewObject,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, self.name,
          LabelEnd,
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
  ELSE
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
  ENDIF
ENDPROC

EXPORT PROC create(parent) OF stringObject
  self.type:=TYPE_STRING
  SUPER self.create(parent)
  self.maxChars:=80
  AstrCopy(self.value,'')
  self.minVisible:=4
  self.disabled:=0
  self.readOnly:=0
  self.tabCycle:=TRUE
  self.replaceMode:=0

  self.libsused:=[TYPE_STRING,TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF stringObject
  DEF editForm:PTR TO stringSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF stringObject IS
[
  makeProp(maxChars,FIELDTYPE_CHAR),
  makeProp(value,FIELDTYPE_STR),
  makeProp(minVisible,FIELDTYPE_INT),
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(tabCycle,FIELDTYPE_CHAR),
  makeProp(replaceMode,FIELDTYPE_CHAR)
]

EXPORT PROC getTypeName() OF stringObject
  RETURN 'String'
ENDPROC

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF stringObject

  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  IF self.tabCycle THEN srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF self.readOnly THEN srcGen.componentProperty('GA_ReadOnly','TRUE',FALSE)
  IF StrLen(self.value) THEN srcGen.componentProperty('STRINGA_TextVal',self.value,TRUE)
  srcGen.componentPropertyInt('STRINGA_MaxChars',self.maxChars)
  IF self.minVisible<>4 THEN srcGen.componentPropertyInt('STRINGA_MinVisible',self.minVisible)
  IF self.replaceMode THEN srcGen.componentProperty('STRINGA_ReplaceMode', 'TRUE', FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF stringObject
  srcGen.componentAddChildLabel(self.name)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC


EXPORT PROC createStringObject(parent)
  DEF string:PTR TO stringObject
  
  NEW string.create(parent)
ENDPROC string
