OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'gadgets/getfont','getfont',
        'gadgets/string','string',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen','*validator'

EXPORT ENUM GETFONTGAD_IDENT, GETFONTGAD_NAME, GETFONTGAD_HINT, GETFONTGAD_TITLE,
            GETFONTGAD_LEFT, GETFONTGAD_TOP, GETFONTGAD_WIDTH, GETFONTGAD_HEIGHT, 
            GETFONTGAD_MINHEIGHT, GETFONTGAD_MAXHEIGHT, GETFONTGAD_MAXFRONT, GETFONTGAD_MAXBACK, 
            GETFONTGAD_DOFRONTPEN, GETFONTGAD_DOBACKPEN, GETFONTGAD_DOSTYLE,
            GETFONTGAD_DODRAWMODE, GETFONTGAD_FIXEDWIDTHONLY, 
            GETFONTGAD_OK, GETFONTGAD_CHILD, GETFONTGAD_CANCEL
      

CONST NUM_GETFONT_GADS=GETFONTGAD_CANCEL+1

EXPORT OBJECT getFontObject OF reactionObject
  title[80]:ARRAY OF CHAR
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  fMinHeight:INT
  fMaxHeight:INT
  maxFrontPen:INT
  maxBackPen:INT
  doFrontPen:CHAR
  doBackPen:CHAR
  doStyle:CHAR
  doDrawMode:CHAR
  fixedWidthOnly:CHAR
ENDOBJECT

OBJECT getFontSettingsForm OF reactionForm
PRIVATE
  getFontObject:PTR TO getFontObject
ENDOBJECT

PROC create() OF getFontSettingsForm
  DEF gads:PTR TO LONG
  DEF arrows,scr:PTR TO screen
  
  NEW gads[NUM_GETFONT_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_GETFONT_GADS]
  self.gadgetActions:=gads
  
  scr:=LockPubScreen(NIL)
  arrows:=(scr.width>=800)
  UnlockPubScreen(NIL,scr)

  self.windowObj:=WindowObject,
    WA_TITLE, 'GetFont Attribute Setting',
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

        LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_IDENT ]:=StringObject,
          GA_ID, GETFONTGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_NAME ]:=StringObject,
          GA_ID, GETFONTGAD_NAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Label',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_HINT ]:=ButtonObject,
          GA_ID, GETFONTGAD_HINT,
          GA_TEXT, 'Hint',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,       
        CHILD_WEIGHTEDWIDTH,50,            
      LayoutEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_TITLE ]:=StringObject,
        GA_ID, GETFONTGAD_TITLE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'GetFont _Title',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
      
        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_LEFT ]:=IntegerObject,
          GA_ID, GETFONTGAD_LEFT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Left Edge',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_TOP ]:=IntegerObject,
          GA_ID, GETFONTGAD_TOP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Top Edge',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_WIDTH ]:=IntegerObject,
          GA_ID, GETFONTGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_HEIGHT ]:=IntegerObject,
          GA_ID, GETFONTGAD_HEIGHT,
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
        LAYOUT_SHRINKWRAP, TRUE,
      
        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_MINHEIGHT ]:=IntegerObject,
          GA_ID, GETFONTGAD_MINHEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MinHeight',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_MAXHEIGHT ]:=IntegerObject,
          GA_ID, GETFONTGAD_MAXHEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxHeight',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_MAXFRONT ]:=IntegerObject,
          GA_ID, GETFONTGAD_MAXFRONT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxFrontPen',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_MAXBACK ]:=IntegerObject,
          GA_ID, GETFONTGAD_MAXBACK,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'MaxBackPen',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_DOFRONTPEN ]:=CheckBoxObject,
          GA_ID, GETFONTGAD_DOFRONTPEN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoFrontPen',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_DOBACKPEN ]:=CheckBoxObject,
          GA_ID, GETFONTGAD_DOBACKPEN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoBackPen',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_DOSTYLE ]:=CheckBoxObject,
          GA_ID, GETFONTGAD_DOSTYLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoStyle',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_DODRAWMODE ]:=CheckBoxObject,
          GA_ID, GETFONTGAD_DODRAWMODE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoDrawMode',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFONTGAD_FIXEDWIDTHONLY ]:=CheckBoxObject,
          GA_ID, GETFONTGAD_FIXEDWIDTHONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'FixedWidthOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_OK ]:=ButtonObject,
          GA_ID, GETFONTGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_CHILD ]:=ButtonObject,
          GA_ID, GETFONTGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFONTGAD_CANCEL ]:=ButtonObject,
          GA_ID, GETFONTGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[GETFONTGAD_CHILD]:={editChildSettings}
  self.gadgetActions[GETFONTGAD_HINT]:={editHint}
  self.gadgetActions[GETFONTGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[GETFONTGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF getFontSettingsForm
  self:=nself
  self.setBusy()
  self.getFontObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF getFontSettingsForm
  END self.gadgetList[NUM_GETFONT_GADS]
  END self.gadgetActions[NUM_GETFONT_GADS]
ENDPROC

EXPORT PROC canClose(modalRes) OF getFontSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.getFontObject,GETFONTGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editHint(nself,gadget,id,code) OF getFontSettingsForm
  self:=nself
  self.setBusy()
  self.getFontObject.editHint()
  self.clearBusy()
  self.updateHint(GETFONTGAD_HINT, self.getFontObject.hintText)
ENDPROC

PROC editSettings(comp:PTR TO getFontObject) OF getFontSettingsForm
  DEF res

  self.getFontObject:=comp

  self.updateHint(GETFONTGAD_HINT, comp.hintText)
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_TITLE ],0,0,[STRINGA_TEXTVAL,comp.title,0])

  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_LEFT ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_TOP ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])

  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_MINHEIGHT ],0,0,[INTEGER_NUMBER,comp.fMinHeight,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_MAXHEIGHT ],0,0,[INTEGER_NUMBER,comp.fMaxHeight,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_MAXFRONT ],0,0,[INTEGER_NUMBER,comp.maxFrontPen,0])
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_MAXBACK ],0,0,[INTEGER_NUMBER,comp.maxBackPen,0])

  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_DOFRONTPEN ],0,0,[CHECKBOX_CHECKED,comp.doFrontPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_DOBACKPEN ],0,0,[CHECKBOX_CHECKED,comp.doBackPen,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_DOSTYLE ],0,0,[CHECKBOX_CHECKED,comp.doStyle,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_DODRAWMODE ],0,0,[CHECKBOX_CHECKED,comp.doDrawMode,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFONTGAD_FIXEDWIDTHONLY ],0,0,[CHECKBOX_CHECKED,comp.fixedWidthOnly,0]) 

  res:=self.showModal()
  IF res=MR_OK
    
    AstrCopy(comp.ident,Gets(self.gadgetList[ GETFONTGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.name,Gets(self.gadgetList[ GETFONTGAD_NAME ],STRINGA_TEXTVAL))
    AstrCopy(comp.title,Gets(self.gadgetList[ GETFONTGAD_TITLE ],STRINGA_TEXTVAL))

    comp.leftEdge:=Gets(self.gadgetList[ GETFONTGAD_LEFT ],INTEGER_NUMBER)
    comp.topEdge:=Gets(self.gadgetList[ GETFONTGAD_TOP ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ GETFONTGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ GETFONTGAD_HEIGHT ],INTEGER_NUMBER)

    comp.fMinHeight:=Gets(self.gadgetList[ GETFONTGAD_MINHEIGHT ],INTEGER_NUMBER)
    comp.fMaxHeight:=Gets(self.gadgetList[ GETFONTGAD_MAXHEIGHT ],INTEGER_NUMBER)
    comp.maxFrontPen:=Gets(self.gadgetList[ GETFONTGAD_MAXFRONT ],INTEGER_NUMBER)
    comp.maxBackPen:=Gets(self.gadgetList[ GETFONTGAD_MAXBACK ],INTEGER_NUMBER)

    comp.doFrontPen:=Gets(self.gadgetList[ GETFONTGAD_DOFRONTPEN ],CHECKBOX_CHECKED)
    comp.doBackPen:=Gets(self.gadgetList[ GETFONTGAD_DOBACKPEN ],CHECKBOX_CHECKED)
    comp.doStyle:=Gets(self.gadgetList[ GETFONTGAD_DOSTYLE ],CHECKBOX_CHECKED)
    comp.doDrawMode:=Gets(self.gadgetList[ GETFONTGAD_DODRAWMODE ],CHECKBOX_CHECKED)
    comp.fixedWidthOnly:=Gets(self.gadgetList[ GETFONTGAD_FIXEDWIDTHONLY ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF getFontObject
  self.previewObject:=GetFontObject,
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
          CHILD_NOMINALSIZE, self.nominalSize,
          CHILD_WEIGHTMINIMUM, self.weightMinimum,
          IF self.weightBar THEN LAYOUT_WEIGHTBAR ELSE TAG_IGNORE, 1,
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
          CHILD_NOMINALSIZE, self.nominalSize,
          CHILD_WEIGHTMINIMUM, self.weightMinimum,
          IF self.weightBar THEN LAYOUT_WEIGHTBAR ELSE TAG_IGNORE, 1,
          TAG_END]
  ENDIF
ENDPROC

EXPORT PROC create(parent) OF getFontObject
  self.type:=TYPE_GETFONT
  SUPER self.create(parent)

  AstrCopy(self.title,'Select a Font')
  self.leftEdge:=30
  self.topEdge:=20
  self.width:=300
  self.height:=200
  self.fMinHeight:=6
  self.fMaxHeight:=20
  self.maxFrontPen:=255
  self.maxBackPen:=255

  self.doFrontPen:=0
  self.doBackPen:=0
  self.doStyle:=0
  self.doDrawMode:=0
  self.fixedWidthOnly:=0

  self.libsused:=[TYPE_GETFONT,TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF getFontObject
  DEF editForm:PTR TO getFontSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF getFontObject IS
[
  makeProp(title,FIELDTYPE_STR),
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(fMinHeight,FIELDTYPE_INT),
  makeProp(fMaxHeight,FIELDTYPE_INT),
  makeProp(maxFrontPen,FIELDTYPE_INT),
  makeProp(maxBackPen,FIELDTYPE_INT),
  makeProp(doFrontPen,FIELDTYPE_CHAR),
  makeProp(doBackPen,FIELDTYPE_CHAR),
  makeProp(doStyle,FIELDTYPE_CHAR),
  makeProp(doDrawMode,FIELDTYPE_CHAR),
  makeProp(fixedWidthOnly,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF getFontObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  IF StrLen(self.title) THEN srcGen.componentProperty('GETFONT_TitleText',self.title,TRUE)
  IF self.leftEdge<>30 THEN srcGen.componentPropertyInt('GETFONT_LeftEdge',self.leftEdge)
  IF self.topEdge<>20 THEN srcGen.componentPropertyInt('GETFONT_TopEdge',self.topEdge)
  IF self.width<>300 THEN srcGen.componentPropertyInt('GETFONT_Width',self.width)
  IF self.height<>200 THEN srcGen.componentPropertyInt('GETFONT_Height',self.height)
  
  IF self.fMinHeight<>6 THEN srcGen.componentPropertyInt('GETFONT_MinHeight',self.fMinHeight)
  IF self.fMaxHeight<>20 THEN srcGen.componentPropertyInt('GETFONT_MaxHeight',self.fMaxHeight)
  
  IF self.maxFrontPen<>255 THEN srcGen.componentPropertyInt('GETFONT_MaxFrontPen',self.maxFrontPen)
  IF self.maxBackPen<>255 THEN srcGen.componentPropertyInt('GETFONT_MaxBackPen',self.maxBackPen)

  IF self.doFrontPen THEN srcGen.componentProperty('GETFONT_DoFrontPen','TRUE',FALSE)
  IF self.doBackPen THEN srcGen.componentProperty('GETFONT_DoBackPen','TRUE',FALSE)

  IF self.doStyle THEN srcGen.componentProperty('GETFONT_DoStyle','TRUE',FALSE)
  IF self.doDrawMode THEN srcGen.componentProperty('GETFONT_DoDrawMode','TRUE',FALSE)
  IF self.fixedWidthOnly THEN srcGen.componentProperty('GETFONT_FixedWidthOnly','TRUE',FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF getFontObject
  srcGen.componentAddChildLabel(self.name)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC getTypeName() OF getFontObject
  RETURN 'GetFont'
ENDPROC

EXPORT PROC getTypeEndName() OF getFontObject
  RETURN 'End'
ENDPROC

EXPORT PROC createGetFontObject(parent)
  DEF getfont:PTR TO getFontObject
  
  NEW getfont.create(parent)
ENDPROC getfont
