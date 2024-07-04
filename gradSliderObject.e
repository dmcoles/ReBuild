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
        'gadgets/gradientslider',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen','*validator'

EXPORT ENUM GRADSLDGAD_IDENT, GRADSLDGAD_NAME, GRADSLDGAD_MAXVAL,GRADSLDGAD_CURRVAL,GRADSLDGAD_SKIPVAL,GRADSLDGAD_KNOBPIXELS,GRADSLDGAD_ORIENTATION,
      GRADSLDGAD_OK, GRADSLDGAD_CHILD, GRADSLDGAD_CANCEL
      
EXPORT DEF gradientsliderbase

CONST NUM_GRADSLD_GADS=GRADSLDGAD_CANCEL+1

EXPORT OBJECT gradSliderObject OF reactionObject
  maxVal:LONG
  currVal:LONG
  skipVal:LONG
  knobPixels:INT
  orientation:CHAR
ENDOBJECT

OBJECT gradSliderSettingsForm OF reactionForm
PRIVATE
  gradSliderObject:PTR TO gradSliderObject
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF gradSliderSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_GRADSLD_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_GRADSLD_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Gradient Slider Attribute Setting',
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


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GRADSLDGAD_IDENT ]:=StringObject,
          GA_ID, GRADSLDGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GRADSLDGAD_NAME ]:=StringObject,
          GA_ID, GRADSLDGAD_NAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Label',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GRADSLDGAD_MAXVAL ]:=IntegerObject,
          GA_ID, GRADSLDGAD_MAXVAL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 5,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 65535,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Max Value',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GRADSLDGAD_CURRVAL ]:=IntegerObject,
          GA_ID, GRADSLDGAD_CURRVAL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 5,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 65535,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Current Value',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GRADSLDGAD_SKIPVAL ]:=IntegerObject,
          GA_ID, GRADSLDGAD_SKIPVAL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 5,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 65535,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Skip Value',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GRADSLDGAD_KNOBPIXELS ]:=IntegerObject,
          GA_ID, GRADSLDGAD_KNOBPIXELS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 5,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 65535,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Knob Pixels',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GRADSLDGAD_ORIENTATION ]:=ChooserObject,
          GA_ID, GRADSLDGAD_ORIENTATION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['LORIENT_HORIZ','LORIENT_VERT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Or_ientation',
        LabelEnd,
      LayoutEnd,
      
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GRADSLDGAD_OK ]:=ButtonObject,
          GA_ID, GRADSLDGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GRADSLDGAD_CHILD ]:=ButtonObject,
          GA_ID, GRADSLDGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GRADSLDGAD_CANCEL ]:=ButtonObject,
          GA_ID, GRADSLDGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[GRADSLDGAD_CHILD]:={editChildSettings}
  self.gadgetActions[GRADSLDGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[GRADSLDGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF gradSliderSettingsForm
  self:=nself
  self.setBusy()
  self.gradSliderObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF gradSliderSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_GRADSLD_GADS]
  END self.gadgetActions[NUM_GRADSLD_GADS]
ENDPROC

EXPORT PROC canClose(modalRes) OF gradSliderSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.gradSliderObject,GRADSLDGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO gradSliderObject) OF gradSliderSettingsForm
  DEF res

  self.gradSliderObject:=comp

  SetGadgetAttrsA(self.gadgetList[ GRADSLDGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ GRADSLDGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ GRADSLDGAD_MAXVAL ],0,0,[INTEGER_NUMBER,comp.maxVal,0])
  SetGadgetAttrsA(self.gadgetList[ GRADSLDGAD_CURRVAL ],0,0,[INTEGER_NUMBER,comp.currVal,0])
  SetGadgetAttrsA(self.gadgetList[ GRADSLDGAD_SKIPVAL],0,0,[INTEGER_NUMBER,comp.skipVal,0])
  SetGadgetAttrsA(self.gadgetList[ GRADSLDGAD_KNOBPIXELS ],0,0,[INTEGER_NUMBER,comp.knobPixels,0])
  SetGadgetAttrsA(self.gadgetList[ GRADSLDGAD_ORIENTATION ],0,0,[CHOOSER_SELECTED,comp.orientation,0])

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ GRADSLDGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.name,Gets(self.gadgetList[ GRADSLDGAD_NAME ],STRINGA_TEXTVAL))
    comp.maxVal:=Gets(self.gadgetList[ GRADSLDGAD_MAXVAL ],INTEGER_NUMBER)
    comp.currVal:=Gets(self.gadgetList[ GRADSLDGAD_CURRVAL ],INTEGER_NUMBER)
    comp.skipVal:=Gets(self.gadgetList[ GRADSLDGAD_SKIPVAL ],INTEGER_NUMBER)
    comp.knobPixels:=Gets(self.gadgetList[ GRADSLDGAD_KNOBPIXELS ],INTEGER_NUMBER)
    comp.orientation:=Gets(self.gadgetList[ GRADSLDGAD_ORIENTATION ],CHOOSER_SELECTED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF gradSliderObject
  self.previewObject:=0
  IF (gradientsliderbase)
    self.previewObject:=GradientObject,
      GRAD_MAXVAL, self.maxVal,
      GRAD_CURVAL, self.currVal,
      GRAD_SKIPVAL, self.skipVal,
      GRAD_KNOBPIXELS, self.knobPixels,
      PGA_FREEDOM, ListItem([LORIENT_HORIZ,LORIENT_VERT],self.orientation),
      GradientSliderEnd
  ENDIF
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

EXPORT PROC create(parent) OF gradSliderObject
  self.type:=TYPE_GRADSLIDER
  SUPER self.create(parent)

  self.maxVal:=65535
  self.currVal:=0
  self.skipVal:=1000
  self.knobPixels:=5
  self.orientation:=0
  self.libsused:=[TYPE_GRADSLIDER]
ENDPROC

EXPORT PROC editSettings() OF gradSliderObject
  DEF editForm:PTR TO gradSliderSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF gradSliderObject
  RETURN 'Gradient'
ENDPROC

EXPORT PROC getTypeEndName() OF gradSliderObject
  RETURN 'GradientSliderEnd'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF gradSliderObject IS
[
  makeProp(maxVal,FIELDTYPE_LONG),
  makeProp(currVal,FIELDTYPE_LONG),
  makeProp(skipVal,FIELDTYPE_LONG),
  makeProp(knobPixels,FIELDTYPE_INT),
  makeProp(orientation,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF gradSliderObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  
  IF self.maxVal<>$FFFF THEN srcGen.componentPropertyInt('GRAD_MaxVal',self.maxVal)
  IF self.currVal THEN srcGen.componentPropertyInt('GRAD_CurVal',self.currVal)
  IF self.skipVal<>$1111 THEN srcGen.componentPropertyInt('GRAD_SkipVal',self.skipVal)
  IF self.knobPixels<>5 THEN srcGen.componentPropertyInt('GRAD_KnobPixels',self.knobPixels)
  IF self.orientation THEN srcGen.componentProperty('PGA_FREEDOM','LORIENT_VERT',FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF gradSliderObject
  srcGen.componentAddChildLabel(self.name)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC libNameCreate() OF gradSliderObject IS 'gradientslider.gadget'
  
EXPORT PROC createGradSliderObject(parent)
  DEF gradSlider:PTR TO gradSliderObject
  
  NEW gradSlider.create(parent)
ENDPROC gradSlider


