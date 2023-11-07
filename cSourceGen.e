
OPT MODULE

  MODULE '*fileStreamer','*sourceGen','*reactionObject','*menuObject','*stringlist'

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

PROC genHeader(count,menuObject:PTR TO menuObject) OF cSrcGen
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
  IF menuObject.menuItems.count()>0 THEN self.writeLine('#include <proto/gadtools.h>')
  
  self.writeLine('')
  self.writeLine('#include <libraries/gadtools.h>')
  self.writeLine('#include <reaction/reaction.h>')
  self.writeLine('#include <intuition/gadgetclass.h>')
  self.writeLine('#include <reaction/reaction_macros.h>')
  self.writeLine('#include <classes/window.h>')
  self.writeLine('')
  self.writeLine('int main(int argc, char **argv);')
  self.writeLine('void close_all(void);')
  self.writeLine('')
  IF menuObject.menuItems.count()>0
    self.writeLine('struct NewMenu gMenuData[] =')
    self.writeLine('{')
    FOR i:=0 TO menuObject.menuItems.count()-1
      menuItem:=menuObject.menuItems.item(i)
      StrCopy(commKey,'0')
      IF menuItem.menuItem 
        itemType:='NM_ITEM'
        StringF(itemName,'\q\s\q',menuItem.itemName)
        IF StrLen(menuItem.commKey) THEN StringF(commKey,'\q\s\q',menuItem.commKey)
      ELSEIF menuItem.menuBar
        itemType:='NM_ITEM'
        StrCopy(itemName,'NM_BARLABEL')
      ELSE
        itemType:='NM_TITLE'
        StringF(itemName,'\q\s\q',menuItem.itemName)      
      ENDIF
      StringF(tempStr,'  { \s, \s,\s,0,0,NULL },',itemType,itemName,commKey)
      self.writeLine(tempStr)
    ENDFOR
    self.writeLine('  { NM_END, NULL, 0, 0, 0, (APTR)0 }')
    self.writeLine('};')

    self.write('')
    self.writeLine('')
  ENDIF
  
  self.writeLine('struct Screen	*gScreen = NULL;')
  self.writeLine('struct DrawInfo	*gDrinfo = NULL;')
  self.writeLine('struct MsgPort	*gApp_port = NULL;')
  self.writeLine('struct Window	*gMain_window = NULL;')
  StringF(tempStr,'struct Gadget	*gMain_Gadgets[ \d ];',count)
  self.writeLine(tempStr)
  IF menuObject.menuItems.count()>0
    self.writeLine('struct Menu	*gMenuStrip = NULL;')
    self.writeLine('APTR gVi = NULL;')
  ENDIF
  self.writeLine('Object *gWindow_object = NULL;')
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
  IF menuObject.menuItems.count()>0 THEN self.writeLine('               *GadToolsBase = NULL,')
  self.writeLine('               *LayoutBase = NULL;')
  IF menuObject.menuItems.count()>0  THEN self.writeLine('struct IntuitionBase *IntuitionBase = NULL;')

  self.writeLine('')
  self.writeLine('int main(int argc, char **argv)')
  self.writeLine('{')
  self.writeLine('  char initOk=0;')

  self.writeLine('  if( IntuitionBase = (struct IntuitionBase*) OpenLibrary("intuition.library",0L) )')
  self.writeLine('  {')
  self.writeLine('    gScreen = LockPubScreen( NULL );')
  self.writeLine('')
  IF menuObject.menuItems.count()>0
    self.writeLine('    if( GadToolsBase = (struct Library*) OpenLibrary("gadtools.library",0L) )')
    self.writeLine('    {')
    self.writeLine('      gVi = GetVisualInfo( gScreen, TAG_DONE );')
    self.writeLine('    }')
  ENDIF

  self.writeLine('  }')
  self.writeLine('')
  self.writeLine('  if ( gScreen )')
  self.writeLine('  {')
  self.writeLine('    gDrinfo = GetScreenDrawInfo ( gScreen );')
  self.writeLine('    gApp_port = CreateMsgPort();')
 
  self.writeLine('    if( WindowBase = (struct Library*) OpenLibrary("window.class",0L) )')
  self.writeLine('    {')
  self.writeLine('      if( LayoutBase = (struct Library*) OpenLibrary("gadgets/layout.gadget",0L) )')
  self.writeLine('      {')
  self.indent:=8
  IF self.libsused AND LIB_BUTTON
    self.writeLine('if( ButtonBase = (struct Library*) OpenLibrary("gadgets/button.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_CHECKBOX
    self.writeLine('if( CheckBoxBase = (struct Library*) OpenLibrary("gadgets/checkbox.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_CHOOSER
    self.writeLine('if( ChooserBase = (struct Library*) OpenLibrary("gadgets/chooser.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF
  
  IF self.libsused AND LIB_CLICKTAB
    self.writeLine('if( ClickTabBase = (struct Library*) OpenLibrary("gadgets/clicktab.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_FUELGAUGE
    self.writeLine('if( FuelGaugeBase = (struct Library*) OpenLibrary("gadgets/fuelgauge.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_GETFILE
    self.writeLine('if( GetFileBase = (struct Library*) OpenLibrary("gadgets/getfile.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_GETFONT
    self.writeLine('if( GetFontBase = (struct Library*) OpenLibrary("gadgets/getfont.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_GETSCREEN
    self.writeLine('if( GetScreenModeBase = (struct Library*) OpenLibrary("gadgets/getscreenmode.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_INTEGER
    self.writeLine('if( IntegerBase = (struct Library*) OpenLibrary("gadgets/integer.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_PALETTE
    self.writeLine('if( PaletteBase = (struct Library*) OpenLibrary("gadgets/palette.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_LISTB
    self.writeLine('if( ListBrowserBase = (struct Library*) OpenLibrary("gadgets/listbrowser.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_RADIO
    self.writeLine('if( RadioButtonBase = (struct Library*) OpenLibrary("gadgets/radiobutton.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_SCROLLER
    self.writeLine('if( ScrollerBase = (struct Library*) OpenLibrary("gadgets/scroller.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_STRING
    self.writeLine('if( StringBase = (struct Library*) OpenLibrary("gadgets/string.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_SPACE
    self.writeLine('if( SpaceBase = (struct Library*) OpenLibrary("gadgets/space.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_TEXTFIELD
    self.writeLine('if( TextFieldBase = (struct Library*) OpenLibrary("gadgets/textfield.gadget",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_BEVEL
    self.writeLine('if( BevelBase = (struct Library*) OpenLibrary("images/bevel.image",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_DRAWLIST
    self.writeLine('if( DrawListBase = (struct Library*) OpenLibrary("images/drawlist.image",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_GLYPH
    self.writeLine('if( GlyphBase = (struct Library*) OpenLibrary("images/glyph.image",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF

  IF self.libsused AND LIB_LABEL
    self.writeLine('if( LabelBase = (struct Library*) OpenLibrary("images/label.image",0L) )')
    self.writeLine('{')
    self.indent+=2
  ENDIF
  
  self.writeLine('initOk = -1;')

  IF self.libsused AND LIB_BUTTON
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_CHECKBOX
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_CHOOSER
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_CLICKTAB
    self.indent-=2
    self.writeLine('}')
  ENDIF
  
  IF self.libsused AND LIB_FUELGAUGE
    self.indent-=2
    self.writeLine('}')
  ENDIF
  
  IF self.libsused AND LIB_GETFILE
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_GETFONT
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_GETSCREEN
    self.indent-=2
    self.writeLine('}')
  ENDIF
            
  IF self.libsused AND LIB_INTEGER
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_PALETTE
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_LISTB
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_RADIO
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_SCROLLER
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_STRING
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_SPACE
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_TEXTFIELD
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_BEVEL
    self.indent-=2
    self.writeLine('}')
  ENDIF
  
  IF self.libsused AND LIB_DRAWLIST
    self.indent-=2
    self.writeLine('}')
  ENDIF

  IF self.libsused AND LIB_GLYPH
    self.indent-=2
    self.writeLine('}')
  ENDIF
  
  IF self.libsused AND LIB_LABEL
    self.indent-=2
    self.writeLine('}')
  ENDIF

  self.indent-=2
  self.writeLine('}')
  
  self.indent-=2
  self.writeLine('}')
 
  self.indent-=2
  self.writeLine('}')

  self.writeLine('')
  self.writeLine('if ( initOk )')
  self.writeLine('{')
  self.indent+=2
  IF menuObject.menuItems.count()>0
    self.writeLine('if ( gVi )')
    self.writeLine('{')
    self.writeLine('  gMenuStrip = CreateMenusA( gMenuData, TAG_END);')
    self.writeLine('  LayoutMenus( gMenuStrip, gVi,')
    self.writeLine('    GTMN_NewLookMenus, TRUE,')
    self.writeLine('    TAG_DONE);')
    self.writeLine('}')
    self.writeLine('')
   ENDIF
  
ENDPROC

PROC genFooter(count,menuObject:PTR TO menuObject) OF cSrcGen
  self.writeLine('}')
  self.indent:=0
  self.writeLine('')
  self.writeLine('  if ( gWindow_object )')
  self.writeLine('  {')
  self.writeLine('    if ( gMain_window = (struct Window *) RA_OpenWindow( gWindow_object ))')
  self.writeLine('    {')
  self.writeLine('      WORD Code;')
  self.writeLine('      ULONG wait = 0, signal = 0, result = 0, done = FALSE;')
  self.writeLine('      GetAttr( WINDOW_SigMask, gWindow_object, &signal );')
  IF menuObject.menuItems.count()>0
    self.writeLine('      SetMenuStrip( gMain_window, gMenuStrip );')
  ENDIF

  self.writeLine('      while ( !done)')
  self.writeLine('      {')
  self.writeLine('            wait = Wait( signal | SIGBREAKF_CTRL_C );')
  self.writeLine('')
  self.writeLine('        if ( wait & SIGBREAKF_CTRL_C )')
  self.writeLine('          done = TRUE;')
  self.writeLine('            else')
  self.writeLine('        while (( result = RA_HandleInput( gWindow_object, &Code )) != WMHI_LASTMSG)')
  self.writeLine('        {')
  self.writeLine('          switch ( result & WMHI_CLASSMASK )')
  self.writeLine('          {')
  self.writeLine('            case WMHI_CLOSEWINDOW:')
  self.writeLine('              done = TRUE;')
  self.writeLine('              break;')
  self.writeLine('')
  self.writeLine('            case WMHI_GADGETUP:')
  self.writeLine('              break;')
  self.writeLine('')
  self.writeLine('            case WMHI_ICONIFY:')
  self.writeLine('              if ( RA_Iconify( gWindow_object ) )')
  self.writeLine('                gMain_window = NULL;')
  self.writeLine('              break;')
  self.writeLine('')
  self.writeLine('            case WMHI_UNICONIFY:')
  self.writeLine('              gMain_window = RA_OpenWindow( gWindow_object );')
  self.writeLine('            break;')
  self.writeLine('')
  self.writeLine('          }')
  self.writeLine('        }')
  self.writeLine('      }')
  self.writeLine('    }')
  self.writeLine('    close_all();')
  self.writeLine('  }')
  self.writeLine('  return(0);')
  self.writeLine('}')
  self.writeLine('')
  
  self.writeLine('void close_all( void )')
  self.writeLine('{')
  IF menuObject.menuItems.count()>0
    self.writeLine('  if ( gMenuStrip )')
    self.writeLine('    FreeMenus( gMenuStrip );')
  ENDIF
  self.writeLine('  if ( gApp_port )')
  self.writeLine('    DeleteMsgPort( gApp_port );')
  self.writeLine('  if ( gDrinfo )')
  self.writeLine('    FreeScreenDrawInfo( gScreen, gDrinfo);')
  IF menuObject.menuItems.count()>0
    self.writeLine('  if ( gVi )')
    self.writeLine('    FreeVisualInfo( gVi );')
  ENDIF
  self.writeLine('  if ( gScreen )')
  self.writeLine('    UnlockPubScreen(0, gScreen );')
  self.writeLine('  if ( gWindow_object )')
  self.writeLine('  {')
  self.writeLine('    DisposeObject( gWindow_object );')
  self.writeLine('    gWindow_object = NULL;')
  self.writeLine('    gMain_window = NULL;')
  self.writeLine('  }')
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
  IF menuObject.menuItems.count()>0 THEN self.writeLine('  if (GadToolsBase) CloseLibrary( (struct Library *)GadToolsBase );')
  self.writeLine('  if (LayoutBase) CloseLibrary( (struct Library *)LayoutBase );')
  self.writeLine('  if (WindowBase) CloseLibrary( (struct Library *)WindowBase );')
  self.writeLine('}')
  self.writeLine('')
ENDPROC
