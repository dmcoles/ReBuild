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
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*sourceGen'

EXPORT ENUM SCRGAD_PUBLIC, SCRGAD_CUSTOM, SCRGAD_AUTOSCROLL, SCRGAD_TITLE, SCRGAD_PUBLICNAME,
      SCRGAD_LEFTEDGE, SCRGAD_TOPEDGE, SCRGAD_WIDTH, SCRGAD_HEIGHT, SCRGAD_DEPTH,
      SCRGAD_OVERSCANTYPE, SCRGAD_DISPLAYID,
      SCRGAD_OK, SCRGAD_CANCEL

CONST NUM_SCR_GADS=SCRGAD_CANCEL+1

EXPORT OBJECT screenObject OF reactionObject
  public:CHAR
  custom:CHAR
  autoScroll:CHAR
  title[80]:ARRAY OF CHAR
  publicname[80]:ARRAY OF CHAR
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  depth:INT
  overscanType:CHAR
  displayID:CHAR
ENDOBJECT

OBJECT screenSettingsForm OF reactionForm
PRIVATE
  screenObject:PTR TO screenObject
  labels1:PTR TO LONG
  labels2:PTR TO LONG
ENDOBJECT

PROC create() OF screenSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_SCR_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_SCR_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Screen Attribute Setting',
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
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ SCRGAD_PUBLIC ]:=CheckBoxObject,
            GA_ID, SCRGAD_PUBLIC,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_Public Screen',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ SCRGAD_CUSTOM ]:=CheckBoxObject,
            GA_ID, SCRGAD_CUSTOM,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'Custo_m Screen',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ SCRGAD_AUTOSCROLL ]:=CheckBoxObject,
            GA_ID, SCRGAD_AUTOSCROLL,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_AutoScroll',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SCRGAD_TITLE ]:=StringObject,
          GA_ID, SCRGAD_TITLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_DISABLED, TRUE, 
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Screen _Title',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ SCRGAD_PUBLICNAME ]:=StringObject,
          GA_ID, SCRGAD_PUBLICNAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_DISABLED, TRUE, 
          STRINGA_MAXCHARS, 80,
        StringEnd,

        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Public screen _Name',
        LabelEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCRGAD_LEFTEDGE ]:=IntegerObject,
            GA_ID, SCRGAD_LEFTEDGE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_LeftEdge',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCRGAD_TOPEDGE ]:=IntegerObject,
            GA_ID, SCRGAD_TOPEDGE,
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

          LAYOUT_ADDCHILD,  self.gadgetList[ SCRGAD_WIDTH ]:=IntegerObject,
            GA_ID, SCRGAD_WIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Width',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCRGAD_HEIGHT ]:=IntegerObject,
            GA_ID, SCRGAD_HEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Height',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCRGAD_DEPTH ]:=IntegerObject,
            GA_ID, SCRGAD_DEPTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 2,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 24,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, '_Depth',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ SCRGAD_OVERSCANTYPE ]:=ChooserObject,
            GA_ID, SCRGAD_OVERSCANTYPE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels1:=chooserLabelsA(['OSCAN_TEXT', 'OSCAN_STANDARD', 'OSCAN_MAX', 'OSCAN_VIDEO',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'Over_ScanType',
          LabelEnd,


          LAYOUT_ADDCHILD, self.gadgetList[ SCRGAD_DISPLAYID ]:=ChooserObject,
            GA_ID, SCRGAD_DISPLAYID,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            CHOOSER_POPUP, TRUE,
            CHOOSER_MAXLABELS, 12,
            CHOOSER_ACTIVE, 0,
            CHOOSER_WIDTH, -1,
            CHOOSER_LABELS, self.labels2:=chooserLabelsA(['LORES_KEY','HIRES_KEY','SUPER_KEY','HAM_KEY','LORESLACE_KEY',
              'HIRESLACE_KEY','SUPERLACE_KEY','HAMLACE_KEY','EXTRAHALFBRITE_KEY','EXTRAHALFBRITELACE_KEY',
              'HIRESHAM_KEY','SUPERHAM_KEY','HIRESEHB_KEY','SUPEREHB_KEY','HIRESHAMLACE_KEY','SUPERHAMLACE_KEY',
              'HIRESEHBLACE_KEY','SUPEREHBLACE_KEY','LORESDBL_KEY','LORESHAMDBL_KEY','LORESEHBDBL_KEY','HIRESHAMDBL_KEY',
              'VGAEXTRALORES_KEY','VGALORES_KEY','VGAPRODUCT_KEY','VGAHAM_KEY','VGAEXTRALORESLACE_KEY',
              'VGALORESLACE_KEY','VGAPRODUCTLACE_KEY','VGAHAMLACE_KEY','VGAPRODUCTHAM_KEY','VGALORESHAM_KEY',
              'VGAEXTRALORESHAM_KEY','VGAPRODUCTHAMLACE_KEY',0]),
          ChooserEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'DisplayID',
          LabelEnd,
        LayoutEnd,
    
 
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCRGAD_OK ]:=ButtonObject,
            GA_ID, SCRGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ SCRGAD_CANCEL ]:=ButtonObject,
            GA_ID, SCRGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[SCRGAD_PUBLIC]:={update}
  self.gadgetActions[SCRGAD_CUSTOM]:={update}
  self.gadgetActions[SCRGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[SCRGAD_OK]:=MR_OK
ENDPROC

PROC end() OF screenSettingsForm
  freeChooserLabels( self.labels1 )
  freeChooserLabels( self.labels2 )

  END self.gadgetList[NUM_SCR_GADS]
  END self.gadgetActions[NUM_SCR_GADS]
ENDPROC

PROC update(nself,gadget,id,code) OF screenSettingsForm
  DEF win
  DEF custom
  DEF public

  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  
  custom:=Gets(self.gadgetList[ SCRGAD_CUSTOM ],CHECKBOX_CHECKED)
  public:=Gets(self.gadgetList[ SCRGAD_PUBLIC ],CHECKBOX_CHECKED)

  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_TITLE ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_TITLE ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_PUBLICNAME ],0,0,[GA_DISABLED,public=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_PUBLICNAME ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_LEFTEDGE ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_LEFTEDGE ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_TOPEDGE ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_TOPEDGE ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_WIDTH ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_WIDTH ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_HEIGHT ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_HEIGHT ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_DEPTH ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_DEPTH ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_OVERSCANTYPE ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN  RefreshGList(self.gadgetList[ SCRGAD_OVERSCANTYPE ], win,0,1)
  IF SetGadgetAttrsA(self.gadgetList[ SCRGAD_DISPLAYID ],0,0,[GA_DISABLED,custom=FALSE,0]) THEN IF win THEN RefreshGList(self.gadgetList[ SCRGAD_DISPLAYID ], win,0,1)
ENDPROC

PROC editSettings(comp:PTR TO screenObject) OF screenSettingsForm
  DEF res

  self.screenObject:=comp
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_PUBLIC ],0,0,[CHECKBOX_CHECKED,comp.public,0]) 
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_CUSTOM ],0,0,[CHECKBOX_CHECKED,comp.custom,0]) 
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_AUTOSCROLL ],0,0,[CHECKBOX_CHECKED,comp.autoScroll,0]) 
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_TITLE ],0,0,[STRINGA_TEXTVAL,comp.title,0])
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_PUBLICNAME ],0,0,[STRINGA_TEXTVAL,comp.publicname,0])
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_LEFTEDGE ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_TOPEDGE ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_DEPTH ],0,0,[INTEGER_NUMBER,comp.depth,0])
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_OVERSCANTYPE ],0,0,[CHOOSER_SELECTED,comp.overscanType,0]) 
  SetGadgetAttrsA(self.gadgetList[ SCRGAD_DISPLAYID ],0,0,[CHOOSER_SELECTED,comp.displayID,0]) 
  self.update(self,0,0,0)

  res:=self.showModal()
  IF res=MR_OK
    comp.public:=Gets(self.gadgetList[ SCRGAD_PUBLIC ],CHECKBOX_CHECKED)
    comp.custom:=Gets(self.gadgetList[ SCRGAD_CUSTOM ],CHECKBOX_CHECKED)
    comp.autoScroll:=Gets(self.gadgetList[ SCRGAD_AUTOSCROLL ],CHECKBOX_CHECKED)
    AstrCopy(comp.title,Gets(self.gadgetList[ SCRGAD_TITLE ],STRINGA_TEXTVAL))
    AstrCopy(comp.publicname,Gets(self.gadgetList[ SCRGAD_PUBLICNAME ],STRINGA_TEXTVAL))
    comp.leftEdge:=Gets(self.gadgetList[ SCRGAD_LEFTEDGE ],INTEGER_NUMBER)
    comp.topEdge:=Gets(self.gadgetList[ SCRGAD_TOPEDGE ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ SCRGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ SCRGAD_HEIGHT ],INTEGER_NUMBER)
    comp.depth:=Gets(self.gadgetList[ SCRGAD_DEPTH ],INTEGER_NUMBER)
    comp.overscanType:=Gets(self.gadgetList[ SCRGAD_OVERSCANTYPE ],CHOOSER_SELECTED)
    comp.displayID:=Gets(self.gadgetList[ SCRGAD_DISPLAYID ],CHOOSER_SELECTED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC create(parent) OF screenObject
  self.type:=TYPE_SCREEN
  SUPER self.create(parent)
  AstrCopy(self.name,'')
  
  self.public:=FALSE
  self.custom:=FALSE
  self.autoScroll:=FALSE
  AstrCopy(self.title,'My Screen Title')
  AstrCopy(self.publicname,'')
  self.leftEdge:=0
  self.topEdge:=0
  self.width:=640
  self.height:=200
  self.depth:=2
  self.overscanType:=0
  self.displayID:=0
  self.previewObject:=0
  self.previewChildAttrs:=0
ENDPROC

EXPORT PROC editSettings() OF screenObject
  DEF editForm:PTR TO screenSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF screenObject
  RETURN 'Screen'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF screenObject IS
[
  makeProp(public,FIELDTYPE_CHAR),
  makeProp(custom,FIELDTYPE_CHAR),
  makeProp(autoScroll,FIELDTYPE_CHAR),
  makeProp(title,FIELDTYPE_STR),
  makeProp(publicname,FIELDTYPE_STR),
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(depth,FIELDTYPE_INT),
  makeProp(overscanType,FIELDTYPE_CHAR),
  makeProp(displayID,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF screenObject
  DEF tempStr[100]:STRING

  IF self.custom
    srcGen.componentPropertyInt('SA_Left',self.leftEdge)
    srcGen.componentPropertyInt('SA_Top',self.topEdge)
    srcGen.componentPropertyInt('SA_Width',self.width)
    srcGen.componentPropertyInt('SA_Height',self.height)
    srcGen.componentPropertyInt('SA_Depth',self.depth)
    srcGen.componentProperty('SA_Title',self.title, TRUE)
    srcGen.componentProperty('SA_Type','CUSTOMSCREEN', FALSE)
    srcGen.componentProperty('SA_AutoScroll',IF self.autoScroll THEN 'TRUE' ELSE 'FALSE', FALSE)
    IF (self.public=TRUE) AND (StrLen(self.publicname)>0)
      srcGen.componentProperty('SA_PubName',self.publicname, TRUE)
    ENDIF
    srcGen.componentProperty('SA_Overscan',ListItem(['OSCAN_TEXT', 'OSCAN_STANDARD', 'OSCAN_MAX', 'OSCAN_VIDEO'],self.overscanType),FALSE)
    srcGen.componentProperty('SA_DisplayID',ListItem(
        ['LORES_KEY','HIRES_KEY','SUPER_KEY','HAM_KEY','LORESLACE_KEY',
              'HIRESLACE_KEY','SUPERLACE_KEY','HAMLACE_KEY','EXTRAHALFBRITE_KEY','EXTRAHALFBRITELACE_KEY',
              'HIRESHAM_KEY','SUPERHAM_KEY','HIRESEHB_KEY','SUPEREHB_KEY','HIRESHAMLACE_KEY','SUPERHAMLACE_KEY',
              'HIRESEHBLACE_KEY','SUPEREHBLACE_KEY','LORESDBL_KEY','LORESHAMDBL_KEY','LORESEHBDBL_KEY','HIRESHAMDBL_KEY',
              'VGAEXTRALORES_KEY','VGALORES_KEY','VGAPRODUCT_KEY','VGAHAM_KEY','VGAEXTRALORESLACE_KEY',
              'VGALORESLACE_KEY','VGAPRODUCTLACE_KEY','VGAHAMLACE_KEY','VGAPRODUCTHAM_KEY','VGALORESHAM_KEY',
              'VGAEXTRALORESHAM_KEY','VGAPRODUCTHAMLACE_KEY'],self.displayID),FALSE)
  ENDIF  
ENDPROC

EXPORT PROC createScreenObject(parent)
  DEF screen:PTR TO screenObject
  
  NEW screen.create(parent)
ENDPROC screen
