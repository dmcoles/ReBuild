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
         '*penMapObject','*sliderObject','*bitmapObject','*speedBarObject','*colorWheelObject','*dateBrowserObject',
         '*getColorObject','*gradSliderObject','*tapeDeckObject','*textEditorObject','*ledObject','*listViewObject',
         '*virtualObject','*sketchboardObject','*tabsObject'

#define vernum '0.5.0-beta'
#date verstring '$VER:Rebuild 0.5.0-%Y%m%d%h%n%s-alpha'

#ifndef EVO_3_7_0
  FATAL 'Rebuild should only be compiled with E-VO Amiga E Compiler v3.7.0 or higher'
#endif

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

  CONST MENU_ADD_GADGET_COUNT=29
  CONST MENU_ADD_IMAGE_COUNT=8
  
  ENUM LANG_E, LANG_C

  CONST MENU_PROJECT_NEW=0
  CONST MENU_PROJECT_LOAD=1
  CONST MENU_PROJECT_SAVE=2
  CONST MENU_PROJECT_SAVEAS=3
  CONST MENU_PROJECT_GENCODE=5
  CONST MENU_PROJECT_SHOWLIBS=7
  CONST MENU_PROJECT_ABOUT=9
  CONST MENU_PROJECT_QUIT=11

  CONST MENU_EDIT_ADD_GADGET=0
  CONST MENU_EDIT_ADD_IMAGE=1
  CONST MENU_EDIT_ADD_WINDOW=2
  CONST MENU_EDIT_ADD_HLAYOUT=3
  CONST MENU_EDIT_ADD_VLAYOUT=4
  CONST MENU_EDIT_EDIT=6
  CONST MENU_EDIT_DELETE=7
  CONST MENU_EDIT_MOVE=9
  CONST MENU_EDIT_LISTS=11
  CONST MENU_EDIT_BUFFER=13
  CONST MENU_EDIT_SHOW_ADD_SETTINGS=14
  CONST MENU_EDIT_WARN_ON_DEL=15
  CONST MENU_EDIT_PREVIEW=17
  
  CONST MENU_EDIT_MOVEUP=0
  CONST MENU_EDIT_MOVEDOWN=1
  CONST MENU_EDIT_MOVETOP=2
  CONST MENU_EDIT_MOVEBOTTOM=3
  CONST MENU_EDIT_MOVELPREV=4
  CONST MENU_EDIT_MOVELNEXT=5

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
  DEF savePath[256]:STRING
  
  DEF tabsbase=0
  DEF gradientsliderbase=0
  DEF progressbase=0
  DEF statusbarbase=0
  DEF tapedeckbase=0
  DEF textentrybase=0
  DEF ledbase=0
  DEF smartbitmapbase=0
  DEF titlebarbase=0
  DEF errorState=0
  DEF codeOptions: codeOptions

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
  IF (getfilebase:=OpenLibrary('gadgets/getfile.gadget',0))=NIL THEN Throw("LIB","file")
  IF (getfontbase:=OpenLibrary('gadgets/getfont.gadget',0))=NIL THEN Throw("LIB","font")
  IF (getscreenmodebase:=OpenLibrary('gadgets/getscreenmode.gadget',0))=NIL THEN Throw("LIB","scrn")
  IF (sliderbase:=OpenLibrary('gadgets/slider.gadget',0))=NIL THEN Throw("LIB","sldr")
  IF (glyphbase:=OpenLibrary('images/glyph.image',0))=NIL THEN Throw("LIB","glyp")
  IF (labelbase:=OpenLibrary('images/label.image',0))=NIL THEN Throw("LIB","labl")
  IF (bevelbase:=OpenLibrary('images/bevel.image',0))=NIL THEN Throw("LIB","bevl")
  IF (drawlistbase:=OpenLibrary('images/drawlist.image',0))=NIL THEN Throw("LIB","draw")
  IF (penmapbase:=OpenLibrary('images/penmap.image',0))=NIL THEN Throw("LIB","penm")
  IF (bitmapbase:=OpenLibrary('images/bitmap.image',0))=NIL THEN Throw("LIB","bitm")
  tabsbase:=OpenLibrary('gadgets/tabs.gadget',0)
  speedbarbase:=OpenLibrary('gadgets/speedbar.gadget',0)
  textfieldbase:=OpenLibrary('gadgets/textfield.gadget',0)
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

  IF tabsbase THEN CloseLibrary(tabsbase)
  IF colorwheelbase THEN CloseLibrary(colorwheelbase)
  IF datebrowserbase THEN CloseLibrary(datebrowserbase)
  IF getcolorbase THEN  CloseLibrary(getcolorbase)
  IF gradientsliderbase THEN CloseLibrary(gradientsliderbase)
  IF listviewbase THEN CloseLibrary(listviewbase)
  IF progressbase THEN CloseLibrary(progressbase)
  IF sketchboardbase THEN CloseLibrary(sketchboardbase)
  IF statusbarbase THEN CloseLibrary(statusbarbase)
  IF tapedeckbase THEN CloseLibrary(tapedeckbase)
  IF textfieldbase THEN CloseLibrary(textfieldbase)
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
    IF comp.parent THEN parent:=comp.parent ELSE parent:=window
    
    FOR i:=0 TO comp.children.count()-1
      removeMembers(comp.children.item(i),window)
    ENDFOR
    IF comp.previewObject
      IF parent.addChildTag()=parent.removeChildTag()
        Sets(parent.addChildTo(),parent.removeChildTag(), 0)
      ELSE
        Sets(parent.addChildTo(),parent.removeChildTag(), comp.previewObject)
      ENDIF
      comp.previewObject:=0
      comp.previewChildAttrs:=0
    ENDIF
  ENDIF
ENDPROC

PROC addMembers(comp:PTR TO reactionObject,window:PTR TO windowObject)
  DEF i, parent:PTR TO reactionObject
  IF comp
    IF comp.parent THEN parent:=comp.parent ELSE parent:=window
    comp.createPreviewObject(win.wscreen)
    IF (comp.isImage())
      SetGadgetAttrsA(parent.addChildTo(),0,0,[parent.addImageTag(), comp.previewObject, TAG_END])
    ELSE
      SetGadgetAttrsA(parent.addChildTo(),0,0,[parent.addChildTag(), comp.previewObject, TAG_END])
    ENDIF
    IF comp.previewChildAttrs THEN SetGadgetAttrsA(parent.previewObject,0,0,comp.previewChildAttrs)

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
  DEF disprevgroup,disnextgroup
  DEF menuItem
  DEF type
  DEF allowchildren=FALSE
  
  IF node THEN GetListBrowserNodeAttrsA(node,[LBNA_USERDATA,{comp},TAG_END])
  IF comp
    allowchildren:=(comp.allowChildren()=TRUE) ORELSE ((comp.allowChildren()>0) ANDALSO (comp.children.count()<comp.allowChildren()))
    selectedComp:=comp
    FOR i:=0 TO 31
      FOR j:=0 TO 1
        IF ((j=0) AND (i<MENU_ADD_GADGET_COUNT) OR (i<MENU_ADD_IMAGE_COUNT))

          menuItem:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,IF j=0 THEN MENU_EDIT_ADD_GADGET ELSE MENU_EDIT_ADD_IMAGE,i))
          IF menuItem
            type:=GTMENUITEM_USERDATA(menuItem)
            IF type<>-1
              check:=(allowchildren=FALSE) OR (comp.type=TYPE_WINDOW) OR (type==[TYPE_STATUSBAR,
                TYPE_PAGE, TYPE_PROGRESS, TYPE_TEXTENTRY, TYPE_SMARTBITMAP, TYPE_TITLEBAR])
              menuDisable(win,MENU_EDIT,IF j=0 THEN MENU_EDIT_ADD_GADGET ELSE MENU_EDIT_ADD_IMAGE,i,check)
            ENDIF
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
      disprevgroup:=TRUE
      disnextgroup:=TRUE
    ELSE
      dismoveup:=comp.getChildIndex()=0
      dismovedown:=comp.getChildIndex()=(comp.parent.children.count()-1)
      disdel:=(comp.parent=0)
      IF comp.parent.parent=0
        disprevgroup:=TRUE
        disnextgroup:=TRUE
      ELSE
        disprevgroup:=TRUE
        FOR i:=0 TO comp.parent.getChildIndex()-1
          child:=comp.parent.parent.children.item(i)
          IF child.type=TYPE_LAYOUT THEN disprevgroup:=FALSE
        ENDFOR
        disnextgroup:=TRUE
        FOR i:=comp.parent.getChildIndex()+1 TO comp.parent.parent.children.count()-1
          child:=comp.parent.parent.children.item(i)
          IF child.type=TYPE_LAYOUT THEN disnextgroup:=FALSE
        ENDFOR
      ENDIF
    ENDIF
    
    dis:=allowchildren=FALSE
    menuDisable(win,MENU_EDIT,MENU_EDIT_EDIT,0,FALSE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_ADD_VLAYOUT,0,dis)
    menuDisable(win,MENU_EDIT,MENU_EDIT_ADD_HLAYOUT,0,dis)
    menuDisable(win,MENU_EDIT,MENU_EDIT_DELETE,0,disdel)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVEUP,dismoveup)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVEDOWN,dismovedown)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVETOP,dismoveup)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVEBOTTOM,dismovedown)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVELPREV,disprevgroup)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVELNEXT,disnextgroup)
    
    SetGadgetAttrsA(gMain_Gadgets[GAD_ADD],win,0,[GA_DISABLED,(comp.parent=0) AND (allowchildren=FALSE) AND (comp.type<>TYPE_SCREEN) AND (comp.type<>TYPE_WINDOW),TAG_END])
    SetGadgetAttrsA(gMain_Gadgets[GAD_GENMINUS],win,0,[GA_DISABLED,Not((comp.parent<>0) ANDALSO (comp.parent.parent<>0)),TAG_END])

    IF bufferLayout
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_COPYTO],win,0,[GA_DISABLED,(comp.parent=0) AND (comp.allowChildren()=FALSE) AND (comp.type<>TYPE_WINDOW),TAG_END])
      SetGadgetAttrsA(gMain_Gadgets[GAD_TEMP_MOVETO],win,0,[GA_DISABLED,(((comp.parent=0) AND (comp.type<>TYPE_WINDOW))),TAG_END])
    ENDIF

    
    dis:=TRUE
    IF comp.parent
      idx:=comp.getChildIndex()
      IF (idx<(comp.parent.children.count()-1))
        child:=comp.parent.children.item(idx+1)
        IF (child.allowChildren())
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
      FOR j:=0 TO 1
        IF ((j=0) AND (i<MENU_ADD_GADGET_COUNT) OR (i<MENU_ADD_IMAGE_COUNT))
          menuItem:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,IF j=0 THEN MENU_EDIT_ADD_GADGET ELSE MENU_EDIT_ADD_IMAGE,i))
          IF menuItem
            type:=GTMENUITEM_USERDATA(menuItem)
            IF type<>-1 THEN menuDisable(win,MENU_EDIT,IF j=0 THEN MENU_EDIT_ADD_GADGET ELSE MENU_EDIT_ADD_IMAGE,i,TRUE)
          ENDIF
        ENDIF
      ENDFOR
    ENDFOR
    menuDisable(win,MENU_EDIT,MENU_EDIT_EDIT,0,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_DELETE,0,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVEUP,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_MOVE,MENU_EDIT_MOVEDOWN,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_ADD_VLAYOUT,0,TRUE)
    menuDisable(win,MENU_EDIT,MENU_EDIT_ADD_HLAYOUT,0,TRUE)

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
        GA_TEXT, '=>Copy',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_COPYFROM]:=ButtonObject,
        GA_ID, GAD_TEMP_COPYFROM,
        GA_TEXT, '<=Copy',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_MOVETO]:=ButtonObject,
        GA_ID, GAD_TEMP_MOVETO,
        GA_TEXT, 'Move=>',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, gMain_Gadgets[GAD_TEMP_MOVEFROM]:=ButtonObject,
        GA_ID, GAD_TEMP_MOVEFROM,
        GA_TEXT, '<=Move',
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
    WINDOW_ICONTITLE, 'Rebuild',
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
    idx:=findWindowIndex(parent)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    parent.addChild(newobj)
    makeList(newobj)
    addMembers(mainRootLayout,window)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC removeObject(child:PTR TO reactionObject)
  DEF i,idx, mainRootLayout
  DEF comp2:PTR TO reactionObject
  DEF window,parent:PTR TO reactionObject

  parent:=child.parent
  
  IF parent.allowChildren()
    idx:=findWindowIndex(child)
    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    idx:=child.getChildIndex()
    parent.removeChild(child)
    END child
    makeList()
    addMembers(mainRootLayout,window)
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

PROC moveUp(child:PTR TO reactionObject,count=1)
  DEF idx, mainRootLayout, window
  DEF parent:PTR TO reactionObject
  
  parent:=child.parent
  IF parent=0
    idx:=findWindowIndex(child)

    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    WHILE count
      swapWindows(idx,idx-1)
      idx--
      count--
    ENDWHILE
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
    WHILE count
      parent.swapChildren(child.getChildIndex(),child.getChildIndex()-1)
      count--
    ENDWHILE
    makeList(child)
    addMembers(mainRootLayout,window)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC moveDown(child:PTR TO reactionObject,count=1)
  DEF idx, mainRootLayout, window
  DEF parent:PTR TO reactionObject
  parent:=child.parent
  IF parent=0
    idx:=findWindowIndex(child)

    mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
    window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
    removeMembers(mainRootLayout,window)
    WHILE count
      swapWindows(idx,idx+1)
      idx++
      count--
    ENDWHILE
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
    WHILE count
      parent.swapChildren(child.getChildIndex(),child.getChildIndex()+1)
      count--
    ENDWHILE
    makeList(child)
    addMembers(mainRootLayout,window)
    rethinkPreviews()
  ENDIF
ENDPROC

PROC movePrevLayout(comp:PTR TO reactionObject)
  DEF idx, mainRootLayout, window
  DEF newLayout:PTR TO reactionObject
  DEF i
  
  i:=comp.parent.getChildIndex()-1
  WHILE comp.parent.parent.children.item(i)::reactionObject.type<>TYPE_LAYOUT DO i--
  newLayout:=comp.parent.parent.children.item(i)

  changes:=TRUE
  idx:=findWindowIndex(comp)
  mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
  window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
  removeMembers(mainRootLayout,window)
  comp.parent.removeChild(comp)
  newLayout.addChild(comp)
  makeList(comp)
  addMembers(mainRootLayout,window)
  rethinkPreviews()
ENDPROC

PROC moveNextLayout(comp:PTR TO reactionObject)
  DEF idx, mainRootLayout, window
  DEF newLayout:PTR TO reactionObject
  DEF i
  
  i:=comp.parent.getChildIndex()+1
  WHILE comp.parent.parent.children.item(i)::reactionObject.type<>TYPE_LAYOUT DO i++
  newLayout:=comp.parent.parent.children.item(i)

  changes:=TRUE
  idx:=findWindowIndex(comp)
  mainRootLayout:=objectList.item(ROOT_LAYOUT_ITEM+(idx*3))
  window:=objectList.item(ROOT_WINDOW_ITEM+(idx*3))
  removeMembers(mainRootLayout,window)
  comp.parent.removeChild(comp)
  newLayout.addChild(comp)
  makeList(comp)
  addMembers(mainRootLayout,window)
  rethinkPreviews()
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
  DEF n
  IF from.libsused
    FOR i:=0 TO ListLen(from.libsused)-1 
      n:=ListItem(from.libsused,i)
      libsused[n]:=TRUE
    ENDFOR
  ENDIF

  FOR i:=0 TO from.children.count()-1 DO findLibsUsed(from.children.item(i),libsused)
ENDPROC

PROC countGads(from=0:PTR TO reactionObject,n=0)
  DEF i
  IF from=0 THEN from:=objectList.item(ROOT_LAYOUT_ITEM)

  FOR i:=0 TO from.children.count()-1 DO n:=countGads(from.children.item(i),n)
ENDPROC n+1

PROC genComponentCode(comp:PTR TO reactionObject, nptr:PTR TO LONG, srcGen:PTR TO srcGen)
  DEF i
  DEF tempStr[200]:STRING
  DEF libname,libtype,addTag
  IF comp.isImage()
    IF comp.parent THEN addTag:=comp.parent.addImageTag() ELSE addTag:=LAYOUT_ADDIMAGE
    srcGen.componentAddImage(addTag)
  ELSE
    IF comp.parent THEN addTag:=comp.parent.addChildTag() ELSE addTag:=LAYOUT_ADDCHILD
    srcGen.componentAddChild(addTag)
  ENDIF

  srcGen.assignGadgetVar(nptr[])
  IF (libtype:=comp.libTypeCreate())
    srcGen.componentLibtypeCreate(libtype)
  ELSEIF (libname:=comp.libNameCreate())
    srcGen.componentLibnameCreate(libname)
  ELSE
    StringF(tempStr,'\sObject,',comp.getTypeName())
    srcGen.componentCreate(tempStr)
  ENDIF

  IF comp.type<>TYPE_LAYOUT
    IF srcGen.useIds
      srcGen.componentPropertyInt('GA_ID',comp.id)
    ELSE
      srcGen.componentPropertyInt('GA_ID',srcGen.currentGadgetVar)
    ENDIF
  ENDIF
  comp.genCodeProperties(srcGen)
  IF comp.children.count()>0
    comp.genChildObjectsHeader(srcGen)
    FOR i:=0 TO comp.children.count()-1
      nptr[]:=nptr[]+1
      genComponentCode(comp.children.item(i),nptr,srcGen)
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
  DEF i,res
  DEF menuComp:PTR TO reactionObject
  DEF windowComp:PTR TO reactionObject
  DEF layoutComp:PTR TO reactionObject
  DEF screenComp:PTR TO screenObject
  DEF rexxComp:PTR TO rexxObject
  DEF libsused[TYPE_MAX]:ARRAY OF CHAR
  DEF n
  
  setBusy()
  NEW codeGenForm.create()
  res:=codeGenForm.selectLang(codeOptions)
  END codeGenForm
  clearBusy()
  IF res=FALSE THEN RETURN

  aslbase:=OpenLibrary('asl.library',37)
  IF aslbase=NIL THEN Throw("LIB","ASL")
  tags:=NEW [ASL_HAIL,'Select a file to save',
     ASL_WINDOW, win,
     ASLFR_INITIALDRAWER, codeOptions.savePath,
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
  AstrCopy(codeOptions.savePath,fr.drawer,256)
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

 SELECT codeOptions.langid
    CASE LANG_E
      NEW eSrcGen.create(fs,libsused,codeOptions.fullcode=FALSE,codeOptions.useids)
      srcGen:=eSrcGen
    CASE LANG_C
      NEW cSrcGen.create(fs,libsused,codeOptions.fullcode=FALSE,codeOptions.useids)
      srcGen:=cSrcGen
  ENDSELECT

  i:=0
  windowComp:=objectList.item(ROOT_WINDOW_ITEM)
  screenComp:=objectList.item(ROOT_SCREEN_ITEM)
  rexxComp:=objectList.item(ROOT_REXX_ITEM)
  srcGen.genHeader(screenComp,rexxComp)
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
    n:=0
    genComponentCode(layoutComp,{n},srcGen)
    srcGen.componentEnd('LayoutEnd,') 
    srcGen.finalComponentEnd(objectEnd) 
    srcGen.decreaseIndent()
    srcGen.genWindowFooter(count,windowComp,menuComp,layoutComp, getReactionLists())
    i+=3
  ENDWHILE
  windowComp:=objectList.item(ROOT_WINDOW_ITEM)
  srcGen.genFooter(windowComp,rexxComp)
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
  DEF tempStr[300]:STRING
  DEF loadObjectList=0:PTR TO stdlist
  DEF reactionLists:PTR TO stdlist
  DEF type,i
  DEF a=0:PTR TO menuitem

  DEF ver,newid,v

  DEF tags
  DEF fr:PTR TO filerequester
  DEF fname[255]:STRING

  errorState:=FALSE
  aslbase:=OpenLibrary('asl.library',37)
  IF aslbase=NIL THEN Throw("LIB","ASL")
  tags:=NEW [ASL_HAIL,'Select a file to load',
     ASL_WINDOW, win,
     ASLFR_INITIALDRAWER, savePath,
     TAG_DONE]
  fr:=AllocAslRequest(ASL_FILEREQUEST,tags)
  IF(AslRequest(fr,0))=FALSE
    IF tags THEN FastDisposeList(tags)
    IF aslbase THEN CloseLibrary(aslbase)
    RETURN
  ENDIF

  StrCopy(fname,fr.drawer)
  StrCopy(savePath,fr.drawer)
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
    ELSEIF StrCmp(tempStr,'LANGID=',STRLEN)
      v:=Val(tempStr+STRLEN)
      codeOptions.langid:=v
    ELSEIF StrCmp(tempStr,'USEIDS=',STRLEN)
      v:=Val(tempStr+STRLEN)
      codeOptions.useids:=IF v THEN TRUE ELSE FALSE
    ELSEIF StrCmp(tempStr,'FULLCODE=',STRLEN)
      v:=Val(tempStr+STRLEN)
      codeOptions.fullcode:=IF v THEN TRUE ELSE FALSE
    ELSEIF StrCmp(tempStr,'CODEFOLDER=',STRLEN)
      AstrCopy(codeOptions.savePath,tempStr+STRLEN,256)
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
  DEF tempStr[300]:STRING
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
  StringF(tempStr,'LANGID=\d',codeOptions.langid)
  fs.writeLine(tempStr)
  StringF(tempStr,'USEIDS=\d',IF codeOptions.useids THEN TRUE ELSE FALSE)
  fs.writeLine(tempStr)
  StringF(tempStr,'FULLCODE=\d',IF codeOptions.fullcode THEN TRUE ELSE FALSE)
  fs.writeLine(tempStr)
  StringF(tempStr,'CODEFOLDER=\s',codeOptions.savePath)
  fs.writeLine(tempStr)
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
     ASLFR_INITIALDRAWER, savePath,
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
  StrCopy(savePath,fr.drawer)
  AddPart(fname,fr.file,100)
  SetStr(fname)
  StrCopy(filename,fname)
  UpperStr(fname)
  IF EndsWith(fname,'.REB')=FALSE THEN StrAdd(filename,'.reb')
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
  
  SUBA.L #$100,A7
  
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
  ADD.L #$100,A7
ENDPROC res

PROC showAbout()
  DEF reqmsg:PTR TO orrequest
  DEF aboutStr[100]:STRING
  DEF reqobj
  
  SUBA.L #$100,A7

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
  ADD.L #$100,A7
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
  IF errorState
    errorRequest(mainWindow,'Warning','This file contains gadgets that you do not have installed.\nThey will not be displayed correctly.')
  ENDIF
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

PROC doAddLayoutQuick(comp:PTR TO reactionObject, horiz)
  DEF newObj:PTR TO layoutObject
  DEF a=0:PTR TO menuitem
  DEF allowchildren
  DEF tempStr[100]:STRING
  newObj:=0
  
  allowchildren:=((comp.allowChildren()=TRUE) OR ((comp.allowChildren()>0) AND (comp.children.count()<comp.allowChildren())))
  WHILE (comp) AND (allowchildren=FALSE) 
    comp:=comp.parent
    IF comp THEN allowchildren:=((comp.allowChildren()=TRUE) OR ((comp.allowChildren()>0) AND (comp.children.count()<comp.allowChildren())))
  ENDWHILE
  IF comp AND allowchildren
    newObj:=createLayoutObject(comp)
    IF newObj 
      IF horiz
        newObj.orientation:=0
        StringF(tempStr,'Horiz\d',newObj.id)
        AstrCopy(newObj.name,tempStr,80)
      ENDIF
      changes:=TRUE
      addObject(comp,newObj)
    ENDIF
  ENDIF
ENDPROC


PROC doAddComp(comp:PTR TO reactionObject, objType)
  DEF newObj:PTR TO reactionObject
  DEF a=0:PTR TO menuitem
  DEF allowchildren
  newObj:=0
  
  allowchildren:=((comp.allowChildren()=TRUE) OR ((comp.allowChildren()>0) AND (comp.children.count()<comp.allowChildren())))
  WHILE (comp) AND (allowchildren=FALSE) 
    comp:=comp.parent
    IF comp THEN allowchildren:=((comp.allowChildren()=TRUE) OR ((comp.allowChildren()>0) AND (comp.children.count()<comp.allowChildren())))
  ENDWHILE
  IF comp
    newObj:=createObjectByType(objType,comp)
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
    IF selectedComp.children.count()>0
      IF (warnRequest(mainWindow,'Warning','Are you sure you wish\nto delete this item and all of its children?',TRUE)=1)
        changes:=TRUE
        removeObject(selectedComp)
      ENDIF
    ELSE
      IF win
        a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_WARN_ON_DEL,0))
      ENDIF
      IF a THEN skipWarn:=(a.flags AND CHECKED)
      
      IF (skipWarn=0) ORELSE (warnRequest(mainWindow,'Warning','Are you sure you wish\nto delete this item?',TRUE)=1)
        changes:=TRUE
        removeObject(selectedComp)
      ENDIF
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

PROC doCopyToBuffer(comp:PTR TO reactionObject)
  DEF recurse=FALSE

  IF comp.children.count()>0
    recurse:=queryRequest(mainWindow,'Query','Do you wish to copy recursively?')=1
  ENDIF
  
  copyToBuffer(comp,recurse)
ENDPROC

PROC copyToBuffer(comp:PTR TO reactionObject,recurse)
  DEF newObj:PTR TO reactionObject
  DEF fs:PTR TO fileStreamer
  DEF i

  NEW fs.create('t:tempcomp',MODE_NEWFILE)
  comp.serialise(fs)
  END fs
  
  newObj:=createObjectByType(comp.type,0)
  NEW fs.create('t:tempcomp',MODE_OLDFILE)
  newObj.deserialise(fs)
  END fs
  bufferList.add(newObj)
  
  IF recurse
    FOR i:=0 TO comp.children.count()-1
      copyToBuffer(comp.children.item(i),TRUE)
    ENDFOR
  ENDIF
  
  makeBufferList()
ENDPROC

PROC doMoveToBuffer(comp:PTR TO reactionObject)
  IF comp.children.count()>0
    IF warnRequest(mainWindow,'Warning','This will move this and all child items into the buffer.\nDo you wish to continue?',TRUE)=0 THEN RETURN
  ENDIF
  changes:=TRUE

  copyToBuffer(comp,TRUE)
  removeObject(comp)
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
  errorState:=FALSE
  
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
  DEF menuSetup:PTR TO LONG

  count:=(objectList.count()-ROOT_WINDOW_ITEM)/3
  IF count<0 THEN count:=0
  count++

  IF win
    a:=ItemAddress(win.menustrip,menuCode(MENU_EDIT,MENU_EDIT_SHOW_ADD_SETTINGS,0))
    IF (a)
      IF (a.flags AND CHECKED)=0 THEN addSett:=FALSE
    ENDIF
  ENDIF

  IF menus THEN FreeMenus(menus)
  
  menuSetup:=[
  NM_TITLE,'Project',0,0,
  NM_ITEM,'New',0,0,
  NM_ITEM,'Open',0,0,
  NM_ITEM,'Save',0,0,
  NM_ITEM,'Save As',0,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Generate Code',0,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Show Libraries',0,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'About',0,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Quit',0,0,
  NM_TITLE,'Edit',0,0,
  NM_ITEM,'Add Gadget',-1,0,
  NM_SUB,'Button',TYPE_BUTTON,0,
  NM_SUB,'CheckBox',TYPE_CHECKBOX,0,
  NM_SUB,'Chooser',TYPE_CHOOSER,0,
  NM_SUB,'ClickTab',TYPE_CLICKTAB,0,
  NM_SUB,'ColorWheel',TYPE_COLORWHEEL,0,
  NM_SUB,'DateBrowser',TYPE_DATEBROWSER,0,
  NM_SUB,'FuelGauge',TYPE_FUELGAUGE,0,
  NM_SUB,'GetColor',TYPE_GETCOLOR,0,
  NM_SUB,'GetFile',TYPE_GETFILE,0,
  NM_SUB,'GetFont',TYPE_GETFONT,0,
  NM_SUB,'GetScreenMode',TYPE_GETSCREENMODE,0,
  NM_SUB,'GradientSlider',TYPE_GRADSLIDER,0,
  NM_SUB,'Integer',TYPE_INTEGER,0,
  NM_SUB,'Layout',TYPE_LAYOUT,0,
  NM_SUB,'ListBrowser',TYPE_LISTBROWSER,0,
  NM_SUB,'ListView',TYPE_LISTVIEW,0,
  NM_SUB,'Palette',TYPE_PALETTE,0,
  NM_SUB,'RadioButton',TYPE_RADIO,0,
  NM_SUB,'Scroller',TYPE_SCROLLER,0,
  NM_SUB,'SketchBoard',TYPE_SKETCH,0,
  NM_SUB,'Slider',TYPE_SLIDER,0,
  NM_SUB,'Space',TYPE_SPACE,0,
  NM_SUB,'SpeedBar',TYPE_SPEEDBAR,0,
  NM_SUB,'String',TYPE_STRING,0,
  NM_SUB,'Tabs',TYPE_TABS,0,
  NM_SUB,'TapeDeck',TYPE_TAPEDECK,0,
  NM_SUB,'TextEditor',TYPE_TEXTEDITOR,0,
  NM_SUB,'TextField',TYPE_TEXTFIELD,0,
  NM_SUB,'Virtual',TYPE_VIRTUAL,0,
  NM_ITEM,'Add Image',-1,0,
  NM_SUB,'Bevel',TYPE_BEVEL,0,
  NM_SUB,'BitMap',TYPE_BITMAP,0,
  NM_SUB,'BoingBall',TYPE_BOINGBALL,0,
  NM_SUB,'DrawList',TYPE_DRAWLIST,0,
  NM_SUB,'Glyph',TYPE_GLYPH,0,
  NM_SUB,'Label',TYPE_LABEL,0,
  NM_SUB,'LED',TYPE_LED,0,
  NM_SUB,'PenMap',TYPE_PENMAP,0,
  NM_ITEM,'Add Window',-1,0,
  NM_ITEM,'Add HLayout (quick)',-1,0,
  NM_ITEM,'Add VLayout (quick)',-1,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Edit',0,0,
  NM_ITEM,'Delete',0,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Move',0,0,
  NM_SUB,'Up',0,0,
  NM_SUB,'Down',0,0,
  NM_SUB,'Layout Top',0,0,
  NM_SUB,'Layout Bottom',0,0,
  NM_SUB,'Prev Layout',0,0,
  NM_SUB,'Next Layout',0,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Edit Lists',0,0,
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Show Buffer',0,(CHECKIT OR (IF bufferLayout THEN CHECKED ELSE 0 ) OR MENUTOGGLE),
  NM_ITEM,'Show Settings On Add',0,(CHECKIT OR (IF addSett THEN CHECKED ELSE 0 ) OR MENUTOGGLE),
  NM_ITEM,'Warn On Delete',0,(CHECKIT OR (IF addSett THEN CHECKED ELSE 0 ) OR MENUTOGGLE),
  NM_ITEM,NM_BARLABEL,0,0,
  NM_ITEM,'Preview Windows',0,0
  ]
  count:=count+Shr(ListLen(menuSetup),2)
  NEW menuData[count]
  
  n:=0
  i:=0
  WHILE i<ListLen(menuSetup)
    menuData[n].type:=menuSetup[i++]
    menuData[n].label:=menuSetup[i++]
    menuData[n].userdata:=menuSetup[i++]
    menuData[n++].flags:=menuSetup[i++]
  ENDWHILE

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
      newObj:=createSliderObject(comp)
    CASE TYPE_SPEEDBAR
      newObj:=createSpeedBarObject(comp)
    CASE TYPE_COLORWHEEL
      newObj:=createColorWheelObject(comp)
    CASE TYPE_DATEBROWSER
      newObj:=createDateBrowserObject(comp)
    CASE TYPE_GETCOLOR
      newObj:=createGetColorObject(comp)
    CASE TYPE_GRADSLIDER
      newObj:=createGradSliderObject(comp)
    CASE TYPE_TAPEDECK
      newObj:=createTapeDeckObject(comp)
    CASE TYPE_TEXTEDITOR
      newObj:=createTextEditorObject(comp)
    CASE TYPE_LED
      newObj:=createLedObject(comp)
    CASE TYPE_LISTVIEW
      newObj:=createListViewObject(comp)
    CASE TYPE_VIRTUAL
      newObj:=createVirtualObject(comp)
    CASE TYPE_SKETCH
      newObj:=createSketchboardObject(comp)
    CASE TYPE_TABS
      newObj:=createTabsObject(comp)
    DEFAULT
      Raise("OBJ")
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
  initialise()
  NEW objectList.stdlist(20)
  NEW bufferList.stdlist(20)
  initReactionLists()
  
  codeOptions.langid:=0
  codeOptions.useids:=TRUE
  codeOptions.fullcode:=TRUE
  AstrCopy(codeOptions.savePath,'')
  StrCopy(savePath,'')
  
  createForm()
  
  IF (win:=RA_OpenWindow(mainWindow))
    SetMenuStrip(win,menus)
    newProject()
    openPreviews()
    updateBufferSel(win,0)

    GetAttr( WINDOW_SIGMASK, mainWindow, {wsig} )
    WHILE running
      wsig:=getAllWindowSigs()
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
                    CASE MENU_EDIT_ADD_GADGET  ->Add
                      item:=ItemAddress(win.menustrip,result)
                      type:=GTMENUITEM_USERDATA(item)
                      IF type<>-1 THEN doAddComp(selectedComp,type)
                    CASE MENU_EDIT_ADD_IMAGE
                      item:=ItemAddress(win.menustrip,result)
                      type:=GTMENUITEM_USERDATA(item)
                      IF type<>-1 THEN doAddComp(selectedComp,type)
                    CASE MENU_EDIT_ADD_WINDOW
                      doAddWindow()
                    CASE MENU_EDIT_ADD_HLAYOUT
                      doAddLayoutQuick(selectedComp,TRUE)
                    CASE MENU_EDIT_ADD_VLAYOUT
                      doAddLayoutQuick(selectedComp,FALSE)
                    CASE MENU_EDIT_EDIT ->Edit
                      doEdit()
                    CASE MENU_EDIT_DELETE  ->Delete
                      doDelete()
                    CASE MENU_EDIT_MOVE  ->Move
                      SELECT subitem
                        CASE MENU_EDIT_MOVEUP
                          moveUp(selectedComp)
                        CASE MENU_EDIT_MOVEDOWN
                          moveDown(selectedComp)
                        CASE MENU_EDIT_MOVETOP
                          moveUp(selectedComp,selectedComp.getChildIndex())
                        CASE MENU_EDIT_MOVEBOTTOM
                          moveDown(selectedComp,selectedComp.parent.children.count()-selectedComp.getChildIndex()-1)
                        CASE MENU_EDIT_MOVELPREV
                          movePrevLayout(selectedComp)
                        CASE MENU_EDIT_MOVELNEXT
                          moveNextLayout(selectedComp)
                      ENDSELECT
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
                  moveUp(selectedComp)
                CASE GAD_MOVEDOWN  ->Move Down
                  moveDown(selectedComp)
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
                  doCopyToBuffer(selectedComp)
                CASE GAD_TEMP_MOVETO
                  doMoveToBuffer(selectedComp)
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
    CASE "OBJ"
      WriteF('unimplemented object type\n')
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
  IF mainWindow THEN RA_CloseWindow(mainWindow)
  win:=0
  closePreviews()
  IF objectList
    i:=ROOT_WINDOW_ITEM
    WHILE i<objectList.count()
      removeMembers(objectList.item(i+ROOT_LAYOUT_ITEM-ROOT_WINDOW_ITEM),objectList.item(i))
      i+=3
    ENDWHILE
  ENDIF
  IF menus THEN FreeMenus(menus)
  disposeObjects()
  IF objectList THEN END objectList
  IF bufferList 
    disposeBufferObjects()
    END bufferList
  ENDIF
  freeReactionLists()
  IF list THEN freeBrowserNodes( list )
  IF list2 THEN freeBrowserNodes( list2 )
  IF mainWindow THEN DisposeObject(mainWindow)
  IF (appPort) THEN DeleteMsgPort(appPort)
  deinitialise()
  closeClasses()
ENDPROC

CHAR verstring