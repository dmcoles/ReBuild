OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'fuelgauge','gadgets/fuelgauge',
        'string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'images/bevel',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/screens',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourceGen'

EXPORT ENUM FGAUGEGAD_NAME, FGAUGEGAD_MIN, FGAUGEGAD_MAX, FGAUGEGAD_LEVEL, FGAUGEGAD_TICKSIZE,
      FGAUGEGAD_TICKS, FGAUGEGAD_ORIENTATION, FGAUGEGAD_JUSTIFICATION, FGAUGEGAD_SHORTTICKS,
      FGAUGEGAD_PERCENT, FGAUGEGAD_TICKPEN, FGAUGEGAD_PERCENTPEN, FGAUGEGAD_EMPTYPEN,
      FGAUGEGAD_FILLPEN,
      FGAUGEGAD_OK, FGAUGEGAD_CHILD, FGAUGEGAD_CANCEL
      

CONST NUM_FGAUGE_GADS=FGAUGEGAD_CANCEL+1

EXPORT OBJECT fuelGaugeObject OF reactionObject
  min:INT
  max:INT
  level:INT
  tickSize:INT
  ticks:INT
  orientation:CHAR
  justification:CHAR
  shortTicks:CHAR
  percent:CHAR
  tickPen:CHAR
  percentPen:CHAR
  emptyPen:CHAR
  fillPen:CHAR
ENDOBJECT

OBJECT fuelGaugeSettingsForm OF reactionForm
  fuelGaugeObject:PTR TO fuelGaugeObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
  labels3:PTR TO LONG
  labels4:PTR TO LONG
  labels5:PTR TO LONG
  labels6:PTR TO LONG
ENDOBJECT

PROC create() OF fuelGaugeSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_FGAUGE_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_FGAUGE_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'FuelGauge Attribute Setting',
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

        LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_NAME ]:=StringObject,
          GA_ID, FGAUGEGAD_NAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_TEXTVAL, '_Button1',
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Button Name',
        LabelEnd,


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

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_MIN ]:=IntegerObject,
            GA_ID, FGAUGEGAD_MIN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Min',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_MAX ]:=IntegerObject,
            GA_ID, FGAUGEGAD_MAX,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Ma_x',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_LEVEL ]:=IntegerObject,
            GA_ID, FGAUGEGAD_LEVEL,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Level',
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

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_TICKSIZE ]:=IntegerObject,
            GA_ID, FGAUGEGAD_TICKSIZE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Tick _Size',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_TICKS ]:=IntegerObject,
            GA_ID, FGAUGEGAD_TICKS,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Ticks',
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

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_ORIENTATION ]:=ChooserObject,
            GA_ID, FGAUGEGAD_ORIENTATION,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,          
            CHOOSER_LABELS, self.labels1:=chooserLabelsA(['FGORIENT_HORIZ','FGORIENT_VERT',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Or_ientation',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_JUSTIFICATION ]:=ChooserObject,
            GA_ID, FGAUGEGAD_JUSTIFICATION,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels2:=chooserLabelsA(['FGJ_LEFT','FGJ_CENTER',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Justification',
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

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_SHORTTICKS ]:=CheckBoxObject,
            GA_ID, FGAUGEGAD_SHORTTICKS,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Sho_rtTicks',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_PERCENT ]:=CheckBoxObject,
            GA_ID, FGAUGEGAD_PERCENT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Percent',
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
          LAYOUT_EVENSIZE, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_TICKPEN ]:=ChooserObject,
            GA_ID, FGAUGEGAD_TICKPEN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,          
            CHOOSER_LABELS, self.labels3:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Tic_kPen',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_PERCENTPEN ]:=ChooserObject,
            GA_ID, FGAUGEGAD_PERCENTPEN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels2:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Perc_ent',
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

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_EMPTYPEN ]:=ChooserObject,
            GA_ID, FGAUGEGAD_EMPTYPEN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,          
            CHOOSER_LABELS, self.labels5:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Empt_yPen',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ FGAUGEGAD_FILLPEN ]:=ChooserObject,
            GA_ID, FGAUGEGAD_FILLPEN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels6:=chooserLabelsA(['DETAILPEN', 'BLOCKPEN', 'TEXTPEN', 'SHINEPEN','SHADOWPEN','FILLPEN','FILLTEXTPEN','BACKGROUNDPEN','HIGHLIGHTTEXTPEN',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_FillPen',
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

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_OK ]:=ButtonObject,
            GA_ID, FGAUGEGAD_OK,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_CHILD ]:=ButtonObject,
            GA_ID, FGAUGEGAD_CHILD,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ FGAUGEGAD_CANCEL ]:=ButtonObject,
            GA_ID, FGAUGEGAD_CANCEL,
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

  self.gadgetActions[FGAUGEGAD_CHILD]:={editChildSettings}
  self.gadgetActions[FGAUGEGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[FGAUGEGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF fuelGaugeSettingsForm
  self:=nself
  self.fuelGaugeObject.editChildSettings()
ENDPROC

PROC end() OF fuelGaugeSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )
  freeChooserLabels( self.labels4 )
  freeChooserLabels( self.labels5 )
  freeChooserLabels( self.labels6 )

  END self.gadgetList[NUM_FGAUGE_GADS]
  END self.gadgetActions[NUM_FGAUGE_GADS]
ENDPROC

PROC editSettings(comp:PTR TO fuelGaugeObject) OF fuelGaugeSettingsForm
  DEF res

  self.fuelGaugeObject:=comp
    
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_MIN ],0,0,[INTEGER_NUMBER,comp.min,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_MAX ],0,0,[INTEGER_NUMBER,comp.max,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_LEVEL ],0,0,[INTEGER_NUMBER,comp.level,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_TICKSIZE ],0,0,[INTEGER_NUMBER,comp.tickSize,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_TICKS ],0,0,[INTEGER_NUMBER,comp.ticks,0]) 

  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_ORIENTATION ],0,0,[CHOOSER_SELECTED,comp.orientation,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_JUSTIFICATION ],0,0,[CHOOSER_SELECTED,comp.justification,0]) 

  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_SHORTTICKS ],0,0,[CHECKBOX_CHECKED,comp.shortTicks,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_PERCENT ],0,0,[CHECKBOX_CHECKED,comp.percent,0]) 

  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_TICKPEN ],0,0,[CHOOSER_SELECTED,comp.tickPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_PERCENTPEN ],0,0,[CHOOSER_SELECTED,comp.percentPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_EMPTYPEN ],0,0,[CHOOSER_SELECTED,comp.emptyPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ FGAUGEGAD_FILLPEN ],0,0,[CHOOSER_SELECTED,comp.fillPen,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ FGAUGEGAD_NAME ],STRINGA_TEXTVAL))

    comp.min:=Gets(self.gadgetList[ FGAUGEGAD_MIN ],INTEGER_NUMBER)
    comp.max:=Gets(self.gadgetList[ FGAUGEGAD_MAX ],INTEGER_NUMBER)
    comp.level:=Gets(self.gadgetList[ FGAUGEGAD_LEVEL ],INTEGER_NUMBER)
    comp.tickSize:=Gets(self.gadgetList[ FGAUGEGAD_TICKSIZE ],INTEGER_NUMBER)
    comp.ticks:=Gets(self.gadgetList[ FGAUGEGAD_TICKS ],INTEGER_NUMBER)

    comp.orientation:=Gets(self.gadgetList[ FGAUGEGAD_ORIENTATION ],CHOOSER_SELECTED)
    comp.justification:=Gets(self.gadgetList[ FGAUGEGAD_JUSTIFICATION ],CHOOSER_SELECTED)

    comp.shortTicks:=Gets(self.gadgetList[ FGAUGEGAD_SHORTTICKS ],CHECKBOX_CHECKED)
    comp.percent:=Gets(self.gadgetList[ FGAUGEGAD_PERCENT ],CHECKBOX_CHECKED)

    comp.tickPen:=Gets(self.gadgetList[ FGAUGEGAD_TICKPEN ],CHOOSER_SELECTED)
    comp.percentPen:=Gets(self.gadgetList[ FGAUGEGAD_PERCENTPEN ],CHOOSER_SELECTED)
    comp.emptyPen:=Gets(self.gadgetList[ FGAUGEGAD_EMPTYPEN ],CHOOSER_SELECTED)
    comp.fillPen:=Gets(self.gadgetList[ FGAUGEGAD_FILLPEN ],CHOOSER_SELECTED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject() OF fuelGaugeObject
  self.previewObject:=FuelGaugeObject,
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      GA_TEXT, self.name,
      FUELGAUGE_MIN, self.min,
      FUELGAUGE_MAX, self.max,
      FUELGAUGE_LEVEL, self.level,
      FUELGAUGE_ORIENTATION, ListItem([FGORIENT_HORIZ,FGORIENT_VERT],self.orientation),
      FUELGAUGE_PERCENT, self.percent,
      FUELGAUGE_SHORTTICKS, self.shortTicks,
      FUELGAUGE_TICKS,self.ticks,
      FUELGAUGE_TICKSIZE,self.tickSize,
      FUELGAUGE_TICKPEN,self.tickPen,
      FUELGAUGE_PERCENTPEN,self.percentPen,
      FUELGAUGE_EMPTYPEN,self.emptyPen,
      FUELGAUGE_FILLPEN,self.fillPen,
      FUELGAUGE_JUSTIFICATION, ListItem([FGJ_LEFT, FGJ_CENTER],self.justification),
    FuelGaugeEnd
    
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

EXPORT PROC create(parent) OF fuelGaugeObject
  self.type:=TYPE_FUELGAUGE

  SUPER self.create(parent)

  self.min:=0
  self.max:=0
  self.level:=0
  self.tickSize:=5
  self.ticks:=0
  self.orientation:=0
  self.justification:=0
  self.shortTicks:=0
  self.percent:=0
  self.tickPen:=3
  self.percentPen:=2
  self.emptyPen:=7
  self.fillPen:=5

  self.libused:=LIB_FUELGAUGE
ENDPROC

EXPORT PROC editSettings() OF fuelGaugeObject
  DEF editForm:PTR TO fuelGaugeSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF fuelGaugeObject IS
[
  makeProp(min,FIELDTYPE_INT),
  makeProp(max,FIELDTYPE_INT),
  makeProp(level,FIELDTYPE_INT),
  makeProp(tickSize,FIELDTYPE_INT),
  makeProp(ticks,FIELDTYPE_INT),
  makeProp(orientation,FIELDTYPE_CHAR),
  makeProp(justification,FIELDTYPE_CHAR),
  makeProp(shortTicks,FIELDTYPE_CHAR),
  makeProp(percent,FIELDTYPE_CHAR),
  makeProp(tickPen,FIELDTYPE_CHAR),
  makeProp(percentPen,FIELDTYPE_CHAR),
  makeProp(emptyPen,FIELDTYPE_CHAR),
  makeProp(fillPen,FIELDTYPE_CHAR)
]

EXPORT PROC getTypeName() OF fuelGaugeObject
  RETURN 'FuelGauge'
ENDPROC

EXPORT PROC createFuelGaugeObject(parent)
  DEF fuel:PTR TO fuelGaugeObject
  
  NEW fuel.create(parent)
ENDPROC fuel
