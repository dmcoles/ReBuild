OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'string',
        '*textfield',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'gadgets/scroller',
        'images/label','label',
        'images/bevel',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/screens',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'intuition/icclass',
        'utility/tagitem'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourceGen','*validator','*stringlist'

EXPORT ENUM TEXTFIELDGAD_IDENT, TEXTFIELDGAD_LABEL, TEXTFIELDGAD_HINT, TEXTFIELDGAD_DELIM, TEXTFIELDGAD_ACCEPT, TEXTFIELDGAD_REJECT, 
      TEXTFIELDGAD_BLINKRATE, TEXTFIELDGAD_MAXSIZE, TEXTFIELDGAD_SPACING, TEXTFIELDGAD_TABSPACES,
      TEXTFIELDGAD_DISABLED, TEXTFIELDGAD_TABCYCLE, TEXTFIELDGAD_BLOCK, TEXTFIELDGAD_MAXSIZEBEEP, TEXTFIELDGAD_PARTIAL,
      TEXTFIELDGAD_NOGHOST, TEXTFIELDGAD_READONLY, TEXTFIELDGAD_NONPRINTCHARS, TEXTFIELDGAD_INVERTED, TEXTFIELDGAD_VCENTER,
      TEXTFIELDGAD_USERALIGN, TEXTFIELDGAD_RULEDPAPER, TEXTFIELDGAD_LINKTOVSCROLL,
      TEXTFIELDGAD_PAPERPEN, TEXTFIELDGAD_INKPEN, TEXTFIELDGAD_LINEPEN,
      TEXTFIELDGAD_BORDER, TEXTFIELDGAD_ALIGN,
      TEXTFIELDGAD_OK, TEXTFIELDGAD_CHILD, TEXTFIELDGAD_CANCEL

CONST NUM_TEXTFIELD_GADS=TEXTFIELDGAD_CANCEL+1
// V1 attributes

CONST TEXTFIELD_TEXT=$84000001
CONST TEXTFIELD_INSERTTEXT=$84000002
CONST TEXTFIELD_TEXTFONT=$84000003
CONST TEXTFIELD_DELIMITERS=$84000004
CONST TEXTFIELD_TOP=$84000005
CONST TEXTFIELD_BLOCKCURSOR=$84000006
CONST TEXTFIELD_SIZE=$84000007
CONST TEXTFIELD_VISIBLE=$84000008
CONST TEXTFIELD_LINES=$84000009
CONST TEXTFIELD_NOGHOST=$8400000A
CONST TEXTFIELD_MAXSIZE=$8400000B
CONST TEXTFIELD_BORDER=$8400000C
CONST TEXTFIELD_TEXTATTR=$8400000D
CONST TEXTFIELD_FONTSTYLE=$8400000E
CONST TEXTFIELD_UP=$8400000F
CONST TEXTFIELD_DOWN=$84000010
CONST TEXTFIELD_ALIGNMENT=$84000011
CONST TEXTFIELD_VCENTER=$84000012
CONST TEXTFIELD_RULEDPAPER=$84000013
CONST TEXTFIELD_PAPERPEN=$84000014
CONST TEXTFIELD_INKPEN=$84000015
CONST TEXTFIELD_LINEPEN=$84000016
CONST TEXTFIELD_USERALIGN=$84000017
CONST TEXTFIELD_SPACING=$84000018
CONST TEXTFIELD_CLIPSTREAM=$84000019
CONST TEXTFIELD_CLIPSTREAM2=$8400001A
CONST TEXTFIELD_UNDOSTREAM=$8400001A
CONST TEXTFIELD_BLINKRATE=$8400001B
CONST TEXTFIELD_INVERTED=$8400001C
CONST TEXTFIELD_PARTIAL=$8400001D
CONST TEXTFIELD_CURSORPOS=$8400001E

// V2 attributes

CONST TEXTFIELD_READONLY=$8400001F
CONST TEXTFIELD_MODIFIED=$84000020
CONST TEXTFIELD_ACCEPTCHARS=$84000021
CONST TEXTFIELD_REJECTCHARS=$84000022
CONST TEXTFIELD_PASSCOMMAND=$84000023
CONST TEXTFIELD_LINELENGTH=$84000024
CONST TEXTFIELD_MAXSIZEBEEP=$84000025
CONST TEXTFIELD_DELETETEXT=$84000026
CONST TEXTFIELD_SELECTSIZE=$84000027
CONST TEXTFIELD_COPY=$84000028
CONST TEXTFIELD_COPYALL=$84000029
CONST TEXTFIELD_CUT=$8400002A
CONST TEXTFIELD_PASTE=$8400002B
CONST TEXTFIELD_ERASE=$8400002C
CONST TEXTFIELD_UNDO=$8400002D

// V3 ATTRIBUTES

CONST TEXTFIELD_TABSPACES=$8400002E
CONST TEXTFIELD_NONPRINTCHARS=$8400002F

CONST TEXTFIELD_BORDER_NONE=0
CONST TEXTFIELD_BORDER_BEVEL=1
CONST TEXTFIELD_BORDER_DOUBLEBEVEL=2

CONST TEXTFIELD_ALIGN_LEFT=0
CONST TEXTFIELD_ALIGN_CENTER=1
CONST TEXTFIELD_ALIGN_RIGHT=2


EXPORT OBJECT textFieldObject OF reactionObject
  delimiters[80]:ARRAY OF CHAR
  acceptChars[80]:ARRAY OF CHAR
  rejectChars[80]:ARRAY OF CHAR
  blinkRate:LONG
  maxSize:INT
  spacing:INT
  tabSpaces:INT
  disabled:CHAR
  tabCycle:CHAR
  blockCursor:CHAR
  maxSizeBeep:CHAR
  partial:CHAR
  noGhost:CHAR
  readOnly:CHAR
  nonPrintChars:CHAR
  inverted:CHAR
  vCenter:CHAR
  userAlign:CHAR
  ruledPaper:CHAR
  linkToVScroll:INT
  paperPen:INT
  inkPen:INT
  linePen:INT
  border:CHAR
  align:CHAR
ENDOBJECT

OBJECT textFieldSettingsForm OF reactionForm
PRIVATE
  textFieldObject:PTR TO textFieldObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
  labels3:PTR TO LONG
  tempPaperPen:INT
  tempInkPen:INT
  tempLinePen:INT
ENDOBJECT

PROC create() OF textFieldSettingsForm
  DEF gads:PTR TO LONG
  DEF arrows,scr:PTR TO screen
  
  NEW gads[NUM_TEXTFIELD_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_TEXTFIELD_GADS]
  self.gadgetActions:=gads
  
  scr:=LockPubScreen(NIL)
  arrows:=(scr.width>=800)
  UnlockPubScreen(NIL,scr)

  self.windowObj:=WindowObject,
    WA_TITLE, 'TextField Attribute Setting',
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

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_IDENT ]:=StringObject,
          GA_ID, TEXTFIELDGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_LABEL ]:=StringObject,
          GA_ID, TEXTFIELDGAD_LABEL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Label',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_HINT ]:=ButtonObject,
          GA_ID, TEXTFIELDGAD_HINT,
          GA_TEXT, 'Hint',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,           
        CHILD_WEIGHTEDWIDTH,50,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        
        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_DELIM ]:=StringObject,
          GA_ID, TEXTFIELDGAD_DELIM,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Delimiters',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_ACCEPT ]:=StringObject,
          GA_ID, TEXTFIELDGAD_ACCEPT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_AcceptChars',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_REJECT ]:=StringObject,
          GA_ID, TEXTFIELDGAD_REJECT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_RejectChars',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_BLINKRATE ]:=IntegerObject,
          GA_ID, TEXTFIELDGAD_BLINKRATE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'BlinkRate',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_MAXSIZE ]:=IntegerObject,
          GA_ID, TEXTFIELDGAD_MAXSIZE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxSize',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_SPACING ]:=IntegerObject,
          GA_ID, TEXTFIELDGAD_SPACING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Spacing',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_TABSPACES ]:=IntegerObject,
          GA_ID, TEXTFIELDGAD_TABSPACES,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'TabSpaces',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_TABCYCLE ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_TABCYCLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'TabCycle',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_BLOCK ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_BLOCK,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'BlockCursor',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_MAXSIZEBEEP ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_MAXSIZEBEEP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'MaxSizeBeep',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_PARTIAL ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_PARTIAL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Partial',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_NOGHOST ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_NOGHOST,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'NoGhost',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_READONLY ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_READONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'ReadOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_NONPRINTCHARS ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_NONPRINTCHARS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'NonPrintChars',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_INVERTED ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_INVERTED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Inverted',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_VCENTER ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_VCENTER,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'VCenter',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_USERALIGN ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_USERALIGN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'UserAlign',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_RULEDPAPER ]:=CheckBoxObject,
          GA_ID, TEXTFIELDGAD_RULEDPAPER,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'RuledPaper',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_LINKTOVSCROLL ]:=ChooserObject,
          GA_ID, TEXTFIELDGAD_LINKTOVSCROLL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 32,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels3:=chooserLabelsA(['None',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Link to scroller',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_PAPERPEN ]:=ButtonObject,
          GA_ID, TEXTFIELDGAD_PAPERPEN,
          GA_TEXT, 'PaperPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_INKPEN ]:=ButtonObject,
          GA_ID, TEXTFIELDGAD_INKPEN,
          GA_TEXT, 'InkPen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_LINEPEN ]:=ButtonObject,
          GA_ID, TEXTFIELDGAD_LINEPEN,
          GA_TEXT, 'LinePen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_BORDER ]:=ChooserObject,
          GA_ID, TEXTFIELDGAD_BORDER,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['TEXTFIELD_BORDER_NONE','TEXTFIELD_BORDER_BEVEL','TEXTFIELD_BORDER_DOUBLEBEVEL',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Border',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTFIELDGAD_ALIGN ]:=ChooserObject,
          GA_ID, TEXTFIELDGAD_ALIGN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['TEXTFIELD_ALIGN_LEFT','TEXTFIELD_ALIGN_CENTER','TEXTFIELD_ALIGN_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Justification',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_OK ]:=ButtonObject,
          GA_ID, TEXTFIELDGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_CHILD ]:=ButtonObject,
          GA_ID, TEXTFIELDGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTFIELDGAD_CANCEL ]:=ButtonObject,
          GA_ID, TEXTFIELDGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[TEXTFIELDGAD_PAPERPEN]:={selectPen}
  self.gadgetActions[TEXTFIELDGAD_INKPEN]:={selectPen}
  self.gadgetActions[TEXTFIELDGAD_LINEPEN]:={selectPen}
  self.gadgetActions[TEXTFIELDGAD_CHILD]:={editChildSettings}
  self.gadgetActions[TEXTFIELDGAD_HINT]:={editHint}  
  self.gadgetActions[TEXTFIELDGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[TEXTFIELDGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF textFieldSettingsForm
  self:=nself
  self.setBusy()
  self.textFieldObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC selectPen(nself,gadget,id,code) OF textFieldSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE TEXTFIELDGAD_PAPERPEN
      colourProp:={self.tempPaperPen}
    CASE TEXTFIELDGAD_INKPEN
      colourProp:={self.tempInkPen}
    CASE TEXTFIELDGAD_LINEPEN
      colourProp:={self.tempLinePen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC end() OF textFieldSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )

  END self.gadgetList[NUM_TEXTFIELD_GADS]
  END self.gadgetActions[NUM_TEXTFIELD_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF textFieldSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.textFieldObject,TEXTFIELDGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editHint(nself,gadget,id,code) OF textFieldSettingsForm
  self:=nself
  self.setBusy()
  self.textFieldObject.editHint()
  self.clearBusy()
  self.updateHint(TEXTFIELDGAD_HINT, self.textFieldObject.hintText)
ENDPROC

PROC editSettings(comp:PTR TO textFieldObject) OF textFieldSettingsForm
  DEF res
  DEF scrlgads:PTR TO LONG
  DEF i,selscroll
  DEF gad:PTR TO reactionObject
  DEF scrollgads:PTR TO stdlist
    
  NEW scrollgads.stdlist(10)
  comp.parent.findObjectsByType(scrollgads,TYPE_SCROLLER)
  
  scrlgads:=List(scrollgads.count()+2)
  ListAddItem(scrlgads,'None')
  selscroll:=0
  FOR i:=0 TO scrollgads.count()-1
    gad:=scrollgads.item(i)
    IF gad.id=comp.linkToVScroll THEN selscroll:=(i+1)
    ListAddItem(scrlgads,gad.ident)
  ENDFOR
  ListAddItem(scrlgads,0)
  freeChooserLabels(self.labels3)
  self.labels3:=chooserLabelsA(scrlgads)
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_LINKTOVSCROLL ],0,0,[CHOOSER_LABELS,self.labels3,0]) 
  DisposeLink(scrlgads)

  self.textFieldObject:=comp
    
  self.tempPaperPen:=comp.paperPen
  self.tempInkPen:=comp.inkPen
  self.tempLinePen:=comp.linePen
    
  self.updateHint(TEXTFIELDGAD_HINT, comp.hintText)     
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_LABEL ],0,0,[STRINGA_TEXTVAL,comp.label,0])
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_DELIM ],0,0,[STRINGA_TEXTVAL,comp.delimiters,0])
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_ACCEPT ],0,0,[STRINGA_TEXTVAL,comp.acceptChars,0])
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_REJECT ],0,0,[STRINGA_TEXTVAL,comp.rejectChars,0])

  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_BLINKRATE ],0,0,[INTEGER_NUMBER,comp.blinkRate,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_MAXSIZE ],0,0,[INTEGER_NUMBER,comp.maxSize,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_SPACING ],0,0,[INTEGER_NUMBER,comp.spacing,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_TABSPACES ],0,0,[INTEGER_NUMBER,comp.tabSpaces,0]) 
    
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_TABCYCLE ],0,0,[CHECKBOX_CHECKED,comp.tabCycle,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_BLOCK ],0,0,[CHECKBOX_CHECKED,comp.blockCursor,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_MAXSIZEBEEP ],0,0,[CHECKBOX_CHECKED,comp.maxSizeBeep,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_PARTIAL ],0,0,[CHECKBOX_CHECKED,comp.partial,0]) 

  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_NOGHOST ],0,0,[CHECKBOX_CHECKED,comp.noGhost,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_NONPRINTCHARS ],0,0,[CHECKBOX_CHECKED,comp.nonPrintChars,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_INVERTED ],0,0,[CHECKBOX_CHECKED,comp.inverted,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_VCENTER ],0,0,[CHECKBOX_CHECKED,comp.vCenter,0]) 

  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_USERALIGN ],0,0,[CHECKBOX_CHECKED,comp.userAlign,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_RULEDPAPER ],0,0,[CHECKBOX_CHECKED,comp.ruledPaper,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_LINKTOVSCROLL ],0,0,[CHOOSER_SELECTED,selscroll,0]) 

  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_BORDER ],0,0,[CHOOSER_SELECTED,comp.border,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTFIELDGAD_ALIGN ],0,0,[CHOOSER_SELECTED,comp.align,0]) 
    
  res:=self.showModal()
  IF res=MR_OK
  
    comp.paperPen:=self.tempPaperPen
    comp.inkPen:=self.tempInkPen
    comp.linePen:=self.tempLinePen

    AstrCopy(comp.ident,Gets(self.gadgetList[ TEXTFIELDGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.label,Gets(self.gadgetList[ TEXTFIELDGAD_LABEL ],STRINGA_TEXTVAL))
    AstrCopy(comp.delimiters,Gets(self.gadgetList[ TEXTFIELDGAD_DELIM ],STRINGA_TEXTVAL))
    AstrCopy(comp.acceptChars,Gets(self.gadgetList[ TEXTFIELDGAD_ACCEPT ],STRINGA_TEXTVAL))
    AstrCopy(comp.rejectChars,Gets(self.gadgetList[ TEXTFIELDGAD_REJECT ],STRINGA_TEXTVAL))

    comp.blinkRate:=Gets(self.gadgetList[ TEXTFIELDGAD_BLINKRATE ],INTEGER_NUMBER)
    comp.maxSize:=Gets(self.gadgetList[ TEXTFIELDGAD_MAXSIZE ],INTEGER_NUMBER)
    comp.spacing:=Gets(self.gadgetList[ TEXTFIELDGAD_SPACING ],INTEGER_NUMBER)
    comp.tabSpaces:=Gets(self.gadgetList[ TEXTFIELDGAD_TABSPACES ],INTEGER_NUMBER)

    comp.disabled:=Gets(self.gadgetList[ TEXTFIELDGAD_DISABLED ],CHECKBOX_CHECKED)
    comp.tabCycle:=Gets(self.gadgetList[ TEXTFIELDGAD_TABCYCLE ],CHECKBOX_CHECKED)
    comp.blockCursor:=Gets(self.gadgetList[ TEXTFIELDGAD_BLOCK ],CHECKBOX_CHECKED)
    comp.maxSizeBeep:=Gets(self.gadgetList[ TEXTFIELDGAD_MAXSIZEBEEP ],CHECKBOX_CHECKED)
    comp.partial:=Gets(self.gadgetList[ TEXTFIELDGAD_PARTIAL ],CHECKBOX_CHECKED)

    comp.noGhost:=Gets(self.gadgetList[ TEXTFIELDGAD_NOGHOST ],CHECKBOX_CHECKED)
    comp.readOnly:=Gets(self.gadgetList[ TEXTFIELDGAD_READONLY ],CHECKBOX_CHECKED)
    comp.nonPrintChars:=Gets(self.gadgetList[ TEXTFIELDGAD_NONPRINTCHARS ],CHECKBOX_CHECKED)
    comp.inverted:=Gets(self.gadgetList[ TEXTFIELDGAD_INVERTED ],CHECKBOX_CHECKED)
    comp.vCenter:=Gets(self.gadgetList[ TEXTFIELDGAD_VCENTER ],CHECKBOX_CHECKED)

    comp.userAlign:=Gets(self.gadgetList[ TEXTFIELDGAD_USERALIGN ],CHECKBOX_CHECKED)
    comp.ruledPaper:=Gets(self.gadgetList[ TEXTFIELDGAD_RULEDPAPER ],CHECKBOX_CHECKED)
    selscroll:=Gets(self.gadgetList[ TEXTFIELDGAD_LINKTOVSCROLL ],CHOOSER_SELECTED)

    comp.border:=Gets(self.gadgetList[ TEXTFIELDGAD_BORDER ],CHOOSER_SELECTED)
    comp.align:=Gets(self.gadgetList[ TEXTFIELDGAD_ALIGN ],CHOOSER_SELECTED)

    comp.linkToVScroll:=0
    FOR i:=0 TO scrollgads.count()-1
      gad:=scrollgads.item(i)
      selscroll--
      IF selscroll=0 THEN comp.linkToVScroll:=gad.id
    ENDFOR
  ENDIF
  END scrollgads
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF textFieldObject
  self.previewObject:=0
  IF (textfieldbase)
    self.previewObject:=NewObjectA(TextField_GetClass(), NIL,[
      GA_ID, self.id,
      GA_RELVERIFY, TRUE,
      GA_DISABLED, self.disabled,
      GA_TABCYCLE, self.tabCycle,
      TEXTFIELD_READONLY, self.readOnly,
      
      TEXTFIELD_DELIMITERS, self.delimiters,
      TEXTFIELD_ACCEPTCHARS, IF StrLen(self.acceptChars) THEN self.acceptChars ELSE 0,
      TEXTFIELD_REJECTCHARS, IF StrLen(self.rejectChars) THEN self.rejectChars ELSE 0,
      TEXTFIELD_BLINKRATE, self.blinkRate,
      TEXTFIELD_MAXSIZE, self.maxSize,
      TEXTFIELD_SPACING, self.spacing,
      TEXTFIELD_TABSPACES, self.tabSpaces,

      TEXTFIELD_BLOCKCURSOR, self.blockCursor,
      TEXTFIELD_MAXSIZEBEEP, self.maxSizeBeep,
      TEXTFIELD_PARTIAL, self.partial,

      TEXTFIELD_NOGHOST, self.noGhost,
      TEXTFIELD_NONPRINTCHARS, self.nonPrintChars,
      TEXTFIELD_INVERTED, self.inverted,
      TEXTFIELD_VCENTER, self.vCenter,

      TEXTFIELD_USERALIGN, self.userAlign,
      TEXTFIELD_RULEDPAPER, self.ruledPaper,

      TEXTFIELD_PAPERPEN, self.paperPen,
      TEXTFIELD_INKPEN, self.inkPen,
      TEXTFIELD_LINEPEN, self.linePen,
      
      TEXTFIELD_BORDER, ListItem([TEXTFIELD_BORDER_NONE,TEXTFIELD_BORDER_BEVEL,TEXTFIELD_BORDER_DOUBLEBEVEL],self.border),
      TEXTFIELD_ALIGNMENT, ListItem([TEXTFIELD_ALIGN_LEFT,TEXTFIELD_ALIGN_CENTER,TEXTFIELD_ALIGN_RIGHT],self.align),

    End
  ENDIF
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

  self.makePreviewChildAttrs(0)
ENDPROC

EXPORT PROC updatePreviewObject() OF textFieldObject
  DEF map,maptarget:PTR TO reactionObject

  IF self.linkToVScroll
    map:=[TEXTFIELD_TOP, SCROLLER_TOP,
      TEXTFIELD_LINES, SCROLLER_TOTAL,
      TEXTFIELD_VISIBLE, SCROLLER_VISIBLE,
      TAG_DONE]
      maptarget:=self.parent.findReactionObject(self.linkToVScroll)
  ELSE
    map:=0
    maptarget:=0
  ENDIF
  IF map THEN SetGadgetAttrsA(self.previewObject,0,0,[ICA_MAP,map,TAG_DONE])
  IF maptarget THEN SetGadgetAttrsA(self.previewObject,0,0,[ICA_TARGET,maptarget.previewObject,TAG_DONE])

ENDPROC

EXPORT PROC create(parent) OF textFieldObject
  self.type:=TYPE_TEXTFIELD

  SUPER self.create(parent)

  AstrCopy(self.delimiters,',)!@^&*_=+\\|<>?/ ')
  AstrCopy(self.acceptChars,'')
  AstrCopy(self.rejectChars,'')
  self.blinkRate:=100000
  self.maxSize:=0
  self.spacing:=0
  self.tabSpaces:=0
  self.disabled:=0
  self.tabCycle:=TRUE
  self.blockCursor:=0
  self.maxSizeBeep:=TRUE
  self.partial:=0
  self.noGhost:=0
  self.readOnly:=0
  self.nonPrintChars:=0
  self.inverted:=0
  self.vCenter:=0
  self.userAlign:=0
  self.ruledPaper:=0
  self.linkToVScroll:=FALSE
  self.paperPen:=-1
  self.inkPen:=-1
  self.linePen:=-1
  self.border:=1
  self.align:=0

  self.minWidth:=100
  self.minHeight:=70

  self.libsused:=[TYPE_TEXTFIELD]
ENDPROC

EXPORT PROC editSettings() OF textFieldObject
  DEF editForm:PTR TO textFieldSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF textFieldObject IS
[
  makeProp(delimiters,FIELDTYPE_STR),
  makeProp(acceptChars,FIELDTYPE_STR),
  makeProp(rejectChars,FIELDTYPE_STR),
  makeProp(blinkRate,FIELDTYPE_LONG),
  makeProp(maxSize,FIELDTYPE_INT),
  makeProp(spacing,FIELDTYPE_INT),
  makeProp(tabSpaces,FIELDTYPE_INT),
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(tabCycle,FIELDTYPE_CHAR),
  makeProp(blockCursor,FIELDTYPE_CHAR),
  makeProp(maxSizeBeep,FIELDTYPE_CHAR),
  makeProp(partial,FIELDTYPE_CHAR),
  makeProp(noGhost,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(nonPrintChars,FIELDTYPE_CHAR),
  makeProp(inverted,FIELDTYPE_CHAR),
  makeProp(vCenter,FIELDTYPE_CHAR),
  makeProp(userAlign,FIELDTYPE_CHAR),
  makeProp(ruledPaper,FIELDTYPE_CHAR),
  makeProp(linkToVScroll,FIELDTYPE_INT),
  makeProp(paperPen,FIELDTYPE_INT),
  makeProp(inkPen,FIELDTYPE_INT),
  makeProp(linePen,FIELDTYPE_INT),
  makeProp(border,FIELDTYPE_CHAR),
  makeProp(align,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF textFieldObject

  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  IF self.tabCycle THEN srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF self.readOnly THEN srcGen.componentProperty('GA_ReadOnly','TRUE',FALSE)

  IF StrLen(self.delimiters) AND StrCmp(self.delimiters,',)!@^&*_=+\\|<>?/ ')=FALSE THEN srcGen.componentProperty('TEXTFIELD_Delimiters',self.delimiters,TRUE)
  IF StrLen(self.acceptChars) THEN srcGen.componentProperty('TEXTFIELD_AcceptChars',self.acceptChars,TRUE)
  IF StrLen(self.rejectChars) THEN srcGen.componentProperty('TEXTFIELD_RejectChars',self.rejectChars,TRUE)
  
  IF self.maxSize<>0 THEN srcGen.componentPropertyInt('TEXTFIELD_MaxSize',self.maxSize)
  
  IF self.blinkRate<>0 THEN srcGen.componentPropertyInt('TEXTFIELD_BlinkRate',self.blinkRate)
  IF self.spacing<>0 THEN srcGen.componentPropertyInt('TEXTFIELD_Spacing',self.spacing)
  IF self.tabSpaces<>0 THEN srcGen.componentPropertyInt('TEXTFIELD_TabSpaces',self.tabSpaces)
  IF self.blockCursor THEN srcGen.componentProperty('TEXTFIELD_BlockCursor','TRUE',FALSE)
  IF self.partial THEN srcGen.componentProperty('TEXTFIELD_Partial','TRUE',FALSE)
  IF self.noGhost THEN srcGen.componentProperty('TEXTFIELD_NoGhost','TRUE',FALSE)
  IF self.nonPrintChars THEN srcGen.componentProperty('TEXTFIELD_NonPrintChars','TRUE',FALSE)
  IF self.inverted THEN srcGen.componentProperty('TEXTFIELD_Inverted','TRUE',FALSE)
  IF self.vCenter THEN srcGen.componentProperty('TEXTFIELD_VCenter','TRUE',FALSE)
  IF self.userAlign THEN srcGen.componentProperty('TEXTFIELD_UserAlign','TRUE',FALSE)
  IF self.ruledPaper THEN srcGen.componentProperty('TEXTFIELD_RuledPaper','TRUE',FALSE)
  IF self.maxSizeBeep=FALSE THEN srcGen.componentProperty('TEXTFIELD_MaxSizeBeep','FALSE',FALSE)
  
  IF self.paperPen<>-1 THEN srcGen.componentPropertyInt('TEXTFIELD_PaperPen',self.paperPen)
  IF self.inkPen<>-1 THEN srcGen.componentPropertyInt('TEXTFIELD_InkPen',self.inkPen)
  IF self.linePen<>-1 THEN srcGen.componentPropertyInt('TEXTFIELD_LinePen',self.linePen)
  IF self.border<>0 THEN srcGen.componentProperty('TEXTFIELD_Border',ListItem(['TEXTFIELD_BORDER_NONE','TEXTFIELD_BORDER_BEVEL','TEXTFIELD_BORDER_DOUBLEBEVEL'],self.border),FALSE)
  IF self.align<>0 THEN srcGen.componentProperty('TEXTFIELD_Alignment',ListItem(['TEXTFIELD_ALIGN_LEFT','TEXTFIELD_ALIGN_CENTER','TEXTFIELD_ALIGN_RIGHT'],self.align),FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF textFieldObject
  srcGen.componentAddChildLabel(self.label)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC genCodeMaps(header, srcGen:PTR TO srcGen) OF textFieldObject
  DEF maptarget
  IF self.linkToVScroll
    maptarget:=self.parent.findReactionObject(self.linkToVScroll)
  ELSE
    maptarget:=0
  ENDIF
  IF maptarget
    srcGen.setIcaMap(header, 'TEXTFIELD_Top, SCROLLER_Top, TEXTFIELD_Lines, SCROLLER_Total, TEXTFIELD_Visible, SCROLLER_Visible',self,maptarget)
  ENDIF
ENDPROC

EXPORT PROC getTypeName() OF textFieldObject
  RETURN 'TextField'
ENDPROC

EXPORT PROC createTextFieldObject(parent)
  DEF textfield:PTR TO textFieldObject
  
  NEW textfield.create(parent)
ENDPROC textfield
