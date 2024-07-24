OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string','gadgets/string',
        'texteditor','gadgets/texteditor',
        '*textfield',
        'chooser','gadgets/chooser',
        'gadgets/checkbox','checkbox',
        'gadgets/listbrowser','listbrowser',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec/lists','exec/nodes',
        'requester','classes/requester'

  MODULE '*reactionObject','*reactionForm','*stringlist','*baseStreamer','*validator'

CONST TEXTFIELD_TEXT=$84000001
CONST TEXTFIELD_BORDER_BEVEL=1
CONST TEXTFIELD_BORDER=$8400000C
CONST TEXTFIELD_SIZE=$84000007
CONST TEXTFIELD_READONLY=$8400001F

EXPORT DEF texteditorbase

EXPORT ENUM REQITEMGAD_TYPE, REQITEMGAD_IDENT, REQITEMGAD_TITLEPARAM, REQITEMGAD_TITLE,REQITEMGAD_GADTEXTPARAM, REQITEMGAD_GADTEXT,REQITEMGAD_IMAGE,REQITEMGAD_BODYPARAM, REQITEMGAD_BODY,
      REQITEMGAD_OK, REQITEMGAD_TEST, REQITEMGAD_CANCEL 

CONST NUM_REQITEM_GADS=REQITEMGAD_CANCEL+1

EXPORT OBJECT requesterItemObject OF reactionObject
  reqType:CHAR
  titleParam:CHAR
  gadgetsParam:CHAR
  bodyParam:CHAR
  titleText[80]:ARRAY OF CHAR
  gadgetsText[80]:ARRAY OF CHAR
  image:CHAR
  bodyText:PTR TO stringlist
ENDOBJECT

EXPORT OBJECT requesterItemSettingsForm OF reactionForm
PRIVATE
  typeLabels
  imageLabels
  requesterItem:PTR TO requesterItemObject
ENDOBJECT

PROC create(parent) OF requesterItemObject
  DEF strlist:PTR TO stringlist

  self.type:=TYPE_REQUESTER_ITEM
  SUPER self.create(parent)

  self.reqType:=0
  self.image:=0
  AstrCopy(self.titleText,'')
  AstrCopy(self.gadgetsText,'')
  self.titleParam:=0
  self.gadgetsParam:=0
  self.bodyParam:=0
  NEW strlist.stringlist(10)
  self.bodyText:=strlist
ENDPROC

PROC end() OF requesterItemObject
  END self.bodyText
ENDPROC

PROC create() OF requesterItemSettingsForm
  DEF gads:PTR TO LONG
  DEF tempbase=0

  NEW gads[NUM_REQITEM_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_REQITEM_GADS]
  self.gadgetActions:=gads

  IF texteditorbase
    tempbase:=textfieldbase
    textfieldbase:=texteditorbase

    self.gadgetList[ REQITEMGAD_BODY ]:=NewObjectA( TextEditor_GetClass(), NIL,[
        GA_ID, REQITEMGAD_BODY,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_READONLY, FALSE,
      TAG_END])
  ELSE
    self.gadgetList[ REQITEMGAD_BODY ]:=NewObjectA( TextField_GetClass(), NIL,[
        GA_ID, REQITEMGAD_BODY,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_READONLY, FALSE,
        TEXTFIELD_BORDER, TEXTFIELD_BORDER_BEVEL,
      TAG_END])
  ENDIF

  self.typeLabels:=chooserLabelsA(['Info','Integer','String',0])
  self.imageLabels:=chooserLabelsA(['Default','Info','Warning','Error','Question','Insert Disk',0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Requester Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 220,
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

        LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_TYPE]:=ChooserObject,
          GA_ID, REQITEMGAD_TYPE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_SELECTED, 0,
          CHOOSER_LABELS, self.typeLabels,
        ChooserEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Type',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ REQITEMGAD_IDENT ]:=StringObject,
          GA_ID, REQITEMGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ REQITEMGAD_TITLEPARAM ]:=CheckBoxObject,
          GA_ID, REQITEMGAD_TITLEPARAM,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Parameterised title',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ REQITEMGAD_GADTEXTPARAM ]:=CheckBoxObject,
          GA_ID, REQITEMGAD_GADTEXTPARAM,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Parameterised gadgets',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
        
        LAYOUT_ADDCHILD, self.gadgetList[ REQITEMGAD_BODYPARAM ]:=CheckBoxObject,
          GA_ID, REQITEMGAD_BODYPARAM,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Parameterised body',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_TITLE]:=StringObject,
          GA_ID, REQITEMGAD_TITLE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Title Text',
        LabelEnd,
        LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_GADTEXT]:=StringObject,
          GA_ID, REQITEMGAD_GADTEXT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Gadget Text',
        LabelEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
      LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_IMAGE]:=ChooserObject,
        GA_ID, REQITEMGAD_IMAGE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        CHOOSER_POPUP, TRUE,
        CHOOSER_SELECTED, 0,
        CHOOSER_LABELS, self.imageLabels,
      ChooserEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Image',
      LabelEnd,
      LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_BODY],
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Body Text',
      LabelEnd,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_OK]:=ButtonObject,
          GA_ID, REQITEMGAD_OK,
          GA_TEXT, 'Ok',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_TEST]:=ButtonObject,
          GA_ID, REQITEMGAD_TEST,
          GA_TEXT, 'Test',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_CANCEL]:=ButtonObject,
          GA_ID, REQITEMGAD_CANCEL,
          GA_TEXT, 'Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[REQITEMGAD_TITLEPARAM]:={updateTitleParam}
  self.gadgetActions[REQITEMGAD_GADTEXTPARAM]:={updateGadgetsParam}
  self.gadgetActions[REQITEMGAD_BODYPARAM]:={updateBodyParam}
  self.gadgetActions[REQITEMGAD_TEST]:={testRequester}
  self.gadgetActions[REQITEMGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[REQITEMGAD_OK]:=MR_OK
  
  IF tempbase THEN textfieldbase:=tempbase
ENDPROC

PROC updateTitleParam(nself,gadget,id,code) OF requesterItemSettingsForm
  DEF win
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW) 
  SetGadgetAttrsA(self.gadgetList[REQITEMGAD_TITLE],win,0,[GA_DISABLED, code<>0, TAG_END])
ENDPROC

PROC updateGadgetsParam(nself,gadget,id,code) OF requesterItemSettingsForm
  DEF win
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW) 
  SetGadgetAttrsA(self.gadgetList[REQITEMGAD_GADTEXT],win,0,[GA_DISABLED, code<>0, TAG_END])
ENDPROC

PROC updateBodyParam(nself,gadget,id,code) OF requesterItemSettingsForm
  DEF win
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW) 
  SetGadgetAttrsA(self.gadgetList[REQITEMGAD_BODY],win,0,[GA_DISABLED, code<>0, TAG_END])
ENDPROC

PROC testRequester(nself,gadget,id,code) OF requesterItemSettingsForm
  DEF reqmsg:PTR TO orrequest
  DEF reqobj,win
  DEF res=0,strval,vallen
  DEF type,titleText,gadText,bodyText,image

  SUBA.L #$100,A7
  self:=nself

  win:=Gets(self.windowObj,WINDOW_WINDOW)
  
  type:=Gets(self.gadgetList[ REQITEMGAD_TYPE ],CHOOSER_SELECTED)
  titleText:=Gets(self.gadgetList[ REQITEMGAD_TITLE ],STRINGA_TEXTVAL)
  gadText:=Gets(self.gadgetList[ REQITEMGAD_GADTEXT ],STRINGA_TEXTVAL)

  IF texteditorbase
    bodyText:=DoMethod(self.gadgetList[ REQITEMGAD_BODY ], GM_TEXTEDITOR_EXPORTTEXT)
  ELSE
    SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODY ],0,0,[TEXTFIELD_READONLY,TRUE,0])
    vallen:=Gets(self.gadgetList[ REQITEMGAD_BODY ], TEXTFIELD_SIZE)
    strval:=Gets(self.gadgetList[ REQITEMGAD_BODY ], TEXTFIELD_TEXT)
    bodyText:=AllocVec(vallen+1,0)
    IF (vallen<>0) AND (strval<>0)
      CopyMem(strval,bodyText,vallen)
    ENDIF
    bodyText[vallen]:=0
    SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODY ],0,0,[TEXTFIELD_READONLY,FALSE,0])
  ENDIF
  image:=Gets(self.gadgetList[ REQITEMGAD_IMAGE ],CHOOSER_SELECTED)

  IF Gets(self.gadgetList[ REQITEMGAD_TITLEPARAM ],CHECKBOX_CHECKED)
    titleText:='titleParam'
  ENDIF

  IF Gets(self.gadgetList[ REQITEMGAD_GADTEXTPARAM ],CHECKBOX_CHECKED)
    gadText:='gadgetsParam'
  ENDIF

  IF Gets(self.gadgetList[ REQITEMGAD_BODYPARAM ],CHECKBOX_CHECKED)
    bodyText:='bodyParam'
  ENDIF

  type:=ListItem([REQTYPE_INFO, REQTYPE_INTEGER, REQTYPE_STRING],type)
  image:=ListItem([REQIMAGE_DEFAULT, REQIMAGE_INFO, REQIMAGE_WARNING, REQIMAGE_ERROR, REQIMAGE_QUESTION, REQIMAGE_INSERTDISK],image)

  NEW reqmsg
  reqmsg.methodid:=RM_OPENREQ
  reqmsg.window:=win
  reqmsg.attrs:=[REQ_TYPE, type, REQ_IMAGE, image, REQ_TITLETEXT,titleText,REQ_BODYTEXT,bodyText,REQ_GADGETTEXT,gadText,TAG_END]
  reqobj:=NewObjectA(Requester_GetClass(),0,[TAG_END])
  IF reqobj
    res:=DoMethodA(reqobj, reqmsg)
    DisposeObject(reqobj)
  ENDIF
  END reqmsg
  IF Gets(self.gadgetList[ REQITEMGAD_BODYPARAM ],CHECKBOX_CHECKED)=FALSE
    FreeVec(bodyText)
  ENDIF
  ADD.L #$100,A7
  
ENDPROC

PROC end() OF requesterItemSettingsForm
  IF self.typeLabels THEN freeChooserLabels(self.typeLabels)
  IF self.imageLabels THEN freeChooserLabels(self.imageLabels)
  END self.gadgetList[NUM_REQITEM_GADS]
  END self.gadgetActions[NUM_REQITEM_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF requesterItemSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.requesterItem,REQITEMGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(reqItem:PTR TO requesterItemObject) OF requesterItemSettingsForm
  DEF res,bodyText,strval,vallen

  self.requesterItem:=reqItem
  
  SetGadgetAttrsA(self.gadgetList[REQITEMGAD_TITLE],0,0,[GA_DISABLED, reqItem.titleParam<>0, TAG_END])
  SetGadgetAttrsA(self.gadgetList[REQITEMGAD_GADTEXT],0,0,[GA_DISABLED, reqItem.gadgetsParam<>0, TAG_END])
  SetGadgetAttrsA(self.gadgetList[REQITEMGAD_BODY],0,0,[GA_DISABLED, reqItem.bodyParam<>0, TAG_END])

  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_IDENT ],0,0,[STRINGA_TEXTVAL,reqItem.ident,0])
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_TYPE ],0,0,[CHOOSER_SELECTED,reqItem.reqType,0]) 
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_TITLE ],0,0,[STRINGA_TEXTVAL,reqItem.titleText,0])
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_GADTEXT ],0,0,[STRINGA_TEXTVAL,reqItem.gadgetsText,0])
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_TITLEPARAM ],0,0,[CHECKBOX_CHECKED,reqItem.titleParam,0])
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_GADTEXTPARAM ],0,0,[CHECKBOX_CHECKED,reqItem.gadgetsParam,0])
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODYPARAM ],0,0,[CHECKBOX_CHECKED,reqItem.bodyParam,0])
  
  bodyText:=reqItem.bodyText.makeTextString()

  IF texteditorbase
    SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODY ],0,0,[GA_TEXTEDITOR_CONTENTS, bodyText,0])
  ELSE
    SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODY ],0,0,[TEXTFIELD_TEXT,bodyText,0])
  ENDIF

  DisposeLink(bodyText)
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_IMAGE ],0,0,[CHOOSER_SELECTED,reqItem.image,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(reqItem.ident,Gets(self.gadgetList[ REQITEMGAD_IDENT ],STRINGA_TEXTVAL),80)
    reqItem.reqType:=Gets(self.gadgetList[ REQITEMGAD_TYPE ],CHOOSER_SELECTED)
    AstrCopy(reqItem.titleText,Gets(self.gadgetList[ REQITEMGAD_TITLE ],STRINGA_TEXTVAL),80)
    AstrCopy(reqItem.gadgetsText,Gets(self.gadgetList[ REQITEMGAD_GADTEXT ],STRINGA_TEXTVAL),80)
    reqItem.titleParam:=Gets(self.gadgetList[ REQITEMGAD_TITLEPARAM ],CHECKBOX_CHECKED)
    reqItem.gadgetsParam:=Gets(self.gadgetList[ REQITEMGAD_GADTEXTPARAM ],CHECKBOX_CHECKED)
    reqItem.bodyParam:=Gets(self.gadgetList[ REQITEMGAD_BODYPARAM ],CHECKBOX_CHECKED)

    IF texteditorbase   
      bodyText:=DoMethod(self.gadgetList[ REQITEMGAD_BODY ], GM_TEXTEDITOR_EXPORTTEXT)
    ELSE
      SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODY ],0,0,[TEXTFIELD_READONLY,TRUE,0])
      vallen:=Gets(self.gadgetList[ REQITEMGAD_BODY ], TEXTFIELD_SIZE)
      strval:=Gets(self.gadgetList[ REQITEMGAD_BODY ], TEXTFIELD_TEXT)
      bodyText:=AllocVec(vallen+1,0)
      IF (vallen<>0) AND (strval<>0)
        CopyMem(strval,bodyText,vallen)
      ENDIF
      bodyText[vallen]:=0
      SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODY ],0,0,[TEXTFIELD_READONLY,FALSE,0])    
    ENDIF

    reqItem.bodyText.setFromTextString(bodyText)
    FreeVec(bodyText)
    reqItem.image:=Gets(self.gadgetList[ REQITEMGAD_IMAGE ],CHOOSER_SELECTED)

  ENDIF
ENDPROC res=MR_OK

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC getTypeName() OF requesterItemObject
  RETURN 'Requester'
ENDPROC

EXPORT PROC serialiseData() OF requesterItemObject IS
[
  makeProp(reqType,FIELDTYPE_CHAR),
  makeProp(titleParam,FIELDTYPE_CHAR),
  makeProp(gadgetsParam,FIELDTYPE_CHAR),
  makeProp(bodyParam,FIELDTYPE_CHAR),
  makeProp(titleText,FIELDTYPE_STR),
  makeProp(gadgetsText,FIELDTYPE_STR),
  makeProp(image,FIELDTYPE_CHAR),
  makeProp(bodyText,FIELDTYPE_STRLIST)
]

EXPORT PROC editSettings() OF requesterItemObject
  DEF editForm:PTR TO requesterItemSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC createRequesterItemObject(parent)
  DEF requesterItem:PTR TO requesterItemObject
  
  NEW requesterItem.create(parent)
ENDPROC requesterItem


