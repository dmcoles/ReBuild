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
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*listPicker','*stringlist','*reactionListObject','*reactionLists','*sourceGen'

EXPORT ENUM LISTBGAD_LISTSELECT, LISTBGAD_COLUMNSBUTTON,
      LISTBGAD_TOP, LISTBGAD_MAKEVISIBLE,
      LISTBGAD_POSITION, LISTBGAD_VIRTUALWIDTH, LISTBGAD_NUMCOLS,
      LISTBGAD_LEFT, LISTBGAD_SPACING, LISTBGAD_SELECTED,
      LISTBGAD_DISABLED, LISTBGAD_READONLY, LISTBGAD_SHOWSELECTED, LISTBGAD_MULTISELECT,
      LISTBGAD_SEPARATOR, LISTBGAD_VSEPARATOR, LISTBGAD_HSEPARATOR, LISTBGAD_BORDERLESS,
      LISTBGAD_COLUMNTITLES, LISTBGAD_AUTOFIT, LISTBGAD_VPROP, LISTBGAD_HPROP,
      LISTBGAD_SCROLLRAST, LISTBGAD_HIERARCHICAL, LISTBGAD_EDITABLE,
      LISTBGAD_OK, LISTBGAD_CHILD, LISTBGAD_CANCEL

CONST NUM_LISTB_GADS=LISTBGAD_CANCEL+1

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

  columnInfo:PTR TO columninfo
  browsernodes:PTR TO LONG
ENDOBJECT

OBJECT listBrowserSettingsForm OF reactionForm
  listBrowserObject:PTR TO listBrowserObject
  colTitles:PTR TO stringlist
  colWidths:PTR TO stdlist
  selectedListId:LONG
ENDOBJECT

OBJECT editColumnsForm OF reactionForm
  count:LONG
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
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_SHRINKWRAP, TRUE,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,
          
          LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_LISTSELECT ]:=ButtonObject,
            GA_ID, LISTBGAD_LISTSELECT,
            GA_TEXT, '_Pick a List',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_COLUMNSBUTTON ]:=ButtonObject,
            GA_ID, LISTBGAD_COLUMNSBUTTON,
            GA_TEXT, 'Edit Columns',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

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
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

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
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

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
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_DISABLED ]:=CheckBoxObject,
            GA_ID, LISTBGAD_DISABLED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Disabled',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_READONLY ]:=CheckBoxObject,
            GA_ID, LISTBGAD_READONLY,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_ReadOnly',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_SHOWSELECTED ]:=CheckBoxObject,
            GA_ID, LISTBGAD_SHOWSELECTED,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_ShowSelected',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_MULTISELECT ]:=CheckBoxObject,
            GA_ID, LISTBGAD_MULTISELECT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_MultiSelect',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_SEPARATOR ]:=CheckBoxObject,
            GA_ID, LISTBGAD_SEPARATOR,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Sep_arators',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_VSEPARATOR ]:=CheckBoxObject,
            GA_ID, LISTBGAD_VSEPARATOR,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'VertSeparators',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_HSEPARATOR ]:=CheckBoxObject,
            GA_ID, LISTBGAD_HSEPARATOR,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'HorizSeparators',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_BORDERLESS ]:=CheckBoxObject,
            GA_ID, LISTBGAD_BORDERLESS,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Borderless',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_COLUMNTITLES ]:=CheckBoxObject,
            GA_ID, LISTBGAD_COLUMNTITLES,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Col_umnTitles',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_AUTOFIT ]:=CheckBoxObject,
            GA_ID, LISTBGAD_AUTOFIT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'AutoFit',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_VPROP ]:=CheckBoxObject,
            GA_ID, LISTBGAD_VPROP,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'VerticalProp',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_HPROP ]:=CheckBoxObject,
            GA_ID, LISTBGAD_HPROP,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'HorizontalProp',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_SCROLLRAST ]:=CheckBoxObject,
            GA_ID, LISTBGAD_SCROLLRAST,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'ScrollRaster',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_HIERARCHICAL ]:=CheckBoxObject,
            GA_ID, LISTBGAD_HIERARCHICAL,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Hierarchical',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ LISTBGAD_EDITABLE ]:=CheckBoxObject,
            GA_ID, LISTBGAD_EDITABLE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Editable',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_OK ]:=ButtonObject,
            GA_ID, LISTBGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_CHILD ]:=ButtonObject,
            GA_ID, LISTBGAD_CHILD,
            GA_TEXT, 'C_hild',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ LISTBGAD_CANCEL ]:=ButtonObject,
            GA_ID, LISTBGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,
        LayoutEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[LISTBGAD_LISTSELECT]:={selectList}
  self.gadgetActions[LISTBGAD_CHILD]:={editChildSettings}
  self.gadgetActions[LISTBGAD_COLUMNTITLES]:={colTitles}
  self.gadgetActions[LISTBGAD_COLUMNSBUTTON]:={editColumns}
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

PROC editSettings(comp:PTR TO listBrowserObject) OF listBrowserSettingsForm
  DEF res

  self.listBrowserObject:=comp
  self.selectedListId:=comp.listObjectId
  self.colTitles:=comp.colTitles
  self.colWidths:=comp.colWidths

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
  DEF n,i,newLayout

  DEF rootLayout
  
  NEW gads[(count+1)*2]
  self.gadgetList:=gads
  NEW gads[(count+1)*2]
  self.gadgetActions:=gads
  self.count:=count

  self.windowObj:=WindowObject,
    WA_TITLE, 'Set ListBrowser Columns',
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
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_SHRINKWRAP, TRUE,

        LAYOUT_ADDCHILD, rootLayout:=LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ 0 ]:=ButtonObject,
            GA_ID, 0,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ 1 ]:=ButtonObject,
            GA_ID, 1,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  n:=2
  FOR i:=0 TO count-1
    newLayout:=
        LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,
          
          LAYOUT_ADDCHILD, self.gadgetList[ n ]:=IntegerObject,
              GA_ID, n++,
              GA_RELVERIFY, TRUE,
              GA_TABCYCLE, TRUE,
              INTEGER_MINIMUM, 0,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Column Width',
          LabelEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ n ]:=StringObject,
            GA_ID, n++,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            STRINGA_TEXTVAL, '',
            STRINGA_MAXCHARS, 80,
          StringEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Column Title',
          LabelEnd,
        LayoutEnd

    SetGadgetAttrsA(rootLayout,0,0,[LAYOUT_ADDCHILD, newLayout,  TAG_END])
  ENDFOR

  self.gadgetActions[1]:=MR_CANCEL
  self.gadgetActions[0]:=MR_OK
ENDPROC

PROC editColumns(titles:PTR TO stringlist, widths:PTR TO stdlist) OF editColumnsForm
  DEF i,res
  
  FOR i:=0 TO self.count-1
    IF i<titles.count()
      SetGadgetAttrsA(self.gadgetList[ ((i+1)<<1)+1 ],0,0,[STRINGA_TEXTVAL,titles.item(i),0])
    ELSE
      SetGadgetAttrsA(self.gadgetList[ ((i+1)<<1)+1],0,0,[STRINGA_TEXTVAL,'',0])
    ENDIF

    IF i<widths.count()
      SetGadgetAttrsA(self.gadgetList[ (i+1)<<1 ],0,0,[INTEGER_NUMBER,widths.item(i),0])
    ELSE
      SetGadgetAttrsA(self.gadgetList[ (i+1)<<1 ],0,0,[INTEGER_NUMBER,1,0])
    ENDIF
  ENDFOR
  
  res:=self.showModal()
  IF res=MR_OK
    WriteF('count=\d\n',self.count)
    FOR i:=0 TO self.count-1
    
      titles.setItem(i,Gets(self.gadgetList[ ((i+1) << 1)+1 ],STRINGA_TEXTVAL))
      WriteF('title[\d]=\s\n',i,titles.item(i))
      widths.setItem(i,Gets(self.gadgetList[ (i+1) << 1 ],INTEGER_NUMBER))
      WriteF('width[\d]=\d\n',i,widths.item(i))
    ENDFOR
  ENDIF
ENDPROC res=MR_OK

PROC makeBrowserList(id) OF listBrowserObject
  DEF i
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
    ListAddItem(newlist,0)
  ELSE
    newlist:=[0]
  ENDIF
ENDPROC browserNodesA(newlist)

EXPORT PROC createPreviewObject() OF listBrowserObject
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
  self.libused:=LIB_LISTB
ENDPROC

PROC end() OF listBrowserObject
  END self.colWidths
  END self.colTitles
  Dispose(self.columnInfo)
  freeBrowserNodes( self.browsernodes )
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
  srcGen.componentPropertyInt('GA_ID',self.id)
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

  IF self.listObjectId 
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
