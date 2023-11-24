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
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourcegen'

EXPORT ENUM CHKGAD_NAME, CHKGAD_TEXTPEN, CHKGAD_BGPEN, CHKGAD_FILLTEXTPEN,
      CHKGAD_DISABLED, CHKGAD_SELECTED, CHKGAD_LABELPLACE,
      CHKGAD_OK, CHKGAD_CHILD, CHKGAD_CANCEL
      

CONST NUM_CHK_GADS=CHKGAD_CANCEL+1

EXPORT OBJECT checkboxObject OF reactionObject
  textPen:INT
  bgPen:INT
  fillTextPen:INT
  disabled:CHAR
  selected:CHAR
  labelPlace:CHAR
ENDOBJECT

OBJECT checkboxSettingsForm OF reactionForm
PRIVATE
  checkboxObject:PTR TO checkboxObject
  tempTextPen:INT
  tempBgPen:INT
  tempFillTextPen:INT
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF checkboxSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_CHK_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_CHK_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Checkbox Attribute Setting',
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

      LAYOUT_ADDCHILD, self.gadgetList[ CHKGAD_NAME ]:=StringObject,
        GA_ID, CHKGAD_NAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Button Name',
      LabelEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ CHKGAD_TEXTPEN ]:=ButtonObject,
          GA_ID, CHKGAD_TEXTPEN,
          GA_TEXT, '_TextPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ CHKGAD_BGPEN ]:=ButtonObject,
          GA_ID, CHKGAD_BGPEN,
          GA_TEXT, 'Back_groundPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ CHKGAD_FILLTEXTPEN ]:=ButtonObject,
          GA_ID, CHKGAD_FILLTEXTPEN,
          GA_TEXT, '_FillTextPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,   
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ CHKGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, CHKGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ CHKGAD_SELECTED ]:=CheckBoxObject,
          GA_ID, CHKGAD_SELECTED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Selected',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ CHKGAD_LABELPLACE ]:=ChooserObject,
          GA_ID, CHKGAD_LABELPLACE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['PLACETEXT_LEFT', 'PLACETEXT_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'L_abelPlace',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ CHKGAD_OK ]:=ButtonObject,
          GA_ID, CHKGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ CHKGAD_CHILD ]:=ButtonObject,
          GA_ID, CHKGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ CHKGAD_CANCEL ]:=ButtonObject,
          GA_ID, CHKGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[CHKGAD_TEXTPEN]:={selectPen}
  self.gadgetActions[CHKGAD_BGPEN]:={selectPen}
  self.gadgetActions[CHKGAD_FILLTEXTPEN]:={selectPen}
  self.gadgetActions[CHKGAD_CHILD]:={editChildSettings}
  self.gadgetActions[CHKGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[CHKGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF checkboxSettingsForm
  self:=nself
  self.setBusy()
  self.checkboxObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC selectPen(nself,gadget,id,code) OF checkboxSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE CHKGAD_TEXTPEN
      colourProp:={self.tempTextPen}
    CASE CHKGAD_BGPEN
      colourProp:={self.tempBgPen}
    CASE CHKGAD_FILLTEXTPEN
      colourProp:={self.tempFillTextPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC end() OF checkboxSettingsForm
  freeChooserLabels( self.labels1 )

  END self.gadgetList[NUM_CHK_GADS]
  END self.gadgetActions[NUM_CHK_GADS]
ENDPROC

PROC editSettings(comp:PTR TO checkboxObject) OF checkboxSettingsForm
  DEF res

  self.checkboxObject:=comp
    
  self.tempTextPen:=comp.textPen
  self.tempBgPen:=comp.bgPen
  self.tempFillTextPen:=comp.fillTextPen
  SetGadgetAttrsA(self.gadgetList[ CHKGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ CHKGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 
  SetGadgetAttrsA(self.gadgetList[ CHKGAD_SELECTED ],0,0,[CHECKBOX_CHECKED,comp.selected,0]) 
  SetGadgetAttrsA(self.gadgetList[ CHKGAD_LABELPLACE ],0,0,[CHOOSER_SELECTED,comp.labelPlace,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ CHKGAD_NAME ],STRINGA_TEXTVAL))
    comp.textPen:=self.tempTextPen
    comp.bgPen:=self.tempBgPen
    comp.fillTextPen:=self.tempFillTextPen
    comp.disabled:=Gets(self.gadgetList[ CHKGAD_DISABLED ],CHECKBOX_CHECKED)   
    comp.selected:=Gets(self.gadgetList[ CHKGAD_SELECTED ],CHECKBOX_CHECKED)   
    comp.labelPlace:=Gets(self.gadgetList[ CHKGAD_LABELPLACE ],CHOOSER_SELECTED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF checkboxObject
  self.previewObject:=CheckBoxObject,
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      GA_TEXT, self.name,
      GA_DISABLED, self.disabled,
      GA_SELECTED, self.selected,
      CHECKBOX_TEXTPEN, self.textPen,
      CHECKBOX_BACKGROUNDPEN, self.bgPen,
      CHECKBOX_FILLTEXTPEN, self.fillTextPen,
      CHECKBOX_TEXTPLACE, ListItem([PLACETEXT_LEFT,PLACETEXT_RIGHT],self.labelPlace),
    CheckBoxEnd

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
ENDPROC

EXPORT PROC create(parent) OF checkboxObject
  self.type:=TYPE_CHECKBOX
  SUPER self.create(parent)
  self.textPen:=1
  self.bgPen:=0
  self.fillTextPen:=1
  self.disabled:=0
  self.selected:=0
  self.labelPlace:=1
  self.libsused:=[TYPE_CHECKBOX]
ENDPROC

EXPORT PROC editSettings() OF checkboxObject
  DEF editForm:PTR TO checkboxSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF checkboxObject
  RETURN 'CheckBox'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF checkboxObject IS
[
  makeProp(textPen,FIELDTYPE_INT),
  makeProp(bgPen,FIELDTYPE_INT),
  makeProp(fillTextPen,FIELDTYPE_INT),
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(selected,FIELDTYPE_CHAR),
  makeProp(labelPlace,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF checkboxObject
  srcGen.componentPropertyInt('GA_ID',self.id)
  srcGen.componentProperty('GA_Text',self.name,TRUE)
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF self.selected THEN srcGen.componentProperty('GA_Selected','TRUE',FALSE)
  srcGen.componentProperty('CHECKBOX_TextPlace',ListItem(['PLACETEXT_LEFT','PLACETEXT_RIGHT'],self.labelPlace),FALSE)

  IF self.textPen<>1 THEN srcGen.componentPropertyInt('CHECKBOX_TextPen',self.textPen)
  IF self.bgPen<>0 THEN srcGen.componentPropertyInt('CHECKBOX_BackgroundPen',self.bgPen)
  IF self.fillTextPen<>1 THEN srcGen.componentPropertyInt('CHECKBOX_FillTextPen',self.fillTextPen)
ENDPROC

EXPORT PROC createCheckboxObject(parent)
  DEF checkbox:PTR TO checkboxObject
  
  NEW checkbox.create(parent)
ENDPROC checkbox


