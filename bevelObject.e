OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'bevel','images/bevel',
        'string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/screens',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourceGen'

EXPORT ENUM BEVELGAD_NAME, BEVELGAD_LEFT, BEVELGAD_TOP, BEVELGAD_WIDTH, BEVELGAD_HEIGHT,
      BEVELGAD_FILLPEN, BEVELGAD_TEXTPEN, BEVELGAD_STYLE, BEVELGAD_PLACETEXT,
      BEVELGAD_HIGHLIGHTPEN, BEVELGAD_FOREGROUNDPEN, BEVELGAD_BACKGROUNDPEN, BEVELGAD_SHADOWPEN,
      BEVELGAD_RECESSED, BEVELGAD_EDGESONLY, BEVELGAD_TRANSPARENT,
      BEVELGAD_OK, BEVELGAD_CHILD, BEVELGAD_CANCEL
      

CONST NUM_BEVEL_GADS=BEVELGAD_CANCEL+1

EXPORT OBJECT bevelObject OF reactionObject
  left:INT
  top:INT
  width:INT
  height:INT
  fillPen:INT
  textPen:INT
  style:CHAR
  placeText:CHAR
  highlightPen:CHAR
  foregroundPen:CHAR
  backgroundPen:CHAR
  shadowPen:CHAR
  recessed:CHAR
  edgesOnly:CHAR
  transparent:CHAR
ENDOBJECT

OBJECT bevelSettingsForm OF reactionForm
PRIVATE
  tmpFillPen:INT
  tmpTextPen:INT
  bevelObject:PTR TO bevelObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
  labels3:PTR TO LONG
  labels4:PTR TO LONG
  labels5:PTR TO LONG
  labels6:PTR TO LONG
ENDOBJECT

PROC create() OF bevelSettingsForm
  DEF gads:PTR TO LONG
  DEF arrows,scr:PTR TO screen
  
  NEW gads[NUM_BEVEL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_BEVEL_GADS]
  self.gadgetActions:=gads
  
  scr:=LockPubScreen(NIL)
  arrows:=(scr.width>=800)
  UnlockPubScreen(NIL,scr)
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Bevel Attribute Setting',
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

      LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_NAME ]:=StringObject,
        GA_ID, BEVELGAD_NAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Button Name',
      LabelEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_LEFT ]:=IntegerObject,
          GA_ID, BEVELGAD_LEFT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Left',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_TOP ]:=IntegerObject,
          GA_ID, BEVELGAD_TOP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Top',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_WIDTH ]:=IntegerObject,
          GA_ID, BEVELGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_HEIGHT ]:=IntegerObject,
          GA_ID, BEVELGAD_HEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Hei_ght',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_FILLPEN ]:=ButtonObject,
          GA_ID, BEVELGAD_FILLPEN,
          GA_TEXT, 'FillPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDWIDTH, 0,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_TEXTPEN ]:=ButtonObject,
          GA_ID, BEVELGAD_TEXTPEN,
          GA_TEXT, 'TextPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDWIDTH, 0,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_STYLE ]:=ChooserObject,
          GA_ID, BEVELGAD_STYLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['BVS_NONE', 'BVS_THIN', 'BVS_BUTTON', 'BVS_GROUP','BVS_FIELD','BVS_DROPBOX','BVS_SBAR_HORIZ','BVS_SBAR_VERT','BVS_BOX','BVS_RADIOBUTTON','BVS_STANDARD',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Style',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_PLACETEXT ]:=ChooserObject,
          GA_ID, BEVELGAD_PLACETEXT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['BVJ_TOP_CENTER', 'BVJ_TOP_LEFT', 'BVJ_TOP_RIGHT', 'BVJ_IN_CENTER', 'BVJ_IN_LEFT', 'BVJ_IN_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_PlaceText',
        LabelEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_HIGHLIGHTPEN ]:=ChooserObject,
          GA_ID, BEVELGAD_HIGHLIGHTPEN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels3:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'HighlightPen',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_FOREGROUNDPEN ]:=ChooserObject,
          GA_ID, BEVELGAD_FOREGROUNDPEN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels4:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'ForegroundPen',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_BACKGROUNDPEN ]:=ChooserObject,
          GA_ID, BEVELGAD_BACKGROUNDPEN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels5:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'BackgroundPen',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_SHADOWPEN ]:=ChooserObject,
          GA_ID, BEVELGAD_SHADOWPEN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels6:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'ShadowPen',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_RECESSED ]:=CheckBoxObject,
          GA_ID, BEVELGAD_RECESSED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Recessed',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_EDGESONLY ]:=CheckBoxObject,
          GA_ID, BEVELGAD_EDGESONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_EdgesOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ BEVELGAD_TRANSPARENT ]:=CheckBoxObject,
          GA_ID, BEVELGAD_TRANSPARENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Tr_ansparent',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_OK ]:=ButtonObject,
          GA_ID, BEVELGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_CHILD ]:=ButtonObject,
          GA_ID, BEVELGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BEVELGAD_CANCEL ]:=ButtonObject,
          GA_ID, BEVELGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[BEVELGAD_CHILD]:={editChildSettings}
  self.gadgetActions[BEVELGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[BEVELGAD_OK]:=MR_OK

  self.gadgetActions[BEVELGAD_FILLPEN]:={selectPen}
  self.gadgetActions[BEVELGAD_TEXTPEN]:={selectPen}
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF bevelSettingsForm
  self:=nself
  self.setBusy()
  self.bevelObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC selectPen(nself,gadget,id,code) OF bevelSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE BEVELGAD_TEXTPEN
      colourProp:={self.tmpTextPen}
    CASE BEVELGAD_FILLPEN
      colourProp:={self.tmpFillPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()

ENDPROC

PROC end() OF bevelSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )
  freeChooserLabels( self.labels4 )
  freeChooserLabels( self.labels5 )
  freeChooserLabels( self.labels6 )

  END self.gadgetList[NUM_BEVEL_GADS]
  END self.gadgetActions[NUM_BEVEL_GADS]
ENDPROC

PROC editSettings(comp:PTR TO bevelObject) OF bevelSettingsForm
  DEF res

  self.bevelObject:=comp
    
  self.tmpFillPen:=comp.fillPen
  self.tmpTextPen:=comp.textPen

  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_LEFT ],0,0,[INTEGER_NUMBER,comp.left,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_TOP ],0,0,[INTEGER_NUMBER,comp.top,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0]) 

  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_STYLE ],0,0,[CHOOSER_SELECTED,comp.style,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_PLACETEXT ],0,0,[CHOOSER_SELECTED,comp.placeText,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_HIGHLIGHTPEN ],0,0,[CHOOSER_SELECTED,comp.highlightPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_FOREGROUNDPEN ],0,0,[CHOOSER_SELECTED,comp.foregroundPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_BACKGROUNDPEN ],0,0,[CHOOSER_SELECTED,comp.backgroundPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_SHADOWPEN ],0,0,[CHOOSER_SELECTED,comp.shadowPen,0]) 

  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_RECESSED ],0,0,[CHECKBOX_CHECKED,comp.recessed,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_EDGESONLY ],0,0,[CHECKBOX_CHECKED,comp.edgesOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ BEVELGAD_TRANSPARENT ],0,0,[CHECKBOX_CHECKED,comp.transparent,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ BEVELGAD_NAME ],STRINGA_TEXTVAL))
    comp.fillPen:=self.tmpFillPen
    comp.textPen:=self.tmpTextPen
    
    comp.left:=Gets(self.gadgetList[ BEVELGAD_LEFT ],INTEGER_NUMBER)
    comp.top:=Gets(self.gadgetList[ BEVELGAD_TOP ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ BEVELGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ BEVELGAD_HEIGHT ],INTEGER_NUMBER)

    comp.style:=Gets(self.gadgetList[ BEVELGAD_STYLE ],CHOOSER_SELECTED)
    comp.placeText:=Gets(self.gadgetList[ BEVELGAD_PLACETEXT ],CHOOSER_SELECTED)
    comp.highlightPen:=Gets(self.gadgetList[ BEVELGAD_HIGHLIGHTPEN ],CHOOSER_SELECTED)
    comp.foregroundPen:=Gets(self.gadgetList[ BEVELGAD_FOREGROUNDPEN ],CHOOSER_SELECTED)
    comp.backgroundPen:=Gets(self.gadgetList[ BEVELGAD_BACKGROUNDPEN ],CHOOSER_SELECTED)
    comp.shadowPen:=Gets(self.gadgetList[ BEVELGAD_SHADOWPEN ],CHOOSER_SELECTED)

    comp.recessed:=Gets(self.gadgetList[ BEVELGAD_RECESSED ],CHECKBOX_CHECKED)
    comp.edgesOnly:=Gets(self.gadgetList[ BEVELGAD_EDGESONLY ],CHECKBOX_CHECKED)
    comp.transparent:=Gets(self.gadgetList[ BEVELGAD_TRANSPARENT ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF bevelObject
  self.previewObject:=BevelObject,
      IA_LEFT, self.left,
      IA_TOP, self.top,
      IA_WIDTH, self.width,
      IA_HEIGHT, self.height,
      BEVEL_FILLPEN, self.fillPen,
      BEVEL_TEXTPEN, self.textPen,
      BEVEL_STYLE,ListItem([BVS_NONE, BVS_THIN, BVS_BUTTON, BVS_GROUP,BVS_FIELD,BVS_DROPBOX,BVS_SBAR_HORIZ,BVS_SBAR_VERT,BVS_BOX,BVS_RADIOBUTTON,BVS_STANDARD],self.style),
      BEVEL_LABELPLACE,ListItem([BVJ_TOP_CENTER, BVJ_TOP_LEFT, BVJ_TOP_RIGHT, BVJ_IN_CENTER, BVJ_IN_LEFT, BVJ_IN_RIGHT],self.placeText),
      BEVEL_LABEL, self.name,
      IA_HIGHLIGHTPEN, ListItem([DETAILPEN,BLOCKPEN,TEXTPEN,SHINEPEN,SHADOWPEN,FILLPEN,FILLTEXTPEN,BACKGROUNDPEN,HIGHLIGHTTEXTPEN],self.highlightPen),
      IA_FGPEN, ListItem([DETAILPEN,BLOCKPEN,TEXTPEN,SHINEPEN,SHADOWPEN,FILLPEN,FILLTEXTPEN,BACKGROUNDPEN,HIGHLIGHTTEXTPEN],self.foregroundPen),
      IA_BGPEN, ListItem([DETAILPEN,BLOCKPEN,TEXTPEN,SHINEPEN,SHADOWPEN,FILLPEN,FILLTEXTPEN,BACKGROUNDPEN,HIGHLIGHTTEXTPEN],self.backgroundPen),
      IA_SHADOWPEN, ListItem([DETAILPEN,BLOCKPEN,TEXTPEN,SHINEPEN,SHADOWPEN,FILLPEN,FILLTEXTPEN,BACKGROUNDPEN,HIGHLIGHTTEXTPEN],self.shadowPen),
      IA_RECESSED, self.recessed,
      IA_EDGESONLY, self.edgesOnly,
      BEVEL_TRANSPARENT, self.transparent,
    BevelEnd
    
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

EXPORT PROC create(parent) OF bevelObject
  self.type:=TYPE_BEVEL

  SUPER self.create(parent)
  
  self.textPen:=1
  self.fillPen:=0
  self.top:=0
  self.width:=0
  self.height:=0
  self.style:=1
  self.placeText:=0
  self.highlightPen:=SHINEPEN
  self.foregroundPen:=SHINEPEN
  self.backgroundPen:=SHADOWPEN
  self.shadowPen:=SHADOWPEN
  self.recessed:=0
  self.edgesOnly:=0
  self.transparent:=0

  self.libsused:=[TYPE_BEVEL]
ENDPROC

EXPORT PROC editSettings() OF bevelObject
  DEF editForm:PTR TO bevelSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF bevelObject IS
[
  makeProp(left,FIELDTYPE_INT),
  makeProp(top,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(fillPen,FIELDTYPE_INT),
  makeProp(textPen,FIELDTYPE_INT),
  makeProp(style,FIELDTYPE_CHAR),
  makeProp(placeText,FIELDTYPE_CHAR),
  makeProp(highlightPen,FIELDTYPE_CHAR),
  makeProp(foregroundPen,FIELDTYPE_CHAR),
  makeProp(backgroundPen,FIELDTYPE_CHAR),
  makeProp(shadowPen,FIELDTYPE_CHAR),
  makeProp(recessed,FIELDTYPE_CHAR),
  makeProp(edgesOnly,FIELDTYPE_CHAR),
  makeProp(transparent,FIELDTYPE_CHAR)

]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF bevelObject
  srcGen.componentProperty('GA_DrawInfo','gDrawInfo',FALSE)
  srcGen.componentPropertyInt('IA_Top',self.top)
  srcGen.componentPropertyInt('IA_Left',self.left)
  srcGen.componentPropertyInt('IA_Width',self.width)
  srcGen.componentPropertyInt('IA_Height',self.height)
  IF self.textPen<>1 THEN srcGen.componentPropertyInt('BEVEL_TextPen',self.textPen) 
  IF self.fillPen<>0 THEN srcGen.componentPropertyInt('BEVEL_FillPen',self.fillPen) 
  IF self.style<>2 THEN srcGen.componentProperty('BEVEL_Style',ListItem(['BVS_NONE', 'BVS_THIN', 'BVS_BUTTON', 'BVS_GROUP','BVS_FIELD','BVS_DROPBOX','BVS_SBAR_HORIZ','BVS_SBAR_VERT','BVS_BOX','BVS_RADIOBUTTON','BVS_STANDARD'],self.style),FALSE)
  IF self.placeText<>0 THEN srcGen.componentProperty('BEVEL_LabelPlace',ListItem(['BVJ_TOP_CENTER', 'BVJ_TOP_LEFT', 'BVJ_TOP_RIGHT', 'BVJ_IN_CENTER', 'BVJ_IN_LEFT', 'BVJ_IN_RIGHT'],self.placeText),FALSE)

  srcGen.componentProperty('BEVEL_Label',self.name,TRUE)

  IF self.highlightPen<>SHINEPEN THEN srcGen.componentPropertyInt('IA_HighlightPen',self.highlightPen)
  IF self.foregroundPen<>SHINEPEN THEN srcGen.componentPropertyInt('IA_FGPen',self.foregroundPen)
  IF self.backgroundPen<>SHADOWPEN THEN srcGen.componentPropertyInt('IA_BGPen',self.backgroundPen)
  IF self.shadowPen<>SHADOWPEN THEN srcGen.componentPropertyInt('IA_ShadowPen',self.shadowPen)

  IF self.recessed THEN srcGen.componentProperty('IA_Recessed','TRUE',TRUE)
  IF self.edgesOnly THEN srcGen.componentProperty('IA_EdgesOnly','TRUE',TRUE)
  IF self.transparent THEN srcGen.componentProperty('BEVEL_Transparent','TRUE',TRUE)
ENDPROC

EXPORT PROC getTypeName() OF bevelObject
  RETURN 'Bevel'
ENDPROC

EXPORT PROC isImage() OF bevelObject IS TRUE

EXPORT PROC createBevelObject(parent)
  DEF bevel:PTR TO bevelObject
  
  NEW bevel.create(parent)
ENDPROC bevel
