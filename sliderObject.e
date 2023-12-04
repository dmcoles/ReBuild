OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/slider','slider',
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

EXPORT ENUM SLDGAD_NAME, SLDGAD_MIN, SLDGAD_MAX, SLDGAD_LEVEL, SLDGAD_TICKS,SLDGAD_TICKSIZE,
      SLDGAD_MAXLEN, SLDGAD_SHORTTICKS,
      SLDGAD_INVERT, SLDGAD_ORIENTATION, SLDGAD_LEVELPLACE, SLDGAD_LEVELJUSTIFY, SLDGAD_DISABLED,

      SLDGAD_OK, SLDGAD_CHILD, SLDGAD_CANCEL

      

CONST NUM_SLD_GADS=SLDGAD_CANCEL+1

EXPORT OBJECT sliderObject OF reactionObject
  min:INT
  max:INT
  level:INT
  ticks:INT
  tickSize:LONG
  maxLen:INT
  shortTicks:CHAR
  invert:CHAR

  orientation:CHAR 
  levelPlace:CHAR
  levelJustify:CHAR
  disabled:CHAR
  
ENDOBJECT

OBJECT sliderSettingsForm OF reactionForm
PRIVATE
  sliderObject:PTR TO sliderObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
  labels3:PTR TO LONG
ENDOBJECT

PROC create() OF sliderSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_SLD_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_SLD_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Slider Attribute Setting',
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

      LAYOUT_ADDCHILD, self.gadgetList[ SLDGAD_NAME ]:=StringObject,
        GA_ID, SLDGAD_NAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Name',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_MIN ]:=IntegerObject,
          GA_ID, SLDGAD_MIN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Min',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_MAX ]:=IntegerObject,
          GA_ID, SLDGAD_MAX,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Ma_x',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_LEVEL ]:=IntegerObject,
          GA_ID, SLDGAD_LEVEL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Level',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_TICKS ]:=IntegerObject,
          GA_ID, SLDGAD_MIN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Ticks',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_TICKSIZE ]:=IntegerObject,
          GA_ID, SLDGAD_TICKSIZE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Tick Size',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_MAXLEN ]:=IntegerObject,
          GA_ID, SLDGAD_MAXLEN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Maximum Chars',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ SLDGAD_ORIENTATION ]:=ChooserObject,
          GA_ID, SLDGAD_ORIENTATION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['SORIENT_HORIZ','SORIENT_VERT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Orientation',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SLDGAD_LEVELPLACE ]:=ChooserObject,
          GA_ID, SLDGAD_LEVELPLACE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['PLACETEXT_LEFT', 'PLACETEXT_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Level Place',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ SLDGAD_LEVELJUSTIFY ]:=ChooserObject,
          GA_ID, SLDGAD_LEVELJUSTIFY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels3:=chooserLabelsA(['SLJ_LEFT', 'SLJ_CENTER', 'SLJ_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Level Justification',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SLDGAD_SHORTTICKS ]:=CheckBoxObject,
          GA_ID, SLDGAD_SHORTTICKS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Short Ticks',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ SLDGAD_INVERT ]:=CheckBoxObject,
          GA_ID, SLDGAD_INVERT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Invert',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SLDGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, SLDGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_OK ]:=ButtonObject,
          GA_ID, SLDGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_CHILD ]:=ButtonObject,
          GA_ID, SLDGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SLDGAD_CANCEL ]:=ButtonObject,
          GA_ID, SLDGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[SLDGAD_CHILD]:={editChildSettings}
  self.gadgetActions[SLDGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[SLDGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF sliderSettingsForm
  self:=nself
  self.setBusy()
  self.sliderObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF sliderSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )
  END self.gadgetList[NUM_SLD_GADS]
  END self.gadgetActions[NUM_SLD_GADS]
ENDPROC

PROC editSettings(comp:PTR TO sliderObject) OF sliderSettingsForm
  DEF res

  self.sliderObject:=comp
  
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_MIN ],0,0,[INTEGER_NUMBER,comp.min,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_MAX ],0,0,[INTEGER_NUMBER,comp.max,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_LEVEL ],0,0,[INTEGER_NUMBER,comp.level,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_TICKS ],0,0,[INTEGER_NUMBER,comp.ticks,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_TICKSIZE ],0,0,[INTEGER_NUMBER,comp.tickSize,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_MAXLEN ],0,0,[INTEGER_NUMBER,comp.maxLen,0])

  SetGadgetAttrsA(self.gadgetList[ SLDGAD_SHORTTICKS ],0,0,[CHECKBOX_CHECKED,comp.shortTicks,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_INVERT ],0,0,[CHECKBOX_CHECKED,comp.invert,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0])

  SetGadgetAttrsA(self.gadgetList[ SLDGAD_ORIENTATION ],0,0,[CHOOSER_SELECTED,comp.orientation,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_LEVELPLACE ],0,0,[CHOOSER_SELECTED,comp.levelPlace,0])
  SetGadgetAttrsA(self.gadgetList[ SLDGAD_LEVELJUSTIFY ],0,0,[CHOOSER_SELECTED,comp.levelJustify,0])

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ SLDGAD_NAME ],STRINGA_TEXTVAL))
    comp.min:=Gets(self.gadgetList[ SLDGAD_MIN ],INTEGER_NUMBER)
    comp.max:=Gets(self.gadgetList[ SLDGAD_MAX ],INTEGER_NUMBER)
    comp.level:=Gets(self.gadgetList[ SLDGAD_LEVEL ],INTEGER_NUMBER)
    comp.ticks:=Gets(self.gadgetList[ SLDGAD_TICKS ],INTEGER_NUMBER)
    comp.tickSize:=Gets(self.gadgetList[ SLDGAD_TICKSIZE ],INTEGER_NUMBER)
    comp.maxLen:=Gets(self.gadgetList[ SLDGAD_MAXLEN ],INTEGER_NUMBER)

    comp.shortTicks:=Gets(self.gadgetList[ SLDGAD_SHORTTICKS ],CHECKBOX_CHECKED)
    comp.invert:=Gets(self.gadgetList[ SLDGAD_INVERT ],CHECKBOX_CHECKED)
    comp.disabled:=Gets(self.gadgetList[ SLDGAD_DISABLED ],CHECKBOX_CHECKED)

    comp.orientation:=Gets(self.gadgetList[ SLDGAD_ORIENTATION ],CHOOSER_SELECTED)
    comp.levelPlace:=Gets(self.gadgetList[ SLDGAD_LEVELPLACE ],CHOOSER_SELECTED)
    comp.levelJustify:=Gets(self.gadgetList[ SLDGAD_LEVELJUSTIFY ],CHOOSER_SELECTED)

  ENDIF
ENDPROC res

EXPORT PROC createPreviewObject(scr) OF sliderObject
  self.previewObject:=SliderObject, 
      GA_RELVERIFY, TRUE,
      GA_DISABLED, self.disabled,
      SLIDER_MIN, self.min,
      SLIDER_MAX, self.max,
      SLIDER_LEVEL, self.level,
      SLIDER_TICKS, self.ticks,
      SLIDER_TICKSIZE, self.tickSize,
      SLIDER_LEVELMAXLEN, self.maxLen,
      SLIDER_SHORTTICKS, self.shortTicks,
      SLIDER_INVERT, self.invert,
      SLIDER_ORIENTATION, ListItem([SORIENT_HORIZ,SORIENT_VERT],self.orientation),
      SLIDER_LEVELPLACE, ListItem([PLACETEXT_LEFT, PLACETEXT_RIGHT],self.levelPlace),
      SLIDER_LEVELJUSTIFY, ListItem([SLJ_LEFT, SLJ_CENTER, SLJ_RIGHT],self.levelJustify),
    SliderEnd
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
      TAG_END]
  ENDIF
ENDPROC

EXPORT PROC create(parent) OF sliderObject
  self.type:=TYPE_SLIDER
  SUPER self.create(parent)
  
  self.min:=0
  self.max:=0
  self.level:=0
  self.ticks:=0
  self.tickSize:=5
  self.maxLen:=3
  self.shortTicks:=0
  self.invert:=0
  self.orientation:=1
  self.levelPlace:=0
  self.levelJustify:=0
  self.disabled:=0

  self.libsused:=[TYPE_SLIDER, TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF sliderObject
  DEF editForm:PTR TO sliderSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res=MR_OK

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF sliderObject IS
[
  makeProp(min,FIELDTYPE_INT),
  makeProp(max,FIELDTYPE_INT),
  makeProp(level,FIELDTYPE_INT),
  makeProp(ticks,FIELDTYPE_INT),
  makeProp(tickSize,FIELDTYPE_LONG),
  makeProp(maxLen,FIELDTYPE_INT),
  makeProp(shortTicks,FIELDTYPE_CHAR),
  makeProp(invert,FIELDTYPE_CHAR),
  makeProp(orientation,FIELDTYPE_CHAR),
  makeProp(levelPlace,FIELDTYPE_CHAR),
  makeProp(levelJustify,FIELDTYPE_CHAR),
  makeProp(disabled,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF sliderObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)  
  IF self.min THEN srcGen.componentPropertyInt('SLIDER_Min',self.min)
  IF self.max THEN srcGen.componentPropertyInt('SLIDER_Max',self.max)
  IF self.level THEN srcGen.componentPropertyInt('SLIDER_Level',self.level)
  IF self.ticks THEN srcGen.componentPropertyInt('SLIDER_Ticks',self.ticks)
  IF self.tickSize<>5 THEN srcGen.componentPropertyInt('SLIDER_TickSize',self.tickSize)
  IF self.maxLen<>3 THEN srcGen.componentPropertyInt('SLIDER_LevelMaxLen',self.maxLen)

  IF self.shortTicks THEN srcGen.componentProperty('SLIDER_ShortTick','TRUE',FALSE)
  IF self.invert THEN srcGen.componentProperty('SLIDER_Invert','TRUE',FALSE)
  IF self.orientation<>1 THEN srcGen.componentProperty('SLIDER_Orientation',ListItem(['SORIENT_HORIZ','SORIENT_VERT'],self.orientation),FALSE)

  srcGen.componentProperty('SLIDER_LevelPlace',ListItem(['PLACETEXT_LEFT', 'PLACETEXT_RIGHT'],self.levelPlace),FALSE)
  srcGen.componentProperty('SLIDER_LevelJustify',ListItem(['SLJ_LEFT', 'SLJ_CENTER', 'SLJ_RIGHT'],self.levelJustify),FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF sliderObject
  srcGen.componentAddChildLabel(self.name)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC getTypeName() OF sliderObject
  RETURN 'Slider'
ENDPROC

EXPORT PROC createSliderObject(parent)
  DEF slider:PTR TO sliderObject
  
  NEW slider.create(parent)
ENDPROC slider
