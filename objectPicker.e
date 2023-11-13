OPT MODULE

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionForm'


EXPORT ENUM OBJECT_BUTTON=0, OBJECT_BITMAP, OBJECT_CHECKBOX, OBJECT_CHOOSER, 
            OBJECT_CLICKTAB, OBJECT_FUELGAUGE, OBJECT_GETFILE, OBJECT_GETFONT,
            OBJECT_GETSCREENMODE, OBJECT_INTEGER, OBJECT_PALETTE, OBJECT_PENMAP,
            OBJECT_LAYOUT, OBJECT_LISTBROWSER, OBJECT_RADIO, OBJECT_SCROLLER,
            OBJECT_SPEEDBAR, OBJECT_SLIDER, OBJECT_STATUSBAR, OBJECT_STRING,
            OBJECT_SPACE, OBJECT_TEXTFIELD, OBJECT_BEVEL, OBJECT_DRAWLIST,
            OBJECT_GLYPH, OBJECT_LABEL,


//these are definied for the future
            OBJECT_COLORWHEEL, OBJECT_DATEBROWSER, OBJECT_GETCOLOR, OBJECT_GRADSLIDER,
            OBJECT_LISTVIEW, OBJECT_PAGE, OBJECT_PROGRESS, OBJECT_SKETCH,OBJECT_TAPEDECK,
            OBJECT_TEXTEDITOR, OBJECT_TEXTENTRY, OBJECT_VIRTUAL, OBJECT_BOINGBALL, OBJECT_LED,
            OBJECT_PENMAP, OBJECT_SMARTBITMAP, OBJECT_TITLEBAR,
           
            
            BTNCANCEL

EXPORT CONST NUM_OBJECT_TYPES=OBJECT_LABEL+1

CONST NUMGADS=BTNCANCEL+1

EXPORT OBJECT objectPickerForm OF reactionForm
  selectedItem:LONG
ENDOBJECT

PROC gadgetClick(nself,gadget,id,code) OF objectPickerForm
  self:=nself

  self.modalResult:=MR_OK
  self.selectedItem:=id
ENDPROC

EXPORT PROC create() OF objectPickerForm
  DEF gads:PTR TO LONG
  DEF i
  
  NEW gads[NUMGADS]
  self.gadgetList:=gads
  NEW gads[NUMGADS]
  self.gadgetActions:=gads

  self.windowObj:=WindowObject,
    WA_TITLE, 'Select an object to add',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
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
        LAYOUT_SHRINKWRAP, TRUE,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_SPACEINNER, FALSE,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_BUTTON]:=ButtonObject,
            GA_ID, OBJECT_BUTTON,
            GA_TEXT, 'Button',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_BITMAP]:=ButtonObject,
            GA_ID, OBJECT_BITMAP,
            GA_TEXT, 'Bitmap',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_CHECKBOX]:=ButtonObject,
            GA_ID, OBJECT_CHECKBOX,
            GA_TEXT, 'CheckBox',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_CHOOSER]:=ButtonObject,
            GA_ID, OBJECT_CHOOSER,
            GA_TEXT, 'Chooser',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_SPACEINNER, FALSE,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_CLICKTAB]:=ButtonObject,
            GA_ID, OBJECT_CLICKTAB,
            GA_TEXT, 'ClickTab',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_FUELGAUGE]:=ButtonObject,
            GA_ID, OBJECT_FUELGAUGE,
            GA_TEXT, 'FuelGauge',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_GETFILE]:=ButtonObject,
            GA_ID, OBJECT_GETFILE,
            GA_TEXT, 'GetFile',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_GETFONT]:=ButtonObject,
            GA_ID, OBJECT_GETFONT,
            GA_TEXT, 'GetFont',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_SPACEINNER, FALSE,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_GETSCREENMODE]:=ButtonObject,
            GA_ID, OBJECT_GETSCREENMODE,
            GA_TEXT, 'GetScreenMode',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_INTEGER]:=ButtonObject,
            GA_ID, OBJECT_INTEGER,
            GA_TEXT, 'Integer',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_PALETTE]:=ButtonObject,
            GA_ID, OBJECT_PALETTE,
            GA_TEXT, 'Palette',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_PENMAP]:=ButtonObject,
            GA_ID, OBJECT_PENMAP,
            GA_TEXT, 'PenMap',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_SPACEINNER, FALSE,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_LAYOUT]:=ButtonObject,
            GA_ID, OBJECT_LAYOUT,
            GA_TEXT, 'Layout',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_LISTBROWSER]:=ButtonObject,
            GA_ID, OBJECT_LISTBROWSER,
            GA_TEXT, 'ListBrowser',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_RADIO]:=ButtonObject,
            GA_ID, OBJECT_RADIO,
            GA_TEXT, 'RadioButton',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_SCROLLER]:=ButtonObject,
            GA_ID, OBJECT_SCROLLER,
            GA_TEXT, 'Scroller',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_SPACEINNER, FALSE,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_SPEEDBAR]:=ButtonObject,
            GA_ID, OBJECT_SPEEDBAR,
            GA_TEXT, 'SpeedBar',
            GA_DISABLED,TRUE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_SLIDER]:=ButtonObject,
            GA_ID, OBJECT_SLIDER,
            GA_TEXT, 'Slider',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_STATUSBAR]:=ButtonObject,
            GA_ID, OBJECT_STATUSBAR,
            GA_TEXT, 'StatusBar',
            GA_DISABLED,TRUE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_STRING]:=ButtonObject,
            GA_ID, OBJECT_STRING,
            GA_TEXT, 'String',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_SPACEINNER, FALSE,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_SPACE]:=ButtonObject,
            GA_ID, OBJECT_SPACE,
            GA_TEXT, 'Space',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_TEXTFIELD]:=ButtonObject,
            GA_ID, OBJECT_TEXTFIELD,
            GA_TEXT, 'TextField',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_BEVEL]:=ButtonObject,
            GA_ID, OBJECT_BEVEL,
            GA_TEXT, 'Bevel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_DRAWLIST]:=ButtonObject,
            GA_ID, OBJECT_DRAWLIST,
            GA_TEXT, 'DrawList',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_SPACEINNER, FALSE,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_GLYPH]:=ButtonObject,
            GA_ID, OBJECT_GLYPH,
            GA_TEXT, 'Glyph',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_LABEL]:=ButtonObject,
            GA_ID, OBJECT_LABEL,
            GA_TEXT, 'Label',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,self.gadgetList[OBJECT_BOINGBALL]:=ButtonObject,
            GA_ID, OBJECT_BOINGBALL,
            GA_TEXT, 'BoingBall',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_SPACEINNER, FALSE,

          LAYOUT_ADDCHILD,self.gadgetList[BTNCANCEL]:=ButtonObject,
            GA_ID, BTNCANCEL,
            GA_TEXT, 'Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  FOR i:=0 TO BTNCANCEL-1
    self.gadgetActions[i]:={gadgetClick}
  ENDFOR
  self.gadgetActions[BTNCANCEL]:=MR_CANCEL
ENDPROC

PROC end() OF objectPickerForm
  END self.gadgetList[NUMGADS]
  END self.gadgetActions[NUMGADS]
ENDPROC

EXPORT PROC selectItem() OF  objectPickerForm
  IF self.showModal()=MR_OK
    RETURN self.selectedItem
  ENDIF
ENDPROC -1
