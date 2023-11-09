OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'images/penmap',
        'string',
        '*bball',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourceGen'

EXPORT ENUM BBGAD_NAME, BBGAD_LEFTEDGE, BBGAD_TOPEDGE,
            BBGAD_WIDTH, BBGAD_HEIGHT, BBGAD_BGPEN, BBGAD_TRANSPARENT, 
      BBGAD_OK, BBGAD_CHILD, BBGAD_CANCEL

CONST NUM_BB_GADS=BBGAD_CANCEL+1

EXPORT OBJECT boingBallObject OF reactionObject
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  bgPen:INT
  transparent:CHAR
ENDOBJECT

OBJECT boingBallSettingsForm OF reactionForm
  boingBallObject:PTR TO boingBallObject
  tempBgPen:INT
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF boingBallSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_BB_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_BB_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'BoingBall Attribute Setting',
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
          LAYOUT_SHRINKWRAP, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_LEFTEDGE ]:=IntegerObject,
            GA_ID, BBGAD_LEFTEDGE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_LeftEdge',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_TOPEDGE ]:=IntegerObject,
            GA_ID, BBGAD_TOPEDGE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Top_Edge',
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
          LAYOUT_SHRINKWRAP, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_WIDTH ]:=IntegerObject,
            GA_ID, BBGAD_WIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Width',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_HEIGHT ]:=IntegerObject,
            GA_ID, BBGAD_HEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Height',
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
          LAYOUT_EVENSIZE, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_BGPEN ]:=ButtonObject,
            GA_ID, BBGAD_BGPEN,
            GA_TEXT, '_Background Pen',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ BBGAD_TRANSPARENT ]:=CheckBoxObject,
            GA_ID, BBGAD_TRANSPARENT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Transparent',
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

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_OK ]:=ButtonObject,
            GA_ID, BBGAD_OK,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_CHILD ]:=ButtonObject,
            GA_ID, BBGAD_CHILD,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ BBGAD_CANCEL ]:=ButtonObject,
            GA_ID, BBGAD_CANCEL,
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

  self.gadgetActions[BBGAD_BGPEN]:={selectPen}
  self.gadgetActions[BBGAD_CHILD]:={editChildSettings}
  self.gadgetActions[BBGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[BBGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF boingBallSettingsForm
  self:=nself
  self.setBusy()
  self.boingBallObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF boingBallSettingsForm
  END self.gadgetList[NUM_BB_GADS]
  END self.gadgetActions[NUM_BB_GADS]
ENDPROC

PROC selectPen(nself,gadget,id,code) OF boingBallSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE BBGAD_BGPEN
      colourProp:={self.tempBgPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC editSettings(comp:PTR TO boingBallObject) OF boingBallSettingsForm
  DEF res

  self.boingBallObject:=comp

  self.tempBgPen:=comp.bgPen
  SetGadgetAttrsA(self.gadgetList[ BBGAD_LEFTEDGE ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ BBGAD_TOPEDGE ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ BBGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ BBGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])
  SetGadgetAttrsA(self.gadgetList[ BBGAD_TRANSPARENT  ],0,0,[CHECKBOX_CHECKED,comp.transparent,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.leftEdge:=Gets(self.gadgetList[ BBGAD_LEFTEDGE ],INTEGER_NUMBER)
    comp.topEdge:=Gets(self.gadgetList[ BBGAD_TOPEDGE ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ BBGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ BBGAD_HEIGHT ],INTEGER_NUMBER)
    comp.bgPen:=self.tempBgPen
    comp.transparent:=Gets(self.gadgetList[ BBGAD_TRANSPARENT ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF boingBallObject
  self.previewObject:=NewObjectA(BoingBall_GetClass(),NIL,[TAG_IGNORE,0,
      IA_LEFT, self.leftEdge,
      IA_TOP, self.topEdge,
      IA_WIDTH, self.width,
      IA_HEIGHT, self.height,
      IA_BGPEN, self.bgPen,
      PENMAP_TRANSPARENT, self.transparent,
      PENMAP_SCREEN, scr,
      ->LABEL_DRAWINFO, self.drawInfo,
    TAG_DONE])

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

EXPORT PROC create(parent) OF boingBallObject
  self.type:=TYPE_BOINGBALL
  SUPER self.create(parent)
  self.leftEdge:=0
  self.topEdge:=0
  self.width:=0
  self.height:=0
  self.bgPen:=0
  self.transparent:=TRUE
  self.libused:=LIB_BOINGBALL
ENDPROC

EXPORT PROC editSettings() OF boingBallObject
  DEF editForm:PTR TO boingBallSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF boingBallObject IS
[
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(bgPen,FIELDTYPE_INT),
  makeProp(transparent,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF boingBallObject

  srcGen.componentPropertyInt('IA_Left',self.leftEdge)
  srcGen.componentPropertyInt('IA_Top',self.topEdge)
  srcGen.componentPropertyInt('IA_Width',self.width)
  srcGen.componentPropertyInt('IA_Height',self.topEdge)
  srcGen.componentProperty('PENMAP_Screen','gScreen',FALSE)
  
  IF self.bgPen<>0 THEN srcGen.componentPropertyInt('IA_BGPen',self.bgPen)
  IF self.transparent=FALSE THEN srcGen.componentProperty('PENMAP_Transparent','FALSE',FALSE)
ENDPROC

EXPORT PROC getTypeName() OF boingBallObject
  RETURN 'BoingBall'
ENDPROC

EXPORT PROC libNameCreate() OF boingBallObject IS 'boingball.image'

EXPORT PROC isImage() OF boingBallObject IS TRUE

EXPORT PROC createBoingBallObject(parent)
  DEF bball:PTR TO boingBallObject
  
  NEW bball.create(parent)
ENDPROC bball
