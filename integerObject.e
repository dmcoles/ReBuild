OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm'

EXPORT ENUM INTGAD_NAME, INTGAD_MAXCHARS, INTGAD_VALUE,INTGAD_MINVISIBLE,
      INTGAD_MINIMUM, INTGAD_MAXIMUM,
      INTGAD_DISABLED, INTGAD_TABCYCLE, INTGAD_ARROWS,
      INTGAD_OK, INTGAD_CHILD, INTGAD_CANCEL
      

CONST NUM_INT_GADS=INTGAD_CANCEL+1

EXPORT OBJECT integerObject OF reactionObject
  maxChars:CHAR
  value:LONG
  minVisible:INT
  minimum:LONG
  maximum:LONG
  disabled:CHAR
  tabCycle:CHAR
  arrows:CHAR
ENDOBJECT

OBJECT integerSettingsForm OF reactionForm
  integerObject:PTR TO integerObject
ENDOBJECT

PROC create() OF integerSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_INT_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_INT_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Integer Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WA_PUBSCREEN, 0,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_NOCAREREFRESH, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,

    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_SHRINKWRAP, TRUE,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ INTGAD_NAME ]:=StringObject,
            GA_ID, INTGAD_NAME,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_TEXTVAL, '_Integer1',
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Integer _Name',
          LabelEnd,
          
          LAYOUT_ADDCHILD,  self.gadgetList[ INTGAD_MAXCHARS ]:=IntegerObject,
            GA_ID, INTGAD_MAXCHARS,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 10,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 99,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MaxCha_rs',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ INTGAD_VALUE ]:=IntegerObject,
            GA_ID, INTGAD_VALUE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            /*INTEGER_MAXCHARS, 2,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 99,*/
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Integer _Value',
          LabelEnd,
          
          LAYOUT_ADDCHILD,  self.gadgetList[ INTGAD_MINVISIBLE ]:=IntegerObject,
            GA_ID, INTGAD_MINVISIBLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 3,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM,256,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MinVisible',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ INTGAD_MINIMUM ]:=IntegerObject,
            GA_ID, INTGAD_MINIMUM,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            /*INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 8192,*/
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Minimum',
          LabelEnd,
          
          LAYOUT_ADDCHILD,  self.gadgetList[ INTGAD_MAXIMUM ]:=IntegerObject,
            GA_ID, INTGAD_MAXIMUM,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            /*INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 8192,*/
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Maximuim',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ INTGAD_DISABLED ]:=CheckBoxObject,
            GA_ID, INTGAD_DISABLED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Disabled',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ INTGAD_TABCYCLE ]:=CheckBoxObject,
            GA_ID, INTGAD_TABCYCLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_TabCycle',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ INTGAD_ARROWS ]:=CheckBoxObject,
            GA_ID, INTGAD_ARROWS,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Arrows',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,
 
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ INTGAD_OK ]:=ButtonObject,
            GA_ID, INTGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ INTGAD_CHILD ]:=ButtonObject,
            GA_ID, INTGAD_CHILD,
            GA_TEXT, 'C_hild',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ INTGAD_CANCEL ]:=ButtonObject,
            GA_ID, INTGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,
        LayoutEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[INTGAD_CHILD]:={editChildSettings}
  self.gadgetActions[INTGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[INTGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF integerSettingsForm
  self:=nself
  self.setBusy()
  self.integerObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF integerSettingsForm
  END self.gadgetList[NUM_INT_GADS]
  END self.gadgetActions[NUM_INT_GADS]
ENDPROC

PROC editSettings(comp:PTR TO integerObject) OF integerSettingsForm
  DEF res

  SetGadgetAttrsA(self.gadgetList[ INTGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ INTGAD_MAXCHARS ],0,0,[INTEGER_NUMBER,comp.maxChars,0])
  SetGadgetAttrsA(self.gadgetList[ INTGAD_VALUE ],0,0,[INTEGER_NUMBER,comp.value,0])
  SetGadgetAttrsA(self.gadgetList[ INTGAD_MINVISIBLE ],0,0,[INTEGER_NUMBER,comp.minVisible,0])
  SetGadgetAttrsA(self.gadgetList[ INTGAD_MINIMUM ],0,0,[INTEGER_NUMBER,comp.minimum,0])
  SetGadgetAttrsA(self.gadgetList[ INTGAD_MAXIMUM ],0,0,[INTEGER_NUMBER,comp.maximum,0])
  SetGadgetAttrsA(self.gadgetList[ INTGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 
  SetGadgetAttrsA(self.gadgetList[ INTGAD_TABCYCLE ],0,0,[CHECKBOX_CHECKED,comp.tabCycle,0]) 
  SetGadgetAttrsA(self.gadgetList[ INTGAD_ARROWS ],0,0,[CHECKBOX_CHECKED,comp.arrows,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ INTGAD_NAME ],STRINGA_TEXTVAL))
    comp.maxChars:=Gets(self.gadgetList[ INTGAD_MAXCHARS ],INTEGER_NUMBER)
    comp.value:=Gets(self.gadgetList[ INTGAD_VALUE ],INTEGER_NUMBER)
    comp.minVisible:=Gets(self.gadgetList[ INTGAD_MINVISIBLE ],INTEGER_NUMBER)
    comp.minimum:=Gets(self.gadgetList[ INTGAD_MINIMUM ],INTEGER_NUMBER)
    comp.maximum:=Gets(self.gadgetList[ INTGAD_MAXIMUM ],INTEGER_NUMBER)
    comp.disabled:=Gets(self.gadgetList[ INTGAD_DISABLED ],CHECKBOX_CHECKED)
    comp.tabCycle:=Gets(self.gadgetList[ INTGAD_TABCYCLE ],CHECKBOX_CHECKED)
    comp.arrows:=Gets(self.gadgetList[ INTGAD_ARROWS ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject() OF integerObject
  self.previewObject:=IntegerObject,
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, self.tabCycle,
      GA_DISABLED, self.disabled,
      INTEGER_ARROWS, self.arrows,
      INTEGER_MAXCHARS, self.maxChars,
      INTEGER_NUMBER, self.value,
      INTEGER_MINIMUM, self.minimum,
      INTEGER_MAXIMUM, self.maximum,
    IntegerEnd

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
    TAG_END]
ENDPROC

EXPORT PROC create(parent) OF integerObject
  self.type:=TYPE_INTEGER
  SUPER self.create(parent)
  self.maxChars:=10
  self.value:=0
  self.minVisible:=0
  self.minimum:=0
  self.maximum:=8192
  self.disabled:=0
  self.tabCycle:=TRUE
  self.arrows:=TRUE

  self.libused:=LIB_INTEGER OR LIB_LABEL
ENDPROC

EXPORT PROC editSettings() OF integerObject
  DEF editForm:PTR TO integerSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res


#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF integerObject IS
[
  makeProp(maxChars,FIELDTYPE_CHAR),
  makeProp(value,FIELDTYPE_LONG),
  makeProp(minVisible,FIELDTYPE_INT),
  makeProp(minimum,FIELDTYPE_LONG),
  makeProp(maximum,FIELDTYPE_LONG),
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(tabCycle,FIELDTYPE_CHAR),
  makeProp(arrows,FIELDTYPE_CHAR)
]

EXPORT PROC getTypeName() OF integerObject
  RETURN 'Integer'
ENDPROC

EXPORT PROC createIntegerObject(parent)
  DEF integer:PTR TO integerObject
  
  NEW integer.create(parent)
ENDPROC integer
