OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'drawlist','images/drawlist',
        'images/bevel',
        'string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/screens',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*fileStreamer','*sourceGen'

EXPORT ENUM DRAWLISTGAD1_ACTION, DRAWLISTGAD1_X1, DRAWLISTGAD1_Y1, DRAWLISTGAD1_X2, DRAWLISTGAD1_Y2, DRAWLISTGAD1_PEN,
      DRAWLISTGAD2_ACTION, DRAWLISTGAD2_X1, DRAWLISTGAD2_Y1, DRAWLISTGAD2_X2, DRAWLISTGAD2_Y2, DRAWLISTGAD2_PEN,
      DRAWLISTGAD3_ACTION, DRAWLISTGAD3_X1, DRAWLISTGAD3_Y1, DRAWLISTGAD3_X2, DRAWLISTGAD3_Y2, DRAWLISTGAD3_PEN,
      DRAWLISTGAD4_ACTION, DRAWLISTGAD4_X1, DRAWLISTGAD4_Y1, DRAWLISTGAD4_X2, DRAWLISTGAD4_Y2, DRAWLISTGAD4_PEN,
      DRAWLISTGAD5_ACTION, DRAWLISTGAD5_X1, DRAWLISTGAD5_Y1, DRAWLISTGAD5_X2, DRAWLISTGAD5_Y2, DRAWLISTGAD5_PEN,
      DRAWLISTGAD6_ACTION, DRAWLISTGAD6_X1, DRAWLISTGAD6_Y1, DRAWLISTGAD6_X2, DRAWLISTGAD6_Y2, DRAWLISTGAD6_PEN,
      DRAWLISTGAD7_ACTION, DRAWLISTGAD7_X1, DRAWLISTGAD7_Y1, DRAWLISTGAD7_X2, DRAWLISTGAD7_Y2, DRAWLISTGAD7_PEN,
      DRAWLISTGAD_OK, DRAWLISTGAD_CHILD, DRAWLISTGAD_CANCEL
      

CONST NUM_DRAWLIST_GADS=DRAWLISTGAD_CANCEL+1

CONST MAX_DRAW_ITEMS=7

EXPORT OBJECT drawListObject OF reactionObject
  drawItems[MAX_DRAW_ITEMS+1]:ARRAY OF drawlist
ENDOBJECT

OBJECT drawListSettingsForm OF reactionForm
  drawListObject:PTR TO drawListObject
  tmpPen1:INT
  tmpPen2:INT
  tmpPen3:INT
  tmpPen4:INT
  tmpPen5:INT
  tmpPen6:INT
  tmpPen7:INT
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF drawListSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_DRAWLIST_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_DRAWLIST_GADS]
  self.gadgetActions:=gads

  self.labels1:=chooserLabelsA(['DLST_END', 'DLST_LINE', 'DLST_RECT', 'DLST_LINEPAT','DLST_FILLPAT','DLST_LINESIZE','DLST_AMOVE','DLST_ADRAW','DLST_AFILL','DLST_FILL','DLST_ELLIPSE','DLST_CIRCLE',0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'DrawList Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
    WA_PUBSCREEN, 0,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,

    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_EVENSIZE, FALSE,
        LAYOUT_SHRINKWRAP, TRUE, 
        LAYOUT_SPACEINNER, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD1_ACTION ]:=ChooserObject,
          GA_ID, DRAWLISTGAD1_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD1_X1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD1_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD1_Y1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD1_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD1_X2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD1_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD1_Y2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD1_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD1_PEN ]:=ButtonObject,
          GA_ID, DRAWLISTGAD1_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_EVENSIZE, FALSE,
        LAYOUT_SHRINKWRAP, TRUE, 
        LAYOUT_SPACEINNER, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD2_ACTION ]:=ChooserObject,
          GA_ID, DRAWLISTGAD2_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD2_X1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD2_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD2_Y1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD2_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD2_X2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD2_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD2_Y2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD2_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD2_PEN ]:=ButtonObject,
          GA_ID, DRAWLISTGAD2_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_EVENSIZE, FALSE,
        LAYOUT_SHRINKWRAP, TRUE, 
        LAYOUT_SPACEINNER, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD3_ACTION ]:=ChooserObject,
          GA_ID, DRAWLISTGAD3_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD3_X1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD3_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD3_Y1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD3_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD3_X2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD3_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD3_Y2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD3_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD3_PEN ]:=ButtonObject,
          GA_ID, DRAWLISTGAD3_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_EVENSIZE, FALSE,
        LAYOUT_SHRINKWRAP, TRUE, 
        LAYOUT_SPACEINNER, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD4_ACTION ]:=ChooserObject,
          GA_ID, DRAWLISTGAD4_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD4_X1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD4_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD4_Y1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD4_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD4_X2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD4_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD4_Y2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD4_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD4_PEN ]:=ButtonObject,
          GA_ID, DRAWLISTGAD4_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_EVENSIZE, FALSE,
        LAYOUT_SHRINKWRAP, TRUE, 
        LAYOUT_SPACEINNER, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD5_ACTION ]:=ChooserObject,
          GA_ID, DRAWLISTGAD5_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD5_X1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD5_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD5_Y1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD5_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD5_X2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD5_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD5_Y2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD5_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD5_PEN ]:=ButtonObject,
          GA_ID, DRAWLISTGAD5_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_EVENSIZE, FALSE,
        LAYOUT_SHRINKWRAP, TRUE, 
        LAYOUT_SPACEINNER, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD6_ACTION ]:=ChooserObject,
          GA_ID, DRAWLISTGAD6_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD6_X1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD6_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD6_Y1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD6_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD6_X2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD6_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD6_Y2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD6_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD6_PEN ]:=ButtonObject,
          GA_ID, DRAWLISTGAD6_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_EVENSIZE, FALSE,
        LAYOUT_SHRINKWRAP, TRUE, 
        LAYOUT_SPACEINNER, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD7_ACTION ]:=ChooserObject,
          GA_ID, DRAWLISTGAD7_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD7_X1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD7_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD7_Y1 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD7_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD7_X2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD7_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD7_Y2 ]:=IntegerObject,
          GA_ID, DRAWLISTGAD7_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD7_PEN ]:=ButtonObject,
          GA_ID, DRAWLISTGAD7_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          BUTTON_TEXTPEN, 1,
          BUTTON_BACKGROUNDPEN, 0,
          BUTTON_FILLTEXTPEN, 1,
          BUTTON_FILLPEN, 3,
          BUTTON_BEVELSTYLE, BVS_BUTTON,
          BUTTON_JUSTIFICATION, BCJ_CENTER,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,
          LAYOUT_SPACEINNER, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_OK ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_CHILD ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_CHILD,
            GA_TEXT, 'C_hild',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_CANCEL ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,
        LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[DRAWLISTGAD_CHILD]:={editChildSettings}
  self.gadgetActions[DRAWLISTGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[DRAWLISTGAD_OK]:=MR_OK

  self.gadgetActions[DRAWLISTGAD1_PEN]:={selectPen}
  self.gadgetActions[DRAWLISTGAD2_PEN]:={selectPen}
  self.gadgetActions[DRAWLISTGAD3_PEN]:={selectPen}
  self.gadgetActions[DRAWLISTGAD4_PEN]:={selectPen}
  self.gadgetActions[DRAWLISTGAD5_PEN]:={selectPen}
  self.gadgetActions[DRAWLISTGAD6_PEN]:={selectPen}
  self.gadgetActions[DRAWLISTGAD7_PEN]:={selectPen}
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF drawListSettingsForm
  self:=nself
  self.drawListObject.editChildSettings()
ENDPROC

PROC selectPen(nself,gadget,id,code) OF drawListSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself
  SELECT id
    CASE DRAWLISTGAD1_PEN
      colourProp:={self.tmpPen1}
    CASE DRAWLISTGAD2_PEN
      colourProp:={self.tmpPen2}
    CASE DRAWLISTGAD3_PEN
      colourProp:={self.tmpPen3}
    CASE DRAWLISTGAD4_PEN
      colourProp:={self.tmpPen4}
    CASE DRAWLISTGAD5_PEN
      colourProp:={self.tmpPen5}
    CASE DRAWLISTGAD6_PEN
      colourProp:={self.tmpPen6}
    CASE DRAWLISTGAD7_PEN
      colourProp:={self.tmpPen7}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
ENDPROC

PROC end() OF drawListSettingsForm
  freeChooserLabels( self.labels1 )

  END self.gadgetList[NUM_DRAWLIST_GADS]
  END self.gadgetActions[NUM_DRAWLIST_GADS]
ENDPROC

PROC editSettings(comp:PTR TO drawListObject) OF drawListSettingsForm
  DEF res,i

  self.drawListObject:=comp
    
  self.tmpPen1:=comp.drawItems[0].pen
  self.tmpPen2:=comp.drawItems[1].pen
  self.tmpPen3:=comp.drawItems[2].pen
  self.tmpPen4:=comp.drawItems[3].pen
  self.tmpPen5:=comp.drawItems[4].pen
  self.tmpPen6:=comp.drawItems[5].pen
  self.tmpPen7:=comp.drawItems[6].pen

  FOR i:=0 TO MAX_DRAW_ITEMS-1
    SetGadgetAttrsA(self.gadgetList[ (i*6)+DRAWLISTGAD1_ACTION ],0,0,[CHOOSER_SELECTED,comp.drawItems[i].directive,0]) 
    SetGadgetAttrsA(self.gadgetList[ (i*6)+DRAWLISTGAD1_X1 ],0,0,[INTEGER_NUMBER,comp.drawItems[i].x1,0]) 
    SetGadgetAttrsA(self.gadgetList[ (i*6)+DRAWLISTGAD1_Y1 ],0,0,[INTEGER_NUMBER,comp.drawItems[i].y1,0]) 
    SetGadgetAttrsA(self.gadgetList[ (i*6)+DRAWLISTGAD1_X2 ],0,0,[INTEGER_NUMBER,comp.drawItems[i].x2,0]) 
    SetGadgetAttrsA(self.gadgetList[ (i*6)+DRAWLISTGAD1_Y2 ],0,0,[INTEGER_NUMBER,comp.drawItems[i].y2,0])
  ENDFOR

  res:=self.showModal()
  IF res=MR_OK
    comp.drawItems[0].pen:=self.tmpPen1
    comp.drawItems[1].pen:=self.tmpPen2
    comp.drawItems[2].pen:=self.tmpPen3
    comp.drawItems[3].pen:=self.tmpPen4
    comp.drawItems[4].pen:=self.tmpPen5
    comp.drawItems[5].pen:=self.tmpPen6
    comp.drawItems[6].pen:=self.tmpPen7

    FOR i:=0 TO MAX_DRAW_ITEMS-1
      comp.drawItems[i].directive:=Gets(self.gadgetList[ (i*6)+DRAWLISTGAD1_ACTION ],CHOOSER_SELECTED)
      comp.drawItems[i].x1:=Gets(self.gadgetList[ (i*6)+DRAWLISTGAD1_X1 ],INTEGER_NUMBER)
      comp.drawItems[i].y1:=Gets(self.gadgetList[ (i*6)+DRAWLISTGAD1_Y1 ],INTEGER_NUMBER)
      comp.drawItems[i].x2:=Gets(self.gadgetList[ (i*6)+DRAWLISTGAD1_X2 ],INTEGER_NUMBER)
      comp.drawItems[i].y2:=Gets(self.gadgetList[ (i*6)+DRAWLISTGAD1_Y2 ],INTEGER_NUMBER)
    ENDFOR
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject() OF drawListObject
  self.previewObject:=DrawListObject,
      DRAWLIST_DIRECTIVES, self.drawItems,
    DrawListEnd
    
    self.previewChildAttrs:=[
        LAYOUT_MODIFYCHILD, self.previewObject,
        CHILD_NOMINALSIZE, self.nominalSize,
        CHILD_NODISPOSE, FALSE,
        CHILD_MINWIDTH, self.minWidth,
        CHILD_MINHEIGHT, self.minHeight,
        CHILD_MAXWIDTH, self.maxWidth,
        CHILD_MAXHEIGHT, self.maxHeight,
        CHILD_WEIGHTEDWIDTH, self.weightedWidth,
        CHILD_WEIGHTEDHEIGHT,self.weightedHeight,
        CHILD_SCALEWIDTH, self.scaleWidth,
        CHILD_SCALEHEIGHT, self.scaleHeight,
        TAG_END]
ENDPROC

EXPORT PROC create(parent) OF drawListObject
  DEF i
  self.type:=TYPE_DRAWLIST

  SUPER self.create(parent)
  
  FOR i:=0 TO MAX_DRAW_ITEMS-1
    self.drawItems[i].directive:=DLST_END
    self.drawItems[i].pen:=0
    self.drawItems[i].x1:=1
    self.drawItems[i].y1:=1
    self.drawItems[i].x2:=1
    self.drawItems[i].y2:=1
  ENDFOR
  i:=MAX_DRAW_ITEMS
  self.drawItems[i].directive:=DLST_END
  self.drawItems[i].pen:=0
  self.drawItems[i].x1:=0
  self.drawItems[i].y1:=0
  self.drawItems[i].x2:=0
  self.drawItems[i].y2:=0

  self.libused:=LIB_DRAWLIST
ENDPROC

EXPORT PROC editSettings() OF drawListObject
  DEF editForm:PTR TO drawListSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF drawListObject
  RETURN 'DrawList'
ENDPROC

EXPORT PROC serialise(fser:PTR TO fileStreamer) OF drawListObject
  DEF tempStr[200]:STRING
  DEF drawItem:PTR TO drawlist
  DEF i

  SUPER self.serialise(fser)

  FOR i:=0 TO MAX_DRAW_ITEMS-1
    drawItem:=self.drawItems[i]
    StringF(tempStr,'DIRECTIVE: \d',drawItem.directive)
    fser.writeLine(tempStr)
    StringF(tempStr,'PEN: \d',drawItem.pen)
    fser.writeLine(tempStr)
    StringF(tempStr,'X1: \d',drawItem.x1)
    fser.writeLine(tempStr)
    StringF(tempStr,'Y1: \d',drawItem.y1)
    fser.writeLine(tempStr)
    StringF(tempStr,'X2: \d',drawItem.x2)
    fser.writeLine(tempStr)
    StringF(tempStr,'Y2: \d',drawItem.y2)
    fser.writeLine(tempStr)
  ENDFOR
  fser.writeLine('-')
  self.serialiseChildren(fser)
ENDPROC

EXPORT PROC deserialise(fser:PTR TO fileStreamer) OF drawListObject
  DEF tempStr[200]:STRING
  DEF done=FALSE
  DEF i
  DEF drawItem:PTR TO drawlist

  SUPER self.deserialise(fser)

  FOR i:=0 TO MAX_DRAW_ITEMS-1
    self.drawItems[i].directive:=DLST_END
    self.drawItems[i].pen:=0
    self.drawItems[i].x1:=1
    self.drawItems[i].y1:=1
    self.drawItems[i].x2:=1
    self.drawItems[i].y2:=1
  ENDFOR
  
  i:=-1
  REPEAT
    IF fser.readLine(tempStr)
      IF StrCmp('-',tempStr)
        done:=TRUE
      ELSEIF StrCmp('DIRECTIVE: ',tempStr,STRLEN)
        i++
        self.drawItems[i].directive:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('PEN: ',tempStr,STRLEN)
        self.drawItems[i].pen:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('X1: ',tempStr,STRLEN)
        self.drawItems[i].x1:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('Y1: ',tempStr,STRLEN)
        self.drawItems[i].y1:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('X2: ',tempStr,STRLEN)
        self.drawItems[i].x2:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('Y2: ',tempStr,STRLEN)
        self.drawItems[i].y2:=Val(tempStr+STRLEN)
      ENDIF
    ELSE
      done:=TRUE
    ENDIF
  UNTIL done  
ENDPROC

EXPORT PROC isImage() OF drawListObject IS TRUE

EXPORT PROC createDrawListObject(parent)
  DEF drawlist:PTR TO drawListObject
  
  NEW drawlist.create(parent)
ENDPROC drawlist
