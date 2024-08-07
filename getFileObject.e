OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'gadgets/getfile','getfile',
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

EXPORT ENUM GETFILEGAD_IDENT, GETFILEGAD_NAME, GETFILEGAD_HINT, GETFILEGAD_FILEGADNAME, GETFILEGAD_DRAWERGADNAME, GETFILEGAD_FULLFILENAME,
            GETFILEGAD_PATTERN, GETFILEGAD_REJECTPATTERN, GETFILEGAD_ACCEPTPATTERN,
            GETFILEGAD_LEFT, GETFILEGAD_TOP, GETFILEGAD_WIDTH, GETFILEGAD_HEIGHT, 
            GETFILEGAD_FULLEXPAND, GETFILEGAD_DOSAVEMODE, GETFILEGAD_DOMULTISELECT, GETFILEGAD_DOPATTERNS, 
            GETFILEGAD_DRAWERSONLY, GETFILEGAD_REJECTICONS, GETFILEGAD_FILTERDRAWERS, GETFILEGAD_READONLY, 
            GETFILEGAD_OK, GETFILEGAD_CHILD, GETFILEGAD_CANCEL
      

CONST NUM_GETFILE_GADS=GETFILEGAD_CANCEL+1

EXPORT OBJECT getFileObject OF reactionObject
  fileGadgetName[80]:ARRAY OF CHAR
  drawerGadgetName[80]:ARRAY OF CHAR
  fullFileName[80]:ARRAY OF CHAR
  pattern[80]:ARRAY OF CHAR
  rejectPattern[80]:ARRAY OF CHAR
  acceptPattern[80]:ARRAY OF CHAR
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  fullFileExpand:CHAR
  doSaveMode:CHAR
  doMultiSelect:CHAR
  doPatterns:CHAR
  drawersOnly:CHAR
  rejectIcons:CHAR
  filterDrawers:CHAR
  readOnly:CHAR
ENDOBJECT

OBJECT getFileSettingsForm OF reactionForm
PRIVATE
  getFileObject:PTR TO getFileObject
ENDOBJECT

PROC create() OF getFileSettingsForm
  DEF gads:PTR TO LONG
  DEF arrows,scr:PTR TO screen
  
  NEW gads[NUM_GETFILE_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_GETFILE_GADS]
  self.gadgetActions:=gads
  
  scr:=LockPubScreen(NIL)
  arrows:=(scr.width>=800)
  UnlockPubScreen(NIL,scr)

  self.windowObj:=WindowObject,
    WA_TITLE, 'GetFile Attribute Setting',
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

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_IDENT ]:=StringObject,
          GA_ID, GETFILEGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_NAME ]:=StringObject,
          GA_ID, GETFILEGAD_NAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Label',
        LabelEnd,

       LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_HINT ]:=ButtonObject,
          GA_ID, GETFILEGAD_HINT,
          GA_TEXT, 'Hint',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,         
        CHILD_WEIGHTEDWIDTH,50,            
      LayoutEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_FILEGADNAME ]:=StringObject,
        GA_ID, GETFILEGAD_FILEGADNAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_File Gadget Name',
      LabelEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_DRAWERGADNAME ]:=StringObject,
        GA_ID, GETFILEGAD_DRAWERGADNAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Drawer Gadget Name',
      LabelEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_FULLFILENAME ]:=StringObject,
        GA_ID, GETFILEGAD_FULLFILENAME,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'F_ull File Name',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_PATTERN ]:=StringObject,
          GA_ID, GETFILEGAD_PATTERN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Pattern',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_REJECTPATTERN ]:=StringObject,
          GA_ID, GETFILEGAD_REJECTPATTERN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Reject Pattern',
        LabelEnd,
        
        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_ACCEPTPATTERN ]:=StringObject,
          GA_ID, GETFILEGAD_ACCEPTPATTERN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Accept Pattern',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
      
        LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_LEFT ]:=IntegerObject,
          GA_ID, GETFILEGAD_LEFT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, IF arrows THEN 'Left Edge' ELSE 'Left',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_TOP ]:=IntegerObject,
          GA_ID, GETFILEGAD_TOP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, IF arrows THEN 'Top Edge' ELSE 'Top',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_WIDTH ]:=IntegerObject,
          GA_ID, GETFILEGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXCHARS, 4,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_HEIGHT ]:=IntegerObject,
          GA_ID, GETFILEGAD_HEIGHT,
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

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_FULLEXPAND ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_FULLEXPAND,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'FullFileExpand',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_DOSAVEMODE ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_DOSAVEMODE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoSaveMode',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_DOMULTISELECT ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_DOMULTISELECT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoMultiSelect',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_DOPATTERNS ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_DOPATTERNS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DoPatterns',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_DRAWERSONLY ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_DRAWERSONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DrawersOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_REJECTICONS ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_REJECTICONS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'RejectIcons',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_FILTERDRAWERS ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_FILTERDRAWERS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'FilterDrawers',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ GETFILEGAD_READONLY ]:=CheckBoxObject,
          GA_ID, GETFILEGAD_READONLY,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'ReadOnly',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_OK ]:=ButtonObject,
          GA_ID, GETFILEGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_CHILD ]:=ButtonObject,
          GA_ID, GETFILEGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ GETFILEGAD_CANCEL ]:=ButtonObject,
          GA_ID, GETFILEGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[GETFILEGAD_CHILD]:={editChildSettings}
  self.gadgetActions[GETFILEGAD_HINT]:={editHint}
  self.gadgetActions[GETFILEGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[GETFILEGAD_OK]:=MR_OK
ENDPROC

PROC editHint(nself,gadget,id,code) OF getFileSettingsForm
  self:=nself
  self.setBusy()
  self.getFileObject.editHint()
  self.clearBusy()
  self.updateHint(GETFILEGAD_HINT, self.getFileObject.hintText)
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF getFileSettingsForm
  self:=nself
  self.setBusy()
  self.getFileObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF getFileSettingsForm
  END self.gadgetList[NUM_GETFILE_GADS]
  END self.gadgetActions[NUM_GETFILE_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF getFileSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.getFileObject,GETFILEGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO getFileObject) OF getFileSettingsForm
  DEF res

  self.getFileObject:=comp
  self.updateHint(GETFILEGAD_HINT, comp.hintText)

  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_NAME ],0,0,[STRINGA_TEXTVAL,comp.name,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_FILEGADNAME ],0,0,[STRINGA_TEXTVAL,comp.fileGadgetName,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_DRAWERGADNAME ],0,0,[STRINGA_TEXTVAL,comp.drawerGadgetName,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_FULLFILENAME ],0,0,[STRINGA_TEXTVAL,comp.fullFileName,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_PATTERN ],0,0,[STRINGA_TEXTVAL,comp.pattern,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_REJECTPATTERN ],0,0,[STRINGA_TEXTVAL,comp.rejectPattern,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_ACCEPTPATTERN ],0,0,[STRINGA_TEXTVAL,comp.acceptPattern,0])

  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_LEFT ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_TOP ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])

  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_FULLEXPAND ],0,0,[CHECKBOX_CHECKED,comp.fullFileExpand,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_DOSAVEMODE ],0,0,[CHECKBOX_CHECKED,comp.doSaveMode,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_DOMULTISELECT ],0,0,[CHECKBOX_CHECKED,comp.doMultiSelect,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_DOPATTERNS ],0,0,[CHECKBOX_CHECKED,comp.doPatterns,0]) 

  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_DRAWERSONLY ],0,0,[CHECKBOX_CHECKED,comp.drawersOnly,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_REJECTICONS ],0,0,[CHECKBOX_CHECKED,comp.rejectIcons,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_FILTERDRAWERS ],0,0,[CHECKBOX_CHECKED,comp.filterDrawers,0]) 
  SetGadgetAttrsA(self.gadgetList[ GETFILEGAD_READONLY ],0,0,[CHECKBOX_CHECKED,comp.readOnly,0]) 


  res:=self.showModal()
  IF res=MR_OK
  
  AstrCopy(comp.ident,Gets(self.gadgetList[ GETFILEGAD_IDENT ],STRINGA_TEXTVAL))
  AstrCopy(comp.name,Gets(self.gadgetList[ GETFILEGAD_NAME ],STRINGA_TEXTVAL))
  AstrCopy(comp.fileGadgetName,Gets(self.gadgetList[ GETFILEGAD_FILEGADNAME ],STRINGA_TEXTVAL))
  AstrCopy(comp.drawerGadgetName,Gets(self.gadgetList[ GETFILEGAD_DRAWERGADNAME ],STRINGA_TEXTVAL))
  AstrCopy(comp.fullFileName,Gets(self.gadgetList[ GETFILEGAD_FULLFILENAME ],STRINGA_TEXTVAL))
  AstrCopy(comp.pattern,Gets(self.gadgetList[ GETFILEGAD_PATTERN ],STRINGA_TEXTVAL))
  AstrCopy(comp.rejectPattern,Gets(self.gadgetList[ GETFILEGAD_REJECTPATTERN ],STRINGA_TEXTVAL))
  AstrCopy(comp.acceptPattern,Gets(self.gadgetList[ GETFILEGAD_ACCEPTPATTERN ],STRINGA_TEXTVAL))

  comp.leftEdge:=Gets(self.gadgetList[ GETFILEGAD_LEFT ],INTEGER_NUMBER)
  comp.topEdge:=Gets(self.gadgetList[ GETFILEGAD_TOP ],INTEGER_NUMBER)
  comp.width:=Gets(self.gadgetList[ GETFILEGAD_WIDTH ],INTEGER_NUMBER)
  comp.height:=Gets(self.gadgetList[ GETFILEGAD_HEIGHT ],INTEGER_NUMBER)

  comp.fullFileExpand:=Gets(self.gadgetList[ GETFILEGAD_FULLEXPAND ],CHECKBOX_CHECKED)
  comp.doSaveMode:=Gets(self.gadgetList[ GETFILEGAD_DOSAVEMODE ],CHECKBOX_CHECKED)
  comp.doMultiSelect:=Gets(self.gadgetList[ GETFILEGAD_DOMULTISELECT ],CHECKBOX_CHECKED)
  comp.doPatterns:=Gets(self.gadgetList[ GETFILEGAD_DOPATTERNS ],CHECKBOX_CHECKED)

  comp.drawersOnly:=Gets(self.gadgetList[ GETFILEGAD_DRAWERSONLY ],CHECKBOX_CHECKED)
  comp.rejectIcons:=Gets(self.gadgetList[ GETFILEGAD_REJECTICONS ],CHECKBOX_CHECKED)
  comp.filterDrawers:=Gets(self.gadgetList[ GETFILEGAD_FILTERDRAWERS ],CHECKBOX_CHECKED)
  comp.readOnly:=Gets(self.gadgetList[ GETFILEGAD_READONLY ],CHECKBOX_CHECKED)

  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF getFileObject
  self.previewObject:=GetFileObject,
    GA_ID, self.id,
    GA_RELVERIFY, TRUE,
    GA_TABCYCLE, TRUE,
    GETFILE_READONLY, self.readOnly,
  TAG_DONE])
  
  self.makePreviewChildAttrs(self.name)
ENDPROC

EXPORT PROC create(parent) OF getFileObject
  self.type:=TYPE_GETFILE
  SUPER self.create(parent)

  AstrCopy(self.fileGadgetName,'')
  AstrCopy(self.drawerGadgetName,'')
  AstrCopy(self.fullFileName,'')
  AstrCopy(self.pattern,'')
  AstrCopy(self.rejectPattern,'')
  AstrCopy(self.acceptPattern,'')
  self.leftEdge:=30
  self.topEdge:=20
  self.width:=300
  self.height:=200
  self.fullFileExpand:=TRUE
  self.doSaveMode:=0
  self.doMultiSelect:=0
  self.doPatterns:=0
  self.drawersOnly:=0
  self.rejectIcons:=0
  self.filterDrawers:=0
  self.readOnly:=TRUE

  self.libsused:=[TYPE_GETFILE,TYPE_LABEL]
ENDPROC

EXPORT PROC editSettings() OF getFileObject
  DEF editForm:PTR TO getFileSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF getFileObject IS
[
  makeProp(fileGadgetName,FIELDTYPE_STR),
  makeProp(drawerGadgetName,FIELDTYPE_STR),
  makeProp(fullFileName,FIELDTYPE_STR),
  makeProp(pattern,FIELDTYPE_STR),
  makeProp(rejectPattern,FIELDTYPE_STR),
  makeProp(acceptPattern,FIELDTYPE_STR),
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(fullFileExpand,FIELDTYPE_CHAR),
  makeProp(doSaveMode,FIELDTYPE_CHAR),
  makeProp(doMultiSelect,FIELDTYPE_CHAR),
  makeProp(doPatterns,FIELDTYPE_CHAR),
  makeProp(drawersOnly,FIELDTYPE_CHAR),
  makeProp(rejectIcons,FIELDTYPE_CHAR),
  makeProp(filterDrawers,FIELDTYPE_CHAR),
  makeProp(readOnly,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF getFileObject
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GETFILE_TitleText','Select a file',TRUE)
  IF StrLen(self.fileGadgetName) THEN srcGen.componentProperty('GETFILE_File',self.fileGadgetName,TRUE)
  IF StrLen(self.drawerGadgetName) THEN srcGen.componentProperty('GETFILE_Drawer',self.drawerGadgetName,TRUE)
  IF StrLen(self.fullFileName) THEN srcGen.componentProperty('GETFILE_FullFile',self.fullFileName,TRUE)
  IF (StrLen(self.pattern)>0) AND (StrCmp(self.pattern,'#?')=FALSE) THEN srcGen.componentProperty('GETFILE_Pattern',self.pattern,TRUE)
  IF StrLen(self.rejectPattern) THEN srcGen.componentProperty('GETFILE_RejectPattern',self.rejectPattern,TRUE)
  IF StrLen(self.acceptPattern) THEN srcGen.componentProperty('GETFILE_AcceptPattern',self.acceptPattern,TRUE)
  IF self.leftEdge<>30 THEN srcGen.componentPropertyInt('GETFILE_LeftEdge',self.leftEdge)
  IF self.topEdge<>20 THEN srcGen.componentPropertyInt('GETFILE_TopEdge',self.topEdge)
  IF self.width<>300 THEN srcGen.componentPropertyInt('GETFILE_Width',self.width)
  IF self.height<>200 THEN srcGen.componentPropertyInt('GETFILE_Height',self.height)
  IF self.fullFileExpand=FALSE THEN srcGen.componentProperty('GETFILE_FullFileExpand','FALSE',FALSE)
  IF self.doSaveMode THEN srcGen.componentProperty('GETFILE_DoSaveMode','TRUE',FALSE)
  IF self.doMultiSelect THEN srcGen.componentProperty('GETFILE_DoMultiSelect','TRUE',FALSE)
  IF self.doPatterns THEN srcGen.componentProperty('GETFILE_DoPatterns','TRUE',FALSE)
  IF self.drawersOnly THEN srcGen.componentProperty('GETFILE_DrawersOnly','TRUE',FALSE)
  IF self.rejectIcons THEN srcGen.componentProperty('GETFILE_RejectIcons','TRUE',FALSE)
  IF self.filterDrawers THEN srcGen.componentProperty('GETFILE_FilterDrawers','TRUE',FALSE)
  //this was listed in NDK 3.9 as defaulting to TRUE but in NDK 3.2 as defaulting to FALSE
  srcGen.componentProperty('GETFILE_ReadOnly',IF self.readOnly THEN 'TRUE' ELSE 'FALSE',FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF getFileObject
  srcGen.componentAddChildLabel(self.name)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC getTypeName() OF getFileObject
  RETURN 'GetFile'
ENDPROC

EXPORT PROC getTypeEndName() OF getFileObject
  RETURN 'End'
ENDPROC

EXPORT PROC createGetFileObject(parent)
  DEF getfile:PTR TO getFileObject
  
  NEW getfile.create(parent)
ENDPROC getfile
