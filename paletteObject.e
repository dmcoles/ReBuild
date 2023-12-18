OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'palette','gadgets/palette',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen'

EXPORT ENUM PALGAD_NAME, PALGAD_DISABLED,
      PALGAD_INITIAL, PALGAD_OFFSET, PALGAD_NUMCOLS,
      PALGAD_OK, PALGAD_CHILD, PALGAD_CANCEL
      

CONST NUM_PAL_GADS=PALGAD_CANCEL+1

EXPORT OBJECT paletteObject OF reactionObject
  disabled:CHAR
  initial:INT
  offset:INT
  numcols:INT
ENDOBJECT

OBJECT paletteSettingsForm OF reactionForm
PRIVATE
  paletteObject:PTR TO paletteObject
ENDOBJECT

PROC create() OF paletteSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_PAL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_PAL_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Palette Attribute Setting',
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
        
        LAYOUT_ADDCHILD, self.gadgetList[ PALGAD_NAME ]:=StringObject,
          GA_ID, PALGAD_NAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Name',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ PALGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, PALGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,
      
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ PALGAD_INITIAL ]:=IntegerObject,
          GA_ID, PALGAD_INITIAL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Initial Colour',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PALGAD_OFFSET ]:=IntegerObject,
          GA_ID, PALGAD_OFFSET,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Colour _Offset',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PALGAD_NUMCOLS ]:=IntegerObject,
          GA_ID, PALGAD_NUMCOLS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'NumColours',
        LabelEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ PALGAD_OK ]:=ButtonObject,
          GA_ID, PALGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PALGAD_CHILD ]:=ButtonObject,
          GA_ID, PALGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PALGAD_CANCEL ]:=ButtonObject,
          GA_ID, PALGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[PALGAD_CHILD]:={editChildSettings}
  self.gadgetActions[PALGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[PALGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF paletteSettingsForm
  self:=nself
  self.setBusy()
  self.paletteObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF paletteSettingsForm
  END self.gadgetList[NUM_PAL_GADS]
  END self.gadgetActions[NUM_PAL_GADS]
ENDPROC

PROC editSettings(comp:PTR TO paletteObject) OF paletteSettingsForm
  DEF res

  self.paletteObject:=comp
  
  SetGadgetAttrsA(self.gadgetList[ PALGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ PALGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0])
  SetGadgetAttrsA(self.gadgetList[ PALGAD_INITIAL ],0,0,[INTEGER_NUMBER,comp.initial,0])
  SetGadgetAttrsA(self.gadgetList[ PALGAD_OFFSET ],0,0,[INTEGER_NUMBER,comp.offset,0])
  SetGadgetAttrsA(self.gadgetList[ PALGAD_NUMCOLS ],0,0,[INTEGER_NUMBER,comp.numcols,0])

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ PALGAD_NAME ],STRINGA_TEXTVAL))
    comp.disabled:=Gets(self.gadgetList[ PALGAD_DISABLED],CHECKBOX_CHECKED)
    comp.initial:=Gets(self.gadgetList[ PALGAD_INITIAL ],INTEGER_NUMBER)
    comp.offset:=Gets(self.gadgetList[ PALGAD_OFFSET ],INTEGER_NUMBER)
    comp.numcols:=Gets(self.gadgetList[ PALGAD_NUMCOLS ],INTEGER_NUMBER)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF paletteObject
  self.previewObject:=PaletteObject, 
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      PALETTE_COLOUR, self.initial,
      PALETTE_COLOUROFFSET, self.offset,
      PALETTE_NUMCOLOURS, self.numcols,
    PaletteEnd
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

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
ENDPROC

EXPORT PROC create(parent) OF paletteObject
  self.type:=TYPE_PALETTE
  SUPER self.create(parent)
  
  self.disabled:=FALSE
  self.initial:=0
  self.offset:=0
  self.numcols:=4

  self.libsused:=[TYPE_PALETTE]
ENDPROC

EXPORT PROC editSettings() OF paletteObject
  DEF editForm:PTR TO paletteSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF paletteObject IS
[
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(initial,FIELDTYPE_INT),
  makeProp(offset,FIELDTYPE_INT),
  makeProp(numcols,FIELDTYPE_INT)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF paletteObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF self.initial<>0 THEN srcGen.componentPropertyInt('PALETTE_Colour',self.initial)
  IF self.offset<>0 THEN  srcGen.componentPropertyInt('PALETTE_ColourOffset',self.offset)
  IF self.numcols<>2 THEN srcGen.componentPropertyInt('PALETTE_NumColours',self.numcols)
ENDPROC

EXPORT PROC getTypeName() OF paletteObject
  RETURN 'Palette'
ENDPROC

EXPORT PROC createPaletteObject(parent)
  DEF palette:PTR TO paletteObject
  
  NEW palette.create(parent)
ENDPROC palette
