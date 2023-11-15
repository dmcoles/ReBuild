OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/checkbox','checkbox',
        'gadgets/chooser','chooser',
        'gadgets/integer','integer',
        'gadgets/tapedeck',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen'

EXPORT ENUM TAPEGAD_ANIM,TAPEGAD_MODE,TAPEGAD_FRAMES,TAPEGAD_CURRFRAME,
      TAPEGAD_OK, TAPEGAD_CHILD, TAPEGAD_CANCEL
      
EXPORT DEF tapedeckbase


CONST NUM_TAPE_GADS=TAPEGAD_CANCEL+1

EXPORT OBJECT tapeDeckObject OF reactionObject
  anim:CHAR
  mode:CHAR
  frames:CHAR
  currFrame:CHAR
ENDOBJECT

OBJECT tapeDeckSettingsForm OF reactionForm
PRIVATE
  tapeDeckObject:PTR TO tapeDeckObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
ENDOBJECT

PROC create() OF tapeDeckSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_TAPE_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_TAPE_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'TapeDeck Attribute Setting',
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
        LAYOUT_ADDCHILD, self.gadgetList[ TAPEGAD_ANIM ]:=ChooserObject,
          GA_ID, TAPEGAD_MODE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['Tape','Animation',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Type',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TAPEGAD_MODE ]:=ChooserObject,
          GA_ID, TAPEGAD_MODE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['BUT_REWIND','BUT_PLAY', 'BUT_FORWARD', 'BUT_STOP', 'BUT_PAUSE',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Mode',
        LabelEnd,
      LayoutEnd,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ TAPEGAD_FRAMES ]:=IntegerObject,
            GA_ID, TAPEGAD_FRAMES,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 2,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 99,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Frames',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ TAPEGAD_CURRFRAME ]:=IntegerObject,
            GA_ID, TAPEGAD_CURRFRAME,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 2,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 99,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Current Frame',
          LabelEnd,
        LayoutEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ TAPEGAD_OK ]:=ButtonObject,
          GA_ID, TAPEGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TAPEGAD_CHILD ]:=ButtonObject,
          GA_ID, TAPEGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TAPEGAD_CANCEL ]:=ButtonObject,
          GA_ID, TAPEGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[TAPEGAD_CHILD]:={editChildSettings}
  self.gadgetActions[TAPEGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[TAPEGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF tapeDeckSettingsForm
  self:=nself
  self.setBusy()
  self.tapeDeckObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF tapeDeckSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_TAPE_GADS]
  END self.gadgetActions[NUM_TAPE_GADS]
ENDPROC

PROC editSettings(comp:PTR TO tapeDeckObject) OF tapeDeckSettingsForm
  DEF res

  self.tapeDeckObject:=comp
    
  SetGadgetAttrsA(self.gadgetList[ TAPEGAD_ANIM ],0,0,[CHOOSER_SELECTED,comp.anim,0]) 
  SetGadgetAttrsA(self.gadgetList[ TAPEGAD_MODE ],0,0,[CHOOSER_SELECTED,comp.mode,0]) 
  SetGadgetAttrsA(self.gadgetList[ TAPEGAD_FRAMES ],0,0,[INTEGER_NUMBER,comp.frames,0]) 
  SetGadgetAttrsA(self.gadgetList[ TAPEGAD_CURRFRAME ],0,0,[INTEGER_NUMBER,comp.currFrame,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.anim:=Gets(self.gadgetList[ TAPEGAD_ANIM ],CHOOSER_SELECTED)   
    comp.mode:=Gets(self.gadgetList[ TAPEGAD_MODE ],CHOOSER_SELECTED)   
    comp.frames:=Gets(self.gadgetList[ TAPEGAD_FRAMES ],INTEGER_NUMBER)   
    comp.currFrame:=Gets(self.gadgetList[ TAPEGAD_CURRFRAME ],INTEGER_NUMBER)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF tapeDeckObject
  IF (tapedeckbase=0)
    self.previewObject:=self.createErrorObject(scr)
  ELSE
    self.previewObject:=NewObjectA( NIL, 'tapedeck.gadget',[TAG_IGNORE,0,
      TDECK_TAPE, ListItem([TRUE,FALSE],self.anim),
      TDECK_MODE, ListItem([BUT_REWIND,BUT_PLAY, BUT_FORWARD, BUT_STOP, BUT_PAUSE],self.mode),
      TDECK_FRAMES, self.frames,
      TDECK_CURRENTFRAME, self.currFrame,
      TAG_END])
  ENDIF
    
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

EXPORT PROC create(parent) OF tapeDeckObject
  self.type:=TYPE_TAPEDECK
  SUPER self.create(parent)
  self.anim:=0
  self.mode:=3
  self.frames:=10
  self.currFrame:=0
  self.libsused:=[TYPE_TAPEDECK]
ENDPROC

EXPORT PROC editSettings() OF tapeDeckObject
  DEF editForm:PTR TO tapeDeckSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF tapeDeckObject
  RETURN 'TapeDeck'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF tapeDeckObject IS
[
  makeProp(anim,FIELDTYPE_CHAR),
  makeProp(mode,FIELDTYPE_CHAR),
  makeProp(frames,FIELDTYPE_CHAR),
  makeProp(currFrame,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF tapeDeckObject
  srcGen.componentPropertyInt('GA_ID',self.id)
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  
  srcGen.componentProperty('TDECK_Tape',ListItem(['TRUE','FALSE'],self.anim),FALSE)
  srcGen.componentProperty('TDECK_Mode',ListItem(['BUT_REWIND','BUT_PLAY', 'BUT_FORWARD', 'BUT_STOP', 'BUT_PAUSE'],self.mode),FALSE)
  IF self.anim
    srcGen.componentPropertyInt('TDECK_Frames',self.frames)
    srcGen.componentPropertyInt('TDECK_CurrentFrame',self.currFrame)
  ENDIF

ENDPROC

EXPORT PROC libNameCreate() OF tapeDeckObject IS 'tapedeck.gadget'

EXPORT PROC createTapeDeckObject(parent)
  DEF tapeDeck:PTR TO tapeDeckObject
  
  NEW tapeDeck.create(parent)
ENDPROC tapeDeck


