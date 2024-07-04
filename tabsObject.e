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
        'gadgets/integer','integer',
        'images/label','label',
        'graphics/text',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen','*stringlist','*listPicker','*reactionListObject','*reactionLists','*validator'

EXPORT ENUM TABSGAD_IDENT, TABSGAD_LISTSELECT, TABSGAD_DISABLED, TABSGAD_CHILDMAXWIDTH, TABSGAD_CURRENT,
      TABSGAD_OK, TABSGAD_CHILD, TABSGAD_CANCEL

EXPORT DEF tabsbase

CONST NUM_TABS_GADS=TABSGAD_CANCEL+1

EXPORT OBJECT tabsObject OF reactionObject
  listObjectId:LONG
  disabled:CHAR
  childMaxWidth:CHAR
  current:INT
PRIVATE
  tabLabels:PTR TO tablabel
ENDOBJECT

OBJECT tabsSettingsForm OF reactionForm
PRIVATE
  tabsObject:PTR TO tabsObject
  selectedListId:LONG  
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

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TABSGAD_IDENT ]:=StringObject,
          GA_ID, TABSGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TABSGAD_LISTSELECT ]:=ButtonObject,
          GA_ID, TABSGAD_LISTSELECT,
          GA_TEXT, '_Pick a List',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ TABSGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, TABSGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TABSGAD_CHILDMAXWIDTH ]:=CheckBoxObject,
          GA_ID, TABSGAD_CHILDMAXWIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Child Max Width',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TABSGAD_CURRENT ]:=IntegerObject,
          GA_ID, TABSGAD_CURRENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Current',
        LabelEnd,
      LayoutEnd,

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

  self.gadgetActions[TABSGAD_LISTSELECT]:={selectList}
  self.gadgetActions[TABSGAD_CHILD]:={editChildSettings}
  self.gadgetActions[TABSGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[TABSGAD_OK]:=MR_OK
ENDPROC


PROC selectList(nself,gadget,id,code) OF tabsSettingsForm
  DEF frmListPicker:PTR TO listPickerForm
  DEF res
  
  self:=nself
  
  self.setBusy()
  NEW frmListPicker.create()
  IF (res:=frmListPicker.selectList())<>-1
    self.selectedListId:=res  
  ENDIF
  END frmListPicker
  self.clearBusy()
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

EXPORT PROC canClose(modalRes) OF tabsSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.tabsObject,TABSGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO tabsObject) OF tabsSettingsForm
  DEF res

  self.tabsObject:=comp
  self.selectedListId:=comp.listObjectId    
  SetGadgetAttrsA(self.gadgetList[ TABSGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ TABSGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 
  SetGadgetAttrsA(self.gadgetList[ TABSGAD_CHILDMAXWIDTH ],0,0,[CHECKBOX_CHECKED,comp.childMaxWidth,0]) 
  SetGadgetAttrsA(self.gadgetList[ TABSGAD_CURRENT ],0,0,[INTEGER_NUMBER,comp.current,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ TABSGAD_IDENT ],STRINGA_TEXTVAL))
    comp.listObjectId:=self.selectedListId
    comp.disabled:=Gets(self.gadgetList[ TABSGAD_DISABLED ],CHECKBOX_CHECKED)   
    comp.childMaxWidth:=Gets(self.gadgetList[ TABSGAD_CHILDMAXWIDTH ],CHECKBOX_CHECKED)   
    comp.current:=Gets(self.gadgetList[ TABSGAD_CURRENT ],INTEGER_NUMBER)   
  ENDIF
ENDPROC res=MR_OK

PROC makeTabsList(id) OF tabsObject
  DEF i,res,count
  DEF reactionList=0:PTR TO reactionListObject
  DEF findObject:PTR TO reactionListObject
  DEF newlist
  DEF reactionLists:PTR TO stdlist
  DEF label:PTR TO tablabel
  
  reactionLists:=getReactionLists()
  FOR i:=0 TO reactionLists.count()-1
    findObject:=reactionLists.item(i)
    IF findObject.id = id
      reactionList:=findObject
    ENDIF
  ENDFOR
  
  IF reactionList
    newlist:=List(reactionList.items.count()+1)
    FOR i:=0 TO reactionList.items.count()-1
      ListAddItem(newlist,reactionList.items.item(i))
    ENDFOR
  ELSE
    newlist:=List(1)
  ENDIF
  ListAddItem(newlist,0)
  count:=ListLen(newlist)
  label:=New(SIZEOF tablabel*count)
  count--
  res:=label
  FOR i:=0 TO count-1
    label[i].label:=ListItem(newlist,i)
    label[i].pen1:=-1
    label[i].pen2:=-1
    label[i].pen3:=-1
    label[i].pen4:=-1
    label[i].attrs:=0
  ENDFOR
  label[count].label:=0
  label[count].pen1:=0
  label[count].pen2:=0
  label[count].pen3:=0
  label[count].pen4:=0
  label[count].attrs:=0
  
  DisposeLink(newlist)
ENDPROC res

EXPORT PROC createPreviewObject(scr) OF tabsObject
  IF self.tabLabels THEN Dispose(self.tabLabels)
  self.tabLabels:=0
  
  IF tabsbase  
    self.previewObject:=NewObjectA(0,'tabs.gadget',[
        GA_DISABLED, self.disabled,
        TABS_LABELS, self.tabLabels:=self.makeTabsList(self.listObjectId),
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
    CHILD_NOMINALSIZE, self.nominalSize,
    CHILD_WEIGHTMINIMUM, self.weightMinimum,
    IF self.weightBar THEN LAYOUT_WEIGHTBAR ELSE TAG_IGNORE, 1,
    TAG_END]
ENDPROC

EXPORT PROC create(parent) OF tabsObject
  DEF labels:PTR TO stringlist
  self.type:=TYPE_TABS
  SUPER self.create(parent)
  self.disabled:=0
  self.childMaxWidth:=TRUE
  self.current:=0
  self.tabLabels:=0
  self.listObjectId:=-1
  self.libsused:=[TYPE_TABS]
ENDPROC

PROC end() OF tabsObject
  IF self.tabLabels THEN Dispose(self.tabLabels)
  SUPER self.end()
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
  makeProp(listObjectId,FIELDTYPE_LONG)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF tabsObject
  DEF tempStr[255]:STRING
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF self.childMaxWidth=FALSE THEN srcGen.componentProperty('LAYOUTA_ChildMaxWidth','FALSE',FALSE)
  IF self.current THEN srcGen.componentPropertyInt('TABS_Current',self.current)

  IF self.listObjectId>=0
    StringF(tempStr,'labels\d',self.id)
    srcGen.componentProperty('TABS_Labels',tempStr,FALSE)
  ENDIF
ENDPROC

EXPORT PROC libNameCreate() OF tabsObject IS 'tabs.gadget'
EXPORT PROC hasCreateMacro() OF tabsObject IS FALSE

EXPORT PROC getTypeEndName() OF tabsObject
  RETURN 'End'
ENDPROC

EXPORT PROC createTabsObject(parent)
  DEF tabs:PTR TO tabsObject
  
  NEW tabs.create(parent)
ENDPROC tabs


