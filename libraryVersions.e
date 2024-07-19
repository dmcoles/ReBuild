OPT MODULE

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'exec/nodes',
        'listbrowser','gadgets/listbrowser',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec/libraries',
        'gadtools',
        'listbrowser',
        'radiobutton',
        'clicktab',
        'layout',
        'window',
        'requester',
        'string',
        'chooser',
        'palette',
        'space',
        'integer',
        'scroller',
        'checkbox',
        'fuelgauge',
        'textfield',
        'getfile',
        'getfont',
        'getscreenmode',
        'slider',
        'speedbar',
         'glyph',
        'label',
        'bevel',
        'drawlist',
        'penmap',
        'bitmap',
        'colorwheel',
        'datebrowser',
        'getcolor',
        'listview',
        'sketchboard',
        'texteditor',
        'virtual',        
        '*bball'

  MODULE '*reactionForm'

  EXPORT DEF gradientsliderbase
  EXPORT DEF progressbase
  EXPORT DEF tapedeckbase
  EXPORT DEF texteditorbase
  EXPORT DEF textentrybase
  EXPORT DEF ledbase
  EXPORT DEF smartbitmapbase
  EXPORT DEF statusbarbase
  EXPORT DEF titlebarbase
  
EXPORT ENUM LIBS_LIST, LIBS_BTNOK

CONST NUMGADS=LIBS_BTNOK+1

EXPORT OBJECT libraryList OF reactionForm
PRIVATE
  columninfo[3]:ARRAY OF columninfo
  browserlist:PTR TO LONG
ENDOBJECT

EXPORT PROC create() OF libraryList
  DEF gads:PTR TO LONG
  DEF i
  
  NEW gads[NUMGADS]
  self.gadgetList:=gads
  NEW gads[NUMGADS]
  self.gadgetActions:=gads

  
  self.columninfo[0].width:=3
  self.columninfo[0].title:='Library'
  self.columninfo[0].flags:=CIF_WEIGHTED
  
  self.columninfo[1].width:=1
  self.columninfo[1].title:='Version'
  self.columninfo[1].flags:=CIF_WEIGHTED
  
  self.columninfo[2].width:=-1
  self.columninfo[2].title:=-1
  self.columninfo[2].flags:=-1
  
  self.browserlist:=browserNodesA([0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Library versions',
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

      LAYOUT_ADDCHILD,self.gadgetList[LIBS_LIST]:=ListBrowserObject,
          GA_ID, LIBS_LIST,
          GA_RELVERIFY, TRUE,
          LISTBROWSER_POSITION, 0,
          LISTBROWSER_SHOWSELECTED, TRUE,
          LISTBROWSER_COLUMNTITLES, TRUE,
          LISTBROWSER_HIERARCHICAL, FALSE,
          LISTBROWSER_COLUMNINFO, self.columninfo,
          LISTBROWSER_LABELS, self.browserlist,
      ListBrowserEnd,

      LAYOUT_ADDCHILD,self.gadgetList[LIBS_BTNOK]:=ButtonObject,
        GA_ID, LIBS_BTNOK,
        GA_TEXT, 'Ok',
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
      ButtonEnd,
    CHILD_WEIGHTEDHEIGHT, 0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[LIBS_BTNOK]:=MR_OK
ENDPROC

PROC end() OF libraryList
  freeBrowserNodes(self.browserlist)
  END self.gadgetList[NUMGADS]
  END self.gadgetActions[NUMGADS]
  DisposeObject(self.windowObj)
ENDPROC

PROC addLibrary(name,lib:PTR TO lib) OF libraryList
  DEF n,version[20]:STRING

  IF lib
    StringF(version,'\d.\d',lib.version AND $FFFF,lib.revision AND $FFFF)
  ELSE
    StrCopy(version,'N/A')
  ENDIF

  IF (n:=AllocListBrowserNodeA(2, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, name,  LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, version, TAG_END]))
    AddTail(self.browserlist, n)
  ELSE 
    Raise("MEM")    
  ENDIF
ENDPROC

EXPORT PROC showLibraries() OF libraryList

  SetGadgetAttrsA(self.gadgetList[LIBS_LIST],0,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

  self.addLibrary('gadgets/button.gadget',buttonbase)
  self.addLibrary('gadgets/checkbox.gadget',checkboxbase)
  self.addLibrary('gadgets/chooser.gadget',chooserbase)
  self.addLibrary('gadgets/clicktab.gadget',clicktabbase)
  self.addLibrary('gadgets/colorwheel.gadget',colorwheelbase)
  self.addLibrary('gadgets/datebrowser.gadget',datebrowserbase)
  self.addLibrary('gadgets/fuelgauge.gadget',fuelgaugebase)
  self.addLibrary('gadgets/getcolor.gadget',getcolorbase)
  self.addLibrary('gadgets/getfile.gadget',getfilebase)
  self.addLibrary('gadgets/getfont.gadget',getfontbase)
  self.addLibrary('gadgets/getscreenmode.gadget',getscreenmodebase)
  self.addLibrary('gadgets/gradientslider.gadget',gradientsliderbase)
  self.addLibrary('gadgets/integer.gadget',integerbase)
  self.addLibrary('gadgets/layout.gadget',layoutbase)
  self.addLibrary('gadgets/listbrowser.gadget',listbrowserbase)
  self.addLibrary('gadgets/listview.gadget',listviewbase)
  self.addLibrary('gadgets/palette.gadget',palettebase)
  self.addLibrary('gadgets/radiobutton.gadget',radiobuttonbase)
  self.addLibrary('gadgets/scroller.gadget',scrollerbase)
  self.addLibrary('gadgets/sketchboard.gadget',sketchboardbase)
  self.addLibrary('gadgets/slider.gadget',sliderbase)
  self.addLibrary('gadgets/space.gadget',spacebase)
  self.addLibrary('gadgets/speedbar.gadget',speedbarbase)
  self.addLibrary('gadgets/string.gadget',stringbase)
  self.addLibrary('gadgets/tapedeck.gadget',tapedeckbase)
  self.addLibrary('gadgets/texteditor.gadget',texteditorbase)
  self.addLibrary('gadgets/textfield.gadget',textfieldbase)
  self.addLibrary('gadgets/virtual.gadget',virtualbase)
  self.addLibrary('images/bevel.image',bevelbase)
  self.addLibrary('images/bitmap.image',bitmapbase)
  self.addLibrary('images/boingball.image',boingballbase)
  self.addLibrary('images/drawlist.image',drawlistbase)
  self.addLibrary('images/glyph.image',glyphbase)
  self.addLibrary('images/label.image',labelbase)
  self.addLibrary('images/led.image',ledbase)
  self.addLibrary('images/penmap.image',penmapbase)
  self.addLibrary('gadtools.library',gadtoolsbase)
  self.addLibrary('requester.class',requesterbase)
  self.addLibrary('window.class',windowbase)
  
  self.addLibrary('gadgets/statusbar.gadget',statusbarbase)
  self.addLibrary('gadgets/progress.gadget',progressbase)
  self.addLibrary('gadgets/textentry.gadget',textentrybase)
  self.addLibrary('images/smartbitmap.image',smartbitmapbase)
  self.addLibrary('images/titlebar.image',titlebarbase)
  

  SetGadgetAttrsA(self.gadgetList[LIBS_LIST],0,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])

  self.showModal()
ENDPROC -1
