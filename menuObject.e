OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'listbrowser','gadgets/listbrowser',
        'images/bevel',
        'string',
        'gadtools',
        'gadgets/checkbox','checkbox',
        'gadgets/chooser','chooser',
        'gadgets/integer','integer',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec/lists','exec/nodes'

  MODULE '*reactionObject','*reactionForm','*stringlist','*fileStreamer','*dialogs'

EXPORT ENUM MENUGAD_ITEMLIST, MENUGAD_ITEM_NAME, MENUGAD_ITEM_COMMKEY, MENUGAD_ITEM_TYPE, MENUGAD_ITEM_MENUBAR,
      MENUGAD_ITEM_CHECK, MENUGAD_ITEM_TOGGLE, MENUGAD_ITEM_CHECKED, MENUGAD_ITEM_DISABLED, MENUGAD_ITEM_MUTUALGROUP, 
      MENUGAD_ADD, MENUGAD_DELETE, MENUGAD_MODIFY, MENUGAD_MOVEUP, MENUGAD_MOVEDOWN, 
      MENUGAD_OK, MENUGAD_CANCEL

CONST NUM_MENU_GADS=MENUGAD_CANCEL+1

EXPORT ENUM MENU_TYPE_MENU, MENU_TYPE_MENUITEM, MENU_TYPE_MENUSUB

EXPORT OBJECT menuItem
  itemName[80]:ARRAY OF CHAR
  commKey[2]:ARRAY OF CHAR
  type:CHAR
  menuBar:CHAR
  check:CHAR
  toggle:CHAR
  checked:CHAR
  disabled:CHAR
  mutualGroup:INT
ENDOBJECT

EXPORT OBJECT menuObject OF reactionObject
  menuItems:PTR TO stdlist
ENDOBJECT

OBJECT menuSettingsForm OF reactionForm
PRIVATE
  menuObject:PTR TO menuObject
  rootLayout:LONG
  selectedItem:LONG
  tempMenuItems:PTR TO stdlist
  columninfo[4]:ARRAY OF columninfo
  browserlist:PTR TO mlh
  labels1:LONG
ENDOBJECT

PROC moveUp(nself,gadget,id,code) OF menuSettingsForm
  DEF tmp,win
  DEF str1a[100]:STRING
  DEF str1b[100]:STRING
  DEF str1c[100]:STRING
  DEF str2a[100]:STRING
  DEF str2b[100]:STRING
  DEF str2c[100]:STRING
  DEF node1,node2,strval
  DEF gen1, gen2
  
  self:=nself
  IF self.selectedItem>=0
    node1:=self.findNode(self.selectedItem-1)
    node2:=self.findNode(self.selectedItem)
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])


    GetListBrowserNodeAttrsA(node1,[LBNA_GENERATION,{gen1},TAG_END])
    GetListBrowserNodeAttrsA(node1,[LBNA_COLUMN,0, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str1a,strval)
    GetListBrowserNodeAttrsA(node1,[LBNA_COLUMN,1, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str1b,strval)
    GetListBrowserNodeAttrsA(node1,[LBNA_COLUMN,2, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str1c,strval)
    GetListBrowserNodeAttrsA(node2,[LBNA_GENERATION,{gen2},TAG_END])
    GetListBrowserNodeAttrsA(node2,[LBNA_COLUMN,0, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str2a,strval)
    GetListBrowserNodeAttrsA(node2,[LBNA_COLUMN,1, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str2b,strval)
    GetListBrowserNodeAttrsA(node2,[LBNA_COLUMN,2, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str2c,strval)

    SetListBrowserNodeAttrsA(node1,[LBNA_FLAGS,0, LBNA_GENERATION,gen2, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str2a, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str2b, LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str2c, TAG_END])
    SetListBrowserNodeAttrsA(node2,[LBNA_FLAGS,0, LBNA_GENERATION,gen1, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str1a, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str1b, LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str1c, TAG_END])
    
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_SELECTEDNODE, node1,0])
    tmp:=self.tempMenuItems.item(self.selectedItem-1)
    self.tempMenuItems.setItem(self.selectedItem-1,self.tempMenuItems.item(self.selectedItem))
    self.tempMenuItems.setItem(self.selectedItem,tmp)

    self.selectItem(self,0,0,self.selectedItem-1)
  ENDIF
ENDPROC

PROC moveDown(nself,gadget,id,code) OF menuSettingsForm
  DEF tmp,win
  DEF str1a[100]:STRING
  DEF str1b[100]:STRING
  DEF str1c[100]:STRING
  DEF str2a[100]:STRING
  DEF str2b[100]:STRING
  DEF str2c[100]:STRING
  DEF node1,node2,strval
  DEF gen1,gen2
  
  self:=nself

  IF self.selectedItem<(self.tempMenuItems.count()-1)
    node1:=self.findNode(self.selectedItem)
    node2:=self.findNode(self.selectedItem+1)
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

    GetListBrowserNodeAttrsA(node1,[LBNA_GENERATION,{gen1},TAG_END])
    GetListBrowserNodeAttrsA(node1,[LBNA_COLUMN,0, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str1a,strval)
    GetListBrowserNodeAttrsA(node1,[LBNA_COLUMN,1, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str1b,strval)
    GetListBrowserNodeAttrsA(node1,[LBNA_COLUMN,2, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str1c,strval)

    GetListBrowserNodeAttrsA(node2,[LBNA_GENERATION,{gen2},TAG_END])
    GetListBrowserNodeAttrsA(node2,[LBNA_COLUMN,0, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str2a,strval)
    GetListBrowserNodeAttrsA(node2,[LBNA_COLUMN,1, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str2b,strval)
    GetListBrowserNodeAttrsA(node2,[LBNA_COLUMN,2, LBNCA_TEXT,{strval},TAG_END])
    StrCopy(str2c,strval)

    SetListBrowserNodeAttrsA(node1,[LBNA_FLAGS,0, LBNA_GENERATION,gen2, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str2a, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str2b, LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str2c, TAG_END])
    SetListBrowserNodeAttrsA(node2,[LBNA_FLAGS,0, LBNA_GENERATION,gen1, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str1a, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str1b, LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, str1c, TAG_END])
    
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_SELECTEDNODE, node2,0])

    tmp:=self.tempMenuItems.item(self.selectedItem)
    self.tempMenuItems.setItem(self.selectedItem,self.tempMenuItems.item(self.selectedItem+1))
    self.tempMenuItems.setItem(self.selectedItem+1,tmp)
    self.selectItem(self,0,0,self.selectedItem+1)
  ENDIF
ENDPROC

PROC deleteItem(nself,gadget,id,code) OF menuSettingsForm
  DEF win,node
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  IF self.selectedItem>=0
    self.tempMenuItems.remove(self.selectedItem)
    node:=Gets(self.gadgetList[MENUGAD_ITEMLIST],LISTBROWSER_SELECTEDNODE)
    remNode(self.gadgetList[MENUGAD_ITEMLIST],win,0,node)
    self.selectItem(self,0,0,-1)
    DoMethod(self.windowObj, WM_RETHINK)
  ENDIF
ENDPROC

PROC modifyItem(nself,gadget,id,code) OF menuSettingsForm
  DEF win,node,strval
  DEF menuItem:PTR TO menuItem
  DEF gen
  DEF type[20]:STRING

  self:=nself
  
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  IF self.selectedItem>=0
    menuItem:=self.tempMenuItems.item(self.selectedItem)
    node:=Gets(self.gadgetList[MENUGAD_ITEMLIST],LISTBROWSER_SELECTEDNODE)

    strval:=Gets(self.gadgetList[ MENUGAD_ITEM_NAME ],STRINGA_TEXTVAL)
    IF StrLen(strval)
      AstrCopy(menuItem.itemName,strval,80)
    ENDIF
  
    strval:=Gets(self.gadgetList[ MENUGAD_ITEM_COMMKEY ],STRINGA_TEXTVAL)
    AstrCopy(menuItem.commKey,strval,2)
    
    menuItem.type:=Gets(self.gadgetList[ MENUGAD_ITEM_TYPE ],CHOOSER_SELECTED)
    menuItem.menuBar:=IF Gets(self.gadgetList[ MENUGAD_ITEM_MENUBAR ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.check:=IF Gets(self.gadgetList[ MENUGAD_ITEM_CHECK ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.toggle:=IF Gets(self.gadgetList[ MENUGAD_ITEM_TOGGLE ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.checked:=IF Gets(self.gadgetList[ MENUGAD_ITEM_CHECKED ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.disabled:=IF Gets(self.gadgetList[ MENUGAD_ITEM_DISABLED ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.mutualGroup:=Gets(self.gadgetList[ MENUGAD_ITEM_MUTUALGROUP ],INTEGER_NUMBER)  

    IF menuItem.type=MENU_TYPE_MENUSUB
      IF menuItem.menuBar THEN StrCopy(type,'Menu bar') ELSE StrCopy(type,'Sub item')
      gen:=2
    ELSEIF menuItem.type=MENU_TYPE_MENUITEM
      IF menuItem.menuBar THEN StrCopy(type,'Menu bar') ELSE StrCopy(type,'Menu item')
      gen:=1
    ELSE
      StrCopy(type,'Menu')
      gen:=0
    ENDIF

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
    SetListBrowserNodeAttrsA(node,[LBNA_FLAGS,0, LBNA_GENERATION, gen, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, menuItem.itemName, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, menuItem.commKey, LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, type,TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  ENDIF
ENDPROC

PROC selectItem(nself,gadget,id,code) OF menuSettingsForm
  DEF win,menuItem:PTR TO menuItem
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  self.selectedItem:=code
  menuItem:=self.tempMenuItems.item(code)
  IF code=-1
    SetGadgetAttrsA(self.gadgetList[MENUGAD_DELETE],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_MODIFY],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_MOVEUP],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_MOVEDOWN],win,0,[GA_DISABLED, TRUE, TAG_END])

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_NAME],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_COMMKEY],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_TYPE],win,0,[CHOOSER_SELECTED, -1, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_MENUBAR],win,0,[CHECKBOX_CHECKED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_CHECK],win,0,[CHECKBOX_CHECKED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_TOGGLE],win,0,[CHECKBOX_CHECKED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_CHECKED],win,0,[CHECKBOX_CHECKED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_DISABLED],win,0,[CHECKBOX_CHECKED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_MUTUALGROUP],0,0,[INTEGER_NUMBER,0,0])
  ELSE
    SetGadgetAttrsA(self.gadgetList[MENUGAD_DELETE],win,0,[GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_MODIFY],win,0,[GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_MOVEUP],win,0,[GA_DISABLED, code=0, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_MOVEDOWN],win,0,[GA_DISABLED, code=(self.tempMenuItems.count()-1), TAG_END])
    
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_NAME],win,0,[STRINGA_TEXTVAL, menuItem.itemName, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_COMMKEY],win,0,[STRINGA_TEXTVAL, menuItem.commKey, TAG_END])

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_TYPE],win,0,[CHOOSER_SELECTED, menuItem.type , TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_MENUBAR],win,0,[CHECKBOX_CHECKED, menuItem.menuBar , TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_CHECK],win,0,[CHECKBOX_CHECKED, menuItem.check , TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_TOGGLE],win,0,[CHECKBOX_CHECKED, menuItem.toggle , TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_CHECKED],win,0,[CHECKBOX_CHECKED, menuItem.checked , TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_DISABLED],win,0,[CHECKBOX_CHECKED, menuItem.disabled , TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_MUTUALGROUP],0,0,[INTEGER_NUMBER,menuItem.mutualGroup,0])
  ENDIF
  DoMethod(self.windowObj, WM_RETHINK)
ENDPROC

PROC addItem(nself,gadget,id,code) OF menuSettingsForm
  DEF strval
  DEF n,win,gen
  DEF menuItem:PTR TO menuItem
  DEF type[20]:STRING

  self:=nself

  strval:=Gets(self.gadgetList[ MENUGAD_ITEM_NAME ],STRINGA_TEXTVAL)
  IF StrLen(strval)

    win:=Gets(self.windowObj,WINDOW_WINDOW)

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
    NEW menuItem
    AstrCopy(menuItem.itemName,strval,80)
  
    strval:=Gets(self.gadgetList[ MENUGAD_ITEM_COMMKEY ],STRINGA_TEXTVAL)
    AstrCopy(menuItem.commKey,strval,2)
    
    menuItem.type:=Gets(self.gadgetList[ MENUGAD_ITEM_TYPE ],CHOOSER_SELECTED)
    menuItem.menuBar:=IF Gets(self.gadgetList[ MENUGAD_ITEM_MENUBAR ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.check:=IF Gets(self.gadgetList[ MENUGAD_ITEM_CHECK ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.toggle:=IF Gets(self.gadgetList[ MENUGAD_ITEM_TOGGLE ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.checked:=IF Gets(self.gadgetList[ MENUGAD_ITEM_CHECKED ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.disabled:=IF Gets(self.gadgetList[ MENUGAD_ITEM_DISABLED ],CHECKBOX_CHECKED) THEN TRUE ELSE FALSE
    menuItem.mutualGroup:=Gets(self.gadgetList[ MENUGAD_ITEM_MUTUALGROUP ],INTEGER_NUMBER)

    self.tempMenuItems.add(menuItem)
    
    IF menuItem.type=MENU_TYPE_MENUSUB
      IF menuItem.menuBar THEN StrCopy(type,'Menu bar') ELSE StrCopy(type,'Sub item')
      gen:=2
    ELSEIF menuItem.type=MENU_TYPE_MENUITEM
      IF menuItem.menuBar THEN StrCopy(type,'Menu bar') ELSE StrCopy(type,'Menu item')
      gen:=1
    ELSE
      StrCopy(type,'Menu')
      gen:=0
    ENDIF

    IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS,0, LBNA_GENERATION, gen, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, menuItem.itemName, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, menuItem.commKey, LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, type, TAG_END]))
      AddTail(self.browserlist, n)
    ELSE 
      Raise("MEM")    
    ENDIF

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_NAME],win,0,[STRINGA_TEXTVAL, '', TAG_END])

    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],win,0,[LISTBROWSER_SELECTEDNODE, 0,0])
    self.selectItem(self,0,0,-1)

    ->restore type so we can add again quickly
    SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEM_TYPE],win,0,[CHOOSER_SELECTED, menuItem.type , TAG_END])

    IF gadget=self.gadgetList[MENUGAD_ITEM_NAME] THEN ActivateLayoutGadget(self.rootLayout, win, 0, gadget)
  ENDIF
ENDPROC

PROC findNode(n) OF menuSettingsForm
  DEF node:PTR TO ln
  node:=self.browserlist.head
  WHILE (node)
    IF n=0 THEN RETURN node
    n--
    node:=node.succ
  ENDWHILE
ENDPROC 0

PROC create() OF menuSettingsForm
  DEF gads:PTR TO LONG
  DEF menuItems:PTR TO stdlist
  
  NEW menuItems.stdlist(20)
  self.tempMenuItems:=menuItems
  
  NEW gads[NUM_MENU_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_MENU_GADS]
  self.gadgetActions:=gads
  
  self.columninfo[0].width:=3
  self.columninfo[0].title:='Menu Name'
  self.columninfo[0].flags:=CIF_WEIGHTED

  self.columninfo[1].width:=1
  self.columninfo[1].title:='CommKey'
  self.columninfo[1].flags:=CIF_WEIGHTED

  self.columninfo[2].width:=2
  self.columninfo[2].title:='Menu Type'
  self.columninfo[2].flags:=CIF_WEIGHTED

  self.columninfo[3].width:=-1
  self.columninfo[3].title:=-1
  self.columninfo[3].flags:=-1
  self.browserlist:=browserNodesA([0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Menu Setup',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 180,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 180,
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
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDCHILD,self.gadgetList[MENUGAD_ITEMLIST]:=ListBrowserObject,
              GA_ID, MENUGAD_ITEMLIST,
              GA_RELVERIFY, TRUE,
              LISTBROWSER_POSITION, 0,
              LISTBROWSER_SHOWSELECTED, TRUE,
              LISTBROWSER_COLUMNTITLES, TRUE,
              LISTBROWSER_HIERARCHICAL, TRUE,
              LISTBROWSER_COLUMNINFO, self.columninfo,
              LISTBROWSER_LABELS, self.browserlist,
        ListBrowserEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          //LAYOUT_FIXEDHORIZ, FALSE,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_NAME ]:=StringObject,
            GA_ID, MENUGAD_ITEM_NAME,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_MINWIDTH,100,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Name',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_COMMKEY ]:=StringObject,
            GA_ID, MENUGAD_ITEM_COMMKEY,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 2,
          StringEnd,
          CHILD_WEIGHTEDWIDTH,0,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Comm_Key',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_TYPE ]:=ChooserObject,
            GA_ID, MENUGAD_ITEM_TYPE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels1:=chooserLabelsA(['Menu','Menu Item','Menu Sub Item',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Type',
          LabelEnd,

        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_MENUBAR ]:=CheckBoxObject,
            GA_ID, MENUGAD_ITEM_MENUBAR,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Menu _Bar',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_CHECK ]:=CheckBoxObject,
            GA_ID, MENUGAD_ITEM_CHECK,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Check',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_TOGGLE ]:=CheckBoxObject,
            GA_ID, MENUGAD_ITEM_TOGGLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Toggle',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_CHECKED ]:=CheckBoxObject,
            GA_ID, MENUGAD_ITEM_CHECKED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Checked',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ MENUGAD_ITEM_DISABLED ]:=CheckBoxObject,
            GA_ID, MENUGAD_ITEM_DISABLED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Disabled',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_ITEM_MUTUALGROUP ]:=IntegerObject,
            GA_ID, MENUGAD_ITEM_MUTUALGROUP,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Mutual Group',
          LabelEnd,

        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
        
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_ADD ]:=ButtonObject,
            GA_ID, MENUGAD_ADD,
            GA_TEXT, '_Add',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_DELETE ]:=ButtonObject,
            GA_ID, MENUGAD_DELETE,
            GA_TEXT, '_Delete',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_MODIFY ]:=ButtonObject,
            GA_ID, MENUGAD_MODIFY,
            GA_TEXT, '_Modify',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_MOVEUP ]:=ButtonObject,
            GA_ID, MENUGAD_MOVEUP,
            GA_TEXT, 'Move _Up',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_MOVEDOWN ]:=ButtonObject,
            GA_ID, MENUGAD_MOVEDOWN,
            GA_TEXT, 'Move D_own',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
        
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_OK ]:=ButtonObject,
            GA_ID, MENUGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ MENUGAD_CANCEL ]:=ButtonObject,
            GA_ID, MENUGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[MENUGAD_ITEMLIST]:={selectItem}
  self.gadgetActions[MENUGAD_ADD]:={addItem}
  self.gadgetActions[MENUGAD_MOVEUP]:={moveUp}
  self.gadgetActions[MENUGAD_MOVEDOWN]:={moveDown}
  self.gadgetActions[MENUGAD_DELETE]:={deleteItem}
  self.gadgetActions[MENUGAD_MODIFY]:={modifyItem}
  self.gadgetActions[MENUGAD_ITEM_NAME]:={addItem}
  self.gadgetActions[MENUGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[MENUGAD_OK]:={validate}
ENDPROC

PROC end() OF menuSettingsForm
  DEF i
  DEF menuItem:PTR TO menuItem
  FOR i:=0 TO self.tempMenuItems.count()-1
    menuItem:=self.tempMenuItems.item(i)
    END menuItem
  ENDFOR
  END self.tempMenuItems
  freeBrowserNodes(self.browserlist)
  END self.gadgetList[NUM_MENU_GADS]
  END self.gadgetActions[NUM_MENU_GADS]
  freeChooserLabels( self.labels1 ) 
ENDPROC


PROC validate(nself,gadget,id,code) OF menuSettingsForm
  DEF win,menuItem:PTR TO menuItem
  DEF lastWasItem=FALSE
  DEF i

  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  IF self.tempMenuItems.count()>0
    menuItem:=self.tempMenuItems.item(0)
    IF menuItem.type<>MENU_TYPE_MENU
      errorRequest(self.windowObj,'Error','The first item must always be a menu')
      RETURN
    ENDIF
    FOR i:=0 TO self.tempMenuItems.count()-1
      menuItem:=self.tempMenuItems.item(i)
      IF (menuItem.type=MENU_TYPE_MENUSUB) AND (lastWasItem=FALSE)
        errorRequest(self.windowObj,'Error','Sub items must always follow a menu item')
        RETURN
      ENDIF
      lastWasItem:=menuItem.type<>MENU_TYPE_MENU
      
    ENDFOR
  ENDIF
  self.modalResult:=MR_OK
ENDPROC TRUE

PROC editSettings(comp:PTR TO menuObject) OF menuSettingsForm
  DEF res
  DEF i,n
  DEF menuItem:PTR TO menuItem
  DEF type[20]:STRING
  DEF gen

  self.menuObject:=comp
  SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],0,0,[LISTBROWSER_LABELS, -1, TAG_END])
  
  FOR i:=0 TO comp.menuItems.count()-1
    NEW menuItem
    AstrCopy(menuItem.itemName,comp.menuItems.item(i)::menuItem.itemName)
    AstrCopy(menuItem.commKey,comp.menuItems.item(i)::menuItem.commKey,2)
    menuItem.type:=comp.menuItems.item(i)::menuItem.type
    menuItem.menuBar:=comp.menuItems.item(i)::menuItem.menuBar
    menuItem.check:=comp.menuItems.item(i)::menuItem.check
    menuItem.toggle:=comp.menuItems.item(i)::menuItem.toggle
    menuItem.checked:=comp.menuItems.item(i)::menuItem.checked
    menuItem.disabled:=comp.menuItems.item(i)::menuItem.disabled
    menuItem.mutualGroup:=comp.menuItems.item(i)::menuItem.mutualGroup
   
    self.tempMenuItems.add(menuItem)

    IF menuItem.type=MENU_TYPE_MENUSUB
      IF menuItem.menuBar THEN StrCopy(type,'Menu bar') ELSE StrCopy(type,'Sub item')
      gen:=2
    ELSEIF menuItem.type=MENU_TYPE_MENUITEM
      IF menuItem.menuBar THEN StrCopy(type,'Menu bar') ELSE StrCopy(type,'Menu item')
      gen:=1
    ELSE
      StrCopy(type,'Menu')
      gen:=0
    ENDIF

    IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS,0, LBNA_GENERATION, gen, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, menuItem.itemName, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, menuItem.commKey, LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, type, TAG_END]))
      AddTail(self.browserlist, n)
    ELSE 
      Raise("MEM")    
    ENDIF
  
  ENDFOR
  SetGadgetAttrsA(self.gadgetList[MENUGAD_ITEMLIST],0,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  self.selectItem(self,0,0,-1)

  res:=self.showModal()
  IF res=MR_OK
    FOR i:=0 TO comp.menuItems.count()-1 
      menuItem:=comp.menuItems.item(i)
      END menuItem
    ENDFOR
    comp.menuItems.clear()
    FOR i:=0 TO self.tempMenuItems.count()-1
      NEW menuItem
      AstrCopy(menuItem.itemName,self.tempMenuItems.item(i)::menuItem.itemName)
      AstrCopy(menuItem.commKey,self.tempMenuItems.item(i)::menuItem.commKey,2)
      menuItem.type:=self.tempMenuItems.item(i)::menuItem.type
      menuItem.menuBar:=self.tempMenuItems.item(i)::menuItem.menuBar
      menuItem.check:=self.tempMenuItems.item(i)::menuItem.check
      menuItem.toggle:=self.tempMenuItems.item(i)::menuItem.toggle
      menuItem.checked:=self.tempMenuItems.item(i)::menuItem.checked
      menuItem.disabled:=self.tempMenuItems.item(i)::menuItem.disabled
      menuItem.mutualGroup:=self.tempMenuItems.item(i)::menuItem.mutualGroup
      comp.menuItems.add(menuItem)
    ENDFOR

  ENDIF
ENDPROC res=MR_OK

PROC makeMutual(menu:PTR TO menuItem,index) OF menuObject
  DEF i,cnt,res=0,group,menuItem:PTR TO menuItem,currMenu:PTR TO menuItem
  
  
  group:=self.menuItems.item(index)::menuItem.mutualGroup
  
  FOR i:=0 TO self.menuItems.count()-1
    menuItem:=self.menuItems.item(i)
    IF menuItem.type=MENU_TYPE_MENU 
      currMenu:=menuItem
      cnt:=0
    ELSE
      IF (currMenu=menu) AND (i<>index) AND (cnt<32)
        IF menuItem.mutualGroup=group
          res:=res OR (1<<cnt)
        ENDIF
      ENDIF
      cnt++
    ENDIF
  ENDFOR
ENDPROC res

EXPORT PROC createPreviewObject(scr) OF menuObject
  DEF newMenu:PTR TO newmenu
  DEF i,n
  DEF count
  DEF menuItem:PTR TO menuItem
  DEF currMenu:PTR TO menuItem

  IF self.previewObject 
    FreeMenus(self.previewObject)
    self.previewObject:=0
  ENDIF
  count:=self.menuItems.count()
  IF count>0
    menuItem:=self.menuItems.item(0)
    ->first item must be a menu otherwise LayoutMenusA will freeze
    IF (menuItem.type=MENU_TYPE_MENU)
      count++
      newMenu:=New(count*SIZEOF newmenu)
      FOR i:=0 TO count-2
        menuItem:=self.menuItems.item(i)
        IF menuItem.type=MENU_TYPE_MENUSUB
          newMenu[i].mutualexclude:=self.makeMutual(currMenu,i)
          newMenu[i].flags:=(IF menuItem.check THEN CHECKIT ELSE 0) OR
                            (IF menuItem.toggle THEN MENUTOGGLE ELSE 0) OR
                            (IF menuItem.checked THEN CHECKED ELSE 0) OR
                            (IF menuItem.disabled THEN NM_ITEMDISABLED ELSE 0)

          newMenu[i].type:=NM_SUB
          IF menuItem.menuBar THEN newMenu[i].label:=NM_BARLABEL ELSE newMenu[i].label:=menuItem.itemName         
          IF StrLen(menuItem.commKey)
            newMenu[i].commkey:=menuItem.commKey
          ENDIF
        ELSEIF menuItem.type=MENU_TYPE_MENUITEM
          newMenu[i].mutualexclude:=self.makeMutual(currMenu,i)
          newMenu[i].flags:=(IF menuItem.check THEN CHECKIT ELSE 0) OR
                            (IF menuItem.toggle THEN MENUTOGGLE ELSE 0) OR
                            (IF menuItem.checked THEN CHECKED ELSE 0) OR
                            (IF menuItem.disabled THEN NM_ITEMDISABLED ELSE 0)
                            
          newMenu[i].type:=NM_ITEM
          IF menuItem.menuBar THEN newMenu[i].label:=NM_BARLABEL ELSE newMenu[i].label:=menuItem.itemName
          IF StrLen(menuItem.commKey)
            newMenu[i].commkey:=menuItem.commKey
          ENDIF
        ELSE
          currMenu:=menuItem
          newMenu[i].flags:=IF menuItem.disabled THEN NM_MENUDISABLED ELSE 0
          newMenu[i].type:=NM_TITLE
          newMenu[i].label:=menuItem.itemName
          IF StrLen(menuItem.commKey)
            newMenu[i].commkey:=menuItem.commKey
          ENDIF
        ENDIF
      ENDFOR
      newMenu[count-1].type:=NM_END    
      self.previewObject:=CreateMenusA(newMenu,[GTMN_FRONTPEN,1,TAG_END])
      Dispose(newMenu)
    
      IF self.previewObject THEN LayoutMenusA(self.previewObject,self.visInfo,[GTMN_NEWLOOKMENUS,TRUE,TAG_END])
    ENDIF
  ENDIF
ENDPROC

EXPORT PROC create(parent) OF menuObject
  DEF menuItems:PTR TO stdlist
  
  SUPER self.create(parent)
  self.type:=TYPE_MENU
  NEW menuItems.stdlist(10)
  self.menuItems:=menuItems
  
  self.previewObject:=0
  self.createPreviewObject(0)
  self.previewChildAttrs:=0
ENDPROC

EXPORT PROC end() OF menuObject
  IF self.previewObject THEN FreeMenus(self.previewObject)
  self.previewObject:=0
  END self.menuItems
  SUPER self.end()
ENDPROC

EXPORT PROC editSettings() OF menuObject
  DEF editForm:PTR TO menuSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC serialise(fser:PTR TO fileStreamer) OF menuObject
  DEF tempStr[200]:STRING
  DEF menuItem:PTR TO menuItem
  DEF i

  SUPER self.serialise(fser)

  FOR i:=0 TO self.menuItems.count()-1
    menuItem:=self.menuItems.item(i)
    StringF(tempStr,'ITEMNAME: \s',menuItem.itemName)
    fser.writeLine(tempStr)
    StringF(tempStr,'COMMKEY: \s',menuItem.commKey)
    fser.writeLine(tempStr)
    StringF(tempStr,'TYPE: \d',menuItem.type)
    fser.writeLine(tempStr)
    StringF(tempStr,'MENUBAR: \d',menuItem.menuBar)
    fser.writeLine(tempStr)
    StringF(tempStr,'CHECK: \d',menuItem.check)
    fser.writeLine(tempStr)
    StringF(tempStr,'TOGGLE: \d',menuItem.toggle)
    fser.writeLine(tempStr)
    StringF(tempStr,'CHECKED: \d',menuItem.checked)
    fser.writeLine(tempStr)
    StringF(tempStr,'DISABLED: \d',menuItem.disabled)
    fser.writeLine(tempStr)
    StringF(tempStr,'MUTUALGROUP: \d',menuItem.mutualGroup)
    fser.writeLine(tempStr)
  ENDFOR
  fser.writeLine('-')
  self.serialiseChildren(fser)
ENDPROC

EXPORT PROC deserialise(fser:PTR TO fileStreamer) OF menuObject
  DEF tempStr[200]:STRING
  DEF done=FALSE
  DEF i
  DEF menuItem:PTR TO menuItem

  SUPER self.deserialise(fser)

  FOR i:=0 TO self.menuItems.count()-1
    menuItem:=self.menuItems.item(i)
    END menuItem
  ENDFOR
  self.menuItems.clear()

  REPEAT
    IF fser.readLine(tempStr)
      IF StrCmp('-',tempStr)
        done:=TRUE
      ELSEIF StrCmp('ITEMNAME: ',tempStr,STRLEN)
        NEW menuItem
        self.menuItems.add(menuItem)
        AstrCopy(menuItem.itemName,tempStr+STRLEN,80)
      ELSEIF StrCmp('COMMKEY: ',tempStr,STRLEN)
        AstrCopy(menuItem.commKey,tempStr+STRLEN,2)
      ELSEIF StrCmp('TYPE: ',tempStr,STRLEN)
        menuItem.type:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('MENUBAR: ',tempStr,STRLEN)
        menuItem.menuBar:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('CHECK: ',tempStr,STRLEN)
        menuItem.check:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('TOGGLE: ',tempStr,STRLEN)
        menuItem.toggle:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('CHECKED: ',tempStr,STRLEN)
        menuItem.checked:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('DISABLED: ',tempStr,STRLEN)
        menuItem.disabled:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('MUTUALGROUP: ',tempStr,STRLEN)
        menuItem.mutualGroup:=Val(tempStr+STRLEN)
      ENDIF
    ELSE
      done:=TRUE
    ENDIF
  UNTIL done  
ENDPROC

EXPORT PROC getTypeName() OF menuObject
  RETURN 'Menu'
ENDPROC

EXPORT PROC createMenuObject(parent)
  DEF menu:PTR TO menuObject
  
  NEW menu.create(parent)
ENDPROC menu
