OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'listbrowser','gadgets/listbrowser',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi','amigalib/lists',
        'exec/lists','exec/nodes',
        'exec/memory',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*listPicker','*stringlist','*reactionListObject','*reactionLists','*sourceGen','*validator'

EXPORT ENUM LISTBGAD_IDENT, LISTBGAD_HINT, LISTBGAD_LISTSELECT, LISTBGAD_COLUMNSBUTTON,
      LISTBGAD_TOP, LISTBGAD_MAKEVISIBLE,
      LISTBGAD_POSITION, LISTBGAD_VIRTUALWIDTH, LISTBGAD_NUMCOLS,
      LISTBGAD_LEFT, LISTBGAD_SPACING, LISTBGAD_SELECTED,
      LISTBGAD_DISABLED, LISTBGAD_READONLY, LISTBGAD_SHOWSELECTED, LISTBGAD_MULTISELECT,
      LISTBGAD_SEPARATOR, LISTBGAD_VSEPARATOR, LISTBGAD_HSEPARATOR, LISTBGAD_BORDERLESS,
      LISTBGAD_COLUMNTITLES, LISTBGAD_AUTOFIT, LISTBGAD_VPROP, LISTBGAD_HPROP,
      LISTBGAD_SCROLLRAST, LISTBGAD_HIERARCHICAL, LISTBGAD_EDITABLE,
      LISTBGAD_OK, LISTBGAD_CHILD, LISTBGAD_CANCEL

CONST NUM_LISTB_GADS=LISTBGAD_CANCEL+1

ENUM EDITCOLGADS_LIST, EDITCOLGADS_COLTITLE, EDITCOLGADS_COLWIDTH,EDITCOLGADS_SETBTN, EDITCOLGADS_OK, EDITCOLGADS_CANCEL
CONST NUM_EDITCOL_GADS=EDITCOLGADS_CANCEL+1

EXPORT OBJECT listBrowserObject OF reactionObject
  listObjectId:LONG
  top:INT
  makeVisible:INT
  position:INT
  virtualWidth:INT
  numColumns:INT
  left:INT
  spacing:INT
  selected:INT
  disabled:CHAR
  readOnly:CHAR
  showSelected:CHAR
  multiSelect:CHAR
  separators:CHAR
  vertSeparators:CHAR
  horzSeparators:CHAR
  borderless:CHAR
  columnTitles:CHAR
  autofit:CHAR
  vertProp:CHAR
  horzProp:CHAR
  scrollRaster:CHAR
  hierarchical:CHAR
  editable:CHAR
  colWidths:PTR TO stdlist
  colTitles:PTR TO stringlist

PRIVATE
  columnInfo:PTR TO columninfo
  browsernodes:PTR TO LONG
ENDOBJECT

OBJECT listBrowserSettingsForm OF reactionForm
PRIVATE
  listBrowserObject:PTR TO listBrowserObject
  colTitles:PTR TO stringlist
  colWidths:PTR TO stdlist
  selectedListId:LONG
ENDOBJECT

OBJECT editColumnsForm OF reactionForm
  count:LONG
  browserlist:PTR TO LONG
  columnInfo:PTR TO columninfo
  nodes:PTR TO stdlist
  selectedNodeNum:INT
ENDOBJECT

PROC create() OF listBrowserSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_LISTB_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_LISTB_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'ListBrowser Attribute Setting',
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
        
        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_IDENT ]:=StringObject,
          GA_ID, LISTBGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,
       
        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_HINT ]:=ButtonObject,
          GA_ID, LISTBGAD_HINT,
          GA_TEXT, 'Hint',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,    
        CHILD_WEIGHTEDWIDTH,50,
        
        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_LISTSELECT ]:=ButtonObject,
          GA_ID, LISTBGAD_LISTSELECT,
          GA_TEXT, '_Pick a List',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDWIDTH,50,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_COLUMNSBUTTON ]:=ButtonObject,
          GA_ID, LISTBGAD_COLUMNSBUTTON,
          GA_TEXT, 'Edit Columns',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDWIDTH,50,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_TOP ]:=IntegerObject,
          GA_ID, LISTBGAD_TOP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Top',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_MAKEVISIBLE ]:=IntegerObject,
          GA_ID, LISTBGAD_MAKEVISIBLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Make_Visible',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_POSITION ]:=IntegerObject,
          GA_ID, LISTBGAD_POSITION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Positi_on',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_VIRTUALWIDTH ]:=IntegerObject,
          GA_ID, LISTBGAD_VIRTUALWIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Virtual_Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_NUMCOLS ]:=IntegerObject,
          GA_ID, LISTBGAD_NUMCOLS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_NumColumns',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_LEFT ]:=IntegerObject,
          GA_ID, LISTBGAD_LEFT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Left',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_SPACING ]:=IntegerObject,
          GA_ID, LISTBGAD_SPACING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, 0,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Spacing',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_SELECTED ]:=IntegerObject,
          GA_ID, LISTBGAD_SELECTED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MINIMUM, -1,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Select_ed',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, LISTBGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_READONLY ]:=CheckBoxObject,
          GA_ID, LISTBGAD_READONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_ReadOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_SHOWSELECTED ]:=CheckBoxObject,
          GA_ID, LISTBGAD_SHOWSELECTED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_ShowSelected',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_MULTISELECT ]:=CheckBoxObject,
          GA_ID, LISTBGAD_MULTISELECT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_MultiSelect',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_SEPARATOR ]:=CheckBoxObject,
          GA_ID, LISTBGAD_SEPARATOR,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Sep_arators',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_VSEPARATOR ]:=CheckBoxObject,
          GA_ID, LISTBGAD_VSEPARATOR,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'VertSeparators',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_HSEPARATOR ]:=CheckBoxObject,
          GA_ID, LISTBGAD_HSEPARATOR,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'HorizSeparators',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_BORDERLESS ]:=CheckBoxObject,
          GA_ID, LISTBGAD_BORDERLESS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, '_Borderless',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_COLUMNTITLES ]:=CheckBoxObject,
          GA_ID, LISTBGAD_COLUMNTITLES,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Col_umnTitles',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_AUTOFIT ]:=CheckBoxObject,
          GA_ID, LISTBGAD_AUTOFIT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'AutoFit',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_VPROP ]:=CheckBoxObject,
          GA_ID, LISTBGAD_VPROP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'VerticalProp',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_HPROP ]:=CheckBoxObject,
          GA_ID, LISTBGAD_HPROP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'HorizontalProp',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_SCROLLRAST ]:=CheckBoxObject,
          GA_ID, LISTBGAD_SCROLLRAST,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'ScrollRaster',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_HIERARCHICAL ]:=CheckBoxObject,
          GA_ID, LISTBGAD_HIERARCHICAL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Hierarchical',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_EDITABLE ]:=CheckBoxObject,
          GA_ID, LISTBGAD_EDITABLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Editable',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_OK ]:=ButtonObject,
          GA_ID, LISTBGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_CHILD ]:=ButtonObject,
          GA_ID, LISTBGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_CANCEL ]:=ButtonObject,
          GA_ID, LISTBGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[LISTBGAD_LISTSELECT]:={selectList}
  self.gadgetActions[LISTBGAD_CHILD]:={editChildSettings}
  self.gadgetActions[LISTBGAD_COLUMNTITLES]:={colTitles}
  self.gadgetActions[LISTBGAD_COLUMNSBUTTON]:={editColumns}
  self.gadgetActions[LISTBGAD_HINT]:={editHint}  
  self.gadgetActions[LISTBGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[LISTBGAD_OK]:=MR_OK
ENDPROC

PROC colTitles(nself,gadget,id,code) OF listBrowserSettingsForm
  self:=nself
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_COLUMNSBUTTON ],0,0,[GA_DISABLED,IF code=1 THEN FALSE ELSE TRUE,0])
  DoMethod(self.windowObj, WM_RETHINK)
ENDPROC

PROC editColumns(nself,gadget,id,code) OF listBrowserSettingsForm
  DEF editColumnsForm: PTR TO editColumnsForm
  DEF colcount
  
  self:=nself
  
  self.setBusy()
  colcount:=Gets(self.gadgetList[ LISTBGAD_NUMCOLS ],INTEGER_NUMBER)
  
  NEW editColumnsForm.create(colcount)
  editColumnsForm.editColumns(self.colTitles,self.colWidths)
  END editColumnsForm
  self.clearBusy()
ENDPROC

PROC selectList(nself,gadget,id,code) OF listBrowserSettingsForm
  DEF frmListPicker:PTR TO listPickerForm
  DEF res
  
  self:=nself
  
  self.setBusy()
  NEW frmListPicker.create()
  IF (res:=frmListPicker.selectList())<>-1
    self.selectedListId:=res  
  ENDIF
  END frmListPicker
  self.clearBusy()
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF listBrowserSettingsForm
  self:=nself
  self.setBusy()
  self.listBrowserObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF listBrowserSettingsForm
  END self.gadgetList[NUM_LISTB_GADS]
  END self.gadgetActions[NUM_LISTB_GADS]
ENDPROC

EXPORT PROC canClose(modalRes) OF listBrowserSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.listBrowserObject,LISTBGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE



PROC editHint(nself,gadget,id,code) OF listBrowserSettingsForm
  self:=nself
  self.setBusy()
  self.listBrowserObject.editHint()
  self.clearBusy()
  self.updateHint(LISTBGAD_HINT, self.listBrowserObject.hintText)
ENDPROC

PROC editSettings(comp:PTR TO listBrowserObject) OF listBrowserSettingsForm
  DEF res

  self.listBrowserObject:=comp
  self.selectedListId:=comp.listObjectId
  self.colTitles:=comp.colTitles
  self.colWidths:=comp.colWidths

  self.updateHint(LISTBGAD_HINT, comp.hintText)
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_TOP ],0,0,[INTEGER_NUMBER,comp.top,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_MAKEVISIBLE ],0,0,[INTEGER_NUMBER,comp.makeVisible,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_POSITION ],0,0,[INTEGER_NUMBER,comp.position,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_VIRTUALWIDTH ],0,0,[INTEGER_NUMBER,comp.virtualWidth,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_NUMCOLS ],0,0,[INTEGER_NUMBER,comp.numColumns,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_LEFT ],0,0,[INTEGER_NUMBER,comp.left,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_SPACING ],0,0,[INTEGER_NUMBER,comp.spacing,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_SELECTED ],0,0,[INTEGER_NUMBER,comp.selected,0])

  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_SHOWSELECTED ],0,0,[CHECKBOX_CHECKED,comp.showSelected,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_MULTISELECT ],0,0,[CHECKBOX_CHECKED,comp.multiSelect,0])

  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_SEPARATOR ],0,0,[CHECKBOX_CHECKED,comp.separators,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_VSEPARATOR ],0,0,[CHECKBOX_CHECKED,comp.vertSeparators,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_HSEPARATOR ],0,0,[CHECKBOX_CHECKED,comp.horzSeparators,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_BORDERLESS ],0,0,[CHECKBOX_CHECKED,comp.borderless,0])

  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_COLUMNTITLES ],0,0,[CHECKBOX_CHECKED,comp.columnTitles,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_AUTOFIT ],0,0,[CHECKBOX_CHECKED,comp.autofit,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_VPROP ],0,0,[CHECKBOX_CHECKED,comp.vertProp,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_HPROP ],0,0,[CHECKBOX_CHECKED,comp.horzProp,0])

  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_SCROLLRAST ],0,0,[CHECKBOX_CHECKED,comp.scrollRaster,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_HIERARCHICAL ],0,0,[CHECKBOX_CHECKED,comp.hierarchical,0])
  SetGadgetAttrsA(self.gadgetList[ LISTBGAD_EDITABLE ],0,0,[CHECKBOX_CHECKED,comp.editable,0])

  self.colTitles(self,0,0,comp.columnTitles)

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ LISTBGAD_IDENT ],STRINGA_TEXTVAL))
    comp.listObjectId:=self.selectedListId
    comp.top:=Gets(self.gadgetList[ LISTBGAD_TOP ],INTEGER_NUMBER)
    comp.makeVisible:=Gets(self.gadgetList[ LISTBGAD_MAKEVISIBLE ],INTEGER_NUMBER)
    comp.position:=Gets(self.gadgetList[ LISTBGAD_POSITION ],INTEGER_NUMBER)
    comp.virtualWidth:=Gets(self.gadgetList[ LISTBGAD_VIRTUALWIDTH ],INTEGER_NUMBER)
    comp.numColumns:=Gets(self.gadgetList[ LISTBGAD_NUMCOLS ],INTEGER_NUMBER)
    comp.left:=Gets(self.gadgetList[ LISTBGAD_LEFT ],INTEGER_NUMBER)
    comp.spacing:=Gets(self.gadgetList[ LISTBGAD_SPACING ],INTEGER_NUMBER)
    comp.selected:=Gets(self.gadgetList[ LISTBGAD_SELECTED ],INTEGER_NUMBER)

    comp.disabled:=Gets(self.gadgetList[ LISTBGAD_DISABLED ],CHECKBOX_CHECKED)
    comp.readOnly:=Gets(self.gadgetList[ LISTBGAD_READONLY ],CHECKBOX_CHECKED)
    comp.showSelected:=Gets(self.gadgetList[ LISTBGAD_SHOWSELECTED ],CHECKBOX_CHECKED)
    comp.multiSelect:=Gets(self.gadgetList[ LISTBGAD_MULTISELECT ],CHECKBOX_CHECKED)

    comp.separators:=Gets(self.gadgetList[ LISTBGAD_SEPARATOR ],CHECKBOX_CHECKED)
    comp.vertSeparators:=Gets(self.gadgetList[ LISTBGAD_VSEPARATOR ],CHECKBOX_CHECKED)
    comp.horzSeparators:=Gets(self.gadgetList[ LISTBGAD_HSEPARATOR ],CHECKBOX_CHECKED)
    comp.borderless:=Gets(self.gadgetList[ LISTBGAD_BORDERLESS ],CHECKBOX_CHECKED)

    comp.columnTitles:=Gets(self.gadgetList[ LISTBGAD_COLUMNTITLES ],CHECKBOX_CHECKED)
    comp.autofit:=Gets(self.gadgetList[ LISTBGAD_AUTOFIT ],CHECKBOX_CHECKED)
    comp.vertProp:=Gets(self.gadgetList[ LISTBGAD_VPROP ],CHECKBOX_CHECKED)
    comp.horzProp:=Gets(self.gadgetList[ LISTBGAD_HPROP ],CHECKBOX_CHECKED)

    comp.scrollRaster:=Gets(self.gadgetList[ LISTBGAD_SCROLLRAST ],CHECKBOX_CHECKED)
    comp.hierarchical:=Gets(self.gadgetList[ LISTBGAD_HIERARCHICAL ],CHECKBOX_CHECKED)
    comp.editable:=Gets(self.gadgetList[ LISTBGAD_EDITABLE ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

PROC create(count) OF editColumnsForm
  DEF gads:PTR TO LONG
  DEF i,newLayout

  DEF rootLayout
  
  NEW gads[NUM_EDITCOL_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_EDITCOL_GADS]
  self.gadgetActions:=gads
  self.count:=count

  self.browserlist:=browserNodesA([0])

  self.columnInfo:=New(4*SIZEOF columninfo)
  self.columnInfo[0].width:=1
  self.columnInfo[0].title:='Column Number'
  self.columnInfo[0].flags:=CIF_WEIGHTED

  self.columnInfo[1].width:=2
  self.columnInfo[1].title:='Column Title'
  self.columnInfo[1].flags:=CIF_WEIGHTED
  
  self.columnInfo[2].width:=2
  self.columnInfo[2].title:='Column Width'
  self.columnInfo[2].flags:=CIF_WEIGHTED

  self.columnInfo[3].width:=-1
  self.columnInfo[3].title:=-1
  self.columnInfo[3].flags:=-1

  self.windowObj:=WindowObject,
    WA_TITLE, 'Set ListBrowser Columns',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 250,
    WA_WIDTH, 250,
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

      LAYOUT_ADDCHILD,  self.gadgetList[ EDITCOLGADS_LIST ]:=ListBrowserObject, 
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_ID,EDITCOLGADS_LIST,
        
        LISTBROWSER_COLUMNTITLES, TRUE,
        LISTBROWSER_COLUMNINFO, self.columnInfo,
        LISTBROWSER_LABELS, self.browserlist,
      ListBrowserEnd,
      CHILD_WEIGHTEDHEIGHT, 100,
          
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ EDITCOLGADS_COLTITLE ]:=StringObject,
              GA_ID, EDITCOLGADS_COLTITLE,
              GA_DISABLED,TRUE,
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
              STRINGA_MAXCHARS, 80,
            StringEnd,
            CHILD_LABEL, LabelObject,
              LABEL_TEXT, 'Column Title',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ EDITCOLGADS_COLWIDTH ]:=IntegerObject,
                GA_ID, EDITCOLGADS_COLWIDTH,
                GA_DISABLED,TRUE,
                GA_RELVERIFY, TRUE,
                GA_TABCYCLE, TRUE,
                INTEGER_MINIMUM, 0,
            IntegerEnd,
            CHILD_LABEL, LabelObject,
              LABEL_TEXT, 'Column Width',
          LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ EDITCOLGADS_SETBTN ]:=ButtonObject,
          GA_ID, EDITCOLGADS_SETBTN,
          GA_DISABLED,TRUE,
          GA_TEXT, 'Set',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LayoutEnd,
      CHILD_WEIGHTEDHEIGHT, 0,
  
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ EDITCOLGADS_OK ]:=ButtonObject,
          GA_ID, EDITCOLGADS_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ EDITCOLGADS_CANCEL ]:=ButtonObject,
          GA_ID, EDITCOLGADS_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT, 0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[EDITCOLGADS_LIST]:={updateSel}
  self.gadgetActions[EDITCOLGADS_SETBTN]:={setValues}
  self.gadgetActions[EDITCOLGADS_COLTITLE]:={setValues}
  self.gadgetActions[EDITCOLGADS_COLWIDTH]:={setValues}
  self.gadgetActions[EDITCOLGADS_CANCEL]:=MR_CANCEL
  self.gadgetActions[EDITCOLGADS_OK]:=MR_OK
  self.selectedNodeNum:=-1
ENDPROC

PROC updateSel(nself,gadget,id,code) OF editColumnsForm
  DEF t,n,win,dis
  self:=nself

  dis:=IF code>=0 THEN FALSE ELSE TRUE
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  SetGadgetAttrsA(self.gadgetList[ EDITCOLGADS_COLTITLE ],win,0,[GA_DISABLED, dis,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ EDITCOLGADS_COLWIDTH ],win,0,[GA_DISABLED, dis,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ EDITCOLGADS_SETBTN ],win,0,[GA_DISABLED, dis,TAG_END])

  self.selectedNodeNum:=code
  GetListBrowserNodeAttrsA (self.nodes.item(code),[LBNA_COLUMN,1,LBNCA_TEXT,{t},LBNA_COLUMN,2,LBNCA_TEXT,{n},TAG_END])
  SetGadgetAttrsA(self.gadgetList[ EDITCOLGADS_COLTITLE ],win,0,[STRINGA_TEXTVAL,t,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ EDITCOLGADS_COLWIDTH ],win,0,[INTEGER_NUMBER,Val(n),TAG_END])
ENDPROC

PROC setValues(nself,gadget,id,code) OF editColumnsForm
  DEF t,n,win
  DEF tempStr[100]:STRING
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  
  t:=Gets(self.gadgetList[ EDITCOLGADS_COLTITLE ],STRINGA_TEXTVAL)
  n:=Gets(self.gadgetList[ EDITCOLGADS_COLWIDTH ],INTEGER_NUMBER)
  StringF(tempStr,'\d',n)
  SetGadgetAttrsA(self.gadgetList[EDITCOLGADS_LIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  SetListBrowserNodeAttrsA (self.nodes.item(self.selectedNodeNum),[LBNA_COLUMN,1,LBNCA_COPYTEXT,TRUE,LBNCA_TEXT,t,LBNA_COLUMN,2,LBNCA_COPYTEXT,TRUE,LBNCA_TEXT,tempStr,TAG_END])
  SetGadgetAttrsA(self.gadgetList[EDITCOLGADS_LIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
ENDPROC

PROC end() OF editColumnsForm
  freeBrowserNodes(self.browserlist)
  Dispose(self.columnInfo)
  SUPER self.end()
ENDPROC

PROC editColumns(titles:PTR TO stringlist, widths:PTR TO stdlist) OF editColumnsForm
  DEF i,res,t,n
  DEF tempStr[200]:STRING
  DEF colTitle[200]:STRING
  DEF colWidth[10]:STRING
  DEF nodes:PTR TO stdlist
  
  SetGadgetAttrsA(self.gadgetList[EDITCOLGADS_LIST],0,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

  NEW nodes.stdlist(self.count)
  self.nodes:=nodes

  FOR i:=0 TO self.count-1
    StringF(tempStr,'\d',i+1)
    
    IF i<titles.count() THEN StrCopy(colTitle,titles.item(i)) ELSE StringF(colTitle,'Column\d',i+1)
    IF i<widths.count() THEN StringF(colWidth,'\d',widths.item(i)) ELSE StrCopy(colWidth,'1')
    
    IF (n:=AllocListBrowserNodeA(3, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, tempStr, LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, colTitle,LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, colWidth,TAG_END])) 
      AddTail(self.browserlist, n)
    ENDIF
    nodes.add(n)
  ENDFOR

  SetGadgetAttrsA(self.gadgetList[EDITCOLGADS_LIST],0,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  
  res:=self.showModal()
  IF res=MR_OK
    FOR i:=0 TO self.count-1
      GetListBrowserNodeAttrsA (nodes.item(i),[LBNA_COLUMN,1,LBNCA_TEXT,{t},LBNA_COLUMN,2,LBNCA_TEXT,{n},TAG_END])
      titles.setItem(i,t)
      widths.setItem(i,Val(n))
    ENDFOR
  ENDIF
  
  END nodes
ENDPROC res=MR_OK

PROC browserNodesA(text:PTR TO LONG, colCount) OF listBrowserObject
  DEF list:PTR TO lh
  DEF node:PTR TO ln
 
  IF (list:=AllocMem(SIZEOF lh,MEMF_PUBLIC))
		newList(list)

		WHILE( text[] )
      node:=AllocListBrowserNodeA( colCount,[LBNCA_TEXT,text[]++,0])
			IF(node=FALSE)
				freeBrowserNodes( list )
				RETURN NIL
			ENDIF

			AddTail( list, node )
		ENDWHILE
	ENDIF

ENDPROC list

PROC makeBrowserList(id) OF listBrowserObject
  DEF i,res
  DEF reactionList=0:PTR TO reactionListObject
  DEF findObject:PTR TO reactionListObject
  DEF newlist
  DEF reactionLists:PTR TO stdlist
  
  reactionLists:=getReactionLists()
  FOR i:=0 TO reactionLists.count()-1
    findObject:=reactionLists.item(i)
    IF findObject.id = id
      reactionList:=findObject
    ENDIF
  ENDFOR
  
  IF reactionList
    newlist:=List(reactionList.items.count()+1)
    FOR i:=0 TO reactionList.items.count()-1
      ListAddItem(newlist,reactionList.items.item(i))
    ENDFOR
  ELSE
    newlist:=List(1)
  ENDIF
  ListAddItem(newlist,0)
  res:=self.browserNodesA(newlist,self.numColumns)
  DisposeLink(newlist)
ENDPROC res

EXPORT PROC createPreviewObject(scr) OF listBrowserObject
  DEF i
  Dispose(self.columnInfo)

  self.columnInfo:=New((self.numColumns+1)*SIZEOF columninfo)
  FOR i:=0 TO self.numColumns-1
    IF self.colWidths.count()>i
      self.columnInfo[i].width:=self.colWidths.item(i)
    ELSE
      self.columnInfo[i].width:=1
    ENDIF
    IF self.colTitles.count()>i
      self.columnInfo[i].title:=self.colTitles.item(i)
    ELSE
      self.columnInfo[i].title:=''
    ENDIF
    self.columnInfo[i].flags:=CIF_WEIGHTED
  ENDFOR

  self.columnInfo[self.numColumns].width:=-1
  self.columnInfo[self.numColumns].title:=-1
  self.columnInfo[self.numColumns].flags:=-1

  IF self.browsernodes THEN freeBrowserNodes( self.browsernodes )

  self.previewObject:=ListBrowserObject, 
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      GA_DISABLED, self.disabled,
      GA_READONLY, self.readOnly,
      
      LISTBROWSER_TOP, self.top,
      LISTBROWSER_MAKEVISIBLE, self.makeVisible,
      LISTBROWSER_POSITION, self.position,
      LISTBROWSER_VIRTUALWIDTH, self.virtualWidth,
      LISTBROWSER_LEFT, self.left,
      LISTBROWSER_SPACING, self.spacing,
      LISTBROWSER_SELECTED, self.selected,
      LISTBROWSER_SHOWSELECTED, self.showSelected,
      LISTBROWSER_MULTISELECT, self.multiSelect,
      LISTBROWSER_SEPARATORS, self.separators,
      LISTBROWSER_VERTSEPARATORS, self.vertSeparators,
      LISTBROWSER_HORIZSEPARATORS, self.horzSeparators,
      LISTBROWSER_BORDERLESS, self.borderless,
      LISTBROWSER_COLUMNTITLES, self.columnTitles,
      LISTBROWSER_AUTOFIT, self.autofit,
      LISTBROWSER_VERTICALPROP, self.vertProp,
      LISTBROWSER_HORIZONTALPROP, self.horzProp,
      LISTBROWSER_SCROLLRASTER, self.scrollRaster,
      LISTBROWSER_HIERARCHICAL, self.hierarchical,
      LISTBROWSER_EDITABLE, self.editable,
      LISTBROWSER_COLUMNINFO, self.columnInfo,
      LISTBROWSER_LABELS, self.browsernodes:=self.makeBrowserList(self.listObjectId),
    ListBrowserEnd
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

EXPORT PROC create(parent) OF listBrowserObject
  DEF colWidths:PTR TO stdlist
  DEF colTitles:PTR TO stringlist

  self.type:=TYPE_LISTBROWSER
  SUPER self.create(parent)
  
  NEW colWidths.stdlist(20)
  self.colWidths:=colWidths
  NEW colTitles.stringlist(20)
  self.colTitles:=colTitles
  self.columnInfo:=0
  
  self.listObjectId:=-1
  self.top:=0
  self.makeVisible:=0
  self.position:=0
  self.virtualWidth:=0
  self.numColumns:=1
  self.left:=0
  self.spacing:=0
  self.selected:=-1
  self.disabled:=0
  self.readOnly:=0
  self.showSelected:=TRUE
  self.multiSelect:=0
  self.separators:=TRUE
  self.vertSeparators:=TRUE
  self.horzSeparators:=0
  self.borderless:=0
  self.columnTitles:=0
  self.autofit:=0
  self.vertProp:=TRUE
  self.horzProp:=0
  self.scrollRaster:=TRUE
  self.hierarchical:=0
  self.editable:=0

  self.browsernodes:=0
  self.libsused:=[TYPE_LISTBROWSER]
ENDPROC

PROC end() OF listBrowserObject
  END self.colWidths
  END self.colTitles
  Dispose(self.columnInfo)
  freeBrowserNodes( self.browsernodes )
  SUPER self.end()
ENDPROC

EXPORT PROC editSettings() OF listBrowserObject
  DEF editForm:PTR TO listBrowserSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF listBrowserObject IS
[
  makeProp(listObjectId,FIELDTYPE_LONG),
  makeProp(top,FIELDTYPE_INT),
  makeProp(makeVisible,FIELDTYPE_INT),
  makeProp(position,FIELDTYPE_INT),
  makeProp(virtualWidth,FIELDTYPE_INT),
  makeProp(numColumns,FIELDTYPE_INT),
  makeProp(left,FIELDTYPE_INT),
  makeProp(spacing,FIELDTYPE_INT),
  makeProp(selected,FIELDTYPE_INT),
  makeProp(disabled,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(showSelected,FIELDTYPE_CHAR),
  makeProp(multiSelect,FIELDTYPE_CHAR),
  makeProp(separators,FIELDTYPE_CHAR),
  makeProp(vertSeparators,FIELDTYPE_CHAR),
  makeProp(horzSeparators,FIELDTYPE_CHAR),
  makeProp(borderless,FIELDTYPE_CHAR),
  makeProp(columnTitles,FIELDTYPE_CHAR),
  makeProp(autofit,FIELDTYPE_CHAR),
  makeProp(vertProp,FIELDTYPE_CHAR),
  makeProp(horzProp,FIELDTYPE_CHAR),
  makeProp(scrollRaster,FIELDTYPE_CHAR),
  makeProp(hierarchical,FIELDTYPE_CHAR),
  makeProp(editable,FIELDTYPE_CHAR),
  makeProp(colWidths,FIELDTYPE_INTLIST),
  makeProp(colTitles,FIELDTYPE_STRLIST)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF listBrowserObject
  DEF tempStr[200]:STRING
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF self.readOnly THEN srcGen.componentProperty('GA_ReadOnly','TRUE',FALSE)

  IF self.left THEN srcGen.componentPropertyInt('LISTBROWSER_Left',self.left)
  IF self.top THEN srcGen.componentPropertyInt('LISTBROWSER_Top',self.top)
  IF self.makeVisible THEN srcGen.componentPropertyInt('LISTBROWSER_MakeVisible',self.makeVisible)
  srcGen.componentPropertyInt('LISTBROWSER_Position',self.position)
  IF self.virtualWidth THEN srcGen.componentPropertyInt('LISTBROWSER_VirtualWidth',self.virtualWidth)
  IF self.spacing THEN srcGen.componentPropertyInt('LISTBROWSER_Spacing',self.spacing)
  IF self.selected<>-1 THEN srcGen.componentPropertyInt('LISTBROWSER_Selected',self.selected)

  IF self.listObjectId>=0
    StringF(tempStr,'labels\d',self.id)
    srcGen.componentProperty('LISTBROWSER_Labels',tempStr,FALSE)
  ENDIF
  
  IF self.columnTitles
    IF srcGen.type=CSOURCE_GEN
      StringF(tempStr,'&ListBrowser\d_ci',self.id)
    ELSE
      StringF(tempStr,'listBrowser\d_ci',self.id)
    ENDIF
    srcGen.componentProperty('LISTBROWSER_ColumnInfo',tempStr,FALSE)
    srcGen.componentProperty('LISTBROWSER_ColumnTitles','TRUE',FALSE)
  ENDIF

  IF self.showSelected=FALSE THEN srcGen.componentProperty('LISTBROWSER_ShowSelected','FALSE',FALSE)
  IF self.multiSelect THEN srcGen.componentProperty('LISTBROWSER_MultiSelect','TRUE',FALSE)
  IF self.separators=FALSE THEN srcGen.componentProperty('LISTBROWSER_Separators','FALSE',FALSE)
  IF self.vertSeparators=FALSE THEN srcGen.componentProperty('LISTBROWSER_VertSeparators','FALSE',FALSE)
  IF self.horzSeparators THEN srcGen.componentProperty('LISTBROWSER_HorizSeparators','TRUE',FALSE)
  IF self.borderless THEN srcGen.componentProperty('LISTBROWSER_Borderless','TRUE',FALSE)
  IF self.autofit THEN srcGen.componentProperty('LISTBROWSER_AutoFit','TRUE',FALSE)
  IF self.vertProp=FALSE THEN srcGen.componentProperty('LISTBROWSER_VerticalProp','FALSE',FALSE)
  IF self.horzProp THEN srcGen.componentProperty('LISTBROWSER_HorizontalProp','TRUE',FALSE)
  IF self.scrollRaster=FALSE THEN srcGen.componentProperty('LISTBROWSER_ScrollRaster','FALSE',FALSE)
  IF self.hierarchical THEN srcGen.componentProperty('LISTBROWSER_Hierarchical','TRUE',FALSE)
  IF self.editable THEN srcGen.componentProperty('LISTBROWSER_Editable','TRUE',FALSE)

ENDPROC

  ->numColumns:INT
  ->columninfo

EXPORT PROC getTypeName() OF listBrowserObject
  RETURN 'ListBrowser'
ENDPROC

EXPORT PROC createListBrowserObject(parent)
  DEF listb:PTR TO listBrowserObject
  
  NEW listb.create(parent)
ENDPROC listb
