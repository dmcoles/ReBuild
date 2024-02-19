OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'chooser','gadgets/chooser',
        'checkbox','gadgets/checkbox',
        'images/bevel',
        'libraries/gadtools',
        'label','images/label',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionForm'

EXPORT ENUM CODEGEN_LABEL, CODEGEN_LANGSELECTOR,CODEGEN_USEIDS, CODEGEN_FULLCODE, CODEGEN_USEMACROS,
              CODEGEN_OK, CODEGEN_CANCEL

CONST NUMGADS=CODEGEN_CANCEL+1

EXPORT OBJECT codeOptions
  langid:CHAR
  useids:CHAR
  fullcode:CHAR
  usemacros:CHAR
  savePath[256]:ARRAY OF CHAR
ENDOBJECT

EXPORT OBJECT codeGenForm OF reactionForm
PRIVATE
  langOptions:PTR TO LONG
  gadIdOptions:PTR TO LONG
  fullCodeOption:PTR TO LONG
  selectedLanguage:LONG
ENDOBJECT

EXPORT PROC create() OF codeGenForm
  DEF gads:PTR TO LONG
  DEF i
  
  NEW gads[NUMGADS]
  self.gadgetList:=gads
  NEW gads[NUMGADS]
  self.gadgetActions:=gads

  self.langOptions:=chooserLabelsA(['E source','C source',0])
  self.gadIdOptions:=chooserLabelsA(['Use ids for GA_ID','Use array index for GA_ID',0])
  self.fullCodeOption:=chooserLabelsA(['Generate full code','Generate definitions only',0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Generate Code',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WA_PUBSCREEN, 0,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
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
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDIMAGE, self.gadgetList[CODEGEN_LABEL]:= LabelObject,
          ->LABEL_DRAWINFO, gDrinfo,
          GA_ID, CODEGEN_LABEL,
          LABEL_TEXT, 'Select code type:',
          LABEL_JUSTIFICATION, LJ_LEFT,
          IA_BGPEN, 0,
          IA_FGPEN, 1,
        LabelEnd,
        CHILD_WEIGHTMINIMUM, TRUE,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, self.gadgetList[ CODEGEN_LANGSELECTOR ]:=ChooserObject,
          GA_ID, CODEGEN_LANGSELECTOR,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,          
          CHOOSER_LABELS, self.langOptions,
        ChooserEnd,

        LAYOUT_ADDIMAGE, LabelObject,
          ->LABEL_DRAWINFO, gDrinfo,
          LABEL_TEXT, 'Gadget ids:',
          LABEL_JUSTIFICATION, LJ_LEFT,
          IA_BGPEN, 0,
          IA_FGPEN, 1,
        LabelEnd,
        CHILD_WEIGHTMINIMUM, TRUE,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, self.gadgetList[ CODEGEN_USEIDS ]:=ChooserObject,
          GA_UNDERSCORE, '#',          
          GA_ID, CODEGEN_USEIDS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,  
          CHOOSER_LABELS, self.gadIdOptions,
        ChooserEnd,

        LAYOUT_ADDIMAGE, LabelObject,
          ->LABEL_DRAWINFO, gDrinfo,
          LABEL_TEXT, 'Generate:',
          LABEL_JUSTIFICATION, LJ_LEFT,
          IA_BGPEN, 0,
          IA_FGPEN, 1,
        LabelEnd,
        CHILD_WEIGHTMINIMUM, TRUE,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, self.gadgetList[ CODEGEN_FULLCODE ]:=ChooserObject,
          GA_ID, CODEGEN_FULLCODE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,  
          CHOOSER_LABELS, self.fullCodeOption,
        ChooserEnd,

        LAYOUT_ADDCHILD, self.gadgetList[CODEGEN_USEMACROS]:=CheckBoxObject,
          GA_ID, CODEGEN_USEMACROS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Use NDK Macros in definitions',
        CheckBoxEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[CODEGEN_OK]:=ButtonObject,
            GA_ID, CODEGEN_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
  
          LAYOUT_ADDCHILD,self.gadgetList[CODEGEN_CANCEL]:=ButtonObject,
            GA_ID, CODEGEN_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd
  self.gadgetActions[CODEGEN_OK]:=MR_OK
  self.gadgetActions[CODEGEN_CANCEL]:=MR_CANCEL
ENDPROC

PROC end() OF codeGenForm
  freeChooserLabels( self.langOptions )
  freeChooserLabels( self.gadIdOptions )
  freeChooserLabels( self.fullCodeOption )
  END self.gadgetList[NUMGADS]
  END self.gadgetActions[NUMGADS]
ENDPROC

EXPORT PROC selectLang(codeOptions:PTR TO codeOptions) OF codeGenForm
  DEF hintInfo:PTR TO hintinfo
  
  hintInfo:=New(SIZEOF hintinfo*7)
  hintInfo[0].gadgetid:=CODEGEN_LANGSELECTOR
  hintInfo[0].code:=-1
  hintInfo[0].flags:=0
  hintInfo[0].text:='Select which language you would like the code generated in'

  hintInfo[1].gadgetid:=CODEGEN_USEIDS
  hintInfo[1].code:=-1
  hintInfo[1].flags:=0
  hintInfo[1].text:='Select whether you want the unique rebuild IDs to be used\nto identifythe gadgets or the array element indexes.'

  hintInfo[2].gadgetid:=CODEGEN_FULLCODE
  hintInfo[2].code:=-1
  hintInfo[2].flags:=0
  hintInfo[2].text:='Generate an entire code snippet including a sample\nmessage processing loop or just the definitions.'

  hintInfo[3].gadgetid:=CODEGEN_USEMACROS
  hintInfo[3].code:=-1
  hintInfo[3].flags:=0
  hintInfo[3].text:='Select whether you want the code to use the NDK\nmacros for the window definitions or not.'

  hintInfo[4].gadgetid:=CODEGEN_OK
  hintInfo[4].code:=-1
  hintInfo[4].flags:=0
  hintInfo[4].text:='Proceed with the code generation'

  hintInfo[5].gadgetid:=CODEGEN_CANCEL
  hintInfo[5].code:=-1
  hintInfo[5].flags:=0
  hintInfo[5].text:='Cancel the code generation'

  Sets(self.windowObj,WINDOW_HINTINFO,hintInfo)
  Sets(self.windowObj,WINDOW_GADGETHELP, TRUE)

  SetGadgetAttrsA(self.gadgetList[ CODEGEN_LANGSELECTOR ],0,0,[CHOOSER_SELECTED,codeOptions.langid,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ CODEGEN_USEIDS ],0,0,[CHOOSER_SELECTED,IF codeOptions.useids THEN 0 ELSE 1,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ CODEGEN_FULLCODE ],0,0,[CHOOSER_SELECTED,IF codeOptions.fullcode THEN 0 ELSE 1,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ CODEGEN_USEMACROS ],0,0,[CHECKBOX_CHECKED,IF codeOptions.usemacros THEN TRUE ELSE FALSE,TAG_END])

  IF self.showModal()=MR_OK
    codeOptions.langid:=Gets(self.gadgetList[ CODEGEN_LANGSELECTOR ],CHOOSER_SELECTED)
    codeOptions.useids:=IF Gets(self.gadgetList[ CODEGEN_USEIDS ],CHOOSER_SELECTED)=0 THEN TRUE ELSE FALSE
    codeOptions.fullcode:=IF Gets(self.gadgetList[ CODEGEN_FULLCODE ],CHOOSER_SELECTED)=0 THEN TRUE ELSE FALSE
    codeOptions.usemacros:=IF Gets(self.gadgetList[ CODEGEN_USEMACROS ],CHECKBOX_CHECKED)=0 THEN FALSE ELSE TRUE
    Dispose(hintInfo)
    RETURN TRUE
  ENDIF
  Dispose(hintInfo)
ENDPROC FALSE


