OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/datebrowser','datebrowser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourcegen'

EXPORT ENUM DATEGAD_MULTISELECT,DATEGAD_SHOWTITLE,DATEGAD_READONLY,DATEGAD_DISABLED,
      DATEGAD_OK, DATEGAD_CHILD, DATEGAD_CANCEL
      

CONST NUM_DATE_GADS=DATEGAD_CANCEL+1

EXPORT OBJECT dateBrowserObject OF reactionObject
  multiSelect:CHAR
  showTitle:CHAR
  readOnly:CHAR
  disabled:CHAR
ENDOBJECT

OBJECT dateBrowserSettingsForm OF reactionForm
PRIVATE
  dateBrowserObject:PTR TO dateBrowserObject
ENDOBJECT

PROC create() OF dateBrowserSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_DATE_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_DATE_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'DateBrowser Attribute Setting',
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
        LAYOUT_SPACEINNER, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ DATEGAD_MULTISELECT ]:=CheckBoxObject,
          GA_ID, DATEGAD_MULTISELECT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Multi-select',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ DATEGAD_SHOWTITLE ]:=CheckBoxObject,
          GA_ID, DATEGAD_SHOWTITLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Show Title',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_SPACEINNER, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[ DATEGAD_READONLY ]:=CheckBoxObject,
          GA_ID, DATEGAD_READONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Read Only',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ DATEGAD_DISABLED ]:=CheckBoxObject,
          GA_ID, DATEGAD_DISABLED,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Disabled',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ DATEGAD_OK ]:=ButtonObject,
          GA_ID, DATEGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DATEGAD_CHILD ]:=ButtonObject,
          GA_ID, DATEGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DATEGAD_CANCEL ]:=ButtonObject,
          GA_ID, DATEGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[DATEGAD_CHILD]:={editChildSettings}
  self.gadgetActions[DATEGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[DATEGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF dateBrowserSettingsForm
  self:=nself
  self.setBusy()
  self.dateBrowserObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF dateBrowserSettingsForm

  END self.gadgetList[NUM_DATE_GADS]
  END self.gadgetActions[NUM_DATE_GADS]
ENDPROC

PROC editSettings(comp:PTR TO dateBrowserObject) OF dateBrowserSettingsForm
  DEF res

  self.dateBrowserObject:=comp
  
  SetGadgetAttrsA(self.gadgetList[ DATEGAD_MULTISELECT ],0,0,[CHECKBOX_CHECKED,comp.multiSelect,0]) 
  SetGadgetAttrsA(self.gadgetList[ DATEGAD_SHOWTITLE ],0,0,[CHECKBOX_CHECKED,comp.showTitle,0]) 
  SetGadgetAttrsA(self.gadgetList[ DATEGAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ DATEGAD_DISABLED ],0,0,[CHECKBOX_CHECKED,comp.disabled,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.multiSelect:=Gets(self.gadgetList[ DATEGAD_MULTISELECT ],CHECKBOX_CHECKED)   
    comp.showTitle:=Gets(self.gadgetList[ DATEGAD_SHOWTITLE ],CHECKBOX_CHECKED)   
    comp.readOnly:=Gets(self.gadgetList[ DATEGAD_READONLY ],CHECKBOX_CHECKED)   
    comp.disabled:=Gets(self.gadgetList[ DATEGAD_DISABLED ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF dateBrowserObject
  self.previewObject:=NewObjectA(DateBrowser_GetClass(), NIL,[TAG_IGNORE,0,
      GA_RELVERIFY, TRUE,
      GA_TABCYCLE, TRUE,
      GA_DISABLED, self.disabled,
      GA_READONLY, self.readOnly,
      DATEBROWSER_MULTISELECT, self.multiSelect,
      DATEBROWSER_SHOWTITLE, self.showTitle,
    TAG_DONE])
        
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

EXPORT PROC create(parent) OF dateBrowserObject
  self.type:=TYPE_DATEBROWSER
  SUPER self.create(parent)
  self.multiSelect:=0
  self.showTitle:=0
  self.readOnly:=0
  self.disabled:=0
  self.libsused:=[TYPE_DATEBROWSER]
ENDPROC

EXPORT PROC editSettings() OF dateBrowserObject
  DEF editForm:PTR TO dateBrowserSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF dateBrowserObject
  RETURN 'DateBrowser'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF dateBrowserObject IS
[
  makeProp(multiSelect,FIELDTYPE_CHAR),
  makeProp(showTitle,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR),
  makeProp(disabled,FIELDTYPE_CHAR)

]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF dateBrowserObject
  srcGen.componentPropertyInt('GA_ID',self.id)
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.disabled THEN srcGen.componentProperty('GA_Disabled','TRUE',FALSE)
  IF self.readOnly THEN srcGen.componentProperty('GA_ReadOnly','TRUE',FALSE)
  IF self.multiSelect THEN srcGen.componentProperty('DATEBROWSR_MultiSelect','TRUE',FALSE)
  IF self.showTitle THEN srcGen.componentProperty('DATEBROWSER_ShowTitle','TRUE',FALSE)
ENDPROC

EXPORT PROC libTypeCreate() OF dateBrowserObject IS 'DateBrowser_GetClass()'

EXPORT PROC getTypeEndName() OF dateBrowserObject
  RETURN 'End'
ENDPROC

EXPORT PROC createDateBrowserObject(parent)
  DEF dateBrowser:PTR TO dateBrowserObject
  
  NEW dateBrowser.create(parent)
ENDPROC dateBrowser


