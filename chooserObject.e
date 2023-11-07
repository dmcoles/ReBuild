OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'checkbox','gadgets/checkbox',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*listPicker','*stringlist','*reactionListObject','*reactionLists'

EXPORT ENUM CHOOSER_GAD_NAME, CHOOSER_GAD_LISTSELECT,
      CHOOSER_GAD_MAXLABELS, CHOOSER_GAD_ACTIVE, CHOOSER_GAD_WIDTH,
      CHOOSER_GAD_READONLY, CHOOSER_GAD_DISABLED, CHOOSER_GAD_AUTOFIT, 
      CHOOSER_GAD_POPUP, CHOOSER_GAD_DROPDOWN, 
      CHOOSER_GAD_OK, CHOOSER_GAD_CHILD, CHOOSER_GAD_CANCEL
      

CONST NUM_CHOOSER_GADS=CHOOSER_GAD_CANCEL+1

EXPORT OBJECT chooserObject OF reactionObject
  listObjectId:LONG
  maxLabels:INT
  active:INT
  width:INT
  readOnly:CHAR
  disabled:CHAR
  autofit:CHAR
  popup:CHAR
  dropdown:CHAR
  labels1:PTR TO LONG
ENDOBJECT

OBJECT chooserSettingsForm OF reactionForm
  chooserObject:PTR TO chooserObject
  selectedListId:LONG
ENDOBJECT

PROC create() OF chooserSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_CHOOSER_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_CHOOSER_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Chooser Attribute Setting',
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

          LAYOUT_ADDCHILD, self.gadgetList[ CHOOSER_GAD_NAME ]:=StringObject,
            GA_ID, CHOOSER_GAD_NAME,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_TEXTVAL, '_Chooser1',
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Name',
          LabelEnd,
          
          LAYOUT_ADDCHILD,  self.gadgetList[ CHOOSER_GAD_LISTSELECT ]:=ButtonObject,
            GA_ID, CHOOSER_GAD_LISTSELECT,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CHOOSER_GAD_MAXLABELS ]:=IntegerObject,
            GA_ID, CHOOSER_GAD_MAXLABELS,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Max Labels',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHOOSER_GAD_ACTIVE ]:=IntegerObject,
            GA_ID, CHOOSER_GAD_ACTIVE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Active',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHOOSER_GAD_WIDTH ]:=IntegerObject,
            GA_ID, CHOOSER_GAD_WIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, -1,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Width',
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

          LAYOUT_ADDCHILD, self.gadgetList[ CHOOSER_GAD_READONLY ]:=CheckBoxObject,
            GA_ID, CHOOSER_GAD_READONLY,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_ReadOnly',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ CHOOSER_GAD_DISABLED ]:=CheckBoxObject,
            GA_ID, CHOOSER_GAD_DISABLED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Disabled',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ CHOOSER_GAD_AUTOFIT ]:=CheckBoxObject,
            GA_ID, CHOOSER_GAD_AUTOFIT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Auto_Fit',
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

          LAYOUT_ADDCHILD, self.gadgetList[ CHOOSER_GAD_POPUP ]:=CheckBoxObject,
            GA_ID, CHOOSER_GAD_POPUP,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Pop_Up',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ CHOOSER_GAD_DROPDOWN ]:=CheckBoxObject,
            GA_ID, CHOOSER_GAD_DROPDOWN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Dro_pDown',
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CHOOSER_GAD_OK ]:=ButtonObject,
            GA_ID, CHOOSER_GAD_OK,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CHOOSER_GAD_CHILD ]:=ButtonObject,
            GA_ID, CHOOSER_GAD_CHILD,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ CHOOSER_GAD_CANCEL ]:=ButtonObject,
            GA_ID, CHOOSER_GAD_CANCEL,
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

  self.gadgetActions[CHOOSER_GAD_LISTSELECT]:={selectList}
  self.gadgetActions[CHOOSER_GAD_CHILD]:={editChildSettings}
  self.gadgetActions[CHOOSER_GAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[CHOOSER_GAD_OK]:=MR_OK
ENDPROC

PROC selectList(nself,gadget,id,code) OF chooserSettingsForm
  DEF frmListPicker:PTR TO listPickerForm
  DEF res
  
  self:=nself
  
  NEW frmListPicker.create()
  IF (res:=frmListPicker.selectList())<>-1
    self.selectedListId:=res  
  ENDIF
  END frmListPicker
  
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF chooserSettingsForm
  self:=nself
  self.chooserObject.editChildSettings()
ENDPROC

PROC end() OF chooserSettingsForm
  END self.gadgetList[NUM_CHOOSER_GADS]
  END self.gadgetActions[NUM_CHOOSER_GADS]
ENDPROC

PROC editSettings(comp:PTR TO chooserObject) OF chooserSettingsForm
  DEF res

  self.chooserObject:=comp
  self.selectedListId:=comp.listObjectId

  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])

  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_MAXLABELS ],0,0,[INTEGER_NUMBER,comp.maxLabels,0])
  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_ACTIVE ],0,0,[INTEGER_NUMBER,comp.active,0])
  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])

  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0])
  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0])
  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_AUTOFIT ],0,0,[CHECKBOX_CHECKED,comp.autofit,0])
  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_POPUP ],0,0,[CHECKBOX_CHECKED,comp.popup,0])
  SetGadgetAttrsA(self.gadgetList[ CHOOSER_GAD_DROPDOWN ],0,0,[CHECKBOX_CHECKED,comp.dropdown,0])

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ CHOOSER_GAD_NAME ],STRINGA_TEXTVAL))
    comp.listObjectId:=self.selectedListId
    comp.maxLabels:=Gets(self.gadgetList[ CHOOSER_GAD_MAXLABELS ],INTEGER_NUMBER)
    comp.active:=Gets(self.gadgetList[ CHOOSER_GAD_ACTIVE ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ CHOOSER_GAD_WIDTH ],INTEGER_NUMBER)
    
    comp.readOnly:=Gets(self.gadgetList[ CHOOSER_GAD_READONLY ],CHECKBOX_CHECKED)
    comp.disabled:=Gets(self.gadgetList[ CHOOSER_GAD_DISABLED ],CHECKBOX_CHECKED)
    comp.autofit:=Gets(self.gadgetList[ CHOOSER_GAD_AUTOFIT ],CHECKBOX_CHECKED)
    comp.popup:=Gets(self.gadgetList[ CHOOSER_GAD_POPUP ],CHECKBOX_CHECKED)
    comp.dropdown:=Gets(self.gadgetList[ CHOOSER_GAD_DROPDOWN ],CHECKBOX_CHECKED)

  ENDIF
ENDPROC res=MR_OK

PROC makeChooserList(id) OF chooserObject
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
ENDPROC chooserLabelsA(newlist)

EXPORT PROC createPreviewObject() OF chooserObject
  self.previewObject:=ChooserObject, 
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      GA_READONLY, self.readOnly,
      GA_DISABLED, self.disabled,
      CHOOSER_AUTOFIT, self.autofit,
      CHOOSER_POPUP, self.popup,
      CHOOSER_DROPDOWN, self.dropdown,
      CHOOSER_MAXLABELS, self.maxLabels,
      CHOOSER_ACTIVE, self.active,
      CHOOSER_WIDTH, self.width,
      CHOOSER_LABELS, self.labels1:=self.makeChooserList(self.listObjectId),
    ChooserEnd

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

EXPORT PROC create(parent) OF chooserObject
  self.type:=TYPE_CHOOSER
  SUPER self.create(parent)
  
  self.listObjectId:=-1
  self.maxLabels:=12
  self.active:=0
  self.width:=-1
  self.readOnly:=0
  self.disabled:=0
  self.autofit:=0
  self.popup:=TRUE
  self.dropdown:=0

  self.labels1:=0
  self.libused:=LIB_CHOOSER OR LIB_LABEL
ENDPROC

PROC end() OF chooserObject
  freeChooserLabels( self.labels1 )
ENDPROC

EXPORT PROC editSettings() OF chooserObject
  DEF editForm:PTR TO chooserSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF chooserObject IS
[
  makeProp(listObjectId,FIELDTYPE_LONG),
  makeProp(maxLabels,FIELDTYPE_INT),
  makeProp(active,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(autofit,FIELDTYPE_CHAR),
  makeProp(popup,FIELDTYPE_CHAR),
  makeProp(dropdown,FIELDTYPE_CHAR)
]

EXPORT PROC getTypeName() OF chooserObject
  RETURN 'Chooser'
ENDPROC

EXPORT PROC createChooserObject(parent)
  DEF chooser:PTR TO chooserObject
  
  NEW chooser.create(parent)
ENDPROC chooser
