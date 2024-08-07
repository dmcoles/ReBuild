OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'bitmap','images/bitmap',
        'string',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'listbrowser','gadgets/listbrowser',
        'speedbar','gadgets/speedbar',
        'images/label','label',
        'amigalib/boopsi',
        'exec/lists',
        'exec/nodes',
        'amigalib/lists',
        'exec/memory',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourcegen','*stringlist','*validator'

EXPORT ENUM SBARGAD_IDENT,SBARGAD_LABEL, SBARGAD_HINT, SBARGAD_BTNLIST, SBARGAD_BUTTON_TEXT, SBARGAD_BUTTON_TYPE, SBARGAD_BUTTON_ADD, SBARGAD_BUTTON_DEL, SBARGAD_ORIENTATION, SBARGAD_BGPEN,
            SBARGAD_STRUMBAR, SBARGAD_BEVELSTYLE,
      SBARGAD_OK, SBARGAD_CHILD, SBARGAD_CANCEL
      

CONST TYPE_TEXT="0"
CONST TYPE_IMAGE="1"

CONST NUM_SBAR_GADS=SBARGAD_CANCEL+1

EXPORT OBJECT speedBarObject OF reactionObject
  orientation:CHAR
  bgPen:INT
  strumBar:CHAR
  bevelStyle:CHAR
  buttonList:PTR TO stringlist
PRIVATE
  buttonLabels:PTR TO stdlist
  buttons:LONG
ENDOBJECT

OBJECT speedBarSettingsForm OF reactionForm
PRIVATE
  speedBarObject:PTR TO speedBarObject
  rootLayout:LONG
  columninfo[3]:ARRAY OF columninfo
  tempItems:PTR TO stringlist
  selectedItem:INT
  tempBgPen:INT
  labels1:LONG
  labels2:LONG
  browserlist:PTR TO mlh
ENDOBJECT

PROC selectItem(nself,gadget,id,code) OF speedBarSettingsForm
  DEF win
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  self.selectedItem:=code
  SetGadgetAttrsA(self.gadgetList[SBARGAD_BUTTON_DEL],win,0,[GA_DISABLED, IF code=-1 THEN TRUE ELSE FALSE, TAG_END])
  DoMethod(self.windowObj, WM_RETHINK)
ENDPROC

PROC addItem(nself,gadget,id,code) OF speedBarSettingsForm
  DEF strval
  DEF n,win
  DEF type
  DEF newval
  DEF typeStr[10]:STRING

  self:=nself

  strval:=Gets(self.gadgetList[ SBARGAD_BUTTON_TEXT ],STRINGA_TEXTVAL)
  IF StrLen(strval)
    newval:=String(StrLen(strval)+1)
    type:=Gets(self.gadgetList[ SBARGAD_BUTTON_TYPE ],CHOOSER_ACTIVE)
    StringF(newval,'\d\s',type,strval)
    self.tempItems.add(newval)

    win:=Gets(self.windowObj,WINDOW_WINDOW)
    SetGadgetAttrsA(self.gadgetList[SBARGAD_BTNLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

    IF type=1
      StrCopy(typeStr,'Image')
    ELSE
      StrCopy(typeStr,'Text')
    ENDIF

    IF (n:=AllocListBrowserNodeA(2, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, strval, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, typeStr, TAG_END]))
      AddTail(self.browserlist, n)
    ELSE 
      Raise("MEM")    
    ENDIF

    SetGadgetAttrsA(self.gadgetList[SBARGAD_BUTTON_TEXT],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    SetGadgetAttrsA(self.gadgetList[SBARGAD_BUTTON_TYPE],win,0,[CHOOSER_ACTIVE, 0, TAG_END])

    SetGadgetAttrsA(self.gadgetList[SBARGAD_BTNLIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
    SetGadgetAttrsA(self.gadgetList[SBARGAD_BTNLIST],win,0,[LISTBROWSER_SELECTEDNODE, 0,0])
    self.selectItem(self,0,0,-1)
    IF gadget=self.gadgetList[SBARGAD_BUTTON_TEXT] THEN ActivateLayoutGadget(self.rootLayout, win, 0, gadget)

  ENDIF
ENDPROC

PROC deleteItem(nself,gadget,id,code) OF speedBarSettingsForm
  DEF win,node
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  IF self.selectedItem>=0
    self.tempItems.remove(self.selectedItem)
    node:=Gets(self.gadgetList[SBARGAD_BTNLIST],LISTBROWSER_SELECTEDNODE)
    remNode(self.gadgetList[SBARGAD_BTNLIST],win,0,node)
    self.selectItem(self,0,0,-1)
    DoMethod(self.windowObj, WM_RETHINK)
  ENDIF
ENDPROC

PROC create() OF speedBarSettingsForm
  DEF gads:PTR TO LONG
  DEF tmpItems:PTR TO stringlist
  
  NEW gads[NUM_SBAR_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_SBAR_GADS]
  self.gadgetActions:=gads
  
  NEW tmpItems.stringlist(10)
  self.tempItems:=tmpItems
  
  self.columninfo[0].width:=3
  self.columninfo[0].title:='Menu Buttons'
  self.columninfo[0].flags:=CIF_WEIGHTED
  
  self.columninfo[1].width:=1
  self.columninfo[1].title:='Type'
  self.columninfo[1].flags:=CIF_WEIGHTED

  self.columninfo[2].width:=-1
  self.columninfo[2].title:=-1
  self.columninfo[2].flags:=-1
  
  self.browserlist:=browserNodesA([0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'SpeedBar Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 450,
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

    WINDOW_PARENTGROUP, self.rootLayout:=VLayoutObject,
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ SBARGAD_IDENT ]:=StringObject,
          GA_ID, SBARGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SBARGAD_LABEL ]:=StringObject,
          GA_ID, SBARGAD_LABEL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Label',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBARGAD_HINT ]:=ButtonObject,
          GA_ID, SBARGAD_HINT,
          GA_TEXT, 'Hint',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,           
        CHILD_WEIGHTEDWIDTH,50,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBARGAD_BGPEN ]:=ButtonObject,
          GA_ID, SBARGAD_BGPEN,
          GA_TEXT, 'Back_groundPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDWIDTH,0,

        LAYOUT_ADDCHILD, self.gadgetList[ SBARGAD_STRUMBAR ]:=CheckBoxObject,
          GA_ID, SBARGAD_STRUMBAR,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'StrumBar',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
        CHILD_WEIGHTEDWIDTH,0,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ SBARGAD_ORIENTATION ]:=ChooserObject,
          GA_ID, SBARGAD_ORIENTATION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['SBORIENT_HORIZ','SBORIENT_VERT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Orientation',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SBARGAD_BEVELSTYLE ]:=ChooserObject,
          GA_ID, SBARGAD_BEVELSTYLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['BVS_NONE', 'BVS_THIN', 'BVS_BUTTON', 'BVS_GROUP','BVS_FIELD','BVS_DROPBOX','BVS_SBAR_HORIZ','BVS_SBAR_VERT','BVS_BOX','BVS_RADIOBUTTON','BVS_STANDARD',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'BevelStyle',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD,self.gadgetList[SBARGAD_BTNLIST]:=ListBrowserObject,
          GA_ID, SBARGAD_BTNLIST,
          GA_RELVERIFY, TRUE,
          LISTBROWSER_POSITION, 0,
          LISTBROWSER_SHOWSELECTED, TRUE,
          LISTBROWSER_COLUMNTITLES, TRUE,
          LISTBROWSER_HIERARCHICAL, FALSE,
          LISTBROWSER_COLUMNINFO, self.columninfo,
          LISTBROWSER_LABELS, self.browserlist,
      ListBrowserEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ SBARGAD_BUTTON_TEXT ]:=StringObject,
          GA_ID, SBARGAD_BUTTON_TEXT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ SBARGAD_BUTTON_TYPE ]:=ChooserObject,
          GA_ID, SBARGAD_BUTTON_TYPE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['Text','Image',0]),
        ChooserEnd,
        CHILD_WEIGHTEDWIDTH,0,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBARGAD_BUTTON_ADD ]:=ButtonObject,
          GA_ID, SBARGAD_BUTTON_ADD,
          GA_TEXT, 'Add',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDWIDTH,0,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBARGAD_BUTTON_DEL ]:=ButtonObject,
          GA_ID, SBARGAD_BUTTON_DEL,
          GA_TEXT, 'Remove',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDWIDTH,0,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBARGAD_OK ]:=ButtonObject,
          GA_ID, SBARGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBARGAD_CHILD ]:=ButtonObject,
          GA_ID, SBARGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBARGAD_CANCEL ]:=ButtonObject,
          GA_ID, SBARGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[SBARGAD_BTNLIST]:={selectItem}
  self.gadgetActions[SBARGAD_BGPEN]:={selectPen}
  self.gadgetActions[SBARGAD_CHILD]:={editChildSettings}
  self.gadgetActions[SBARGAD_HINT]:={editHint}  
  self.gadgetActions[SBARGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[SBARGAD_BUTTON_ADD]:={addItem}
  self.gadgetActions[SBARGAD_BUTTON_DEL]:={deleteItem}
  self.gadgetActions[SBARGAD_BUTTON_TEXT]:={addItem}
  self.gadgetActions[SBARGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF speedBarSettingsForm
  self:=nself
  self.setBusy()
  self.speedBarObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC selectPen(nself,gadget,id,code) OF speedBarSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE SBARGAD_BGPEN
      colourProp:={self.tempBgPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC end() OF speedBarSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeBrowserNodes(self.browserlist)
  END self.tempItems
  
  END self.gadgetList[NUM_SBAR_GADS]
  END self.gadgetActions[NUM_SBAR_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF speedBarSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.speedBarObject,SBARGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editHint(nself,gadget,id,code) OF speedBarSettingsForm
  self:=nself
  self.setBusy()
  self.speedBarObject.editHint()
  self.clearBusy()
  self.updateHint(SBARGAD_HINT, self.speedBarObject.hintText)
ENDPROC

PROC editSettings(comp:PTR TO speedBarObject) OF speedBarSettingsForm
  DEF res,i,n
  DEF typeStr[10]:STRING
  DEF str:PTR TO CHAR

  self.speedBarObject:=comp
    
  self.tempBgPen:=comp.bgPen

  self.updateHint(SBARGAD_HINT, comp.hintText)  
  SetGadgetAttrsA(self.gadgetList[SBARGAD_BTNLIST],0,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  FOR i:=0 TO comp.buttonList.count()-1
    self.tempItems.add(comp.buttonList.item(i))
    str:=comp.buttonList.item(i)
    IF str[0]=TYPE_IMAGE
      StrCopy(typeStr,'Image')
    ELSE
      StrCopy(typeStr,'Text')
    ENDIF
    IF (n:=AllocListBrowserNodeA(2, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, comp.buttonList.item(i)+1, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, typeStr, TAG_END]))
      AddTail(self.browserlist, n)
    ELSE 
      Raise("MEM")    
    ENDIF
  ENDFOR
  SetGadgetAttrsA(self.gadgetList[SBARGAD_BTNLIST],0,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  self.selectItem(self,0,0,-1)

  SetGadgetAttrsA(self.gadgetList[ SBARGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ SBARGAD_LABEL ],0,0,[STRINGA_TEXTVAL,comp.label,0])
  SetGadgetAttrsA(self.gadgetList[ SBARGAD_STRUMBAR ],0,0,[CHECKBOX_CHECKED,comp.strumBar,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBARGAD_ORIENTATION ],0,0,[CHOOSER_SELECTED,comp.orientation,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBARGAD_BEVELSTYLE ],0,0,[CHOOSER_SELECTED,comp.bevelStyle,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ SBARGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.label,Gets(self.gadgetList[ SBARGAD_LABEL ],STRINGA_TEXTVAL))
    comp.bgPen:=self.tempBgPen
    comp.strumBar:=Gets(self.gadgetList[ SBARGAD_STRUMBAR ],CHECKBOX_CHECKED)   
    comp.orientation:=Gets(self.gadgetList[ SBARGAD_ORIENTATION ],CHOOSER_SELECTED)   
    comp.bevelStyle:=Gets(self.gadgetList[ SBARGAD_BEVELSTYLE ],CHOOSER_SELECTED)
    comp.buttonList.clear()
    FOR i:=0 TO self.tempItems.count()-1 DO comp.buttonList.add(self.tempItems.item(i))
  ENDIF
ENDPROC res=MR_OK

PROC freeButtons(list:PTR TO lh) OF speedBarObject
  DEF node:PTR TO ln
  DEF nextnode:PTR TO ln
  DEF i
  
  FOR i:=0 TO self.buttonLabels.count()-1
    DisposeObject(self.buttonLabels.item(i))
  ENDFOR
  self.buttonLabels.clear()
  
  IF list
    node:= list.head
   WHILE (nextnode := node.succ)
    FreeSpeedButtonNode(node)
      node := nextnode
   ENDWHILE
   FreeMem(list,SIZEOF lh)
  ENDIF
ENDPROC

PROC makeButtons(scr) OF speedBarObject
  DEF list:PTR TO lh
  DEF node:PTR TO ln
  DEF label
  DEF i,n=0
  DEF str:PTR TO CHAR

  self.freeButtons(self.buttons)

  IF (list:=AllocMem( SIZEOF lh, MEMF_PUBLIC ))
    newList(list)
    
    FOR i:=0 TO self.buttonList.count()-1
      str:=self.buttonList.item(i)
      IF str[0]=TYPE_IMAGE
        label:=BitMapObject,
            BITMAP_SOURCEFILE, self.buttonList.item(i)+1,
            BITMAP_SCREEN,scr,
            BitMapEnd
      ELSE
        label:=LabelObject,
            LABEL_TEXT, self.buttonList.item(i)+1,
            LabelEnd
      ENDIF
      self.buttonLabels.add(label)
          
      IF (node:=AllocSpeedButtonNodeA(
        i,[SBNA_IMAGE, label,
        SBNA_ENABLED, TRUE,
        SBNA_SPACING, 2,
        SBNA_HIGHLIGHT, SBH_RECESS,
        TAG_DONE]))=FALSE

        self.freeButtons(self.buttons)
        RETURN NIL
      ENDIF
      AddTail(list,node)
    ENDFOR
  ENDIF
ENDPROC list

EXPORT PROC createPreviewObject(scr) OF speedBarObject
  self.previewObject:=0
  IF (speedbarbase)
    self.previewObject:=SpeedBarObject,
        GA_ID, self.id,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        SPEEDBAR_ORIENTATION, ListItem([SBORIENT_HORIZ,SBORIENT_VERT],self.orientation),
        SPEEDBAR_BACKGROUND, self.bgPen,
        SPEEDBAR_STRUMBAR, self.strumBar,
        SPEEDBAR_BEVELSTYLE, ListItem([BVS_NONE, BVS_THIN, BVS_BUTTON, BVS_GROUP,BVS_FIELD,BVS_DROPBOX,BVS_SBAR_HORIZ,BVS_SBAR_VERT,BVS_BOX,BVS_RADIOBUTTON,BVS_STANDARD],self.bevelStyle),
        SPEEDBAR_BUTTONS, self.buttons:=self.makeButtons(scr),
      SpeedBarEnd
  ENDIF
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)
  self.makePreviewChildAttrs(self.label)

ENDPROC

EXPORT PROC create(parent) OF speedBarObject
  DEF buttons:PTR TO stringlist
  DEF buttonLabels:PTR TO stdlist
  self.type:=TYPE_SPEEDBAR
  SUPER self.create(parent)

  self.orientation:=0
  self.bgPen:=0
  self.strumBar:=FALSE
  self.bevelStyle:=2
  NEW buttons.stringlist(10)
  self.buttonList:=buttons
  NEW buttonLabels.stdlist(10)
  self.buttonLabels:=buttonLabels
  self.libsused:=[TYPE_SPEEDBAR,TYPE_LABEL, TYPE_BITMAP]
ENDPROC

PROC end() OF speedBarObject
  END self.buttonList
  self.freeButtons(self.buttons)
  END self.buttonLabels
  SUPER self.end()
ENDPROC

EXPORT PROC editSettings() OF speedBarObject
  DEF editForm:PTR TO speedBarSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF speedBarObject
  RETURN 'SpeedBar'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF speedBarObject IS
[
  makeProp(orientation,FIELDTYPE_CHAR),
  makeProp(bgPen,FIELDTYPE_INT),
  makeProp(strumBar,FIELDTYPE_CHAR),
  makeProp(bevelStyle,FIELDTYPE_CHAR),
  makeProp(buttonList,FIELDTYPE_STRLIST)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF speedBarObject
  DEF tempStr[200]:STRING

  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)

  IF self.bgPen<>0 THEN srcGen.componentPropertyInt('SPEEDBAR_Background',self.bgPen)

  IF self.orientation<>0 THEN srcGen.componentProperty('SPEEDBAR_Orientation',ListItem(['SBORIENT_HORIZ','SBORIENT_VERT'],self.orientation),FALSE)
  IF self.strumBar THEN srcGen.componentProperty('SPEEDBAR_StrumBar','TRUE',FALSE)
  IF self.bevelStyle<>2 THEN srcGen.componentProperty('SPEEDBAR_BevelStyle',ListItem(['BVS_NONE', 'BVS_THIN', 'BVS_BUTTON', 'BVS_GROUP','BVS_FIELD','BVS_DROPBOX','BVS_SBAR_HORIZ','BVS_SBAR_VERT','BVS_BOX','BVS_RADIOBUTTON','BVS_STANDARD'],self.bevelStyle),FALSE)

  StringF(tempStr,'buttons\d',self.id)
  srcGen.componentProperty('SPEEDBAR_Buttons',tempStr,FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF speedBarObject
  srcGen.componentAddChildLabel(self.label)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC createSpeedBarObject(parent)
  DEF speedbar:PTR TO speedBarObject
  
  NEW speedbar.create(parent)
ENDPROC speedbar


