OPT MODULE,LARGE

  MODULE 'images/drawlist'
  MODULE '*fileStreamer','*sourceGen','*reactionObject','*windowObject','*menuObject','*stringlist','*screenObject'
  MODULE '*chooserObject','*clickTabObject','*radioObject','*listBrowserObject','*tabsObject','*reactionListObject',
         '*drawListObject','*speedBarObject','*listViewObject','*rexxObject'

EXPORT OBJECT cSrcGen OF srcGen
ENDOBJECT

PROC create(fser:PTR TO fileStreamer, libsused:PTR TO CHAR,definitionOnly,useIds) OF cSrcGen
  SUPER self.create(fser,libsused,definitionOnly,useIds)
  self.type:=CSOURCE_GEN
  self.stringDelimiter:=34
  self.orOperator:='|'
  self.upperCaseProperties:=FALSE
  AstrCopy(self.assignChars,'=')
  self.extraPadding:=TRUE
  self.terminator:=";"
  self.indent:=0
ENDPROC

PROC genHeader(screenObject:PTR TO screenObject, rexxObject:PTR TO rexxObject) OF cSrcGen
  DEF tempStr[200]:STRING
  DEF menuItem:PTR TO menuItem
  DEF itemName[200]:STRING
  DEF commKey[10]:STRING
  DEF itemType
  DEF hasarexx,i

  hasarexx:=(rexxObject.commands.count()>0) AND (StrLen(rexxObject.hostName)>0)

  self.writeLine('#include <clib/macros.h>')
  self.writeLine('#include <clib/alib_protos.h>')
  self.writeLine('#include <clib/compiler-specific.h>')
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
  IF self.libsused[TYPE_BUTTON] THEN self.writeLine('#include <proto/button.h>')
  IF self.libsused[TYPE_CHECKBOX] THEN self.writeLine('#include <proto/checkbox.h>')
  IF self.libsused[TYPE_CHOOSER] THEN self.writeLine('#include <proto/chooser.h>')
  IF self.libsused[TYPE_CLICKTAB] THEN self.writeLine('#include <proto/clicktab.h>')
  IF self.libsused[TYPE_FUELGAUGE] THEN self.writeLine('#include <proto/fuelgauge.h>')
  IF self.libsused[TYPE_GETFILE] THEN self.writeLine('#include <proto/getfile.h>')
  IF self.libsused[TYPE_GETFONT] THEN self.writeLine('#include <proto/getfont.h>')
  IF self.libsused[TYPE_GETSCREENMODE] THEN self.writeLine('#include <proto/getscreenmode.h>')
  IF self.libsused[TYPE_INTEGER] THEN self.writeLine('#include <proto/integer.h>')
  IF self.libsused[TYPE_PALETTE] THEN self.writeLine('#include <proto/palette.h>')
  IF self.libsused[TYPE_LISTBROWSER] THEN self.writeLine('#include <proto/listbrowser.h>')
  IF self.libsused[TYPE_RADIO] THEN self.writeLine('#include <proto/radiobutton.h>')
  IF self.libsused[TYPE_SCROLLER] THEN self.writeLine('#include <proto/scroller.h>')
  IF self.libsused[TYPE_SPEEDBAR] THEN self.writeLine('#include <proto/speedbar.h>')
  IF self.libsused[TYPE_STRING] THEN self.writeLine('#include <proto/string.h>')
  IF self.libsused[TYPE_SPACE] THEN self.writeLine('#include <proto/space.h>')
  IF self.libsused[TYPE_TEXTFIELD] THEN self.writeLine('#include <proto/textfield.h>')
  IF self.libsused[TYPE_BEVEL] THEN self.writeLine('#include <proto/bevel.h>')
  IF self.libsused[TYPE_DRAWLIST] THEN self.writeLine('#include <proto/drawlist.h>')
  IF self.libsused[TYPE_GLYPH] THEN self.writeLine('#include <proto/glyph.h>')
  IF self.libsused[TYPE_LABEL] THEN self.writeLine('#include <proto/label.h>')
  IF self.libsused[TYPE_BITMAP] THEN self.writeLine('#include <proto/bitmap.h>')
  IF (self.libsused[TYPE_BOINGBALL] OR self.libsused[TYPE_PENMAP]) THEN self.writeLine('#include <proto/penmap.h>')
  IF self.libsused[TYPE_COLORWHEEL] THEN self.writeLine('#include <proto/colorwheel.h>')
  IF self.libsused[TYPE_DATEBROWSER] THEN self.writeLine('#include <proto/datebrowser.h>')
  IF self.libsused[TYPE_GETCOLOR] THEN self.writeLine('#include <proto/getcolor.h>')
  IF self.libsused[TYPE_GRADSLIDER] THEN self.writeLine('#include <gadgets/gradientslider.h>')
  IF self.libsused[TYPE_TAPEDECK] THEN self.writeLine('#include <gadgets/tapedeck.h>')
  IF self.libsused[TYPE_TEXTEDITOR] THEN self.writeLine('#include <proto/texteditor.h>')
  IF self.libsused[TYPE_LED] THEN self.writeLine('#include <images/led.h>')
  IF self.libsused[TYPE_TABS] THEN self.writeLine('#include <gadgets/tabs.h>')
  IF self.libsused[TYPE_LISTVIEW] 
    self.writeLine('#include <gadgets/listview.h>')
    self.writeLine('#include <pragmas/listview_pragmas.h>')
  ENDIF
  IF hasarexx
    self.writeLine('#include <proto/arexx.h>')
    IF rexxObject.replyHook
      self.writeLine('#include <utility/hooks.h>')
    ENDIF
  ENDIF

  IF self.libsused[TYPE_VIRTUAL] THEN self.writeLine('#include <proto/virtual.h>')
  IF self.libsused[TYPE_SKETCH] THEN self.writeLine('#include <proto/sketchboard.h>')
  self.writeLine('#include <proto/gadtools.h>')
  
  self.writeLine('')
  self.writeLine('#include <libraries/gadtools.h>')
  self.writeLine('#include <reaction/reaction.h>')
  self.writeLine('#include <intuition/gadgetclass.h>')
  self.writeLine('#include <reaction/reaction_macros.h>')
  self.writeLine('#include <classes/window.h>')
  self.writeLine('#include <exec/memory.h>')
  self.writeLine('')

  IF self.libsused[TYPE_VIRTUAL]
    self.writeLine('#define Virtual_GetClass() VIRTUAL_GetClass()')
    self.writeLine('')
  ENDIF

  IF self.libsused[TYPE_SKETCH]
    self.writeLine('#define SketchBoard_GetClass() SKETCHBOARD_GetClass()')
    self.writeLine('')
  ENDIF

  IF self.libsused[TYPE_LISTVIEW]
    self.writeLine('#define ListView_GetClass() LISTVIEW_GetClass()')
    self.writeLine('')
  ENDIF

  self.writeLine('struct Screen	*gScreen = NULL;')
  self.writeLine('struct DrawInfo	*gDrawInfo = NULL;')
  self.writeLine('APTR gVisinfo = NULL;')
  self.writeLine('struct MsgPort	*gAppPort = NULL;')
  self.writeLine('')

  IF self.definitionOnly=FALSE

    IF self.libsused[TYPE_LISTVIEW]
      self.writeLine('struct List *ListViewLabelsA(STRPTR *nameList)')
      self.writeLine('{')
      self.writeLine('  struct List *newList;')
      self.writeLine('  struct ListLabelNode *node;')
      self.writeLine('  int i=0;')
      self.writeLine('  newList = (struct List *)AllocMem(sizeof(struct List), MEMF_PUBLIC );')
      self.writeLine('')
      self.writeLine('  if (newList && nameList)')
      self.writeLine('  {')
      self.writeLine('    NewList( newList );')
      self.writeLine('    while(*nameList)')
      self.writeLine('    {')
      self.writeLine('      node = (struct ListLabelNode *)AllocMem(sizeof(struct ListLabelNode), MEMF_ANY | MEMF_CLEAR );')
      self.writeLine('')
      self.writeLine('      node->lvn_RenderForeground = 1;')
      self.writeLine('      node->lvn_RenderBackground = 0;')
      self.writeLine('')
      self.writeLine('      node->lvn_SelectForeground = 2;')
      self.writeLine('      node->lvn_SelectBackground = 3;')
      self.writeLine('')
      self.writeLine('      node->lvn_Node.ln_Name = *nameList;')
      self.writeLine('      node->lvn_Node.ln_Type = i;')
      self.writeLine('      AddTail(newList, (struct Node *)node);')
      self.writeLine('      i++;')
      self.writeLine('      nameList++;')
      self.writeLine('    }')
      self.writeLine('  }')
      self.writeLine('  return newList;')
      self.writeLine('}')
      self.writeLine('')
      self.writeLine('void FreeListViewLabels(struct List *list)')
      self.writeLine('{')
      self.writeLine('  struct Node *node;')
      self.writeLine('  struct Node *nextnode;')
      self.writeLine('  ')
      self.writeLine('    if (list)')
      self.writeLine('    {')
      self.writeLine('      node = list->lh_Head;')
      self.writeLine('')
      self.writeLine('      while(nextnode = node->ln_Succ)')
      self.writeLine('      {')
      self.writeLine('        FreeMem(node,sizeof(struct ListLabelNode));')
      self.writeLine('        node = nextnode;')
      self.writeLine('      }')
      self.writeLine('      FreeMem(list, sizeof (struct List));')
      self.writeLine('    }')
      self.writeLine('}')
      self.writeLine('')
    ENDIF

    IF self.libsused[TYPE_SPEEDBAR]
      self.writeLine('struct List *SpeedBarNodesA(STRPTR *nameList)')
      self.writeLine('{')
      self.writeLine('  struct List *newList;')
      self.writeLine('  struct Gadget *label;')
      self.writeLine('  int i=0;')
      self.writeLine('  char *c;')
      self.writeLine('  newList = (struct List *)AllocMem(sizeof(struct List), MEMF_PUBLIC );')
      self.writeLine('')
      self.writeLine('  if (newList && nameList)')
      self.writeLine('  {')
      self.writeLine('    NewList( newList );')
      self.writeLine('    while(*nameList)')
      self.writeLine('    {')
      self.writeLine('      c = (char *)(*nameList);')
      self.writeLine('      if (c[0]==\a1\a) {')
      self.writeLine('        label = BitMapObject,')
      self.writeLine('          BITMAP_SourceFile, c+1,')
      self.writeLine('          BITMAP_Screen, gScreen,')
      self.writeLine('        BitMapEnd;')
      self.writeLine('      } else {')
      self.writeLine('        label = LabelObject,')
      self.writeLine('          LABEL_Text, c+1,')
      self.writeLine('        LabelEnd;')
      self.writeLine('      }')
      self.writeLine('      AddTail(newList, AllocSpeedButtonNode(i, SBNA_Image, label, SBNA_Enabled, TRUE, SBNA_Spacing, 2, SBNA_Highlight, SBH_RECESS, TAG_END));')
      self.writeLine('      nameList++;')
      self.writeLine('      i++;')
      self.writeLine('    }')
      self.writeLine('  }')
      self.writeLine('  return newList;')
      self.writeLine('}')
      self.writeLine('')
      self.writeLine('void FreeSpeedBarNodes(struct List *list)')
      self.writeLine('{')
      self.writeLine('  struct Gadget *label;')
      self.writeLine('  struct Node *node;')
      self.writeLine('  struct Node *nextnode;')
      self.writeLine('  ')
      self.writeLine('    if (list)')
      self.writeLine('    {')
      self.writeLine('      node = list->lh_Head;')
      self.writeLine('')
      self.writeLine('      while(nextnode = node->ln_Succ)')
      self.writeLine('      {')
      self.writeLine('        GetSpeedButtonNodeAttrs(node, SBNA_Image, &label, TAG_END);')
      self.writeLine('        DisposeObject(label);')
      self.writeLine('        FreeSpeedButtonNode(node);')
      self.writeLine('        node = nextnode;')
      self.writeLine('      }')
      self.writeLine('      FreeMem(list, sizeof (struct List));')
      self.writeLine('    }')
      self.writeLine('}')
      self.writeLine('')
      
    ENDIF

    IF self.libsused[TYPE_CHOOSER]
      self.writeLine('struct List *ChooserLabelsA(STRPTR *nameList)')
      self.writeLine('{')
      self.writeLine('  struct List *newList;')
      self.writeLine('  newList = (struct List *)AllocMem(sizeof(struct List), MEMF_PUBLIC );')
      self.writeLine('')
      self.writeLine('  if (newList && nameList)')
      self.writeLine('  {')
      self.writeLine('    NewList( newList );')
      self.writeLine('    while(*nameList)')
      self.writeLine('    {')
      self.writeLine('      AddTail(newList, AllocChooserNode(CNA_Text, *nameList, TAG_END));')
      self.writeLine('      nameList++;')
      self.writeLine('    }')
      self.writeLine('  }')
      self.writeLine('  return newList;')
      self.writeLine('}')
      self.writeLine('')
      self.writeLine('void FreeChooserLabels(struct List *list)')
      self.writeLine('{')
      self.writeLine('  struct Node *node;')
      self.writeLine('  struct Node *nextnode;')
      self.writeLine('  ')
      self.writeLine('    if (list)')
      self.writeLine('    {')
      self.writeLine('      node = list->lh_Head;')
      self.writeLine('')
      self.writeLine('      while(nextnode = node->ln_Succ)')
      self.writeLine('      {')
      self.writeLine('        FreeChooserNode(node);')
      self.writeLine('        node = nextnode;')
      self.writeLine('      }')
      self.writeLine('      FreeMem(list, sizeof (struct List));')
      self.writeLine('    }')
      self.writeLine('}')
      self.writeLine('')
    ENDIF

    IF self.libsused[TYPE_CLICKTAB]
      self.writeLine('struct List *ClickTabsA(STRPTR *nameList)')
      self.writeLine('{')
      self.writeLine('  struct List *newList;')
      self.writeLine('  newList = (struct List *)AllocMem(sizeof(struct List), MEMF_PUBLIC );')
      self.writeLine('')
      self.writeLine('  if (newList && nameList)')
      self.writeLine('  {')
      self.writeLine('    NewList( newList );')
      self.writeLine('    while(*nameList)')
      self.writeLine('    {')
      self.writeLine('      AddTail(newList, AllocClickTabNode(TNA_Text, *nameList, TAG_END));')
      self.writeLine('      nameList++;')
      self.writeLine('    }')
      self.writeLine('  }')
      self.writeLine('  return newList;')
      self.writeLine('}')
      self.writeLine('')
      self.writeLine('void FreeClickTabs(struct List *list)')
      self.writeLine('{')
      self.writeLine('  struct Node *node;')
      self.writeLine('  struct Node *nextnode;')
      self.writeLine('  ')
      self.writeLine('    if (list)')
      self.writeLine('    {')
      self.writeLine('      node = list->lh_Head;')
      self.writeLine('')
      self.writeLine('      while(nextnode = node->ln_Succ)')
      self.writeLine('      {')
      self.writeLine('        FreeClickTabNode(node);')
      self.writeLine('        node = nextnode;')
      self.writeLine('      }')
      self.writeLine('      FreeMem(list, sizeof (struct List));')
      self.writeLine('    }')
      self.writeLine('}')
      self.writeLine('')
    ENDIF


    IF self.libsused[TYPE_RADIO]
      self.writeLine('struct List *RadioButtonsA(STRPTR *nameList)')
      self.writeLine('{')
      self.writeLine('  struct List *newList;')
      self.writeLine('  newList = (struct List *)AllocMem(sizeof(struct List), MEMF_PUBLIC );')
      self.writeLine('')
      self.writeLine('  if (newList && nameList)')
      self.writeLine('  {')
      self.writeLine('    NewList( newList );')
      self.writeLine('    while(*nameList)')
      self.writeLine('    {')
      self.writeLine('      AddTail(newList, AllocRadioButtonNode(RBNA_Labels, *nameList, TAG_END));')
      self.writeLine('      nameList++;')
      self.writeLine('    }')
      self.writeLine('  }')
      self.writeLine('  return newList;')
      self.writeLine('}')
      self.writeLine('')
      self.writeLine('void FreeRadioButtons(struct List *list)')
      self.writeLine('{')
      self.writeLine('  struct Node *node;')
      self.writeLine('  struct Node *nextnode;')
      self.writeLine('  ')
      self.writeLine('    if (list)')
      self.writeLine('    {')
      self.writeLine('      node = list->lh_Head;')
      self.writeLine('')
      self.writeLine('      while(nextnode = node->ln_Succ)')
      self.writeLine('      {')
      self.writeLine('        FreeRadioButtonNode(node);')
      self.writeLine('        node = nextnode;')
      self.writeLine('      }')
      self.writeLine('      FreeMem(list, sizeof (struct List));')
      self.writeLine('    }')
      self.writeLine('}')
      self.writeLine('')
    ENDIF

    IF self.libsused[TYPE_LISTBROWSER]
      self.writeLine('struct List *BrowserNodesA(STRPTR *nameList)')
      self.writeLine('{')
      self.writeLine('  struct List *newList;')
      self.writeLine('  newList = (struct List *)AllocMem(sizeof(struct List), MEMF_PUBLIC );')
      self.writeLine('')
      self.writeLine('  if (newList && nameList)')
      self.writeLine('  {')
      self.writeLine('    NewList( newList );')
      self.writeLine('    while(*nameList)')
      self.writeLine('    {')
      self.writeLine('      AddTail(newList, AllocListBrowserNode(1, LBNCA_Text, *nameList, TAG_END));')
      self.writeLine('      nameList++;')
      self.writeLine('    }')
      self.writeLine('  }')
      self.writeLine('  return newList;')
      self.writeLine('}')
      self.writeLine('')
      self.writeLine('void FreeBrowserNodes(struct List *list)')
      self.writeLine('{')
      self.writeLine('  ')
      self.writeLine('    if (list)')
      self.writeLine('    {')
      self.writeLine('      FreeListBrowserList(list);')
      self.writeLine('      FreeMem(list, sizeof (struct List));')
      self.writeLine('    }')
      self.writeLine('}')
      self.writeLine('')
    ENDIF
  ENDIF

  IF hasarexx
    IF rexxObject.replyHook
      self.writeLine('void __SAVE_DS__ rexxReply_CallBack(struct Hook *, Object *, struct RexxMsg * );')
    ENDIF
    FOR i:=0 TO rexxObject.commands.count()-1
      StrCopy(tempStr,rexxObject.commands.item(i))
      LowerStr(tempStr)
      StringF(tempStr,'void __SAVE_DS__ __ASM__ rexx_\s',tempStr)
      StrAdd(tempStr,'(__REG__(a0,struct ARexxCmd *),__REG__(a1,struct RexxMsg * ));')
      self.writeLine(tempStr)
    ENDFOR
 
    self.writeLine('Object	*gArexxObject = NULL;')
    IF rexxObject.replyHook
      self.writeLine('struct Hook gArexxReplyHook;')
    ENDIF
    self.writeLine('struct ARexxCmd gRxCommands[] =')
    self.writeLine('{')
    FOR i:=0 TO rexxObject.commands.count()-1
      StrCopy(tempStr,rexxObject.commands.item(i))
      LowerStr(tempStr)
      StringF(tempStr,'  { \q\s\q, \d, rexx_\s, NULL, NULL },',rexxObject.commands.item(i),i,tempStr)
      self.writeLine(tempStr)
    ENDFOR
    self.writeLine('  { NULL, NULL, NULL, NULL, NULL }')
    self.writeLine('};')
    self.writeLine('')
  ENDIF

  self.writeLine('struct Library *WindowBase = NULL,')
  IF hasarexx THEN self.writeLine('               *ARexxBase = NULL,')
  IF self.libsused[TYPE_BUTTON] THEN self.writeLine('               *ButtonBase = NULL,')
  IF self.libsused[TYPE_CHECKBOX] THEN self.writeLine('               *CheckBoxBase = NULL,')
  IF self.libsused[TYPE_CHOOSER] THEN self.writeLine('               *ChooserBase = NULL,')
  IF self.libsused[TYPE_CLICKTAB] THEN self.writeLine('               *ClickTabBase  = NULL,')
  IF self.libsused[TYPE_FUELGAUGE] THEN self.writeLine('               *FuelGaugeBase = NULL,')
  IF self.libsused[TYPE_GETFILE] THEN self.writeLine('               *GetFileBase = NULL,')
  IF self.libsused[TYPE_GETFONT] THEN self.writeLine('               *GetFontBase = NULL,')
  IF self.libsused[TYPE_GETSCREENMODE] THEN self.writeLine('               *GetScreenModeBase = NULL,')
  IF self.libsused[TYPE_INTEGER] THEN self.writeLine('               *IntegerBase = NULL,')
  IF self.libsused[TYPE_PALETTE] THEN self.writeLine('               *PaletteBase = NULL,')
  IF self.libsused[TYPE_LISTBROWSER] THEN self.writeLine('               *ListBrowserBase = NULL,')
  IF self.libsused[TYPE_RADIO] THEN self.writeLine('               *RadioButtonBase = NULL,')
  IF self.libsused[TYPE_SCROLLER] THEN self.writeLine('               *ScrollerBase = NULL,')
  IF self.libsused[TYPE_SPEEDBAR] THEN self.writeLine('               *SpeedBarBase = NULL,')
  IF self.libsused[TYPE_STRING] THEN self.writeLine('               *StringBase = NULL,')
  IF self.libsused[TYPE_SPACE] THEN self.writeLine('               *SpaceBase = NULL,')
  IF self.libsused[TYPE_TEXTFIELD] THEN self.writeLine('               *TextFieldBase = NULL,')
  IF self.libsused[TYPE_BEVEL] THEN self.writeLine('               *BevelBase = NULL,')
  IF self.libsused[TYPE_DRAWLIST] THEN self.writeLine('               *DrawListBase = NULL,')
  IF self.libsused[TYPE_GLYPH] THEN self.writeLine('               *GlyphBase = NULL,')
  IF self.libsused[TYPE_LABEL] THEN self.writeLine('               *LabelBase = NULL,')
  IF self.libsused[TYPE_BITMAP] THEN self.writeLine('               *BitMapBase = NULL,')
  IF self.libsused[TYPE_BOINGBALL] THEN self.writeLine('               *LabelBase = NULL,')
  IF self.libsused[TYPE_PENMAP] THEN self.writeLine('               *PenMapBase = NULL,')
  IF self.libsused[TYPE_COLORWHEEL] THEN self.writeLine('               *ColorWheelBase = NULL,')
  IF self.libsused[TYPE_DATEBROWSER] THEN self.writeLine('               *DateBrowserBase = NULL,')
  IF self.libsused[TYPE_GETCOLOR] THEN self.writeLine('               *GetColorBase = NULL,')
  IF self.libsused[TYPE_GRADSLIDER] THEN self.writeLine('               *GradientSliderBase = NULL,')
  IF self.libsused[TYPE_TAPEDECK] THEN self.writeLine('               *TapeDeckBase = NULL,')
  IF self.libsused[TYPE_TEXTEDITOR] THEN self.writeLine('               *TextEditorBase = NULL,')
  IF self.libsused[TYPE_LED] THEN self.writeLine('               *LedBase = NULL,')
  IF self.libsused[TYPE_LISTVIEW] THEN self.writeLine('               *ListViewBase = NULL,')
  IF self.libsused[TYPE_VIRTUAL] THEN self.writeLine('               *VirtualBase = NULL,')
  IF self.libsused[TYPE_SKETCH] THEN self.writeLine('               *SketchBoardBase = NULL,')
  IF self.libsused[TYPE_TABS] THEN self.writeLine('               *TabsBase = NULL,')
  self.writeLine('               *GadToolsBase = NULL,')
  self.writeLine('               *LayoutBase = NULL;')
  self.writeLine('struct IntuitionBase *IntuitionBase = NULL;')
  
  IF self.definitionOnly THEN RETURN
  
  self.writeLine('')
  self.writeLine('int setup( void )')
  self.writeLine('{')
  self.writeLine('  if( !(IntuitionBase = (struct IntuitionBase*) OpenLibrary("intuition.library",0L)) ) return 0;')
  self.writeLine('  if( !(GadToolsBase = (struct Library*) OpenLibrary("gadtools.library",0L) ) ) return 0;')
  self.writeLine('  if( !(WindowBase = (struct Library*) OpenLibrary("window.class",0L) ) ) return 0;')
  IF hasarexx
    self.writeLine('  if( !(ARexxBase = (struct Library*) OpenLibrary("arexx.class",0L) ) ) return 0;')
  ENDIF
  self.writeLine('  if( !(LayoutBase = (struct Library*) OpenLibrary("gadgets/layout.gadget",0L) ) ) return 0;')

  IF self.libsused[TYPE_BUTTON]
    self.writeLine('  if( !(ButtonBase = (struct Library*) OpenLibrary("gadgets/button.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_CHECKBOX]
    self.writeLine('  if( !(CheckBoxBase = (struct Library*) OpenLibrary("gadgets/checkbox.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_CHOOSER]
    self.writeLine('  if( !(ChooserBase = (struct Library*) OpenLibrary("gadgets/chooser.gadget",0L) ) ) return 0;')
  ENDIF
  
  IF self.libsused[TYPE_CLICKTAB]
    self.writeLine('  if( !(ClickTabBase = (struct Library*) OpenLibrary("gadgets/clicktab.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_FUELGAUGE]
    self.writeLine('  if( !(FuelGaugeBase = (struct Library*) OpenLibrary("gadgets/fuelgauge.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_GETFILE]
    self.writeLine('  if( !(GetFileBase = (struct Library*) OpenLibrary("gadgets/getfile.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_GETFONT]
    self.writeLine('  if( !(GetFontBase = (struct Library*) OpenLibrary("gadgets/getfont.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_GETSCREENMODE]
    self.writeLine('  if( !(GetScreenModeBase = (struct Library*) OpenLibrary("gadgets/getscreenmode.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_INTEGER]
    self.writeLine('  if( !(IntegerBase = (struct Library*) OpenLibrary("gadgets/integer.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_PALETTE]
    self.writeLine('  if( !(PaletteBase = (struct Library*) OpenLibrary("gadgets/palette.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_LISTBROWSER]
    self.writeLine('  if( !(ListBrowserBase = (struct Library*) OpenLibrary("gadgets/listbrowser.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_RADIO]
    self.writeLine('  if( !(RadioButtonBase = (struct Library*) OpenLibrary("gadgets/radiobutton.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_SCROLLER]
    self.writeLine('  if( !(ScrollerBase = (struct Library*) OpenLibrary("gadgets/scroller.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_SPEEDBAR]
    self.writeLine('  if( !(SpeedBarBase = (struct Library*) OpenLibrary("gadgets/speedbar.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_STRING]
    self.writeLine('  if( !(StringBase = (struct Library*) OpenLibrary("gadgets/string.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_SPACE]
    self.writeLine('  if( !(SpaceBase = (struct Library*) OpenLibrary("gadgets/space.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_TEXTFIELD]
    self.writeLine('  if( !(TextFieldBase = (struct Library*) OpenLibrary("gadgets/textfield.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_BEVEL]
    self.writeLine('  if( !(BevelBase = (struct Library*) OpenLibrary("images/bevel.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_DRAWLIST]
    self.writeLine('  if( !(DrawListBase = (struct Library*) OpenLibrary("images/drawlist.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_GLYPH]
    self.writeLine('  if( !(GlyphBase = (struct Library*) OpenLibrary("images/glyph.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_LABEL]
    self.writeLine('  if( !(LabelBase = (struct Library*) OpenLibrary("images/label.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_BITMAP]
    self.writeLine('  if( !(BitMapBase = (struct Library*) OpenLibrary("images/bitmap.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_PENMAP]
    self.writeLine('  if( !(PenMapBase = (struct Library*) OpenLibrary("images/penmap.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_COLORWHEEL]
    self.writeLine('  if( !(ColorWheelBase = (struct Library*) OpenLibrary("gadgets/colorwheel.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_DATEBROWSER]
    self.writeLine('  if( !(DateBrowserBase = (struct Library*) OpenLibrary("gadgets/datebrowser.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_GETCOLOR]
    self.writeLine('  if( !(GetColorBase = (struct Library*) OpenLibrary("gadgets/getcolor.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_GRADSLIDER]
    self.writeLine('  if( !(GradientSliderBase = (struct Library*) OpenLibrary("gadgets/gradientslider.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_TAPEDECK]
    self.writeLine('  if( !(TapeDeckBase = (struct Library*) OpenLibrary("gadgets/tapedeck.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_TEXTEDITOR]
    self.writeLine('  if( !(TextEditorBase = (struct Library*) OpenLibrary("gadgets/texteditor.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_LED]
    self.writeLine('  if( !(LedBase = (struct Library*) OpenLibrary("images/led.image",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_LISTVIEW]
    self.writeLine('  if( !(ListViewBase = (struct Library*) OpenLibrary("gadgest/listview.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_VIRTUAL]
    self.writeLine('  if( !(VirtualBase = (struct Library*) OpenLibrary("gadgets/virtual.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_SKETCH]
    self.writeLine('  if( !(SketchBoardBase = (struct Library*) OpenLibrary("gadgets/sketchboard.gadget",0L) ) ) return 0;')
  ENDIF

  IF self.libsused[TYPE_TABS]
    self.writeLine('  if( !(TabsBase = (struct Library*) OpenLibrary("gadgets/tabs.gadget",0L) ) ) return 0;')
  ENDIF

  self.genScreenCreate(screenObject)
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
  self.genScreenFree(screenObject)
  self.writeLine('')
  self.writeLine('  if (GadToolsBase) CloseLibrary( (struct Library *)GadToolsBase );')
  self.writeLine('  if (IntuitionBase) CloseLibrary( (struct Library *)IntuitionBase );')
  IF self.libsused[TYPE_BUTTON] THEN self.writeLine('  if (ButtonBase) CloseLibrary( (struct Library *)ButtonBase );')
  IF self.libsused[TYPE_CHECKBOX] THEN self.writeLine('  if (CheckBoxBase) CloseLibrary( (struct Library *)CheckBoxBase );')
  IF self.libsused[TYPE_CHOOSER] THEN self.writeLine('  if (ChooserBase) CloseLibrary( (struct Library *)ChooserBase );')
  IF self.libsused[TYPE_CLICKTAB] THEN self.writeLine('  if (ClickTabBase) CloseLibrary( (struct Library *)ClickTabBase );')
  IF self.libsused[TYPE_FUELGAUGE] THEN self.writeLine('  if (FuelGaugeBase) CloseLibrary( (struct Library *)FuelGaugeBase );')
  IF self.libsused[TYPE_GETFILE] THEN self.writeLine('  if (GetFileBase) CloseLibrary( (struct Library *)GetFileBase );')
  IF self.libsused[TYPE_GETFONT] THEN self.writeLine('  if (GetFontBase) CloseLibrary( (struct Library *)GetFontBase );')
  IF self.libsused[TYPE_GETSCREENMODE] THEN self.writeLine('  if (GetScreenModeBase) CloseLibrary( (struct Library *)GetScreenModeBase );')
  IF self.libsused[TYPE_INTEGER] THEN self.writeLine('  if (IntegerBase) CloseLibrary( (struct Library *)IntegerBase );')
  IF self.libsused[TYPE_PALETTE] THEN self.writeLine('  if (PaletteBase) CloseLibrary( (struct Library *)PaletteBase );')
  IF self.libsused[TYPE_LISTBROWSER] THEN self.writeLine('  if (ListBrowserBase) CloseLibrary( (struct Library *)ListBrowserBase );')
  IF self.libsused[TYPE_RADIO] THEN self.writeLine('  if (RadioButtonBase) CloseLibrary( (struct Library *)RadioButtonBase );')
  IF self.libsused[TYPE_SCROLLER] THEN self.writeLine('  if (ScrollerBase) CloseLibrary( (struct Library *)ScrollerBase );')
  IF self.libsused[TYPE_SPEEDBAR] THEN self.writeLine('  if (SpeedBarBase) CloseLibrary( (struct Library *)SpeedBarBase );')
  IF self.libsused[TYPE_STRING] THEN self.writeLine('  if (StringBase) CloseLibrary( (struct Library *)StringBase );')
  IF self.libsused[TYPE_SPACE] THEN self.writeLine('  if (SpaceBase) CloseLibrary( (struct Library *)SpaceBase );')
  IF self.libsused[TYPE_TEXTFIELD] THEN self.writeLine('  if (ButtonBase) CloseLibrary( (struct Library *)TextFieldBase );')
  IF self.libsused[TYPE_BEVEL] THEN self.writeLine('  if (BevelBase) CloseLibrary( (struct Library *)BevelBase );')
  IF self.libsused[TYPE_DRAWLIST] THEN self.writeLine('  if (DrawListBase) CloseLibrary( (struct Library *)DrawListBase );')
  IF self.libsused[TYPE_GLYPH] THEN self.writeLine('  if (GlyphBase) CloseLibrary( (struct Library *)GlyphBase );')
  IF self.libsused[TYPE_LABEL] THEN self.writeLine('  if (LabelBase) CloseLibrary( (struct Library *)LabelBase );')
  IF self.libsused[TYPE_BITMAP] THEN self.writeLine('  if (BitMapBase) CloseLibrary( (struct Library *)BitMapBase );')
  IF self.libsused[TYPE_PENMAP] THEN self.writeLine('  if (PenMapBase) CloseLibrary( (struct Library *)PenMapBase );')

  IF self.libsused[TYPE_COLORWHEEL] THEN self.writeLine('  if (ColorWheelBase) CloseLibrary( (struct Library *)ColorWheelBase );')
  IF self.libsused[TYPE_DATEBROWSER] THEN self.writeLine('  if (DateBrowserBase) CloseLibrary( (struct Library *)DateBrowserBase );')
  IF self.libsused[TYPE_GETCOLOR] THEN self.writeLine('  if (GetColorBase) CloseLibrary( (struct Library *)GetColorBase );')
  IF self.libsused[TYPE_GRADSLIDER] THEN self.writeLine('  if (GradientSliderBase) CloseLibrary( (struct Library *)GradientSliderBase );')
  IF self.libsused[TYPE_TAPEDECK] THEN self.writeLine('  if (TapeDeckBase) CloseLibrary( (struct Library *)TapeDeckBase );')
  IF self.libsused[TYPE_TEXTEDITOR] THEN self.writeLine('  if (TextEditorBase) CloseLibrary( (struct Library *)TextEditorBase );')
  IF self.libsused[TYPE_LED] THEN self.writeLine('  if (LedBase) CloseLibrary( (struct Library *)LedBase );')
  IF self.libsused[TYPE_LISTVIEW] THEN self.writeLine('  if (ListViewBase) CloseLibrary( (struct Library *)ListViewBase );')
  IF self.libsused[TYPE_VIRTUAL] THEN self.writeLine('  if (VirtualBase) CloseLibrary( (struct Library *)VirtualBase );')
  IF self.libsused[TYPE_SKETCH] THEN self.writeLine('  if (SketchBoardBase) CloseLibrary( (struct Library *)SketchBoardBase );')
  IF self.libsused[TYPE_TABS] THEN self.writeLine('  if (TabsBase) CloseLibrary( (struct Library *)TabsBase );')
  self.writeLine('  if (LayoutBase) CloseLibrary( (struct Library *)LayoutBase );')
  self.writeLine('  if (WindowBase) CloseLibrary( (struct Library *)WindowBase );')
  IF hasarexx
    self.writeLine('  if (ARexxBase) CloseLibrary( (struct Library *)ARexxBase );')
  ENDIF

  self.writeLine('}')
  self.writeLine('')
  self.writeLine('void runWindow( Object *window_object, struct Menu *menu_strip )')
  self.writeLine('{')
  self.writeLine('  struct Window	*main_window = NULL;')
  IF hasarexx
    self.writeLine('  ULONG rxsig = 0;')
  ENDIF  
  self.writeLine('')
  self.writeLine('  if ( window_object )')
  self.writeLine('  {')
  self.writeLine('    if ( main_window = (struct Window *) RA_OpenWindow( window_object ))')
  self.writeLine('    {')
  self.writeLine('      WORD Code;')
  self.writeLine('      ULONG wait = 0, signal = 0, result = 0, done = FALSE;')
  self.writeLine('      GetAttr( WINDOW_SigMask, window_object, &signal );')
  IF hasarexx
    self.writeLine('      GetAttr( AREXX_SigMask, gArexxObject, &rxsig );')
    IF rexxObject.replyHook
      self.writeLine('')
      self.writeLine('      gArexxReplyHook.h_Entry = (HOOKFUNC) rexxReply_CallBack;')
      self.writeLine('      gArexxReplyHook.h_SubEntry = NULL;')
      self.writeLine('      gArexxReplyHook.h_Data = NULL;')
      self.writeLine('')
    ENDIF
  ENDIF

  self.writeLine('      if ( menu_strip)  SetMenuStrip( main_window, menu_strip );')
  self.writeLine('      while ( !done)')
  self.writeLine('      {')
  IF hasarexx
    self.writeLine('        wait = Wait( signal | rxsig | SIGBREAKF_CTRL_C );')
    self.writeLine('')
    self.writeLine('      if ( wait & rxsig) RA_HandleRexx(gArexxObject);')
    self.writeLine('')
  ELSE
    self.writeLine('        wait = Wait( signal | SIGBREAKF_CTRL_C );')
  ENDIF


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
  DEF i,j
  DEF menuItem:PTR TO menuItem
  DEF itemType
  DEF itemName[200]:STRING
  DEF commKey[10]:STRING
  DEF directiveStr[20]:STRING
  DEF listObjects:PTR TO stdlist
  DEF listObjects2:PTR TO stdlist
  DEF reactionObject:PTR TO reactionObject
  DEF drawlistObject:PTR TO drawListObject
  DEF listbObject:PTR TO listBrowserObject
  DEF listStr
  DEF drawlist:PTR TO drawlist

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
  layoutObject.findObjectsByType(listObjects,TYPE_SPEEDBAR)
  layoutObject.findObjectsByType(listObjects,TYPE_LISTVIEW)
  layoutObject.findObjectsByType(listObjects,TYPE_TABS)

  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    IF reactionObject.type=TYPE_SPEEDBAR
      StringF(tempStr,'  struct List *buttons\d;',reactionObject.id)
      self.writeLine(tempStr)
    ELSEIF reactionObject.type<>TYPE_TABS
      StringF(tempStr,'  struct List *labels\d;',reactionObject.id)
      self.writeLine(tempStr)
    ENDIF
      
    SELECT reactionObject.type
      CASE TYPE_CHOOSER
        StringF(tempStr,'  UBYTE *labels\d_str[] = ',reactionObject.id)
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::chooserObject.listObjectId)
      CASE TYPE_RADIO
        StringF(tempStr,'  UBYTE *labels\d_str[] = ',reactionObject.id)
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::radioObject.listObjectId)
      CASE TYPE_CLICKTAB
        StringF(tempStr,'  UBYTE *labels\d_str[] = ',reactionObject.id)     
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::clickTabObject.listObjectId)
      CASE TYPE_LISTBROWSER
        StringF(tempStr,'  UBYTE *labels\d_str[] = ',reactionObject.id)     
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::listBrowserObject.listObjectId)
      CASE TYPE_SPEEDBAR
        StringF(tempStr,'  UBYTE *buttons\d_str[] = ',reactionObject.id)     
        listStr:=self.makeList2(tempStr,reactionObject::speedBarObject.buttonList)
      CASE TYPE_LISTVIEW
        StringF(tempStr,'  UBYTE *labels\d_str[] = ',reactionObject.id)     
        listStr:=self.makeList(tempStr,reactionLists,reactionObject::listViewObject.listObjectId)
      CASE TYPE_TABS
        StringF(tempStr,'  TabLabel labels\d ',reactionObject.id)     
        StrAdd(tempStr,'[] =')
        listStr:=self.makeList3(tempStr,reactionLists,reactionObject::tabsObject.listObjectId)
    ENDSELECT
    
    IF listStr
      self.writeLine(listStr)
      DisposeLink(listStr)
    ELSE
      StringF(tempStr,'  UBYTE *labels\d_str[] = { NULL };',reactionObject.id)
      self.writeLine(tempStr)
    ENDIF
  ENDFOR

  NEW listObjects2.stdlist(20)
  layoutObject.findObjectsByType(listObjects2,TYPE_DRAWLIST)
  FOR i:=0 TO listObjects2.count()-1
    drawlistObject:=listObjects2.item(i)
    StringF(tempStr,'  struct DrawList DLST_DrawList\d',drawlistObject.id)
    StrAdd(tempStr,'[] = ')
    self.writeLine(tempStr)
    self.writeLine('  {')
    FOR j:=0 TO drawlistObject.drawItemsList.count()-1
      drawlist:=drawlistObject.drawItemsList.item(j)
      EXIT drawlist.directive=DLST_END
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
      StringF(tempStr,'    { \s, \d, \d, \d, \d, \d },',directiveStr,drawlist.x1, drawlist.y1, drawlist.x2, drawlist.y2, drawlist.pen)
      self.writeLine(tempStr)
    ENDFOR
    self.writeLine('    { DLST_END, 0, 0, 0, 0, 0 },')
    self.writeLine('  };')
    self.writeLine('')
  ENDFOR
  IF self.libsused[TYPE_LED]
    self.writeLine('  int ledValues[4]={12,34,56,78};')  
    self.writeLine('')
  ENDIF
  

  listObjects2.clear()
  layoutObject.findObjectsByType(listObjects2,TYPE_LISTBROWSER)
  FOR i:=0 TO listObjects2.count()-1
    listbObject:=listObjects2.item(i)
    IF listbObject.columnTitles
      StringF(tempStr,'  struct ColumnInfo ListBrowser\d_ci[] =',listbObject.id)
      self.writeLine(tempStr)
      self.writeLine('  {')
      FOR j:=0 TO listbObject.numColumns-1
        StringF(tempStr,'    { \d, \q\s\q, 0 },',IF j<listbObject.colWidths.count() THEN listbObject.colWidths.item(j) ELSE 1,IF j<listbObject.colTitles.count() THEN listbObject.colTitles.item(j) ELSE '')
        self.writeLine(tempStr)
      ENDFOR
      self.writeLine('    { -1, (STRPTR)~0, -1 }')
      self.writeLine('  };')
      self.writeLine('')
    ENDIF
  ENDFOR
  END listObjects2

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
      CASE TYPE_SPEEDBAR
        StringF(tempStr,'  buttons\d = SpeedBarNodesA( buttons\d_str );',reactionObject.id,reactionObject.id)
      CASE TYPE_LISTVIEW
        StringF(tempStr,'  labels\d = ListViewLabelsA( labels\d_str );',reactionObject.id,reactionObject.id)
      CASE TYPE_TABS
        StrCopy(tempStr,'')
    ENDSELECT
    IF EstrLen(tempStr) THEN self.writeLine(tempStr)
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

  IF self.definitionOnly
    self.writeLine('}')
    self.writeLine('')
    RETURN
  ENDIF

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
  layoutObject.findObjectsByType(listObjects,TYPE_LISTVIEW)
  FOR i:=0 TO listObjects.count()-1
    reactionObject:=listObjects.item(i)
    SELECT reactionObject.type
      CASE TYPE_CHOOSER
        StringF(tempStr,'  if ( labels\d ) FreeChooserLabels( labels\d );',reactionObject.id,reactionObject.id)
      CASE TYPE_RADIO
        StringF(tempStr,'  if ( labels\d ) FreeRadioButtons( labels\d );',reactionObject.id, reactionObject.id)
      CASE TYPE_CLICKTAB
        StringF(tempStr,'  if ( labels\d ) FreeClickTabs( labels\d );',reactionObject.id,reactionObject.id)
      CASE TYPE_LISTBROWSER
        StringF(tempStr,'  if ( labels\d ) FreeBrowserNodes( labels\d );',reactionObject.id,reactionObject.id)
      CASE TYPE_SPEEDBAR
        StringF(tempStr,'  if ( buttons\d ) FreeSpeedBarNodesNodes( buttons\d );',reactionObject.id,reactionObject.id)
      CASE TYPE_LISTVIEW
        StringF(tempStr,'  if ( labels\d ) FreeListViewLabels( labels\d );',reactionObject.id,reactionObject.id)
    ENDSELECT
    self.writeLine(tempStr)
  ENDFOR
  END listObjects


  
  self.writeLine('}')
  self.writeLine('')
ENDPROC

PROC genFooter(windowObject:PTR TO windowObject, rexxObject:PTR TO rexxObject) OF cSrcGen
  DEF tempStr[200]:STRING
  DEF hasarexx,i
  
  IF self.definitionOnly THEN RETURN

  hasarexx:=(rexxObject.commands.count()>0) AND (StrLen(rexxObject.hostName)>0)
  IF hasarexx
    IF rexxObject.replyHook
      self.writeLine('void __SAVE_DS__ rexxReply_CallBack(struct Hook *hook, Object *object, struct RexxMsg *rxm)')
      self.writeLine('{')
      self.writeLine('}')
      self.writeLine('')
    ENDIF
    FOR i:=0 TO rexxObject.commands.count()-1
      StrCopy(tempStr,rexxObject.commands.item(i))
      LowerStr(tempStr)
      StringF(tempStr,'void __SAVE_DS__ __ASM__ rexx_\s',tempStr)

      StrAdd(tempStr,'(__REG__(a0,struct ARexxCmd *ac), __REG__(a1,struct RexxMsg *rxm))')
      self.writeLine(tempStr)
      self.writeLine('{')
      self.writeLine('}')
      self.writeLine('')
    ENDFOR
  ENDIF
    
  self.writeLine('int main( int argc, char **argv )')
  self.writeLine('{')
  self.writeLine('  if ( setup() )')
  self.writeLine('  {')

  IF hasarexx  
    self.writeLine('    gArexxObject = ARexxObject,')
    StrCopy(tempStr,rexxObject.hostName)
    UpperStr(tempStr)
    StringF(tempStr,'      AREXX_HostName, \q\s\q,',tempStr)
    self.writeLine(tempStr)
    self.writeLine('      AREXX_Commands, gRxCommands,')
    IF rexxObject.noSlot
      self.writeLine('      AREXX_NoSlot, TRUE,')
    ENDIF
    IF rexxObject.replyHook
      self.writeLine('      AREXX_ReplyHook, &gArexxReplyHook,')
    ENDIF
    
    IF StrLen(rexxObject.extension)>0
      StringF(tempStr,'      AREXX_DefExtension, \q\s\q,',rexxObject.extension)
      self.writeLine(tempStr)
    ENDIF
    self.writeLine('    End;')
    self.writeLine('    if ( !gArexxObject )')
    self.writeLine('    {')
    self.writeLine('      cleanup();')
    self.writeLine('      return -2;')
    self.writeLine('    }')
    self.writeLine('')
  ENDIF
    
  
  StringF(tempStr,'    \s',windowObject.name)
  LowerStr(tempStr)
  StrAdd(tempStr,'();')
  self.writeLine(tempStr)
  self.writeLine('  }')

  IF hasarexx
    self.writeLine('  if ( gArexxObject) DisposeObject( gArexxObject );')
  ENDIF
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
  self.currentGadgetVar:=index 
ENDPROC

PROC componentLibnameCreate(libname:PTR TO CHAR) OF cSrcGen
  DEF tempStr[200]:STRING
  StringF(tempStr,'NewObject( NULL, \q\s\q,',libname)
  self.componentCreate(tempStr)
ENDPROC

PROC componentLibtypeCreate(libtype:PTR TO CHAR) OF cSrcGen
  DEF tempStr[200]:STRING
  StringF(tempStr,'NewObject( \s, NULL, ',libtype)
  self.componentCreate(tempStr)
ENDPROC

PROC genScreenCreate(screenObject:PTR TO screenObject) OF cSrcGen
  DEF tempStr[200]:STRING
  IF (screenObject.public=FALSE) AND (screenObject.custom=FALSE)
    self.writeLine('  if( !(gScreen = LockPubScreen( 0 ) ) ) return 0;')
  ELSEIF (screenObject.public) AND (screenObject.custom=FALSE)
    StringF(tempStr,'  if( !(gScreen = LockPubScreen( \q\s\q ) ) ) return 0;',screenObject.publicname)
    self.writeLine(tempStr)
  ELSE
    self.writeLine('  if (!( gScreen = OpenScreenTags( 0,')
    self.indent:=8
    screenObject.genCodeProperties(self)
    self.indent:=0
    self.writeLine('        TAG_END ) ) ) return 0;')
  ENDIF
ENDPROC

PROC genScreenFree(screenObject:PTR TO screenObject) OF cSrcGen
  DEF tempStr[200]:STRING
  IF (screenObject.public=FALSE) AND (screenObject.custom=FALSE)
    self.writeLine('  if ( gScreen ) UnlockPubScreen( 0, gScreen );')
  ELSEIF (screenObject.public) AND (screenObject.custom=FALSE)
    StringF(tempStr,'  if ( gScreen ) UnlockPubScreen( \q\s\q, gScreen );',screenObject.publicname)
    self.writeLine(tempStr)
  ELSE
    self.writeLine('  if ( gScreen ) CloseScreen( gScreen );')
  ENDIF
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

PROC makeList3(start:PTR TO CHAR,reactionLists:PTR TO stdlist, listid) OF cSrcGen
  DEF res=0
  DEF totsize=0
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
      totsize:=totsize+EstrLen(listitem.items.item(i))+22
    ENDFOR
    res:=String(totsize+30)
    StrCopy(res,start)
    StrAdd(res,'\n  {\n')
    FOR i:=0 TO listitem.items.count()-1
      StrAdd(res,'    {\q')
      StrAdd(res,listitem.items.item(i))
      StrAdd(res,'\q, -1, -1, -1, -1},\n')
    ENDFOR
    StrAdd(res,'    NULL\n  };')
  ENDIF
  
ENDPROC res

PROC makeList2(start:PTR TO CHAR,list:PTR TO stringlist) OF cSrcGen
  DEF res=0
  DEF totsize=0,linelen=0
  DEF i

  totsize:=StrLen(start)
  FOR i:=0 TO list.count()-1
    linelen:=linelen+EstrLen(list.item(i))+4
    IF linelen>90
      linelen:=0
      totsize:=totsize+5
    ENDIF
    totsize:=totsize+EstrLen(list.item(i))+4
  ENDFOR
  res:=String(totsize+10)
  StrCopy(res,start)
  StrAdd(res,'{ ')
  linelen:=0
  FOR i:=0 TO list.count()-1
    StrAdd(res,'\q')
    StrAdd(res,list.item(i))
    StrAdd(res,'\q, ')
    linelen:=linelen+EstrLen(list.item(i))+4
    IF linelen>90
      linelen:=0
      StrAdd(res,'\n    ')
    ENDIF
  ENDFOR
  StrAdd(res,' NULL };') 
ENDPROC res
