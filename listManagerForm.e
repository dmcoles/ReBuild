OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'listbrowser','gadgets/listbrowser',
        'string',
        'images/label','label',       
        'images/bevel',
        'gadgets/checkbox','checkbox',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec/nodes','exec/lists'

  MODULE '*reactionForm','*stringlist','*reactionListObject','*reactionLists'

EXPORT ENUM LISTMANAGER_LISTLIST, LISTMANAGER_LISTNAME, LISTMANAGER_ITEMLIST, LISTMANAGER_ITEMNAME, 
    LISTMANAGER_CHOOSER, LISTMANAGER_CLICKTAB, LISTMANAGER_LISTBROWSER, LISTMANAGER_RADIOBTN,
    LISTMANAGER_OK, LISTMANAGER_ADD, LISTMANAGER_MODIFYNAME, LISTMANAGER_DELNAME, LISTMANAGER_DELITEM,
    LISTMANAGER_SORTITEM

CONST NUMGADS=LISTMANAGER_SORTITEM+1

EXPORT OBJECT listManagerForm OF reactionForm
  lists:PTR TO stdlist
  selectedList:LONG
  selectedItem:LONG
  columninfo1[3]:ARRAY OF columninfo
  columninfo2[2]:ARRAY OF columninfo
  browserlist1:PTR TO mlh
  browserlist2:PTR TO mlh
ENDOBJECT

PROC makeItemsList(list:PTR TO reactionListObject) OF listManagerForm
  DEF i,n,win
  freeBrowserNodes(self.browserlist2)
  self.browserlist2:=browserNodesA([0])
  self.selectedItem:=-1

  win:=Gets(self.windowObj,WINDOW_WINDOW)
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  IF list

    FOR i:=0 TO list.items.count()-1
      IF (n:=AllocListBrowserNodeA(1, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, list.items.item(i), TAG_END])) 
        AddTail(self.browserlist2, n)
      ELSE 
        Raise("MEM")    
      ENDIF
    ENDFOR
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist2, GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTNAME],win,0,[STRINGA_TEXTVAL, list.name, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMNAME],win,0,[STRINGA_TEXTVAL, '', GA_DISABLED, FALSE, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_CHOOSER],win,0,[CHECKBOX_CHECKED, list.chooser, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_CLICKTAB],win,0,[CHECKBOX_CHECKED, list.clicktab, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTBROWSER],win,0,[CHECKBOX_CHECKED,list.listbrowser, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_RADIOBTN],win,0,[CHECKBOX_CHECKED,list.radiobutton, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MODIFYNAME],win,0,[GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELNAME],win,0,[GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_SORTITEM],win,0,[GA_DISABLED, FALSE, TAG_END])
  ELSE
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist2, GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTNAME],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMNAME],win,0,[STRINGA_TEXTVAL, '', GA_DISABLED, TRUE, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_CHOOSER],win,0,[CHECKBOX_CHECKED, 0, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_CLICKTAB],win,0,[CHECKBOX_CHECKED, 0, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTBROWSER],win,0,[CHECKBOX_CHECKED,0, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_RADIOBTN],win,0,[CHECKBOX_CHECKED,0, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MODIFYNAME],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELNAME],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_SORTITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
  ENDIF
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist2, TAG_END])
  DoMethod(self.windowObj, WM_RETHINK)
  
ENDPROC

PROC selectList(nself,gadget,id,code) OF listManagerForm
  self:=nself
  self.selectedList:=code
  IF id>=0
    self.makeItemsList(self.lists.item(code))
  ELSE
    self.makeItemsList(0)
  ENDIF
ENDPROC

PROC addList(nself,gadget,id,code) OF listManagerForm
  DEF win,listName,n
  DEF reactionList:PTR TO reactionListObject
  DEF tempStr[4]:STRING
  DEF node:PTR TO ln
  self:=nself

  win:=Gets(self.windowObj,WINDOW_WINDOW)
  
  listName:=Gets(self.gadgetList[LISTMANAGER_LISTNAME],STRINGA_TEXTVAL)
  IF StrLen(listName)>0
    NEW reactionList.create(0)

    AstrCopy(reactionList.name,listName)
    
    reactionList.chooser:=Gets(self.gadgetList[LISTMANAGER_CHOOSER],CHECKBOX_CHECKED)
    reactionList.clicktab:=Gets(self.gadgetList[LISTMANAGER_CLICKTAB],CHECKBOX_CHECKED)
    reactionList.listbrowser:=Gets(self.gadgetList[LISTMANAGER_LISTBROWSER],CHECKBOX_CHECKED)
    reactionList.radiobutton:=Gets(self.gadgetList[LISTMANAGER_RADIOBTN],CHECKBOX_CHECKED)
    self.lists.add(reactionList)
    
    self.selectedList:=self.lists.count()-1
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
    StringF(tempStr,'\d',reactionList.id)
    IF (n:=AllocListBrowserNodeA(2, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, reactionList.name, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, tempStr,TAG_END])) 
      reactionList.listnode:=n
      AddTail(self.browserlist1, n)
    ELSE 
      Raise("MEM")    
    ENDIF
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],win,0,[LISTBROWSER_LABELS, self.browserlist1, LISTBROWSER_SELECTED, self.selectedList, TAG_END])
    self.selectList(self,self.gadgetList[LISTMANAGER_LISTLIST],LISTMANAGER_LISTLIST,self.selectedList)
  ENDIF
ENDPROC

PROC modifyName(nself,gadget,id,code) OF listManagerForm
  DEF win,listName,n
  DEF reactionList:PTR TO reactionListObject
  self:=nself
  
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  reactionList:=self.lists.item(self.selectedList)

  listName:=Gets(self.gadgetList[LISTMANAGER_LISTNAME],STRINGA_TEXTVAL)
  AstrCopy(reactionList.name,listName)
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  SetListBrowserNodeAttrsA(reactionList.listnode,[LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, reactionList.name,TAG_END])
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],win,0,[LISTBROWSER_LABELS, self.browserlist1, TAG_END])
  
ENDPROC

PROC delName(nself,gadget,id,code) OF listManagerForm
  DEF win,listName,n
  DEF node:PTR TO ln
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF self.selectedList>=0
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    reactionList:=self.lists.item(self.selectedList)
    remNode(self.gadgetList[LISTMANAGER_LISTLIST],win,0,reactionList.listnode)

    self.lists.remove(self.selectedList)
    END reactionList
    self.makeItemsList(0)
    DoMethod(self.windowObj, WM_RETHINK)
  ENDIF
ENDPROC

PROC updateFlags(nself,gadget,id,code) OF listManagerForm
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF self.selectedList>=0
    reactionList:=self.lists.item(self.selectedList)
    
    reactionList.chooser:=Gets(self.gadgetList[LISTMANAGER_CHOOSER],CHECKBOX_CHECKED)
    reactionList.clicktab:=Gets(self.gadgetList[LISTMANAGER_CLICKTAB],CHECKBOX_CHECKED)
    reactionList.listbrowser:=Gets(self.gadgetList[LISTMANAGER_LISTBROWSER],CHECKBOX_CHECKED)
    reactionList.radiobutton:=Gets(self.gadgetList[LISTMANAGER_RADIOBTN],CHECKBOX_CHECKED)
   
  ENDIF
ENDPROC

PROC newItem(nself,gadget,id,code) OF listManagerForm
  DEF win,itemName,n
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF self.selectedList>=0
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    reactionList:=self.lists.item(self.selectedList)
    itemName:=Gets(self.gadgetList[LISTMANAGER_ITEMNAME],STRINGA_TEXTVAL)

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
    IF (n:=AllocListBrowserNodeA(1, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, itemName,TAG_END])) 
      AddTail(self.browserlist2, n)
      reactionList.items.add(itemName)
      SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMNAME],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    ELSE 
      Raise("MEM")    
    ENDIF
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist2, TAG_END])

  ENDIF
ENDPROC

PROC selItem(nself,gadget,id,code) OF listManagerForm
  DEF win,itemName,n
  DEF reactionList:PTR TO reactionListObject
  self:=nself
  
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELITEM],win,0,[GA_DISABLED, code<0, TAG_END])
  self.selectedItem:=code
ENDPROC

PROC delItem(nself,gadget,id,code) OF listManagerForm
  DEF win,itemName,n
  DEF node:PTR TO ln
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF (self.selectedList>=0) AND (self.selectedItem>=0)
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    reactionList:=self.lists.item(self.selectedList)
    reactionList.items.remove(self.selectedItem)

    node:=self.browserlist2.head
    n:=self.selectedItem
    WHILE (n>0)
      node:=node.succ
      n--
    ENDWHILE
    remNode(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,node)
    DoMethod(self.windowObj, WM_RETHINK)
  ENDIF
ENDPROC

PROC sortItems(nself,gadget,id,code) OF listManagerForm
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF (self.selectedList>=0)
    reactionList:=self.lists.item(self.selectedList)
    reactionList.items.sort()
    self.makeItemsList(reactionList)
  ENDIF
ENDPROC

EXPORT PROC create() OF listManagerForm
  DEF gads:PTR TO LONG
  DEF i

  self.columninfo1[0].width:=3
  self.columninfo1[0].title:='List Name'
  self.columninfo1[0].flags:=CIF_WEIGHTED

  self.columninfo1[1].width:=1
  self.columninfo1[1].title:='List ID'
  self.columninfo1[1].flags:=CIF_WEIGHTED

  self.columninfo1[2].width:=-1
  self.columninfo1[2].title:=-1
  self.columninfo1[2].flags:=-1

  self.columninfo2[0].width:=1
  self.columninfo2[0].title:='List Items'
  self.columninfo2[0].flags:=CIF_WEIGHTED

  self.columninfo2[1].width:=-1
  self.columninfo2[1].title:=-1
  self.columninfo2[1].flags:=-1

  self.browserlist1:=browserNodesA([0])
  self.browserlist2:=browserNodesA([0])

  NEW gads[NUMGADS]
  self.gadgetList:=gads
  NEW gads[NUMGADS]
  self.gadgetActions:=gads

  self.windowObj:=WindowObject,
    WA_TITLE, 'Lists Manager',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WA_PUBSCREEN, 0,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW,
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
        LAYOUT_SPACEINNER, TRUE,

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
          LAYOUT_SPACEINNER, TRUE,

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
            LAYOUT_SPACEINNER, TRUE,

            LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_LISTLIST ] := ListBrowserObject,
              GA_ID, LISTMANAGER_LISTLIST,
              GA_RELVERIFY, TRUE,
              LISTBROWSER_POSITION, 0,
              LISTBROWSER_SHOWSELECTED, TRUE,
              LISTBROWSER_VERTSEPARATORS, TRUE,
              LISTBROWSER_SEPARATORS, TRUE,
              LISTBROWSER_COLUMNTITLES, TRUE,
              LISTBROWSER_COLUMNINFO, self.columninfo1,
              LISTBROWSER_LABELS, self.browserlist1,
            ListBrowserEnd,

            LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_LISTNAME ] := StringObject,
              GA_ID, LISTMANAGER_LISTNAME,
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
              STRINGA_MAXCHARS, 80,
            StringEnd,
            CHILD_LABEL, LabelObject,
              LABEL_TEXT, '_Name',
            LabelEnd,

          LayoutEnd,

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
            LAYOUT_SPACEINNER, TRUE,

            LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_ITEMLIST ] := ListBrowserObject,
              GA_ID, LISTMANAGER_ITEMLIST,
              GA_RELVERIFY, TRUE,
              GA_DISABLED, TRUE,
              LISTBROWSER_POSITION, 0,
              LISTBROWSER_SHOWSELECTED, TRUE,
              LISTBROWSER_VERTSEPARATORS, TRUE,
              LISTBROWSER_SEPARATORS, TRUE,
              LISTBROWSER_COLUMNTITLES, TRUE,
              LISTBROWSER_COLUMNINFO, self.columninfo2,
              LISTBROWSER_LABELS, self.browserlist2,
            ListBrowserEnd,

            LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_ITEMNAME ] := StringObject,
              GA_ID, LISTMANAGER_ITEMNAME,
              GA_DISABLED, TRUE,
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
              STRINGA_MAXCHARS, 80,
            StringEnd,
            CHILD_LABEL, LabelObject,
              LABEL_TEXT, 'Item',
            LabelEnd,
          LayoutEnd,
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
          LAYOUT_SPACEINNER, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_CHOOSER ] := CheckBoxObject,
            GA_ID, LISTMANAGER_CHOOSER,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Chooser',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_CLICKTAB ] := CheckBoxObject,
            GA_ID, LISTMANAGER_CLICKTAB,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'ClickTab',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_LISTBROWSER ] := CheckBoxObject,
            GA_ID, LISTMANAGER_LISTBROWSER,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'ListBrowser',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTMANAGER_RADIOBTN ] := CheckBoxObject,
            GA_ID, LISTMANAGER_RADIOBTN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'RadioButton',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
        
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
          LAYOUT_SPACEINNER, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_OK ] := ButtonObject,
            GA_ID, LISTMANAGER_OK,
            GA_TEXT, '_Ok',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_ADD ] := ButtonObject,
            GA_ID, LISTMANAGER_ADD,
            GA_TEXT, 'Add',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_MODIFYNAME ] := ButtonObject,
            GA_ID, LISTMANAGER_MODIFYNAME,
            GA_TEXT, '_Modify Name',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_DELNAME ] := ButtonObject,
            GA_ID, LISTMANAGER_DELNAME,
            GA_TEXT, '_Del Name',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_DELITEM ] := ButtonObject,
            GA_ID, LISTMANAGER_DELITEM,
            GA_TEXT, '_Del Item',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_SORTITEM ] := ButtonObject,
            GA_ID, LISTMANAGER_SORTITEM,
            GA_TEXT, '_Sort Item',
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
        CHILD_WEIGHTEDHEIGHT, 0,
        
      LayoutEnd,
    LayoutEnd,
  WindowEnd
  self.gadgetActions[LISTMANAGER_LISTLIST]:={selectList}
  self.gadgetActions[LISTMANAGER_ADD]:={addList}
  self.gadgetActions[LISTMANAGER_MODIFYNAME]:={modifyName}
  self.gadgetActions[LISTMANAGER_DELNAME]:={delName}
  self.gadgetActions[LISTMANAGER_LISTNAME]:={addList}
  self.gadgetActions[LISTMANAGER_ITEMNAME]:={newItem}
  self.gadgetActions[LISTMANAGER_ITEMLIST]:={selItem}
  self.gadgetActions[LISTMANAGER_SORTITEM]:={sortItems}
  self.gadgetActions[LISTMANAGER_DELITEM]:={delItem}
  self.gadgetActions[LISTMANAGER_CHOOSER]:={updateFlags}
  self.gadgetActions[LISTMANAGER_CLICKTAB]:={updateFlags}
  self.gadgetActions[LISTMANAGER_LISTBROWSER]:={updateFlags}
  self.gadgetActions[LISTMANAGER_RADIOBTN]:={updateFlags}
  self.gadgetActions[LISTMANAGER_OK]:=MR_OK
ENDPROC

PROC end() OF listManagerForm
  freeBrowserNodes(self.browserlist1)
  freeBrowserNodes(self.browserlist2)

  END self.gadgetList[NUMGADS] 
  END self.gadgetActions[NUMGADS]
ENDPROC

EXPORT PROC manageLists() OF listManagerForm
  DEF rlist:PTR TO reactionListObject
  DEF i
  DEF tempStr[4]:STRING
  DEF n
  self.lists:=getReactionLists()
  self.selectedList:=-1

  self.makeItemsList(0)

  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],0,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

  FOR i:=0 TO self.lists.count()-1
    rlist:=self.lists.item(i)
    StringF(tempStr,'\d',rlist.id)
    IF (n:=AllocListBrowserNodeA(2, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, rlist.name, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT,tempStr,TAG_END]))
      rlist.listnode:=n
      AddTail(self.browserlist1, n)
    ELSE 
      Raise("MEM")    
    ENDIF
  ENDFOR
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],0,0,[LISTBROWSER_LABELS, self.browserlist1, TAG_END])

  IF self.showModal()=MR_OK
  ENDIF
ENDPROC -1
