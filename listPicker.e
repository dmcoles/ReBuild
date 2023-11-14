OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'listbrowser','gadgets/listbrowser',
        'images/bevel',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionForm','*stringlist','*reactionListObject','*reactionLists'

EXPORT ENUM LISTPICK_SELECTOR, LISTPICK_OK, LISTPICK_CANCEL

CONST NUMGADS=LISTPICK_CANCEL+1

EXPORT OBJECT listPickerForm OF reactionForm
PRIVATE
  selectedColour:LONG
  columninfo[3]:ARRAY OF columninfo
  browserlist:PTR TO LONG
  selectedItem:LONG
ENDOBJECT

EXPORT PROC create() OF listPickerForm
  DEF gads:PTR TO LONG
  DEF i
  
  NEW gads[NUMGADS]
  self.gadgetList:=gads
  NEW gads[NUMGADS]
  self.gadgetActions:=gads

  self.columninfo[0].width:=2
  self.columninfo[0].title:='List Name'
  self.columninfo[0].flags:=CIF_WEIGHTED

  self.columninfo[1].width:=1
  self.columninfo[1].title:='List ID'
  self.columninfo[1].flags:=CIF_WEIGHTED


  self.columninfo[2].width:=-1
  self.columninfo[2].title:=-1
  self.columninfo[2].flags:=-1

  self.browserlist:=browserNodesA([0])


  self.windowObj:=WindowObject,
    WA_TITLE, 'Select a List',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 180,
    WA_WIDTH, 350,
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
    WA_NOCAREREFRESH, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,
    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD,self.gadgetList[LISTPICK_SELECTOR]:=ListBrowserObject,
            GA_ID, LISTPICK_SELECTOR,
            GA_RELVERIFY, TRUE,
            LISTBROWSER_POSITION, 0,
            LISTBROWSER_SHOWSELECTED, TRUE,
            LISTBROWSER_VERTSEPARATORS, TRUE,
            LISTBROWSER_SEPARATORS, TRUE,
            LISTBROWSER_COLUMNTITLES, TRUE,
            LISTBROWSER_COLUMNINFO, self.columninfo,
            LISTBROWSER_LABELS, self.browserlist,
      ListBrowserEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,self.gadgetList[LISTPICK_OK]:=ButtonObject,
          GA_ID, LISTPICK_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,self.gadgetList[LISTPICK_CANCEL]:=ButtonObject,
          GA_ID, LISTPICK_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT, 0,
    LayoutEnd,
  WindowEnd
  self.gadgetActions[LISTPICK_SELECTOR]:={selectItem}
  self.gadgetActions[LISTPICK_OK]:=MR_OK
  self.gadgetActions[LISTPICK_CANCEL]:=MR_CANCEL
ENDPROC

PROC end() OF listPickerForm
  freeBrowserNodes(self.browserlist)
  END self.gadgetList[NUMGADS]
  END self.gadgetActions[NUMGADS]
ENDPROC

PROC makeList() OF listPickerForm
  DEF reactionList:PTR TO reactionListObject
  DEF lists:PTR TO stdlist
  DEF tempStr[4]:STRING
  DEF win,i,n
  freeBrowserNodes(self.browserlist)
  
  lists:=getReactionLists()
  
  self.browserlist:=browserNodesA([0])
  self.selectedItem:=-1

  win:=Gets(self.windowObj,WINDOW_WINDOW)
  SetGadgetAttrsA(self.gadgetList[LISTPICK_SELECTOR],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  IF lists

    FOR i:=0 TO lists.count()-1
      reactionList:=lists.item(i)
      StringF(tempStr,'\d',reactionList.id)
      IF (n:=AllocListBrowserNodeA(2, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, reactionList.name, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, tempStr, TAG_END])) 
        AddTail(self.browserlist, n)
      ELSE 
        Raise("MEM")    
      ENDIF
    ENDFOR
  ENDIF
  SetGadgetAttrsA(self.gadgetList[LISTPICK_SELECTOR],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  SetGadgetAttrsA(self.gadgetList[LISTPICK_OK],win,0,[GA_DISABLED, TRUE, TAG_END])
ENDPROC

PROC selectItem(nself,gadget,id,code) OF listPickerForm
  DEF win,clickType
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  self.selectedItem:=code
  clickType:=Gets(self.gadgetList[LISTPICK_SELECTOR],LISTBROWSER_RELEVENT)
  IF clickType=LBRE_DOUBLECLICK
    self.modalResult:=MR_OK
  ENDIF

  self.selectedItem:=code
  SetGadgetAttrsA(self.gadgetList[LISTPICK_OK],win,0,[GA_DISABLED, code<0, TAG_END])
ENDPROC

EXPORT PROC selectList() OF listPickerForm
  DEF reactionLists:PTR TO stdlist
  DEF reactionList:PTR TO reactionListObject
  self.makeList()
  
  IF self.showModal()=MR_OK
    reactionLists:=getReactionLists()
    reactionList:=reactionLists.item(self.selectedItem)
    RETURN reactionList.id
  ENDIF
ENDPROC -1


