OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/tabs',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'graphics/text',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen','*stringlist'

EXPORT ENUM TABSGAD_DISABLED,
      TABSGAD_OK, TABSGAD_CHILD, TABSGAD_CANCEL

EXPORT DEF tabsbase

CONST NUM_TABS_GADS=TABSGAD_CANCEL+1

EXPORT OBJECT tabsObject OF reactionObject
  disabled:CHAR
  childMaxWidth:CHAR
  current:INT
  labels:PTR TO stringlist
PRIVATE
  tabLabels:PTR TO tablabel
ENDOBJECT

OBJECT tabsSettingsForm OF reactionForm
PRIVATE
  tabsObject:PTR TO tabsObject
ENDOBJECT

PROC create() OF tabsSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_TABS_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_TABS_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Tabs Attribute Setting',
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

      LAYOUT_ADDCHILD, self.gadgetList[ TABSGAD_DISABLED ]:=CheckBoxObject,
        GA_ID, TABSGAD_DISABLED,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_TEXT, 'Disabled',
        ->CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
      CheckBoxEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ TABSGAD_OK ]:=ButtonObject,
          GA_ID, TABSGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TABSGAD_CHILD ]:=ButtonObject,
          GA_ID, TABSGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TABSGAD_CANCEL ]:=ButtonObject,
          GA_ID, TABSGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[TABSGAD_CHILD]:={editChildSettings}
  self.gadgetActions[TABSGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[TABSGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF tabsSettingsForm
  self:=nself
  self.setBusy()
  self.tabsObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF tabsSettingsForm
  END self.gadgetList[NUM_TABS_GADS]
  END self.gadgetActions[NUM_TABS_GADS]
ENDPROC

PROC editSettings(comp:PTR TO tabsObject) OF tabsSettingsForm
  DEF res

  self.tabsObject:=comp
    
  SetGadgetAttrsA(self.gadgetList[ TABSGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.disabled:=Gets(self.gadgetList[ TABSGAD_DISABLED ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF tabsObject
  DEF label:PTR TO tablabel

  IF tabsbase  
    NEW label[3]
    label[0].label:='Display'
    label[0].pen1:=-1
    label[0].pen2:=-1
    label[0].pen3:=-1
    label[0].pen4:=-1
    label[0].attrs:=0

    label[1].label:='Display2'
    label[1].pen1:=-1
    label[1].pen2:=-1
    label[1].pen3:=-1
    label[1].pen4:=-1
    label[1].attrs:=0

    label[2].label:=0
    label[2].pen1:=0
    label[2].pen2:=0
    label[2].pen3:=0
    label[2].pen4:=0
    label[2].attrs:=0
    
    self.tabLabels:=label

    self.previewObject:=NewObjectA(0,'tabs.gadget',[
        GA_DISABLED, self.disabled,
        TABS_LABELS, self.tabLabels,
        LAYOUTA_CHILDMAXWIDTH, self.childMaxWidth,
        TABS_CURRENT, self.current,
      TAG_END])
  ENDIF
  
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

EXPORT PROC create(parent) OF tabsObject
  DEF labels:PTR TO stringlist
  self.type:=TYPE_TABS
  SUPER self.create(parent)
  self.disabled:=0
  self.childMaxWidth:=TRUE
  self.current:=0
  NEW labels.stringlist(10)
  self.labels:=labels
  self.tabLabels:=0
  self.libsused:=[TYPE_TABS]
ENDPROC

PROC end() OF tabsObject
  END self.labels
  IF self.tabLabels THEN END self.tabLabels[3]
ENDPROC

EXPORT PROC editSettings() OF tabsObject
  DEF editForm:PTR TO tabsSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF tabsObject
  RETURN 'Tabs'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF tabsObject IS
[
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(childMaxWidth,FIELDTYPE_CHAR),
  makeProp(current,FIELDTYPE_INT),
  makeProp(labels,FIELDTYPE_STRLIST)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF tabsObject
  srcGen.componentPropertyInt('GA_ID',self.id)
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  ->srcGen.componentProperty('WHEEL_Screen','gScreen',FALSE) 
  ->IF self.bevelBox THEN srcGen.componentProperty('WHEEL_BevelBox','TRUE',FALSE)
ENDPROC

EXPORT PROC createTabsObject(parent)
  DEF tabs:PTR TO tabsObject
  
  NEW tabs.create(parent)
ENDPROC tabs


