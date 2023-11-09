
OPT MODULE

  MODULE '*fileStreamer','*sourceGen','*reactionObject','*windowObject','*menuObject','*stringlist'
  MODULE '*chooserObject','*clickTabObject','*radioObject','*listBrowserObject','*reactionListObject'

EXPORT OBJECT cSrcGen OF srcGen
ENDOBJECT

PROC create(fser:PTR TO fileStreamer, libsused) OF cSrcGen
  SUPER self.create(fser,libsused)
  self.type:=CSOURCE_GEN
  self.stringDelimiter:=34
  self.orOperator:='|'
  self.upperCaseProperties:=FALSE
  AstrCopy(self.assignChars,'=')
  self.extraPadding:=TRUE
  self.terminator:=";"
  self.indent:=0
ENDPROC

PROC genHeader() OF cSrcGen
  DEF tempStr[200]:STRING
  DEF menuItem:PTR TO menuItem
  DEF itemName[200]:STRING
  DEF commKey[10]:STRING
  DEF itemType
  DEF i
  self.writeLine('#include <clib/macros.h>')
  self.writeLine('#include <clib/alib_protos.h>')
  self.writeLine('')
  self.writeLine('#include <proto/exec.h>')
  self.writeLine('#include <proto/dos.h>')
  self.writeLine('#include <proto/utility.h>')
  self.writeLine('#include <proto/graphics.h>')
  self.writeLine('#include <proto/intuition.h>')
  self.writeLine('#include <proto/gadtools.h>')
  self.writeLine('')
  self.writeLine('#include <stdio.h>')
  self.writeLine('#include <stdlib.h>')
  self.writeLine('#include <string.h>')
  self.writeLine('')
  self.writeLine('#include <proto/window.h>')
  self.writeLine('#include <proto/layout.h>')
  IF self.libsused AND LIB_BUTTON THEN self.writeLine('#include <proto/button.h>')
  IF self.libsused AND LIB_CHECKBOX THEN self.writeLine('#include <proto/checkbox.h>')
  IF self.libsused AND LIB_CHOOSER THEN self.writeLine('#include <proto/chooser.h>')
  IF self.libsused AND LIB_CLICKTAB THEN self.writeLine('#include <proto/clicktab.h>')
  IF self.libsused AND LIB_FUELGAUGE THEN self.writeLine('#include <proto/fuelgauge.h>')
  IF self.libsused AND LIB_GETFILE THEN self.writeLine('#include <proto/getfile.h>')
  IF self.libsused AND LIB_GETFONT THEN self.writeLine('#include <proto/getfont.h>')
  IF self.libsused AND LIB_GETSCREEN THEN self.writeLine('#include <proto/getscreenmode.h>')
  IF self.libsused AND LIB_INTEGER THEN self.writeLine('#include <proto/integer.h>')
  IF self.libsused AND LIB_PALETTE THEN self.writeLine('#include <proto/palette.h>')
  IF self.libsused AND LIB_LISTB THEN self.writeLine('#include <proto/listbrowser.h>')
  IF self.libsused AND LIB_RADIO THEN self.writeLine('#include <proto/radiobutton.h>')
  IF self.libsused AND LIB_SCROLLER THEN self.writeLine('#include <proto/scroller.h>')
  IF self.libsused AND LIB_STRING THEN self.writeLine('#include <proto/string.h>')
  IF self.libsused AND LIB_SPACE THEN self.writeLine('#include <proto/space.h>')
  IF self.libsused AND LIB_TEXTFIELD THEN self.writeLine('#include <proto/textfield.h>')
  IF self.libsused AND LIB_BEVEL THEN self.writeLine('#include <proto/bevel.h>')
  IF self.libsused AND LIB_DRAWLIST THEN self.writeLine('#include <proto/drawlist.h>')
  IF self.libsused AND LIB_GLYPH THEN self.writeLine('#include <proto/glyph.h>')
  IF self.libsused AND LIB_LABEL THEN self.writeLine('#include <proto/label.h>')
  self.writeLine('#include <proto/gadtools.h>')
  
  self.writeLine('')
  self.writeLine('#include <libraries/gadtools.h>')
  self.writeLine('#include <reaction/reaction.h>')
  self.writeLine('#include <intuition/gadgetclass.h>')
  self.writeLine('#include <reaction/reaction_macros.h>')
  self.writeLine('#include <classes/window.h>')
  self.writeLine('')

  self.writeLine('struct List *ClickTabsA( STRPTR *text_array );')
  self.writeLine('VOID FreeClickTabs( struct List *list );')
  self.writeLine('struct List *BrowserNodesA( STRPTR *text_array );')
  self.writeLine('VOID FreeBrowserNodes( struct List *list );')
  self.writeLine('struct List *ChooserLabelsA( STRPTR *text_array );')
  self.writeLine('VOID FreeChooserLabels( struct List *list );')
  self.writeLine('struct List *RadioButtonsA( STRPTR *text_array );')
  self.writeLine('VOID FreeRadioButtons( struct List *list );')
  self.writeLine('')

  self.writeLine('struct Screen	*gScreen = NULL;')
  self.writeLine('struct DrawInfo	*gDrawInfo = NULL;')
  self.writeLine('APTR gVisinfo = NULL;')
  self.writeLine('struct MsgPort	*gAppPort = NULL;')
  self.writeLine('')

  self.writeLine('struct Library *WindowBase = NULL,')
  IF self.libsused AND LIB_BUTTON THEN self.writeLine('               *ButtonBase = NULL,')
  IF self.libsused AND LIB_CHECKBOX THEN self.writeLine('               *CheckBoxBase = NULL,')
  IF self.libsused AND LIB_CHOOSER THEN self.writeLine('               *ChooserBase = NULL,')
  IF self.libsused AND LIB_CLICKTAB THEN self.writeLine('               *ClickTabBase  = NULL,')
  IF self.libsused AND LIB_FUELGAUGE THEN self.writeLine('               *FuelGaugeBase = NULL,')
  IF self.libsused AND LIB_GETFILE THEN self.writeLine('               *GetFileBase = NULL,')
  IF self.libsused AND LIB_GETFONT THEN self.writeLine('               *GetFontBase = NULL,')
  IF self.libsused AND LIB_GETSCREEN THEN self.writeLine('               *GetScreenModeBase = NULL,')
  IF self.libsused AND LIB_INTEGER THEN self.writeLine('               *IntegerBase = NULL,')
  IF self.libsused AND LIB_PALETTE THEN self.writeLine('               *PaletteBase = NULL,')
  IF self.libsused AND LIB_LISTB THEN self.writeLine('               *ListBrowserBase = NULL,')
  IF self.libsused AND LIB_RADIO THEN self.writeLine('               *RadioButtonBase = NULL,')
  IF self.libsused AND LIB_SCROLLER THEN self.writeLine('               *ScrollerBase = NULL,')
  IF self.libsused AND LIB_STRING THEN self.writeLine('               *StringBase = NULL,')
  IF self.libsused AND LIB_SPACE THEN self.writeLine('               *SpaceBase = NULL,')
  IF self.libsused AND LIB_TEXTFIELD THEN self.writeLine('               *TextFieldBase = NULL,')
  IF self.libsused AND LIB_BEVEL THEN self.writeLine('               *BevelBase = NULL,')
  IF self.libsused AND LIB_DRAWLIST THEN self.writeLine('               *DrawListBase = NULL,')
  IF self.libsused AND LIB_GLYPH THEN self.writeLine('               *GlyphBase = NULL,')
  IF self.libsused AND LIB_LABEL THEN self.writeLine('               *LabelBase = NULL,')
  self.writeLine('               *GadToolsBase = NULL,')
  self.writeLine('               *LayoutBase = NULL;')
  self.writeLine('struct IntuitionBase *IntuitionBase = NULL;')
  self.writeLine('')
  self.writeLine('int setup( void )')
  self.writeLine('{')
  self.writeLine('  if( !(IntuitionBase = (struct IntuitionBase*) OpenLibrary("intuition.library",0L)) ) return 0;')
  self.writeLine('  if( !(GadToolsBase = (struct Library*) OpenLibrary("gadtools.library",0L) ) ) return 0;')
  self.writeLine('  if( !(WindowBase = (struct Library*) OpenLibrary("window.class",0L) ) ) return 0;')
  self.writeLine('  if( !(LayoutBase = (struct Library*) OpenLibrary("gadgets/layout.gadget",0L) ) ) return 0;')

  IF self.libsused AND LIB_BUTTON
    self.writeLine('  if( !(ButtonBase = (struct Library*) OpenLibrary("gadgets/button.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_CHECKBOX
    self.writeLine('  if( !(CheckBoxBase = (struct Library*) OpenLibrary("gadgets/checkbox.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_CHOOSER
    self.writeLine('  if( !(ChooserBase = (struct Library*) OpenLibrary("gadgets/chooser.gadget",0L) ) ) return 0;')
  ENDIF
  
  IF self.libsused AND LIB_CLICKTAB
    self.writeLine('  if( !(ClickTabBase = (struct Library*) OpenLibrary("gadgets/clicktab.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_FUELGAUGE
    self.writeLine('  if( !(FuelGaugeBase = (struct Library*) OpenLibrary("gadgets/fuelgauge.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_GETFILE
    self.writeLine('  if( !(GetFileBase = (struct Library*) OpenLibrary("gadgets/getfile.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_GETFONT
    self.writeLine('  if( !(GetFontBase = (struct Library*) OpenLibrary("gadgets/getfont.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_GETSCREEN
    self.writeLine('  if( !(GetScreenModeBase = (struct Library*) OpenLibrary("gadgets/getscreenmode.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_INTEGER
    self.writeLine('  if( !(IntegerBase = (struct Library*) OpenLibrary("gadgets/integer.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_PALETTE
    self.writeLine('  if( !(PaletteBase = (struct Library*) OpenLibrary("gadgets/palette.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_LISTB
    self.writeLine('  if( !(ListBrowserBase = (struct Library*) OpenLibrary("gadgets/listbrowser.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_RADIO
    self.writeLine('  if( !(RadioButtonBase = (struct Library*) OpenLibrary("gadgets/radiobutton.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_SCROLLER
    self.writeLine('  if( !(ScrollerBase = (struct Library*) OpenLibrary("gadgets/scroller.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_STRING
    self.writeLine('  if( !(StringBase = (struct Library*) OpenLibrary("gadgets/string.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_SPACE
    self.writeLine('  if( !(SpaceBase = (struct Library*) OpenLibrary("gadgets/space.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_TEXTFIELD
    self.writeLine('  if( !(TextFieldBase = (struct Library*) OpenLibrary("gadgets/textfield.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_BEVEL
    self.writeLine('  if( !(BevelBase = (struct Library*) OpenLibrary("images/bevel.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_DRAWLIST
    self.writeLine('  if( !(DrawListBase = (struct Library*) OpenLibrary("images/drawlist.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_GLYPH
    self.writeLine('  if( !(GlyphBase = (struct Library*) OpenLibrary("images/glyph.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused AND LIB_LABEL
    self.writeLine('  if( !(LabelBase = (struct Library*) OpenLibrary("images/label.image",0L) ) ) return 0;')
  ENDIF
  self.writeLine('  if( !(gScreen = LockPubScreen( NULL ) ) ) return 0;')
  self.writeLine('  if( !(gVisinfo = GetVisualInfo( gScreen, TAG_DONE ) ) ) return 0;')
  self.writeLine('  if( !(gDrawInfo = GetScreenDrawInfo ( gScreen ) ) ) return 0;')
  self.writeLine('  if( !(gAppPort = CreateMsgPort() ) ) return 0;')
  self.writeLine('')

  self.writeLine('  return -1;')
  self.writeLine('}')
  self.writeLine('')

  self.writeLine('void cleanup( void )')
  self.writeLine('{')
  self.writeLine('  if ( gDrawInfo ) FreeScreenDrawInfo( gScreen, gDrawInfo);')
  self.writeLine('  if ( gVisinfo ) FreeVisualInfo( gVisinfo );')
  self.writeLine('  if ( gAppPort ) DeleteMsgPort( gAppPort );')
  self.writeLine('  if ( gScreen ) UnlockPubScreen( 0, gScreen );')
  self.writeLine('')
  self.writeLine('  if (GadToolsBase) CloseLibrary( (struct Library *)GadToolsBase );')
  self.writeLine('  if (IntuitionBase) CloseLibrary( (struct Library *)IntuitionBase );')
  IF self.libsused AND LIB_BUTTON THEN self.writeLine('  if (ButtonBase) CloseLibrary( (struct Library *)ButtonBase );')
  IF self.libsused AND LIB_CHECKBOX THEN self.writeLine('  if (CheckBoxBase) CloseLibrary( (struct Library *)CheckBoxBase );')
  IF self.libsused AND LIB_CHOOSER THEN self.writeLine('  if (ChooserBase) CloseLibrary( (struct Library *)ChooserBase );')
  IF self.libsused AND LIB_CLICKTAB THEN self.writeLine('  if (ClickTabBase) CloseLibrary( (struct Library *)ClickTabBase );')
  IF self.libsused AND LIB_FUELGAUGE THEN self.writeLine('  if (FuelGaugeBase) CloseLibrary( (struct Library *)FuelGaugeBase );')
  IF self.libsused AND LIB_GETFILE THEN self.writeLine('  if (GetFileBase) CloseLibrary( (struct Library *)GetFileBase );')
  IF self.libsused AND LIB_GETFONT THEN self.writeLine('  if (GetFontBase) CloseLibrary( (struct Library *)GetFontBase );')
  IF self.libsused AND LIB_GETSCREEN THEN self.writeLine('  if (GetScreenModeBase) CloseLibrary( (struct Library *)GetScreenModeBase );')
  IF self.libsused AND LIB_INTEGER THEN self.writeLine('  if (IntegerBase) CloseLibrary( (struct Library *)IntegerBase );')
  IF self.libsused AND LIB_PALETTE THEN self.writeLine('  if (PaletteBase) CloseLibrary( (struct Library *)PaletteBase );')
  IF self.libsused AND LIB_LISTB THEN self.writeLine('  if (ListBrowserBase) CloseLibrary( (struct Library *)ListBrowserBase );')
  IF self.libsused AND LIB_RADIO THEN self.writeLine('  if (RadioButtonBase) CloseLibrary( (struct Library *)RadioButtonBase );')
  IF self.libsused AND LIB_SCROLLER THEN self.writeLine('  if (ScrollerBase) CloseLibrary( (struct Library *)ScrollerBase );')
  IF self.libsused AND LIB_STRING THEN self.writeLine('  if (StringBase) CloseLibrary( (struct Library *)StringBase );')
  IF self.libsused AND LIB_SPACE THEN self.writeLine('  if (SpaceBase) CloseLibrary( (struct Library *)SpaceBase );')
  IF self.libsused AND LIB_TEXTFIELD THEN self.writeLine('  if (ButtonBase) CloseLibrary( (struct Library *)TextFieldBase );')
  IF self.libsused AND LIB_BEVEL THEN self.writeLine('  if (BevelBase) CloseLibrary( (struct Library *)BevelBase );')
  IF self.libsused AND LIB_DRAWLIST THEN self.writeLine('  if (DrawListBase) CloseLibrary( (struct Library *)DrawListBase );')
  IF self.libsused AND LIB_GLYPH THEN self.writeLine('  if (GlyphBase) CloseLibrary( (struct Library *)GlyphBase );')
  IF self.libsused AND LIB_LABEL THEN self.writeLine('  if (LabelBase) CloseLibrary( (struct Library *)LabelBase );')
  self.writeLine('  if (LayoutBase) CloseLibrary( (struct Library *)LayoutBase );')
  self.writeLine('  if (WindowBase) CloseLibrary( (struct Library *)WindowBase );')
  self.writeLine('}')
  self.writeLine('')
  self.writeLine('void runWindow( Object *window_object, struct Menu *menu_strip )')
  self.writeLine('{')
  self.writeLine('  struct Window	*main_window = NULL;')
  self.writeLine('')
  self.writeLine('  if ( window_object )')
  self.writeLine('  {')
  self.writeLine('    if ( main_window = (struct Window *) RA_OpenWindow( window_object ))')
  self.writeLine('    {')
  self.writeLine('      WORD Code;')
  self.writeLine('      ULONG wait = 0, signal = 0, result = 0, done = FALSE;')
  self.writeLine('      GetAttr( WINDOW_SigMask, window_object, &signal );')
  self.writeLine('      if ( menu_strip)  SetMenuStrip( main_window, menu_strip );')
  self.writeLine('      while ( !done)')
  self.writeLine('      {')
  self.writeLine('        wait = Wait( signal | SIGBREAKF_CTRL_C );')
  self.writeLine('')
  self.writeLine('        if ( wait & SIGBREAKF_CTRL_C )')
  self.writeLine('          done = TRUE;')
  self.writeLine('        else')
  self.writeLine('          while (( result = RA_HandleInput( window_object, &Code )) != WMHI_LASTMSG)')
  self.writeLine('          {')
  self.writeLine('            switch ( result & WMHI_CLASSMASK )')
  self.writeLine('            {')
  self.writeLine('              case WMHI_CLOSEWINDOW:')
  self.writeLine('                done = TRUE;')
  self.writeLine('                break;')
  self.writeLine('')
  self.writeLine('              case WMHI_GADGETUP:')
  self.writeLine('                break;')
  self.writeLine('')
  self.writeLine('              case WMHI_ICONIFY:')
  self.writeLine('                if ( RA_Iconify( window_object ) )')
  self.writeLine('                  main_window = NULL;')
  self.writeLine('                break;')
  self.writeLine('')
  self.writeLine('              case WMHI_UNICONIFY:')
  self.writeLine('                main_window = RA_OpenWindow( window_object );')
  self.writeLine('              break;')
  self.writeLine('')
  self.writeLine('            }')
  self.writeLine('          }')
  self.writeLine('      }')
  self.writeLine('    }')
  self.writeLine('  }')
  self.writeLine('}')
  self.writeLine('')
ENDPROC

PROC genWindowHeader(count, windowObject:PTR TO windowObject, menuObject:PTR TO menuObject, layoutObject:PTR TO reactionObject, reactionLists:PTR TO stdlist) OF cSrcGen
  DEF tempStr[200]:STRING
  DEF i
  DEF menuItem:PTR TO menuItem
  DEF itemType
  DEF itemName[200]:STRING
  DEF commKey[10]:STRING
  DEF listObjects:PTR TO stdlist
  DEF reactionObject:PTR TO reactionObject
  DEF listStr

  StrCopy(tempStr,windowObject.name)
  LowerStr(tempStr)
  self.write('void ')
  self.write(tempStr)
  self.writeLine('( void )')
  self.writeLine('{')

  IF menuObject.menuItems.count()>0
    self.writeLine('  struct NewMenu menuData[] =')
    self.writeLine('  {')
    FOR i:=0 TO menuObject.menuItems.count()-1
      menuItem:=menuObject.menuItems.item(i)
      StrCopy(commKey,'0')
      IF menuItem.type=MENU_TYPE_MENUSUB
        itemType:='NM_SUB'
        IF menuItem.menuBar THEN StrCopy(itemName,'NM_BARLABEL') ELSE StringF(itemName,'\q\s\q',menuItem.itemName)
       
        IF StrLen(menuItem.commKey) THEN StringF(commKey,'\q\s\q',menuItem.commKey)
      ELSEIF menuItem.type=MENU_TYPE_MENUITEM
        itemType:='NM_ITEM'
        IF menuItem.menuBar THEN StrCopy(itemName,'NM_BARLABEL') ELSE StringF(itemName,'\q\s\q',menuItem.itemName)

        IF StrLen(menuItem.commKey) THEN StringF(commKey,'\q\s\q',menuItem.commKey)
      ELSE
        itemType:='NM_TITLE'
        StringF(itemName,'\q\s\q',menuItem.itemName)      
      ENDIF
      StringF(tempStr,'    { \s, \s,\s,0,0,NULL },',itemType,itemName,commKey)
      self.writeLine(tempStr)
    ENDFOR
    self.writeLine('    { NM_END, NULL, 0, 0, 0, (APTR)0 }')
    self.writeLine('  };')
    self.writeLine('')
    self.writeLine('  struct Menu	*menu_strip = NULL;')
  ENDIF
  StringF(tempStr,'  struct Gadget	*main_gadgets[ \d ];',count)
  self.writeLine(tempStr)
  self.writeLine('  Object *window_object = NULL;')

  NEW listObjects.stdlist(20)
  layoutObject.findObjectsByType(listObjects,TYPE_CHOOSER)
  layoutObject.findObjectsByType(listObjects,TYPE_RADIO)
  layoutObject.findObjectsByType(listObjects,TYPE_CLICKTAB)
  layoutObject.findObjectsByType(listObjects,TYPE_LISTBROWSER)
  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    StringF(tempStr,'  struct List *labels\d;',reactionObject.id)
    self.writeLine(tempStr)
      
    StringF(tempStr,'  UBYTE *labels\d_str[] = ',reactionObject.id)     
    listStr:=self.makeList(tempStr,reactionLists,reactionObject::listBrowserObject.listObjectId)
    IF listStr
      self.writeLine(listStr)
      DisposeLink(listStr)
    ELSE
      StringF(tempStr,'  UBYTE *labels\d_str[] = { NULL };',reactionObject.id)
      self.writeLine(tempStr)
    ENDIF
  ENDFOR
  self.writeLine('')

  IF menuObject.menuItems.count()>0
    self.writeLine('  menu_strip = CreateMenusA( menuData, TAG_END );')
    self.writeLine('  LayoutMenus( menu_strip, gVisinfo,')
    self.writeLine('    GTMN_NewLookMenus, TRUE,')
    self.writeLine('    TAG_DONE );')
    self.writeLine('')
   ENDIF

  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    SELECT reactionObject.type
      CASE TYPE_CHOOSER
        StringF(tempStr,'  labels\d = ChooserLabelsA( labels\d_str );',reactionObject.id,reactionObject.id)
      CASE TYPE_RADIO
        StringF(tempStr,'  labels\d = RadioButtonsA( labels\d_str );',reactionObject.id,reactionObject.id)
      CASE TYPE_CLICKTAB
        StringF(tempStr,'  labels\d = ClickTabsA( labels\d_str );',reactionObject.id,reactionObject.id)
      CASE TYPE_LISTBROWSER
        StringF(tempStr,'  labels\d = BrowserNodesA( labels\d_str );',reactionObject.id,reactionObject.id)
    ENDSELECT
    self.writeLine(tempStr)
  ENDFOR
  END listObjects
  self.writeLine('')

  self.indent:=2
ENDPROC

PROC genWindowFooter(count, windowObject:PTR TO windowObject, menuObject:PTR TO menuObject, layoutObject:PTR TO reactionObject, reactionLists:PTR TO stdlist) OF cSrcGen
  DEF listObjects:PTR TO stdlist
  DEF reactionObject:PTR TO reactionObject
  DEF listStr
  DEF tempStr[200]:STRING
  DEF i

  self.writeLine('')
  IF menuObject.menuItems.count()>0
    self.writeLine('  runWindow( window_object,menu_strip );')
  ELSE
    self.writeLine('  runWindow( window_object, 0 );')
  ENDIF
  self.writeLine('')
  self.writeLine('  if ( window_object ) DisposeObject( window_object );')
  IF menuObject.menuItems.count()>0
    self.writeLine('  if ( menu_strip ) FreeMenus( menu_strip );')
  ENDIF

  NEW listObjects.stdlist(20)
  layoutObject.findObjectsByType(listObjects,TYPE_CHOOSER)
  layoutObject.findObjectsByType(listObjects,TYPE_RADIO)
  layoutObject.findObjectsByType(listObjects,TYPE_CLICKTAB)
  layoutObject.findObjectsByType(listObjects,TYPE_LISTBROWSER)
  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    SELECT reactionObject.type
      CASE TYPE_CHOOSER
        StringF(tempStr,'  if ( labels\d ) FreeChooserLabels( labels\d );',reactionObject.id,reactionObject.id)
      CASE TYPE_RADIO
        StringF(tempStr,'  if ( labels\d ) FreeRadioButtons( labels\d );',reactionObject.id, reactionObject.id)
      CASE TYPE_CLICKTAB
        StringF(tempStr,'  if ( labels\d ) FreeClickTabs( labels\d )',reactionObject.id,reactionObject.id)
      CASE TYPE_LISTBROWSER
        StringF(tempStr,'  if (labels\d ) FreeBrowserNodes( labels\d )',reactionObject.id,reactionObject.id)
    ENDSELECT
    self.writeLine(tempStr)
  ENDFOR
  END listObjects


  
  self.writeLine('}')
  self.writeLine('')
ENDPROC

PROC genFooter(windowObject:PTR TO windowObject) OF cSrcGen
  DEF tempStr[200]:STRING
  self.writeLine('int main( int argc, char **argv )')
  self.writeLine('{')
  self.writeLine('  if ( setup() )')
  self.writeLine('  {')
  StringF(tempStr,'    \s',windowObject.name)
  LowerStr(tempStr)
  StrAdd(tempStr,'();')
  self.writeLine(tempStr)
  self.writeLine('  }')

  self.writeLine('  cleanup();')
  self.writeLine('}')
ENDPROC

PROC assignWindowVar() OF cSrcGen
  self.genIndent()
  self.write('window_object = ')
ENDPROC

PROC assignGadgetVar(index) OF cSrcGen
  DEF tempStr[100]:STRING
  StringF(tempStr,'main_gadgets[\d] = ',index)
  self.write(tempStr)
ENDPROC

PROC makeList(start:PTR TO CHAR,reactionLists:PTR TO stdlist, listid) OF cSrcGen
  DEF res=0
  DEF totsize=0,linelen=0
  DEF i,listitem=0:PTR TO reactionListObject
  DEF foundid=-1
  DEF items:PTR TO stringlist
 
  FOR i:=0 TO reactionLists.count()-1
    listitem:=reactionLists.item(i)
    IF listitem.id=listid THEN foundid:=i
  ENDFOR
  
  IF foundid<>-1
    totsize:=StrLen(start)
    listitem:=reactionLists.item(foundid)
    FOR i:=0 TO listitem.items.count()-1
      linelen:=linelen+EstrLen(listitem.items.item(i))+4
      IF linelen>90
        linelen:=0
        totsize:=totsize+5
      ENDIF
      totsize:=totsize+EstrLen(listitem.items.item(i))+4
    ENDFOR
    res:=String(totsize+10)
    StrCopy(res,start)
    StrAdd(res,'{ ')
    linelen:=0
    FOR i:=0 TO listitem.items.count()-1
      StrAdd(res,'\q')
      StrAdd(res,listitem.items.item(i))
      StrAdd(res,'\q, ')
      linelen:=linelen+EstrLen(listitem.items.item(i))+4
      IF linelen>90
        linelen:=0
        StrAdd(res,'\n    ')
      ENDIF
    ENDFOR
    StrAdd(res,' NULL };')
  ENDIF
  
ENDPROC res
