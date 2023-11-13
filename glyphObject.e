OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'images/glyph','glyph',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen'

EXPORT ENUM GLYGAD_NAME, GLYGAD_TYPE,
      GLYGAD_OK, GLYGAD_CHILD, GLYGAD_CANCEL
      

CONST NUM_GLY_GADS=GLYGAD_CANCEL+1

EXPORT OBJECT glyphObject OF reactionObject
  glyphType:CHAR
ENDOBJECT

OBJECT glyphSettingsForm OF reactionForm
  glyphObject:PTR TO glyphObject
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF glyphSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_GLY_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_GLY_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Glyph Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 70,
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
    WA_NOCAREREFRESH, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,

    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,
    
      LAYOUT_ADDCHILD, self.gadgetList[ GLYGAD_NAME ]:=StringObject,
        GA_ID, GLYGAD_NAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Name',
      LabelEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ GLYGAD_TYPE ]:=ChooserObject,
        GA_ID, GLYGAD_TYPE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        CHOOSER_POPUP, TRUE,
        CHOOSER_MAXLABELS, 12,
        CHOOSER_ACTIVE, 0,
        CHOOSER_WIDTH, -1,
        CHOOSER_LABELS, self.labels1:=chooserLabelsA(['GLYPH_NONE', 'GLYPH_DOWNARROW', 'GLYPH_UPARROW', 'GLYPH_LEFTARROW', 'GLYPH_RIGHTARROW', 
          'GLYPH_DROPDOWN', 'GLYPH_POPUP', 'GLYPH_CHECKMARK', 'GLYPH_POPFONT', 'GLYPH_POPFILE','GLYPH_POPDRAWER','GLYPH_POPSCREENMODE',0]),
      ChooserEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Type',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GLYGAD_OK ]:=ButtonObject,
          GA_ID, GLYGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GLYGAD_CHILD ]:=ButtonObject,
          GA_ID, GLYGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GLYGAD_CANCEL ]:=ButtonObject,
          GA_ID, GLYGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT, 0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[GLYGAD_CHILD]:={editChildSettings}
  self.gadgetActions[GLYGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[GLYGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF glyphSettingsForm
  self:=nself
  self.setBusy()
  self.glyphObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF glyphSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_GLY_GADS]
  END self.gadgetActions[NUM_GLY_GADS]
ENDPROC

PROC editSettings(comp:PTR TO glyphObject) OF glyphSettingsForm
  DEF res

  self.glyphObject:=comp
  
  SetGadgetAttrsA(self.gadgetList[ GLYGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ GLYGAD_TYPE ],0,0,[CHOOSER_SELECTED,comp.glyphType,0])

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.name,Gets(self.gadgetList[ GLYGAD_NAME ],STRINGA_TEXTVAL))
    comp.glyphType:=Gets(self.gadgetList[ GLYGAD_TYPE ],CHOOSER_SELECTED)
  ENDIF
ENDPROC res

EXPORT PROC createPreviewObject(scr) OF glyphObject
  self.previewObject:=GlyphObject,
      GLYPH_GLYPH, ListItem([GLYPH_NONE,GLYPH_DOWNARROW,GLYPH_UPARROW,GLYPH_LEFTARROW,GLYPH_RIGHTARROW, GLYPH_DROPDOWN,GLYPH_POPUP,GLYPH_CHECKMARK,GLYPH_POPFONT,GLYPH_POPFILE,GLYPH_POPDRAWER,GLYPH_POPSCREENMODE],self.glyphType),
      GLYPH_DRAWINFO, self.drawInfo,
    GlyphEnd

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
ENDPROC

EXPORT PROC create(parent) OF glyphObject
  self.type:=TYPE_GLYPH
  SUPER self.create(parent)
  self.glyphType:=9
  self.libsused:=[TYPE_GLYPH,TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF glyphObject
  DEF editForm:PTR TO glyphSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res=MR_OK

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF glyphObject IS
[
  makeProp(glyphType,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF glyphObject
  srcGen.componentProperty('GLYPH_DrawInfo','gDrawInfo',FALSE)
  IF self.glyphType<>9 THEN srcGen.componentProperty('GLYPH_Glyph',ListItem(['GLYPH_NONE', 'GLYPH_DOWNARROW', 'GLYPH_UPARROW', 'GLYPH_LEFTARROW', 'GLYPH_RIGHTARROW', 
            'GLYPH_DROPDOWN', 'GLYPH_POPUP', 'GLYPH_CHECKMARK', 'GLYPH_POPFONT', 'GLYPH_POPFILE','GLYPH_POPDRAWER','GLYPH_POPSCREENMODE'],self.glyphType),FALSE)
ENDPROC

EXPORT PROC getTypeName() OF glyphObject
  RETURN 'Glyph'
ENDPROC

EXPORT PROC isImage() OF glyphObject IS TRUE

EXPORT PROC createGlyphObject(parent)
  DEF glyph:PTR TO glyphObject
  
  NEW glyph.create(parent)
ENDPROC glyph
