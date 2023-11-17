OPT MODULE,LARGE

  MODULE 'images/drawlist'
  MODULE '*fileStreamer','*sourceGen','*reactionObject','*menuObject','*windowObject','*stringlist','*screenObject'
  MODULE '*chooserObject','*clickTabObject','*radioObject','*listBrowserObject',
         '*reactionListObject','*reactionLists','*drawlistObject','*speedBarObject','*listViewObject'

EXPORT OBJECT eSrcGen OF srcGen
ENDOBJECT

PROC create(fser:PTR TO fileStreamer,libsused) OF eSrcGen
  SUPER self.create(fser,libsused)
  self.type:=ESOURCE_GEN
  self.stringDelimiter:=39
  self.orOperator:='OR'
  self.upperCaseProperties:=TRUE
  AstrCopy(self.assignChars,':=')
  self.extraPadding:=FALSE
  self.indent:=0
  self.terminator:=0
ENDPROC

PROC genHeader(screenObject:PTR TO screenObject) OF eSrcGen
  DEF tempStr[200]:STRING
  self.writeLine('OPT OSVERSION=37')
  self.writeLine('')
  self.writeLine('  MODULE \areaction/reaction_macros\a,')
  self.writeLine('      \areaction/reaction_lib\a,')
  self.writeLine('      \awindow\a,\aclasses/window\a,')
  self.writeLine('      \agadgets/layout\a,\alayout\a,')
  self.writeLine('      \alibraries/gadtools\a,\agadtools\a,')
  IF self.libsused[TYPE_BUTTON] THEN self.writeLine('      \abutton\a,\agadgets/button\a,')
  IF self.libsused[TYPE_CHECKBOX] THEN self.writeLine('      \acheckbox\a,\agadgets/checkbox\a,')
  IF self.libsused[TYPE_CHOOSER] THEN self.writeLine('      \achooser\a,\agadgets/chooser\a,')
  IF self.libsused[TYPE_CLICKTAB] THEN self.writeLine('      \aclicktab\a,\agadgets/clicktab\a,')
  IF self.libsused[TYPE_FUELGAUGE] THEN self.writeLine('      \afuelgauge\a,\agadgets/fuelgauge\a,')
  IF self.libsused[TYPE_GETFILE] THEN self.writeLine('      \agetfile\a,\agadgets/getfile\a,')
  IF self.libsused[TYPE_GETFONT] THEN self.writeLine('      \agetfont\a,\agadgets/getfont\a,')
  IF self.libsused[TYPE_GETSCREENMODE] THEN self.writeLine('      \agetscreenmode\a,\agadgets/getscreenmode\a,')
  IF self.libsused[TYPE_INTEGER] THEN self.writeLine('      \ainteger\a,\agadgets/integer\a,')
  IF self.libsused[TYPE_PALETTE] THEN self.writeLine('      \apalette\a,\agadgets/palette\a,')
  IF self.libsused[TYPE_LISTBROWSER] THEN self.writeLine('      \alistbrowser\a,\agadgets/listbrowser\a,')
  IF self.libsused[TYPE_RADIO] THEN self.writeLine('      \aradiobutton\a,\agadgets/radiobutton\a,')
  IF self.libsused[TYPE_SCROLLER] THEN self.writeLine('      \ascroller\a,\agadgets/scroller\a,')
  IF self.libsused[TYPE_STRING] THEN self.writeLine('      \astring\a,\agadgets/string\a,')
  IF self.libsused[TYPE_SPACE] THEN self.writeLine('      \aspace\a,')
  IF self.libsused[TYPE_SPEEDBAR] THEN self.writeLine('      \aspeedbar\a,\agadgets/speedbar\a,')
  IF self.libsused[TYPE_TEXTFIELD] THEN self.writeLine('      \atextfield\a,\agadgets/textfield\a,')
  IF self.libsused[TYPE_BEVEL] THEN self.writeLine('      \abevel\a,')
  IF self.libsused[TYPE_DRAWLIST] THEN self.writeLine('      \adrawlist\a,\aimages/drawlist\a,')
  IF self.libsused[TYPE_GLYPH] THEN self.writeLine('      \aglyph\a,\aimages/glyph\a,')
  IF self.libsused[TYPE_LABEL] THEN self.writeLine('      \alabel\a,\aimages/label\a,')
  IF (self.libsused[TYPE_BOINGBALL] OR self.libsused[TYPE_PENMAP]) THEN self.writeLine('      \aimages/penmap\a,')
  IF self.libsused[TYPE_COLORWHEEL]  THEN self.writeLine('      \acolorwheel\a,\agadgets/colorwheel\a,')
  IF self.libsused[TYPE_DATEBROWSER]  THEN self.writeLine('      \adatebrowser\a,\agadgets/datebrowser\a,')
  IF self.libsused[TYPE_GETCOLOR]  THEN self.writeLine('      \agetcolor\a,\agadgets/getcolor\a,')
  IF self.libsused[TYPE_GRADSLIDER]  THEN self.writeLine('      \agadgets/gradientslider\a,')
  IF self.libsused[TYPE_TAPEDECK]  THEN self.writeLine('      \agadgets/tapedeck\a,')
  IF self.libsused[TYPE_TEXTEDITOR]  THEN self.writeLine('      \agadgets/texteditor\a,\atexteditor\a,')
  IF self.libsused[TYPE_LED]  THEN self.writeLine('      \aimages/led\a,')
  IF self.libsused[TYPE_LISTVIEW]  THEN self.writeLine('      \agadgets/listview\a,\alistview\a,')
  IF self.libsused[TYPE_VIRTUAL]  THEN self.writeLine('      \agadgets/virtual\a,\avirtual\a,')
  IF self.libsused[TYPE_SKETCH]  THEN self.writeLine('      \agadgets/sketchboard\a,\asketchboard\a,')
  self.writeLine('      \aimages/bevel\a,')
  self.writeLine('      \aamigalib/boopsi\a,')
  self.writeLine('      \aexec\a,')
  IF self.libsused[TYPE_SPEEDBAR] OR  self.libsused[TYPE_LISTVIEW]
    self.writeLine('      \aexec/lists\a,\aexec/nodes\a,')
    self.writeLine('      \aexec/memory\a,')
    self.writeLine('      \aamigalib/lists\a,')
  ENDIF
  self.writeLine('      \aintuition/intuition\a,')
  self.writeLine('      \aintuition/imageclass\a,')
  self.writeLine('      \aintuition/screens\a,')
  IF (screenObject.custom)
    self.writeLine('      \agraphics/modeid\a,')
  ENDIF
  self.writeLine('      \aintuition/gadgetclass\a')
  self.writeLine('')

  IF self.libsused[TYPE_GRADSLIDER]
    self.writeLine('DEF gradientsliderbase')
  ENDIF
  IF self.libsused[TYPE_TAPEDECK]
    self.writeLine('DEF tapedeckbase')
  ENDIF
  IF self.libsused[TYPE_LED]
    self.writeLine('DEF ledbase')
  ENDIF
  
  self.writeLine('DEF gScreen=0,gVisInfo=0,gDrawInfo=0,gAppPort=0')
  self.writeLine('')
  
  self.writeLine('PROC setup()')
  self.writeLine('  IF (windowbase:=OpenLibrary(\awindow.class\a,0))=NIL THEN Throw(\qLIB\q,\qwin\q)')
  self.writeLine('  IF (layoutbase:=OpenLibrary(\agadgets/layout.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qlayo\q)')
  self.writeLine('  IF (gadtoolsbase:=OpenLibrary(\agadtools.library\a,0))=NIL THEN Throw(\qLIB\q,\qgadt\q)')

  IF self.libsused[TYPE_BUTTON] THEN self.writeLine('  IF (buttonbase:=OpenLibrary(\agadgets/button.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qbtn\q)')
  IF self.libsused[TYPE_CHECKBOX] THEN self.writeLine('  IF (checkboxbase:=OpenLibrary(\agadgets/checkbox.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qchkb\q)')
  IF self.libsused[TYPE_CHOOSER] THEN self.writeLine('  IF (chooserbase:=OpenLibrary(\agadgets/chooser.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qchoo\q)')
  IF self.libsused[TYPE_CLICKTAB] THEN self.writeLine('  IF (clicktabbase:=OpenLibrary(\agadgets/clicktab.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qclkt\q)')
  IF self.libsused[TYPE_FUELGAUGE] THEN self.writeLine('  IF (fuelgaugebase:=OpenLibrary(\agadgets/fuelgauge.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qfuel\q)')
  IF self.libsused[TYPE_GETFILE] THEN self.writeLine('  IF (getfilebase:=OpenLibrary(\agadgets/getfile.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qfile\q)')
  IF self.libsused[TYPE_GETFONT] THEN self.writeLine('  IF (getfontbase:=OpenLibrary(\agadgets/getfont.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qfont\q)')
  IF self.libsused[TYPE_GETSCREENMODE] THEN self.writeLine('  IF (getscreenmodebase:=OpenLibrary(\agadgets/getscreenmode.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qscrn\q)')
  IF self.libsused[TYPE_INTEGER] THEN self.writeLine('  IF (integerbase:=OpenLibrary(\agadgets/integer.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qintr\q)')
  IF self.libsused[TYPE_PALETTE] THEN self.writeLine('  IF (palettebase:=OpenLibrary(\agadgets/palette.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qpall\q)')
  IF self.libsused[TYPE_LISTBROWSER] THEN self.writeLine('  IF (listbrowserbase:=OpenLibrary(\agadgets/listbrowser.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qlist\q)')
  IF self.libsused[TYPE_RADIO] THEN self.writeLine('  IF (radiobuttonbase:=OpenLibrary(\agadgets/radiobutton.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qrbtn\q)')
  IF self.libsused[TYPE_SCROLLER] THEN self.writeLine('  IF (scrollerbase:=OpenLibrary(\agadgets/scroller.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qscrl\q)')
  IF self.libsused[TYPE_SPEEDBAR] THEN self.writeLine('  IF (speedbarbase:=OpenLibrary(\agadgets/speedbar.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qspdb\q)')
  IF self.libsused[TYPE_STRING] THEN self.writeLine('  IF (stringbase:=OpenLibrary(\agadgets/string.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qstrn\q)')
  IF self.libsused[TYPE_SPACE] THEN self.writeLine('  IF (spacebase:=OpenLibrary(\agadgets/space.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qspce\q)')
  IF self.libsused[TYPE_TEXTFIELD] THEN self.writeLine('  IF (textfieldbase:=OpenLibrary(\agadgets/textfield.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qtext\q)')
  IF self.libsused[TYPE_BEVEL] THEN self.writeLine('  IF (bevelbase:=OpenLibrary(\aimages/bevel.image\a,0))=NIL THEN Throw(\qLIB\q,\qbevl\q)')
  IF self.libsused[TYPE_DRAWLIST] THEN self.writeLine('  IF (drawlistbase:=OpenLibrary(\aimages/drawlist.image\a,0))=NIL THEN Throw(\qLIB\q,\qdraw\q)')
  IF self.libsused[TYPE_GLYPH] THEN self.writeLine('  IF (glyphbase:=OpenLibrary(\aimages/glyph.image\a,0))=NIL THEN Throw(\qLIB\q,\qglyp\q)')
  IF self.libsused[TYPE_LABEL] THEN self.writeLine('  IF (labelbase:=OpenLibrary(\aimages/label.image\a,0))=NIL THEN Throw(\qLIB\q,\qlabl\q)')
  IF self.libsused[TYPE_PENMAP] THEN self.writeLine('  IF (penmapbase:=OpenLibrary(\aimages/penmap.image\a,0))=NIL THEN Throw(\qLIB\q,\qpenm\q)')
  IF self.libsused[TYPE_COLORWHEEL] THEN self.writeLine('  IF (colorwheelbase:=OpenLibrary(\agadgets/colorwheel.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qcwhe\q)')
  IF self.libsused[TYPE_DATEBROWSER] THEN self.writeLine('  IF (datebrowserbase:=OpenLibrary(\agadgets/datebrowser.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qdbro\q)')
  IF self.libsused[TYPE_GETCOLOR] THEN self.writeLine('  IF (getcolorbase:=OpenLibrary(\agadgets/getcolor.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qgcol\q)')
  IF self.libsused[TYPE_GRADSLIDER] THEN self.writeLine('  IF (gradientsliderbase:=OpenLibrary(\agadgets/gradientslider.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qgsld\q)')
  IF self.libsused[TYPE_TAPEDECK] THEN self.writeLine('  IF (tapedeckbase:=OpenLibrary(\agadgets/tapedeck.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qtape\q)')
  IF self.libsused[TYPE_TEXTEDITOR] THEN self.writeLine('  IF (textfieldbase:=OpenLibrary(\agadgets/texteditor.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qtext\q)')
  IF self.libsused[TYPE_LED] THEN self.writeLine('  IF (ledbase:=OpenLibrary(\aimages/led.image\a,0))=NIL THEN Throw(\qLIB\q,\qed\q)')
  IF self.libsused[TYPE_LISTVIEW] THEN self.writeLine('  IF (listviewbase:=OpenLibrary(\agadgets/listview.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qlvw\q)')
  IF self.libsused[TYPE_VIRTUAL] THEN self.writeLine('  IF (virtualbase:=OpenLibrary(\agadgets/virtual.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qvirt\q)')
  IF self.libsused[TYPE_SKETCH] THEN self.writeLine('  IF (sketchboardbase:=OpenLibrary(\agadgets/sketchboard.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qskch\q)')

  self.genScreenCreate(screenObject)
  self.writeLine('  IF (gVisInfo:=GetVisualInfoA(gScreen, [TAG_END]))=NIL THEN Raise(\qvisi\q)')
  self.writeLine('  IF (gDrawInfo:=GetScreenDrawInfo(gScreen))=NIL THEN Raise("dinf")')
  self.writeLine('  IF (gAppPort:=CreateMsgPort())=NIL THEN Raise(\qport\q)')
  self.writeLine('ENDPROC')
  self.writeLine('')
  self.writeLine('PROC cleanup()')
  self.writeLine('  IF gVisInfo THEN FreeVisualInfo(gVisInfo)')
  self.writeLine('  IF gDrawInfo THEN FreeScreenDrawInfo(gScreen,gDrawInfo)')
  self.writeLine('  IF gAppPort THEN DeleteMsgPort(gAppPort)')
  self.genScreenFree(screenObject)
  self.writeLine('')
  self.writeLine('  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)')
  self.writeLine('  IF windowbase THEN CloseLibrary(windowbase)')
  self.writeLine('  IF layoutbase THEN CloseLibrary(layoutbase)')
  IF self.libsused[TYPE_BUTTON] THEN self.writeLine('  IF buttonbase THEN CloseLibrary(buttonbase)')
  IF self.libsused[TYPE_CHECKBOX] THEN self.writeLine('  IF checkboxbase THEN CloseLibrary(checkboxbase)')
  IF self.libsused[TYPE_CHOOSER] THEN self.writeLine('  IF chooserbase THEN CloseLibrary(chooserbase)')
  IF self.libsused[TYPE_CLICKTAB] THEN self.writeLine('  IF clicktabbase THEN CloseLibrary(clicktabbase)')
  IF self.libsused[TYPE_FUELGAUGE] THEN self.writeLine('  IF fuelgaugebase THEN CloseLibrary(fuelgaugebase)')
  IF self.libsused[TYPE_GETFILE] THEN self.writeLine('  IF getfilebase THEN CloseLibrary(getfilebase)')
  IF self.libsused[TYPE_GETFONT] THEN self.writeLine('  IF getfontbase THEN CloseLibrary(getfontbase)')
  IF self.libsused[TYPE_GETSCREENMODE] THEN self.writeLine('  IF getscreenmodebase THEN CloseLibrary(getscreenmodebase)')
  IF self.libsused[TYPE_INTEGER] THEN self.writeLine('  IF integerbase THEN CloseLibrary(integerbase)')
  IF self.libsused[TYPE_PALETTE] THEN self.writeLine('  IF palettebase THEN CloseLibrary(palettebase)')
  IF self.libsused[TYPE_LISTBROWSER] THEN self.writeLine('  IF listbrowserbase THEN CloseLibrary(listbrowserbase)')
  IF self.libsused[TYPE_RADIO] THEN self.writeLine('  IF radiobuttonbase THEN CloseLibrary(radiobuttonbase)')
  IF self.libsused[TYPE_SCROLLER] THEN self.writeLine('  IF scrollerbase THEN CloseLibrary(scrollerbase)')
  IF self.libsused[TYPE_SPEEDBAR] THEN self.writeLine('  IF speedbarbase THEN CloseLibrary(speedbarbase)')
  IF self.libsused[TYPE_STRING] THEN self.writeLine('  IF stringbase THEN CloseLibrary(stringbase)')
  IF self.libsused[TYPE_SPACE] THEN self.writeLine('  IF spacebase THEN CloseLibrary(spacebase)')
  IF self.libsused[TYPE_TEXTFIELD] THEN self.writeLine('  IF textfieldbase THEN CloseLibrary(textfieldbase)')
  IF self.libsused[TYPE_BEVEL] THEN self.writeLine('  IF bevelbase THEN CloseLibrary(bevelbase)')
  IF self.libsused[TYPE_DRAWLIST] THEN self.writeLine('  IF drawlistbase THEN CloseLibrary(drawlistbase)')
  IF self.libsused[TYPE_GLYPH] THEN self.writeLine('  IF glyphbase THEN CloseLibrary(glyphbase)')
  IF self.libsused[TYPE_LABEL] THEN self.writeLine('  IF labelbase THEN CloseLibrary(labelbase)')
  IF self.libsused[TYPE_PENMAP] THEN self.writeLine('  IF penmapbase THEN CloseLibrary(penmapbase)')

  IF self.libsused[TYPE_COLORWHEEL] THEN self.writeLine('  IF colorwheelbase THEN CloseLibrary(colorwheelbase)')
  IF self.libsused[TYPE_DATEBROWSER] THEN self.writeLine('  IF datebrowserbase THEN CloseLibrary(datebrowserbase)')
  IF self.libsused[TYPE_GETCOLOR] THEN self.writeLine('  IF getcolorbase THEN CloseLibrary(getcolorbase)')
  IF self.libsused[TYPE_GRADSLIDER] THEN self.writeLine('  IF gradientsliderbase THEN CloseLibrary(gradientsliderbase)')
  IF self.libsused[TYPE_TAPEDECK] THEN self.writeLine('  IF tapedeckbase THEN CloseLibrary(tapedeckbase)')
  IF self.libsused[TYPE_TEXTEDITOR] THEN self.writeLine('  IF textfieldbase THEN CloseLibrary(textfieldbase)')
  IF self.libsused[TYPE_LED] THEN self.writeLine('  IF ledbase THEN CloseLibrary(ledbase)')
  IF self.libsused[TYPE_LISTVIEW] THEN self.writeLine('  IF listviewbase THEN CloseLibrary(listviewbase)')
  IF self.libsused[TYPE_VIRTUAL] THEN self.writeLine('  IF virtualbase THEN CloseLibrary(virtualbase)')
  IF self.libsused[TYPE_SKETCH] THEN self.writeLine('  IF sketchboardbase THEN CloseLibrary(sketchboardbase)')
  self.writeLine('ENDPROC')
  self.writeLine('')

  IF self.libsused[TYPE_LISTVIEW]
    self.writeLine('PROC listViewLabelsA(text:PTR TO LONG)')
    self.writeLine('  DEF list:PTR TO lh')
    self.writeLine('  DEF node:PTR TO listlabelnode')
    self.writeLine('  DEF i=0')
    self.writeLine('')
    self.writeLine('  IF (list:=AllocMem( SIZEOF lh, MEMF_PUBLIC ))')
    self.writeLine('    newList(list)')
    self.writeLine('')
    self.writeLine('    WHILE (text[])')
    self.writeLine('      NEW node')
    self.writeLine('      IF node=0')
    self.writeLine('        freeListViewLabels(list)')
    self.writeLine('        RETURN NIL')
    self.writeLine('      ENDIF')
    self.writeLine('      node.node.type:=i')
    self.writeLine('      node.renderforeground:=1')
    self.writeLine('      node.renderbackground:=0')
    self.writeLine('      node.selectforeground:=2')
    self.writeLine('      node.selectbackground:=3')
    self.writeLine('      node.node.name:=text[]++')
    self.writeLine('      AddTail(list,node)')
    self.writeLine('    ENDWHILE')
    self.writeLine('  ENDIF')
    self.writeLine('ENDPROC list')
    self.writeLine('')
    self.writeLine('PROC freeListViewLabels(list:PTR TO lh)')
    self.writeLine('  DEF node:PTR TO listlabelnode')
    self.writeLine('  DEF nextnode:PTR TO ln')
    self.writeLine('  DEF i')
    self.writeLine('  ')
    self.writeLine('  IF list')
    self.writeLine('    node:= list.head')
    self.writeLine('   WHILE (nextnode := node.node.succ)')
    self.writeLine('      END node')
    self.writeLine('      node := nextnode')
    self.writeLine('   ENDWHILE')
    self.writeLine('   FreeMem(list,SIZEOF lh)')
    self.writeLine('  ENDIF')
    self.writeLine('ENDPROC')
    self.writeLine('')
  ENDIF

  IF self.libsused[TYPE_SPEEDBAR]
    self.writeLine('PROC speedBarNodesA(text:PTR TO LONG)')
    self.writeLine('  DEF list:PTR TO lh')
    self.writeLine('  DEF node:PTR TO ln')
    self.writeLine('  DEF label')
    self.writeLine('  DEF i=0')
    self.writeLine('')
    self.writeLine('  IF (list:=AllocMem( SIZEOF lh, MEMF_PUBLIC ))')
    self.writeLine('    newList(list)')
    self.writeLine('')
    self.writeLine('    WHILE (text[])')
    self.writeLine('      label:=LabelObject,')
    self.writeLine('          LABEL_TEXT, text[],')
    self.writeLine('          LabelEnd')
    self.writeLine('')
    self.writeLine('      IF (node:=AllocSpeedButtonNodeA(')
    self.writeLine('        i,[SBNA_IMAGE, label,')
    self.writeLine('        SBNA_ENABLED, TRUE,')
    self.writeLine('        SBNA_SPACING, 2,')
    self.writeLine('        SBNA_HIGHLIGHT, SBH_RECESS,')
    self.writeLine('        TAG_DONE]))=FALSE')
    self.writeLine('')
    self.writeLine('        freeSpeedBarNodes(list)')
    self.writeLine('        RETURN NIL')
    self.writeLine('      ENDIF')
    self.writeLine('      AddTail(list,node)')
    self.writeLine('      i++')
    self.writeLine('      text++')
    self.writeLine('    ENDWHILE')
    self.writeLine('  ENDIF')
    self.writeLine('ENDPROC list')
  
    self.writeLine('')
    self.writeLine('PROC freeSpeedBarNodes(list:PTR TO lh)')
    self.writeLine('  DEF node:PTR TO ln')
    self.writeLine('  DEF nextnode:PTR TO ln')
    self.writeLine('  DEF i,label')
    self.writeLine('')
    self.writeLine('  IF list')
    self.writeLine('    node:= list.head')
    self.writeLine('   WHILE (nextnode := node.succ)')
    self.writeLine('    GetSpeedButtonNodeAttrsA(node,[SBNA_IMAGE,{label},TAG_END])')
    self.writeLine('    DisposeObject(label)')
    self.writeLine('    FreeSpeedButtonNode(node)')
    self.writeLine('      node := nextnode')
    self.writeLine('   ENDWHILE')
    self.writeLine('   FreeMem(list,SIZEOF lh)')
    self.writeLine('  ENDIF')
    self.writeLine('ENDPROC')
    self.writeLine('')
  ENDIF

  self.writeLine('PROC runWindow(windowObject,menuStrip) HANDLE')
  self.writeLine('  DEF running=TRUE')
  self.writeLine('  DEF win:PTR TO window,wsig,code,msg,sig,result')
  self.writeLine('')
  self.writeLine('  IF (win:=RA_OpenWindow(windowObject))')
  self.writeLine('    GetAttr( WINDOW_SIGMASK, windowObject, {wsig} )')
  self.writeLine('    IF menuStrip THEN SetMenuStrip( win, menuStrip )')
  self.writeLine('')
  self.writeLine('    WHILE running')
  self.writeLine('      sig:=Wait(wsig)')
  self.writeLine('      IF (sig AND (wsig))')
  self.writeLine('        WHILE ((result:=RA_HandleInput(windowObject,{code})) <> WMHI_LASTMSG)')
  self.writeLine('          msg:=(result AND WMHI_CLASSMASK)')
  self.writeLine('          SELECT msg')
  self.writeLine('            CASE WMHI_GADGETUP')
  self.writeLine('              ->handle gadget press')
  self.writeLine('            CASE WMHI_CLOSEWINDOW')
  self.writeLine('              running:=FALSE')
  self.writeLine('            CASE WMHI_MENUPICK')
  self.writeLine('              ->handle menu item')
  self.writeLine('            CASE WMHI_ICONIFY')
  self.writeLine('              RA_Iconify(windowObject)')
  self.writeLine('            CASE WMHI_UNICONIFY')
  self.writeLine('              win:=RA_OpenWindow(windowObject)')
  self.writeLine('          ENDSELECT')
  self.writeLine('        ENDWHILE')
  self.writeLine('      ENDIF')
  self.writeLine('    ENDWHILE')
  self.writeLine('  ENDIF')
  self.writeLine('EXCEPT DO')
  self.writeLine('  RA_CloseWindow(windowObject)')
  self.writeLine('ENDPROC')
  self.writeLine('')
ENDPROC

PROC genWindowHeader(count, windowObject:PTR TO windowObject, menuObject:PTR TO menuObject, layoutObject:PTR TO reactionObject, reactionLists:PTR TO stdlist) OF eSrcGen
  DEF tempStr[200]:STRING
  DEF i,j
  DEF menuItem:PTR TO menuItem
  DEF itemType
  DEF itemName[200]:STRING
  DEF commKey[10]:STRING
  DEF directiveStr[20]:STRING
  DEF listObjects:PTR TO stdlist
  DEF listObjects2:PTR TO stdlist
  DEF listObjects3:PTR TO stdlist
  DEF reactionObject:PTR TO reactionObject
  DEF drawlistObject:PTR TO drawListObject
  DEF listbObject:PTR TO listBrowserObject
  DEF listStr
  DEF drawlist:PTR TO drawlist
  DEF colWidth
  DEF colTitle

  StrCopy(tempStr,windowObject.name)
  LowerStr(tempStr)
  self.write('PROC ')
  self.write(tempStr)
  self.writeLine('() HANDLE')
  self.writeLine('  DEF windowObject')
  StringF(tempStr,'  DEF mainGadgets[\d]:ARRAY OF LONG',count)
  self.writeLine(tempStr)
  IF menuObject.menuItems.count()>0
    self.writeLine('  DEF menuStrip=0,menuData=0:PTR TO newmenu')
  ENDIF
  
  NEW listObjects.stdlist(20)
  layoutObject.findObjectsByType(listObjects,TYPE_CHOOSER)
  layoutObject.findObjectsByType(listObjects,TYPE_RADIO)
  layoutObject.findObjectsByType(listObjects,TYPE_CLICKTAB)
  layoutObject.findObjectsByType(listObjects,TYPE_LISTBROWSER)
  layoutObject.findObjectsByType(listObjects,TYPE_SPEEDBAR)
  layoutObject.findObjectsByType(listObjects,TYPE_LISTVIEW)
  
  NEW listObjects2.stdlist(20)
  layoutObject.findObjectsByType(listObjects2,TYPE_DRAWLIST)
  
  NEW listObjects3.stdlist(20)
  layoutObject.findObjectsByType(listObjects3,TYPE_LISTBROWSER)

  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    IF reactionObject.type=TYPE_SPEEDBAR
      StringF(tempStr,'  DEF buttons\d=0',reactionObject.id)
    ELSE
      StringF(tempStr,'  DEF labels\d=0',reactionObject.id)
    ENDIF
    self.writeLine(tempStr)
  ENDFOR

  FOR i:=0 TO listObjects2.count()-1
    drawlistObject:=listObjects2.item(i)
    j:=0
    drawlist:=drawlistObject.drawItems[j]
    count:=0
    WHILE (drawlist.directive<>DLST_END)
      count++
      j++
      drawlist:=drawlistObject.drawItems[j]
    ENDWHILE

    StringF(tempStr,'  DEF dlstDrawList\d[\d]:ARRAY OF drawlist',drawlistObject.id,count+1)
    self.writeLine(tempStr)
  ENDFOR

  FOR i:=0 TO listObjects3.count()-1
    listbObject:=listObjects3.item(i)
    IF listbObject.columnTitles
      StringF(tempStr,'  DEF listBrowser\d_ci[\d]:ARRAY OF columninfo',listbObject.id,listbObject.numColumns+1)
    self.writeLine(tempStr)
    ENDIF
  ENDFOR

  self.writeLine('')
  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    SELECT reactionObject.type
      CASE TYPE_CHOOSER
        StringF(tempStr,'  labels\d:=chooserLabelsA(',reactionObject.id)
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::chooserObject.listObjectId)
      CASE TYPE_RADIO
        StringF(tempStr,'  labels\d:=radioButtonsA(',reactionObject.id)
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::radioObject.listObjectId)
      CASE TYPE_CLICKTAB
        StringF(tempStr,'  labels\d:=clickTabsA(',reactionObject.id)
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::clickTabObject.listObjectId)
      CASE TYPE_LISTBROWSER
        StringF(tempStr,'  labels\d:=browserNodesA(',reactionObject.id)
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::listBrowserObject.listObjectId)
      CASE TYPE_SPEEDBAR
        StringF(tempStr,'  buttons\d:=speedBarNodesA(',reactionObject.id)
        listStr:=self.makeList2(tempStr,reactionObject::speedBarObject.buttonList)
      CASE TYPE_LISTVIEW
        StringF(tempStr,'  labels\d:=listViewLabelsA(',reactionObject.id)
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::listViewObject.listObjectId)
    ENDSELECT
    IF listStr
      self.writeLine(listStr)
      DisposeLink(listStr)
    ELSE
      StrAdd(tempStr,'[0])')
      self.writeLine(tempStr)
    ENDIF
  ENDFOR
  END listObjects

  FOR i:=0 TO listObjects2.count()-1
    drawlistObject:=listObjects2.item(i)
    j:=0
    drawlist:=drawlistObject.drawItems[j]
    WHILE (drawlist.directive<>DLST_END)
      SELECT drawlist.directive
        CASE DLST_LINE
          StrCopy(directiveStr,'DLST_LINE')
        CASE DLST_RECT
          StrCopy(directiveStr,'DLST_RECT')
        CASE DLST_LINEPAT
          StrCopy(directiveStr,'DLST_LINEPAT')
        CASE DLST_FILLPAT
          StrCopy(directiveStr,'DLST_FILLPAT')
        CASE DLST_LINESIZE
          StrCopy(directiveStr,'DLST_LINESIZE')
        CASE DLST_AMOVE
          StrCopy(directiveStr,'DLST_AMOVE')
        CASE DLST_ADRAW
          StrCopy(directiveStr,'DLST_ADRAW')
        CASE DLST_AFILL
          StrCopy(directiveStr,'DLST_AFILL')
        CASE DLST_FILL
          StrCopy(directiveStr,'DLST_FILL')
        CASE DLST_ELLIPSE
          StrCopy(directiveStr,'DLST_ELLIPSE')
        CASE DLST_CIRCLE
          StrCopy(directiveStr,'DLST_CIRCLE')
      ENDSELECT
      StringF(tempStr,'  dlstDrawList\d[\d].directive:=\s',drawlistObject.id,j,directiveStr)
      self.writeLine(tempStr)
      StringF(tempStr,'  dlstDrawList\d[\d].x1:=\d',drawlistObject.id,j,drawlist.x1)
      self.writeLine(tempStr)
      StringF(tempStr,'  dlstDrawList\d[\d].y1:=\d',drawlistObject.id,j,drawlist.y1)
      self.writeLine(tempStr)
      StringF(tempStr,'  dlstDrawList\d[\d].x2:=\d',drawlistObject.id,j,drawlist.x2)
      self.writeLine(tempStr)
      StringF(tempStr,'  dlstDrawList\d[\d].y2:=\d',drawlistObject.id,j,drawlist.y2)
      self.writeLine(tempStr)
      StringF(tempStr,'  dlstDrawList\d[\d].pen:=\d',drawlistObject.id,j,drawlist.pen)
      self.writeLine(tempStr)
      j++
      drawlist:=drawlistObject.drawItems[j]
    ENDWHILE
    StringF(tempStr,'  dlstDrawList\d[\d].directive:=DLST_END',drawlistObject.id,j)
    self.writeLine(tempStr)
    StringF(tempStr,'  dlstDrawList\d[\d].x1:=0',drawlistObject.id,j)
    self.writeLine(tempStr)
    StringF(tempStr,'  dlstDrawList\d[\d].y1:=0',drawlistObject.id,j)
    self.writeLine(tempStr)
    StringF(tempStr,'  dlstDrawList\d[\d].x2:=0',drawlistObject.id,j)
    self.writeLine(tempStr)
    StringF(tempStr,'  dlstDrawList\d[\d].y2:=0',drawlistObject.id,j)
    self.writeLine(tempStr)
    StringF(tempStr,'  dlstDrawList\d[\d].pen:=0',drawlistObject.id,j)
    self.writeLine('')
  ENDFOR
  END listObjects2

  FOR i:=0 TO listObjects3.count()-1
    listbObject:=listObjects3.item(i)
    IF listbObject.columnTitles
      FOR j:=0 TO listbObject.numColumns-1
        colWidth:=IF j<listbObject.colWidths.count() THEN listbObject.colWidths.item(j) ELSE 1
        colTitle:=IF j<listbObject.colTitles.count() THEN listbObject.colTitles.item(j) ELSE ''
        
        StringF(tempStr,'  listBrowser\d_ci[\d].width:=\d',listbObject.id,j,colWidth)
        self.writeLine(tempStr)
        StringF(tempStr,'  listBrowser\d_ci[\d].title:=\a\s\a',listbObject.id,j,colTitle)
        self.writeLine(tempStr)
        StringF(tempStr,'  listBrowser\d_ci[\d].flags:=CIF_WEIGHTED',listbObject.id,j)
        self.writeLine(tempStr)
      ENDFOR
      StringF(tempStr,'  listBrowser\d_ci[\d].width:=-1',listbObject.id,j)
      self.writeLine(tempStr)
      StringF(tempStr,'  listBrowser\d_ci[\d].title:=-1',listbObject.id,j)
      self.writeLine(tempStr)
      StringF(tempStr,'  listBrowser\d_ci[\d].flags:=-1',listbObject.id,j)
      self.writeLine(tempStr)
    ENDIF
  ENDFOR
  END listObjects3

  self.writeLine('')

  IF menuObject.menuItems.count()>0
    StringF(tempStr,'  NEW menuData[\d]',menuObject.menuItems.count()+1)
    self.writeLine(tempStr)

    FOR i:=0 TO menuObject.menuItems.count()-1
      menuItem:=menuObject.menuItems.item(i)
      StrCopy(commKey,'')
      IF menuItem.type=MENU_TYPE_MENUSUB
        itemType:='NM_SUB'
        IF menuItem.menuBar THEN StrCopy(itemName,'NM_BARLABEL') ELSE StringF(itemName,'\a\s\a',menuItem.itemName)

        IF StrLen(menuItem.commKey) THEN StringF(commKey,'\a\s\a',menuItem.commKey)
      ELSEIF menuItem.type=MENU_TYPE_MENUITEM
        itemType:='NM_ITEM'
        IF menuItem.menuBar THEN StrCopy(itemName,'NM_BARLABEL') ELSE StringF(itemName,'\a\s\a',menuItem.itemName)

        IF StrLen(menuItem.commKey) THEN StringF(commKey,'\a\s\a',menuItem.commKey)
      ELSE
        itemType:='NM_TITLE'
        StringF(itemName,'\a\s\a',menuItem.itemName)
      ENDIF
      StringF(tempStr,'  menuData[\d].type:=\s',i,itemType)
      self.writeLine(tempStr)
      StringF(tempStr,'  menuData[\d].label:=\s',i,itemName)
      self.writeLine(tempStr)
      IF EstrLen(commKey)>0
        StringF(tempStr,'  menuData[\d].commkey:=\s',i,commKey)
        self.writeLine(tempStr)
      ENDIF
    ENDFOR
    StringF(tempStr,'  menuData[\d].type:=NM_END',menuObject.menuItems.count())
    self.writeLine(tempStr)
    self.writeLine('')
    self.writeLine('  IF (menuStrip:=CreateMenusA( menuData, [TAG_END]))=NIL THEN Raise(\qmenu\q)')
    self.writeLine('  LayoutMenusA(menuStrip,gVisInfo,[GTMN_NEWLOOKMENUS,TRUE,TAG_END])')
    StringF(tempStr,'  END menuData[\d]',menuObject.menuItems.count()+1)
    self.writeLine(tempStr)
    self.writeLine('  menuData:=0')
    self.writeLine('')  
  ENDIF
  self.indent:=2
ENDPROC

PROC genWindowFooter(count, windowObject:PTR TO windowObject, menuObject:PTR TO menuObject, layoutObject:PTR TO reactionObject, reactionLists:PTR TO stdlist) OF eSrcGen
  DEF tempStr[200]:STRING
  DEF listObjects:PTR TO stdlist
  DEF reactionObject:PTR TO reactionObject
  DEF i

  self.writeLine('')
  IF menuObject.menuItems.count()>0
    self.writeLine('  runWindow(windowObject,menuStrip)')
  ELSE
    self.writeLine('  runWindow(windowObject,NIL)')
  ENDIF
  self.writeLine('')
  self.writeLine('EXCEPT DO')
  self.writeLine('  IF windowObject THEN DisposeObject(windowObject);')

  NEW listObjects.stdlist(20)
  layoutObject.findObjectsByType(listObjects,TYPE_CHOOSER)
  layoutObject.findObjectsByType(listObjects,TYPE_RADIO)
  layoutObject.findObjectsByType(listObjects,TYPE_CLICKTAB)
  layoutObject.findObjectsByType(listObjects,TYPE_LISTBROWSER)
  layoutObject.findObjectsByType(listObjects,TYPE_SPEEDBAR)
  layoutObject.findObjectsByType(listObjects,TYPE_LISTVIEW)
  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    SELECT reactionObject.type
      CASE TYPE_CHOOSER
        StringF(tempStr,'  IF labels\d THEN freeChooserLabels(labels\d)',reactionObject.id,reactionObject.id)
      CASE TYPE_RADIO
        StringF(tempStr,'  IF labels\d THEN freeRadioButtons(labels\d)',reactionObject.id, reactionObject.id)
      CASE TYPE_CLICKTAB
        StringF(tempStr,'  IF labels\d THEN freeClickTabs(labels\d)',reactionObject.id,reactionObject.id)
      CASE TYPE_LISTBROWSER
        StringF(tempStr,'  IF labels\d THEN freeBrowserNodes(labels\d)',reactionObject.id,reactionObject.id)
      CASE TYPE_SPEEDBAR
        StringF(tempStr,'  IF buttons\d THEN freeSpeedBarNodes(buttons\d)',reactionObject.id,reactionObject.id)
      CASE TYPE_LISTVIEW
        StringF(tempStr,'  IF labels\d THEN freeListViewLabels(labels\d)',reactionObject.id,reactionObject.id)
    ENDSELECT
    self.writeLine(tempStr)
  ENDFOR
  END listObjects

  IF menuObject.menuItems.count()>0
    self.writeLine('  IF menuData THEN  END menuData[3]')
    self.writeLine('  IF menuStrip THEN FreeMenus(menuStrip)')
  ENDIF
  self.writeLine('ENDPROC')
  self.writeLine('')
ENDPROC

PROC genFooter(windowObject:PTR TO windowObject) OF eSrcGen
  DEF tempStr[200]:STRING
  self.writeLine('PROC main() HANDLE')
  self.writeLine('  setup()')
  self.writeLine('')
  StringF(tempStr,'  \s',windowObject.name)
  LowerStr(tempStr)
  StrAdd(tempStr,'()')

  self.writeLine(tempStr)
  self.writeLine('')
  self.writeLine('EXCEPT DO')
  self.writeLine('  cleanup()')
  self.writeLine('ENDPROC')
ENDPROC

PROC assignWindowVar() OF eSrcGen
  self.genIndent()
  self.write('windowObject:=')
ENDPROC

PROC componentLibnameCreate(libname:PTR TO CHAR) OF eSrcGen
  DEF tempStr[200]:STRING
  StringF(tempStr,'NewObjectA(NIL,\a\s\a,[TAG_IGNORE,0,',libname)
  self.componentCreate(tempStr)
ENDPROC

PROC componentLibtypeCreate(libtype:PTR TO CHAR) OF eSrcGen
  DEF tempStr[200]:STRING
  StringF(tempStr,'NewObjectA(\s,NIL,[TAG_IGNORE,0,',libtype)
  self.componentCreate(tempStr)
ENDPROC

PROC genScreenCreate(screenObject:PTR TO screenObject) OF eSrcGen
  DEF tempStr[200]:STRING
  IF (screenObject.public=FALSE) AND (screenObject.custom=FALSE)
    self.writeLine('  IF (gScreen:=LockPubScreen(NIL))=NIL THEN Raise(\qpub\q)')
  ELSEIF (screenObject.public) AND (screenObject.custom=FALSE)
    StringF(tempStr,'  IF (gScreen:=LockPubScreen(\a\s\a))=NIL THEN Raise(\qpub\q)',screenObject.publicname)
    self.writeLine(tempStr)
  ELSE
    self.writeLine('  IF (gScreen:=OpenScreenTagList(NIL, [')
    self.indent:=8
    screenObject.genCodeProperties(self)
    self.indent:=0
    self.writeLine('        TAG_END]))=NIL THEN Raise(\qpub\q)')
  ENDIF
ENDPROC

PROC genScreenFree(screenObject:PTR TO screenObject) OF eSrcGen
  DEF tempStr[200]:STRING
  IF (screenObject.public=FALSE) AND (screenObject.custom=FALSE)
    self.writeLine('  IF gScreen THEN UnlockPubScreen(NIL,gScreen)')
  ELSEIF (screenObject.public) AND (screenObject.custom=FALSE)
    StringF(tempStr,'  IF gScreen THEN UnlockPubScreen(\a\s\a,gScreen)',screenObject.publicname)
    self.writeLine(tempStr)
  ELSE
    self.writeLine('  IF gScreen THEN CloseScreen(gScreen)')
  ENDIF
ENDPROC

PROC assignGadgetVar(index) OF eSrcGen
  DEF tempStr[100]:STRING
  StringF(tempStr,'mainGadgets[\d]:=',index)
  self.write(tempStr)
ENDPROC

PROC makeList(start:PTR TO CHAR,reactionLists:PTR TO stdlist, listid) OF eSrcGen
  DEF res=0
  DEF totsize=0,linelen=0
  DEF i,listitem=0:PTR TO reactionListObject
  DEF foundid=-1
 
  FOR i:=0 TO reactionLists.count()-1
    listitem:=reactionLists.item(i)
    IF listitem.id=listid THEN foundid:=i
  ENDFOR
  
  IF foundid<>-1
    totsize:=StrLen(start)
    listitem:=reactionLists.item(foundid)
    FOR i:=0 TO listitem.items.count()-1
      linelen:=linelen+EstrLen(listitem.items.item(i))+3
      IF linelen>90
        linelen:=0
        totsize:=totsize+5
      ENDIF
      totsize:=totsize+EstrLen(listitem.items.item(i))+3
    ENDFOR
    res:=String(totsize+4)
    StrCopy(res,start)
    StrAdd(res,'[')
    linelen:=0
    FOR i:=0 TO listitem.items.count()-1
      StrAdd(res,'\a')
      StrAdd(res,listitem.items.item(i))
      StrAdd(res,'\a,')
      linelen:=linelen+EstrLen(listitem.items.item(i))+3
      IF linelen>90
        linelen:=0
        StrAdd(res,'\n    ')
      ENDIF
    ENDFOR
    StrAdd(res,'0])')
  ENDIF
  
ENDPROC res

PROC makeList2(start:PTR TO CHAR,list:PTR TO stringlist) OF eSrcGen
  DEF res=0
  DEF totsize=0,linelen=0
  DEF i

  totsize:=StrLen(start)
  FOR i:=0 TO list.count()-1
    linelen:=linelen+EstrLen(list.item(i))+3
    IF linelen>90
      linelen:=0
      totsize:=totsize+5
    ENDIF
    totsize:=totsize+EstrLen(list.item(i))+3
  ENDFOR
  res:=String(totsize+4)
  StrCopy(res,start)
  StrAdd(res,'[')
  linelen:=0
  FOR i:=0 TO list.count()-1
    StrAdd(res,'\a')
    StrAdd(res,list.item(i))
    StrAdd(res,'\a,')
    linelen:=linelen+EstrLen(list.item(i))+3
    IF linelen>90
      linelen:=0
      StrAdd(res,'\n    ')
    ENDIF
  ENDFOR
  StrAdd(res,'0])')
ENDPROC res

