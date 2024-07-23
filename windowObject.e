OPT MODULE, OSVERSION=37,LARGE

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec'

  MODULE '*reactionObject','*reactionForm','*sourceGen','*stringlist','*validator'

EXPORT ENUM WINGAD_IDENT, WINGAD_TITLE, WINGAD_SCREENTITLE, WINGAD_ICONTITLE, WINGAD_ICONFILE,
      WINGAD_LEFTEDGE, WINGAD_TOPEDGE, WINGAD_WIDTH, WINGAD_HEIGHT,
      WINGAD_MINWIDTH, WINGAD_MINHEIGHT, WINGAD_MAXWIDTH, WINGAD_MAXHEIGHT,
      WINGAD_WINDOWPOS, WINGAD_LOCKWIDTH, WINGAD_LOCKHEIGHT,
      WINGAD_SHAREDPORT, WINGAD_ICONIFYGAD, WINGAD_GADGETHELP,
      WINGAD_OK, WINGAD_FLAGS, WINGAD_IDCMP, WINGAD_CANCEL

CONST NUM_WIN_GADS=WINGAD_CANCEL+1

->These are not proper WFLG values 
CONST WFLG_ZOOM = 1<<28
CONST WFLG_NOTIFY_DEPTH  = 1<<29
CONST WFLG_MENUHELP = 1<<30
CONST WFLG_HELPGROUP = 1<<31

EXPORT ENUM WINGAD_FLAGS_REFRESH,
      WINGAD_FLAGS_CLOSE,WINGAD_FLAGS_DEPTH, WINGAD_FLAGS_SIZE, WINGAD_FLAGS_SIZEBRIGHT,
      WINGAD_FLAGS_SIZEBBOTTOM,WINGAD_FLAGS_DRAG,WINGAD_FLAGS_GIMME00,WINGAD_FLAGS_BORDERLESS,
      WINGAD_FLAGS_ACTIVATE,WINGAD_FLAGS_RMBTRAP,WINGAD_FLAGS_SUPERBITMAP,WINGAD_FLAGS_BACKDROP,
      WINGAD_FLAGS_ZOOM,WINGAD_FLAGS_NOTIFYDEPTH,WINGAD_FLAGS_MENUHELP,WINGAD_FLAGS_HELPGROUP,
      WINGAD_FLAGS_OK, WINGAD_FLAGS_CANCEL

CONST NUM_WIN_FLAGS_GADS=WINGAD_FLAGS_CANCEL+1

EXPORT ENUM WINGAD_IDCMP_MOUSEBUTTONS, WINGAD_IDCMP_MOUSEMOVE, WINGAD_IDCMP_DELTAMOVE, WINGAD_IDCMP_GADGETDOWN,
      WINGAD_IDCMP_GADGETUP, WINGAD_IDCMP_CLOSEWINDOW, WINGAD_IDCMP_MENUPICK, WINGAD_IDCMP_MENUVERIFY,
      WINGAD_IDCMP_MENUHELP, WINGAD_IDCMP_NEWSIZE, WINGAD_IDCMP_REFRESHWIN, WINGAD_IDCMP_SIZEVERIFY,
      WINGAD_IDCMP_VANILLAKEY, WINGAD_IDCMP_RAWKEY, WINGAD_IDCMP_NEWPREFS, WINGAD_IDCMP_DISKINSERT,
      WINGAD_IDCMP_DISKREMOVE, WINGAD_IDCMP_TICKS, WINGAD_IDCMP_UPDATE, WINGAD_IDCMP_CHANGEWINDOW,
      WINGAD_IDCMP_OK, WINGAD_IDCMP_CANCEL

CONST NUM_WIN_IDCMP_GADS=WINGAD_IDCMP_CANCEL+1

EXPORT OBJECT windowObject OF reactionObject
  title[80]:ARRAY OF CHAR
  screentitle[80]:ARRAY OF CHAR
  iconTitle[80]:ARRAY OF CHAR
  iconFile[80]:ARRAY OF CHAR
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  windowPos:CHAR
  lockWidth:CHAR
  lockHeight:CHAR
  sharedPort:CHAR
  iconifyGadget:CHAR
  gadgetHelp:CHAR
  refreshType:CHAR
  flags:LONG
  idcmp:LONG
  appPort:LONG
  previewOpen:CHAR
  previewRootLayout:LONG
  previewLeft:INT
  previewTop:INT
  previewWidth:INT
  previewHeight:INT
  previewHintInfo:PTR TO hintinfo
ENDOBJECT

OBJECT windowSettingsForm OF reactionForm
PRIVATE
  windowObject:PTR TO windowObject
  tmpRefreshType:CHAR
  tmpFlags:LONG
  tmpIDCMP:LONG
  labels1:PTR TO LONG
ENDOBJECT

OBJECT windowFlagsSettingsForm OF reactionForm
  labels1:PTR TO LONG
ENDOBJECT

OBJECT windowIDCMPSettingsForm OF reactionForm
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF windowIDCMPSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_WIN_IDCMP_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_WIN_IDCMP_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Window IDCMP Attribute Setting',
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
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_MOUSEBUTTONS ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_MOUSEBUTTONS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'MouseButtons',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_MOUSEMOVE ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_MOUSEMOVE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'MouseMove',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_DELTAMOVE ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_DELTAMOVE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DeltaMove',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_GADGETDOWN ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_GADGETDOWN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'GadgetDown',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_GADGETUP ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_GADGETUP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'GadgetUp',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_CLOSEWINDOW ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_CLOSEWINDOW,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'CloseWindow',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_MENUPICK ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_MENUPICK,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'MenuPick',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_MENUVERIFY ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_MENUVERIFY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'MenuVerify',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_MENUHELP ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_MENUHELP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'MenuHelp',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_NEWSIZE ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_NEWSIZE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'NewSize',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_REFRESHWIN ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_REFRESHWIN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'RefreshWindow',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_SIZEVERIFY ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_SIZEVERIFY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'SizeVerify',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_VANILLAKEY ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_VANILLAKEY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'VanillaKey',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_RAWKEY ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_RAWKEY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'RawKey',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_NEWPREFS ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_NEWPREFS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'NewPrefs',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_DISKINSERT ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_DISKINSERT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DiskInserted',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_DISKREMOVE ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_DISKREMOVE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DiskRemoved',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_TICKS ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_TICKS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'IntuiTicks',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_UPDATE ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_UPDATE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'IDCMPUpdate',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDCMP_CHANGEWINDOW ]:=CheckBoxObject,
          GA_ID, WINGAD_IDCMP_CHANGEWINDOW,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'ChangeWindow',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_IDCMP_OK ]:=ButtonObject,
          GA_ID, WINGAD_IDCMP_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_IDCMP_CANCEL ]:=ButtonObject,
          GA_ID, WINGAD_IDCMP_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[WINGAD_IDCMP_CANCEL]:=MR_CANCEL
  self.gadgetActions[WINGAD_IDCMP_OK]:=MR_OK
ENDPROC

PROC end() OF windowIDCMPSettingsForm
  END self.gadgetList[NUM_WIN_IDCMP_GADS]
  END self.gadgetActions[NUM_WIN_IDCMP_GADS]
  DisposeObject(self.windowObj)
ENDPROC

PROC editSettingsIDCMP(idcmpPtr:PTR TO LONG) OF windowIDCMPSettingsForm
  DEF res
  DEF idcmp

  idcmp:=idcmpPtr[]

  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_MOUSEBUTTONS ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_MOUSEBUTTONS,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_MOUSEMOVE    ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_MOUSEMOVE,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_DELTAMOVE    ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_DELTAMOVE,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_GADGETDOWN   ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_GADGETDOWN,0]) 

  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_GADGETUP    ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_GADGETUP,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_CLOSEWINDOW ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_CLOSEWINDOW,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_MENUPICK    ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_MENUPICK,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_MENUVERIFY  ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_MENUVERIFY,0]) 

  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_MENUHELP   ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_MENUHELP,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_NEWSIZE    ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_NEWSIZE,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_REFRESHWIN ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_REFRESHWINDOW,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_SIZEVERIFY ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_SIZEVERIFY,0]) 

  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_VANILLAKEY ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_VANILLAKEY,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_RAWKEY     ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_RAWKEY,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_NEWPREFS   ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_NEWPREFS,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_DISKINSERT ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_DISKINSERTED,0]) 

  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_DISKREMOVE   ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_DISKREMOVED,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_TICKS        ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_INTUITICKS,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_UPDATE       ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_IDCMPUPDATE,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDCMP_CHANGEWINDOW ],0,0,[CHECKBOX_CHECKED,idcmp AND IDCMP_CHANGEWINDOW,0]) 

  res:=self.showModal()
  IF res=MR_OK
    idcmp:=0

    IF Gets(self.gadgetList[ WINGAD_IDCMP_MOUSEBUTTONS ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_MOUSEBUTTONS
    IF Gets(self.gadgetList[ WINGAD_IDCMP_MOUSEMOVE    ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_MOUSEMOVE
    IF Gets(self.gadgetList[ WINGAD_IDCMP_DELTAMOVE    ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_DELTAMOVE
    IF Gets(self.gadgetList[ WINGAD_IDCMP_GADGETDOWN   ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_GADGETDOWN
                                                                                                  
    IF Gets(self.gadgetList[ WINGAD_IDCMP_GADGETUP    ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_GADGETUP
    IF Gets(self.gadgetList[ WINGAD_IDCMP_CLOSEWINDOW ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_CLOSEWINDOW
    IF Gets(self.gadgetList[ WINGAD_IDCMP_MENUPICK    ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_MENUPICK
    IF Gets(self.gadgetList[ WINGAD_IDCMP_MENUVERIFY  ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_MENUVERIFY
                                                                                                  
    IF Gets(self.gadgetList[ WINGAD_IDCMP_MENUHELP   ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_MENUHELP
    IF Gets(self.gadgetList[ WINGAD_IDCMP_NEWSIZE    ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_NEWSIZE
    IF Gets(self.gadgetList[ WINGAD_IDCMP_REFRESHWIN ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_REFRESHWINDOW
    IF Gets(self.gadgetList[ WINGAD_IDCMP_SIZEVERIFY ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_SIZEVERIFY
                                                                                                  
    IF Gets(self.gadgetList[ WINGAD_IDCMP_VANILLAKEY ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_VANILLAKEY
    IF Gets(self.gadgetList[ WINGAD_IDCMP_RAWKEY     ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_RAWKEY
    IF Gets(self.gadgetList[ WINGAD_IDCMP_NEWPREFS   ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_NEWPREFS 
    IF Gets(self.gadgetList[ WINGAD_IDCMP_DISKINSERT ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_DISKINSERTED
                                                                                                  
    IF Gets(self.gadgetList[ WINGAD_IDCMP_DISKREMOVE   ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_DISKREMOVED
    IF Gets(self.gadgetList[ WINGAD_IDCMP_TICKS        ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_INTUITICKS
    IF Gets(self.gadgetList[ WINGAD_IDCMP_UPDATE       ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_IDCMPUPDATE
    IF Gets(self.gadgetList[ WINGAD_IDCMP_CHANGEWINDOW ],CHECKBOX_CHECKED ) THEN  idcmp:=idcmp OR IDCMP_CHANGEWINDOW

    idcmpPtr[]:=idcmp
  ENDIF
ENDPROC

PROC create() OF windowFlagsSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_WIN_FLAGS_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_WIN_FLAGS_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Window Flags Attribute Setting',
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
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,

      LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_REFRESH ]:=ChooserObject,
        GA_ID, WINGAD_FLAGS_REFRESH,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        CHOOSER_POPUP, TRUE,
        CHOOSER_MAXLABELS, 12,
        CHOOSER_ACTIVE, 0,
        CHOOSER_WIDTH, -1,
        CHOOSER_LABELS, self.labels1:=chooserLabelsA(['WA_NoCareRefresh','WA_SimpleRefresh','WA_SmartRefresh','WA_SuperBitmap',0]),
      ChooserEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Refresh type',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_CLOSE ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_CLOSE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Close Gadget',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_DEPTH ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_DEPTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Depth Gadget',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_SIZE ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_SIZE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Size Gadget',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_SIZEBRIGHT ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_SIZEBRIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'SizeBRight',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_SIZEBBOTTOM ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_SIZEBBOTTOM,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'SizeBBottom',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_DRAG ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_DRAG,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Drag Bar',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_GIMME00 ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_GIMME00,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'GimmeZeroZero',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_BORDERLESS ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_BORDERLESS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Borderless',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_ACTIVATE ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_ACTIVATE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Activate',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_RMBTRAP ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_RMBTRAP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'RMBTrap',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_SUPERBITMAP ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_SUPERBITMAP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'SuperBitMap',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_BACKDROP ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_BACKDROP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'BackDrop',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_EVENSIZE, TRUE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_ZOOM ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_ZOOM,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Zoom',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_NOTIFYDEPTH ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_NOTIFYDEPTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'NotifyDepth',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_MENUHELP ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_MENUHELP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Menu Help',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_FLAGS_HELPGROUP ]:=CheckBoxObject,
          GA_ID, WINGAD_FLAGS_HELPGROUP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Help Group',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_FLAGS_OK ]:=ButtonObject,
          GA_ID, WINGAD_FLAGS_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_FLAGS_CANCEL ]:=ButtonObject,
          GA_ID, WINGAD_FLAGS_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[WINGAD_FLAGS_CANCEL]:=MR_CANCEL
  self.gadgetActions[WINGAD_FLAGS_OK]:=MR_OK
ENDPROC

PROC end() OF windowFlagsSettingsForm
  freeChooserLabels( self.labels1 )

  END self.gadgetList[NUM_WIN_FLAGS_GADS]
  END self.gadgetActions[NUM_WIN_FLAGS_GADS]
  DisposeObject(self.windowObj)
ENDPROC

PROC editSettingsFlags(refreshPtr:PTR TO CHAR, flagsPtr:PTR TO LONG) OF windowFlagsSettingsForm
  DEF res
  DEF flags,refresh
  flags:=flagsPtr[]
  refresh:=refreshPtr[]
  
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_REFRESH ],0,0,[CHOOSER_SELECTED,refresh,0]) 
 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_CLOSE ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_CLOSEGADGET,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_DEPTH ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_DEPTHGADGET,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_SIZE ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_SIZEGADGET,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_SIZEBRIGHT ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_SIZEBRIGHT,0]) 

  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_SIZEBBOTTOM ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_SIZEBBOTTOM,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_DRAG ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_DRAGBAR,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_GIMME00 ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_GIMMEZEROZERO,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_BORDERLESS ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_BORDERLESS,0]) 

  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_ACTIVATE ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_ACTIVATE,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_RMBTRAP ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_RMBTRAP,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_SUPERBITMAP ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_SUPER_BITMAP,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_BACKDROP ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_BACKDROP,0]) 

  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_ZOOM ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_ZOOM,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_NOTIFYDEPTH ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_NOTIFY_DEPTH,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_MENUHELP ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_MENUHELP,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_FLAGS_HELPGROUP ],0,0,[CHECKBOX_CHECKED,flags AND WFLG_HELPGROUP,0])

  res:=self.showModal()
  IF res=MR_OK
    flags:=0
    IF Gets(self.gadgetList[ WINGAD_FLAGS_CLOSE ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_CLOSEGADGET
    IF Gets(self.gadgetList[ WINGAD_FLAGS_DEPTH ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_DEPTHGADGET
    IF Gets(self.gadgetList[ WINGAD_FLAGS_SIZE ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_SIZEGADGET
    IF Gets(self.gadgetList[ WINGAD_FLAGS_SIZEBRIGHT ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_SIZEBRIGHT

    IF Gets(self.gadgetList[ WINGAD_FLAGS_SIZEBBOTTOM ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_SIZEBBOTTOM
    IF Gets(self.gadgetList[ WINGAD_FLAGS_DRAG ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_DRAGBAR
    IF Gets(self.gadgetList[ WINGAD_FLAGS_GIMME00 ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_GIMMEZEROZERO
    IF Gets(self.gadgetList[ WINGAD_FLAGS_BORDERLESS ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_BORDERLESS
    
    IF Gets(self.gadgetList[ WINGAD_FLAGS_ACTIVATE ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_ACTIVATE
    IF Gets(self.gadgetList[ WINGAD_FLAGS_RMBTRAP ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_RMBTRAP
    IF Gets(self.gadgetList[ WINGAD_FLAGS_SUPERBITMAP ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_SUPER_BITMAP
    IF Gets(self.gadgetList[ WINGAD_FLAGS_BACKDROP ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_BACKDROP
    
    IF Gets(self.gadgetList[ WINGAD_FLAGS_ZOOM ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_ZOOM
    IF Gets(self.gadgetList[ WINGAD_FLAGS_NOTIFYDEPTH ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_NOTIFY_DEPTH
    IF Gets(self.gadgetList[ WINGAD_FLAGS_MENUHELP ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_MENUHELP
    IF Gets(self.gadgetList[ WINGAD_FLAGS_HELPGROUP ],CHECKBOX_CHECKED ) THEN  flags:=flags OR WFLG_HELPGROUP
    
    refresh:=Gets(self.gadgetList[ WINGAD_FLAGS_REFRESH ],CHOOSER_SELECTED )
  
    flagsPtr[]:=flags
    refreshPtr[]:=refresh
  ENDIF

ENDPROC res=MR_OK

PROC create() OF windowSettingsForm
  DEF gads:PTR TO LONG
  DEF scr:PTR TO screen
  DEF arrows
  
  NEW gads[NUM_WIN_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_WIN_GADS]
  self.gadgetActions:=gads
  
  scr:=LockPubScreen(NIL)
  arrows:=(scr.width>=800)
  UnlockPubScreen(NIL,scr)


  self.windowObj:=WindowObject,
    WA_TITLE, 'Window Attribute Setting',
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
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_IDENT ]:=StringObject,
            GA_ID, WINGAD_IDENT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Identifier',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_TITLE ]:=StringObject,
            GA_ID, WINGAD_TITLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Window Title',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_SCREENTITLE ]:=StringObject,
          GA_ID, WINGAD_SCREENTITLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Screen Title',
        LabelEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_ICONTITLE ]:=StringObject,
            GA_ID, WINGAD_ICONTITLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Ico_n Title',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_ICONFILE ]:=StringObject,
            GA_ID,  WINGAD_ICONFILE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Icon File',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_LEFTEDGE ]:=IntegerObject,
            GA_ID, WINGAD_LEFTEDGE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_ARROWS, arrows,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'LeftEdge',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_TOPEDGE ]:=IntegerObject,
            GA_ID, WINGAD_TOPEDGE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_ARROWS, arrows,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Top_Edge',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_WIDTH ]:=IntegerObject,
            GA_ID, WINGAD_WIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_ARROWS, arrows,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Width',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_HEIGHT ]:=IntegerObject,
            GA_ID, WINGAD_HEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_ARROWS, arrows,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Height',
          LabelEnd,
        LayoutEnd,
        
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_MINWIDTH ]:=IntegerObject,
            GA_ID, WINGAD_MINWIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_ARROWS, arrows,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MinWidth',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_MINHEIGHT ]:=IntegerObject,
            GA_ID, WINGAD_MINHEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_ARROWS, arrows,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MinHeight',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_MAXWIDTH ]:=IntegerObject,
            GA_ID,WINGAD_MAXWIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_ARROWS, arrows,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MaxWidth',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_MAXHEIGHT ]:=IntegerObject,
            GA_ID, WINGAD_MAXHEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_ARROWS, arrows,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MaxHeight',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_WINDOWPOS ]:=ChooserObject,
          GA_ID, WINGAD_WINDOWPOS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['NONE','WPOS_CENTERSCREEN','WPOS_CENTERMOUSE','WPOS_TOPLEFT','WPOS_CENTERWINDOW','WPOS_FULLSCREEN',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Window P_osition',
        LabelEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_LOCKWIDTH ]:=CheckBoxObject,
            GA_ID, WINGAD_LOCKWIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Lock Width',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_LOCKHEIGHT ]:=CheckBoxObject,
            GA_ID, WINGAD_LOCKHEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Lock Height',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_SHAREDPORT ]:=CheckBoxObject,
            GA_ID, WINGAD_SHAREDPORT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Shared Port',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_ICONIFYGAD ]:=CheckBoxObject,
            GA_ID, WINGAD_ICONIFYGAD,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Iconify Gadget',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ WINGAD_GADGETHELP ]:=CheckBoxObject,
            GA_ID, WINGAD_GADGETHELP,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Gadget Help',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_OK ]:=ButtonObject,
            GA_ID, WINGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_FLAGS ]:=ButtonObject,
            GA_ID, WINGAD_FLAGS,
            GA_TEXT, '_Flags',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_IDCMP ]:=ButtonObject,
            GA_ID, WINGAD_IDCMP,
            GA_TEXT, '_IDCMP',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ WINGAD_CANCEL ]:=ButtonObject,
            GA_ID, WINGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[WINGAD_FLAGS]:={editFlags}
  self.gadgetActions[WINGAD_IDCMP]:={editIDCMP}
  self.gadgetActions[WINGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[WINGAD_OK]:=MR_OK
ENDPROC

EXPORT PROC canClose(modalRes) OF windowSettingsForm
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.windowObject,WINGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editFlags(nself,gadget,id,code) OF windowSettingsForm
  DEF res,refreshType,flags
  DEF windowFlagsSettingsForm:PTR TO windowFlagsSettingsForm
  self:=nself

  self.setBusy()
  NEW windowFlagsSettingsForm.create()
  windowFlagsSettingsForm.editSettingsFlags({self.tmpRefreshType},{self.tmpFlags})
  END windowFlagsSettingsForm
  self.clearBusy()
ENDPROC

PROC editIDCMP(nself,gadget,id,code) OF windowSettingsForm
  DEF res,idcmp
  DEF windowIDCMPSettingsForm:PTR TO windowIDCMPSettingsForm
  self:=nself

  self.setBusy()
  NEW windowIDCMPSettingsForm.create()
  windowIDCMPSettingsForm.editSettingsIDCMP({self.tmpIDCMP})
  END windowIDCMPSettingsForm
  self.clearBusy()
ENDPROC

PROC end() OF windowSettingsForm
  freeChooserLabels( self.labels1 )

  END self.gadgetList[NUM_WIN_GADS]
  END self.gadgetActions[NUM_WIN_GADS]
  DisposeObject(self.windowObj)
ENDPROC

PROC editSettings(comp:PTR TO windowObject) OF windowSettingsForm
  DEF res

  self.windowObject:=comp

  self.tmpRefreshType:=comp.refreshType
  self.tmpFlags:=comp.flags
  self.tmpIDCMP:=comp.idcmp

  SetGadgetAttrsA(self.gadgetList[ WINGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_TITLE ],0,0,[STRINGA_TEXTVAL,comp.title,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_SCREENTITLE ],0,0,[STRINGA_TEXTVAL,comp.screentitle,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_ICONTITLE ],0,0,[STRINGA_TEXTVAL,comp.iconTitle,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_ICONFILE ],0,0,[STRINGA_TEXTVAL,comp.iconFile,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_LEFTEDGE ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_TOPEDGE ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_MINWIDTH ],0,0,[INTEGER_NUMBER,comp.minWidth,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_MINHEIGHT ],0,0,[INTEGER_NUMBER,comp.minHeight,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_MAXWIDTH ],0,0,[INTEGER_NUMBER,comp.maxWidth,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_MAXHEIGHT ],0,0,[INTEGER_NUMBER,comp.maxHeight,0])
  SetGadgetAttrsA(self.gadgetList[ WINGAD_WINDOWPOS ],0,0,[CHOOSER_SELECTED,comp.windowPos,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_LOCKWIDTH ],0,0,[CHECKBOX_CHECKED,comp.lockWidth,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_LOCKHEIGHT ],0,0,[CHECKBOX_CHECKED,comp.lockHeight,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_SHAREDPORT ],0,0,[CHECKBOX_CHECKED,comp.sharedPort,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_ICONIFYGAD ],0,0,[CHECKBOX_CHECKED,comp.iconifyGadget,0]) 
  SetGadgetAttrsA(self.gadgetList[ WINGAD_GADGETHELP ],0,0,[CHECKBOX_CHECKED,comp.gadgetHelp,0]) 

  res:=self.showModal()
  IF res=MR_OK

    AstrCopy(comp.ident,Gets(self.gadgetList[ WINGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.name,Gets(self.gadgetList[ WINGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.title,Gets(self.gadgetList[ WINGAD_TITLE ],STRINGA_TEXTVAL))
    AstrCopy(comp.screentitle,Gets(self.gadgetList[ WINGAD_SCREENTITLE ],STRINGA_TEXTVAL))
    AstrCopy(comp.iconTitle,Gets(self.gadgetList[ WINGAD_ICONTITLE ],STRINGA_TEXTVAL))
    AstrCopy(comp.iconFile,Gets(self.gadgetList[ WINGAD_ICONFILE ],STRINGA_TEXTVAL))
    comp.leftEdge:=Gets(self.gadgetList[ WINGAD_LEFTEDGE ],INTEGER_NUMBER)
    comp.topEdge:=Gets(self.gadgetList[ WINGAD_TOPEDGE ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ WINGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ WINGAD_HEIGHT ],INTEGER_NUMBER)
    comp.minWidth:=Gets(self.gadgetList[ WINGAD_MINWIDTH ],INTEGER_NUMBER)
    comp.minHeight:=Gets(self.gadgetList[ WINGAD_MINHEIGHT ],INTEGER_NUMBER)
    comp.maxWidth:=Gets(self.gadgetList[ WINGAD_MAXWIDTH ],INTEGER_NUMBER)
    comp.maxHeight:=Gets(self.gadgetList[ WINGAD_MAXHEIGHT ],INTEGER_NUMBER)
    comp.windowPos:=Gets(self.gadgetList[ WINGAD_WINDOWPOS ],CHOOSER_SELECTED)
    comp.lockWidth:=Gets(self.gadgetList[ WINGAD_LOCKWIDTH ],CHECKBOX_CHECKED)
    comp.lockHeight:=Gets(self.gadgetList[ WINGAD_LOCKHEIGHT ],CHECKBOX_CHECKED)
    comp.sharedPort:=Gets(self.gadgetList[ WINGAD_SHAREDPORT ],CHECKBOX_CHECKED)
    comp.iconifyGadget:=Gets(self.gadgetList[ WINGAD_ICONIFYGAD ],CHECKBOX_CHECKED)
    comp.gadgetHelp:=Gets(self.gadgetList[ WINGAD_GADGETHELP ],CHECKBOX_CHECKED)

    comp.refreshType:=self.tmpRefreshType
    comp.flags:=self.tmpFlags
    comp.idcmp:=self.tmpIDCMP
    
    comp.previewLeft:=comp.leftEdge
    comp.previewTop:=comp.topEdge
    comp.previewWidth:=comp.width
    comp.previewHeight:=comp.height
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF windowObject
  IF self.previewObject THEN DisposeObject(self.previewObject)
  
  self.previewObject:=WindowObject,
    WA_TITLE, self.title,
    IF StrLen(self.screentitle) THEN WA_SCREENTITLE ELSE TAG_IGNORE, self.screentitle,
    WA_LEFT, self.leftEdge,
    WA_TOP, self.topEdge,
    WA_HEIGHT,self.height,
    WA_WIDTH,self.width,
    WA_MINWIDTH,self.minWidth,
    WA_MAXWIDTH,self.maxWidth,
    WA_MINHEIGHT,self.minHeight,
    WA_MAXHEIGHT,self.maxHeight,
    WA_PUBSCREEN, 0,
    WA_ACTIVATE, FALSE,
    WA_NEWLOOKMENUS, TRUE,
    WINDOW_APPPORT, self.appPort,
    WINDOW_HINTINFO,self.previewHintInfo,
    WINDOW_GADGETHELP,self.gadgetHelp,
    WINDOW_ICONIFYGADGET, IF self.iconifyGadget THEN TRUE ELSE FALSE,
    IF self.windowPos THEN WINDOW_POSITION ELSE TAG_IGNORE, ListItem([WPOS_TOPLEFT,WPOS_CENTERSCREEN,WPOS_CENTERMOUSE,WPOS_TOPLEFT,WPOS_CENTERWINDOW,WPOS_FULLSCREEN,0],self.windowPos),
    WA_CLOSEGADGET,IF self.flags AND WFLG_CLOSEGADGET THEN TRUE ELSE FALSE,
    WA_DEPTHGADGET,IF self.flags AND WFLG_DEPTHGADGET THEN TRUE ELSE FALSE,
    WA_SIZEGADGET,IF self.flags AND WFLG_SIZEGADGET THEN TRUE ELSE FALSE,
    WA_DRAGBAR,IF self.flags AND WFLG_DRAGBAR THEN TRUE ELSE FALSE,
    IF self.flags AND WFLG_SIZEBRIGHT THEN WA_SIZEBRIGHT ELSE TAG_IGNORE, IF self.flags AND WFLG_SIZEBRIGHT THEN TRUE ELSE FALSE,
    IF self.flags AND WFLG_SIZEBBOTTOM THEN WA_SIZEBBOTTOM ELSE TAG_IGNORE, IF self.flags AND WFLG_SIZEBBOTTOM THEN TRUE ELSE FALSE,
    WA_GIMMEZEROZERO, IF self.flags AND WFLG_GIMMEZEROZERO THEN TRUE ELSE FALSE,
    WA_BORDERLESS, IF self.flags AND WFLG_BORDERLESS THEN TRUE ELSE FALSE,
    WA_SUPERBITMAP, IF self.flags AND WFLG_SUPER_BITMAP THEN TRUE ELSE FALSE,
    WA_BACKDROP, IF self.flags AND WFLG_BACKDROP THEN TRUE ELSE FALSE,
    WA_ZOOM, IF self.flags AND WFLG_ZOOM THEN TRUE ELSE FALSE,
    WA_IDCMP,IDCMP_CHANGEWINDOW OR IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW,
      WINDOW_PARENTGROUP, self.previewRootLayout:=VLayoutObject,
      LAYOUT_SPACEOUTER, TRUE,  
      LAYOUT_DEFERLAYOUT, FALSE,  
      LayoutEnd,
    WindowEnd
ENDPROC
  
EXPORT PROC create(parent) OF windowObject
  self.type:=TYPE_WINDOW
  SUPER self.create(parent)
  
  AstrCopy(self.title,'Application Window')
  AstrCopy(self.screentitle,'')
  AstrCopy(self.iconTitle,'MyApp')
  AstrCopy(self.iconFile,'')
  self.leftEdge:=5
  self.topEdge:=20
  self.width:=150
  self.height:=80
  self.minWidth:=150
  self.minHeight:=80
  self.maxWidth:=8192
  self.maxHeight:=8192
  self.windowPos:=0
  self.lockWidth:=0
  self.lockHeight:=0
  self.sharedPort:=0
  self.iconifyGadget:=0
  self.gadgetHelp:=TRUE
  self.refreshType:=0
  self.flags:=WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR WFLG_SIZEGADGET OR WFLG_DRAGBAR OR WFLG_ACTIVATE
  self.idcmp:=IDCMP_GADGETDOWN OR IDCMP_GADGETUP OR IDCMP_CLOSEWINDOW OR IDCMP_NEWSIZE

  self.previewHintInfo:=New(SIZEOF hintinfo) 
  self.previewHintInfo.gadgetid:=-1
  self.previewHintInfo.code:=-1
  
  self.appPort:=CreateMsgPort()
  self.previewObject:=0
  self.createPreviewObject(0)
  self.previewChildAttrs:=0
  self.previewOpen:=TRUE
  self.previewLeft:=self.leftEdge
  self.previewTop:=self.topEdge
  self.previewWidth:=self.width
  self.previewHeight:=self.height
ENDPROC

PROC end() OF windowObject
  IF self.appPort THEN DeleteMsgPort(self.appPort)
  IF self.previewHintInfo THEN Dispose(self.previewHintInfo)
  SUPER self.end()
ENDPROC

EXPORT PROC editSettings() OF windowObject
  DEF editForm:PTR TO windowSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF windowObject IS
[
  makeProp(title,FIELDTYPE_STR),
  makeProp(screentitle,FIELDTYPE_STR),
  makeProp(iconTitle,FIELDTYPE_STR),
  makeProp(iconFile,FIELDTYPE_STR),
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(windowPos,FIELDTYPE_CHAR),
  makeProp(lockWidth,FIELDTYPE_CHAR),
  makeProp(lockHeight,FIELDTYPE_CHAR),
  makeProp(sharedPort,FIELDTYPE_CHAR),
  makeProp(iconifyGadget,FIELDTYPE_CHAR),
  makeProp(gadgetHelp,FIELDTYPE_CHAR),
  makeProp(refreshType,FIELDTYPE_CHAR),
  makeProp(flags,FIELDTYPE_LONG),
  makeProp(idcmp,FIELDTYPE_LONG),
  makeProp(previewOpen,FIELDTYPE_CHAR),
  makeProp(previewLeft,FIELDTYPE_INT),
  makeProp(previewTop,FIELDTYPE_INT),
  makeProp(previewWidth,FIELDTYPE_INT),
  makeProp(previewHeight,FIELDTYPE_INT)
]

EXPORT PROC getTypeName() OF windowObject
  RETURN 'Window'
ENDPROC

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF windowObject
  DEF tempStr[100]:STRING
  DEF idcmpList:PTR TO stringlist
  
  srcGen.componentProperty('WA_Title',self.title,TRUE)
  IF StrLen(self.screentitle) THEN srcGen.componentProperty('WA_ScreenTitle',self.screentitle,TRUE)
  StringF(tempStr,'\d',self.leftEdge)
  srcGen.componentProperty('WA_Left',tempStr,FALSE)
  StringF(tempStr,'\d',self.topEdge)
  srcGen.componentProperty('WA_Top',tempStr,FALSE)
  StringF(tempStr,'\d',self.width)
  srcGen.componentProperty('WA_Width',tempStr,FALSE)
  StringF(tempStr,'\d',self.height)
  srcGen.componentProperty('WA_Height',tempStr,FALSE)
  StringF(tempStr,'\d',self.minWidth)
  srcGen.componentProperty('WA_MinWidth',tempStr,FALSE)
  StringF(tempStr,'\d',self.minHeight)
  srcGen.componentProperty('WA_MinHeight',tempStr,FALSE)
  StringF(tempStr,'\d',self.maxWidth)
  srcGen.componentProperty('WA_MaxWidth',tempStr,FALSE)
  StringF(tempStr,'\d',self.maxHeight)
  srcGen.componentProperty('WA_MaxHeight',tempStr,FALSE)

  IF self.lockWidth THEN srcGen.componentProperty('WINDOW_LockWidth','TRUE',FALSE)
  IF self.lockHeight THEN srcGen.componentProperty('WINDOW_LockHeight','TRUE',FALSE)
  IF self.iconifyGadget THEN srcGen.componentProperty('WINDOW_IconifyGadget','TRUE',FALSE)
  IF self.gadgetHelp 
    srcGen.componentProperty('WINDOW_HintInfo','hintInfo',FALSE)
    srcGen.componentProperty('WINDOW_GadgetHelp','TRUE',FALSE)
  ENDIF
  IF self.sharedPort
    srcGen.componentProperty('WINDOW_SharedPort','gSharedPort',FALSE)
  ENDIF
  srcGen.componentProperty('WINDOW_AppPort','gAppPort',FALSE)

  IF self.iconifyGadget THEN srcGen.componentProperty('WINDOW_IconifyGadget','TRUE',FALSE)
  IF self.flags AND WFLG_CLOSEGADGET THEN srcGen.componentProperty('WA_CloseGadget','TRUE',FALSE)
  IF self.flags AND WFLG_DEPTHGADGET THEN srcGen.componentProperty('WA_DepthGadget','TRUE',FALSE)
  IF self.flags AND WFLG_SIZEGADGET THEN srcGen.componentProperty('WA_SizeGadget','TRUE',FALSE)
  IF self.flags AND WFLG_DRAGBAR THEN srcGen.componentProperty('WA_DragBar','TRUE',FALSE)
  IF self.flags AND WFLG_ACTIVATE THEN srcGen.componentProperty('WA_Activate','TRUE',FALSE)

  IF self.flags AND WFLG_SIZEBRIGHT THEN srcGen.componentProperty('WA_SizeBRight','TRUE',FALSE)
  IF self.flags AND WFLG_SIZEBBOTTOM THEN srcGen.componentProperty('WA_SizeBBottom','TRUE',FALSE)
  IF self.flags AND WFLG_GIMMEZEROZERO THEN srcGen.componentProperty('WA_GimmeZeroZero','TRUE',FALSE)
  IF self.flags AND WFLG_BORDERLESS THEN srcGen.componentProperty('WA_Borderless','TRUE',FALSE)
  IF self.flags AND WFLG_RMBTRAP THEN srcGen.componentProperty('WA_RMBTrap','TRUE',FALSE)
  IF self.flags AND WFLG_SUPER_BITMAP THEN srcGen.componentProperty('WA_SuperBitMap','TRUE',FALSE)
  IF self.flags AND WFLG_BACKDROP THEN srcGen.componentProperty('WA_Backdrop','TRUE',FALSE)
  IF self.flags AND WFLG_ZOOM THEN srcGen.componentProperty('WA_Zoom','TRUE',FALSE)
  IF self.flags AND WFLG_NOTIFY_DEPTH THEN srcGen.componentProperty('WA_NotifyDepth','TRUE',FALSE)
  IF self.flags AND WFLG_MENUHELP THEN srcGen.componentProperty('WA_MenuHelp','TRUE',FALSE)
  IF self.flags AND WFLG_HELPGROUP THEN srcGen.componentProperty('WA_HelpGroup','TRUE',FALSE)

  IF self.windowPos THEN srcGen.componentProperty('WINDOW_Position',ListItem(['NONE','WPOS_CENTERSCREEN','WPOS_CENTERMOUSE','WPOS_TOPLEFT','WPOS_CENTERWINDOW','WPOS_FULLSCREEN',0],self.windowPos),FALSE)
  IF StrLen(self.iconTitle)>0 THEN srcGen.componentProperty('WINDOW_IconTitle',self.iconTitle,TRUE)

  IF StrLen(self.iconFile)>0
    IF srcGen.type=CSOURCE_GEN
      StringF(tempStr,' GetDiskObject(\q\s\q)',self.iconFile)
    ELSE
      StringF(tempStr,' GetDiskObject(\a\s\a)',self.iconFile)
    ENDIF
    srcGen.componentProperty('WINDOW_Icon',tempStr,FALSE)
  ENDIF


  SELECT self.refreshType
    CASE 0
      srcGen.componentProperty('WA_NoCareRefresh','TRUE',FALSE)
    CASE 1
      srcGen.componentProperty('WA_SimpleRefresh','TRUE',FALSE)
    CASE 2
      srcGen.componentProperty('WA_SmartRefresh','TRUE',FALSE)
    CASE 3
      srcGen.componentProperty('WA_SuperBitmap','TRUE',FALSE)
  ENDSELECT

  NEW idcmpList.stringlist(20)

  IF self.idcmp AND IDCMP_MOUSEBUTTONS THEN idcmpList.add('IDCMP_MOUSEBUTTONS')

  IF self.idcmp AND IDCMP_MOUSEBUTTONS THEN idcmpList.add('IDCMP_MOUSEBUTTONS')
  IF self.idcmp AND IDCMP_MOUSEMOVE    THEN idcmpList.add('IDCMP_MOUSEMOVE')
  IF self.idcmp AND IDCMP_DELTAMOVE    THEN idcmpList.add('IDCMP_DELTAMOVE')
  IF self.idcmp AND IDCMP_GADGETDOWN   THEN idcmpList.add('IDCMP_GADGETDOWN')
  
  IF self.idcmp AND IDCMP_GADGETUP     THEN idcmpList.add('IDCMP_GADGETUP')
  IF self.idcmp AND IDCMP_CLOSEWINDOW  THEN idcmpList.add('IDCMP_CLOSEWINDOW')
  IF self.idcmp AND IDCMP_MENUPICK     THEN idcmpList.add('IDCMP_MENUPICK')
  IF self.idcmp AND IDCMP_MENUVERIFY   THEN idcmpList.add('IDCMP_MENUVERIFY')
                                       
  IF self.idcmp AND IDCMP_MENUHELP      THEN idcmpList.add('IDCMP_MENUHELP')
  IF self.idcmp AND IDCMP_NEWSIZE       THEN idcmpList.add('IDCMP_NEWSIZE')
  IF self.idcmp AND IDCMP_REFRESHWINDOW THEN idcmpList.add('IDCMP_REFRESHWINDOW')
  IF self.idcmp AND IDCMP_SIZEVERIFY    THEN idcmpList.add('IDCMP_SIZEVERIFY')
  
  IF self.idcmp AND IDCMP_VANILLAKEY     THEN idcmpList.add('IDCMP_VANILLAKEY')
  IF self.idcmp AND IDCMP_RAWKEY         THEN idcmpList.add('IDCMP_RAWKEY')
  IF self.idcmp AND IDCMP_NEWPREFS       THEN idcmpList.add('IDCMP_NEWPREFS')
  IF self.idcmp AND IDCMP_DISKINSERTED   THEN idcmpList.add('IDCMP_DISKINSERTED')
  
  IF self.idcmp AND IDCMP_DISKREMOVED     THEN idcmpList.add('IDCMP_DISKREMOVED')
  IF self.idcmp AND IDCMP_INTUITICKS      THEN idcmpList.add('IDCMP_INTUITICKS')
  IF self.idcmp AND IDCMP_IDCMPUPDATE     THEN idcmpList.add('IDCMP_IDCMPUPDATE')
  IF self.idcmp AND IDCMP_CHANGEWINDOW    THEN idcmpList.add('IDCMP_CHANGEWINDOW')

  srcGen.componentPropertyListOr('WA_IDCMP',idcmpList)
  END idcmpList
  
ENDPROC

EXPORT PROC allowChildren() OF windowObject IS -1

EXPORT PROC addChildTag() OF windowObject IS LAYOUT_ADDCHILD

EXPORT PROC removeChildTag() OF windowObject IS LAYOUT_REMOVECHILD

EXPORT PROC addImageTag() OF windowObject IS LAYOUT_ADDIMAGE

EXPORT PROC addChildTo() OF windowObject IS self.previewRootLayout

EXPORT PROC createWindowObject(parent)
  DEF window:PTR TO windowObject
  
  NEW window.create(parent)
ENDPROC window
