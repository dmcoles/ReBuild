OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourceGen'

EXPORT ENUM LBLGAD_NAME, LBLGAD_FGPEN, LBLGAD_BGPEN, LBLGAD_DISPOSE, LBLGAD_JUSTIFICATION,
      LBLGAD_OK, LBLGAD_CHILD, LBLGAD_CANCEL

CONST NUM_LBL_GADS=LBLGAD_CANCEL+1

EXPORT OBJECT labelObject OF reactionObject
  fgPen:INT
  bgPen:INT
  dispose:CHAR
  justify:CHAR
ENDOBJECT

OBJECT labelSettingsForm OF reactionForm
PRIVATE
  labelObject:PTR TO labelObject
  tempFgPen:INT
  tempBgPen:INT
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF labelSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_LBL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_LBL_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Label Attribute Setting',
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
      LAYOUT_ADDCHILD, self.gadgetList[ LBLGAD_NAME ]:=StringObject,
        GA_ID, LBLGAD_NAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Label _Text',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LBLGAD_FGPEN ]:=ButtonObject,
          GA_ID, LBLGAD_FGPEN,
          GA_TEXT, '_Foreground Pen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LBLGAD_BGPEN ]:=ButtonObject,
          GA_ID, LBLGAD_BGPEN,
          GA_TEXT, '_Background Pen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LBLGAD_DISPOSE ]:=CheckBoxObject,
          GA_ID, LBLGAD_DISPOSE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Dispose Image',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LBLGAD_JUSTIFICATION ]:=ChooserObject,
          GA_ID, LBLGAD_JUSTIFICATION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['BCJ_LEFT', 'BCJ_CENTER', 'BCJ_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Justification',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LBLGAD_OK ]:=ButtonObject,
          GA_ID, LBLGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LBLGAD_CHILD ]:=ButtonObject,
          GA_ID, LBLGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LBLGAD_CANCEL ]:=ButtonObject,
          GA_ID, LBLGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[LBLGAD_FGPEN]:={selectPen}
  self.gadgetActions[LBLGAD_BGPEN]:={selectPen}
  self.gadgetActions[LBLGAD_CHILD]:={editChildSettings}
  self.gadgetActions[LBLGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[LBLGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF labelSettingsForm
  self:=nself
  self.setBusy()
  self.labelObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF labelSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_LBL_GADS]
  END self.gadgetActions[NUM_LBL_GADS]
ENDPROC

PROC selectPen(nself,gadget,id,code) OF labelSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE LBLGAD_FGPEN
      colourProp:={self.tempFgPen}
    CASE LBLGAD_BGPEN
      colourProp:={self.tempBgPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC editSettings(comp:PTR TO labelObject) OF labelSettingsForm
  DEF res

  self.labelObject:=comp

  self.tempFgPen:=comp.fgPen
  self.tempBgPen:=comp.bgPen
  SetGadgetAttrsA(self.gadgetList[ LBLGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ LBLGAD_DISPOSE  ],0,0,[CHECKBOX_CHECKED,comp.dispose,0]) 
  SetGadgetAttrsA(self.gadgetList[ LBLGAD_JUSTIFICATION  ],0,0,[CHOOSER_SELECTED,comp.justify,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ LBLGAD_NAME ],STRINGA_TEXTVAL))
    comp.fgPen:=self.tempFgPen
    comp.bgPen:=self.tempBgPen
    comp.dispose:=Gets(self.gadgetList[ LBLGAD_DISPOSE ],CHECKBOX_CHECKED)
    comp.justify:=Gets(self.gadgetList[ LBLGAD_JUSTIFICATION ],CHOOSER_SELECTED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF labelObject
  self.previewObject:=LabelObject,
      LABEL_TEXT, self.name,
      LABEL_DISPOSEIMAGE, FALSE,
      IA_BGPEN, self.bgPen,
      IA_FGPEN, self.fgPen,
      LABEL_DRAWINFO, self.drawInfo,
      LABEL_JUSTIFICATION,ListItem([LJ_LEFT,LJ_CENTER,LJ_RIGHT],self.justify),
    LabelEnd
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
    TAG_END]
      ->drawinfo
ENDPROC

EXPORT PROC create(parent) OF labelObject
  self.type:=TYPE_LABEL
  SUPER self.create(parent)
  self.fgPen:=1
  self.bgPen:=0
  self.dispose:=FALSE
  self.justify:=0
  self.libsused:=[TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF labelObject
  DEF editForm:PTR TO labelSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF labelObject IS
[
  makeProp(fgPen,FIELDTYPE_INT),
  makeProp(bgPen,FIELDTYPE_INT),
  makeProp(dispose,FIELDTYPE_CHAR),
  makeProp(justify,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF labelObject
  srcGen.componentProperty('LABEL_DrawInfo','gDrawInfo',FALSE)
  srcGen.componentProperty('LABEL_Text',self.name,TRUE)
  IF self.fgPen<>1 THEN srcGen.componentPropertyInt('IA_FGPen',self.fgPen)
  IF self.bgPen<>0 THEN srcGen.componentPropertyInt('IA_BGPen',self.bgPen)
  IF self.dispose THEN srcGen.componentProperty('LABEL_DisposeImage','TRUE',FALSE)
  IF self.justify<>0 THEN srcGen.componentProperty('LABEL_Justification',ListItem(['LJ_LEFT','LJ_CENTER','LJ_RIGHT'],self.justify),FALSE)
ENDPROC

EXPORT PROC getTypeName() OF labelObject
  RETURN 'Label'
ENDPROC

EXPORT PROC isImage() OF labelObject IS TRUE

EXPORT PROC createLabelObject(parent)
  DEF label:PTR TO labelObject
  
  NEW label.create(parent)
ENDPROC label
