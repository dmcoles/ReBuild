OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/screens',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen'

EXPORT ENUM LAYOUTGAD_ORIENTATION, LAYOUTGAD_HORZALIGN, LAYOUTGAD_VERTALIGN,
      LAYOUTGAD_EVENSIZE,LAYOUTGAD_SPACEOUTER, LAYOUTGAD_SPACEINNER, LAYOUTGAD_DEFERLAYOUT,
      LAYOUTGAD_BEVELSTYLE,LAYOUTGAD_BEVELSTATE,
      LAYOUTGAD_LEFTSPACING,LAYOUTGAD_RIGHTSPACING,LAYOUTGAD_TOPSPACING,LAYOUTGAD_BOTTOMSPACING,
      LAYOUTGAD_LABEL,LAYOUTGAD_LABELPLACE,
      LAYOUTGAD_FIXEDHORIZ,LAYOUTGAD_FIXEDVERT,LAYOUTGAD_SHRINKWRAP,
      LAYOUTGAD_OK, LAYOUTGAD_CHILD, LAYOUTGAD_CANCEL
      

CONST NUM_LAYOUT_GADS=LAYOUTGAD_CANCEL+1

EXPORT OBJECT layoutObject OF reactionObject
  orientation:CHAR
  horizAlignment:CHAR
  vertAlignment:CHAR
  bevelStyle:CHAR
  bevelState:CHAR
  leftSpacing:INT
  rightSpacing:INT
  topSpacing:INT
  bottomSpacing:INT
  label[80]:ARRAY OF CHAR
  labelPlace:CHAR
  fixedHoriz:CHAR
  fixedVert:CHAR
  shrinkWrap:CHAR
  evenSize:CHAR
  spaceOuter:CHAR
  spaceInner:CHAR
  deferLayout:CHAR
ENDOBJECT

EXPORT PROC createPreviewObject(scr) OF layoutObject

  self.previewObject:=LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE, ->self.deferLayout,
        LAYOUT_SPACEINNER, self.spaceInner,
        LAYOUT_SPACEOUTER, self.spaceOuter,
        LAYOUT_TOPSPACING, self.topSpacing,
        LAYOUT_LEFTSPACING, self.leftSpacing,
        LAYOUT_RIGHTSPACING, self.rightSpacing,
        LAYOUT_BOTTOMSPACING, self.bottomSpacing,
        LAYOUT_ORIENTATION, ListItem([LAYOUT_ORIENT_HORIZ,LAYOUT_ORIENT_VERT],self.orientation),
        LAYOUT_HORIZALIGNMENT, ListItem([LALIGN_LEFT, LALIGN_RIGHT],self.horizAlignment),
        LAYOUT_VERTALIGNMENT, ListItem([LALIGN_TOP, LALIGN_BOTTOM],self.vertAlignment),
        LAYOUT_BEVELSTYLE, ListItem([BVS_NONE, BVS_THIN, BVS_BUTTON, BVS_GROUP, BVS_FIELD, BVS_DROPBOX, BVS_SBAR_HORIZ,BVS_SBAR_VERT,BVS_BOX,BVS_RADIOBUTTON,BVS_STANDARD],self.bevelStyle),
        LAYOUT_BEVELSTATE, ListItem([IDS_NORMAL,IDS_SELECTED,IDS_DISABLED],self.bevelState),
        LAYOUT_LABEL,self.label,
        LAYOUT_LABELPLACE, ListItem([BVJ_TOP_CENTER, BVJ_TOP_LEFT, BVJ_TOP_RIGHT, BVJ_IN_CENTER, BVJ_IN_LEFT, BVJ_IN_RIGHT],self.labelPlace),
        LAYOUT_FIXEDHORIZ, self.fixedHoriz,
        LAYOUT_FIXEDVERT, self.fixedVert,
        LAYOUT_SHRINKWRAP, self.shrinkWrap,
        LAYOUT_EVENSIZE, self.evenSize,
      LayoutEnd

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

EXPORT PROC create(parent) OF layoutObject
  DEF tempStr[80]:STRING
  self.type:=TYPE_LAYOUT
  SUPER self.create(parent)
  StringF(tempStr,'Vert_\d',self.id)
  AstrCopy(self.name,tempStr,80)
  self.orientation:=1
  self.horizAlignment:=0
  self.vertAlignment:=0
  self.bevelStyle:=0
  self.bevelState:=0
  self.leftSpacing:=0
  self.rightSpacing:=0
  self.topSpacing:=0
  self.bottomSpacing:=0
  AstrCopy(self.label,'')
  self.labelPlace:=0
  self.fixedHoriz:=TRUE
  self.fixedVert:=TRUE
  self.shrinkWrap:=0
  self.evenSize:=0
  self.spaceOuter:=0
  self.spaceInner:=TRUE
  self.deferLayout:=0
ENDPROC

OBJECT layoutSettingsForm OF reactionForm
  layoutObject:PTR TO layoutObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
  labels3:PTR TO LONG
  labels4:PTR TO LONG
  labels5:PTR TO LONG
ENDOBJECT

PROC create() OF layoutSettingsForm
  DEF gads:PTR TO LONG
  DEF arrows,scr:PTR TO screen
 
  NEW gads[NUM_LAYOUT_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_LAYOUT_GADS]
  self.gadgetActions:=gads
  
  scr:=LockPubScreen(NIL)
  arrows:=FALSE->(scr.width>=800)
  UnlockPubScreen(NIL,scr)

  self.windowObj:=WindowObject,
    WA_TITLE, 'Window Layout Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, CHIGAD_MINHEIGHT,
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

      LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_ORIENTATION ]:=ChooserObject,
        GA_ID, LAYOUTGAD_ORIENTATION,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        CHOOSER_POPUP, TRUE,
        CHOOSER_MAXLABELS, 12,
        CHOOSER_ACTIVE, 0,
        CHOOSER_WIDTH, -1,
        CHOOSER_LABELS, self.labels1:=chooserLabelsA(['LAYOUT_ORIENT_HORIZ', 'LAYOUT_ORIENT_VERT',0]),
      ChooserEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Orientation',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_HORZALIGN ]:=ChooserObject,
          GA_ID, LAYOUTGAD_HORZALIGN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['LALIGN_LEFT', 'LALIGN_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'HorzAlignment',
        LabelEnd,
        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_VERTALIGN ]:=ChooserObject,
          GA_ID, LAYOUTGAD_VERTALIGN,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels3:=chooserLabelsA(['LALIGN_TOP', 'LALIGN_BOTTOM',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'VertAlignment',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_BEVELSTYLE ]:=ChooserObject,
          GA_ID, LAYOUTGAD_BEVELSTYLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels2:=chooserLabelsA(['BVS_NONE', 'BVS_THIN', 'BVS_BUTTON', 'BVS_GROUP','BVS_FIELD','BVS_DROPBOX','BVS_SBAR_HORIZ','BVS_SBAR_VERT','BVS_BOX','BVS_RADIOBUTTON','BVS_STANDARD',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'BevelStyle',
        LabelEnd,
        
        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_BEVELSTATE ]:=ChooserObject,
          GA_ID, LAYOUTGAD_BEVELSTATE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels3:=chooserLabelsA(['IDS_NORMAL', 'IDS_SELECTED','IDS_DISABLED',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'BevelState',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LAYOUTGAD_LEFTSPACING ]:=IntegerObject,
          GA_ID, LAYOUTGAD_LEFTSPACING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 2,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 99,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_LSpacing',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LAYOUTGAD_RIGHTSPACING ]:=IntegerObject,
          GA_ID, LAYOUTGAD_RIGHTSPACING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 2,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 99,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_RSpacing',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LAYOUTGAD_TOPSPACING ]:=IntegerObject,
          GA_ID, LAYOUTGAD_TOPSPACING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 2,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 99,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'TS_pacing',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LAYOUTGAD_BOTTOMSPACING ]:=IntegerObject,
          GA_ID, LAYOUTGAD_BOTTOMSPACING,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 2,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 99,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_BSpacing',
        LabelEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_LABEL ]:=StringObject,
          GA_ID, LAYOUTGAD_LABEL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Layout Label',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_LABELPLACE ]:=ChooserObject,
          GA_ID, LAYOUTGAD_LABELPLACE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels4:=chooserLabelsA(['BVJ_TOP_CENTER', 'BVJ_TOP_LEFT', 'BVJ_TOP_RIGHT', 'BVJ_IN_CENTER', 'BVJ_IN_LEFT', 'BVJ_IN_RIGHT',0]),
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'L_abelPlace',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_FIXEDHORIZ ]:=CheckBoxObject,
          GA_ID, LAYOUTGAD_FIXEDHORIZ,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'F_ixedHoriz',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_FIXEDVERT ]:=CheckBoxObject,
          GA_ID, LAYOUTGAD_FIXEDVERT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'FixedV_ert',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_SHRINKWRAP ]:=CheckBoxObject,
          GA_ID, LAYOUTGAD_SHRINKWRAP,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Shrink_Wrap',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

      LayoutEnd,
      
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_EVENSIZE ]:=CheckBoxObject,
          GA_ID, LAYOUTGAD_EVENSIZE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'EvenSize',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_SPACEOUTER ]:=CheckBoxObject,
          GA_ID, LAYOUTGAD_SPACEOUTER,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'SpaceOuter',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_SPACEINNER ]:=CheckBoxObject,
          GA_ID, LAYOUTGAD_SPACEINNER,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'SpaceInner',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LAYOUTGAD_DEFERLAYOUT ]:=CheckBoxObject,
          GA_ID, LAYOUTGAD_DEFERLAYOUT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'DeferLayout',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LAYOUTGAD_OK ]:=ButtonObject,
          GA_ID, LAYOUTGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LAYOUTGAD_CHILD ]:=ButtonObject,
          GA_ID, LAYOUTGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LAYOUTGAD_CANCEL ]:=ButtonObject,
          GA_ID, LAYOUTGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[LAYOUTGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[LAYOUTGAD_CHILD]:={editChildSettings}
  self.gadgetActions[LAYOUTGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF layoutSettingsForm
  self:=nself
  self.setBusy()
  self.layoutObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF layoutSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )
  freeChooserLabels( self.labels3 )
  freeChooserLabels( self.labels4 )
  freeChooserLabels( self.labels5 )

  END self.gadgetList[NUM_LAYOUT_GADS]
  END self.gadgetActions[NUM_LAYOUT_GADS]
ENDPROC

PROC editSettings(comp:PTR TO layoutObject) OF layoutSettingsForm
  DEF tempStr[80]:STRING
  DEF res
 
  self.layoutObject:=comp
  
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_ORIENTATION ],0,0,[CHOOSER_SELECTED,comp.orientation,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_HORZALIGN ],0,0,[CHOOSER_SELECTED,comp.horizAlignment,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_VERTALIGN ],0,0,[CHOOSER_SELECTED,comp.vertAlignment,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_BEVELSTYLE ],0,0,[CHOOSER_SELECTED,comp.bevelStyle,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_BEVELSTATE ],0,0,[CHOOSER_SELECTED,comp.bevelState,0]) 

  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_LEFTSPACING ],0,0,[INTEGER_NUMBER,comp.leftSpacing,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_RIGHTSPACING ],0,0,[INTEGER_NUMBER,comp.rightSpacing,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_TOPSPACING ],0,0,[INTEGER_NUMBER,comp.topSpacing,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_BOTTOMSPACING ],0,0,[INTEGER_NUMBER,comp.bottomSpacing,0]) 

  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_LABEL ],0,0,[STRINGA_TEXTVAL,comp.label,0])
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_LABELPLACE ],0,0,[CHOOSER_SELECTED,comp.labelPlace,0]) 

  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_FIXEDHORIZ ],0,0,[CHECKBOX_CHECKED,comp.fixedHoriz,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_FIXEDVERT ],0,0,[CHECKBOX_CHECKED,comp.fixedVert,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_SHRINKWRAP ],0,0,[CHECKBOX_CHECKED,comp.shrinkWrap,0]) 

  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_EVENSIZE  ],0,0,[CHECKBOX_CHECKED,comp.evenSize,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_SPACEOUTER  ],0,0,[CHECKBOX_CHECKED,comp.spaceOuter,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_SPACEINNER  ],0,0,[CHECKBOX_CHECKED,comp.spaceInner,0]) 
  SetGadgetAttrsA(self.gadgetList[ LAYOUTGAD_DEFERLAYOUT  ],0,0,[CHECKBOX_CHECKED,comp.deferLayout,0]) 

  res:=self.showModal()
  IF res=MR_OK

    comp.orientation:=Gets(self.gadgetList[ LAYOUTGAD_ORIENTATION ],CHOOSER_SELECTED)
    comp.horizAlignment:=Gets(self.gadgetList[ LAYOUTGAD_HORZALIGN ],CHOOSER_SELECTED)
    comp.vertAlignment:=Gets(self.gadgetList[ LAYOUTGAD_VERTALIGN ],CHOOSER_SELECTED)
    comp.bevelStyle:=Gets(self.gadgetList[ LAYOUTGAD_BEVELSTYLE ],CHOOSER_SELECTED)
    comp.bevelState:=Gets(self.gadgetList[ LAYOUTGAD_BEVELSTATE ],CHOOSER_SELECTED)

    comp.leftSpacing:=Gets(self.gadgetList[ LAYOUTGAD_LEFTSPACING ],INTEGER_NUMBER)
    comp.rightSpacing:=Gets(self.gadgetList[ LAYOUTGAD_RIGHTSPACING ],INTEGER_NUMBER)
    comp.topSpacing:=Gets(self.gadgetList[ LAYOUTGAD_TOPSPACING ],INTEGER_NUMBER)
    comp.bottomSpacing:=Gets(self.gadgetList[ LAYOUTGAD_BOTTOMSPACING ],INTEGER_NUMBER)

    AstrCopy(comp.label,Gets(self.gadgetList[ LAYOUTGAD_LABEL ],STRINGA_TEXTVAL))
    comp.labelPlace:=Gets(self.gadgetList[ LAYOUTGAD_LABELPLACE ],CHOOSER_SELECTED)

    comp.fixedHoriz:=Gets(self.gadgetList[ LAYOUTGAD_FIXEDHORIZ ],CHECKBOX_CHECKED)
    comp.fixedVert:=Gets(self.gadgetList[ LAYOUTGAD_FIXEDVERT ],CHECKBOX_CHECKED)
    comp.shrinkWrap:=Gets(self.gadgetList[ LAYOUTGAD_SHRINKWRAP ],CHECKBOX_CHECKED)

    comp.evenSize:=Gets(self.gadgetList[ LAYOUTGAD_EVENSIZE ],CHECKBOX_CHECKED)
    comp.spaceOuter:=Gets(self.gadgetList[ LAYOUTGAD_SPACEOUTER ],CHECKBOX_CHECKED)
    comp.spaceInner:=Gets(self.gadgetList[ LAYOUTGAD_SPACEINNER ],CHECKBOX_CHECKED)
    comp.deferLayout:=Gets(self.gadgetList[ LAYOUTGAD_DEFERLAYOUT ],CHECKBOX_CHECKED)
    StringF(tempStr,'\s_\d',IF comp.orientation THEN 'Vert' ELSE 'Horiz',comp.id)
    AstrCopy(comp.name,tempStr,80)

  ENDIF
ENDPROC res=MR_OK

EXPORT PROC editSettings() OF layoutObject
  DEF editForm:PTR TO layoutSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF layoutObject
  RETURN 'Layout'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF layoutObject IS
[
  makeProp(orientation,FIELDTYPE_CHAR),
  makeProp(horizAlignment,FIELDTYPE_CHAR),
  makeProp(vertAlignment,FIELDTYPE_CHAR),
  makeProp(bevelStyle,FIELDTYPE_CHAR),
  makeProp(bevelState,FIELDTYPE_CHAR),
  makeProp(leftSpacing,FIELDTYPE_INT),
  makeProp(rightSpacing,FIELDTYPE_INT),
  makeProp(topSpacing,FIELDTYPE_INT),
  makeProp(bottomSpacing,FIELDTYPE_INT),
  makeProp(label,FIELDTYPE_STR),
  makeProp(labelPlace,FIELDTYPE_CHAR),
  makeProp(fixedHoriz,FIELDTYPE_CHAR),
  makeProp(fixedVert,FIELDTYPE_CHAR),
  makeProp(shrinkWrap,FIELDTYPE_CHAR),
  makeProp(evenSize,FIELDTYPE_CHAR),
  makeProp(spaceOuter,FIELDTYPE_CHAR),
  makeProp(spaceInner,FIELDTYPE_CHAR),
  makeProp(deferLayout,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF layoutObject
  DEF tempStr[100]:STRING

  IF self.orientation
    srcGen.componentProperty('LAYOUT_Orientation','LAYOUT_ORIENT_VERT',FALSE)
  ELSE
    srcGen.componentProperty('LAYOUT_Orientation','LAYOUT_ORIENT_HORIZ',FALSE)
  ENDIF

  IF self.horizAlignment
    srcGen.componentProperty('LAYOUT_HorizAlignment','LALIGN_RIGHT',FALSE)
  ENDIF

  IF self.vertAlignment
    srcGen.componentProperty('LAYOUT_VertAlignment','LALIGN_BOTTOM',FALSE)
  ENDIF

  IF self.bevelStyle
    srcGen.componentProperty('LAYOUT_BevelStyle',ListItem(['BVS_NONE', 'BVS_THIN', 'BVS_BUTTON', 'BVS_GROUP', 'BVS_FIELD', 'BVS_DROPBOX', 'BVS_SBAR_HORIZ','BVS_SBAR_VERT','BVS_BOX','BVS_RADIOBUTTON','BVS_STANDARD'],self.bevelStyle),FALSE)
  ENDIF

  IF self.bevelState 
    srcGen.componentProperty('LAYOUT_BevelState',ListItem(['IDS_NORMAL','IDS_SELECTED','IDS_DISABLED'],self.bevelState),FALSE)
  ENDIF

  IF self.spaceOuter THEN srcGen.componentProperty('LAYOUT_SpaceOuter','TRUE',FALSE)

  IF self.spaceInner=FALSE THEN srcGen.componentProperty('LAYOUT_SpaceInner','FALSE',FALSE)

  IF self.leftSpacing
    StringF(tempStr,'\d',self.leftSpacing)
    srcGen.componentProperty('LAYOUT_LeftSpacing',tempStr,FALSE)
  ENDIF

  IF self.rightSpacing
    StringF(tempStr,'\d',self.rightSpacing)
    srcGen.componentProperty('LAYOUT_RightSpacing',tempStr,FALSE)
  ENDIF

  IF self.topSpacing
    StringF(tempStr,'\d',self.topSpacing)
    srcGen.componentProperty('LAYOUT_TopSpacing',tempStr,FALSE)
  ENDIF

  IF self.bottomSpacing
    StringF(tempStr,'\d',self.bottomSpacing)
    srcGen.componentProperty('LAYOUT_BottomSpacing',tempStr,FALSE)
  ENDIF

  IF StrLen(self.label) THEN srcGen.componentProperty('LAYOUT_Label',self.label,TRUE)

  IF self.labelPlace THEN srcGen.componentProperty('LAYOUT_LabelPlace', ListItem(['BVJ_TOP_CENTER', 'BVJ_TOP_LEFT', 'BVJ_TOP_RIGHT', 'BVJ_IN_CENTER', 'BVJ_IN_LEFT', 'BVJ_IN_RIGHT'],self.labelPlace),FALSE)

  IF self.fixedHoriz=FALSE THEN srcGen.componentProperty('LAYOUT_FixedHoriz','FALSE',FALSE)
  
  IF self.fixedVert=FALSE THEN srcGen.componentProperty('LAYOUT_FixedVert','FALSE',FALSE)

  IF self.shrinkWrap THEN srcGen.componentProperty('LAYOUT_ShrinkWrap','TRUE',FALSE)

  IF self.evenSize  THEN srcGen.componentProperty('LAYOUT_EvenSize','TRUE',FALSE)

  IF self.deferLayout THEN srcGen.componentProperty('LAYOUT_DeferLayout','TRUE',FALSE)
ENDPROC

EXPORT PROC allowChildren() OF layoutObject IS -1

EXPORT PROC addChildTag() OF layoutObject IS LAYOUT_ADDCHILD

EXPORT PROC removeChildTag() OF layoutObject IS LAYOUT_REMOVECHILD

EXPORT PROC addImageTag() OF layoutObject IS LAYOUT_ADDIMAGE

EXPORT PROC addChildTo() OF layoutObject IS self.previewObject

EXPORT PROC createLayoutObject(parent)
  DEF layout:PTR TO layoutObject
  
  NEW layout.create(parent)
ENDPROC layout
