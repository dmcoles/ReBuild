OPT MODULE

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'clicktab','gadgets/clicktab',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionForm','*reactionObject'


CONST BTNCANCEL=TYPE_MAX, BTNCANCEL2=TYPE_MAX+1, PAGECTRL=TYPE_MAX+2

CONST NUMGADS=PAGECTRL+1

EXPORT OBJECT objectPickerForm OF reactionForm
PRIVATE
  selectedItem:LONG
  ->tabs1:PTR TO LONG
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
      LAYOUT_SPACEINNER,FALSE,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BUTTON]:=ButtonObject,
                GA_ID, TYPE_BUTTON,
                GA_TEXT, 'Button',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_CHECKBOX]:=ButtonObject,
                GA_ID, TYPE_CHECKBOX,
                GA_TEXT, 'CheckBox',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_CHOOSER]:=ButtonObject,
                GA_ID, TYPE_CHOOSER,
                GA_TEXT, 'Chooser',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_CLICKTAB]:=ButtonObject,
                GA_ID, TYPE_CLICKTAB,
                GA_TEXT, 'ClickTab',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_COLORWHEEL]:=ButtonObject,
                GA_ID, TYPE_COLORWHEEL,
                GA_TEXT, 'ColorWheel',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,              
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_DATEBROWSER]:=ButtonObject,
                GA_ID, TYPE_DATEBROWSER,
                GA_TEXT, 'DateBrowser',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_FUELGAUGE]:=ButtonObject,
                GA_ID, TYPE_FUELGAUGE,
                GA_TEXT, 'FuelGauge',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETCOLOR]:=ButtonObject,
                GA_ID, TYPE_GETCOLOR,
                GA_TEXT, 'GetColor',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETFILE]:=ButtonObject,
                GA_ID, TYPE_GETFILE,
                GA_TEXT, 'GetFile',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd, 
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETFONT]:=ButtonObject,
                GA_ID, TYPE_GETFONT,
                GA_TEXT, 'GetFont',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,              
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
              
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETSCREENMODE]:=ButtonObject,
                GA_ID, TYPE_GETSCREENMODE,
                GA_TEXT, 'GetScreenMode',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GRADSLIDER]:=ButtonObject,
                GA_ID, TYPE_GRADSLIDER,
                GA_TEXT, 'GradientSlider',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_INTEGER]:=ButtonObject,
                GA_ID, TYPE_INTEGER,
                GA_TEXT, 'Integer',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LAYOUT]:=ButtonObject,
                GA_ID, TYPE_LAYOUT,
                GA_TEXT, 'Layout',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,              
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LISTBROWSER]:=ButtonObject,
                GA_ID, TYPE_LISTBROWSER,
                GA_TEXT, 'ListBrowser',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LISTVIEW]:=ButtonObject,
                GA_ID, TYPE_LISTVIEW,
                GA_TEXT, 'ListView',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_PALETTE]:=ButtonObject,
                GA_ID, TYPE_PALETTE,
                GA_TEXT, 'Palette',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_RADIO]:=ButtonObject,
                GA_ID, TYPE_RADIO,
                GA_TEXT, 'RadioButton',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SCROLLER]:=ButtonObject,
                GA_ID, TYPE_SCROLLER,
                GA_TEXT, 'Scroller',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,


              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SKETCH]:=ButtonObject,
                GA_ID, TYPE_SKETCH,
                GA_TEXT, 'SketchBoard',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SLIDER]:=ButtonObject,
                GA_ID, TYPE_SLIDER,
                GA_TEXT, 'Slider',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SPEEDBAR]:=ButtonObject,
                GA_ID, TYPE_SPEEDBAR,
                GA_TEXT, 'SpeedBar',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_STRING]:=ButtonObject,
                GA_ID, TYPE_STRING,
                GA_TEXT, 'String',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SPACE]:=ButtonObject,
                GA_ID, TYPE_SPACE,
                GA_TEXT, 'Space',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TABS]:=ButtonObject,
                GA_ID, TYPE_TABS,
                GA_TEXT, 'Tabs',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TAPEDECK]:=ButtonObject,
                GA_ID, TYPE_TAPEDECK,
                GA_TEXT, 'TapeDeck',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TEXTEDITOR]:=ButtonObject,
                GA_ID, TYPE_TEXTEDITOR,
                GA_TEXT, 'TextEditor',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TEXTFIELD]:=ButtonObject,
                GA_ID, TYPE_TEXTFIELD,
                GA_TEXT, 'TextField',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_VIRTUAL]:=ButtonObject,
                GA_ID, TYPE_VIRTUAL,
                GA_TEXT, 'Virtual',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,              
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BEVEL]:=ButtonObject,
                GA_ID, TYPE_BEVEL,
                GA_TEXT, 'Bevel',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BITMAP]:=ButtonObject,
                GA_ID, TYPE_BITMAP,
                GA_TEXT, 'Bitmap',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BOINGBALL]:=ButtonObject,
                GA_ID, TYPE_BOINGBALL,
                GA_TEXT, 'BoingBall',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_DRAWLIST]:=ButtonObject,
                GA_ID, TYPE_DRAWLIST,
                GA_TEXT, 'DrawList',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GLYPH]:=ButtonObject,
                GA_ID, TYPE_GLYPH,
                GA_TEXT, 'Glyph',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LABEL]:=ButtonObject,
                GA_ID, TYPE_LABEL,
                GA_TEXT, 'Label',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LED]:=ButtonObject,
                GA_ID, TYPE_LED,
                GA_TEXT, 'LED',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_PENMAP]:=ButtonObject,
                GA_ID, TYPE_PENMAP,
                GA_TEXT, 'PenMap',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
              LAYOUT_SPACEINNER, FALSE,

              LAYOUT_ADDCHILD,self.gadgetList[BTNCANCEL2]:=ButtonObject,
                GA_ID, BTNCANCEL2,
                GA_TEXT, 'Cancel',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

      /*LAYOUT_ADDCHILD, ClickTabObject, 
        GA_ID, PAGECTRL,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        CLICKTAB_LABELS, self.tabs1:=clickTabsA(['Standard','More',0]),
        CLICKTAB_PAGEGROUP, PageObject,
          
          LAYOUT_DEFERLAYOUT, TRUE,
          PAGE_ADD, VLayoutObject,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BUTTON]:=ButtonObject,
                GA_ID, TYPE_BUTTON,
                GA_TEXT, 'Button',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BITMAP]:=ButtonObject,
                GA_ID, TYPE_BITMAP,
                GA_TEXT, 'Bitmap',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_CHECKBOX]:=ButtonObject,
                GA_ID, TYPE_CHECKBOX,
                GA_TEXT, 'CheckBox',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_CHOOSER]:=ButtonObject,
                GA_ID, TYPE_CHOOSER,
                GA_TEXT, 'Chooser',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_CLICKTAB]:=ButtonObject,
                GA_ID, TYPE_CLICKTAB,
                GA_TEXT, 'ClickTab',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_FUELGAUGE]:=ButtonObject,
                GA_ID, TYPE_FUELGAUGE,
                GA_TEXT, 'FuelGauge',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETFILE]:=ButtonObject,
                GA_ID, TYPE_GETFILE,
                GA_TEXT, 'GetFile',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETFONT]:=ButtonObject,
                GA_ID, TYPE_GETFONT,
                GA_TEXT, 'GetFont',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETSCREENMODE]:=ButtonObject,
                GA_ID, TYPE_GETSCREENMODE,
                GA_TEXT, 'GetScreenMode',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_INTEGER]:=ButtonObject,
                GA_ID, TYPE_INTEGER,
                GA_TEXT, 'Integer',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_PALETTE]:=ButtonObject,
                GA_ID, TYPE_PALETTE,
                GA_TEXT, 'Palette',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_PENMAP]:=ButtonObject,
                GA_ID, TYPE_PENMAP,
                GA_TEXT, 'PenMap',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LAYOUT]:=ButtonObject,
                GA_ID, TYPE_LAYOUT,
                GA_TEXT, 'Layout',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LISTBROWSER]:=ButtonObject,
                GA_ID, TYPE_LISTBROWSER,
                GA_TEXT, 'ListBrowser',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_RADIO]:=ButtonObject,
                GA_ID, TYPE_RADIO,
                GA_TEXT, 'RadioButton',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SCROLLER]:=ButtonObject,
                GA_ID, TYPE_SCROLLER,
                GA_TEXT, 'Scroller',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SPEEDBAR]:=ButtonObject,
                GA_ID, TYPE_SPEEDBAR,
                GA_TEXT, 'SpeedBar',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SLIDER]:=ButtonObject,
                GA_ID, TYPE_SLIDER,
                GA_TEXT, 'Slider',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_STATUSBAR]:=ButtonObject,
                GA_ID, TYPE_STATUSBAR,
                GA_TEXT, 'StatusBar',
                GA_DISABLED,TRUE,
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_STRING]:=ButtonObject,
                GA_ID, TYPE_STRING,
                GA_TEXT, 'String',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SPACE]:=ButtonObject,
                GA_ID, TYPE_SPACE,
                GA_TEXT, 'Space',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TEXTFIELD]:=ButtonObject,
                GA_ID, TYPE_TEXTFIELD,
                GA_TEXT, 'TextField',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BEVEL]:=ButtonObject,
                GA_ID, TYPE_BEVEL,
                GA_TEXT, 'Bevel',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_DRAWLIST]:=ButtonObject,
                GA_ID, TYPE_DRAWLIST,
                GA_TEXT, 'DrawList',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GLYPH]:=ButtonObject,
                GA_ID, TYPE_GLYPH,
                GA_TEXT, 'Glyph',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LABEL]:=ButtonObject,
                GA_ID, TYPE_LABEL,
                GA_TEXT, 'Label',
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

          PAGE_ADD, VLayoutObject,
            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
              
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_COLORWHEEL]:=ButtonObject,
                GA_ID, TYPE_COLORWHEEL,
                GA_TEXT, 'ColorWheel',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_DATEBROWSER]:=ButtonObject,
                GA_ID, TYPE_DATEBROWSER,
                GA_TEXT, 'DateBrowser',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GETCOLOR]:=ButtonObject,
                GA_ID, TYPE_GETCOLOR,
                GA_TEXT, 'GetColor',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_GRADSLIDER]:=ButtonObject,
                GA_ID, TYPE_GRADSLIDER,
                GA_TEXT, 'GradientSlider',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LISTVIEW]:=ButtonObject,
                GA_ID, TYPE_LISTVIEW,
                GA_TEXT, 'ListView',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_PROGRESS]:=ButtonObject,
                GA_ID, TYPE_PROGRESS,
                GA_DISABLED,TRUE,
                GA_TEXT, 'Progress',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SKETCH]:=ButtonObject,
                GA_ID, TYPE_SKETCH,
                GA_TEXT, 'SketchBoard',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TAPEDECK]:=ButtonObject,
                GA_ID, TYPE_TAPEDECK,
                GA_TEXT, 'TapeDeck',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TEXTEDITOR]:=ButtonObject,
                GA_ID, TYPE_TEXTEDITOR,
                GA_TEXT, 'TextEditor',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TEXTENTRY]:=ButtonObject,
                GA_ID, TYPE_TEXTENTRY,
                GA_DISABLED,TRUE,
                GA_TEXT, 'TextEntry',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_VIRTUAL]:=ButtonObject,
                GA_ID, TYPE_VIRTUAL,
                GA_TEXT, 'Virtual',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_BOINGBALL]:=ButtonObject,
                GA_ID, TYPE_BOINGBALL,
                GA_TEXT, 'BoingBall',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_SPACEINNER, FALSE,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_LED]:=ButtonObject,
                GA_ID, TYPE_LED,
                GA_TEXT, 'LED',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
              LAYOUT_ADDCHILD,self.gadgetList[TYPE_SMARTBITMAP]:=ButtonObject,
                GA_ID, TYPE_SMARTBITMAP,
                GA_DISABLED,TRUE,
                GA_TEXT, 'SmartBitmap',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,

              LAYOUT_ADDCHILD,self.gadgetList[TYPE_TITLEBAR]:=ButtonObject,
                GA_ID, TYPE_TITLEBAR,
                GA_DISABLED,TRUE,
                GA_TEXT, 'TitleBar',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,

            LAYOUT_ADDCHILD, LayoutObject,
              LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
              LAYOUT_SPACEINNER, FALSE,

              LAYOUT_ADDCHILD,self.gadgetList[BTNCANCEL2]:=ButtonObject,
                GA_ID, BTNCANCEL2,
                GA_TEXT, 'Cancel',
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
              ButtonEnd,
            LayoutEnd,
            CHILD_WEIGHTEDHEIGHT, 0,
          LayoutEnd,
        PageEnd,
      ClickTabEnd,*/
    LayoutEnd,
  WindowEnd

  FOR i:=0 TO BTNCANCEL-1
    self.gadgetActions[i]:={gadgetClick}
  ENDFOR
  self.gadgetActions[BTNCANCEL]:=MR_CANCEL
  self.gadgetActions[BTNCANCEL2]:=MR_CANCEL
  self.gadgetActions[PAGECTRL]:=MR_NONE
ENDPROC

PROC end() OF objectPickerForm
  ->freeClickTabs( self.tabs1 )
  END self.gadgetList[NUMGADS]
  END self.gadgetActions[NUMGADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC selectItem() OF  objectPickerForm
  IF self.showModal()=MR_OK
    RETURN self.selectedItem
  ENDIF
ENDPROC -1
