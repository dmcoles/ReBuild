
OPT MODULE

  MODULE '*fileStreamer','*sourceGen','*reactionObject','*menuObject','*stringlist'

EXPORT OBJECT eSrcGen OF srcGen
ENDOBJECT

PROC create(fser:PTR TO fileStreamer,libsused) OF eSrcGen
  SUPER self.create(fser,libsused)
  self.type:=ESOURCE_GEN
  self.stringDelimiter:=39
  self.upperCaseProperties:=TRUE
  AstrCopy(self.assignChars,':=')
  self.extraPadding:=FALSE
  self.indent:=0
  self.terminator:=0
ENDPROC

PROC genHeader(count,menuObject:PTR TO menuObject) OF eSrcGen
  DEF tempStr[200]:STRING
  DEF i
  DEF menuItem:PTR TO menuItem
  DEF itemType
  DEF itemName[200]:STRING
  DEF commKey[10]:STRING
  self.writeLine('OPT OSVERSION=37')
  self.writeLine('')
  self.writeLine('  MODULE \areaction/reaction_macros\a,')
  self.writeLine('      \areaction/reaction_lib\a,')
  self.writeLine('      \awindow\a,\aclasses/window\a,')
  self.writeLine('      \agadgets/layout\a,\alayout\a,')
  IF menuObject.menuItems.count()>0 THEN self.writeLine('      \alibraries/gadtools\a,\agadtools\a,')
  IF self.libsused AND LIB_BUTTON THEN self.writeLine('      \abutton\a,\agadgets/button\a,')
  IF self.libsused AND LIB_CHECKBOX THEN self.writeLine('      \acheckbox\a,\agadgets/checkbox\a,')
  IF self.libsused AND LIB_CHOOSER THEN self.writeLine('      \achooser\a,\agadgets/chooser\a,')
  IF self.libsused AND LIB_CLICKTAB THEN self.writeLine('      \aclicktab\a,\agadgets/clicktab\a,')
  IF self.libsused AND LIB_FUELGAUGE THEN self.writeLine('      \afuelgauge\a,\agadgets/fuelgauge\a,')
  IF self.libsused AND LIB_GETFILE THEN self.writeLine('      \agetfile\a,\agadgets/getfile\a,')
  IF self.libsused AND LIB_GETFONT THEN self.writeLine('      \agetfont\a,\agadgets/getfont\a,')
  IF self.libsused AND LIB_GETSCREEN THEN self.writeLine('      \agetscreenmode\a,\agadgets/getscreenmode\a,')
  IF self.libsused AND LIB_INTEGER THEN self.writeLine('      \ainteger\a,\agadgets/integer\a,')
  IF self.libsused AND LIB_PALETTE THEN self.writeLine('      \apalette\a,\agadgets/palette\a,')
  IF self.libsused AND LIB_LISTB THEN self.writeLine('      \alistbrowser\a,\agadgets/listbrowser\a,')
  IF self.libsused AND LIB_RADIO THEN self.writeLine('      \aradiobutton\a,\agadgets/radiobutton\a,')
  IF self.libsused AND LIB_SCROLLER THEN self.writeLine('      \ascroller\a,\agadgets/scroller\a,')
  IF self.libsused AND LIB_STRING THEN self.writeLine('      \astring\a,\agadgets/string\a,')
  IF self.libsused AND LIB_SPACE THEN self.writeLine('      \aspace\a,')
  IF self.libsused AND LIB_TEXTFIELD THEN self.writeLine('      \atextfield\a,\agadgets/textfield\a,')
  IF self.libsused AND LIB_BEVEL THEN self.writeLine('      \abevel\a,')
  IF self.libsused AND LIB_DRAWLIST THEN self.writeLine('      \adrawlist\a,\aimages/drawlist\a,')
  IF self.libsused AND LIB_GLYPH THEN self.writeLine('      \aglyph\a,\aimages/glyph\a,')
  IF self.libsused AND LIB_LABEL THEN self.writeLine('      \alabel\a,\aimages/label\a,')
  self.writeLine('      \aimages/bevel\a,')
  self.writeLine('      \aamigalib/boopsi\a,')
  self.writeLine('      \aexec\a,')
  self.writeLine('      \aintuition/intuition\a,')
  self.writeLine('      \aintuition/imageclass\a,')
  self.writeLine('      \aintuition/gadgetclass\a')
  self.writeLine('')
  
  self.writeLine('PROC openClasses()')
  self.writeLine('  IF (windowbase:=OpenLibrary(\awindow.class\a,0))=NIL THEN Throw(\qLIB\q,\qwin\q)')
  self.writeLine('  IF (layoutbase:=OpenLibrary(\agadgets/layout.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qlayo\q)')
  IF self.libsused AND LIB_BUTTON THEN self.writeLine('  IF (buttonbase:=OpenLibrary(\agadgets/button.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qbtn\q)')
  IF self.libsused AND LIB_CHECKBOX THEN self.writeLine('  IF (checkboxbase:=OpenLibrary(\agadgets/checkbox.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qchkb\q)')
  IF self.libsused AND LIB_CHOOSER THEN self.writeLine('  IF (chooserbase:=OpenLibrary(\agadgets/chooser.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qchoo\q)')
  IF self.libsused AND LIB_CLICKTAB THEN self.writeLine('  IF (clicktabbase:=OpenLibrary(\agadgets/clicktab.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qclkt\q)')
  IF self.libsused AND LIB_FUELGAUGE THEN self.writeLine('  IF (fuelgaugebase:=OpenLibrary(\agadgets/fuelgauge.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qfuel\q)')
  IF self.libsused AND LIB_GETFILE THEN self.writeLine('  IF (getfilebase:=OpenLibrary(\agadgets/getfile.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qfile\q)')
  IF self.libsused AND LIB_GETFONT THEN self.writeLine('  IF (getfontbase:=OpenLibrary(\agadgets/getfont.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qfont\q)')
  IF self.libsused AND LIB_GETSCREEN THEN self.writeLine('  IF (getscreenmodebase:=OpenLibrary(\agadgets/getscreenmode.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qscrn\q)')
  IF self.libsused AND LIB_INTEGER THEN self.writeLine('  IF (integerbase:=OpenLibrary(\agadgets/integer.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qintr\q)')
  IF self.libsused AND LIB_PALETTE THEN self.writeLine('  IF (palettebase:=OpenLibrary(\agadgets/palette.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qpall\q)')
  IF self.libsused AND LIB_LISTB THEN self.writeLine('  IF (listbrowserbase:=OpenLibrary(\agadgets/listbrowser.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qlist\q)')
  IF self.libsused AND LIB_RADIO THEN self.writeLine('  IF (radiobuttonbase:=OpenLibrary(\agadgets/radiobutton.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qrbtn\q)')
  IF self.libsused AND LIB_SCROLLER THEN self.writeLine('  IF (scrollerbase:=OpenLibrary(\agadgets/scroller.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qscrl\q)')
  IF self.libsused AND LIB_STRING THEN self.writeLine('  IF (stringbase:=OpenLibrary(\agadgets/string.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qstrn\q)')
  IF self.libsused AND LIB_SPACE THEN self.writeLine('  IF (spacebase:=OpenLibrary(\agadgets/space.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qspce\q)')
  IF self.libsused AND LIB_TEXTFIELD THEN self.writeLine('  IF (textfieldbase:=OpenLibrary(\agadgets/textfield.gadget\a,0))=NIL THEN Throw(\qLIB\q,\qtext\q)')
  IF self.libsused AND LIB_BEVEL THEN self.writeLine('  IF (bevelbase:=OpenLibrary(\aimages/bevel.image\a,0))=NIL THEN Throw(\qLIB\q,\qbevl\q)')
  IF self.libsused AND LIB_DRAWLIST THEN self.writeLine('  IF (drawlistbase:=OpenLibrary(\aimages/drawlist.image\a,0))=NIL THEN Throw(\qLIB\q,\qdraw\q)')
  IF self.libsused AND LIB_GLYPH THEN self.writeLine('  IF (glyphbase:=OpenLibrary(\aimages/glyph.image\a,0))=NIL THEN Throw(\qLIB\q,\qglyp\q)')
  IF self.libsused AND LIB_LABEL THEN self.writeLine('  IF (labelbase:=OpenLibrary(\aimages/label.image\a,0))=NIL THEN Throw(\qLIB\q,\qlabl\q)')
  IF menuObject.menuItems.count()>0 THEN self.writeLine('  IF (gadtoolsbase:=OpenLibrary(\agadtools.library\a,0))=NIL THEN Throw(\qLIB\q,\qgadt\q)')

  self.writeLine('ENDPROC')
  self.writeLine('')
  self.writeLine('PROC closeClasses()')
  self.writeLine('  IF windowbase THEN CloseLibrary(windowbase)')
  self.writeLine('  IF layoutbase THEN CloseLibrary(layoutbase)')
  IF self.libsused AND LIB_BUTTON THEN self.writeLine('  IF buttonbase THEN CloseLibrary(buttonbase)')
  IF self.libsused AND LIB_CHECKBOX THEN self.writeLine('  IF checkboxbase THEN CloseLibrary(checkboxbase)')
  IF self.libsused AND LIB_CHOOSER THEN self.writeLine('  IF chooserbase THEN CloseLibrary(chooserbase)')
  IF self.libsused AND LIB_CLICKTAB THEN self.writeLine('  IF clicktabbase THEN CloseLibrary(clicktabbase)')
  IF self.libsused AND LIB_FUELGAUGE THEN self.writeLine('  IF fuelgaugebase THEN CloseLibrary(fuelgaugebase)')
  IF self.libsused AND LIB_GETFILE THEN self.writeLine('  IF getfilebase THEN CloseLibrary(getfilebase)')
  IF self.libsused AND LIB_GETFONT THEN self.writeLine('  IF getfontbase THEN CloseLibrary(getfontbase)')
  IF self.libsused AND LIB_GETSCREEN THEN self.writeLine('  IF getscreenmodebase THEN CloseLibrary(getscreenmodebase)')
  IF self.libsused AND LIB_INTEGER THEN self.writeLine('  IF integerbase THEN CloseLibrary(integerbase)')
  IF self.libsused AND LIB_PALETTE THEN self.writeLine('  IF palettebase THEN CloseLibrary(palettebase)')
  IF self.libsused AND LIB_LISTB THEN self.writeLine('  IF listbrowserbase THEN CloseLibrary(listbrowserbase)')
  IF self.libsused AND LIB_RADIO THEN self.writeLine('  IF radiobuttonbase THEN CloseLibrary(radiobuttonbase)')
  IF self.libsused AND LIB_SCROLLER THEN self.writeLine('  IF scrollerbase THEN CloseLibrary(scrollerbase)')
  IF self.libsused AND LIB_STRING THEN self.writeLine('  IF stringbase THEN CloseLibrary(stringbase)')
  IF self.libsused AND LIB_SPACE THEN self.writeLine('  IF spacebase THEN CloseLibrary(spacebase)')
  IF self.libsused AND LIB_TEXTFIELD THEN self.writeLine('  IF textfieldbase THEN CloseLibrary(textfieldbase)')
  IF self.libsused AND LIB_BEVEL THEN self.writeLine('  IF bevelbase THEN CloseLibrary(bevelbase)')
  IF self.libsused AND LIB_DRAWLIST THEN self.writeLine('  IF drawlistbase THEN CloseLibrary(drawlistbase)')
  IF self.libsused AND LIB_GLYPH THEN self.writeLine('  IF glyphbase THEN CloseLibrary(glyphbase)')
  IF self.libsused AND LIB_LABEL THEN self.writeLine('  IF labelbase THEN CloseLibrary(labelbase)')
  IF menuObject.menuItems.count()>0 THEN self.writeLine('  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)')
  self.writeLine('ENDPROC')
  self.writeLine('')
  
  self.writeLine('PROC main() HANDLE')
  self.writeLine('  DEF running=TRUE')
  self.writeLine('  DEF window_object=0')
  self.writeLine('  DEF app_port=0')

  StringF(tempStr,'  DEF main_gadgets[\d]:ARRAY OF LONG',count)
  self.writeLine(tempStr)
  IF menuObject.menuItems.count()>0
    self.writeLine('  DEF menuStrip=0,menuData=0:PTR TO newmenu,scr=0,visInfo=0')
  ENDIF
  self.writeLine('  DEF win:PTR TO window,wsig,code,msg,sig,result')
  self.writeLine('')
  self.writeLine('  openClasses()')
  self.writeLine('  IF (app_port:=CreateMsgPort())=NIL THEN Raise(\qport\q)')
  self.writeLine('')
  IF menuObject.menuItems.count()>0
    StringF(tempStr,'  NEW menuData[\d]',menuObject.menuItems.count()+1)
    self.writeLine(tempStr)
    

    FOR i:=0 TO menuObject.menuItems.count()-1
      menuItem:=menuObject.menuItems.item(i)
      StrCopy(commKey,'')
      IF menuItem.menuItem 
        itemType:='NM_ITEM'
        StringF(itemName,'\a\s\a',menuItem.itemName)
        IF StrLen(menuItem.commKey) THEN StringF(commKey,'\a\s\a',menuItem.commKey)
      ELSEIF menuItem.menuBar
        itemType:='NM_ITEM'
        StrCopy(itemName,'NM_BARLABEL')
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
    self.writeLine('  IF (scr:=LockPubScreen(NIL))=NIL THEN Raise(\qpub\q)')
    self.writeLine('  IF (visInfo:=GetVisualInfoA(scr, [TAG_END]))=NIL THEN Raise(\qvisi\q)')
    self.writeLine('  LayoutMenusA(menuStrip,visInfo,[GTMN_NEWLOOKMENUS,TRUE,TAG_END])')
    StringF(tempStr,'  END menuData[\d]',menuObject.menuItems.count()+1)
    self.writeLine(tempStr)
    self.writeLine('  menuData:=0')
    self.writeLine('')
  ENDIF
  self.indent:=2
ENDPROC

PROC genFooter(count, menuObject:PTR TO menuObject) OF eSrcGen
  DEF tempStr[200]:STRING
  self.indent:=0
  self.writeLine('')
  self.writeLine('  IF (win:=RA_OpenWindow(window_object))')
  self.writeLine('    GetAttr( WINDOW_SIGMASK, window_object, {wsig} )')
  IF menuObject.menuItems.count()>0
    self.writeLine('    SetMenuStrip( win, menuStrip )')
  ENDIF
  self.writeLine('')
  self.writeLine('    WHILE running')
  self.writeLine('      sig:=Wait(wsig)')
  self.writeLine('      IF (sig AND (wsig))')
  self.writeLine('        WHILE ((result:=RA_HandleInput(window_object,{code})) <> WMHI_LASTMSG)')
  self.writeLine('          msg:=(result AND WMHI_CLASSMASK)')
  self.writeLine('          SELECT msg')
  self.writeLine('            CASE WMHI_GADGETUP')
  self.writeLine('              ->handle gadget press')
  self.writeLine('            CASE WMHI_CLOSEWINDOW')
  self.writeLine('              running:=FALSE')
  self.writeLine('            CASE WMHI_MENUPICK')
  self.writeLine('              ->handle menu item')
  self.writeLine('            CASE WMHI_ICONIFY')
  self.writeLine('              RA_Iconify(window_object)')
  self.writeLine('            CASE WMHI_UNICONIFY')
  self.writeLine('              win:=RA_OpenWindow(window_object)')
  self.writeLine('          ENDSELECT')
  self.writeLine('        ENDWHILE')
  self.writeLine('      ENDIF')
  self.writeLine('    ENDWHILE')
  self.writeLine('    RA_CloseWindow(window_object)')
  self.writeLine('  ENDIF')
  self.writeLine('')
  self.writeLine('EXCEPT DO')
  self.writeLine('  IF window_object THEN DisposeObject(window_object);')
  self.writeLine('  IF app_port  THEN DeleteMsgPort(app_port)')
  IF menuObject.menuItems.count()>0
    self.writeLine('  IF menuStrip THEN FreeMenus( menuStrip )')
    self.writeLine('  IF visInfo THEN FreeVisualInfo(visInfo)')
    self.writeLine('  IF scr THEN UnlockPubScreen(NIL,scr)')
    StringF(tempStr,'  IF menuData THEN END menuData[\d]',menuObject.menuItems.count()+1)
    self.writeLine(tempStr)
  ENDIF
  self.writeLine('  closeClasses()')
  self.writeLine('ENDPROC')
ENDPROC

PROC assignWindowVar() OF eSrcGen
  self.genIndent()
  self.write('window_object:=')
ENDPROC

PROC assignGadgetVar(index) OF eSrcGen
  DEF tempStr[100]:STRING
  StringF(tempStr,'main_gadgets[\d]:=',index)
  self.write(tempStr)
ENDPROC
