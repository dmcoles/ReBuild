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
        '*bball',
        '*textfield',
        'penmap',
        'bitmap',
        'getfile',
        'getfont',
        'getscreenmode',
        'fuelgauge',
        'radiobutton',
        'clicktab',
        'speedbar',
        'colorwheel',
        'datebrowser',
        'getcolor',
        'listview',
        'sketchboard',
        'texteditor',
        'virtual',
        'scroller','glyph','slider',
        'gadtools','libraries/gadtools',
        'dos/dos',
        'exec',
        'asl','libraries/asl',
        'tools/boopsi',
        'amigalib/boopsi','exec/memory',
        'listbrowser','gadgets/listbrowser',
        'intuition/intuition','intuition/imageclass','intuition/gadgetclass','intuition/classusr'

  MODULE '*fileStreamer','*objectPicker','*cSourceGen', '*eSourceGen',
         '*sourceGen','*codeGenForm','*listManagerForm','*reactionLists','*dialogs','*libraryVersions',
         '*getScreenModeObject','*getFontObject','*getFileObject','*textFieldObject','*drawListObject','*fuelGaugeObject',
         '*bevelObject','*listBrowserObject','*clickTabObject','*chooserObject','*radioObject','*menuObject',
         '*rexxObject','*reactionListObject','*windowObject','*screenObject','*layoutObject','*paletteObject',
         '*scrollerObject','*glyphObject','*spaceObject','*labelObject','*checkboxObject','*buttonObject',
         '*stringObject','*integerObject','*stringlist','*reactionObject','*reactionForm','*boingBallObject',
         '*penMapObject','*sliderObject','*bitmapObject','*speedBarObject'

#define vernum '0.1.0-alpha'
#date verstring '$VER:Rebuild 0.1.0-%Y%m%d%h%n%s-alpha'

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
  CONST MENU_PROJECT_SHOWLIBS=7
  CONST MENU_PROJECT_ABOUT=9
  CONST MENU_PROJECT_QUIT=11

  CONST MENU_EDIT_ADD=0
  CONST MENU_EDIT_ADD_MORE=1
  CONST MENU_EDIT_EDIT=2
  CONST MENU_EDIT_DELETE=3
  CONST MENU_EDIT_MOVEUP=5
  CONST MENU_EDIT_MOVEDOWN=6
  CONST MENU_EDIT_LISTS=8
  CONST MENU_EDIT_BUFFER=10
  CONST MENU_EDIT_SHOW_ADD_SETTINGS=11
  CONST MENU_EDIT_WARN_ON_DEL=12
  CONST MENU_EDIT_PREVIEW=14

  CONST FILE_FORMAT_VER=1

  DEF columninfo[4]:ARRAY OF columninfo
  DEF columninfo2[2]:ARRAY OF columninfo
  DEF mainWindow=0
  DEF mainWindowLayout=0
  DEF bufferLayout=0
  DEF appPort=0
  DEF win:PTR TO window
  DEF gMain_Gadgets[GAD_COUNT]:ARRAY OF LONG
  DEF objectList=0:PTR TO stdlist
  DEF bufferList=0:PTR TO stdlist
  DEF selectedComp:PTR TO reactionObject
  DEF selectedBuffComp:PTR TO reactionObject
  DEF list=0,list2=0
  DEF changes=FALSE
  DEF menus=0
  DEF filename[255]:STRING
  DEF windowTitle[200]:STRING
  
  DEF gradientsliderbase=0
  DEF progressbase=0
  DEF statusbarbase=0
  DEF tapedeckbase=0
  DEF texteditorbase=0
  DEF textentrybase=0
  DEF ledbase=0
  DEF smartbitmapbase=0
  DEF titlebarbase=0

PROC openClasses()
  IF (requesterbase:=OpenLibrary('requester.class',0))=NIL THEN Throw("LIB","reqr")
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',0))=NIL THEN Throw("LIB","gadt")
  IF (windowbase:=OpenLibrary('window.class',0))=NIL THEN Throw("LIB","win")
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
  IF (sliderbase:=OpenLibrary('gadgets/slider.gadget',0))=NIL THEN Throw("LIB","sldr")
  speedbarbase:=OpenLibrary('gadgets/speedbar.gadget',0)
  IF (glyphbase:=OpenLibrary('images/glyph.image',0))=NIL THEN Throw("LIB","glyp")
  IF (labelbase:=OpenLibrary('images/label.image',0))=NIL THEN Throw("LIB","labl")
  IF (bevelbase:=OpenLibrary('images/bevel.image',0))=NIL THEN Throw("LIB","bevl")
  IF (drawlistbase:=OpenLibrary('images/drawlist.image',0))=NIL THEN Throw("LIB","draw")
  IF (penmapbase:=OpenLibrary('images/penmap.image',0))=NIL THEN Throw("LIB","penm")
  IF (bitmapbase:=OpenLibrary('images/bitmap.image',0))=NIL THEN Throw("LIB","bitm")
  colorwheelbase:=OpenLibrary('gadgets/colorwheel.gadget',0)
  datebrowserbase:=OpenLibrary('gadgets/datebrowser.gadget',0)
  getcolorbase:=OpenLibrary('gadgets/getcolor.gadget',0)
  gradientsliderbase:=OpenLibrary('gadgets/gradientslider.gadget',0)
  listviewbase:=OpenLibrary('gadgets/listview.gadget',0)
  progressbase:=OpenLibrary('gadgets/progress.gadget',0)
  sketchboardbase:=OpenLibrary('gadgets/sketchboard.gadget',0)
  statusbarbase:=OpenLibrary('gadgets/statusbar.gadget',0)
  tapedeckbase:=OpenLibrary('gadgets/tapedeck.gadget',0)
  texteditorbase:=OpenLibrary('gadgets/texteditor.gadget',0)
  textentrybase:=OpenLibrary('gadgets/textentry.gadget',0)
  virtualbase:=OpenLibrary('gadgets/virtual.gadget',0)
  boingballbase:=OpenLibrary('images/boingball.image',0)
  ledbase:=OpenLibrary('images/led.image',0)
  smartbitmapbase:=OpenLibrary('images/smartbitmap.image',0)
  titlebarbase:=OpenLibrary('images/titlebar.image',0)
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
  IF sliderbase THEN CloseLibrary(sliderbase)
  IF speedbarbase THEN CloseLibrary(speedbarbase)
 
  IF glyphbase THEN CloseLibrary(glyphbase)
  IF labelbase THEN CloseLibrary(labelbase)
  IF bevelbase THEN CloseLibrary(bevelbase)
  IF drawlistbase THEN CloseLibrary(drawlistbase)
  IF penmapbase THEN CloseLibrary(penmapbase)
  IF bitmapbase THEN CloseLibrary(bitmapbase)

  IF colorwheelbase THEN CloseLibrary(colorwheelbase)
  IF datebrowserbase THEN CloseLibrary(datebrowserbase)
  IF getcolorbase THEN  CloseLibrary(getcolorbase)
  IF gradientsliderbase THEN CloseLibrary(gradientsliderbase)
  IF listviewbase THEN CloseLibrary(listviewbase)
  IF progressbase THEN CloseLibrary(progressbase)
  IF sketchboardbase THEN CloseLibrary(sketchboardbase)
  IF statusbarbase THEN CloseLibrary(statusbarbase)
  IF tapedeckbase THEN CloseLibrary(tapedeckbase)
  IF texteditorbase THEN CloseLibrary(texteditorbase)
  IF textentrybase THEN CloseLibrary(textentrybase)
  IF virtualbase THEN CloseLibrary(virtualbase)
  IF boingballbase THEN CloseLibrary(boingballbase)
  IF ledbase THEN CloseLibrary(ledbase)
  IF smartbitmapbase THEN CloseLibrary(smartbitmapbase)
  IF titlebarbase THEN CloseLibrary(titlebarbase)
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
  StringF(typeStr,'\s',comp.getTypeName())
  IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, IF (comp.parent=0) OR (comp.allowChildren()) THEN LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN ELSE 0,LBNA_USERDATA, comp, LBNA_GENERATION, generation, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, compStr, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, typeStr,LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, idStr,TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
  comp.node:=n
  
  IF comp=selcomp THEN newnode[]:=n
  
  IF comp.allowChildren()
    FOR i:=0 TO comp.children.count()-1
      makeComponentList(comp.children.item(i),generation+1,list, selcomp, newnode)
    ENDFOR
  ENDIF
ENDPROC

PROC removeMembers(comp:PTR TO reactionObject,window:PTR TO windowObject)
  DEF i, parent:PTR TO reactionObject
  IF comp
    FOR i:=0 TO comp.children.count()-1
      removeMembers(comp.children.item(i),window)
    ENDFOR
    IF comp.parent THEN parent:=comp.parent ELSE parent:=window
    WriteF('removing comp \h \h\n',parent.addChildTo(), comp.previewObject)
    IF comp.previewObject
      Sets(parent.addChildTo(),parent.removeChildTag(), comp.previewObject)
      comp.previewObject:=0
      comp.previewChildAttrs:=0
    ENDIF
    WriteF('removed comp \h \h\n',parent.addChildTo(), comp.previewObject)
  ENDIF
ENDPROC

PROC addMembers(comp:PTR TO reactionObject,window:PTR TO windowObject)
  DEF i, parent:PTR TO reactionObject
  IF comp
    IF comp.parent THEN parent:=comp.parent ELSE parent:=window
    WriteF('adding comp \h \h\n',parent.addChildTo(),comp.previewObject)
    comp.createPreviewObject(win.wscreen)
    IF (comp.isImage())
      SetGadgetAttrsA(parent.addChildTo(),0,0,[parent.addImageTag(), comp.previewObject, TAG_END])
    ELSE
      SetGadgetAttrsA(parent.addChildTo(),0,0,[parent.addChildTag(), comp.previewObject, TAG_END])
    ENDIF
    IF comp.previewChildAttrs THEN SetGadgetAttrsA(parent.previewObject,0,0,comp.previewChildAttrs)
    WriteF('added comp \h \h\n',parent.previewObject,comp.previewObject)

    FOR i:=0 TO comp.children.count()-1
      addMembers(comp.children.item(i),window)
    ENDFOR
  ENDIF
ENDPROC

PROC makeList(selcomp=0)
  DEF n,i
  DEF newnode=0
  DEF depth
  DEF comp:PTR TO reactionObject
  
  SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  IF list THEN freeBrowserNodes( list )
  list:=browserNodesA([0])

  FOR i:=0 TO objectList.count()-1
    IF objectList.item(i)=0
      SELECT i
        CASE ROOT_APPLICATION_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 1, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Application Begin', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_REXX_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 2, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Rexx', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_SCREEN_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 2, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Screen', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_WINDOW_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 3, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Window - Main', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT,'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
        CASE ROOT_MENU_ITEM
          IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS, LBFLG_HASCHILDREN OR LBFLG_SHOWCHILDREN, LBNA_USERDATA, 0, LBNA_GENERATION, 4, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Menu', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
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

  IF (n:=AllocListBrowserNodeA(3, [LBNA_USERDATA, 0, LBNA_GENERATION, 1, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'Application End', LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'System',LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, 'N/A',TAG_END])) THEN AddTail(list, n) ELSE Raise("MEM")
-> Reattach the list
  SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_LABELS,list,0])
  IF win 
    IF newnode
      SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_SELECTEDNODE, newnode,0])
      updateSel(newnode)
    ELSE
      SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_SELECTED, -1,0])
      updateSel(0)
    ENDIF
  ENDIF
  
ENDPROC

PROC menuCode(menu,item,subitem) IS (subitem<<11) OR ((item << 5) OR menu)

PROC menuDisable(win,menu,item,subitem,flag)
  IF flag THEN OffMenu(win,menuCode(menu,item,subitem)) ELSE OnMenu(win,menuCode(menu,item,subitem))
ENDPROC

PROC updateSel(node)
  DEF comp=0:PTR TO reactionObject
  DEF child:PTR TO reactionObject
  DEF dis,idx
  DEF check,i,j
  DEF dismoveup,dismovedown,disdel
  DEF menuItem
  DEF type
  
  IF node THEN GetListBrowserNodeAttrsA(node,[LBNA_USERDATA,{comp},TAG_END])
  IF comp
    selectedComp:=comp
    FOR i:=0 TO 31
      FOR j:=0 TO 1
        menuItem:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,IF j=0 THEN MENU_EDIT_ADD ELSE MENU_EDIT_ADD_MORE,i))
        IF menuItem
          type:=GTMENUITEM_USERDATA(menuItem)
          IF type<>-1
            check:=((comp.parent=0) AND (comp.allowChildren()=FALSE)) OR (type==[TYPE_STATUSBAR,
              TYPE_COLORWHEEL, TYPE_DATEBROWSER, TYPE_GETCOLOR, TYPE_GRADSLIDER,
              TYPE_LISTVIEW, TYPE_PAGE, TYPE_PROGRESS, TYPE_SKETCH,TYPE_TAPEDECK,
              TYPE_TEXTEDITOR, TYPE_TEXTENTRY, TYPE_VIRTUAL, TYPE_LED,
              TYPE_SMARTBITMAP, TYPE_TITLEBAR])
            
            menuDisable(win,MENU_EDIT,IF j=0 THEN MENU_EDIT_ADD ELSE MENU_EDIT_ADD_MORE,i,check)
          ENDIF
        ENDIF
      ENDFOR
    ENDFOR
    
    IF comp.parent=0
      IF comp.type=TYPE_WINDOW
        idx:=findWindowIndex(comp)
        dismoveup:=idx=0
        dismovedown:=idx=(((objectList.count()-ROOT_WINDOW_ITEM)/3)-1)
        disdel:=(objectList.count()=(ROOT_WINDOW_ITEM+3))
      ELSE
        dismoveup:=TRUE
        dismovedown:=TRUE
        disdel:=TRUE
      ENDIF
    ELSE
      dismoveup:=comp.getChildIndex()=0
      dismovedown:=comp.getChildIndex()=(comp.parent.children.count()-1)
      disdel:=comp.parent=0
    ENDIF
    
    menuDisable(win,MENU_EDIT,MENU_EDIT_EDIT,0,FALSE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_DELETE,0,disdel)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVEUP,0,dismoveup)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVEDOWN,0,dismovedown)
    
    SetGadgetAttrsA(gMain_Gadgets[GAD_ADD],win,0,[GA_DISABLED,(comp.parent=0) AND (comp.allowChildren()=FALSE) AND (comp.type<>TYPE_SCREEN) AND (comp.type<>TYPE_WINDOW),TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_GENMINUS],win,0,[GA_DISABLED,Not((comp.parent<>0) ANDALSO (comp.parent.parent<>0)),TAG_END])

    IF bufferLayout
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYTO],win,0,[GA_DISABLED,(comp.parent=0) AND (comp.allowChildren()=FALSE) AND (comp.type<>TYPE_WINDOW),TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVETO],win,0,[GA_DISABLED,(((comp.parent=0) AND (comp.type<>TYPE_WINDOW)) OR comp.children.count()),TAG_END])
    ENDIF

    
    dis:=TRUE
    IF comp.parent
      idx:=comp.getChildIndex()
      IF (idx<(comp.parent.children.count()-1))
        child:=comp.parent.children.item(idx+1)
        IF ((child.allowChildren()))
          dis:=FALSE
        ENDIF
      ENDIF
    ENDIF
    SetGadgetAttrsA(gMain_Gadgets[GAD_GENPLUS],win,0,[GA_DISABLED,dis,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_DELETE],win,0,[GA_DISABLED,disdel,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_MOVEUP],win,0,[GA_DISABLED,dismoveup,TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_MOVEDOWN],win,0,[GA_DISABLED,dismovedown,TAG_END])

    IF bufferLayout
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,selectedBuffComp=0,TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,selectedBuffComp=0,TAG_END])
    ENDIF
  ELSE
    selectedComp:=0
    FOR i:=0 TO 31
      menuItem:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_ADD,i))
      IF menuItem
        type:=GTMENUITEM_USERDATA(menuItem)
        IF type<>-1 THEN menuDisable(win,MENU_EDIT,MENU_EDIT_ADD,i,TRUE)
      ENDIF
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

    IF bufferLayout
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYTO],win,0,[GA_DISABLED,TRUE,TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVETO],win,0,[GA_DISABLED,TRUE,TAG_END])

      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
    ENDIF
  ENDIF
ENDPROC

PROC updateBufferSel(win,node)
  DEF comp=0:PTR TO reactionObject
  DEF dis
  IF bufferLayout
    IF node THEN GetListBrowserNodeAttrsA(node,[LBNA_USERDATA,{comp},TAG_END])
    IF comp AND selectedComp
      dis:=(selectedComp.parent=0) AND (selectedComp.allowChildren()=FALSE) AND (selectedComp.type<>TYPE_SCREEN) AND (selectedComp.type<>TYPE_WINDOW)
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,dis,TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,dis,TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_REMOVE],win,0,[GA_DISABLED,dis,TAG_END])
    ELSE
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVEFROM],win,0,[GA_DISABLED,TRUE,TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_REMOVE],win,0,[GA_DISABLED,TRUE,TAG_END])
    ENDIF
    selectedBuffComp:=comp
  ELSE
    selectedBuffComp:=0
  ENDIF
ENDPROC

PROC createBufferGads()
  bufferLayout:=LayoutObject,
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
  columninfo[0].width:=8
  columninfo[0].title:='Name'
  columninfo[0].flags:=CIF_WEIGHTED

  columninfo[1].width:=3
  columninfo[1].title:='Type'
  columninfo[1].flags:=CIF_WEIGHTED

  columninfo[2].width:=2
  columninfo[2].title:='ID'
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

  StringF(windowTitle,'ReBuild - Reaction UI Builder (\s)',vernum)

  mainWindow:=WindowObject,
    WA_TITLE, windowTitle,
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
      LAYOUT_SPACEOUTER, TRUE,
          
      LAYOUT_ADDCHILD, mainWindowLayout:=LayoutObject,
        LAYOUT_ADDCHILD, gMain_Gadgets[GAD_COMPONENTLIST]:=ListBrowserObject,
          GA_ID, GAD_COMPONENTLIST,
          GA_RELVERIFY, TRUE,
          LISTBROWSER_POSITION, 0,
          LISTBROWSER_SHOWSELECTED, TRUE,
          LISTBROWSER_COLUMNTITLES, TRUE,
          LISTBROWSER_COLUMNINFO, columninfo,
          LISTBROWSER_VERTICALPROP, TRUE,
          LISTBROWSER_HIERARCHICAL, TRUE,
          LISTBROWSER_LABELS, list,
        ListBrowserEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
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
  WindowEnd
  
  toggleBuffer()
  
ENDPROC

PROC addObject(parent:PTR TO reactionObject,newobj:PTR TO reactionObject)
  DEF idx, mainRootLayout
  DEF window
  
  IF parent.allowChildren()
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    parent.addChild(newobj)
    makeList(newobj)
    addMembers(mainRootLayout,window)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC removeObject(parent:PTR TO reactionObject,child:PTR TO reactionObject)
  DEF idx, mainRootLayout
  DEF comp2:PTR TO reactionObject
  DEF window
  
  IF parent.allowChildren()
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(objectList.item(ROOT_LAYOUT_ITEM),window)
    idx:=child.getChildIndex()
    parent.removeChild(child)
    END child
    makeList()
    addMembers(objectList.item(ROOT_LAYOUT_ITEM),window)
    rethinkPreviews()
    IF (idx<parent.children.count())
      comp2:=parent.children.item(idx)
    ELSE
      comp2:=parent
    ENDIF
    SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_SELECTEDNODE, comp2.node, TAG_END])
    updateSel(comp2.node)
  ENDIF
ENDPROC

PROC removeWindow(win:PTR TO reactionObject)
  DEF idx,comp:PTR TO reactionObject
  idx:=findWindowIndex(win)
  idx:=(idx*3)
  removeMembers(objectList.item(idx+ROOT_LAYOUT_ITEM),objectList.item(idx+ROOT_WINDOW_ITEM))
  comp:=objectList.item(idx+ROOT_WINDOW_ITEM) 
  END comp
  comp:=objectList.item(idx+ROOT_LAYOUT_ITEM)
  END comp
  comp:=objectList.item(idx+ROOT_MENU_ITEM)
  END comp
  objectList.remove(idx+ROOT_LAYOUT_ITEM)
  objectList.remove(idx+ROOT_MENU_ITEM)
  objectList.remove(idx+ROOT_WINDOW_ITEM) 
  makeList()
  rethinkPreviews()
ENDPROC

PROC doGenUp(parent:PTR TO reactionObject,child:PTR TO reactionObject)
  DEF idx, mainRootLayout, window

  IF (parent.allowChildren()) AND (parent.parent<>0)
    changes:=TRUE
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    parent.removeChild(child)
    parent.parent.addChild(child)
    child.parent:=parent.parent
    makeList(child)
    addMembers(mainRootLayout,window)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC doGenDown(parent:PTR TO reactionObject, child:PTR TO reactionObject)
  DEF idx, mainRootLayout, window
  DEF newparent: PTR TO reactionObject

  changes:=TRUE
  idx:=findWindowIndex(selectedComp)
  mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
  window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
  removeMembers(mainRootLayout,window)
  idx:=child.getChildIndex()
  newparent:=parent.children.item(idx+1)
  parent.removeChild(child)
  newparent.addChild(child)
  makeList(child)
  addMembers(mainRootLayout,window)
  rethinkPreviews()
ENDPROC

PROC swapWindows(idx1,idx2)
  DEF tempitem

  idx1:=idx1*3
  idx2:=idx2*3
  
  tempitem:=objectList.item(ROOT_WINDOW_ITEM+idx1)
  objectList.setItem(ROOT_WINDOW_ITEM+idx1,objectList.item(ROOT_WINDOW_ITEM+idx2))
  objectList.setItem(ROOT_WINDOW_ITEM+idx2,tempitem)
  
  tempitem:=objectList.item(ROOT_MENU_ITEM+idx1)
  objectList.setItem(ROOT_MENU_ITEM+idx1,objectList.item(ROOT_MENU_ITEM+idx2))
  objectList.setItem(ROOT_MENU_ITEM+idx2,tempitem)

  tempitem:=objectList.item(ROOT_LAYOUT_ITEM+idx1)
  objectList.setItem(ROOT_LAYOUT_ITEM+idx1,objectList.item(ROOT_LAYOUT_ITEM+idx2))
  objectList.setItem(ROOT_LAYOUT_ITEM+idx2,tempitem)
ENDPROC

PROC moveUp(parent:PTR TO reactionObject,child:PTR TO reactionObject)
  DEF idx, mainRootLayout, window

  IF parent=0
    idx:=findWindowIndex(child)

    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    swapWindows(idx,idx-1)
    makeList(child)
    addMembers(mainRootLayout,window)
    RETURN
  ENDIF

  IF parent.allowChildren()
    changes:=TRUE
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    parent.swapChildren(child.getChildIndex(),child.getChildIndex()-1)
    makeList(child)
    addMembers(mainRootLayout,window)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC moveDown(parent:PTR TO reactionObject,child:PTR TO reactionObject)
  DEF idx, mainRootLayout, window

  IF parent=0
    idx:=findWindowIndex(child)

    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    swapWindows(idx,idx+1)
    makeList(child)
    addMembers(mainRootLayout,window)
    RETURN
  ENDIF

  IF parent.allowChildren()
    changes:=TRUE
    idx:=findWindowIndex(selectedComp)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    parent.swapChildren(child.getChildIndex(),child.getChildIndex()+1)
    makeList(child)
    addMembers(mainRootLayout,window)
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
    IF comp.allowChildren()=FALSE
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

PROC findLibsUsed(from:PTR TO reactionObject,libsused:PTR TO CHAR)
  DEF i
  FOR i:=0 TO ListLen(from.libsused)-1 DO libsused[ListItem(from.libsused,i)]:=TRUE

  FOR i:=0 TO from.children.count()-1 DO libsused:=findLibsUsed(from.children.item(i),libsused)
ENDPROC libsused

PROC countGads(from=0:PTR TO reactionObject,n=0)
  DEF i
  IF from=0 THEN from:=objectList.item(ROOT_LAYOUT_ITEM)

  FOR i:=0 TO from.children.count()-1 DO n:=countGads(from.children.item(i),n)
ENDPROC n+1

PROC genComponentCode(comp:PTR TO reactionObject, n, srcGen:PTR TO srcGen)
  DEF i
  DEF tempStr[200]:STRING
  DEF libname,addTag
  IF comp.isImage()
    IF comp.parent THEN addTag:=comp.parent.addImageTag() ELSE addTag:=LAYOUT_ADDIMAGE
    srcGen.componentAddImage(addTag)
  ELSE
    IF comp.parent THEN addTag:=comp.parent.addChildTag() ELSE addTag:=LAYOUT_ADDCHILD
    srcGen.componentAddChild(addTag)
  ENDIF

  srcGen.assignGadgetVar(n)
  IF (libname:=comp.libNameCreate())
    srcGen.componentLibnameCreate(libname)
  ELSE
    StringF(tempStr,'\sObject,',comp.getTypeName())
    srcGen.componentCreate(tempStr)
  ENDIF
  comp.genCodeProperties(srcGen)
  IF comp.children.count()>0
    comp.genChildObjectsHeader(srcGen)
    FOR i:=0 TO comp.children.count()-1
      n++
      genComponentCode(comp.children.item(i),n,srcGen)
    ENDFOR
    comp.genChildObjectsFooter(srcGen)
  ENDIF
  StrCopy(tempStr,comp.getTypeEndName())
  IF EstrLen(tempStr)=0
    StringF(tempStr,'\sEnd',comp.getTypeName())
  ENDIF
  StrAddChar(tempStr,",")
  srcGen.componentEnd(tempStr)
  comp.genCodeChildProperties(srcGen)
ENDPROC

PROC showLibs()
  DEF libsForm:PTR TO libraryList
  
  NEW libsForm.create()
  libsForm.showLibraries()
  END libsForm
ENDPROC

PROC genCode()
  DEF fs:PTR TO fileStreamer
  DEF tags
  DEF fr:PTR TO filerequester
  DEF fname[255]:STRING
  DEF eSrcGen: PTR TO eSrcGen
  DEF cSrcGen: PTR TO cSrcGen
  DEF srcGen:PTR TO srcGen
  DEF count
  DEF objectCreate[50]:STRING
  DEF objectEnd[50]:STRING
  DEF codeGenForm:PTR TO codeGenForm
  DEF langid,i
  DEF menuComp:PTR TO reactionObject
  DEF windowComp:PTR TO reactionObject
  DEF layoutComp:PTR TO reactionObject
  DEF screenComp:PTR TO screenObject
  DEF libsused[TYPE_MAX]:ARRAY OF CHAR
  
  setBusy()
  NEW codeGenForm.create()
  langid:=codeGenForm.selectLang()
  END codeGenForm
  clearBusy()
  IF langid=-1 THEN RETURN
  
  aslbase:=OpenLibrary('asl.library',37)
  IF aslbase=NIL THEN Throw("LIB","ASL")
  tags:=NEW [ASL_HAIL,'Select a file to save',
     ASL_WINDOW, win,
     TAG_DONE]
  fr:=AllocAslRequest(ASL_FILEREQUEST,tags)
  setBusy()
  IF(AslRequest(fr,0))=FALSE
    IF tags THEN FastDisposeList(tags)
    IF aslbase THEN CloseLibrary(aslbase)
    clearBusy()
    RETURN
  ENDIF
  clearBusy()

  StrCopy(fname,fr.drawer)
  AddPart(fname,fr.file,100)
  SetStr(fname)
  IF fr THEN FreeAslRequest(fr)
  IF tags THEN FastDisposeList(tags)
  IF aslbase THEN CloseLibrary(aslbase)
  
  FOR i:=0 TO TYPE_MAX-1 DO libsused[i]:=0

  i:=ROOT_LAYOUT_ITEM
  WHILE i<objectList.count()
    findLibsUsed(objectList.item(i),libsused)
    i+=3
  ENDWHILE
  
  IF FileLength(fname)>=0
    IF warnRequest(mainWindow,'Warning','This file already exists,\ndo you want to overwrite?',TRUE)=0 THEN RETURN
  ENDIF

  setBusy()
  NEW fs.create(fname,MODE_NEWFILE)
  
  SELECT langid
    CASE LANG_E
      NEW eSrcGen.create(fs,libsused)
      srcGen:=eSrcGen
    CASE LANG_C
      NEW cSrcGen.create(fs,libsused)
      srcGen:=cSrcGen
  ENDSELECT

  i:=0
  windowComp:=objectList.item(ROOT_WINDOW_ITEM)
  screenComp:=objectList.item(ROOT_SCREEN_ITEM)
  srcGen.genHeader(screenComp)
  WHILE (i+ROOT_WINDOW_ITEM)<objectList.count()
    windowComp:=objectList.item(i+ROOT_WINDOW_ITEM)
    menuComp:=objectList.item(i+ROOT_MENU_ITEM)
    layoutComp:=objectList.item(i+ROOT_LAYOUT_ITEM)
    count:=countGads(layoutComp)
  
    srcGen.genWindowHeader(count,windowComp,menuComp,layoutComp, getReactionLists())
    srcGen.assignWindowVar()
    StringF(objectCreate,'\sObject,',windowComp.getTypeName())
    StringF(objectEnd,'\sEnd',windowComp.getTypeName())
    srcGen.componentCreate(objectCreate)
    windowComp.genCodeProperties(srcGen)
    
    IF screenComp.custom
      srcGen.componentProperty('WA_CustomScreen','gScreen',FALSE)
    ENDIF
    srcGen.componentProperty('WINDOW_ParentGroup','VLayoutObject',FALSE)
    srcGen.componentProperty('LAYOUT_SpaceOuter','TRUE',FALSE)
    srcGen.componentProperty('LAYOUT_DeferLayout','TRUE',FALSE)
    srcGen.increaseIndent()
    genComponentCode(layoutComp,0,srcGen)
    srcGen.componentEnd('LayoutEnd,') 
    srcGen.finalComponentEnd(objectEnd) 
    srcGen.decreaseIndent()
    srcGen.genWindowFooter(count,windowComp,menuComp,layoutComp, getReactionLists())
    i+=3
  ENDWHILE
  windowComp:=objectList.item(ROOT_WINDOW_ITEM)
  srcGen.genFooter(windowComp)
  END srcGen
  
  END fs
  clearBusy()
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
  DEF a=0:PTR TO menuitem

  DEF ver,newid,v

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
    errorRequest(mainWindow,'Error','This file is not a valid rebuild file.')
    END fs
    RETURN
  ENDIF

  fs.readLine(tempStr)
  WHILE (StrCmp(tempStr,'#')=FALSE)
    IF StrCmp(tempStr,'VER=',STRLEN)
      ver:=Val(tempStr+STRLEN)
      IF (ver<1)
        errorRequest(mainWindow,'Error','This file is not a valid rebuild file.')
        END fs
        RETURN
      ENDIF
      IF (ver>FILE_FORMAT_VER)
        errorRequest(mainWindow,'Error','This file is too new for this version of ReBuild.')
        END fs
        RETURN
      ENDIF
    ELSEIF StrCmp(tempStr,'NEXTID=',STRLEN)
      newid:=Val(tempStr+STRLEN)
      IF newid<1
        errorRequest(mainWindow,'Error','This file is not a valid rebuild file.')
        END fs
        RETURN
      ENDIF
    ELSEIF StrCmp(tempStr,'VIEWTMP=',STRLEN)
      v:=Val(tempStr+STRLEN)
      IF Eor((v=TRUE),(bufferLayout<>0))
        toggleBuffer()
      ENDIF
    ELSEIF StrCmp(tempStr,'ADDSETT=',STRLEN)
      v:=Val(tempStr+STRLEN)
      IF win
        a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_SHOW_ADD_SETTINGS,0))
        IF a
          IF v
            a.flags:=a.flags OR CHECKED
          ELSE
            a.flags:=a.flags AND Not(CHECKED)
          ENDIF
        ENDIF
      ENDIF
    ENDIF
    
    IF fs.readLine(tempStr)=FALSE
      errorRequest(mainWindow,'Error','This file is not a valid rebuild file.')
      END fs
      RETURN
    ENDIF
  ENDWHILE
  
  i:=ROOT_WINDOW_ITEM
  WHILE i<objectList.count()
    removeMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i))
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
    addMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i))
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
  DEF i,j,a=0:PTR TO menuitem
  DEF comp:PTR TO reactionObject
  DEF tempStr[10]:STRING
  DEF reactionLists:PTR TO stdlist

  IF EstrLen(filename)=0 
    RETURN saveFileAs()
  ENDIF

  setBusy()

  NEW fs.create(filename,MODE_NEWFILE)
  fs.writeLine('-REBUILD-')
  StringF(tempStr,'VER=\d',FILE_FORMAT_VER)
  fs.writeLine(tempStr)
  StringF(tempStr,'NEXTID=\d',getObjId())
  fs.writeLine(tempStr)
  StringF(tempStr,'VIEWTMP=\d',IF bufferLayout THEN TRUE ELSE FALSE)
  fs.writeLine(tempStr)
  IF win
    a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_SHOW_ADD_SETTINGS,0))
    IF a
      StringF(tempStr,'ADDSETT=\d',IF a.flags AND CHECKED THEN TRUE ELSE FALSE)
      fs.writeLine(tempStr)
    ENDIF
  ENDIF

  fs.writeLine('#')

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
  clearBusy()
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

  setBusy()
  fr:=AllocAslRequest(ASL_FILEREQUEST,tags)
  IF(AslRequest(fr,0))=FALSE
    IF tags THEN FastDisposeList(tags)
    IF aslbase THEN CloseLibrary(aslbase)
    clearBusy()
    RETURN FALSE
  ENDIF
  clearBusy()

  StrCopy(fname,fr.drawer)
  AddPart(fname,fr.file,100)
  SetStr(fname)
  StrCopy(filename,fname)
  IF fr THEN FreeAslRequest(fr)
  IF tags THEN FastDisposeList(tags)
  IF aslbase THEN CloseLibrary(aslbase)

  IF FileLength(filename)>=0
    IF warnRequest(mainWindow,'Warning','This file already exists,\ndo you want to overwrite?',TRUE)=0 THEN RETURN FALSE
  ENDIF
ENDPROC saveFile()

PROC unsavedChangesWarning()
  DEF reqmsg:PTR TO orrequest
  DEF reqobj
  DEF res=0
  
  setBusy()
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
  clearBusy()
ENDPROC res

PROC showAbout()
  DEF reqmsg:PTR TO orrequest
  DEF aboutStr[100]:STRING
  DEF reqobj
  
  setBusy()

  StrCopy(aboutStr,'ReBuilder\n\nThe Reaction UI Builder Tool\nWritten By Darren Coles\n')
  StrAdd(aboutStr,vernum)
  
  NEW reqmsg
  reqmsg.methodid:=RM_OPENREQ
  reqmsg.window:=win
  reqmsg.attrs:=[REQ_TITLETEXT,'About',REQ_BODYTEXT,aboutStr,REQ_GADGETTEXT,'_Ok',TAG_END]
  reqobj:=NewObjectA(Requester_GetClass(),0,[TAG_END])
  IF reqobj
    DoMethodA(reqobj, reqmsg)
    DisposeObject(reqobj)
  ENDIF
  END reqmsg
  clearBusy()
ENDPROC

PROC doLoad()
  DEF res
  IF changes
    res:=unsavedChangesWarning()
    IF res=0 THEN RETURN
    IF res=1 THEN IF saveFile()=FALSE THEN RETURN
  ENDIF
  setBusy()
  closePreviews()
  loadFile()
  restorePreviews()
  clearBusy()
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
  DEF a:PTR TO menuitem

  newwin:=createWindowObject(0)
  IF newwin
    setBusy()
    IF win
      a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_SHOW_ADD_SETTINGS,0))
    ENDIF
    IF (a<>0) ANDALSO (a.flags AND CHECKED)
      IF newwin.editSettings()=FALSE
        objectInitialise(newwin.id)
        END newwin
      ENDIF
    ENDIF
    IF newwin
      objectList.add(newwin)  ->extra window
      objectList.add(createMenuObject(0)) ->extra menu
      objectList.add(createLayoutObject(0)) ->extra layout
      makeList()
      SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_SELECTEDNODE, newwin.node, TAG_END])
      updateSel(newwin.node)
      RA_OpenWindow(newwin.previewObject)
      remakePreviewMenus()
      changes:=TRUE
    ENDIF
    clearBusy()
  ENDIF
    
ENDPROC

PROC doAddComp(comp:PTR TO reactionObject, objType, compType=-1)
  DEF newObj:PTR TO reactionObject
  DEF a=0:PTR TO menuitem
  newObj:=0
  WHILE (comp<>0) AND (comp.allowChildren()=FALSE) DO comp:=comp.parent
  IF comp
    IF compType>-1
      newObj:=createObjectByType(compType,comp)
    ELSE
      newObj:=createObjectByObj(objType,comp)
    ENDIF
    IF newObj 
      setBusy()
      IF win
        a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_SHOW_ADD_SETTINGS,0))
      ENDIF
      IF (a<>0) ANDALSO (a.flags AND CHECKED)
        IF newObj.editSettings()=FALSE
          objectInitialise(newObj.id)
          END newObj
          newObj:=NIL
        ENDIF
      ENDIF
      IF newObj
        changes:=TRUE
        addObject(comp,newObj)
      ENDIF
      clearBusy()
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
  setBusy()
  IF (objType:=frmObjectPicker.selectItem())<>-1
    doAddComp(comp,objType)
  ENDIF
  END frmObjectPicker
  clearBusy()
ENDPROC

PROC doEdit()
  DEF idx, mainRootLayout
  DEF winObj:PTR TO windowObject
  DEF pwin
  IF selectedComp
    setBusy()
    IF selectedComp.editSettings()
      changes:=TRUE
      idx:=findWindowIndex(selectedComp)
      IF idx<>-1
        mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
        winObj:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
        removeMembers(mainRootLayout,winObj)
        IF selectedComp.type=TYPE_WINDOW
          RA_CloseWindow(selectedComp.previewObject)
          selectedComp.createPreviewObject(win.wscreen)
          RA_OpenWindow(selectedComp.previewObject)
        ENDIF
        makeList(selectedComp)
        addMembers(mainRootLayout,winObj)

        IF selectedComp.type=TYPE_MENU
          pwin:=Gets(winObj.previewObject,WINDOW_WINDOW)
          IF pwin THEN ClearMenuStrip(pwin)
          selectedComp.createPreviewObject(win.wscreen)
        ENDIF
        rethinkPreviews()
      ENDIF
    ENDIF
    clearBusy()

  ENDIF
ENDPROC

PROC doDelete()
  DEF a=0:PTR TO menuitem
  DEF skipWarn=FALSE

  IF selectedComp.type=TYPE_WINDOW
    IF warnRequest(mainWindow,'Warning','Are you sure you wish\nto delete this whole window?',TRUE)=1
      changes:=TRUE
      removeWindow(selectedComp)
    ENDIF
  ELSE
    IF win
      a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_WARN_ON_DEL,0))
    ENDIF
    IF a THEN skipWarn:=(a.flags AND CHECKED)
    
    IF (skipWarn=0) ORELSE (warnRequest(mainWindow,'Warning','Are you sure you wish\nto delete this item?',TRUE)=1)
      changes:=TRUE
      removeObject(selectedComp.parent,selectedComp)
    ENDIF
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
  DEF oldid,defname
  DEF name[100]:STRING

  NEW fs.create('t:tempcomp',MODE_NEWFILE)
  bufferComp.serialise(fs)
  END fs
  
  newObj:=createObjectByType(bufferComp.type,0)
  oldid:=newObj.id
  NEW fs.create('t:tempcomp',MODE_OLDFILE)
  newObj.deserialise(fs)
  StringF(name,'\s_\d',newObj.getTypeName(),newObj.id)
  defname:=StrCmp(newObj.name,name)
 
  newObj.id:=oldid

  IF defname
    StringF(name,'\s_\d',newObj.getTypeName(),oldid)
    AstrCopy(newObj.name,name)
  ENDIF
  
  END fs

  comp:=selectedComp
  WHILE (comp<>0) AND (comp.allowChildren()=FALSE) DO comp:=comp.parent
  IF comp 
    addObject(comp,newObj)
    SetGadgetAttrsA(gMain_Gadgets[GAD_COMPONENTLIST],win,0,[LISTBROWSER_SELECTEDNODE, newObj.node, TAG_END])
    updateSel(newObj.node)
  ELSE 
    END newObj
  ENDIF
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
  DEF i,oldpos
  FOR i:=bufferList.count()-1 TO 0 STEP -1
    IF bufferList.item(i)=bufferComp 
      bufferList.remove(i)
      oldpos:=i
    ENDIF
  ENDFOR
  makeBufferList()
  IF oldpos<bufferList.count()
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMPLIST],win,0,[LISTBROWSER_SELECTED, oldpos, TAG_END])
    updateBufferSel(win,Gets(gMain_Gadgets[GAD_TEMPLIST],LISTBROWSER_SELECTEDNODE))
  ELSEIF (oldpos-1)<bufferList.count()
    SetGadgetAttrsA(gMain_Gadgets[GAD_TEMPLIST],win,0,[LISTBROWSER_SELECTED, oldpos-1, TAG_END])
    updateBufferSel(win,Gets(gMain_Gadgets[GAD_TEMPLIST],LISTBROWSER_SELECTEDNODE))
  ENDIF
ENDPROC

PROC makeBufferList()
  DEF comp:PTR TO reactionObject
  DEF compStr[100]:STRING
  DEF i,n
  
  IF bufferLayout
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
  ENDIF
ENDPROC

PROC disposeObjects()
  DEF comp:PTR TO reactionObject
  DEF reactionLists:PTR TO stdlist
  DEF i
  
  reactionLists:=getReactionLists()
  IF reactionLists
    FOR i:=0 TO reactionLists.count()-1
      comp:=reactionLists.item(i)
      IF comp THEN END comp
    ENDFOR
    reactionLists.clear()
  ENDIF

  IF objectList
    FOR i:=0 TO objectList.count()-1
      comp:=objectList.item(i)
      IF comp THEN END comp
    ENDFOR
    objectList.clear()
  ENDIF
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
    removeMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i))
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
    addMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i))
    i+=3
  ENDWHILE
  rethinkPreviews()
  remakePreviewMenus()
  changes:=FALSE
ENDPROC

PROC toggleBuffer()
  DEF a=0:PTR TO menuitem

  IF win
    a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_BUFFER,0))
  ENDIF

  IF bufferLayout
    SetGadgetAttrsA(mainWindowLayout,win,0,[LAYOUT_REMOVECHILD, bufferLayout,TAG_END])
    bufferLayout:=0
    IF a THEN a.flags:=a.flags AND Not(CHECKED)
  ELSE
    createBufferGads()
    SetGadgetAttrsA(mainWindowLayout,win,0,[LAYOUT_ADDCHILD, bufferLayout,CHILD_WEIGHTEDWIDTH,20,TAG_END])
    IF a THEN a.flags:=a.flags OR CHECKED
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
    winObj.previewLeft:=Gets(previewWin,WA_LEFT)
    winObj.previewTop:=Gets(previewWin,WA_TOP)
    RA_CloseWindow(previewWin)
  ELSE
    winObj.previewOpen:=TRUE
    Sets(previewWin,WA_LEFT,winObj.previewLeft)
    Sets(previewWin,WA_TOP,winObj.previewTop)
    RA_OpenWindow(previewWin)
  ENDIF
ENDPROC

PROC handlePreviewInputs()
  DEF pwin:PTR TO window,previewWin,i,code
  DEF winObj:PTR TO windowObject
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
          winObj.previewLeft:=Gets(previewWin,WA_LEFT)
          winObj.previewTop:=Gets(previewWin,WA_TOP)
        CASE WMHI_CLOSEWINDOW
          winObj.previewOpen:=FALSE
          RA_CloseWindow(previewWin)
          remakePreviewMenus()
      ENDSELECT
    ENDWHILE
    i+=3
  ENDWHILE
ENDPROC

PROC setBusy()
  Sets(mainWindow,WA_BUSYPOINTER,TRUE)
ENDPROC

PROC clearBusy()
  Sets(mainWindow,WA_BUSYPOINTER,FALSE)
ENDPROC

PROC remakePreviewMenus()
  DEF menuData:PTR TO newmenu,scr,visInfo
  DEF winObj:PTR TO windowObject
  DEF count,n,i
  DEF addSett=TRUE
  DEF a:PTR TO menuitem

  count:=(objectList.count()-ROOT_WINDOW_ITEM)/4
  count:=count+73

  IF win
    a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_SHOW_ADD_SETTINGS,0))
    IF (a)
      IF (a.flags AND CHECKED)=0 THEN addSett:=FALSE
    ENDIF
  ENDIF

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
  menuData[8].label:='Show Libraries'
  menuData[9].type:=NM_ITEM
  menuData[9].label:=NM_BARLABEL
  menuData[10].type:=NM_ITEM
  menuData[10].label:='About'
  menuData[11].type:=NM_ITEM
  menuData[11].label:=NM_BARLABEL
  menuData[12].type:=NM_ITEM
  menuData[12].label:='Quit'
  menuData[13].type:=NM_TITLE
  menuData[13].label:='Edit'
  menuData[14].type:=NM_ITEM
  menuData[14].label:='Add'
  menuData[14].userdata:=-1

  menuData[15].type:=NM_SUB
  menuData[15].label:='Button'
  menuData[15].userdata:=TYPE_BUTTON
  menuData[16].type:=NM_SUB
  menuData[16].label:='Bitmap'
  menuData[16].userdata:=TYPE_BITMAP
  menuData[17].type:=NM_SUB
  menuData[17].label:='CheckBox'
  menuData[17].userdata:=TYPE_CHECKBOX
  menuData[18].type:=NM_SUB
  menuData[18].label:='Chooser'
  menuData[18].userdata:=TYPE_CHOOSER
  menuData[19].type:=NM_SUB
  menuData[19].label:='ClickTab'
  menuData[19].userdata:=TYPE_CLICKTAB
  menuData[20].type:=NM_SUB
  menuData[20].label:='FuelGauge'
  menuData[20].userdata:=TYPE_FUELGAUGE
  menuData[21].type:=NM_SUB
  menuData[21].label:='GetFile'
  menuData[21].userdata:=TYPE_GETFILE
  menuData[22].type:=NM_SUB
  menuData[22].label:='GetFont'
  menuData[22].userdata:=TYPE_GETFONT
  menuData[23].type:=NM_SUB
  menuData[23].label:='GetScreenMode'
  menuData[23].userdata:=TYPE_GETSCREENMODE
  menuData[24].type:=NM_SUB
  menuData[24].label:='Integer'
  menuData[24].userdata:=TYPE_INTEGER
  menuData[25].type:=NM_SUB
  menuData[25].label:='Palette'
  menuData[25].userdata:=TYPE_PALETTE
  menuData[26].type:=NM_SUB
  menuData[26].label:='PenMap'
  menuData[26].userdata:=TYPE_PENMAP
  menuData[27].type:=NM_SUB
  menuData[27].label:='Layout'
  menuData[27].userdata:=TYPE_LAYOUT
  menuData[28].type:=NM_SUB
  menuData[28].label:='ListBrowser'
  menuData[28].userdata:=TYPE_LISTBROWSER
  menuData[29].type:=NM_SUB
  menuData[29].label:='RadioButton'
  menuData[29].userdata:=TYPE_RADIO
  menuData[30].type:=NM_SUB
  menuData[30].label:='Scroller'
  menuData[30].userdata:=TYPE_SCROLLER
  menuData[31].type:=NM_SUB
  menuData[31].label:='SpeedBar'
  menuData[31].userdata:=TYPE_SPEEDBAR
  menuData[32].type:=NM_SUB
  menuData[32].label:='Slider'
  menuData[32].userdata:=TYPE_SLIDER
  menuData[33].type:=NM_SUB
  menuData[33].label:='StatusBar'
  menuData[33].userdata:=TYPE_STATUSBAR
  menuData[34].type:=NM_SUB
  menuData[34].label:='String'
  menuData[34].userdata:=TYPE_STRING
  menuData[35].type:=NM_SUB
  menuData[35].label:='Space'
  menuData[35].userdata:=TYPE_SPACE
  menuData[36].type:=NM_SUB
  menuData[36].label:='TextField'
  menuData[36].userdata:=TYPE_TEXTFIELD
  menuData[37].type:=NM_SUB
  menuData[37].label:='Bevel'
  menuData[37].userdata:=TYPE_BEVEL
  menuData[38].type:=NM_SUB
  menuData[38].label:='DrawList'
  menuData[38].userdata:=TYPE_DRAWLIST
  menuData[39].type:=NM_SUB
  menuData[39].label:='Glyph'
  menuData[39].userdata:=TYPE_GLYPH
  menuData[40].type:=NM_SUB
  menuData[40].label:='Label'
  menuData[40].userdata:=TYPE_LABEL
  menuData[41].type:=NM_SUB
  menuData[41].label:=NM_BARLABEL
  menuData[41].userdata:=-1
  menuData[42].type:=NM_SUB
  menuData[42].label:='Window'
  menuData[42].userdata:=TYPE_WINDOW

  menuData[43].type:=NM_ITEM
  menuData[43].label:='Add More'
  menuData[43].userdata:=-1

  menuData[44].type:=NM_SUB
  menuData[44].label:='ColorWheel'
  menuData[44].userdata:=TYPE_COLORWHEEL

  menuData[45].type:=NM_SUB
  menuData[45].label:='DateBrowser'
  menuData[45].userdata:=TYPE_DATEBROWSER

  menuData[46].type:=NM_SUB
  menuData[46].label:='GetColor'
  menuData[46].userdata:=TYPE_GETCOLOR

  menuData[47].type:=NM_SUB
  menuData[47].label:='GradientSlider'
  menuData[47].userdata:=TYPE_GRADSLIDER

  menuData[48].type:=NM_SUB
  menuData[48].label:='ListView'
  menuData[48].userdata:=TYPE_LISTVIEW
  
  menuData[49].type:=NM_SUB
  menuData[49].label:='Progress'
  menuData[49].userdata:=TYPE_PROGRESS

  menuData[50].type:=NM_SUB
  menuData[50].label:='SketchBoard'
  menuData[50].userdata:=TYPE_SKETCH

  menuData[51].type:=NM_SUB
  menuData[51].label:='TapeDeck'
  menuData[51].userdata:=TYPE_TAPEDECK

  menuData[52].type:=NM_SUB
  menuData[52].label:='TextEditor'
  menuData[52].userdata:=TYPE_TEXTEDITOR

  menuData[53].type:=NM_SUB
  menuData[53].label:='TextEntry'
  menuData[53].userdata:=TYPE_TEXTENTRY

  menuData[54].type:=NM_SUB
  menuData[54].label:='Virtual'
  menuData[54].userdata:=TYPE_VIRTUAL

  menuData[55].type:=NM_SUB
  menuData[55].label:='BoingBall'
  menuData[55].userdata:=TYPE_BOINGBALL

  menuData[56].type:=NM_SUB
  menuData[56].label:='LED'
  menuData[56].userdata:=TYPE_LED

  menuData[57].type:=NM_SUB
  menuData[57].label:='SmartBitmap'
  menuData[57].userdata:=TYPE_SMARTBITMAP

  menuData[58].type:=NM_SUB
  menuData[58].label:='TitleBar'
  menuData[58].userdata:=TYPE_TITLEBAR

  menuData[59].type:=NM_ITEM
  menuData[59].label:='Edit'
  menuData[60].type:=NM_ITEM
  menuData[60].label:='Delete'
  menuData[61].type:=NM_ITEM
  menuData[61].label:=NM_BARLABEL
  menuData[62].type:=NM_ITEM
  menuData[62].label:='Move Up'
  menuData[63].type:=NM_ITEM
  menuData[63].label:='Move Down'
  menuData[64].type:=NM_ITEM
  menuData[64].label:=NM_BARLABEL
  menuData[65].type:=NM_ITEM
  menuData[65].label:='Edit Lists'
  menuData[66].type:=NM_ITEM
  menuData[66].label:=NM_BARLABEL
  menuData[67].type:=NM_ITEM
  menuData[67].label:='Show Buffer'
  menuData[67].flags:=CHECKIT OR (IF bufferLayout THEN CHECKED ELSE 0 ) OR MENUTOGGLE
  menuData[68].type:=NM_ITEM
  menuData[68].label:='Show Settings On Add'
  menuData[68].flags:=CHECKIT OR (IF addSett THEN CHECKED ELSE 0 ) OR MENUTOGGLE
  menuData[69].type:=NM_ITEM
  menuData[69].label:='Warn On Delete'
  menuData[69].flags:=CHECKIT OR (IF addSett THEN CHECKED ELSE 0 ) OR MENUTOGGLE
  menuData[70].type:=NM_ITEM
  menuData[70].label:=NM_BARLABEL
  menuData[71].type:=NM_ITEM
  menuData[71].label:='Preview Windows'
  n:=72
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
    updateSel(Gets(gMain_Gadgets[GAD_COMPONENTLIST],LISTBROWSER_SELECTEDNODE))
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
  IF objectList=NIL THEN RETURN
  i:=ROOT_WINDOW_ITEM
  WHILE (i<objectList.count())
    previewWin:=objectList.item(i)::windowObject.previewObject
    IF previewWin THEN RA_CloseWindow(previewWin)
    i+=3
  ENDWHILE
  IF win THEN remakePreviewMenus()
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
      Sets(previewWin,WA_LEFT,winObj.previewLeft)
      Sets(previewWin,WA_TOP,winObj.previewTop)
      RA_OpenWindow(previewWin)
    ENDIF
    i+=3
  ENDWHILE
  remakePreviewMenus()
ENDPROC

PROC editLists()
  DEF listManagerForm:PTR TO listManagerForm
  DEF i
  DEF idx,mainRootLayout, window
  
  setBusy()
  NEW listManagerForm.create()
  listManagerForm.manageLists()
  changes:=TRUE
  END listManagerForm
  clearBusy()
  
  idx:=ROOT_WINDOW_ITEM
  WHILE idx<objectList.count()
    mainRootLayout:=objectList.item(idx-ROOT_WINDOW_ITEM+ROOT_LAYOUT_ITEM)
    window:=objectList.item(idx)
    removeMembers(mainRootLayout,window)
    makeList(selectedComp)
    addMembers(mainRootLayout,window)
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
    CASE OBJECT_BOINGBALL
      newObj:=createBoingBallObject(comp)
    CASE OBJECT_PENMAP
      newObj:=createPenMapObject(comp)
    CASE OBJECT_BITMAP
      newObj:=createBitmapObject(comp)
    CASE OBJECT_SLIDER
      newObj:=createSliderObject(comp)
    CASE OBJECT_SPEEDBAR
      newObj:=createSpeedBarObject(comp)
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
    CASE TYPE_BOINGBALL
      newObj:=createBoingBallObject(comp)
    CASE TYPE_PENMAP
      newObj:=createPenMapObject(comp)
    CASE TYPE_BITMAP
      newObj:=createBitmapObject(comp)
    CASE TYPE_SLIDER
      newObj:=createPenMapObject(comp)
    CASE TYPE_SPEEDBAR
      newObj:=createSpeedBarObject(comp)
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
  DEF item,type

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
                    CASE MENU_PROJECT_SHOWLIBS
                      showLibs()
                    CASE MENU_PROJECT_ABOUT
                      showAbout()
                    CASE MENU_PROJECT_QUIT
                      IF doClose() THEN running:=FALSE
                  ENDSELECT
                CASE MENU_EDIT
                  SELECT menuitem
                    CASE MENU_EDIT_ADD  ->Add
                      item:=ItemAddress(win.menustrip,result)
                      type:=GTMENUITEM_USERDATA(item)
                      IF type<>-1
                        IF type=TYPE_WINDOW
                          doAddWindow()
                        ELSE
                          doAddComp(selectedComp,-1,type)
                        ENDIF
                      ENDIF
                    CASE MENU_EDIT_ADD_MORE  ->Add more
                      item:=ItemAddress(win.menustrip,result)
                      type:=GTMENUITEM_USERDATA(item)
                      IF type<>-1 THEN doAddComp(selectedComp,-1,type)
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
                  IF tmp=LBRE_DOUBLECLICK
                    doEdit()
                  ELSE
                    updateSel(Gets(gMain_Gadgets[GAD_COMPONENTLIST],LISTBROWSER_SELECTEDNODE))
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
  SELECT exception
    CASE "NIL"
      WriteF('nil pointer error\n')
    CASE "WIN"
      errorRequest(0,'Error','Error window could not be opened')
    CASE "MEM"
      errorRequest(0,'Error','Not enough free memory')
    CASE "LIB"
      SELECT exceptioninfo
        CASE "reqr"
          EasyRequestArgs(NIL,[20,0,'Error','Unable to open requester.class','Ok'],NIL,NIL) 
        CASE "gadt"
          errorRequest(0,'Error','Unable to open gadtools.library')
        CASE "win"
          errorRequest(0,'Error','Unable to open window.class')
        CASE "list"
          errorRequest(0,'Error','Unable to open listbrowser.gadget')
        CASE "rbtn"
          errorRequest(0,'Error','Unable to open radiobutton.gadget')
        CASE "clkt"
          errorRequest(0,'Error','Unable to open clicktab.gadget')
        CASE "btn"
          errorRequest(0,'Error','Unable to open button.gadget')
        CASE "layo"
          errorRequest(0,'Error','Unable to open layout.gadget')
        CASE "strn"
          errorRequest(0,'Error','Unable to open string.gadget')
        CASE "choo"
          errorRequest(0,'Error','Unable to open chooser.gadget')
        CASE "pall"
          errorRequest(0,'Error','Unable to open palette.gadget')
        CASE "spce"
          errorRequest(0,'Error','Unable to open space.gadget')
        CASE "intr"
          errorRequest(0,'Error','Unable to open integer.gadget')
        CASE "scrl"
          errorRequest(0,'Error','Unable to open scroller.gadget')
        CASE "chkb"
          errorRequest(0,'Error','Unable to open checkbox.gadget')
        CASE "fuel"
          errorRequest(0,'Error','Unable to open fuelgauge.gadget')
        CASE "text"
          errorRequest(0,'Error','Unable to open textfield.gadget')
        CASE "file"
          errorRequest(0,'Error','Unable to open getfile.gadget')
        CASE "font"
          errorRequest(0,'Error','Unable to open getfont.gadget')
        CASE "scrn"
          errorRequest(0,'Error','Unable to open getscreenmode.gadget')
        CASE "sldr"
          errorRequest(0,'Error','Unable to open slider.gadget')
        CASE "sbar"
          errorRequest(0,'Error','Unable to open speedbar.gadget')
        CASE "glyp"
          errorRequest(0,'Error','Unable to open glyph.image')
        CASE "labl"
          errorRequest(0,'Error','Unable to open label.image')
        CASE "bevl"
          errorRequest(0,'Error','Unable to open bevel.image')
        CASE "draw"
          errorRequest(0,'Error','Unable to open drawlist.image')
        CASE "penm"
          errorRequest(0,'Error','Unable to open penmap.image')
        CASE "bitm"
          errorRequest(0,'Error','Unable to open bitmap.image')
        CASE "ASL"
          errorRequest(0,'Error','Unable to open asl.library')
      ENDSELECT
  ENDSELECT
  WriteF('shutdown\n')
  IF mainWindow THEN RA_CloseWindow(mainWindow)
  win:=0
  WriteF('window closed\n')
  closePreviews()
  WriteF('previews closed\n')
  IF objectList
    i:=ROOT_WINDOW_ITEM
    WHILE i<objectList.count()
      removeMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i))
      i+=3
    ENDWHILE
  ENDIF
  WriteF('members removed\n')
  IF menus THEN FreeMenus(menus)
  WriteF('menus freed\n')
  disposeObjects()
  WriteF('objects disposed\n')
  IF objectList THEN END objectList
  WriteF('objects freed\n')
  IF bufferList 
    disposeBufferObjects()
    WriteF('buffer objects disposed\n')
    END bufferList
  ENDIF
  WriteF('buffer freed\n')
  freeReactionLists()
  WriteF('reactionlists freed\n')
  IF list THEN freeBrowserNodes( list )
  WriteF('browsernodes disposed\n')
  IF list2 THEN freeBrowserNodes( list2 )
  WriteF('browsernodes2 disposed\n')
  IF mainWindow THEN DisposeObject(mainWindow)
  WriteF('mainwindow disposed\n')
  IF (appPort) THEN DeleteMsgPort(appPort)
  WriteF('appport deleted\n')
  closeClasses()
  WriteF('classes closed\n')
ENDPROC

CHAR verstring