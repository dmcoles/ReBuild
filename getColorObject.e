OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/getcolor','getcolor',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen'

EXPORT ENUM GETCOLGAD_NAME, GETCOLGAD_TITLE,GETCOLGAD_COLORWHEEL,GETCOLGAD_RGBSLIDERS,GETCOLGAD_HSBSLIDERS,
      GETCOLGAD_SWITCHMODE, GETCOLGAD_INITIAL, GETCOLGAD_SHOWRGB, GETCOLGAD_SHOWHSB,GETCOLGAD_DISABLED,  
      GETCOLGAD_OK, GETCOLGAD_CHILD, GETCOLGAD_CANCEL

CONST NUM_GETCOL_GADS=GETCOLGAD_CANCEL+1

EXPORT OBJECT getColorObject OF reactionObject
  title[80]:ARRAY OF CHAR
  colorWheel:CHAR
  rgbSliders:CHAR
  hsbSliders:CHAR
  switchMode:CHAR
  initial:CHAR
  showRGB:CHAR
  showHSB:CHAR
  disabled:CHAR
ENDOBJECT

OBJECT getColorSettingsForm OF reactionForm
PRIVATE
  getColorObject:PTR TO getColorObject
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF getColorSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_GETCOL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_GETCOL_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'GetColor Attribute Setting',
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

      LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_NAME ]:=StringObject,
        GA_ID, GETCOLGAD_NAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_GetColor Name',
      LabelEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_TITLE ]:=StringObject,
        GA_ID, GETCOLGAD_TITLE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Title text',
      LabelEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_SPACEINNER, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_COLORWHEEL ]:=CheckBoxObject,
          GA_ID, GETCOLGAD_COLORWHEEL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'ColorWheel',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_RGBSLIDERS ]:=CheckBoxObject,
          GA_ID, GETCOLGAD_RGBSLIDERS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Show RGB Sliders',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_HSBSLIDERS ]:=CheckBoxObject,
          GA_ID, GETCOLGAD_HSBSLIDERS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Show HSB Sliders',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_SPACEINNER, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_SPACEINNER, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_SWITCHMODE ]:=CheckBoxObject,
          GA_ID, GETCOLGAD_SHOWRGB,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Switch Mode',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_INITIAL ]:=ChooserObject,
          GA_ID, GETCOLGAD_INITIAL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['RGB','HSB',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Initial Mode',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_SHOWRGB ]:=CheckBoxObject,
          GA_ID, GETCOLGAD_SHOWRGB,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Show RGB Values',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_SHOWHSB ]:=CheckBoxObject,
          GA_ID, GETCOLGAD_SHOWHSB,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Show HSB Values',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETCOLGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, GETCOLGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETCOLGAD_OK ]:=ButtonObject,
          GA_ID, GETCOLGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETCOLGAD_CHILD ]:=ButtonObject,
          GA_ID, GETCOLGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETCOLGAD_CANCEL ]:=ButtonObject,
          GA_ID, GETCOLGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[GETCOLGAD_CHILD]:={editChildSettings}
  self.gadgetActions[GETCOLGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[GETCOLGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF getColorSettingsForm
  self:=nself
  self.setBusy()
  self.getColorObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF getColorSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_GETCOL_GADS]
  END self.gadgetActions[NUM_GETCOL_GADS]
ENDPROC

PROC editSettings(comp:PTR TO getColorObject) OF getColorSettingsForm
  DEF res

  self.getColorObject:=comp

  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_TITLE ],0,0,[STRINGA_TEXTVAL,comp.title,0])
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_COLORWHEEL ],0,0,[CHECKBOX_CHECKED,comp.colorWheel,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_RGBSLIDERS ],0,0,[CHECKBOX_CHECKED,comp.rgbSliders,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_HSBSLIDERS ],0,0,[CHECKBOX_CHECKED,comp.hsbSliders,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_SWITCHMODE ],0,0,[CHECKBOX_CHECKED,comp.switchMode,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_INITIAL ],0,0,[CHOOSER_SELECTED,comp.initial,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_SHOWRGB ],0,0,[CHECKBOX_CHECKED,comp.showRGB,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_SHOWHSB ],0,0,[CHECKBOX_CHECKED,comp.showHSB,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETCOLGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 

  res:=self.showModal()
  IF res=MR_OK

    AstrCopy(comp.name,Gets(self.gadgetList[ GETCOLGAD_NAME ],STRINGA_TEXTVAL))
    AstrCopy(comp.title,Gets(self.gadgetList[ GETCOLGAD_TITLE ],STRINGA_TEXTVAL))
    comp.colorWheel:=Gets(self.gadgetList[ GETCOLGAD_COLORWHEEL ],CHECKBOX_CHECKED)   
    comp.rgbSliders:=Gets(self.gadgetList[ GETCOLGAD_RGBSLIDERS ],CHECKBOX_CHECKED)   
    comp.hsbSliders:=Gets(self.gadgetList[ GETCOLGAD_HSBSLIDERS ],CHECKBOX_CHECKED)   
    comp.switchMode:=Gets(self.gadgetList[ GETCOLGAD_SWITCHMODE ],CHECKBOX_CHECKED)   
    comp.initial:=Gets(self.gadgetList[ GETCOLGAD_INITIAL ],CHOOSER_SELECTED)
    comp.showRGB:=Gets(self.gadgetList[ GETCOLGAD_SHOWRGB ],CHECKBOX_CHECKED)   
    comp.showHSB:=Gets(self.gadgetList[ GETCOLGAD_SHOWHSB ],CHECKBOX_CHECKED)   
    comp.disabled:=Gets(self.gadgetList[ GETCOLGAD_DISABLED ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF getColorObject
  
  self.previewObject:=0
  IF (getcolorbase)
    self.previewObject:=NewObjectA(GetColor_GetClass(), NIL,[TAG_IGNORE,0,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_DISABLED, self.disabled,
        IF StrLen(self.title) THEN GETCOLOR_TITLETEXT ELSE TAG_IGNORE, self.title,
        GETCOLOR_COLORWHEEL,self.colorWheel,
        GETCOLOR_RGBSLIDERS,self.rgbSliders,
        GETCOLOR_HSBSLIDERS,self.hsbSliders,
        GETCOLOR_SWITCHMODE,self.switchMode,
        GETCOLOR_INITIAL,self.initial,
        GETCOLOR_SHOWRGB,self.showRGB,
        GETCOLOR_SHOWHSB,self.showHSB,
        GETCOLOR_SCREEN,scr,
      TAG_DONE])
  ENDIF
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

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

EXPORT PROC create(parent) OF getColorObject
  self.type:=TYPE_GETCOLOR
  SUPER self.create(parent)

  AstrCopy(self.title,'')
  self.colorWheel:=TRUE
  self.rgbSliders:=TRUE
  self.hsbSliders:=0
  self.switchMode:=TRUE
  self.initial:=0
  self.showRGB:=0
  self.showHSB:=0
  self.disabled:=0
  self.libsused:=[TYPE_GETCOLOR, TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF getColorObject
  DEF editForm:PTR TO getColorSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF getColorObject
  RETURN 'GetColor'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF getColorObject IS
[
  makeProp(title,FIELDTYPE_STR),
  makeProp(colorWheel,FIELDTYPE_CHAR),
  makeProp(rgbSliders,FIELDTYPE_CHAR),
  makeProp(hsbSliders,FIELDTYPE_CHAR),
  makeProp(switchMode,FIELDTYPE_CHAR),
  makeProp(initial,FIELDTYPE_CHAR),
  makeProp(showRGB,FIELDTYPE_CHAR),
  makeProp(showHSB,FIELDTYPE_CHAR),
  makeProp(disabled,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF getColorObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF StrLen(self.title) THEN srcGen.componentProperty('GETCOLOR_TitleText',self.title,TRUE)
  srcGen.componentProperty('GETCOLOR_Screen','gScreen',FALSE)
  IF self.colorWheel THEN srcGen.componentProperty('GETCOLOR_ColorWheel','TRUE',FALSE)
  IF self.rgbSliders=FALSE THEN srcGen.componentProperty('GETCOLOR_RGBSliders','FALSE',FALSE)
  IF self.hsbSliders THEN srcGen.componentProperty('GETCOLOR_HSBSliders','TRUE',FALSE)
  IF self.switchMode=FALSE THEN srcGen.componentProperty('GETCOLOR_SwitchMode','FALSE',FALSE)
  IF self.switchMode
    srcGen.componentPropertyInt('GETCOLOR_Initial',self.initial)
  ENDIF
  IF self.showRGB THEN srcGen.componentProperty('GETCOLOR_ShowRGB','TRUE',FALSE)
  IF self.showHSB THEN srcGen.componentProperty('GETCOLOR_ShowHSB','TRUE',FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF getColorObject
  srcGen.componentAddChildLabel(self.name)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC libTypeCreate() OF getColorObject IS 'GetColor_GetClass()'

EXPORT PROC getTypeEndName() OF getColorObject
  RETURN 'End'
ENDPROC

EXPORT PROC createGetColorObject(parent)
  DEF getcolor:PTR TO getColorObject
  
  NEW getcolor.create(parent)
ENDPROC getcolor


