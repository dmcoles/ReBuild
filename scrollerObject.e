OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/scroller','scroller',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'gadgets/texteditor',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/icclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen','*validator','*textEditorObject','*textFieldObject','*stringlist'

CONST TEXTFIELD_TOP=$84000005

EXPORT ENUM SCLGAD_IDENT, SCLGAD_NAME, SCLGAD_HINT, SCLGAD_TOP, SCLGAD_VISIBLE, SCLGAD_TOTAL, SCLGAD_ARROWDELTA,
      SCLGAD_ARROWS, SCLGAD_ORIENTATION,
      SCLGAD_OK, SCLGAD_CHILD, SCLGAD_CANCEL
      

CONST NUM_SCL_GADS=SCLGAD_CANCEL+1

EXPORT OBJECT scrollerObject OF reactionObject
  top:INT
  visible:INT
  total:INT
  arrowdelta:INT
  arrows:CHAR
  orientation:CHAR
ENDOBJECT

OBJECT scrollerSettingsForm OF reactionForm
PRIVATE
  scrollerObject:PTR TO scrollerObject
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF scrollerSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_SCL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_SCL_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Scroller Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 450,
    WA_MINWIDTH, 250,
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

          LAYOUT_ADDCHILD, self.gadgetList[ SCLGAD_IDENT ]:=StringObject,
            GA_ID, SCLGAD_IDENT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Identifier',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ SCLGAD_NAME ]:=StringObject,
            GA_ID, SCLGAD_NAME,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Label',
          LabelEnd,
          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_HINT ]:=ButtonObject,
            GA_ID, SCLGAD_HINT,
            GA_TEXT, 'Hint',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,           
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_TOP ]:=IntegerObject,
            GA_ID, SCLGAD_TOP,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Top',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_VISIBLE ]:=IntegerObject,
            GA_ID, SCLGAD_VISIBLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Visible',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_TOTAL ]:=IntegerObject,
            GA_ID, SCLGAD_TOTAL,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Total',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_ARROWDELTA ]:=IntegerObject,
            GA_ID, SCLGAD_ARROWDELTA,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Visible',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ SCLGAD_ARROWS ]:=CheckBoxObject,
            GA_ID, SCLGAD_ARROWS,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Arrows',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ SCLGAD_ORIENTATION ]:=ChooserObject,
            GA_ID, SCLGAD_ORIENTATION,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels1:=chooserLabelsA(['SORIENT_HORIZ','SORIENT_VERT',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Orientation',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_OK ]:=ButtonObject,
            GA_ID, SCLGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_CHILD ]:=ButtonObject,
            GA_ID, SCLGAD_CHILD,
            GA_TEXT, 'C_hild',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCLGAD_CANCEL ]:=ButtonObject,
            GA_ID, SCLGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[SCLGAD_CHILD]:={editChildSettings}
  self.gadgetActions[SCLGAD_HINT]:={editHint}  
  self.gadgetActions[SCLGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[SCLGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF scrollerSettingsForm
  self:=nself
  self.setBusy()
  self.scrollerObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF scrollerSettingsForm
  freeChooserLabels( self.labels1 )
  END self.gadgetList[NUM_SCL_GADS]
  END self.gadgetActions[NUM_SCL_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF scrollerSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.scrollerObject,SCLGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editHint(nself,gadget,id,code) OF scrollerSettingsForm
  self:=nself
  self.setBusy()
  self.scrollerObject.editHint()
  self.clearBusy()
  self.updateHint(SCLGAD_HINT, self.scrollerObject.hintText)
ENDPROC

PROC editSettings(comp:PTR TO scrollerObject) OF scrollerSettingsForm
  DEF res

  self.scrollerObject:=comp

  self.updateHint(SCLGAD_HINT, comp.hintText) 
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_TOP ],0,0,[INTEGER_NUMBER,comp.top,0])
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_VISIBLE ],0,0,[INTEGER_NUMBER,comp.visible,0])
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_TOTAL ],0,0,[INTEGER_NUMBER,comp.total,0])
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_ARROWDELTA ],0,0,[INTEGER_NUMBER,comp.arrowdelta,0])
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_ARROWS ],0,0,[CHECKBOX_CHECKED,comp.arrows,0])
  SetGadgetAttrsA(self.gadgetList[ SCLGAD_ORIENTATION ],0,0,[CHOOSER_SELECTED,comp.orientation,0])

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ SCLGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.name,Gets(self.gadgetList[ SCLGAD_NAME ],STRINGA_TEXTVAL))
    comp.top:=Gets(self.gadgetList[ SCLGAD_TOP ],INTEGER_NUMBER)
    comp.visible:=Gets(self.gadgetList[ SCLGAD_VISIBLE ],INTEGER_NUMBER)
    comp.total:=Gets(self.gadgetList[ SCLGAD_TOTAL ],INTEGER_NUMBER)
    comp.arrowdelta:=Gets(self.gadgetList[ SCLGAD_ARROWDELTA ],INTEGER_NUMBER)
    comp.arrows:=Gets(self.gadgetList[ SCLGAD_ARROWS ],CHECKBOX_CHECKED)
    comp.orientation:=Gets(self.gadgetList[ SCLGAD_ORIENTATION ],CHOOSER_SELECTED)
  ENDIF
ENDPROC res

EXPORT PROC createPreviewObject(scr) OF scrollerObject
  self.previewObject:=ScrollerObject, 
      GA_ID, self.id,
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      SCROLLER_TOP, self.top,
      SCROLLER_VISIBLE, self.visible,
      SCROLLER_TOTAL, self.total,
      SCROLLER_ARROWDELTA, self.arrowdelta,
      SCROLLER_ORIENTATION, ListItem([SORIENT_HORIZ,SORIENT_VERT],self.orientation),
    ScrollerEnd
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

EXPORT PROC updatePreviewObject() OF scrollerObject
  DEF i,comp:PTR TO reactionObject
  DEF map=0,maptarget=0:PTR TO reactionObject
   
  FOR i:=0 TO self.parent.children.count()-1
    comp:=self.parent.children.item(i)
    IF comp.type=TYPE_TEXTEDITOR
      IF comp::textEditorObject.linkToVScroll=self.id
        map:=[SCROLLER_TOP, GA_TEXTEDITOR_PROP_FIRST,TAG_DONE]
        maptarget:=comp
      ENDIF
    ENDIF
    IF comp.type=TYPE_TEXTFIELD
      IF comp::textFieldObject.linkToScrollBar=self.id
        map:=[SCROLLER_TOP, TEXTFIELD_TOP,TAG_DONE]
        maptarget:=comp
      ENDIF
    ENDIF
  ENDFOR

  IF map THEN SetGadgetAttrsA(self.previewObject,0,0,[ICA_MAP,map,TAG_DONE])
  IF maptarget THEN SetGadgetAttrsA(self.previewObject,0,0,[ICA_TARGET,maptarget.previewObject,TAG_DONE])
ENDPROC

EXPORT PROC create(parent) OF scrollerObject
  self.type:=TYPE_SCROLLER
  SUPER self.create(parent)
  
  self.top:=0
  self.visible:=1
  self.total:=1
  self.arrowdelta:=1
  self.arrows:=TRUE
  self.orientation:=0

  self.libsused:=[TYPE_SCROLLER,TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF scrollerObject
  DEF editForm:PTR TO scrollerSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res=MR_OK

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF scrollerObject IS
[
  makeProp(top,FIELDTYPE_INT),
  makeProp(visible,FIELDTYPE_INT),
  makeProp(total,FIELDTYPE_INT),
  makeProp(arrowdelta,FIELDTYPE_INT),
  makeProp(arrows,FIELDTYPE_CHAR),
  makeProp(orientation,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF scrollerObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  srcGen.componentPropertyInt('SCROLLER_Top',self.top)
  srcGen.componentPropertyInt('SCROLLER_Visible',self.visible)
  srcGen.componentPropertyInt('SCROLLER_Total',self.total)
  srcGen.componentProperty('SCROLLER_Arrows',IF self.arrows THEN 'TRUE' ELSE 'FALSE',FALSE)
  IF self.arrowdelta<>1 THEN srcGen.componentPropertyInt('SCROLLER_ArrowDelta',self.arrowdelta)
  srcGen.componentProperty('SCROLLER_Orientation',ListItem(['SORIENT_HORIZ','SORIENT_VERT'],self.orientation),FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF scrollerObject
  srcGen.componentAddChildLabel(self.name)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC getTypeName() OF scrollerObject
  RETURN 'Scroller'
ENDPROC

EXPORT PROC createScrollerObject(parent)
  DEF scroller:PTR TO scrollerObject
  
  NEW scroller.create(parent)
ENDPROC scroller
