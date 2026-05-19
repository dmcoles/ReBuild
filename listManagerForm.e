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
    LISTMANAGER_OK, LISTMANAGER_ADD, LISTMANAGER_MODIFYNAME, LISTMANAGER_DELNAME, 
    LISTMANAGER_ADDITEM, LISTMANAGER_INSERTITEM, LISTMANAGER_MODIFYITEM, LISTMANAGER_DELITEM,
    LISTMANAGER_MOVEUP, LISTMANAGER_MOVEDOWN,LISTMANAGER_SORTITEM

CONST NUMGADS=LISTMANAGER_SORTITEM+1

EXPORT OBJECT listManagerForm OF reactionForm
PRIVATE
  rootLayout:LONG
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
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist2,LISTBROWSER_SELECTED, -1,GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTNAME],win,0,[STRINGA_TEXTVAL, list.name, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMNAME],win,0,[STRINGA_TEXTVAL, '', GA_DISABLED, FALSE, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MODIFYNAME],win,0,[GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELNAME],win,0,[GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ADD],win,0,[GA_DISABLED, FALSE, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ADDITEM],win,0,[GA_DISABLED, FALSE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_INSERTITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MODIFYITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MOVEUP],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MOVEDOWN],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_SORTITEM],win,0,[GA_DISABLED, FALSE, TAG_END])
  ELSE
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, self.browserlist2, LISTBROWSER_SELECTED, -1, GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTNAME],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMNAME],win,0,[STRINGA_TEXTVAL, '', GA_DISABLED, TRUE, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MODIFYNAME],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELNAME],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ADD],win,0,[GA_DISABLED, FALSE, TAG_END])

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ADDITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_INSERTITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MODIFYITEM],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MOVEUP],win,0,[GA_DISABLED, TRUE, TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MOVEDOWN],win,0,[GA_DISABLED, TRUE, TAG_END])
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
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTNAME],win,0,[STRINGA_TEXTVAL,'',TAG_END])
    IF gadget=self.gadgetList[LISTMANAGER_LISTNAME] THEN ActivateLayoutGadget(self.rootLayout, win,0,gadget)
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

PROC insertItem(nself,gadget,id,code) OF listManagerForm
  DEF win,itemName,n
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF self.selectedList>=0
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    reactionList:=self.lists.item(self.selectedList)
    itemName:=Gets(self.gadgetList[LISTMANAGER_ITEMNAME],STRINGA_TEXTVAL)

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

    n:=self.selectedItem
    reactionList.items.insert(n,itemName)
    self.makeItemsList(self.lists.item(self.selectedList))

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMNAME],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_SELECTED,n,TAG_END])
    
    IF gadget=self.gadgetList[LISTMANAGER_ITEMNAME] THEN ActivateLayoutGadget(self.rootLayout, win, 0, gadget)
  ENDIF
ENDPROC

PROC modifyItem(nself,gadget,id,code) OF listManagerForm
  DEF win,itemName,n
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF self.selectedList>=0
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    reactionList:=self.lists.item(self.selectedList)
    itemName:=Gets(self.gadgetList[LISTMANAGER_ITEMNAME],STRINGA_TEXTVAL)

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

    n:=self.selectedItem
    reactionList.items.setItem(n,itemName)
    self.makeItemsList(self.lists.item(self.selectedList))

    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMNAME],win,0,[STRINGA_TEXTVAL, '', TAG_END])
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_SELECTED,n,TAG_END])
    self.selItem(nself,self.gadgetList[LISTMANAGER_ITEMLIST],LISTMANAGER_ITEMLIST,n)
  ENDIF
ENDPROC

PROC moveItemUp(nself,gadget,id,code) OF listManagerForm
  DEF win,n
  DEF reactionList:PTR TO reactionListObject
  DEF item1,item2
  self:=nself

  IF self.selectedList>=0
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    reactionList:=self.lists.item(self.selectedList)

    n:=self.selectedItem
    item1:=StrClone(reactionList.items.item(n-1))
    item2:=StrClone(reactionList.items.item(n))

    reactionList.items.setItem(n-1,item2)
    reactionList.items.setItem(n,item1)
    DisposeLink(item1)
    DisposeLink(item2)
    
    self.makeItemsList(self.lists.item(self.selectedList))
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_SELECTED,n-1,TAG_END])
    self.selItem(nself,self.gadgetList[LISTMANAGER_ITEMLIST],LISTMANAGER_ITEMLIST,n-1)
  ENDIF
ENDPROC

PROC moveItemDown(nself,gadget,id,code) OF listManagerForm
  DEF win,n
  DEF reactionList:PTR TO reactionListObject
  DEF item1,item2
  self:=nself

  IF self.selectedList>=0
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    reactionList:=self.lists.item(self.selectedList)

    n:=self.selectedItem
    item1:=StrClone(reactionList.items.item(n))
    item2:=StrClone(reactionList.items.item(n+1))

    reactionList.items.setItem(n,item2)
    reactionList.items.setItem(n+1,item1)
    DisposeLink(item1)
    DisposeLink(item2)
    
    self.makeItemsList(self.lists.item(self.selectedList))
    SetGadgetAttrsA(self.gadgetList[LISTMANAGER_ITEMLIST],win,0,[LISTBROWSER_SELECTED,n+1,TAG_END])
    self.selItem(nself,self.gadgetList[LISTMANAGER_ITEMLIST],LISTMANAGER_ITEMLIST,n+1)
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
    IF gadget=self.gadgetList[LISTMANAGER_ITEMNAME] THEN ActivateLayoutGadget(self.rootLayout, win, 0, gadget)
  ENDIF
ENDPROC

PROC selItem(nself,gadget,id,code) OF listManagerForm
  DEF win,itemName,n
  DEF reactionList:PTR TO reactionListObject
  self:=nself
  
  reactionList:=self.lists.item(self.selectedList)
  
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_DELITEM],win,0,[GA_DISABLED, code<0, TAG_END])
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_INSERTITEM],win,0,[GA_DISABLED, code<0, TAG_END])
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MODIFYITEM],win,0,[GA_DISABLED, code<0, TAG_END])
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MOVEUP],win,0,[GA_DISABLED, code<1, TAG_END])
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_MOVEDOWN],win,0,[GA_DISABLED, code>=(reactionList.items.count()-1), TAG_END])
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

PROC sorted(items:PTR TO stringlist) OF listManagerForm
  DEF i
  FOR i:=1 TO items.count()-1
    IF StrCompare(items.item(i-1),items.item(i))>0 THEN RETURN FALSE
  ENDFOR
ENDPROC TRUE

PROC sortItems(nself,gadget,id,code) OF listManagerForm
  DEF reactionList:PTR TO reactionListObject
  self:=nself

  IF (self.selectedList>=0)
    reactionList:=self.lists.item(self.selectedList)
    IF self.sorted(reactionList.items)
      reactionList.items.reverse()
    ELSE
      reactionList.items.sort()
    ENDIF
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
    WA_HEIGHT, 180,
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
    WINDOW_PARENTGROUP, self.rootLayout:=VLayoutObject,
      LAYOUT_SPACEOUTER, TRUE,
      LAYOUT_DEFERLAYOUT, TRUE,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

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

          LAYOUT_ADDCHILD, LayoutObject,
            LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_ADD ] := ButtonObject,
              GA_ID, LISTMANAGER_ADD,
              GA_TEXT, 'Add',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_MODIFYNAME ] := ButtonObject,
              GA_ID, LISTMANAGER_MODIFYNAME,
              GA_TEXT, '_Modify',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_DELNAME ] := ButtonObject,
              GA_ID, LISTMANAGER_DELNAME,
              GA_TEXT, '_Delete',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,
          LayoutEnd,
          CHILD_WEIGHTEDHEIGHT, 0,
      
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

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

          LAYOUT_ADDCHILD, LayoutObject,
            LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
            LAYOUT_FIXEDVERT, FALSE,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_ADDITEM ] := ButtonObject,
              GA_ID, LISTMANAGER_ADDITEM,
              GA_TEXT, 'Add',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_INSERTITEM ] := ButtonObject,
              GA_ID, LISTMANAGER_INSERTITEM,
              GA_TEXT, 'Insert',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_MODIFYITEM ] := ButtonObject,
              GA_ID, LISTMANAGER_MODIFYITEM,
              GA_TEXT, 'Modify',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_DELITEM ] := ButtonObject,
              GA_ID, LISTMANAGER_DELITEM,
              GA_TEXT, '_Delete',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

          LayoutEnd,
          LAYOUT_ADDCHILD, LayoutObject,
            LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
            LAYOUT_FIXEDVERT, FALSE,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_MOVEUP ] := ButtonObject,
              GA_ID, LISTMANAGER_MOVEUP,
              GA_TEXT, 'Up',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_MOVEDOWN ] := ButtonObject,
              GA_ID, LISTMANAGER_MOVEDOWN,
              GA_TEXT, 'Down',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,

            LAYOUT_ADDCHILD,  self.gadgetList[ LISTMANAGER_SORTITEM ] := ButtonObject,
              GA_ID, LISTMANAGER_SORTITEM,
              GA_TEXT, '_Sort',
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
            ButtonEnd,
          LayoutEnd,

        LayoutEnd,
      LayoutEnd,    
    LayoutEnd,
  WindowEnd
  self.gadgetActions[LISTMANAGER_LISTLIST]:={selectList}
  self.gadgetActions[LISTMANAGER_ADD]:={addList}
  self.gadgetActions[LISTMANAGER_MODIFYNAME]:={modifyName}
  self.gadgetActions[LISTMANAGER_DELNAME]:={delName}
  self.gadgetActions[LISTMANAGER_LISTNAME]:={addList}
  self.gadgetActions[LISTMANAGER_ITEMNAME]:={newItem}
  self.gadgetActions[LISTMANAGER_ADDITEM]:={newItem}
  self.gadgetActions[LISTMANAGER_INSERTITEM]:={insertItem}
  self.gadgetActions[LISTMANAGER_MODIFYITEM]:={modifyItem}
  self.gadgetActions[LISTMANAGER_ITEMLIST]:={selItem}
  self.gadgetActions[LISTMANAGER_MOVEUP]:={moveItemUp}
  self.gadgetActions[LISTMANAGER_MOVEDOWN]:={moveItemDown}
  self.gadgetActions[LISTMANAGER_SORTITEM]:={sortItems}
  self.gadgetActions[LISTMANAGER_DELITEM]:={delItem}
  self.gadgetActions[LISTMANAGER_OK]:=MR_OK
ENDPROC

PROC end() OF listManagerForm
  freeBrowserNodes(self.browserlist1)
  freeBrowserNodes(self.browserlist2)

  END self.gadgetList[NUMGADS] 
  END self.gadgetActions[NUMGADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC manageLists() OF listManagerForm
  DEF rlist:PTR TO reactionListObject
  DEF i
  DEF tempStr[4]:STRING
  DEF n
  DEF hintInfo:PTR TO hintinfo
  self.lists:=getReactionLists()
  self.selectedList:=-1

  self.makeItemsList(0)

  hintInfo:=New(SIZEOF hintinfo*13)
  hintInfo[0].gadgetid:=LISTMANAGER_ADD
  hintInfo[0].code:=-1
  hintInfo[0].flags:=0
  hintInfo[0].text:='Add a new list'

  hintInfo[1].gadgetid:=LISTMANAGER_MODIFYNAME
  hintInfo[1].code:=-1
  hintInfo[1].flags:=0
  hintInfo[1].text:='Update the name of the selected list'

  hintInfo[2].gadgetid:=LISTMANAGER_DELNAME
  hintInfo[2].code:=-1
  hintInfo[2].flags:=0
  hintInfo[2].text:='Remove the selected list entirely'

  hintInfo[3].gadgetid:=LISTMANAGER_ADDITEM
  hintInfo[3].code:=-1
  hintInfo[3].flags:=0
  hintInfo[3].text:='Add a new list item'

  hintInfo[4].gadgetid:=LISTMANAGER_INSERTITEM
  hintInfo[4].code:=-1
  hintInfo[4].flags:=0
  hintInfo[4].text:='Insert a new list item'

  hintInfo[5].gadgetid:=LISTMANAGER_MODIFYITEM
  hintInfo[5].code:=-1
  hintInfo[5].flags:=0
  hintInfo[5].text:='Update currently selected list item'

  hintInfo[6].gadgetid:=LISTMANAGER_DELITEM
  hintInfo[6].code:=-1
  hintInfo[6].flags:=0
  hintInfo[6].text:='Delete the currently selected list item'

  hintInfo[7].gadgetid:=LISTMANAGER_DELITEM
  hintInfo[7].code:=-1
  hintInfo[7].flags:=0
  hintInfo[7].text:='Move the currently selected list item up'

  hintInfo[8].gadgetid:=LISTMANAGER_DELITEM
  hintInfo[8].code:=-1
  hintInfo[8].flags:=0
  hintInfo[8].text:='Move the currently selected list item down'

  hintInfo[10].gadgetid:=LISTMANAGER_SORTITEM
  hintInfo[10].code:=-1
  hintInfo[10].flags:=0
  hintInfo[10].text:='Sort the currently selected list'


  hintInfo[11].gadgetid:=LISTMANAGER_LISTNAME
  hintInfo[11].code:=-1
  hintInfo[11].flags:=0
  hintInfo[11].text:='Enter the list name here'

  hintInfo[12].gadgetid:=LISTMANAGER_ITEMNAME
  hintInfo[12].code:=-1
  hintInfo[12].flags:=0
  hintInfo[12].text:='Enter the list item name here'
  
  Sets(self.windowObj,WINDOW_HINTINFO,hintInfo)
  Sets(self.windowObj,WINDOW_GADGETHELP, TRUE)

  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],0,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

  FOR i:=0 TO self.lists.count()-1
    rlist:=self.lists.item(i)
    StringF(tempStr,'\d',rlist.id)
    IF (n:=AllocListBrowserNodeA(2, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, rlist.name, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT,tempStr,TAG_END]))
      rlist.listnode:=n
      AddTail(self.browserlist1, n)
    ELSE 
      Dispose(hintInfo)
      Raise("MEM")    
    ENDIF
  ENDFOR
  SetGadgetAttrsA(self.gadgetList[LISTMANAGER_LISTLIST],0,0,[LISTBROWSER_LABELS, self.browserlist1, TAG_END])

  self.showModal()
  Dispose(hintInfo)
ENDPROC -1
