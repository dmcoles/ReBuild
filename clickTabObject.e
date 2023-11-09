OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'checkbox','gadgets/checkbox',
        'clicktab','gadgets/clicktab',
        'gadgets/integer','integer',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*listPicker','*stringlist','*reactionListObject','*reactionLists','*sourceGen'

EXPORT ENUM CLICKTAB_GAD_LISTSELECT,
      CLICKTAB_GAD_TOP, CLICKTAB_GAD_LEFT, CLICKTAB_GAD_HEIGHT,
      CLICKTAB_GAD_CURRENT, CLICKTAB_GAD_DISABLED, 
      CLICKTAB_GAD_OK, CLICKTAB_GAD_CHILD, CLICKTAB_GAD_CANCEL
      

CONST NUM_CLICKTAB_GADS=CLICKTAB_GAD_CANCEL+1

EXPORT OBJECT clickTabObject OF reactionObject
  listObjectId:LONG
  top:INT
  left:INT
  height:INT
  current:INT
  disabled:CHAR
  labels1:PTR TO LONG
ENDOBJECT

OBJECT clickTabSettingsForm OF reactionForm
  clickTabObject:PTR TO clickTabObject
  selectedListId:LONG
ENDOBJECT

PROC create() OF clickTabSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_CLICKTAB_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_CLICKTAB_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'ClickTab Attribute Setting',
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

        LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_LISTSELECT ]:=ButtonObject,
          GA_ID, CLICKTAB_GAD_LISTSELECT,
          GA_TEXT, '_Pick a List',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,

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

          LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_TOP ]:=IntegerObject,
            GA_ID, CLICKTAB_GAD_TOP,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Top',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_LEFT ]:=IntegerObject,
            GA_ID, CLICKTAB_GAD_LEFT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Left',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_HEIGHT ]:=IntegerObject,
            GA_ID, CLICKTAB_GAD_HEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Hei_ght',
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_CURRENT ]:=IntegerObject,
            GA_ID, CLICKTAB_GAD_CURRENT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Cur_rent',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ CLICKTAB_GAD_DISABLED ]:=CheckBoxObject,
            GA_ID, CLICKTAB_GAD_DISABLED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Disabled',
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_OK ]:=ButtonObject,
            GA_ID, CLICKTAB_GAD_OK,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_CHILD ]:=ButtonObject,
            GA_ID, CLICKTAB_GAD_CHILD,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CLICKTAB_GAD_CANCEL ]:=ButtonObject,
            GA_ID, CLICKTAB_GAD_CANCEL,
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

  self.gadgetActions[CLICKTAB_GAD_LISTSELECT]:={selectList}
  self.gadgetActions[CLICKTAB_GAD_CHILD]:={editChildSettings}
  self.gadgetActions[CLICKTAB_GAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[CLICKTAB_GAD_OK]:=MR_OK
ENDPROC

PROC selectList(nself,gadget,id,code) OF clickTabSettingsForm
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

PROC editChildSettings(nself,gadget,id,code) OF clickTabSettingsForm
  self:=nself
  self.setBusy()
  self.clickTabObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF clickTabSettingsForm
  END self.gadgetList[NUM_CLICKTAB_GADS]
  END self.gadgetActions[NUM_CLICKTAB_GADS]
ENDPROC

PROC editSettings(comp:PTR TO clickTabObject) OF clickTabSettingsForm
  DEF res

  self.clickTabObject:=comp
  self.selectedListId:=comp.listObjectId

  SetGadgetAttrsA(self.gadgetList[ CLICKTAB_GAD_TOP ],0,0,[INTEGER_NUMBER,comp.top,0])
  SetGadgetAttrsA(self.gadgetList[ CLICKTAB_GAD_LEFT ],0,0,[INTEGER_NUMBER,comp.left,0])
  SetGadgetAttrsA(self.gadgetList[ CLICKTAB_GAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])
  SetGadgetAttrsA(self.gadgetList[ CLICKTAB_GAD_CURRENT ],0,0,[INTEGER_NUMBER,comp.current,0])

  SetGadgetAttrsA(self.gadgetList[ CLICKTAB_GAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0])

  res:=self.showModal()
  IF res=MR_OK
    comp.listObjectId:=self.selectedListId
    comp.top:=Gets(self.gadgetList[ CLICKTAB_GAD_TOP ],INTEGER_NUMBER)
    comp.left:=Gets(self.gadgetList[ CLICKTAB_GAD_LEFT ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ CLICKTAB_GAD_HEIGHT ],INTEGER_NUMBER)
    comp.current:=Gets(self.gadgetList[ CLICKTAB_GAD_CURRENT ],INTEGER_NUMBER)
    
    comp.disabled:=Gets(self.gadgetList[ CLICKTAB_GAD_DISABLED ],CHECKBOX_CHECKED)

  ENDIF
ENDPROC res=MR_OK

PROC makeClickTabsList(id) OF clickTabObject
  DEF i
  DEF reactionList=0:PTR TO reactionListObject
  DEF findObject:PTR TO reactionListObject
  DEF newlist
  DEF reactionLists:PTR TO stdlist
  
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
    ListAddItem(newlist,0)
  ELSE
    newlist:=[0]
  ENDIF
ENDPROC clickTabsA(newlist)

EXPORT PROC createPreviewObject(scr) OF clickTabObject
  self.previewObject:=ClickTabObject, 
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      GA_DISABLED, self.disabled,
      GA_TOP, self.top,
      GA_LEFT, self.left,
      GA_HEIGHT, self.height,
      CLICKTAB_CURRENT, self.current,
      CLICKTAB_LABELS, self.labels1:=self.makeClickTabsList(self.listObjectId),
   ClickTabEnd

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

EXPORT PROC create(parent) OF clickTabObject
  self.type:=TYPE_CLICKTAB
  SUPER self.create(parent)
  
  self.listObjectId:=-1
  self.top:=0
  self.left:=0
  self.height:=0
  self.current:=0
  self.disabled:=0

  self.labels1:=0
  self.libused:=LIB_CLICKTAB
ENDPROC

PROC end() OF clickTabObject
  freeClickTabs( self.labels1 )
ENDPROC

EXPORT PROC editSettings() OF clickTabObject
  DEF editForm:PTR TO clickTabSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF clickTabObject IS
[
  makeProp(listObjectId,FIELDTYPE_LONG),
  makeProp(top,FIELDTYPE_INT),
  makeProp(left,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(current,FIELDTYPE_INT),
  makeProp(disabled,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF clickTabObject
  DEF tempStr[200]:STRING

  srcGen.componentPropertyInt('GA_ID',self.id)
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  
  srcGen.componentPropertyInt('GA_Left',self.left)
  srcGen.componentPropertyInt('GA_Top',self.top)
  srcGen.componentPropertyInt('GA_Height',self.height)
  IF self.current THEN srcGen.componentPropertyInt('CLICKTAB_Current',self.current)

  IF self.listObjectId 
    StringF(tempStr,'labels\d',self.id)
    srcGen.componentProperty('CLICKTAB_Labels',tempStr,FALSE)
  ENDIF
ENDPROC

EXPORT PROC getTypeName() OF clickTabObject
  RETURN 'ClickTab'
ENDPROC

EXPORT PROC createClickTabObject(parent)
  DEF clickTab:PTR TO clickTabObject
  
  NEW clickTab.create(parent)
ENDPROC clickTab
