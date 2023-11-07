OPT OSVERSION=37,LARGE

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'bevel',
        'space',
        'string','checkbox','chooser','label','integer','palette',
        'requester','classes/requester',
        'images/bevel',
        'images/label',
        '*textfield',
        'getfile',
        'getfont',
        'getscreenmode',
        'fuelgauge',
        'radiobutton',
        'clicktab',
        'scroller','glyph',
        'gadtools','libraries/gadtools',
        'dos/dos',
        'exec',
        'asl','libraries/asl',
        'tools/boopsi',
        'amigalib/boopsi','exec/memory',
        'listbrowser','gadgets/listbrowser',
        'intuition/intuition','intuition/imageclass','intuition/gadgetclass','intuition/classusr'

  MODULE '*fileStreamer','*objectPicker','*cSourceGen', '*eSourceGen','*sourceGen','*codeGenForm','*listManagerForm','*reactionLists','*dialogs',
         '*getScreenModeObject','*getFontObject','*getFileObject','*textFieldObject','*drawListObject','*fuelGaugeObject','*bevelObject','*listBrowserObject','*clickTabObject','*chooserObject','*radioObject','*menuObject','*rexxObject','*reactionListObject','*windowObject','*screenObject','*layoutObject','*paletteObject','*scrollerObject','*glyphObject','*spaceObject','*labelObject','*checkboxObject','*buttonObject','*stringObject','*integerObject','*stringlist','*reactionObject','*reactionForm'

  CONST ROOT_APPLICATION_ITEM=0
  CONST ROOT_REXX_ITEM=1
  CONST ROOT_SCREEN_ITEM=2
  CONST ROOT_WINDOW_ITEM=3
  CONST ROOT_MENU_ITEM=4
  CONST ROOT_LAYOUT_ITEM=5

  ENUM GAD_COMPONENTLIST,GAD_TEMP_COPYTO, GAD_TEMP_COPYFROM, GAD_TEMP_MOVETO, GAD_TEMP_MOVEFROM, GAD_TEMP_REMOVE, GAD_TEMPLIST, GAD_ADD, GAD_GENMINUS, GAD_GENPLUS, GAD_DELETE, GAD_MOVEUP, GAD_MOVEDOWN, 
       GAD_LISTS, GAD_CODE, GAD_LOAD, GAD_SAVE, GAD_NEW

  CONST GAD_COUNT=GAD_NEW+1
       
  ENUM  MENU_PROJECT, MENU_EDIT
  
  ENUM LANG_E, LANG_C

  CONST MENU_PROJECT_NEW=0
  CONST MENU_PROJECT_LOAD=1
  CONST MENU_PROJECT_SAVE=2
  CONST MENU_PROJECT_SAVEAS=3
  CONST MENU_PROJECT_GENCODE=5
  CONST MENU_PROJECT_ABOUT=7
  CONST MENU_PROJECT_QUIT=9

  CONST MENU_EDIT_ADD=0
  CONST MENU_EDIT_EDIT=1
  CONST MENU_EDIT_DELETE=2
  CONST MENU_EDIT_MOVEUP=4
  CONST MENU_EDIT_MOVEDOWN=5
  CONST MENU_EDIT_LISTS=7
  CONST MENU_EDIT_BUFFER=9
  CONST MENU_EDIT_PREVIEW=11

  CONST FILE_FORMAT_VER=1

  DEF columninfo[4]:ARRAY OF columninfo
  DEF columninfo2[2]:ARRAY OF columninfo
  DEF mainWindow=0
  DEF mainWindowLayout=0
  DEF bufferLayout=0
  DEF appPort=0
  DEF win:PTR TO window
  DEF gMain_Gadgets[GAD_COUNT]:ARRAY OF LONG
  DEF objectList:PTR TO stdlist
  DEF bufferList:PTR TO stdlist
  DEF selectedComp:PTR TO reactionObject
  DEF selectedBuffComp:PTR TO reactionObject
  DEF list=0,list2=0
  DEF changes=FALSE
  DEF menus=0
  DEF filename[255]:STRING

PROC openClasses()
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',0))=NIL THEN Throw("LIB","gadt")
  IF (windowbase:=OpenLibrary('window.class',0))=NIL THEN Throw("LIB","win")
  IF (requesterbase:=OpenLibrary('requester.class',0))=NIL THEN Throw("LIB","reqr")
  IF (listbrowserbase:=OpenLibrary('gadgets/listbrowser.gadget',0))=NIL THEN Throw("LIB","list")
  IF (radiobuttonbase:=OpenLibrary('gadgets/radiobutton.gadget',0))=NIL THEN Throw("LIB","rbtn")
  IF (clicktabbase:=OpenLibrary('gadgets/clicktab.gadget',0))=NIL THEN Throw("LIB","clkt")
  IF (buttonbase:=OpenLibrary('gadgets/button.gadget',0))=NIL THEN Throw("LIB","btn")
  IF (layoutbase:=OpenLibrary('gadgets/layout.gadget',0))=NIL THEN Throw("LIB","layo")
  IF (stringbase:=OpenLibrary('gadgets/string.gadget',0))=NIL THEN Throw("LIB","strn")
  IF (chooserbase:=OpenLibrary('gadgets/chooser.gadget',0))=NIL THEN Throw("LIB","choo")
  IF (palettebase:=OpenLibrary('gadgets/palette.gadget',0))=NIL THEN Throw("LIB","pall")
  IF (spacebase:=OpenLibrary('gadgets/space.gadget',0))=NIL THEN Throw("LIB","spce")
  IF (integerbase:=OpenLibrary('gadgets/integer.gadget',0))=NIL THEN Throw("LIB","intr")
  IF (scrollerbase:=OpenLibrary('gadgets/scroller.gadget',0))=NIL THEN Throw("LIB","scrl")
  IF (checkboxbase:=OpenLibrary('gadgets/checkbox.gadget',0))=NIL THEN Throw("LIB","chkb")
  IF (fuelgaugebase:=OpenLibrary('gadgets/fuelgauge.gadget',0))=NIL THEN Throw("LIB","fuel")
  IF (textfieldbase:=OpenLibrary('gadgets/textfield.gadget',0))=NIL THEN Throw("LIB","text")
  IF (getfilebase:=OpenLibrary('gadgets/getfile.gadget',0))=NIL THEN Throw("LIB","file")
  IF (getfontbase:=OpenLibrary('gadgets/getfont.gadget',0))=NIL THEN Throw("LIB","font")
  IF (getscreenmodebase:=OpenLibrary('gadgets/getscreenmode.gadget',0))=NIL THEN Throw("LIB","scrn")
  IF (glyphbase:=OpenLibrary('images/glyph.image',0))=NIL THEN Throw("LIB","glyp")
  IF (labelbase:=OpenLibrary('images/label.image',0))=NIL THEN Throw("LIB","labl")
  IF (bevelbase:=OpenLibrary('images/bevel.image',0))=NIL THEN Throw("LIB","bevl")
  IF (drawlistbase:=OpenLibrary('images/drawlist.image',0))=NIL THEN Throw("LIB","draw")
ENDPROC

PROC closeClasses()
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF listbrowserbase THEN CloseLibrary(listbrowserbase)
  IF radiobuttonbase THEN CloseLibrary(radiobuttonbase)
  IF clicktabbase THEN CloseLibrary(clicktabbase)
  IF buttonbase THEN CloseLibrary(buttonbase)
  IF layoutbase THEN CloseLibrary(layoutbase)
  IF windowbase THEN CloseLibrary(windowbase)
  IF requesterbase THEN CloseLibrary(requesterbase)
  IF stringbase THEN CloseLibrary(stringbase)
  IF chooserbase THEN CloseLibrary(chooserbase)
  IF palettebase THEN CloseLibrary(palettebase)
  IF spacebase THEN CloseLibrary(spacebase)
  IF integerbase THEN CloseLibrary(integerbase)
  IF scrollerbase THEN CloseLibrary(scrollerbase)
  IF checkboxbase THEN CloseLibrary(checkboxbase)
  IF fuelgaugebase THEN CloseLibrary(fuelgaugebase)
  IF textfieldbase THEN CloseLibrary(textfieldbase)
  IF getfilebase THEN CloseLibrary(getfilebase)
  IF getfontbase THEN CloseLibrary(getfontbase)
  IF getscreenmodebase THEN CloseLibrary(getscreenmodebase)
  
  IF glyphbase THEN CloseLibrary(glyphbase)
  IF labelbase THEN CloseLibrary(labelbase)
  IF bevelbase THEN CloseLibrary(bevelbase)
  IF drawlistbase THEN CloseLibrary(drawlistbase)
ENDPROC

PROC makeComponentList(comp:PTR TO reactionObject,generation,list, selcomp, newnode:PTR TO LONG)
  DEF comp2:PTR TO reactionObject
  DEF count,n,i
  DEF compStr[30]:STRING
  DEF idStr[10]:STRING
  DEF typeStr[15]:STRING
 
  IF StrLen(comp.name)=0
    StringF(compStr,'\s',comp.getTypeName())
  ELSE
    StringF(compStr,'\s - \s',comp.getTypeName(),comp.name)
  ENDIF
  StringF(idStr,'\d',comp.id)
  StringF(typeStr,'\s Object',comp.getTypeName())
  IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, IF (comp.parent=0) OR (comp.type=TYPE_LAYOUT) THEN LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN ELSE 0,LBNA_USERDATA, comp, LBNA_GENERATION, generation, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, compStr, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, typeStr,LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, idStr,TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
  
  IF comp=selcomp THEN newnode[]:=n
  
  IF comp.type=TYPE_LAYOUT
    FOR i:=0 TO comp.children.count()-1
      makeComponentList(comp.children.item(i),generation+1,list, selcomp, newnode)
    ENDFOR
  ENDIF
ENDPROC

PROC removeMembers(comp:PTR TO reactionObject,previewRootLayout)
  DEF i 
  IF comp
    IF comp.type=TYPE_LAYOUT
      FOR i:=0 TO comp.children.count()-1
        removeMembers(comp.children.item(i),previewRootLayout)
      ENDFOR
    ENDIF
    IF comp.parent  
      WriteF('removing comp \h \h\n',comp.parent.previewObject, comp.previewObject)
      IF comp.previewObject
        Sets(comp.parent.previewObject,LAYOUT_REMOVECHILD, comp.previewObject)
        comp.previewObject:=0
        comp.previewChildAttrs:=0
      ENDIF
      WriteF('removed comp \h \h\n',comp.parent.previewObject, comp.previewObject)
    ELSE
      WriteF('removing rootlayout \h \h\n',previewRootLayout, comp.previewObject)
      IF comp.previewObject
        Sets(previewRootLayout,LAYOUT_REMOVECHILD, comp.previewObject)
        comp.previewObject:=0
        comp.previewChildAttrs:=0
      ENDIF
      WriteF('removed rootlayout \h \h\n',previewRootLayout, comp.previewObject)
    ENDIF
  ENDIF
ENDPROC

PROC addMembers(comp:PTR TO reactionObject,previewRootLayout)
  DEF i 
  IF comp
    IF comp.parent  
      WriteF('adding comp \h \h\n',comp.parent.previewObject,comp.previewObject)
      comp.createPreviewObject()
      IF (comp.isImage())
        SetGadgetAttrsA(comp.parent.previewObject,0,0,[LAYOUT_ADDIMAGE, comp.previewObject, TAG_END])
      ELSE
        SetGadgetAttrsA(comp.parent.previewObject,0,0,[LAYOUT_ADDCHILD, comp.previewObject, TAG_END])
      ENDIF
      IF comp.previewChildAttrs THEN SetGadgetAttrsA(comp.parent.previewObject,0,0,comp.previewChildAttrs)
      WriteF('added comp \h \h\n',comp.parent.previewObject,comp.previewObject)
    ELSE
      WriteF('adding rootlayout \h \h\n',previewRootLayout,comp.previewObject)
      comp.createPreviewObject()
      SetGadgetAttrsA(previewRootLayout,0,0,[LAYOUT_ADDCHILD, comp.previewObject, TAG_END])
      IF comp.previewChildAttrs THEN SetGadgetAttrsA(previewRootLayout,0,0,comp.previewChildAttrs)
      WriteF('added rootlayout \h \h\n',previewRootLayout,comp.previewObject)
    ENDIF
    IF comp.type=TYPE_LAYOUT
      FOR i:=0 TO comp.children.count()-1
        addMembers(comp.children.item(i),previewRootLayout)
      ENDFOR
    ENDIF
  ENDIF
ENDPROC

PROC makeList(selcomp=0)
  DEF n,i
  DEF newnode=0
  DEF depth
  
  SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  IF list THEN freeBrowserNodes( list )
  list:=browserNodesA([0])

  FOR i:=0 TO objectList.count()-1
    IF objectList.item(i)=0
      SELECT i
        CASE ROOT_APPLICATION_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 1, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Application Begin', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System Object',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_REXX_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 2, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Rexx', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System Object',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_SCREEN_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 2, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Screen', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System Object',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_WINDOW_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 3, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Window - Main', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System Object',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT,'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_MENU_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 4, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Menu', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System Object',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
      ENDSELECT
    ELSE
      IF i=ROOT_REXX_ITEM
        depth:=2
      ELSEIF i=ROOT_SCREEN_ITEM
        depth:=2
      ELSE
        SELECT Mod(i-ROOT_WINDOW_ITEM,3)
          CASE 0 ->Window object
            depth:=3
          CASE 1 -> Menu object
            depth:=4
          CASE 2 -> Layout object
            depth:=4
        ENDSELECT
      ENDIF
      makeComponentList(objectList.item(i),depth,list,selcomp,{newnode})
/*      IF i<ROOT_WINDOW_ITEM
        SELECT i
          CASE ROOT_REXX_ITEM
            makeComponentList(objectList.item(i),2,list,selcomp,{newnode})
          CASE ROOT_SCREEN_ITEM
            ->screen
            makeComponentList(objectList.item(i),2,list,selcomp,{newnode})
          CASE ROOT_WINDOW_ITEM
            ->window
            makeComponentList(objectList.item(i),3,list,selcomp,{newnode})
        ENDSELECT
      ELSE
        makeComponentList(objectList.item(i),4,list,selcomp,{newnode})
      ENDIF*/
    ENDIF
  ENDFOR

  IF (n:=AllocListBrowserNodeA(3, [LBNA_USERDATA, 0, LBNA_GENERATION, 1, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Application End', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System Object',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
-> Reattach the list
  SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_LABELS,list,0])
  IF win 
    IF newnode
      SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_SELECTEDNODE, newnode,0])
      updateSel(win,newnode)
    ELSE
      SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_SELECTED, -1,0])
      updateSel(win,0)
    ENDIF
  ENDIF
  
ENDPROC

PROC menuCode(menu,item,subitem) IS (subitem<<11) OR ((item << 5) OR menu)

PROC menuDisable(win,menu,item,subitem,flag)
  IF flag THEN OffMenu(win,menuCode(menu,item,subitem)) ELSE OnMenu(win,menuCode(menu,item,subitem))
ENDPROC

PROC updateSel(win,node)
  DEF comp=0:PTR TO reactionObject
  DEF dis,idx
  DEF check,i
  
  IF node THEN GetListBrowserNodeAttrsA(node,[LBNA_USERDATA,{comp},TAG_END])
  IF comp
    selectedComp:=comp
    FOR i:=0 TO NUM_OBJECT_TYPES-1
      check:=(i=1) OR (i=11) OR (i=16) OR (i=17) OR (i=18)
      menuDisable(win,MENU_EDIT,MENU_EDIT_ADD,i,((comp.parent=0) AND (comp.type<>TYPE_LAYOUT)) OR check)
    ENDFOR
    menuDisable(win,MENU_EDIT,MENU_EDIT_EDIT,0,FALSE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_DELETE,0,comp.parent=0)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVEUP,0,(comp.parent=0) ORELSE (comp.getChildIndex()=0))
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVEDOWN,0,(comp.parent=0) ORELSE (comp.getChildIndex()=(comp.parent.children.count()-1)))
    
    SetGadgetAttrsA(gMain_Gadgets[GAD_ADD],win,0,[GA_DISABLED,(comp.parent=0) AND (comp.type<>TYPE_LAYOUT) AND (comp.type<>TYPE_SCREEN) AND (comp.type<>TYPE_WINDOW),TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_GENMINUS],win,0,[GA_DISABLED,Not((comp.parent<>0) ANDALSO (comp.parent.parent<>0)),TAG_END])

    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYTO],win,0,[GA_DISABLED,(comp.parent=0) AND (comp.type<>TYPE_LAYOUT) AND (comp.type<>TYPE_WINDOW),TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVETO],win,0,[GA_DISABLED,(((comp.parent=0) AND (comp.type<>TYPE_WINDOW)) OR comp.children.count()),TAG_END])
    
    dis:=TRUE
    IF comp.parent
      idx:=comp.getChildIndex()
      IF (idx<(comp.parent.children.count()-1))
        IF ((comp.parent.children.item(idx+1)::reactionObject.type)=TYPE_LAYOUT)
          dis:=FALSE
        ENDIF
      ENDIF
    ENDIF
    SetGadgetAttrsA(gMain_Gadgets[GAD_GENPLUS],win,0,[GA_DISABLED,dis,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_DELETE],win,0,[GA_DISABLED,comp.parent=0,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_MOVEUP],win,0,[GA_DISABLED,(comp.parent=0) ORELSE (comp.getChildIndex()=0),TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_MOVEDOWN],win,0,[GA_DISABLED,(comp.parent=0) ORELSE (comp.getChildIndex()=(comp.parent.children.count()-1)),TAG_END])

    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,selectedBuffComp=0,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,selectedBuffComp=0,TAG_END])
  ELSE
    selectedComp:=0
    FOR i:=0 TO NUM_OBJECT_TYPES-1
      menuDisable(win,MENU_EDIT,MENU_EDIT_ADD,i,TRUE)
    ENDFOR
    menuDisable(win,MENU_EDIT,MENU_EDIT_EDIT,0,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_DELETE,0,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVEUP,0,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVEDOWN,0,TRUE)

    SetGadgetAttrsA(gMain_Gadgets[GAD_ADD],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_GENMINUS],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_GENPLUS],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_DELETE],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_MOVEUP],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_MOVEDOWN],win,0,[GA_DISABLED,TRUE,TAG_END])

    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYTO],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVETO],win,0,[GA_DISABLED,TRUE,TAG_END])

    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
  ENDIF
ENDPROC

PROC updateBufferSel(win,node)
  DEF comp=0:PTR TO reactionObject
  DEF dis
  IF node THEN GetListBrowserNodeAttrsA(node,[LBNA_USERDATA,{comp},TAG_END])
  IF comp AND selectedComp
    dis:=(selectedComp.parent=0) AND (selectedComp.type<>TYPE_LAYOUT) AND (selectedComp.type<>TYPE_SCREEN) AND (selectedComp.type<>TYPE_WINDOW)
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,dis,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,dis,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_REMOVE],win,0,[GA_DISABLED,dis,TAG_END])
  ELSE
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_REMOVE],win,0,[GA_DISABLED,TRUE,TAG_END])
  ENDIF
  selectedBuffComp:=comp
ENDPROC

PROC createBufferGads()
  bufferLayout:=LayoutObject,
    LAYOUT_DEFERLAYOUT, FALSE,
    LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,
    
    LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMPLIST]:=ListBrowserObject,
      GA_ID, GAD_TEMPLIST,
      GA_RELVERIFY, TRUE,
      LISTBROWSER_POSITION, 0,
      LISTBROWSER_SHOWSELECTED, TRUE,
      LISTBROWSER_VERTSEPARATORS, TRUE,
      LISTBROWSER_SEPARATORS, TRUE,
      LISTBROWSER_COLUMNTITLES, TRUE,
      LISTBROWSER_COLUMNINFO, columninfo2,
      LISTBROWSER_VERTICALPROP, TRUE,
      LISTBROWSER_HIERARCHICAL, FALSE,
      LISTBROWSER_LABELS, list2,
    ListBrowserEnd,
    CHILD_WEIGHTEDWIDTH,20,
    
    LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_COPYTO]:=ButtonObject,
        GA_ID, GAD_TEMP_COPYTO,
        GA_TEXT, '->Copy',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_COPYFROM]:=ButtonObject,
        GA_ID, GAD_TEMP_COPYFROM,
        GA_TEXT, '<-Copy',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_MOVETO]:=ButtonObject,
        GA_ID, GAD_TEMP_MOVETO,
        GA_TEXT, 'Move->',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_MOVEFROM]:=ButtonObject,
        GA_ID, GAD_TEMP_MOVEFROM,
        GA_TEXT, '<-Move',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,
      
      LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_REMOVE]:=ButtonObject,
        GA_ID, GAD_TEMP_REMOVE,
        GA_TEXT, 'Remove',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,
  LayoutEnd
ENDPROC

PROC createForm()
  appPort:=CreateMsgPort()

  list:=browserNodesA([0])
  list2:=browserNodesA([0])
  columninfo[0].width:=2
  columninfo[0].title:='Object Name'
  columninfo[0].flags:=CIF_WEIGHTED

  columninfo[1].width:=1
  columninfo[1].title:='Object Type'
  columninfo[1].flags:=CIF_WEIGHTED

  columninfo[2].width:=1
  columninfo[2].title:='Object ID'
  columninfo[2].flags:=CIF_WEIGHTED

  columninfo[3].width:=-1
  columninfo[3].title:=-1
  columninfo[3].flags:=-1

  columninfo2[0].width:=1
  columninfo2[0].title:='Buffer'
  columninfo2[0].flags:=CIF_WEIGHTED

  columninfo2[1].width:=-1
  columninfo2[1].title:=-1
  columninfo2[1].flags:=-1

  remakePreviewMenus()

  mainWindow:=WindowObject,
    WA_TITLE, 'ReBuild - Reaction UI Builder',
    WA_LEFT, 100,
    WA_TOP, 100,
    WA_HEIGHT, 280,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_PUBSCREEN, 0,
    WA_ACTIVATE, TRUE,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
    ->WA_CustomScreen, gScreen,
    WINDOW_APPPORT, appPort,
    WINDOW_APPWINDOW, TRUE,
    WINDOW_ICONIFYGADGET, TRUE, 
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    ->WA_NOCAREREFRESH, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR IDCMP_MENUPICK,
    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,
        
      LAYOUT_ADDCHILD, mainWindowLayout:=LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        
          LAYOUT_ADDCHILD, gMain_Gadgets[GAD_COMPONENTLIST]:=ListBrowserObject,
            GA_ID, GAD_COMPONENTLIST,
            GA_RELVERIFY, TRUE,
            LISTBROWSER_POSITION, 0,
            LISTBROWSER_SHOWSELECTED, TRUE,
            LISTBROWSER_VERTSEPARATORS, TRUE,
            LISTBROWSER_SEPARATORS, TRUE,
            LISTBROWSER_COLUMNTITLES, TRUE,
            LISTBROWSER_COLUMNINFO, columninfo,
            LISTBROWSER_VERTICALPROP, TRUE,
            LISTBROWSER_HIERARCHICAL, TRUE,
            LISTBROWSER_LABELS, list,
          ListBrowserEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, TRUE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_ADD]:=ButtonObject,
            GA_ID, GAD_ADD,
            GA_TEXT, '_Add',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_GENMINUS]:=ButtonObject,
            GA_ID, GAD_GENMINUS,
            GA_TEXT, 'Gen _-',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_GENPLUS]:=ButtonObject,
            GA_ID, GAD_GENPLUS,
            GA_TEXT, 'Gen _+',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_DELETE]:=ButtonObject,
            GA_ID, GAD_DELETE,
            GA_TEXT, '_Delete',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_MOVEUP]:=ButtonObject,
            GA_ID, GAD_MOVEUP,
            GA_TEXT, '_Up',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_MOVEDOWN]:=ButtonObject,
            GA_ID, GAD_MOVEDOWN,
            GA_TEXT, 'Do_wn',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_LISTS]:=ButtonObject,
            GA_ID, GAD_LISTS,
            GA_TEXT, 'L_ists',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_CODE]:=ButtonObject,
            GA_ID, GAD_CODE,
            GA_TEXT, '_Code',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_LOAD]:=ButtonObject,
            GA_ID, GAD_LOAD,
            GA_TEXT, '_Open',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_SAVE]:=ButtonObject,
            GA_ID, GAD_SAVE,
            GA_TEXT, '_Save',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  gMain_Gadgets[GAD_NEW]:=ButtonObject,
            GA_ID, GAD_NEW,
            GA_TEXT, '_New',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
          CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd
  
  toggleBuffer()
  
ENDPROC

PROC addObject(parent:PTR TO reactionObject,newobj:PTR TO reactionObject)
  DEF idx, mainRootLayout, previewRootLayout
  
  IF parent.type=TYPE_LAYOUT
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    previewRootLayout:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))::windowObject.previewRootLayout
    removeMembers(mainRootLayout,previewRootLayout)
    parent.addChild(newobj)
    makeList(newobj)
    addMembers(mainRootLayout,previewRootLayout)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC removeObject(parent:PTR TO reactionObject,child)
  DEF idx, mainRootLayout, previewRootLayout

  IF parent.type=TYPE_LAYOUT
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    previewRootLayout:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))::windowObject.previewRootLayout
    removeMembers(objectList.item(ROOT_LAYOUT_ITEM),previewRootLayout)
    parent.removeChild(child)
    END child
    makeList()
    addMembers(objectList.item(ROOT_LAYOUT_ITEM),previewRootLayout)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC doGenUp(parent:PTR TO reactionObject,child:PTR TO reactionObject)
  DEF idx, mainRootLayout, previewRootLayout

  IF (parent.type=TYPE_LAYOUT) AND (parent.parent<>0)
    changes:=TRUE
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    previewRootLayout:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))::windowObject.previewRootLayout
    removeMembers(mainRootLayout,previewRootLayout)
    parent.removeChild(child)
    parent.parent.addChild(child)
    child.parent:=parent.parent
    makeList(child)
    addMembers(mainRootLayout,previewRootLayout)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC doGenDown(parent:PTR TO reactionObject, child:PTR TO reactionObject)
  DEF idx, mainRootLayout, previewRootLayout
  DEF newparent: PTR TO reactionObject

  changes:=TRUE
  idx:=findWindowIndex(selectedComp)
  mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
  previewRootLayout:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))::windowObject.previewRootLayout
  removeMembers(mainRootLayout,previewRootLayout)
  idx:=child.getChildIndex()
  newparent:=parent.children.item(idx+1)
  parent.removeChild(child)
  newparent.addChild(child)
  makeList(child)
  addMembers(mainRootLayout,previewRootLayout)
  rethinkPreviews()
ENDPROC

PROC moveUp(parent:PTR TO reactionObject,child:PTR TO reactionObject)
  DEF idx, mainRootLayout, previewRootLayout

  IF parent.type=TYPE_LAYOUT
    changes:=TRUE
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    previewRootLayout:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))::windowObject.previewRootLayout
    removeMembers(mainRootLayout,previewRootLayout)
    parent.swapChildren(child.getChildIndex(),child.getChildIndex()-1)
    makeList(child)
    addMembers(mainRootLayout,previewRootLayout)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC moveDown(parent:PTR TO reactionObject,child:PTR TO reactionObject)
  DEF idx, mainRootLayout, previewRootLayout

  IF parent.type=TYPE_LAYOUT
    changes:=TRUE
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    previewRootLayout:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))::windowObject.previewRootLayout
    removeMembers(mainRootLayout,previewRootLayout)
    parent.swapChildren(child.getChildIndex(),child.getChildIndex()+1)
    makeList(child)
    addMembers(mainRootLayout,previewRootLayout)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC findWindowIndex(comp:PTR TO reactionObject)
  DEF res,i
  IF comp.type=TYPE_WINDOW
    i:=ROOT_WINDOW_ITEM
    WHILE i<objectList.count()
      IF objectList.item(i)=comp
        RETURN (i-ROOT_WINDOW_ITEM)/3
      ENDIF
      i+=3
    ENDWHILE
  ELSEIF comp.type=TYPE_MENU
    i:=ROOT_WINDOW_ITEM
    WHILE i<objectList.count()
      IF objectList.item(i-ROOT_WINDOW_ITEM+ROOT_MENU_ITEM)=comp
        RETURN (i-ROOT_WINDOW_ITEM)/3
      ENDIF
      i+=3
    ENDWHILE
  ELSE 
    WHILE comp.parent DO comp:=comp.parent
    IF comp.type<>TYPE_LAYOUT
      RETURN -1
    ENDIF
  
    i:=ROOT_LAYOUT_ITEM
    WHILE i<objectList.count()
      IF objectList.item(i)=comp
        RETURN (i-ROOT_LAYOUT_ITEM)/3
      ENDIF
      i+=3
    ENDWHILE
    
  ENDIF
ENDPROC -1

PROC enumerateGads(from=0:PTR TO reactionObject,n=0,libsused=0)
  DEF i
  IF from=0 THEN from:=objectList.item(ROOT_LAYOUT_ITEM)
  libsused:=libsused OR from.libused

  FOR i:=0 TO from.children.count()-1 DO n,libsused:=enumerateGads(from.children.item(i),n,libsused)
ENDPROC n+1,libsused

PROC genComponentCode(comp:PTR TO reactionObject, n, srcGen:PTR TO srcGen)
  DEF i
  DEF tempStr[200]:STRING
  IF comp.isImage()
    srcGen.componentAddImage()
  ELSE
    srcGen.componentAddChild()
  ENDIF
  StringF(tempStr,'\sObject,',comp.getTypeName())
  srcGen.assignGadgetVar(n)
  srcGen.componentCreate(tempStr)
  comp.genCodeProperties(srcGen)
  FOR i:=0 TO comp.children.count()-1
    n++
    genComponentCode(comp.children.item(i),n,srcGen)
  ENDFOR
  StrCopy(tempStr,comp.getTypeEndName())
  IF EstrLen(tempStr)=0
    StringF(tempStr,'\sEnd',comp.getTypeName())
  ENDIF
  StrAddChar(tempStr,",")
  srcGen.componentEnd(tempStr)
  comp.genCodeChildProperties(srcGen)
ENDPROC

PROC genCode()
  DEF fs:PTR TO fileStreamer
  DEF tags
  DEF fr:PTR TO filerequester
  DEF fname[255]:STRING
  DEF eSrcGen: PTR TO eSrcGen
  DEF cSrcGen: PTR TO cSrcGen
  DEF srcGen:PTR TO srcGen
  DEF count,libsused
  DEF comp:PTR TO reactionObject
  DEF objectCreate[50]:STRING
  DEF objectEnd[50]:STRING
  DEF codeGenForm:PTR TO codeGenForm
  DEF langid
  DEF menuComp:PTR TO reactionObject
  
  NEW codeGenForm.create()
  langid:=codeGenForm.selectLang()
  END codeGenForm
  IF langid=-1 THEN RETURN
  
  aslbase:=OpenLibrary('asl.library',37)
  IF aslbase=NIL THEN Throw("LIB","ASL")
  tags:=NEW [ASL_HAIL,'Select a file to save',
     ASL_WINDOW, win,
     TAG_DONE]
  fr:=AllocAslRequest(ASL_FILEREQUEST,tags)
  IF(AslRequest(fr,0))=FALSE
    IF tags THEN FastDisposeList(tags)
    IF aslbase THEN CloseLibrary(aslbase)
    RETURN
  ENDIF

  StrCopy(fname,fr.drawer)
  AddPart(fname,fr.file,100)
  SetStr(fname)
  IF fr THEN FreeAslRequest(fr)
  IF tags THEN FastDisposeList(tags)
  IF aslbase THEN CloseLibrary(aslbase)
  
  count,libsused:=enumerateGads()
  WriteF('libsused=\d\n',libsused)
  
  IF FileLength(fname)>=0
    IF warnRequest(win,'Warning','This file already exists,\ndo you want to overwrite?',TRUE)=0 THEN RETURN
  ENDIF

  NEW fs.create(fname,MODE_NEWFILE)
  
  SELECT langid
    CASE LANG_E
      NEW eSrcGen.create(fs,libsused)
      srcGen:=eSrcGen
    CASE LANG_C
      NEW cSrcGen.create(fs,libsused)
      srcGen:=cSrcGen
  ENDSELECT

  menuComp:=objectList.item(ROOT_MENU_ITEM)
  srcGen.genHeader(count,menuComp)
  srcGen.assignWindowVar()
  comp:=objectList.item(ROOT_WINDOW_ITEM)
  StringF(objectCreate,'\sObject,',comp.getTypeName())
  StringF(objectEnd,'\sEnd',comp.getTypeName())
  srcGen.componentCreate(objectCreate)
  comp.genCodeProperties(srcGen)

  srcGen.componentProperty('WINDOW_ParentGroup','VLayoutObject',FALSE)
  srcGen.componentProperty('LAYOUT_DeferLayout','TRUE',FALSE)
  srcGen.increaseIndent()
  comp:=objectList.item(ROOT_LAYOUT_ITEM)
  genComponentCode(comp,0,srcGen)
  srcGen.componentEnd('LayoutEnd,') 
  srcGen.finalComponentEnd(objectEnd) 
  srcGen.decreaseIndent()
  srcGen.genFooter(count,menuComp)
  END srcGen
  
  END fs

ENDPROC

PROC processObjects(obj:PTR TO reactionObject,list:PTR TO stdlist)
  DEF i
  DEF tmpObj:PTR TO reactionObject
  FOR i:=0 TO list.count()-1
    tmpObj:=list.item(i)
    IF tmpObj.tempParentId=obj.id
       tmpObj.parent:=obj
       obj.addChild(tmpObj)
       processObjects(tmpObj,list)
    ENDIF
  ENDFOR
ENDPROC

PROC loadFile() HANDLE
  DEF fs=0:PTR TO fileStreamer
  DEF newObj:PTR TO reactionObject
  DEF tmpObj:PTR TO reactionObject
  DEF tempStr[255]:STRING
  DEF loadObjectList=0:PTR TO stdlist
  DEF reactionLists:PTR TO stdlist
  DEF type,i
  DEF ver,newid

  DEF tags
  DEF fr:PTR TO filerequester
  DEF fname[255]:STRING

  aslbase:=OpenLibrary('asl.library',37)
  IF aslbase=NIL THEN Throw("LIB","ASL")
  tags:=NEW [ASL_HAIL,'Select a file to load',
     ASL_WINDOW, win,
     TAG_DONE]
  fr:=AllocAslRequest(ASL_FILEREQUEST,tags)
  IF(AslRequest(fr,0))=FALSE
    IF tags THEN FastDisposeList(tags)
    IF aslbase THEN CloseLibrary(aslbase)
    RETURN
  ENDIF

  StrCopy(fname,fr.drawer)
  AddPart(fname,fr.file,100)
  SetStr(fname)
  StrCopy(filename,fname)
  IF fr THEN FreeAslRequest(fr)
  IF tags THEN FastDisposeList(tags)
  IF aslbase THEN CloseLibrary(aslbase)

  NEW fs.create(fname,MODE_OLDFILE)
  
  fs.readLine(tempStr)
  IF StrCmp(tempStr,'-REBUILD-')=FALSE
    errorRequest(win,'Error','This file is not a valid rebuild file.')
    END fs
    RETURN
  ENDIF

  fs.readLine(tempStr)
  ver:=Val(tempStr)
  IF (ver<1)
    errorRequest(win,'Error','This file is not a valid rebuild file.')
    END fs
    RETURN
  ENDIF
  
  IF (ver>FILE_FORMAT_VER)
    errorRequest(win,'Error','This file is too new for this version of ReBuild.')
    END fs
    RETURN
  ENDIF
  
  
  fs.readLine(tempStr)
  newid:=Val(tempStr)
  
  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    removeMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i)::windowObject.previewRootLayout)
    i+=3
  ENDWHILE
  disposeObjects()
  objectInitialise()

  objectList.add(0)  ->Application begin
  objectList.add(0)  ->Rexx
  objectList.add(0)  ->Screen
  objectList.add(0)  ->Window
  objectList.add(0)  ->Menu
  objectList.add(0)  ->Layout

  NEW loadObjectList.stdlist(100)

  reactionLists:=getReactionLists()

  WHILE (fs.readLine(tempStr))
    IF StrCmp('TYPE: ',tempStr,6)
      type:=Val(tempStr+6)
      newObj:=createObjectByType(type,0)
      IF type=TYPE_REACTIONLIST THEN reactionLists.add(newObj)
      IF type=TYPE_SCREEN THEN objectList.setItem(ROOT_SCREEN_ITEM,newObj)
      IF type=TYPE_REXX THEN objectList.setItem(ROOT_REXX_ITEM,newObj)
      IF type=TYPE_WINDOW
        IF objectList.item(ROOT_WINDOW_ITEM)=0
          objectList.setItem(ROOT_WINDOW_ITEM,newObj)
        ELSE
          objectList.add(newObj)  ->extra window
          objectList.add(0) ->extra menu
          objectList.add(0) ->extra layout
        ENDIF
      ENDIF
      IF type=TYPE_MENU THEN objectList.setItem(objectList.count()-2,newObj)
      IF (type=TYPE_LAYOUT) AND (objectList.item(objectList.count()-1)=0) THEN objectList.setItem(objectList.count()-1,newObj)

      IF newObj THEN newObj.deserialise(fs)
      loadObjectList.add(newObj)
    ENDIF
  ENDWHILE

  FOR i:=0 TO loadObjectList.count()-1
    newObj:=loadObjectList.item(i)
    IF newObj.tempParentId=-1
      newObj.parent:=0
    ENDIF
  ENDFOR

  i:=ROOT_LAYOUT_ITEM
  WHILE i<objectList.count()
    processObjects(objectList.item(i),loadObjectList)
    i+=3
  ENDWHILE
  makeList()

  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    addMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i)::windowObject.previewRootLayout)
    i+=3
  ENDWHILE
  remakePreviewMenus()
 
  changes:=FALSE
  
  objectInitialise(newid)
EXCEPT DO
  END loadObjectList
  END fs
ENDPROC

PROC saveFile() HANDLE
  DEF fs=0:PTR TO fileStreamer
  DEF i,j
  DEF comp:PTR TO reactionObject
  DEF tempStr[10]:STRING
  DEF reactionLists:PTR TO stdlist

  IF EstrLen(filename)=0 
    RETURN saveFileAs()
  ENDIF

  NEW fs.create(filename,MODE_NEWFILE)
  fs.writeLine('-REBUILD-')
  StringF(tempStr,'\d',FILE_FORMAT_VER)
  fs.writeLine(tempStr)
  StringF(tempStr,'\d',getObjId())
  fs.writeLine(tempStr)

  reactionLists:=getReactionLists()
  FOR i:=0 TO reactionLists.count()-1
    comp:=reactionLists.item(i)
    IF comp THEN comp.serialise(fs)
  ENDFOR

  FOR i:=0 TO objectList.count()-1
    comp:=objectList.item(i)
    IF comp 
      comp.serialise(fs)
    ENDIF
  ENDFOR
  
  changes:=FALSE
EXCEPT DO
  END fs 
ENDPROC TRUE

PROC saveFileAs()
  DEF tags
  DEF fr:PTR TO filerequester
  DEF fname[255]:STRING

  aslbase:=OpenLibrary('asl.library',37)
  IF aslbase=NIL THEN Throw("LIB","ASL")
  tags:=NEW [ASL_HAIL,'Enter a file to save as',
     ASL_WINDOW, win,
     TAG_DONE]
  fr:=AllocAslRequest(ASL_FILEREQUEST,tags)
  IF(AslRequest(fr,0))=FALSE
    IF tags THEN FastDisposeList(tags)
    IF aslbase THEN CloseLibrary(aslbase)
    RETURN FALSE
  ENDIF

  StrCopy(fname,fr.drawer)
  AddPart(fname,fr.file,100)
  SetStr(fname)
  StrCopy(filename,fname)
  IF fr THEN FreeAslRequest(fr)
  IF tags THEN FastDisposeList(tags)
  IF aslbase THEN CloseLibrary(aslbase)

  IF FileLength(filename)>=0
    IF warnRequest(win,'Warning','This file already exists,\ndo you want to overwrite?',TRUE)=0 THEN RETURN FALSE
  ENDIF
ENDPROC saveFile()

PROC unsavedChangesWarning()
  DEF reqmsg:PTR TO orrequest
  DEF reqobj
  DEF res=0
  
  NEW reqmsg
  reqmsg.methodid:=RM_OPENREQ
  reqmsg.window:=win
  reqmsg.attrs:=[REQ_TYPE, REQTYPE_INFO, REQ_IMAGE, REQIMAGE_WARNING, REQ_TITLETEXT,'Warning',REQ_BODYTEXT,'You have unsaved changes,\ndo you wish to save them first?',REQ_GADGETTEXT,'_Yes|_No|_Cancel',TAG_END]
  reqobj:=NewObjectA(Requester_GetClass(),0,[TAG_END])
  IF reqobj
    res:=DoMethodA(reqobj, reqmsg)
    DisposeObject(reqobj)
  ENDIF
  END reqmsg
ENDPROC res

PROC showAbout()
  DEF reqmsg:PTR TO orrequest
  DEF reqobj
  
  NEW reqmsg
  reqmsg.methodid:=RM_OPENREQ
  reqmsg.window:=win
  reqmsg.attrs:=[REQ_TITLETEXT,'About',REQ_BODYTEXT,'ReBuilder\n\nThe Reaction UI Builder Tool\nWritten By Darren Coles',REQ_GADGETTEXT,'_Ok',TAG_END]
  reqobj:=NewObjectA(Requester_GetClass(),0,[TAG_END])
  IF reqobj
    DoMethodA(reqobj, reqmsg)
    DisposeObject(reqobj)
  ENDIF
  END reqmsg
ENDPROC

PROC doLoad()
  DEF res
  IF changes
    res:=unsavedChangesWarning()
    IF res=0 THEN RETURN
    IF res=1 THEN IF saveFile()=FALSE THEN RETURN
  ENDIF
  closePreviews()
  loadFile()
  restorePreviews()
ENDPROC

PROC doNew()
  DEF res
  IF changes
    res:=unsavedChangesWarning()
    IF res=0 THEN RETURN
    IF res=1 THEN IF saveFile()=FALSE THEN RETURN
  ENDIF
  closePreviews()
  newProject()
  openPreviews()
ENDPROC

PROC doAddWindow()
  DEF newwin:PTR TO windowObject

  objectList.add(newwin:=createWindowObject(0))  ->extra window
  objectList.add(createMenuObject(0)) ->extra menu
  objectList.add(createLayoutObject(0)) ->extra layout
  makeList()
  RA_OpenWindow(newwin.previewObject)
  remakePreviewMenus()
  changes:=TRUE
ENDPROC

PROC doAddComp(comp:PTR TO reactionObject, objType)
  DEF newObj:PTR TO reactionObject
  changes:=TRUE
  newObj:=0
  WHILE (comp<>0) AND (comp.type<>TYPE_LAYOUT) DO comp:=comp.parent
  IF comp
    newObj:=createObjectByObj(objType,comp)
    IF newObj 
      IF newObj.editSettings()
        addObject(comp,newObj)
      ELSE
        END newObj
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC doAdd()
  DEF objType
  DEF comp:PTR TO reactionObject
  DEF frmObjectPicker:PTR TO objectPickerForm

  comp:=selectedComp
  IF (comp.type=TYPE_SCREEN) OR (comp.type=TYPE_WINDOW)
    doAddWindow()
    RETURN
  ENDIF

  NEW frmObjectPicker.create()
  IF (objType:=frmObjectPicker.selectItem())<>-1
    doAddComp(comp,objType)
  ENDIF
  END frmObjectPicker
ENDPROC

PROC doEdit()
  DEF idx, mainRootLayout, previewRootLayout
  DEF winObj:PTR TO windowObject
  DEF pwin
  IF selectedComp
    IF selectedComp.editSettings()
      changes:=TRUE
      idx:=findWindowIndex(selectedComp)
      IF idx<>-1
        mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
        winObj:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
        previewRootLayout:=winObj.previewRootLayout
        removeMembers(mainRootLayout,previewRootLayout)
        IF selectedComp.type=TYPE_WINDOW THEN RA_CloseWindow(selectedComp.previewObject)
        makeList(selectedComp)
        addMembers(mainRootLayout,previewRootLayout)

        IF selectedComp.type=TYPE_MENU
          pwin:=Gets(winObj.previewObject,WINDOW_WINDOW)
          IF pwin THEN ClearMenuStrip(pwin)
          selectedComp.createPreviewObject()
        ENDIF
        
        IF selectedComp.type=TYPE_WINDOW 
          selectedComp.createPreviewObject()
          RA_OpenWindow(selectedComp.previewObject)
        ENDIF
        rethinkPreviews()
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC doDelete()
  IF warnRequest(win,'Warning','Are you sure you wish\nto delete this item?',TRUE)=1
    changes:=TRUE
    removeObject(selectedComp.parent,selectedComp)
  ENDIF
ENDPROC

PROC doClose()
  DEF res
  IF changes
    res:=unsavedChangesWarning()
    IF res=0 THEN RETURN FALSE
    IF res=1 THEN IF saveFile()=FALSE THEN RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC copyToBuffer(comp:PTR TO reactionObject)
  DEF newObj:PTR TO reactionObject
  DEF fs:PTR TO fileStreamer

  NEW fs.create('t:tempcomp',MODE_NEWFILE)
  comp.serialise(fs)
  END fs
  
  newObj:=createObjectByType(comp.type,0)
  NEW fs.create('t:tempcomp',MODE_OLDFILE)
  newObj.deserialise(fs)
  END fs
  bufferList.add(newObj)
  makeBufferList()
ENDPROC

PROC moveToBuffer(comp:PTR TO reactionObject)
  changes:=TRUE
  copyToBuffer(comp)
  removeObject(comp.parent,comp)
ENDPROC

PROC copyFromBuffer(bufferComp:PTR TO reactionObject)
  DEF newObj:PTR TO reactionObject
  DEF comp:PTR TO reactionObject
  DEF fs:PTR TO fileStreamer
  DEF oldid
  DEF name[100]:STRING

  NEW fs.create('t:tempcomp',MODE_NEWFILE)
  bufferComp.serialise(fs)
  END fs
  
  newObj:=createObjectByType(bufferComp.type,0)
  oldid:=newObj.id
  NEW fs.create('t:tempcomp',MODE_OLDFILE)
  newObj.deserialise(fs)
  newObj.id:=oldid

  StringF(name,'\s_\d',newObj.getTypeName(),oldid)
  AstrCopy(newObj.name,name)
  
  END fs

  comp:=selectedComp
  WHILE (comp<>0) AND (comp.type<>TYPE_LAYOUT) DO comp:=comp.parent
  IF comp THEN addObject(comp,newObj) ELSE END newObj
  DeleteFile('t:tempcomp')
  changes:=TRUE
ENDPROC

PROC moveFromBuffer(bufferComp:PTR TO reactionObject)
  DEF i
  copyFromBuffer(bufferComp)
  removeBufferItem(bufferComp)
  changes:=TRUE
ENDPROC

PROC removeBufferItem(bufferComp:PTR TO reactionObject)
  DEF i
  FOR i:=bufferList.count()-1 TO 0 STEP -1
    IF bufferList.item(i)=bufferComp THEN bufferList.remove(i)
  ENDFOR
  makeBufferList()
ENDPROC

PROC makeBufferList()
  DEF comp:PTR TO reactionObject
  DEF compStr[100]:STRING
  DEF i,n
  
  SetGadgetAttrsA(gMain_Gadgets[GAD_TEMPLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  IF list2 THEN freeBrowserNodes( list2 )
  list2:=browserNodesA([0])

  FOR i:=0 TO bufferList.count()-1
    comp:=bufferList.item(i)
    IF StrLen(comp.name)=0
      StringF(compStr,'\s',comp.getTypeName())
    ELSE
      StringF(compStr,'\s - \s',comp.getTypeName(),comp.name)
    ENDIF
    IF (n:=AllocListBrowserNodeA(1, [LBNA_USERDATA, comp, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, compStr,TAG_END])) THEN AddTail(list2, n) ELSE Raise("MEM")
  ENDFOR
  
  SetGadgetAttrsA(gMain_Gadgets[GAD_TEMPLIST],win,0,[LISTBROWSER_LABELS, list2, TAG_END])
  updateBufferSel(win,Gets(gMain_Gadgets[GAD_TEMPLIST],LISTBROWSER_SELECTEDNODE))
ENDPROC

PROC disposeObjects()
  DEF comp:PTR TO reactionObject
  DEF reactionLists:PTR TO stdlist
  DEF i
  
  reactionLists:=getReactionLists()
  FOR i:=0 TO reactionLists.count()-1
    comp:=reactionLists.item(i)
    IF comp THEN END comp
  ENDFOR
  reactionLists.clear()

  FOR i:=0 TO objectList.count()-1
    comp:=objectList.item(i)
    IF comp THEN END comp
  ENDFOR
  objectList.clear()
ENDPROC

PROC disposeBufferObjects()
  DEF comp:PTR TO reactionObject
  DEF i
  FOR i:=0 TO bufferList.count()-1
    comp:=bufferList.item(i)
    IF comp THEN END comp
  ENDFOR
  bufferList.clear()
ENDPROC

PROC newProject()
  DEF i
  StrCopy(filename,'')

  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    removeMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i)::windowObject.previewRootLayout)
    i+=3
  ENDWHILE

  disposeObjects()
  objectInitialise()
  
  objectList.add(0)  ->Application begin
  objectList.add(createRexxObject(0))  ->Rexx
  objectList.add(createScreenObject(0))  ->Screen
  objectList.add(createWindowObject(0))  ->Window
  objectList.add(createMenuObject(0))  ->Menu
  objectList.add(createLayoutObject(0))  ->Layout
  makeList()

  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    addMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i)::windowObject.previewRootLayout)
    i+=3
  ENDWHILE
  rethinkPreviews()
  remakePreviewMenus()
  changes:=FALSE
ENDPROC

PROC toggleBuffer()
  IF bufferLayout
    SetGadgetAttrsA(mainWindowLayout,win,0,[LAYOUT_REMOVECHILD, bufferLayout,TAG_END])
    bufferLayout:=0
  ELSE
    createBufferGads()
    SetGadgetAttrsA(mainWindowLayout,win,0,[LAYOUT_ADDCHILD, bufferLayout,CHILD_WEIGHTEDWIDTH,20,TAG_END])
  ENDIF
  IF win THEN RethinkLayout(mainWindowLayout, win, 0, TRUE )

ENDPROC

PROC togglePreview(subitem)
  DEF idx,pwin
  DEF previewWin
  DEF winObj:PTR TO windowObject
  idx:=(subitem*3)+ROOT_WINDOW_ITEM
  winObj:=objectList.item(idx)
  previewWin:=winObj.previewObject
  pwin:=Gets(previewWin,WINDOW_WINDOW)
  IF pwin
    winObj.previewOpen:=FALSE
    RA_CloseWindow(previewWin)
  ELSE
    winObj.previewOpen:=TRUE
    RA_OpenWindow(previewWin)
  ENDIF
ENDPROC

PROC handlePreviewInputs()
  DEF pwin:PTR TO window,previewWin,i,code
  DEF winObj:PTR TO windowObject
  DEF left,top
  DEF result,tmp
  
  i:=ROOT_WINDOW_ITEM
  WHILE (i<objectList.count())
    winObj:=objectList.item(i)
    previewWin:=winObj.previewObject
    pwin:=Gets(previewWin,WINDOW_WINDOW)
    WHILE ((result:=RA_HandleInput(previewWin,{code})) <> WMHI_LASTMSG)
      tmp:=(result AND WMHI_CLASSMASK)
      SELECT tmp
        CASE WMHI_CHANGEWINDOW
          ->SetGadgetAttrsA(previewWin,pwin,0,[WA_LEFT,pwin.leftedge,WA_TOP,pwin.topedge,TAG_END])
        CASE WMHI_CLOSEWINDOW
          left:=Gets(previewWin,WA_LEFT)
          top:=Gets(previewWin,WA_TOP)
          winObj.previewOpen:=FALSE
          RA_CloseWindow(previewWin)
          SetGadgetAttrsA(previewWin,0,0,[WA_LEFT,left,WA_TOP,top,TAG_END])
          remakePreviewMenus()
      ENDSELECT
    ENDWHILE
    i+=3
  ENDWHILE
ENDPROC

PROC setBusy()
  SetWindowPointerA(win,[WA_BUSYPOINTER,TRUE,TAG_END])
ENDPROC

PROC clearBusy()
  SetWindowPointerA(win,[WA_BUSYPOINTER,FALSE,TAG_END])
ENDPROC

PROC remakePreviewMenus()
  DEF menuData:PTR TO newmenu,scr,visInfo
  DEF winObj:PTR TO windowObject
  DEF count,n,i

  count:=(objectList.count()-ROOT_WINDOW_ITEM)/4
  count:=count+54

  IF menus THEN FreeMenus(menus)

  NEW menuData[count]
  menuData[0].type:=NM_TITLE
  menuData[0].label:='Project'
  menuData[1].type:=NM_ITEM
  menuData[1].label:='New'
  menuData[2].type:=NM_ITEM
  menuData[2].label:='Open'
  menuData[3].type:=NM_ITEM
  menuData[3].label:='Save'
  menuData[4].type:=NM_ITEM
  menuData[4].label:='Save As'
  menuData[5].type:=NM_ITEM
  menuData[5].label:=NM_BARLABEL
  menuData[6].type:=NM_ITEM
  menuData[6].label:='Generate Code'
  menuData[7].type:=NM_ITEM
  menuData[7].label:=NM_BARLABEL
  menuData[8].type:=NM_ITEM
  menuData[8].label:='About'
  menuData[9].type:=NM_ITEM
  menuData[9].label:=NM_BARLABEL
  menuData[10].type:=NM_ITEM
  menuData[10].label:='Quit'
  menuData[11].type:=NM_TITLE
  menuData[11].label:='Edit'
  menuData[12].type:=NM_ITEM
  menuData[12].label:='Add'
  menuData[13].type:=NM_SUB
  menuData[13].label:='Button'
  menuData[14].type:=NM_SUB
  menuData[14].label:='Bitmap'
  menuData[15].type:=NM_SUB
  menuData[15].label:='CheckBox'
  menuData[16].type:=NM_SUB
  menuData[16].label:='Chooser'
  menuData[17].type:=NM_SUB
  menuData[17].label:='ClickTab'
  menuData[18].type:=NM_SUB
  menuData[18].label:='FuelGauge'
  menuData[19].type:=NM_SUB
  menuData[19].label:='GetFile'
  menuData[20].type:=NM_SUB
  menuData[20].label:='GetFont'
  menuData[21].type:=NM_SUB
  menuData[21].label:='GetScreenMode'
  menuData[22].type:=NM_SUB
  menuData[22].label:='Integer'
  menuData[23].type:=NM_SUB
  menuData[23].label:='Palette'
  menuData[24].type:=NM_SUB
  menuData[24].label:='PenMap'
  menuData[25].type:=NM_SUB
  menuData[25].label:='Layout'
  menuData[26].type:=NM_SUB
  menuData[26].label:='ListBrowser'
  menuData[27].type:=NM_SUB
  menuData[27].label:='RadioButton'
  menuData[28].type:=NM_SUB
  menuData[28].label:='Scroller'
  menuData[29].type:=NM_SUB
  menuData[29].label:='SpeedBar'
  menuData[30].type:=NM_SUB
  menuData[30].label:='Slider'
  menuData[31].type:=NM_SUB
  menuData[31].label:='StatusBar'
  menuData[32].type:=NM_SUB
  menuData[32].label:='String'
  menuData[33].type:=NM_SUB
  menuData[33].label:='Space'
  menuData[34].type:=NM_SUB
  menuData[34].label:='TextField'
  menuData[35].type:=NM_SUB
  menuData[35].label:='Bevel'
  menuData[36].type:=NM_SUB
  menuData[36].label:='DrawList'
  menuData[37].type:=NM_SUB
  menuData[37].label:='Glyph'
  menuData[38].type:=NM_SUB
  menuData[38].label:='Label'
  menuData[39].type:=NM_SUB
  menuData[39].label:=NM_BARLABEL
  menuData[40].type:=NM_SUB
  menuData[40].label:='Window'
  menuData[41].type:=NM_ITEM
  menuData[41].label:='Edit'
  menuData[42].type:=NM_ITEM
  menuData[42].label:='Delete'
  menuData[43].type:=NM_ITEM
  menuData[43].label:=NM_BARLABEL
  menuData[44].type:=NM_ITEM
  menuData[44].label:='Move Up'
  menuData[45].type:=NM_ITEM
  menuData[45].label:='Move Down'
  menuData[46].type:=NM_ITEM
  menuData[46].label:=NM_BARLABEL
  menuData[47].type:=NM_ITEM
  menuData[47].label:='Edit Lists'
  menuData[48].type:=NM_ITEM
  menuData[48].label:=NM_BARLABEL
  menuData[49].type:=NM_ITEM
  menuData[49].label:='Show Buffer'
  menuData[49].flags:=CHECKIT OR MENUTOGGLE OR CHECKED
  menuData[50].type:=NM_ITEM
  menuData[50].label:=NM_BARLABEL
  menuData[51].type:=NM_ITEM
  menuData[51].label:='Preview Windows'
  n:=52
  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    winObj:=objectList.item(i)
    menuData[n].type:=NM_SUB
    menuData[n].label:=winObj.name
    menuData[n].flags:=CHECKIT OR MENUTOGGLE
    IF Gets(winObj.previewObject,WINDOW_WINDOW) THEN menuData[n].flags:=menuData[n].flags OR CHECKED
    i+=3
    n++
  ENDWHILE
  menuData[n].type:=NM_END

  menus:=CreateMenusA(menuData,[GTMN_FRONTPEN,1,TAG_END])
  END menuData[count]

  scr:=LockPubScreen(NIL)
  visInfo:=GetVisualInfoA(scr, [TAG_END])
  UnlockPubScreen(NIL,scr)
  LayoutMenusA(menus,visInfo,[GTMN_NEWLOOKMENUS,TRUE,TAG_END])
  FreeVisualInfo(visInfo)
  IF win 
    SetMenuStrip(win,menus)
    updateSel(win,Gets(gMain_Gadgets[GAD_COMPONENTLIST],LISTBROWSER_SELECTEDNODE))
  ENDIF
ENDPROC


PROC rethinkPreviews()
  DEF pwin,previewWin,previewRootLayout,i
  DEF menu
  
  i:=ROOT_WINDOW_ITEM
  WHILE (i<objectList.count())
    previewWin:=objectList.item(i)::windowObject.previewObject
    menu:=objectList.item(i-ROOT_WINDOW_ITEM+ROOT_MENU_ITEM)::menuObject.previewObject
    previewRootLayout:=objectList.item(i)::windowObject.previewRootLayout
    IF previewWin
      pwin:=Gets(previewWin,WINDOW_WINDOW)
      IF pwin
        RethinkLayout(previewRootLayout, pwin, 0, TRUE )
        DoMethod(previewWin, WM_RETHINK)
        IF menu THEN SetMenuStrip(pwin,menu) ELSE ClearMenuStrip(pwin)
        RefreshWindowFrame(pwin)
      ENDIF
    ENDIF
    i+=3
  ENDWHILE
ENDPROC

PROC closePreviews()
  DEF previewWin,i
  
  i:=ROOT_WINDOW_ITEM
  WHILE (i<objectList.count())
    previewWin:=objectList.item(i)::windowObject.previewObject
    RA_CloseWindow(previewWin)
    i+=3
  ENDWHILE
  remakePreviewMenus()
ENDPROC

PROC openPreviews()
  DEF previewWin,i
  
  i:=ROOT_WINDOW_ITEM
  WHILE (i<objectList.count())
    previewWin:=objectList.item(i)::windowObject.previewObject
    RA_OpenWindow(previewWin)
    i+=3
  ENDWHILE
  remakePreviewMenus()
ENDPROC

PROC restorePreviews()
  DEF previewWin,i
  DEF winObj:PTR TO windowObject
  
  i:=ROOT_WINDOW_ITEM
  WHILE (i<objectList.count())
    winObj:=objectList.item(i)
    previewWin:=winObj.previewObject
    IF winObj.previewOpen
      RA_OpenWindow(previewWin)
    ENDIF
    i+=3
  ENDWHILE
  remakePreviewMenus()
ENDPROC

PROC editLists()
  DEF listManagerForm:PTR TO listManagerForm
  DEF idx,mainRootLayout, previewRootLayout
  
  setBusy()
  NEW listManagerForm.create()
  listManagerForm.manageLists()
  changes:=TRUE
  END listManagerForm
  clearBusy()
  
  idx:=ROOT_WINDOW_ITEM
  WHILE idx<objectList.count()
    mainRootLayout:=objectList.item(idx-ROOT_WINDOW_ITEM+ROOT_LAYOUT_ITEM)
    previewRootLayout:=objectList.item(idx)::windowObject.previewRootLayout
    removeMembers(mainRootLayout,previewRootLayout)
    makeList(selectedComp)
    addMembers(mainRootLayout,previewRootLayout)
    rethinkPreviews()
    idx+=3
  ENDWHILE
ENDPROC

PROC createObjectByObj(objType,comp)
  DEF newObj
  SELECT objType
    CASE OBJECT_BUTTON
      newObj:=createButtonObject(comp)
    CASE OBJECT_CHECKBOX
      newObj:=createCheckboxObject(comp)
    CASE OBJECT_LABEL
      newObj:=createLabelObject(comp)
    CASE OBJECT_LAYOUT
      newObj:=createLayoutObject(comp)
    CASE OBJECT_STRING
      newObj:=createStringObject(comp)
    CASE OBJECT_INTEGER
      newObj:=createIntegerObject(comp)
    CASE OBJECT_SPACE
      newObj:=createSpaceObject(comp)
    CASE OBJECT_GLYPH
      newObj:=createGlyphObject(comp)
    CASE OBJECT_SCROLLER
      newObj:=createScrollerObject(comp)
    CASE OBJECT_PALETTE
      newObj:=createPaletteObject(comp)
    CASE OBJECT_RADIO
      newObj:=createRadioObject(comp)
    CASE OBJECT_CHOOSER
      newObj:=createChooserObject(comp)
    CASE OBJECT_CLICKTAB
      newObj:=createClickTabObject(comp)
    CASE OBJECT_LISTBROWSER
      newObj:=createListBrowserObject(comp)
    CASE OBJECT_BEVEL
      newObj:=createBevelObject(comp)
    CASE OBJECT_FUELGAUGE
      newObj:=createFuelGaugeObject(comp)
    CASE OBJECT_DRAWLIST
      newObj:=createDrawListObject(comp)
    CASE OBJECT_TEXTFIELD
      newObj:=createTextFieldObject(comp)
    CASE OBJECT_GETFILE
      newObj:=createGetFileObject(comp)
    CASE OBJECT_GETFONT
      newObj:=createGetFontObject(comp)
    CASE OBJECT_GETSCREENMODE
      newObj:=createGetScreenModeObject(comp)
  ENDSELECT
ENDPROC newObj

PROC createObjectByType(objType,comp)
  DEF newObj
  SELECT objType
    CASE TYPE_REACTIONLIST
      newObj:=createReactionListObject(comp)
    CASE TYPE_REXX
      newObj:=createRexxObject(comp)
    CASE TYPE_BUTTON
      newObj:=createButtonObject(comp)
    CASE TYPE_CHECKBOX
      newObj:=createCheckboxObject(comp)
    CASE TYPE_LABEL
      newObj:=createLabelObject(comp)
    CASE TYPE_LAYOUT
      newObj:=createLayoutObject(comp)
    CASE TYPE_STRING
      newObj:=createStringObject(comp)
    CASE TYPE_RADIO
      newObj:=createRadioObject(comp)
    CASE TYPE_CHOOSER
      newObj:=createChooserObject(comp)
    CASE TYPE_CLICKTAB
      newObj:=createClickTabObject(comp)
    CASE TYPE_LISTBROWSER
      newObj:=createListBrowserObject(comp)
    CASE TYPE_BEVEL
      newObj:=createBevelObject(comp)
    CASE TYPE_DRAWLIST
      newObj:=createDrawListObject(comp)
    CASE TYPE_FUELGAUGE
      newObj:=createFuelGaugeObject(comp)
    CASE TYPE_TEXTFIELD
      newObj:=createTextFieldObject(comp)
    CASE TYPE_GETFILE
      newObj:=createGetFileObject(comp)
    CASE TYPE_GETFONT
      newObj:=createGetFontObject(comp)
    CASE TYPE_GETSCREENMODE
      newObj:=createGetScreenModeObject(comp)
    CASE TYPE_INTEGER
      newObj:=createIntegerObject(comp)
    CASE TYPE_SPACE
      newObj:=createSpaceObject(comp)
    CASE TYPE_GLYPH
      newObj:=createGlyphObject(comp)
    CASE TYPE_SCROLLER
      newObj:=createScrollerObject(comp)
    CASE TYPE_PALETTE
      newObj:=createPaletteObject(comp)
    CASE TYPE_SCREEN
      newObj:=createScreenObject(comp)
    CASE TYPE_WINDOW
      newObj:=createWindowObject(comp)
    CASE TYPE_MENU
      newObj:=createMenuObject(comp)
  ENDSELECT
ENDPROC newObj

PROC getAllWindowSigs()
  DEF wsig,wsig2,i
  GetAttr( WINDOW_SIGMASK, mainWindow, {wsig} )
  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    GetAttr( WINDOW_SIGMASK, objectList.item(i)::windowObject.previewObject, {wsig2} )
    wsig:=wsig OR wsig2
    i+=3
  ENDWHILE
ENDPROC wsig

PROC main() HANDLE
  DEF running=TRUE
  DEF wsig,code,code2,tmp,sig,result
  DEF objType
  DEF newObj:PTR TO reactionObject
  DEF comp:PTR TO reactionObject
  DEF cont
  DEF menu,menuitem,subitem
  DEF reactionList:PTR TO reactionListObject
  DEF i

  openClasses()
  NEW objectList.stdlist(20)
  NEW bufferList.stdlist(20)
  initReactionLists()
  
  createForm()
  
  IF (win:=RA_OpenWindow(mainWindow))
    SetMenuStrip(win,menus)
    newProject()
    openPreviews()
    updateBufferSel(win,0)

    GetAttr( WINDOW_SIGMASK, mainWindow, {wsig} )
    wsig:=getAllWindowSigs()
    WHILE running
      sig:=Wait(wsig)
      handlePreviewInputs()
      IF (sig AND (wsig))
        WHILE ((result:=RA_HandleInput(mainWindow,{code})) <> WMHI_LASTMSG)
          tmp:=(result AND WMHI_CLASSMASK)
          SELECT tmp
            CASE WMHI_MENUPICK
              menu:=result AND $1F
              menuitem:=(Shr((result),5) AND $3F)
              subitem:=(Shr((result),11) AND $1F)
              SELECT menu
                CASE MENU_PROJECT
                  SELECT menuitem
                    CASE MENU_PROJECT_NEW ->New
                      doNew()
                    CASE MENU_PROJECT_LOAD ->Load
                      doLoad()
                    CASE MENU_PROJECT_SAVE ->Save
                      saveFile()
                    CASE MENU_PROJECT_SAVEAS ->Save As
                      saveFileAs()
                    CASE MENU_PROJECT_GENCODE ->Generate Code
                      genCode()
                    CASE MENU_PROJECT_ABOUT
                      showAbout()
                    CASE MENU_PROJECT_QUIT
                      IF doClose() THEN running:=FALSE
                  ENDSELECT
                CASE MENU_EDIT
                  SELECT menuitem
                    CASE MENU_EDIT_ADD  ->Add
                      IF subitem>OBJECT_LABEL
                        doAddWindow()
                      ELSE
                        doAddComp(selectedComp,subitem)
                      ENDIF
                    CASE MENU_EDIT_EDIT ->Edit
                      doEdit()
                    CASE MENU_EDIT_DELETE  ->Delete
                      doDelete()
                    CASE MENU_EDIT_MOVEUP  ->MoveUp
                      moveUp(selectedComp.parent,selectedComp)
                    CASE MENU_EDIT_MOVEDOWN  ->MoveDown
                      moveDown(selectedComp.parent,selectedComp)
                    CASE MENU_EDIT_LISTS
                      editLists()
                    CASE MENU_EDIT_BUFFER
                      toggleBuffer()
                    CASE MENU_EDIT_PREVIEW
                      togglePreview(subitem)
                  ENDSELECT
              ENDSELECT
              
            CASE WMHI_GADGETUP
              SELECT result AND $FFFF
                CASE GAD_COMPONENTLIST
                  tmp:=Gets(gMain_Gadgets[GAD_COMPONENTLIST],LISTBROWSER_RELEVENT)
                  IF tmp=LBRE_NORMAL
                    updateSel(win,Gets(gMain_Gadgets[GAD_COMPONENTLIST],LISTBROWSER_SELECTEDNODE))
                  ELSEIF tmp=LBRE_DOUBLECLICK
                    doEdit()
                  ENDIF
                CASE GAD_TEMPLIST
                  updateBufferSel(win,Gets(gMain_Gadgets[GAD_TEMPLIST],LISTBROWSER_SELECTEDNODE))
                CASE GAD_ADD  ->Add
                  doAdd()
                CASE GAD_GENMINUS  ->Gen-
                  doGenUp(selectedComp.parent,selectedComp)
                CASE GAD_GENPLUS  ->Gen+
                  doGenDown(selectedComp.parent,selectedComp)
                CASE GAD_DELETE  ->Delete
                  doDelete()
                CASE GAD_MOVEUP  ->Move Up
                  moveUp(selectedComp.parent,selectedComp)
                CASE GAD_MOVEDOWN  ->Move Down
                  moveDown(selectedComp.parent,selectedComp)
                CASE GAD_LISTS  ->Lists
                  editLists()
                CASE GAD_CODE  ->Code
                  genCode()
                CASE GAD_LOAD  ->Load
                  doLoad()
                CASE GAD_SAVE  ->Save
                  saveFile()
                CASE GAD_NEW  ->New
                  doNew()
                CASE GAD_TEMP_COPYTO
                  copyToBuffer(selectedComp)
                CASE GAD_TEMP_MOVETO
                  moveToBuffer(selectedComp)
                CASE GAD_TEMP_COPYFROM
                  copyFromBuffer(selectedBuffComp)
                CASE GAD_TEMP_MOVEFROM
                  moveFromBuffer(selectedBuffComp)
                CASE GAD_TEMP_REMOVE
                  removeBufferItem(selectedBuffComp)
              ENDSELECT
            CASE WMHI_ICONIFY
              RA_Iconify(mainWindow)
              closePreviews()

            CASE WMHI_UNICONIFY
              IF (win:=RA_OpenWindow(mainWindow))
                SetMenuStrip(win,menus)
                restorePreviews()
                GetAttr( WINDOW_SIGMASK, mainWindow, {wsig} )
              ENDIF
            CASE WMHI_CLOSEWINDOW
              IF doClose() THEN running:=FALSE
          ENDSELECT
        ENDWHILE
      ENDIF
    ENDWHILE
  ELSE
    Raise("WIN")
  ENDIF
  
EXCEPT DO
  WriteF('shutdown\n')
  RA_CloseWindow(mainWindow)
  win:=0
  WriteF('window closed\n')
  closePreviews()
  WriteF('previews closed\n')
  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    removeMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i)::windowObject.previewRootLayout)
    i+=3
  ENDWHILE
  WriteF('members removed\n')
  FreeMenus(menus)
  WriteF('menus freed\n')
  disposeObjects()
  WriteF('objects disposed\n')
  END objectList
  WriteF('objects freed\n')
  disposeBufferObjects()
  WriteF('buffer objects disposed\n')
  END bufferList
  WriteF('buffer freed\n')
  freeReactionLists()
  WriteF('reactionlists freed\n')
  freeBrowserNodes( list )
  WriteF('browsernodes disposed\n')
  freeBrowserNodes( list2 )
  WriteF('browsernodes2 disposed\n')
  DisposeObject(mainWindow)
  WriteF('mainwindow disposed\n')
  IF (appPort) THEN DeleteMsgPort(appPort)
  WriteF('appport deleted\n')
  closeClasses()
  WriteF('classes closed\n')
ENDPROC
