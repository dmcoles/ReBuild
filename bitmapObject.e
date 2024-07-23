OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'bitmap','images/bitmap',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'gadgets/getfile','getfile',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen','*validator'

EXPORT DEF errorState

EXPORT ENUM BITMAPGAD_IDENT, BITMAPGAD_LABEL, BITMAPGAD_LEFTEDGE, BITMAPGAD_TOPEDGE,
            BITMAPGAD_WIDTH, BITMAPGAD_HEIGHT, BITMAPGAD_SOURCEFILE, BITMAPGAD_MASKING, 
      BITMAPGAD_OK, BITMAPGAD_CHILD, BITMAPGAD_CANCEL

CONST NUM_BITMAP_GADS=BITMAPGAD_CANCEL+1

EXPORT OBJECT bitmapObject OF reactionObject
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  sourceFile[255]:ARRAY OF CHAR
  masking:CHAR
ENDOBJECT

OBJECT bitmapSettingsForm OF reactionForm
PRIVATE
  bitmapObject:PTR TO bitmapObject
ENDOBJECT

PROC create() OF bitmapSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_BITMAP_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_BITMAP_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Bitmap Attribute Setting',
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

      LAYOUT_ADDCHILD, self.gadgetList[ BITMAPGAD_IDENT ]:=StringObject,
        GA_ID, BITMAPGAD_IDENT,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Identifier',
      LabelEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ BITMAPGAD_LABEL ]:=StringObject,
        GA_ID, BITMAPGAD_LABEL,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Label',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_LEFTEDGE ]:=IntegerObject,
          GA_ID, BITMAPGAD_LEFTEDGE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_LeftEdge',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_TOPEDGE ]:=IntegerObject,
          GA_ID, BITMAPGAD_TOPEDGE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Top_Edge',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_WIDTH ]:=IntegerObject,
          GA_ID, BITMAPGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_HEIGHT ]:=IntegerObject,
          GA_ID, BITMAPGAD_HEIGHT,
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

      LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_SOURCEFILE ]:=GetFileObject,
        GA_ID, BITMAPGAD_SOURCEFILE, 
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GETFILE_TITLETEXT, 'Select your image file',
        GETFILE_READONLY, FALSE,
      TAG_DONE]),

      LAYOUT_ADDCHILD, self.gadgetList[ BITMAPGAD_MASKING ]:=CheckBoxObject,
        GA_ID, BITMAPGAD_MASKING,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_TEXT, 'Masking',
        CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
      CheckBoxEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_OK ]:=ButtonObject,
          GA_ID, BITMAPGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_CHILD ]:=ButtonObject,
          GA_ID, BITMAPGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ BITMAPGAD_CANCEL ]:=ButtonObject,
          GA_ID, BITMAPGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[BITMAPGAD_CHILD]:={editChildSettings}
  self.gadgetActions[BITMAPGAD_SOURCEFILE]:={triggerFileSelect}
  self.gadgetActions[BITMAPGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[BITMAPGAD_OK]:=MR_OK
ENDPROC

PROC triggerFileSelect(nself,gadget,id,code) OF bitmapSettingsForm
  DEF win
  self:=nself
  
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  
  gfRequestFile(self.gadgetList[BITMAPGAD_SOURCEFILE],win)
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF bitmapSettingsForm
  self:=nself
  self.setBusy()
  self.bitmapObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF bitmapSettingsForm
  END self.gadgetList[NUM_BITMAP_GADS]
  END self.gadgetActions[NUM_BITMAP_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF bitmapSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.bitmapObject,BITMAPGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO bitmapObject) OF bitmapSettingsForm
  DEF res

  self.bitmapObject:=comp

  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_LABEL ],0,0,[STRINGA_TEXTVAL,comp.label,0])
  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_SOURCEFILE ],0,0,[GETFILE_FULLFILE,comp.sourceFile,0])
  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_LEFTEDGE ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_TOPEDGE ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])
  SetGadgetAttrsA(self.gadgetList[ BITMAPGAD_MASKING  ],0,0,[CHECKBOX_CHECKED,comp.masking,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ BITMAPGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.label,Gets(self.gadgetList[ BITMAPGAD_LABEL ],STRINGA_TEXTVAL))
    AstrCopy(comp.sourceFile,Gets(self.gadgetList[ BITMAPGAD_SOURCEFILE ],GETFILE_FULLFILE),255)
    comp.leftEdge:=Gets(self.gadgetList[ BITMAPGAD_LEFTEDGE ],INTEGER_NUMBER)
    comp.topEdge:=Gets(self.gadgetList[ BITMAPGAD_TOPEDGE ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ BITMAPGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ BITMAPGAD_HEIGHT ],INTEGER_NUMBER)
    comp.masking:=Gets(self.gadgetList[ BITMAPGAD_MASKING ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF bitmapObject
    self.previewObject:=BitMapObject,
        IA_LEFT, self.leftEdge,
        IA_TOP, self.topEdge,
        IA_WIDTH, self.width,
        IA_HEIGHT, self.height,
        BITMAP_MASKING, self.masking,
        BITMAP_SOURCEFILE, self.sourceFile,
        BITMAP_SCREEN, scr,
        ->LABEL_DRAWINFO, self.drawInfo,
      BitMapEnd

  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)
  errorState:=FALSE

  self.makePreviewChildAttrs(0)
ENDPROC

EXPORT PROC create(parent) OF bitmapObject
  self.type:=TYPE_BITMAP
  SUPER self.create(parent)
  self.leftEdge:=0
  self.topEdge:=0
  self.width:=0
  self.height:=0
  self.masking:=FALSE
  AstrCopy(self.sourceFile,'')
  self.libsused:=[TYPE_BITMAP]
ENDPROC

EXPORT PROC editSettings() OF bitmapObject
  DEF editForm:PTR TO bitmapSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF bitmapObject IS
[
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(sourceFile,FIELDTYPE_STR),
  makeProp(masking,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF bitmapObject

  srcGen.componentPropertyInt('IA_Left',self.leftEdge)
  srcGen.componentPropertyInt('IA_Top',self.topEdge)
  srcGen.componentPropertyInt('IA_Width',self.width)
  srcGen.componentPropertyInt('IA_Height',self.height)

  srcGen.componentProperty('BITMAP_Screen','gScreen',FALSE) 
  srcGen.componentProperty('BITMAP_SourceFile',self.sourceFile,TRUE)
  IF self.masking THEN srcGen.componentProperty('BITMAP_Masking','TRUE',FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF bitmapObject
  srcGen.componentAddChildLabel(self.label)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC getTypeName() OF bitmapObject
  RETURN 'BitMap'
ENDPROC

EXPORT PROC isImage() OF bitmapObject IS TRUE

EXPORT PROC createBitmapObject(parent)
  DEF bitmap:PTR TO bitmapObject
  
  NEW bitmap.create(parent)
ENDPROC bitmap
