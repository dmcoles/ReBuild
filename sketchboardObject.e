OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/sketchboard','sketchboard',
        'gadgets/checkbox','checkbox',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/button','button',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker', '*sourcegen'

EXPORT ENUM SBOARDGAD_WIDTH, SBOARDGAD_HEIGHT, SBOARDGAD_PEN, SBOARDGAD_ACTIVETOOL,
      SBOARDGAD_GRID, SBOARDGAD_SCALE, SBOARDGAD_BEVEL, SBOARDGAD_READONLY, SBOARDGAD_DISABLED,
      SBOARDGAD_OK, SBOARDGAD_CHILD, SBOARDGAD_CANCEL
      

CONST NUM_SBOARD_GADS=SBOARDGAD_CANCEL+1

EXPORT OBJECT sketchboardObject OF reactionObject
  width:INT
  height:INT
  pen:CHAR
  activeTool:CHAR
  grid:CHAR
  scale:INT
  bevel:CHAR
  readOnly:CHAR
  disabled:CHAR
ENDOBJECT

OBJECT sketchboardSettingsForm OF reactionForm
PRIVATE
  sketchboardObject:PTR TO sketchboardObject
  tmpPen:INT
  labels1:LONG
ENDOBJECT

PROC create() OF sketchboardSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_SBOARD_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_SBOARD_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Sketchboard Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 60,
    WA_WIDTH, 260,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 60,
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

        LAYOUT_ADDCHILD,  self.gadgetList[ SBOARDGAD_WIDTH ]:=IntegerObject,
          GA_ID, SBOARDGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBOARDGAD_HEIGHT ]:=IntegerObject,
          GA_ID, SBOARDGAD_HEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Height',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ SBOARDGAD_PEN ]:=ButtonObject,
            GA_ID, SBOARDGAD_PEN,
            GA_TEXT, 'Pen',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        
        LAYOUT_ADDCHILD, self.gadgetList[ SBOARDGAD_ACTIVETOOL ]:=ChooserObject,
          GA_ID, SBOARDGAD_ACTIVETOOL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['SGTOOL_FREEHAND_DOTS','SGTOOL_FREEHAND','SGTOOL_ELLIPSE','SGTOOL_ELLIPSE_FILLED','SGTOOL_RECT',
             'SGTOOL_RECT_FILLED','SGTOOL_LINE','SGTOOL_FILL','SGTOOL_GETPEN','SGTOOL_HOTSPOT','SGTOOL_SELECT',
             'SGTOOL_MOVE',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Active Tool',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBOARDGAD_SCALE ]:=IntegerObject,
          GA_ID, SBOARDGAD_SCALE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 2,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 99,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Scale',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SBOARDGAD_GRID ]:=CheckBoxObject,
          GA_ID, SBOARDGAD_GRID,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Grid',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ SBOARDGAD_BEVEL ]:=CheckBoxObject,
          GA_ID, SBOARDGAD_BEVEL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Bevel',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SBOARDGAD_READONLY ]:=CheckBoxObject,
          GA_ID, SBOARDGAD_READONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'ReadOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SBOARDGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, SBOARDGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBOARDGAD_OK ]:=ButtonObject,
          GA_ID, SBOARDGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBOARDGAD_CHILD ]:=ButtonObject,
          GA_ID, SBOARDGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ SBOARDGAD_CANCEL ]:=ButtonObject,
          GA_ID, SBOARDGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[SBOARDGAD_PEN]:={selectPen}
  self.gadgetActions[SBOARDGAD_CHILD]:={editChildSettings}
  self.gadgetActions[SBOARDGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[SBOARDGAD_OK]:=MR_OK
ENDPROC

PROC selectPen(nself,gadget,id,code) OF sketchboardSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  colourProp:={self.tmpPen}
  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF sketchboardSettingsForm
  self:=nself
  self.setBusy()
  self.sketchboardObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF sketchboardSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_SBOARD_GADS]
  END self.gadgetActions[NUM_SBOARD_GADS]
ENDPROC

PROC editSettings(comp:PTR TO sketchboardObject) OF sketchboardSettingsForm
  DEF res

  self.sketchboardObject:=comp

  self.tmpPen:=comp.pen

  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_ACTIVETOOL ],0,0,[CHOOSER_SELECTED,comp.activeTool,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_GRID ],0,0,[CHECKBOX_CHECKED,comp.grid,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_SCALE ],0,0,[INTEGER_NUMBER,comp.scale,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_BEVEL ],0,0,[CHECKBOX_CHECKED,comp.bevel,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ SBOARDGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.pen:=self.tmpPen
    comp.width:=Gets(self.gadgetList[ SBOARDGAD_WIDTH ],INTEGER_NUMBER)   
    comp.height:=Gets(self.gadgetList[ SBOARDGAD_HEIGHT ],INTEGER_NUMBER)   
    comp.activeTool:=Gets(self.gadgetList[ SBOARDGAD_ACTIVETOOL ],CHOOSER_SELECTED)   
    comp.grid:=Gets(self.gadgetList[ SBOARDGAD_GRID ],CHECKBOX_CHECKED)   
    comp.scale:=Gets(self.gadgetList[ SBOARDGAD_BEVEL ],INTEGER_NUMBER)   
    comp.bevel:=Gets(self.gadgetList[ SBOARDGAD_BEVEL ],CHECKBOX_CHECKED)   
    comp.readOnly:=Gets(self.gadgetList[ SBOARDGAD_READONLY ],CHECKBOX_CHECKED)   
    comp.disabled:=Gets(self.gadgetList[ SBOARDGAD_DISABLED ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF sketchboardObject
  self.previewObject:=0
  IF (sketchboardbase)
    self.previewObject:=NewObjectA( SketchBoard_GetClass(), NIL,[TAG_IGNORE,0,
        GA_READONLY, self.readOnly,
        GA_DISABLED, self.disabled,
        SGA_WIDTH, self.width,
        SGA_HEIGHT, self.height,
        SGA_APEN, self.pen,
        SGA_TOOL, ListItem([SGTOOL_FREEHAND_DOTS,SGTOOL_FREEHAND,SGTOOL_ELLIPSE,SGTOOL_ELLIPSE_FILLED,SGTOOL_RECT,
             SGTOOL_RECT_FILLED,SGTOOL_LINE,SGTOOL_FILL,SGTOOL_GETPEN,SGTOOL_HOTSPOT,SGTOOL_SELECT,
             SGTOOL_MOVE],self.activeTool),
        SGA_SHOWGRID, self.grid,
        SGA_SCALE, self.scale,
        SGA_WITHBEVEL, self.bevel,
    TAG_END])
  ENDIF
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
    TAG_END]
ENDPROC

EXPORT PROC create(parent) OF sketchboardObject
  self.type:=TYPE_SKETCH
  SUPER self.create(parent)
  self.width:=32
  self.height:=32
  self.pen:=1
  self.activeTool:=0
  self.grid:=TRUE
  self.scale:=3
  self.bevel:=TRUE
  self.readOnly:=0
  self.disabled:=0
  self.libsused:=[TYPE_SKETCH]
ENDPROC

EXPORT PROC editSettings() OF sketchboardObject
  DEF editForm:PTR TO sketchboardSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF sketchboardObject
  RETURN 'SketchBoard'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF sketchboardObject IS
[
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(pen,FIELDTYPE_CHAR),
  makeProp(activeTool,FIELDTYPE_CHAR),
  makeProp(grid,FIELDTYPE_CHAR),
  makeProp(scale,FIELDTYPE_INT),
  makeProp(bevel,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(disabled,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF sketchboardObject
  srcGen.componentPropertyInt('GA_ID',self.id)
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  ->IF self.scroller=FALSE THEN srcGen.componentProperty('VIRTUALA_Scroller','FALSE',FALSE)
ENDPROC

EXPORT PROC libTypeCreate() OF sketchboardObject IS 'SketchBoard_GetClass()'

EXPORT PROC getTypeEndName() OF sketchboardObject
  RETURN 'End'
ENDPROC

EXPORT PROC createSketchboardObject(parent)
  DEF sketch:PTR TO sketchboardObject
  
  NEW sketch.create(parent)
ENDPROC sketch


