OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/textEditor','texteditor',
        'gadgets/checkbox','checkbox',
        'gadgets/chooser','chooser',
        'gadgets/integer','integer',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen','*validator','*stringlist'

EXPORT ENUM TEXTEDGAD_IDENT, TEXTEDGAD_HINT, TEXTEDGAD_EXPORTWRAP,TEXTEDGAD_FIXEDFONT,TEXTEDGAD_FLOW,TEXTEDGAD_IMPORTWRAP,
      TEXTEDGAD_INDENTWIDTH,TEXTEDGAD_LINEENDING,TEXTEDGAD_LINENUMBERS,TEXTEDGAD_SPACESPERTAB,TEXTEDGAD_TABTYPE,TEXTEDGAD_READONLY,
      TEXTEDGAD_HORIZSCROLL,TEXTEDGAD_LINKTOHSCROLL,TEXTEDGAD_LINKTOVSCROLL,
      TEXTEDGAD_OK, TEXTEDGAD_CHILD, TEXTEDGAD_CANCEL
     
CONST NUM_TEXTED_GADS=TEXTEDGAD_CANCEL+1

EXPORT DEF texteditorbase

EXPORT OBJECT textEditorObject OF reactionObject
  exportWrap:CHAR
  fixedFont:CHAR
  flow:CHAR
  importWrap:INT
  indentWidth:LONG
  lineEndingExport:CHAR
  showLineNumbers:CHAR
  spacesPerTab:INT
  tabKeyPolicy:CHAR
  readOnly:CHAR
  horizScroll:CHAR
  linkToHScroll:INT
  linkToVScroll:INT
ENDOBJECT

OBJECT textEditorSettingsForm OF reactionForm
PRIVATE
  textEditorObject:PTR TO textEditorObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
  labels3:PTR TO LONG
  labels4:PTR TO LONG
ENDOBJECT

PROC create() OF textEditorSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_TEXTED_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_TEXTED_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'TextEditor Attribute Setting',
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

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_IDENT ]:=StringObject,
          GA_ID, TEXTEDGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTEDGAD_HINT ]:=ButtonObject,
          GA_ID, TEXTEDGAD_HINT,
          GA_TEXT, 'Hint',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,           
        CHILD_WEIGHTEDWIDTH,50,
        
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_EXPORTWRAP ]:=CheckBoxObject,
          GA_ID, TEXTEDGAD_EXPORTWRAP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Export Wrap',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_FIXEDFONT ]:=CheckBoxObject,
          GA_ID, TEXTEDGAD_FIXEDFONT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Fixed Font',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_LINENUMBERS ]:=CheckBoxObject,
          GA_ID, TEXTEDGAD_LINENUMBERS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Line Numbers',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_FLOW ]:=ChooserObject,
          GA_ID, TEXTEDGAD_FLOW,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels1:=chooserLabelsA(['GV_TEXTEDITOR_Flow_Left','GV_TEXTEDITOR_Flow_Right',',GV_TEXTEDITOR_Flow_Center','GV_TEXTEDITOR_Flow_Justified',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Flow',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_LINEENDING ]:=ChooserObject,
          GA_ID, TEXTEDGAD_LINEENDING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['LINEENDING_LF','LINEENDING_CR','LINEENDING_CRLF','LINEENDING_ASIMPORT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Type',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_TABTYPE ]:=ChooserObject,
          GA_ID, TEXTEDGAD_TABTYPE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels3:=chooserLabelsA(['GV_TEXTEDITOR_TabKey_IndentsLine','GV_TEXTEDITOR_TabKey_IndentsAfter',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Tab Key Policy',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_READONLY ]:=CheckBoxObject,
          GA_ID, TEXTEDGAD_READONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Read Only',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTEDGAD_IMPORTWRAP ]:=IntegerObject,
          GA_ID, TEXTEDGAD_IMPORTWRAP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 2,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 99,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Import Wrap',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTEDGAD_INDENTWIDTH ]:=IntegerObject,
          GA_ID, TEXTEDGAD_INDENTWIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 2,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 99,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Indent Width',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD,  self.gadgetList[ TEXTEDGAD_SPACESPERTAB ]:=IntegerObject,
        GA_ID, TEXTEDGAD_SPACESPERTAB,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        INTEGER_MAXCHARS, 2,
        INTEGER_MINIMUM, 0,
        INTEGER_MAXIMUM, 99,
      IntegerEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Spaces Per Tab',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_HORIZSCROLL ]:=CheckBoxObject,
          GA_ID, TEXTEDGAD_HORIZSCROLL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Horizontal scroll',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_LINKTOHSCROLL ]:=ChooserObject,
          GA_ID, TEXTEDGAD_LINKTOHSCROLL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 32,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels4:=chooserLabelsA(['None',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Link to scroller',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ TEXTEDGAD_LINKTOVSCROLL ]:=ChooserObject,
          GA_ID, TEXTEDGAD_LINKTOHSCROLL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 32,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.labels4,
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Link to scroller',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTEDGAD_OK ]:=ButtonObject,
          GA_ID, TEXTEDGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTEDGAD_CHILD ]:=ButtonObject,
          GA_ID, TEXTEDGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ TEXTEDGAD_CANCEL ]:=ButtonObject,
          GA_ID, TEXTEDGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[TEXTEDGAD_CHILD]:={editChildSettings}
  self.gadgetActions[TEXTEDGAD_HINT]:={editHint}  
  self.gadgetActions[TEXTEDGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[TEXTEDGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF textEditorSettingsForm
  self:=nself
  self.setBusy()
  self.textEditorObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF textEditorSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )
  freeChooserLabels( self.labels4 )

  END self.gadgetList[NUM_TEXTED_GADS]
  END self.gadgetActions[NUM_TEXTED_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF textEditorSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.textEditorObject,TEXTEDGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editHint(nself,gadget,id,code) OF textEditorSettingsForm
  self:=nself
  self.setBusy()
  self.textEditorObject.editHint()
  self.clearBusy()
  self.updateHint(TEXTEDGAD_HINT, self.textEditorObject.hintText)
ENDPROC

PROC editSettings(comp:PTR TO textEditorObject) OF textEditorSettingsForm
  DEF res
  DEF scrlgads:PTR TO LONG
  DEF i,counter=0,selscroll1,selscroll2
  DEF gad:PTR TO reactionObject
    
  FOR i:=0 TO comp.parent.children.count()-1
    IF comp.parent.children.item(i)::reactionObject.type=TYPE_SCROLLER
      counter++
    ENDIF
  ENDFOR

  scrlgads:=List(counter+2)
  ListAddItem(scrlgads,'None')
  selscroll1:=0
  counter:=0
  FOR i:=0 TO comp.parent.children.count()-1
    gad:=comp.parent.children.item(i)
    IF gad.type=TYPE_SCROLLER
      counter++
      IF gad.id=comp.linkToHScroll THEN selscroll1:=counter
      IF gad.id=comp.linkToVScroll THEN selscroll2:=counter
      ListAddItem(scrlgads,gad.ident)
    ENDIF
  ENDFOR
  ListAddItem(scrlgads,0)
  freeChooserLabels(self.labels4)
  self.labels4:=chooserLabelsA(scrlgads)
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_LINKTOVSCROLL ],0,0,[CHOOSER_LABELS,self.labels4,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_LINKTOHSCROLL ],0,0,[CHOOSER_LABELS,self.labels4,0]) 
  DisposeLink(scrlgads)

  self.textEditorObject:=comp

  self.updateHint(TEXTEDGAD_HINT, comp.hintText)     
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])   
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_EXPORTWRAP ],0,0,[CHECKBOX_CHECKED,comp.exportWrap,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_FIXEDFONT ],0,0,[CHECKBOX_CHECKED,comp.fixedFont,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_FLOW ],0,0,[CHOOSER_SELECTED,comp.flow,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_IMPORTWRAP ],0,0,[INTEGER_NUMBER,comp.importWrap,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_INDENTWIDTH ],0,0,[INTEGER_NUMBER,comp.indentWidth,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_LINEENDING ],0,0,[CHOOSER_SELECTED,comp.lineEndingExport,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_LINENUMBERS ],0,0,[CHECKBOX_CHECKED,comp.showLineNumbers,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_SPACESPERTAB ],0,0,[INTEGER_NUMBER,comp.spacesPerTab,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_TABTYPE ],0,0,[CHOOSER_SELECTED,comp.tabKeyPolicy,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_HORIZSCROLL ],0,0,[CHECKBOX_CHECKED,comp.horizScroll,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_LINKTOHSCROLL ],0,0,[CHOOSER_SELECTED,selscroll1,0]) 
  SetGadgetAttrsA(self.gadgetList[ TEXTEDGAD_LINKTOVSCROLL ],0,0,[CHOOSER_SELECTED,selscroll2,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ TEXTEDGAD_IDENT ],STRINGA_TEXTVAL))
    comp.exportWrap:=Gets(self.gadgetList[ TEXTEDGAD_EXPORTWRAP ],CHECKBOX_CHECKED)   
    comp.fixedFont:=Gets(self.gadgetList[ TEXTEDGAD_FIXEDFONT ],CHECKBOX_CHECKED)   
    comp.flow:=Gets(self.gadgetList[ TEXTEDGAD_FLOW ],CHOOSER_SELECTED)   
    comp.importWrap:=Gets(self.gadgetList[ TEXTEDGAD_IMPORTWRAP ],INTEGER_NUMBER)   
    comp.indentWidth:=Gets(self.gadgetList[ TEXTEDGAD_INDENTWIDTH ],INTEGER_NUMBER)   
    comp.lineEndingExport:=Gets(self.gadgetList[ TEXTEDGAD_LINEENDING ],CHOOSER_SELECTED)   
    comp.showLineNumbers:=Gets(self.gadgetList[ TEXTEDGAD_LINENUMBERS ],CHECKBOX_CHECKED)   
    comp.spacesPerTab:=Gets(self.gadgetList[ TEXTEDGAD_SPACESPERTAB ],INTEGER_NUMBER)   
    comp.tabKeyPolicy:=Gets(self.gadgetList[ TEXTEDGAD_TABTYPE ],CHOOSER_SELECTED)   
    comp.readOnly:=Gets(self.gadgetList[ TEXTEDGAD_READONLY ],CHECKBOX_CHECKED)   
    comp.horizScroll:=Gets(self.gadgetList[ TEXTEDGAD_HORIZSCROLL ],CHECKBOX_CHECKED)   

    selscroll1:=Gets(self.gadgetList[ TEXTEDGAD_LINKTOHSCROLL ],CHOOSER_SELECTED)
    selscroll2:=Gets(self.gadgetList[ TEXTEDGAD_LINKTOVSCROLL ],CHOOSER_SELECTED)

    comp.linkToHScroll:=0
    comp.linkToVScroll:=0
    FOR i:=0 TO comp.parent.children.count()-1
      gad:=comp.parent.children.item(i)
      IF gad.type=TYPE_SCROLLER
        selscroll1--
        selscroll2--
        IF selscroll1=0 THEN comp.linkToHScroll:=gad.id
        IF selscroll2=0 THEN comp.linkToVScroll:=gad.id
      ENDIF
    ENDFOR

  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF textEditorObject
  DEF tempbase
  self.previewObject:=0
  IF (texteditorbase)
    tempbase:=textfieldbase
    textfieldbase:=texteditorbase
    
    self.previewObject:=NewObjectA( TextEditor_GetClass(), NIL,[TAG_IGNORE,0,
      GA_ID, self.id,
      GA_READONLY, self.readOnly,
      GA_TEXTEDITOR_EXPORTWRAP, self.exportWrap,
      GA_TEXTEDITOR_FIXEDFONT, self.fixedFont,
      GA_TEXTEDITOR_FLOW, ListItem([GV_TEXTEDITOR_FLOW_LEFT,GV_TEXTEDITOR_FLOW_RIGHT,GV_TEXTEDITOR_FLOW_CENTER,GV_TEXTEDITOR_FLOW_JUSTIFIED],self.flow),
      GA_TEXTEDITOR_IMPORTWRAP ,self.importWrap,
      GA_TEXTEDITOR_INDENTWIDTH,self.indentWidth,
      GA_TEXTEDITOR_LINEENDINGEXPORT, ListItem([LINEENDING_LF,LINEENDING_CR,LINEENDING_CRLF,LINEENDING_ASIMPORT],self.lineEndingExport),
      GA_TEXTEDITOR_SHOWLINENUMBERS, self.showLineNumbers,
      GA_TEXTEDITOR_SPACESPERTAB,self.spacesPerTab,
      GA_TEXTEDITOR_HORIZONTALSCROLL, self.horizScroll,
      GA_TEXTEDITOR_TABKEYPOLICY, ListItem([GV_TEXTEDITOR_TABKEY_INDENTSLINE,GV_TEXTEDITOR_TABKEY_INDENTSAFTER],self.tabKeyPolicy),
      TAG_END])
  ENDIF
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)
  textfieldbase:=tempbase
  
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

EXPORT PROC create(parent) OF textEditorObject
  self.type:=TYPE_TEXTEDITOR
  SUPER self.create(parent)
  self.exportWrap:=0
  self.fixedFont:=0
  self.flow:=0
  self.importWrap:=1023
  self.indentWidth:=0
  self.lineEndingExport:=0
  self.showLineNumbers:=0
  self.spacesPerTab:=2
  self.tabKeyPolicy:=1
  self.readOnly:=0
  self.horizScroll:=TRUE
  self.linkToHScroll:=0
  self.linkToVScroll:=0
  self.libsused:=[TYPE_TEXTEDITOR]
ENDPROC

EXPORT PROC editSettings() OF textEditorObject
  DEF editForm:PTR TO textEditorSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF textEditorObject
  RETURN 'TextEditor'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF textEditorObject IS
[
  makeProp(exportWrap,FIELDTYPE_CHAR),
  makeProp(fixedFont,FIELDTYPE_CHAR),
  makeProp(flow,FIELDTYPE_CHAR),
  makeProp(importWrap,FIELDTYPE_INT),
  makeProp(indentWidth,FIELDTYPE_LONG),
  makeProp(lineEndingExport,FIELDTYPE_CHAR),
  makeProp(showLineNumbers,FIELDTYPE_CHAR),
  makeProp(spacesPerTab,FIELDTYPE_INT),
  makeProp(tabKeyPolicy,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(horizScroll,FIELDTYPE_CHAR),
  makeProp(linkToHScroll,FIELDTYPE_INT),
  makeProp(linkToVScroll,FIELDTYPE_INT)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF textEditorObject
  srcGen.componentPropertyInt('GA_ReadOnly',self.readOnly)

  srcGen.componentPropertyInt('GA_TEXTEDITOR_ExportWrap',self.exportWrap)
  srcGen.componentPropertyInt('GA_TEXTEDITOR_ImportWrap',self.importWrap)
  srcGen.componentProperty('GA_TEXTEDITOR_FixedFont',IF self.fixedFont THEN 'TRUE' ELSE 'FALSE',FALSE)
  IF srcGen.type=CSOURCE_GEN
    srcGen.componentProperty('GA_TEXTEDITOR_Flow',ListItem(['GV_TEXTEDITOR_Flow_Left','GV_TEXTEDITOR_Flow_Right','GV_TEXTEDITOR_Flow_Center','GV_TEXTEDITOR_Flow_Justified'],self.flow),FALSE)
  ELSE
    srcGen.componentProperty('GA_TEXTEDITOR_Flow',ListItem(['GV_TEXTEDITOR_FLOW_LEFT','GV_TEXTEDITOR_FLOW_RIGHT','GV_TEXTEDITOR_FLOW_CENTER','GV_TEXTEDITOR_FLOW_JUSTIFIED'],self.flow),FALSE)
  ENDIF
  srcGen.componentPropertyInt('GA_TEXTEDITOR_IndentWidth',self.indentWidth)
  srcGen.componentProperty('GA_TEXTEDITOR_LineEndingExport',ListItem(['LINEENDING_LF','LINEENDING_CR','LINEENDING_CRLF','LINEENDING_ASIMPORT'],self.lineEndingExport),FALSE)
  srcGen.componentProperty('GA_TEXTEDITOR_ShowLineNumbers',IF self.showLineNumbers THEN 'TRUE' ELSE 'FALSE',FALSE)
  srcGen.componentPropertyInt('GA_TEXTEDITOR_SpacesPerTAB',self.spacesPerTab)
  IF srcGen.type=CSOURCE_GEN
    srcGen.componentProperty('GA_TEXTEDITOR_TabKeyPolicy',ListItem(['GV_TEXTEDITOR_TabKey_IndentsLine','GV_TEXTEDITOR_TabKey_IndentsAfter'],self.tabKeyPolicy),FALSE)
  ELSE
    srcGen.componentProperty('GA_TEXTEDITOR_TabKeyPolicy',ListItem(['GV_TEXTEDITOR_TABKEY_INDENTSLINE','GV_TEXTEDITOR_TABKEY_INDENTSAFTER'],self.tabKeyPolicy),FALSE)
  ENDIF
ENDPROC

EXPORT PROC hasCreateMacro() OF textEditorObject IS FALSE ->create macro was missing from EVO modules

EXPORT PROC getTypeEndName() OF textEditorObject
  RETURN 'End'
ENDPROC

EXPORT PROC createTextEditorObject(parent)
  DEF textEditor:PTR TO textEditorObject
  
  NEW textEditor.create(parent)
ENDPROC textEditor


