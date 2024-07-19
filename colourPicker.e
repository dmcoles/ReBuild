OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'palette','gadgets/palette',
        'images/bevel',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionForm'

EXPORT ENUM COLOURPICK_SELECTOR, COLOURPICK_OK, COLOURPICK_CANCEL

CONST NUMGADS=COLOURPICK_CANCEL+1

EXPORT OBJECT colourPickerForm OF reactionForm
PRIVATE
  selectedColour:LONG
ENDOBJECT

EXPORT PROC create() OF colourPickerForm
  DEF gads:PTR TO LONG
  DEF i
  
  NEW gads[NUMGADS]
  self.gadgetList:=gads
  NEW gads[NUMGADS]
  self.gadgetActions:=gads

  self.windowObj:=WindowObject,
    WA_TITLE, 'Select a Colour',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 180,
    WA_WIDTH, 250,
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
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDCHILD,self.gadgetList[COLOURPICK_SELECTOR]:=PaletteObject,
          GA_ID, COLOURPICK_SELECTOR,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          PALETTE_COLOUR, 0,
          PALETTE_COLOUROFFSET, 0,
          PALETTE_NUMCOLOURS, 256,
        PaletteEnd,
  
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[COLOURPICK_OK]:=ButtonObject,
            GA_ID, COLOURPICK_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
  
          LAYOUT_ADDCHILD,self.gadgetList[COLOURPICK_CANCEL]:=ButtonObject,
            GA_ID, COLOURPICK_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd
  self.gadgetActions[COLOURPICK_OK]:=MR_OK
  self.gadgetActions[COLOURPICK_CANCEL]:=MR_CANCEL
ENDPROC

PROC end() OF colourPickerForm
  END self.gadgetList[NUMGADS]
  END self.gadgetActions[NUMGADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC selectColour(current) OF colourPickerForm
  SetGadgetAttrsA(self.gadgetList[ COLOURPICK_SELECTOR ],0,0,[PALETTE_COLOUR,current,0])

  IF self.showModal()=MR_OK
    RETURN Gets(self.gadgetList[ COLOURPICK_SELECTOR ],PALETTE_COLOUR)
  ENDIF
ENDPROC -1


