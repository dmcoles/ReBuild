OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'radiobutton','gadgets/radiobutton',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*listPicker','*stringlist','*reactionListObject','*reactionLists','*sourceGen'

EXPORT ENUM RADIOGAD_LISTSELECT, RADIOGAD_LABELPLACE,
      RADIOGAD_SPACING, RADIOGAD_SELECTED,
      RADIOGAD_OK, RADIOGAD_CHILD, RADIOGAD_CANCEL
      

CONST NUM_RADIO_GADS=RADIOGAD_CANCEL+1

EXPORT OBJECT radioObject OF reactionObject
  listObjectId:LONG
  labelPlace:INT
  spacing:INT
  selected:INT
PRIVATE
  labels1:PTR TO LONG
ENDOBJECT

OBJECT radioSettingsForm OF reactionForm
PRIVATE
  radioObject:PTR TO radioObject
  labels1:PTR TO LONG
  selectedListId:LONG
ENDOBJECT

PROC create() OF radioSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_RADIO_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_RADIO_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Radio Attribute Setting',
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
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        
        LAYOUT_ADDCHILD,  self.gadgetList[ RADIOGAD_LISTSELECT ]:=ButtonObject,
          GA_ID, RADIOGAD_LISTSELECT,
          GA_TEXT, '_Pick a List',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ RADIOGAD_LABELPLACE ]:=ChooserObject,
          GA_ID, RADIOGAD_LABELPLACE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['PLACETEXT_LEFT','PLACETEXT_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_LabelPlace',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ RADIOGAD_SPACING ]:=IntegerObject,
          GA_ID, RADIOGAD_SPACING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Spacing',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ RADIOGAD_SELECTED ]:=IntegerObject,
          GA_ID, RADIOGAD_SELECTED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Selected',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ RADIOGAD_OK ]:=ButtonObject,
          GA_ID, RADIOGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ RADIOGAD_CHILD ]:=ButtonObject,
          GA_ID, RADIOGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ RADIOGAD_CANCEL ]:=ButtonObject,
          GA_ID, RADIOGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[RADIOGAD_LISTSELECT]:={selectList}
  self.gadgetActions[RADIOGAD_CHILD]:={editChildSettings}
  self.gadgetActions[RADIOGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[RADIOGAD_OK]:=MR_OK
ENDPROC

PROC selectList(nself,gadget,id,code) OF radioSettingsForm
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

PROC editChildSettings(nself,gadget,id,code) OF radioSettingsForm
  self:=nself
  self.setBusy()
  self.radioObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF radioSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_RADIO_GADS]
  END self.gadgetActions[NUM_RADIO_GADS]
ENDPROC

PROC editSettings(comp:PTR TO radioObject) OF radioSettingsForm
  DEF res

  self.radioObject:=comp
  self.selectedListId:=comp.listObjectId

  SetGadgetAttrsA(self.gadgetList[ RADIOGAD_LABELPLACE ],0,0,[CHOOSER_SELECTED,comp.labelPlace,0])
  SetGadgetAttrsA(self.gadgetList[ RADIOGAD_SPACING ],0,0,[INTEGER_NUMBER,comp.spacing,0])
  SetGadgetAttrsA(self.gadgetList[ RADIOGAD_SELECTED ],0,0,[INTEGER_NUMBER,comp.selected,0])

  res:=self.showModal()
  IF res=MR_OK
    comp.listObjectId:=self.selectedListId
    comp.labelPlace:=Gets(self.gadgetList[ RADIOGAD_LABELPLACE ],CHOOSER_SELECTED)
    comp.spacing:=Gets(self.gadgetList[ RADIOGAD_SPACING ],INTEGER_NUMBER)
    comp.selected:=Gets(self.gadgetList[ RADIOGAD_SELECTED ],INTEGER_NUMBER)
  ENDIF
ENDPROC res=MR_OK

PROC makeRadioList(id) OF radioObject
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
ENDPROC radioButtonsA(newlist)

EXPORT PROC createPreviewObject(scr) OF radioObject
  self.previewObject:=RadioButtonObject, 
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      RADIOBUTTON_LABELS, self.labels1:=self.makeRadioList(self.listObjectId),
      RADIOBUTTON_LABELPLACE, ListItem([PLACETEXT_LEFT,PLACETEXT_RIGHT],self.labelPlace),
      RADIOBUTTON_SPACING, self.spacing,
      RADIOBUTTON_SELECTED, self.selected,
    RadioButtonEnd

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

EXPORT PROC create(parent) OF radioObject
  self.type:=TYPE_RADIO
  SUPER self.create(parent)
  
  self.listObjectId:=-1
  self.labelPlace:=1
  self.spacing:=1
  self.selected:=0

  self.labels1:=0
  self.libsused:=[TYPE_RADIO]
ENDPROC

PROC end() OF radioObject
  freeRadioButtons( self.labels1 )
ENDPROC

EXPORT PROC editSettings() OF radioObject
  DEF editForm:PTR TO radioSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF radioObject IS
[
  makeProp(listObjectId,FIELDTYPE_LONG),
  makeProp(labelPlace,FIELDTYPE_INT),
  makeProp(spacing,FIELDTYPE_INT),
  makeProp(selected,FIELDTYPE_INT)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF radioObject
  DEF tempStr[200]:STRING

  srcGen.componentPropertyInt('GA_ID',self.id)
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  
  IF self.spacing<>1 THEN srcGen.componentPropertyInt('RADIOBUTTON_Spacing',self.spacing)
  IF self.selected THEN  srcGen.componentPropertyInt('RADIOBUTTON_Selected',self.selected)
  IF self.labelPlace<>1 THEN srcGen.componentProperty('RADIOBUTTON_LabelPlace',ListItem(['PLACETEXT_LEFT','PLACETEXT_RIGHT'],self.labelPlace),FALSE)

  IF self.listObjectId 
    StringF(tempStr,'labels\d',self.id)
    srcGen.componentProperty('RADIOBUTTON_Labels',tempStr,FALSE)
  ENDIF
ENDPROC

EXPORT PROC getTypeName() OF radioObject
  RETURN 'RadioButton'
ENDPROC

EXPORT PROC createRadioObject(parent)
  DEF radio:PTR TO radioObject
  
  NEW radio.create(parent)
ENDPROC radio
