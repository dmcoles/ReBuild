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

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourceGen','*validator'

EXPORT ENUM BTNGAD_IDENT, BTNGAD_LABEL, BTNGAD_NAME, BTNGAD_HINT, BTNGAD_TEXTPEN, BTNGAD_BGPEN, BTNGAD_FILLTEXTPEN, BTNGAD_FILLPEN,
      BTNGAD_AUTOBUTTON, BTNGAD_BEVELSTYLE, BTNGAD_JUSTIFICATION, BTNGAD_SELECTED,
      BTNGAD_DISABLED, BTNGAD_READONLY, BTNGAD_PUSHBUTTON, BTNGAD_TRANSPARENT,
      BTNGAD_OK, BTNGAD_CHILD, BTNGAD_CANCEL
      

CONST NUM_BTN_GADS=BTNGAD_CANCEL+1

EXPORT OBJECT buttonObject OF reactionObject
  textPen:INT
  bgPen:INT
  fillTextPen:INT
  fillPen:INT
  autoButton:CHAR
  bevelStyle:CHAR
  justify:CHAR
  selected:CHAR
  disabled:CHAR
  readOnly:CHAR
  pushButton:CHAR
  transparent:CHAR
ENDOBJECT

OBJECT buttonSettingsForm OF reactionForm
PRIVATE
  buttonObject:PTR TO buttonObject
  tmpTextPen:INT
  tmpBgPen:INT
  tmpFillTextPen:INT
  tmpFillPen:INT
  labels1:PTR TO LONG
  labels2:PTR TO LONG
  labels3:PTR TO LONG
ENDOBJECT

PROC create() OF buttonSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_BTN_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_BTN_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Button Attribute Setting',
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
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_IDENT ]:=StringObject,
            GA_ID, BTNGAD_IDENT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Identifier',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_LABEL ]:=StringObject,
            GA_ID, BTNGAD_LABEL,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,

          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Label',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_NAME ]:=StringObject,
            GA_ID, BTNGAD_NAME,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,

          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Text',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_HINT ]:=ButtonObject,
            GA_ID, BTNGAD_HINT,
            GA_TEXT, 'Hint',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
          CHILD_WEIGHTEDWIDTH,50,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_TEXTPEN ]:=ButtonObject,
            GA_ID, BTNGAD_TEXTPEN,
            GA_TEXT, '_TextPen',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_BGPEN ]:=ButtonObject,
            GA_ID, BTNGAD_BGPEN,
            GA_TEXT, 'Back_groundPen',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_FILLTEXTPEN ]:=ButtonObject,
            GA_ID, BTNGAD_FILLTEXTPEN,
            GA_TEXT, '_FillTextPen',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_FILLPEN ]:=ButtonObject,
            GA_ID, BTNGAD_FILLPEN,
            GA_TEXT, 'Fill_Pen',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_AUTOBUTTON ]:=ChooserObject,
            GA_ID, BTNGAD_AUTOBUTTON,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels1:=chooserLabelsA(['NONE', 'BAG_POPFILE', 'BAG_POPDRAWER', 'BAG_POPFONT', 'BAG_CHECKBOX', 
              'BAG_UPARROW', 'BAG_DOWNARROW', 'BAG_RIGHTARROW', 'BAG_LEFTARROW', 'BAG_POPTIME', 
              'BAG_POPSCREEN',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'AutoButton',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_BEVELSTYLE ]:=ChooserObject,
            GA_ID, BTNGAD_BEVELSTYLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels2:=chooserLabelsA(['BVS_NONE', 'BVS_THIN', 'BVS_BUTTON', 'BVS_GROUP',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'BevelStyle',
          LabelEnd,

          LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_JUSTIFICATION ]:=ChooserObject,
            GA_ID, BTNGAD_JUSTIFICATION,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels3:=chooserLabelsA(['BCJ_LEFT', 'BCJ_CENTER', 'BCJ_RIGHT',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Justification',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_SELECTED ]:=CheckBoxObject,
            GA_ID, BTNGAD_SELECTED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Selected',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_DISABLED ]:=CheckBoxObject,
            GA_ID, BTNGAD_DISABLED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Disabled',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_READONLY ]:=CheckBoxObject,
            GA_ID, BTNGAD_READONLY,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'ReadOnly',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[  BTNGAD_PUSHBUTTON ]:=CheckBoxObject,
            GA_ID, BTNGAD_PUSHBUTTON,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'PushButton',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ BTNGAD_TRANSPARENT ]:=CheckBoxObject,
            GA_ID, BTNGAD_TRANSPARENT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Transparent',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,
 
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_OK ]:=ButtonObject,
            GA_ID, BTNGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_CHILD ]:=ButtonObject,
            GA_ID, BTNGAD_CHILD,
            GA_TEXT, 'C_hild',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

/*
          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_HINT ]:=ButtonObject,
            GA_ID, BTNGAD_HINT,
            GA_TEXT, 'Hint',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,*/

          LAYOUT_ADDCHILD,  self.gadgetList[ BTNGAD_CANCEL ]:=ButtonObject,
            GA_ID, BTNGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[BTNGAD_CHILD]:={editChildSettings}
  self.gadgetActions[BTNGAD_HINT]:={editHint}
  self.gadgetActions[BTNGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[BTNGAD_OK]:=MR_OK

  self.gadgetActions[BTNGAD_TEXTPEN]:={selectPen}
  self.gadgetActions[BTNGAD_BGPEN]:={selectPen}
  self.gadgetActions[BTNGAD_FILLTEXTPEN]:={selectPen}
  self.gadgetActions[BTNGAD_FILLPEN]:={selectPen}
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF buttonSettingsForm
  self:=nself
  self.setBusy()
  self.buttonObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC editHint(nself,gadget,id,code) OF buttonSettingsForm
  self:=nself
  self.setBusy()
  self.buttonObject.editHint()
  self.clearBusy()
  self.updateHint(BTNGAD_HINT, self.buttonObject.hintText)
ENDPROC

PROC selectPen(nself,gadget,id,code) OF buttonSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE BTNGAD_TEXTPEN
      colourProp:={self.tmpTextPen}
    CASE BTNGAD_BGPEN
      colourProp:={self.tmpBgPen}
    CASE BTNGAD_FILLTEXTPEN
      colourProp:={self.tmpFillTextPen}
    CASE BTNGAD_FILLPEN
      colourProp:={self.tmpFillPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC end() OF buttonSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )

  END self.gadgetList[NUM_BTN_GADS]
  END self.gadgetActions[NUM_BTN_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF buttonSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.buttonObject,BTNGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO buttonObject) OF buttonSettingsForm
  DEF res

  self.buttonObject:=comp
    
  self.tmpTextPen:=comp.textPen
  self.tmpBgPen:=comp.bgPen
  self.tmpFillTextPen:=comp.fillTextPen
  self.tmpFillPen:=comp.fillPen
 
  self.updateHint(BTNGAD_HINT, comp.hintText)

  SetGadgetAttrsA(self.gadgetList[ BTNGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_LABEL ],0,0,[STRINGA_TEXTVAL,comp.label,0])
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_AUTOBUTTON ],0,0,[CHOOSER_SELECTED,comp.autoButton,0]) 
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_BEVELSTYLE ],0,0,[CHOOSER_SELECTED,comp.bevelStyle,0]) 
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_JUSTIFICATION  ],0,0,[CHOOSER_SELECTED,comp.justify,0]) 
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_SELECTED  ],0,0,[CHECKBOX_CHECKED,comp.selected,0]) 
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_DISABLED  ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_READONLY  ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_PUSHBUTTON  ],0,0,[CHECKBOX_CHECKED,comp.pushButton,0]) 
  SetGadgetAttrsA(self.gadgetList[ BTNGAD_TRANSPARENT  ],0,0,[CHECKBOX_CHECKED,comp.transparent,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ BTNGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.name,Gets(self.gadgetList[ BTNGAD_NAME ],STRINGA_TEXTVAL))
    AstrCopy(comp.label,Gets(self.gadgetList[ BTNGAD_LABEL ],STRINGA_TEXTVAL))
    comp.textPen:=self.tmpTextPen
    comp.bgPen:=self.tmpBgPen
    comp.fillTextPen:=self.tmpFillTextPen
    comp.fillPen:=self.tmpFillPen
    comp.autoButton:=Gets(self.gadgetList[ BTNGAD_AUTOBUTTON ],CHOOSER_SELECTED)
    comp.bevelStyle:=Gets(self.gadgetList[ BTNGAD_BEVELSTYLE ],CHOOSER_SELECTED)
    comp.justify:=Gets(self.gadgetList[ BTNGAD_JUSTIFICATION ],CHOOSER_SELECTED)
    comp.selected:=Gets(self.gadgetList[ BTNGAD_SELECTED ],CHECKBOX_CHECKED)
    comp.disabled:=Gets(self.gadgetList[ BTNGAD_DISABLED ],CHECKBOX_CHECKED)
    comp.readOnly:=Gets(self.gadgetList[ BTNGAD_READONLY ],CHECKBOX_CHECKED)
    comp.pushButton:=Gets(self.gadgetList[ BTNGAD_PUSHBUTTON ],CHECKBOX_CHECKED)
    comp.transparent:=Gets(self.gadgetList[ BTNGAD_TRANSPARENT ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF buttonObject
  self.previewObject:=ButtonObject,
      GA_ID, self.id,
      GA_TEXT,self.name,
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      GA_DISABLED, self.disabled,
      GA_SELECTED, self.selected,
      GA_READONLY, self.readOnly,
      IF self.autoButton THEN BUTTON_AUTOBUTTON ELSE TAG_IGNORE, ListItem([-1,BAG_POPFILE,BAG_POPDRAWER,BAG_POPFONT,BAG_CHECKBOX,BAG_UPARROW,BAG_DNARROW,BAG_RTARROW,BAG_LFARROW,BAG_POPTIME,BAG_POPSCREEN],self.autoButton),
      BUTTON_PUSHBUTTON, self.pushButton,
      BUTTON_TRANSPARENT, self.transparent,
      BUTTON_TEXTPEN, self.textPen,
      BUTTON_BACKGROUNDPEN, self.bgPen,
      BUTTON_FILLTEXTPEN, self.fillTextPen,
      BUTTON_FILLPEN, self.fillPen,
      BUTTON_BEVELSTYLE, ListItem([BVS_NONE,BVS_THIN,BVS_BUTTON,BVS_GROUP],self.bevelStyle),
      BUTTON_JUSTIFICATION, ListItem([BCJ_LEFT,BCJ_CENTER,BCJ_RIGHT],self.justify),
    ButtonEnd

    IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

    self.makePreviewChildAttrs(0)
ENDPROC

EXPORT PROC create(parent) OF buttonObject
  self.type:=TYPE_BUTTON
  SUPER self.create(parent)
  self.textPen:=1
  self.bgPen:=0
  self.fillTextPen:=1
  self.fillPen:=3
  self.autoButton:=0
  self.bevelStyle:=2
  self.justify:=1
  self.selected:=0
  self.disabled:=0
  self.readOnly:=0
  self.pushButton:=0
  self.transparent:=0
  self.libsused:=[TYPE_BUTTON]
ENDPROC

EXPORT PROC editSettings() OF buttonObject
  DEF editForm:PTR TO buttonSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF buttonObject
  RETURN 'Button'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF buttonObject IS
[
  makeProp(textPen,FIELDTYPE_INT),
  makeProp(bgPen,FIELDTYPE_INT),
  makeProp(fillTextPen,FIELDTYPE_INT),
  makeProp(fillPen,FIELDTYPE_INT),
  makeProp(autoButton,FIELDTYPE_CHAR),
  makeProp(bevelStyle,FIELDTYPE_CHAR),
  makeProp(justify,FIELDTYPE_CHAR),
  makeProp(selected,FIELDTYPE_CHAR),
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(pushButton,FIELDTYPE_CHAR),
  makeProp(transparent,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF buttonObject
  DEF tempStr[100]:STRING
    srcGen.componentProperty('GA_Text',self.name,TRUE)
    srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
    srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
    IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
    IF self.selected THEN srcGen.componentProperty('GA_Selected','TRUE',FALSE)
    IF self.readOnly THEN srcGen.componentProperty('GA_ReadOnly','TRUE',FALSE)

    IF self.autoButton
      srcGen.componentProperty('BUTTON_AutoButton',ListItem([0,'BAG_POPFILE','BAG_POPDRAWER','BAG_POPFONT','BAG_CHECKBOX','BAG_UPARROW','BAG_DNARROW','BAG_RTARROW','BAG_LFARROW','BAG_POPTIME','BAG_POPSCREEN'],self.autoButton),FALSE)
    ENDIF

    IF self.pushButton THEN srcGen.componentProperty('BUTTON_PushButton','TRUE',FALSE)
    IF self.transparent THEN srcGen.componentProperty('BUTTON_Transparent','TRUE',FALSE)

    IF self.textPen<>-1 THEN srcGen.componentPropertyInt('BUTTON_TextPen',self.textPen)
    IF self.bgPen<>-1 THEN srcGen.componentPropertyInt('BUTTON_BackgroundPen',self.bgPen)
    IF self.fillTextPen<>-1 THEN srcGen.componentPropertyInt('BUTTON_FillTextPen',self.fillTextPen)
    IF self.fillPen<>-1 THEN srcGen.componentPropertyInt('BUTTON_FillPen',self.fillPen)

    IF self.bevelStyle<>2 THEN srcGen.componentProperty('BUTTON_BevelStyle',ListItem(['BVS_NONE','BVS_THIN','BVS_BUTTON','BVS_GROUP'],self.bevelStyle),FALSE)
    IF self.justify<>1 THEN srcGen.componentProperty('BUTTON_Justification',ListItem(['BCJ_LEFT','BCJ_CENTER','BCJ_RIGHT'],self.justify),FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF buttonObject
  srcGen.componentAddChildLabel(self.label)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC createButtonObject(parent)
  DEF button:PTR TO buttonObject
  
  NEW button.create(parent)
ENDPROC button
