OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'gadgets/getscreenmode','getscreenmode',
        'gadgets/string','string',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'gadgets/chooser','chooser',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen'

EXPORT ENUM GETSCREENGAD_NAME, GETSCREENGAD_TITLE,
            GETSCREENGAD_LEFT, GETSCREENGAD_TOP, GETSCREENGAD_WIDTH, GETSCREENGAD_HEIGHT, 
            GETSCREENGAD_MINWIDTH, GETSCREENGAD_MAXWIDTH, GETSCREENGAD_MINHEIGHT, GETSCREENGAD_MAXHEIGHT, 
            GETSCREENGAD_MINDEPTH, GETSCREENGAD_MAXDEPTH, GETSCREENGAD_INFOLEFT, GETSCREENGAD_INFOTOP, 
            GETSCREENGAD_OSCANTYPE, GETSCREENGAD_DISPLAYID, GETSCREENGAD_PROPFLAGS, GETSCREENGAD_PROPMASK, 
            GETSCREENGAD_AUTOSCROLL, GETSCREENGAD_INFOOPENED, GETSCREENGAD_DOWIDTH, GETSCREENGAD_DOHEIGHT, 
            GETSCREENGAD_DODEPTH, GETSCREENGAD_DOOSCAN, GETSCREENGAD_DOAUTOSCROLL,
            GETSCREENGAD_OK, GETSCREENGAD_CHILD, GETSCREENGAD_CANCEL
      

CONST NUM_GETSCREEN_GADS=GETSCREENGAD_CANCEL+1

EXPORT OBJECT getScreenModeObject OF reactionObject
  title[80]:ARRAY OF CHAR
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  sMinWidth:INT
  sMaxWidth:INT
  sMinHeight:INT
  sMaxHeight:INT
  sMinDepth:INT
  sMaxDepth:INT
  infoLeftEdge:INT
  infoTopEdge:INT
  oscanType:CHAR
  displayId:LONG
  propertyFlags:CHAR
  propertyMask:CHAR
  autoScroll:CHAR
  infoOpened:CHAR
  doWidth:CHAR
  doHeight:CHAR
  doDepth:CHAR
  doOverscan:CHAR
  doAutoScroll:CHAR
ENDOBJECT

OBJECT getScreenModeSettingsForm OF reactionForm
PRIVATE
  getScreenModeObject:PTR TO getScreenModeObject
  labels1:LONG
  labels2:LONG
  labels3:LONG
ENDOBJECT

PROC create() OF getScreenModeSettingsForm
  DEF gads:PTR TO LONG
  DEF arrows,scr:PTR TO screen
  
  NEW gads[NUM_GETSCREEN_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_GETSCREEN_GADS]
  self.gadgetActions:=gads
  
  scr:=LockPubScreen(NIL)
  arrows:=(scr.width>=800)
  UnlockPubScreen(NIL,scr)
 
  self.windowObj:=WindowObject,
    WA_TITLE, 'GetScreenMode Attribute Setting',
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
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_NAME ]:=StringObject,
          GA_ID, GETSCREENGAD_NAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'GetScreenMode _Name',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_TITLE ]:=StringObject,
          GA_ID, GETSCREENGAD_TITLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'GetScreenMode _Title',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
      
        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_LEFT ]:=IntegerObject,
          GA_ID, GETSCREENGAD_LEFT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Left Edge',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_TOP ]:=IntegerObject,
          GA_ID, GETSCREENGAD_TOP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Top Edge',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_WIDTH ]:=IntegerObject,
          GA_ID, GETSCREENGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_HEIGHT ]:=IntegerObject,
          GA_ID, GETSCREENGAD_HEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Height',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
      
        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_MINWIDTH ]:=IntegerObject,
          GA_ID, GETSCREENGAD_MINWIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MinWidth',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_MAXWIDTH ]:=IntegerObject,
          GA_ID, GETSCREENGAD_MAXWIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxWidth',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_MINHEIGHT ]:=IntegerObject,
          GA_ID, GETSCREENGAD_MINHEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MinHeight',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_MAXHEIGHT ]:=IntegerObject,
          GA_ID, GETSCREENGAD_MAXHEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxHeight',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
      
        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_MINDEPTH ]:=IntegerObject,
          GA_ID, GETSCREENGAD_MINDEPTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MinDepth',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_MAXDEPTH ]:=IntegerObject,
          GA_ID, GETSCREENGAD_MAXDEPTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxDepth',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_INFOLEFT ]:=IntegerObject,
          GA_ID, GETSCREENGAD_INFOLEFT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'InfoLeftEdge',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_INFOTOP ]:=IntegerObject,
          GA_ID, GETSCREENGAD_INFOTOP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'InfoTopEdge',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_FIXEDHORIZ, FALSE,
        LAYOUT_SHRINKWRAP, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_OSCANTYPE ]:=ChooserObject,
          GA_ID, GETSCREENGAD_OSCANTYPE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['OSCAN_TEXT', 'OSCAN_STANDARD', 'OSCAN_MAX', 'OSCAN_VIDEO',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Over_ScanType',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_DISPLAYID ]:=ChooserObject,
          GA_ID, GETSCREENGAD_DISPLAYID,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['LORES_KEY','HIRES_KEY','SUPER_KEY','HAM_KEY','LORESLACE_KEY','HIRESLACE_KEY',
    'SUPERLACE_KEY','HAMLACE_KEY','EXTRAHALFBRITE_KEY','EXTRAHALFBRITELACE_KEY',
    'HIRESHAM_KEY','SUPERHAM_KEY','HIRESEHB_KEY','SUPEREHB_KEY',
    'HIRESHAMLACE_KEY','SUPERHAMLACE_KEY','HIRESEHBLACE_KEY','SUPEREHBLACE_KEY',
    'LORESSDBL_KEY','LORESHAMSDBL_KEY','LORESEHBSDBL_KEY','HIRESHAMSDBL_KEY',
    'VGAEXTRALORES_KEY','VGALORES_KEY','VGAPRODUCT_KEY','VGAHAM_KEY',
    'VGAEXTRALORESLACE_KEY','VGALORESLACE_KEY','VGAPRODUCTLACE_KEY',
    'VGAHAMLACE_KEY','VGAPRODUCTHAM_KEY','VGALORESHAM_KEY',
    'VGAEXTRALORESHAM_KEY','VGAPRODUCTHAMLACE_KEY',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Display_ID',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_FIXEDHORIZ, FALSE,
        LAYOUT_INNERSPACING,0,
        LAYOUT_SHRINKWRAP, TRUE,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_PROPFLAGS ]:=ChooserObject,
          GA_ID, GETSCREENGAD_PROPFLAGS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_LABELS, self.labels3:=chooserLabelsA(['DIPF_IS_LACE','DIPF_IS_DUALPF','DIPF_IS_PF2PRI','DIPF_IS_HAM','DIPF_IS_ECS6','DIPF_IS_AA','DIPF_IS_PAL','DIPF_IS_SPRITES',
    'DIPF_IS_GENLOCK','DIPF_IS_WB','DIPF_IS_DRAGGABLE','DIPF_IS_PANELLED','DIPF_IS_BEAMSYNC','DIPF_IS_EXTRAHALFBRITE',
    'DIPF_IS_SPRITES_ATT','DIPF_IS_SPRITES_CHNG_RES','DIPF_IS_SPRITES_BORDER','DIPF_IS_SCANDBL','DIPF_IS_SPRITES_CHNG_BASE',
    'DIPF_IS_SPRITES_CHNG_PRI','DIPF_IS_DBUFFER','DIPF_IS_PROGBEAM','DIPF_IS_FOREIGN',0]),
            
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Prop_Flags',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_PROPMASK ]:=ChooserObject,
          GA_ID, GETSCREENGAD_PROPMASK,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels3,
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Prop_Mask',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_AUTOSCROLL ]:=CheckBoxObject,
          GA_ID, GETSCREENGAD_AUTOSCROLL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_AutoScroll',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_INFOOPENED ]:=CheckBoxObject,
          GA_ID, GETSCREENGAD_INFOOPENED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'In_foOpened',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_DOWIDTH ]:=CheckBoxObject,
          GA_ID, GETSCREENGAD_DOWIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Do_Width',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_DOHEIGHT ]:=CheckBoxObject,
          GA_ID, GETSCREENGAD_DOHEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Do_Height',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_DODEPTH ]:=CheckBoxObject,
          GA_ID, GETSCREENGAD_DODEPTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoDe_pth',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_DOOSCAN ]:=CheckBoxObject,
          GA_ID, GETSCREENGAD_DOOSCAN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoO_verScan',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETSCREENGAD_DOAUTOSCROLL ]:=CheckBoxObject,
          GA_ID, GETSCREENGAD_DOAUTOSCROLL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoAutoScro_ll',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_OK ]:=ButtonObject,
          GA_ID, GETSCREENGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_CHILD ]:=ButtonObject,
          GA_ID, GETSCREENGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETSCREENGAD_CANCEL ]:=ButtonObject,
          GA_ID, GETSCREENGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[GETSCREENGAD_CHILD]:={editChildSettings}
  self.gadgetActions[GETSCREENGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[GETSCREENGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF getScreenModeSettingsForm
  self:=nself
  self.setBusy()
  self.getScreenModeObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF getScreenModeSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )
  END self.gadgetList[NUM_GETSCREEN_GADS]
  END self.gadgetActions[NUM_GETSCREEN_GADS]
ENDPROC

PROC editSettings(comp:PTR TO getScreenModeObject) OF getScreenModeSettingsForm
  DEF res

  self.getScreenModeObject:=comp

  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_TITLE ],0,0,[STRINGA_TEXTVAL,comp.title,0])

  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_LEFT ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_TOP ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])

  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_MINWIDTH ],0,0,[INTEGER_NUMBER,comp.sMinWidth,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_MAXWIDTH ],0,0,[INTEGER_NUMBER,comp.sMaxWidth,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_MINHEIGHT ],0,0,[INTEGER_NUMBER,comp.sMinHeight,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_MAXHEIGHT ],0,0,[INTEGER_NUMBER,comp.sMaxHeight,0])

  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_MINDEPTH ],0,0,[INTEGER_NUMBER,comp.sMinDepth,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_MAXDEPTH ],0,0,[INTEGER_NUMBER,comp.sMaxDepth,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_INFOLEFT ],0,0,[INTEGER_NUMBER,comp.infoLeftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_INFOTOP ],0,0,[INTEGER_NUMBER,comp.infoTopEdge,0])

  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_OSCANTYPE ],0,0,[CHOOSER_SELECTED,comp.oscanType,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_DISPLAYID ],0,0,[CHOOSER_SELECTED,comp.displayId,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_PROPFLAGS ],0,0,[CHOOSER_SELECTED,comp.propertyFlags,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_PROPMASK ],0,0,[CHOOSER_SELECTED,comp.propertyMask,0]) 

  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_AUTOSCROLL ],0,0,[CHECKBOX_CHECKED,comp.autoScroll,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_INFOOPENED ],0,0,[CHECKBOX_CHECKED,comp.infoOpened,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_DOWIDTH ],0,0,[CHECKBOX_CHECKED,comp.doWidth,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_DOHEIGHT ],0,0,[CHECKBOX_CHECKED,comp.doHeight,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_DODEPTH ],0,0,[CHECKBOX_CHECKED,comp.doDepth,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_DOOSCAN ],0,0,[CHECKBOX_CHECKED,comp.doOverscan,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETSCREENGAD_DOAUTOSCROLL ],0,0,[CHECKBOX_CHECKED,comp.doAutoScroll,0]) 

  res:=self.showModal()
  IF res=MR_OK

    AstrCopy(comp.name,Gets(self.gadgetList[ GETSCREENGAD_NAME ],STRINGA_TEXTVAL))
    AstrCopy(comp.title,Gets(self.gadgetList[ GETSCREENGAD_TITLE ],STRINGA_TEXTVAL))

    comp.leftEdge:=Gets(self.gadgetList[ GETSCREENGAD_LEFT ],INTEGER_NUMBER)
    comp.topEdge:=Gets(self.gadgetList[ GETSCREENGAD_TOP ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ GETSCREENGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ GETSCREENGAD_HEIGHT ],INTEGER_NUMBER)

    comp.sMinWidth:=Gets(self.gadgetList[ GETSCREENGAD_MINWIDTH ],INTEGER_NUMBER)
    comp.sMaxWidth:=Gets(self.gadgetList[ GETSCREENGAD_MAXWIDTH ],INTEGER_NUMBER)
    comp.sMinHeight:=Gets(self.gadgetList[ GETSCREENGAD_MINHEIGHT ],INTEGER_NUMBER)
    comp.sMaxHeight:=Gets(self.gadgetList[ GETSCREENGAD_MAXHEIGHT ],INTEGER_NUMBER)

    comp.sMinDepth:=Gets(self.gadgetList[ GETSCREENGAD_MINDEPTH ],INTEGER_NUMBER)
    comp.sMaxDepth:=Gets(self.gadgetList[ GETSCREENGAD_MAXDEPTH ],INTEGER_NUMBER)
    comp.infoLeftEdge:=Gets(self.gadgetList[ GETSCREENGAD_INFOLEFT ],INTEGER_NUMBER)
    comp.infoTopEdge:=Gets(self.gadgetList[ GETSCREENGAD_INFOTOP ],INTEGER_NUMBER)

    comp.oscanType:=Gets(self.gadgetList[ GETSCREENGAD_OSCANTYPE ],CHOOSER_SELECTED)
    comp.displayId:=Gets(self.gadgetList[ GETSCREENGAD_DISPLAYID ],CHOOSER_SELECTED)
    comp.propertyFlags:=Gets(self.gadgetList[ GETSCREENGAD_PROPFLAGS ],CHOOSER_SELECTED)
    comp.propertyMask:=Gets(self.gadgetList[ GETSCREENGAD_PROPMASK ],CHOOSER_SELECTED)

    comp.autoScroll:=Gets(self.gadgetList[ GETSCREENGAD_AUTOSCROLL ],CHECKBOX_CHECKED)
    comp.infoOpened:=Gets(self.gadgetList[ GETSCREENGAD_INFOOPENED ],CHECKBOX_CHECKED)
    comp.doWidth:=Gets(self.gadgetList[ GETSCREENGAD_DOWIDTH ],CHECKBOX_CHECKED)
    comp.doHeight:=Gets(self.gadgetList[ GETSCREENGAD_DOHEIGHT ],CHECKBOX_CHECKED)
    comp.doDepth:=Gets(self.gadgetList[ GETSCREENGAD_DODEPTH ],CHECKBOX_CHECKED)
    comp.doOverscan:=Gets(self.gadgetList[ GETSCREENGAD_DOOSCAN ],CHECKBOX_CHECKED)
    comp.doAutoScroll:=Gets(self.gadgetList[ GETSCREENGAD_DOAUTOSCROLL ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF getScreenModeObject
  self.previewObject:=GetScreenModeObject,
    GA_RELVERIFY, TRUE,
    GA_TABCYCLE, TRUE,
  TAG_DONE])
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)
  
  IF StrLen(self.name)>0
    self.previewChildAttrs:=[
          LAYOUT_MODIFYCHILD, self.previewObject,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, self.name,
          LabelEnd,
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
  ELSE
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
  ENDIF
ENDPROC

EXPORT PROC create(parent) OF getScreenModeObject
  self.type:=TYPE_GETSCREENMODE
  SUPER self.create(parent)

  AstrCopy(self.title,'Scren Mode Selection')
  self.leftEdge:=30
  self.topEdge:=20
  self.width:=300
  self.height:=200

  self.sMinWidth:=16
  self.sMaxWidth:=16368
  self.sMinHeight:=16
  self.sMaxHeight:=16368
  self.sMinDepth:=1
  self.sMaxDepth:=24
  self.infoLeftEdge:=30
  self.infoTopEdge:=20
  self.oscanType:=0
  self.displayId:=0
  self.propertyFlags:=9
  self.propertyMask:=9
  self.autoScroll:=TRUE
  self.infoOpened:=TRUE
  self.doWidth:=0
  self.doHeight:=0
  self.doDepth:=0
  self.doOverscan:=0
  self.doAutoScroll:=0

  self.libsused:=[TYPE_GETSCREENMODE,TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF getScreenModeObject
  DEF editForm:PTR TO getScreenModeSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF getScreenModeObject IS
[
  makeProp(title,FIELDTYPE_STR),
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(sMinWidth,FIELDTYPE_INT),
  makeProp(sMaxWidth,FIELDTYPE_INT),
  makeProp(sMinHeight,FIELDTYPE_INT),
  makeProp(sMaxHeight,FIELDTYPE_INT),
  makeProp(sMinDepth,FIELDTYPE_INT),
  makeProp(sMaxDepth,FIELDTYPE_INT),
  makeProp(infoLeftEdge,FIELDTYPE_INT),
  makeProp(infoTopEdge,FIELDTYPE_INT),
  makeProp(oscanType,FIELDTYPE_CHAR),
  makeProp(displayId,FIELDTYPE_LONG),
  makeProp(propertyFlags,FIELDTYPE_CHAR),
  makeProp(propertyMask,FIELDTYPE_CHAR),
  makeProp(autoScroll,FIELDTYPE_CHAR),
  makeProp(infoOpened,FIELDTYPE_CHAR),
  makeProp(doWidth,FIELDTYPE_CHAR),
  makeProp(doHeight,FIELDTYPE_CHAR),
  makeProp(doDepth,FIELDTYPE_CHAR),
  makeProp(doOverscan,FIELDTYPE_CHAR),
  makeProp(doAutoScroll,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF getScreenModeObject
  DEF propflags

  propflags:=['DIPF_IS_LACE','DIPF_IS_DUALPF','DIPF_IS_PF2PRI','DIPF_IS_HAM','DIPF_IS_ECS6','DIPF_IS_AA','DIPF_IS_PAL','DIPF_IS_SPRITES',
      'DIPF_IS_GENLOCK','DIPF_IS_WB','DIPF_IS_DRAGGABLE','DIPF_IS_PANELLED','DIPF_IS_BEAMSYNC','DIPF_IS_EXTRAHALFBRITE',
      'DIPF_IS_SPRITES_ATT','DIPF_IS_SPRITES_CHNG_RES','DIPF_IS_SPRITES_BORDER','DIPF_IS_SCANDBL','DIPF_IS_SPRITES_CHNG_BASE',
      'DIPF_IS_SPRITES_CHNG_PRI','DIPF_IS_DBUFFER','DIPF_IS_PROGBEAM','DIPF_IS_FOREIGN'] 

  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  IF StrLen(self.title) THEN srcGen.componentProperty('GETSCREENMODE_TitleText',self.title,TRUE)
  IF self.leftEdge<>30 THEN srcGen.componentPropertyInt('GETSCREENMODE_LeftEdge',self.leftEdge)
  IF self.topEdge<>20 THEN srcGen.componentPropertyInt('GETSCREENMODE_TopEdge',self.topEdge)
  IF self.width<>300 THEN srcGen.componentPropertyInt('GETSCREENMODE_Width',self.width)
  IF self.height<>200 THEN srcGen.componentPropertyInt('GETSCREENMODE_Height',self.height)
  
  IF self.sMinWidth<>16 THEN srcGen.componentPropertyInt('GETSCREENMODE_MinWidth',self.sMinWidth)
  IF self.sMaxWidth<>16368 THEN srcGen.componentPropertyInt('GETSCREENMODE_MaxWidth',self.sMaxWidth)
  
  IF self.sMinHeight<>16 THEN srcGen.componentPropertyInt('GETSCREENMODE_MinHeight',self.sMinHeight)
  IF self.sMaxHeight<>16368 THEN srcGen.componentPropertyInt('GETSCREENMODE_MaxHeight',self.sMaxHeight)
  
  IF self.sMinDepth<>1 THEN srcGen.componentPropertyInt('GETSCREENMODE_MinDepth',self.sMinDepth)
  IF self.sMaxDepth<>24 THEN srcGen.componentPropertyInt('GETSCREENMODE_MaxDepth',self.sMaxDepth)

  IF self.infoLeftEdge<>30 THEN srcGen.componentPropertyInt('GETSCREENMODE_InfoLeftEdge',self.infoLeftEdge)
  IF self.infoTopEdge<>20 THEN srcGen.componentPropertyInt('GETSCREENMODE_InfoTopEdge',self.infoTopEdge)

  IF self.oscanType<>0 THEN srcGen.componentProperty('GETSCREENMODE_OverscanType',ListItem(['OSCAN_TEXT', 'OSCAN_STANDARD', 'OSCAN_MAX', 'OSCAN_VIDEO'],self.oscanType),FALSE)
  IF self.displayId<>0 THEN srcGen.componentProperty('GETSCREENMODE_DisplayID',ListItem(['LORES_KEY','HIRES_KEY','SUPER_KEY','HAM_KEY','LORESLACE_KEY','HIRESLACE_KEY',
      'SUPERLACE_KEY','HAMLACE_KEY','EXTRAHALFBRITE_KEY','EXTRAHALFBRITELACE_KEY',
      'HIRESHAM_KEY','SUPERHAM_KEY','HIRESEHB_KEY','SUPEREHB_KEY',
      'HIRESHAMLACE_KEY','SUPERHAMLACE_KEY','HIRESEHBLACE_KEY','SUPEREHBLACE_KEY',
      'LORESSDBL_KEY','LORESHAMSDBL_KEY','LORESEHBSDBL_KEY','HIRESHAMSDBL_KEY',
      'VGAEXTRALORES_KEY','VGALORES_KEY','VGAPRODUCT_KEY','VGAHAM_KEY',
      'VGAEXTRALORESLACE_KEY','VGALORESLACE_KEY','VGAPRODUCTLACE_KEY',
      'VGAHAMLACE_KEY','VGAPRODUCTHAM_KEY','VGALORESHAM_KEY',
      'VGAEXTRALORESHAM_KEY','VGAPRODUCTHAMLACE_KEY',0],self.displayId),FALSE)

  IF self.propertyFlags<>9 THEN srcGen.componentProperty('GETSCREENMODE_PropertyFlags',ListItem(propflags,self.propertyFlags),FALSE)
  IF self.propertyMask<>9 THEN srcGen.componentProperty('GETSCREENMODE_GETSCREENMODE_PropertyMask',ListItem(propflags,self.propertyMask),FALSE)
 
  IF self.autoScroll=FALSE THEN srcGen.componentProperty('GETSCREENMODE_AutoScroll','FALSE',FALSE)
  IF self.infoOpened THEN srcGen.componentProperty('GETSCREENMODE_InfoOpened','TRUE',FALSE)

  IF self.doWidth THEN srcGen.componentProperty('GETSCREENMODE_DoWidth','TRUE',FALSE)
  IF self.doHeight THEN srcGen.componentProperty('GETSCREENMODE_DoHeight','TRUE',FALSE)
  IF self.doDepth THEN srcGen.componentProperty('GETSCREENMODE_DoDepth','TRUE',FALSE)
  IF self.doOverscan THEN srcGen.componentProperty('GETSCREENMODE_DoOverscanType','TRUE',FALSE)
  IF self.doAutoScroll THEN srcGen.componentProperty('GETSCREENMODE_DoAutoScroll','TRUE',FALSE)
ENDPROC

EXPORT PROC getTypeName() OF getScreenModeObject
  RETURN 'GetScreenMode'
ENDPROC

EXPORT PROC getTypeEndName() OF getScreenModeObject
  RETURN 'End'
ENDPROC

EXPORT PROC createGetScreenModeObject(parent)
  DEF getscreen:PTR TO getScreenModeObject
  
  NEW getscreen.create(parent)
ENDPROC getscreen
