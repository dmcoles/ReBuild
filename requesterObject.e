OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string','gadgets/string',
        'texteditor','gadgets/texteditor',
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

  MODULE '*reactionObject','*reactionForm','*sourcegen','*validator','*stringlist','*fileStreamer'

EXPORT DEF texteditorbase

EXPORT ENUM REQITEMGAD_TYPE, REQITEMGAD_TITLE,REQITEMGAD_GADTEXT,REQITEMGAD_IMAGE,REQITEMGAD_BODY,
      REQITEMGAD_OK, REQITEMGAD_TEST, REQITEMGAD_CANCEL
      

CONST NUM_REQITEM_GADS=REQITEMGAD_CANCEL+1

EXPORT ENUM REQGAD_LIST, REQGAD_ADD, REQGAD_EDIT, REQGAD_DELETE, REQGAD_OK, REQGAD_CANCEL
CONST NUM_REQ_GADS=REQGAD_CANCEL+1

EXPORT OBJECT requesterItem
  reqType:CHAR
  titleText[80]:ARRAY OF CHAR
  gadgetsText[80]:ARRAY OF CHAR
  image:CHAR
  bodyText:PTR TO stringlist
ENDOBJECT

EXPORT OBJECT requesterObject OF reactionObject
  requesterItems:PTR TO stdlist
ENDOBJECT

OBJECT requesterItemSettingsForm OF reactionForm
PRIVATE
  typeLabels
  imageLabels
  requesterItem:PTR TO requesterItem
ENDOBJECT

OBJECT requesterSettingsForm OF reactionForm
PRIVATE
  selectedItem:LONG
  browserlist:PTR TO mlh
  tempRequesterItems:PTR TO stdlist
  requesterObject:PTR TO requesterObject
ENDOBJECT

PROC create() OF requesterItem
  DEF strlist:PTR TO stringlist

  self.reqType:=0
  self.image:=0
  AstrCopy(self.titleText,'')
  AstrCopy(self.gadgetsText,'')
  NEW strlist.stringlist(10)
  self.bodyText:=strlist
ENDPROC

PROC end() OF requesterItem
  END self.bodyText
ENDPROC

PROC create() OF requesterItemSettingsForm
  DEF gads:PTR TO LONG
  DEF tempbase

  NEW gads[NUM_REQITEM_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_REQITEM_GADS]
  self.gadgetActions:=gads

  tempbase:=textfieldbase
  textfieldbase:=texteditorbase

  self.typeLabels:=chooserLabelsA(['Info','Integer','String',0])
  self.imageLabels:=chooserLabelsA(['Default','Info','Warning','Error','Question','Insert Disk',0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Requester Attribute Setting',
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
      LAYOUT_ADDCHILD, self.gadgetList[REQITEMGAD_BODY]:=NewObjectA(TextEditor_GetClass(),NIL,[
        GA_ID, REQITEMGAD_BODY,
        GA_READONLY, 0,
      End,
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
    LayoutEnd,
  WindowEnd

  self.gadgetActions[REQITEMGAD_TEST]:={testRequester}
  self.gadgetActions[REQITEMGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[REQITEMGAD_OK]:=MR_OK
  
  textfieldbase:=tempbase
ENDPROC

PROC testRequester(nself,gadget,id,code) OF requesterItemSettingsForm
  DEF reqmsg:PTR TO orrequest
  DEF reqobj,win
  DEF res=0
  DEF type,titleText,gadText,bodyText,image

  SUBA.L #$100,A7
  self:=nself

  win:=Gets(self.windowObj,WINDOW_WINDOW)
  
  type:=Gets(self.gadgetList[ REQITEMGAD_TYPE ],CHOOSER_SELECTED)
  titleText:=Gets(self.gadgetList[ REQITEMGAD_TITLE ],STRINGA_TEXTVAL)
  gadText:=Gets(self.gadgetList[ REQITEMGAD_GADTEXT ],STRINGA_TEXTVAL)
  bodyText:=DoMethod(self.gadgetList[ REQITEMGAD_BODY ], GM_TEXTEDITOR_EXPORTTEXT)
  image:=Gets(self.gadgetList[ REQITEMGAD_IMAGE ],CHOOSER_SELECTED)

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
  FreeVec(bodyText)
  ADD.L #$100,A7
  
ENDPROC

PROC end() OF requesterItemSettingsForm
  IF self.typeLabels THEN freeChooserLabels(self.typeLabels)
  IF self.imageLabels THEN freeChooserLabels(self.imageLabels)
  END self.gadgetList[NUM_REQITEM_GADS]
  END self.gadgetActions[NUM_REQITEM_GADS]
ENDPROC

PROC editSettings(reqItem:PTR TO requesterItem) OF requesterItemSettingsForm
  DEF res,bodyText

  self.requesterItem:=reqItem
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_TYPE ],0,0,[CHOOSER_SELECTED,reqItem.reqType,0]) 
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_TITLE ],0,0,[STRINGA_TEXTVAL,reqItem.titleText,0])
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_GADTEXT ],0,0,[STRINGA_TEXTVAL,reqItem.gadgetsText,0])
  bodyText:=reqItem.bodyText.makeTextString()
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_BODY ],0,0,[GA_TEXTEDITOR_CONTENTS, bodyText,0])
  Dispose(bodyText)
  SetGadgetAttrsA(self.gadgetList[ REQITEMGAD_IMAGE ],0,0,[CHOOSER_SELECTED,reqItem.image,0]) 

  res:=self.showModal()
  IF res=MR_OK
    reqItem.reqType:=Gets(self.gadgetList[ REQITEMGAD_TYPE ],CHOOSER_SELECTED)
    AstrCopy(reqItem.titleText,Gets(self.gadgetList[ REQITEMGAD_TITLE ],STRINGA_TEXTVAL),80)
    AstrCopy(reqItem.gadgetsText,Gets(self.gadgetList[ REQITEMGAD_GADTEXT ],STRINGA_TEXTVAL),80)
    bodyText:=DoMethod(self.gadgetList[ REQITEMGAD_BODY ], GM_TEXTEDITOR_EXPORTTEXT)
    reqItem.bodyText.setFromTextString(bodyText)
    FreeVec(bodyText)
    reqItem.image:=Gets(self.gadgetList[ REQITEMGAD_IMAGE ],CHOOSER_SELECTED)

  ENDIF
ENDPROC res=MR_OK

PROC create() OF requesterSettingsForm
  DEF gads:PTR TO LONG
  DEF tempbase
  DEF reqItems:PTR TO stdlist

  NEW gads[NUM_REQ_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_REQ_GADS]
  self.gadgetActions:=gads
  
  NEW reqItems.stdlist(20)
  self.tempRequesterItems:=reqItems

  self.browserlist:=browserNodesA([0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Edit Requester List',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 160,
    WA_WIDTH, 260,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 160,
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

      LAYOUT_ADDCHILD,self.gadgetList[REQGAD_LIST]:=ListBrowserObject,
            GA_ID, REQGAD_LIST,
            GA_RELVERIFY, TRUE,
            LISTBROWSER_POSITION, 0,
            LISTBROWSER_SHOWSELECTED, TRUE,
            //LISTBROWSER_COLUMNTITLES, TRUE,
            //LISTBROWSER_HIERARCHICAL, TRUE,
            //LISTBROWSER_COLUMNINFO, self.columninfo,
            LISTBROWSER_LABELS, self.browserlist,
      ListBrowserEnd,
      
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[REQGAD_ADD]:=ButtonObject,
          GA_ID, REQGAD_ADD,
          GA_TEXT, 'Add',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD, self.gadgetList[REQGAD_EDIT]:=ButtonObject,
          GA_ID, REQGAD_EDIT,
          GA_TEXT, 'Edit',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD, self.gadgetList[REQGAD_DELETE]:=ButtonObject,
          GA_ID, REQGAD_DELETE,
          GA_TEXT, 'Delete',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD, self.gadgetList[REQGAD_OK]:=ButtonObject,
          GA_ID, REQGAD_OK,
          GA_TEXT, 'Ok',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        LAYOUT_ADDCHILD, self.gadgetList[REQGAD_CANCEL]:=ButtonObject,
          GA_ID, REQGAD_CANCEL,
          GA_TEXT, 'Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[REQGAD_ADD]:={addItem}
  self.gadgetActions[REQGAD_EDIT]:={editItem}
  self.gadgetActions[REQGAD_DELETE]:={deleteItem}
  self.gadgetActions[REQGAD_LIST]:={selectItem}
  self.gadgetActions[REQGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[REQGAD_OK]:=MR_OK 
ENDPROC

PROC selectItem(nself,gadget,id,code) OF requesterSettingsForm
  DEF win
  self:=nself
  self.selectedItem:=code
  
  IF code>=0
    IF Gets(gadget,LISTBROWSER_RELEVENT)=LBRE_DOUBLECLICK
      self.editItem(nself,gadget,id,code)
    ENDIF
  ENDIF

  win:=Gets(self.windowObj,WINDOW_WINDOW) 
  SetGadgetAttrsA(self.gadgetList[REQGAD_DELETE],win,0,[GA_DISABLED, code=-1, TAG_END])
  SetGadgetAttrsA(self.gadgetList[REQGAD_EDIT],win,0,[GA_DISABLED, code=-1, TAG_END])
ENDPROC

PROC addItem(nself,gadget,id,code) OF requesterSettingsForm
  DEF reqItemSettingsForm:PTR TO requesterItemSettingsForm
  DEF reqItem:PTR TO requesterItem
  DEF res,n,win
  self:=nself
  
  NEW reqItem.create()
  
  NEW reqItemSettingsForm.create()
  res:=reqItemSettingsForm.editSettings(reqItem)
  IF res
    win:=Gets(self.windowObj,WINDOW_WINDOW)

    SetGadgetAttrsA(self.gadgetList[REQGAD_LIST],win,0,[LISTBROWSER_LABELS, -1, TAG_END])
    self.tempRequesterItems.add(reqItem)
    IF (n:=AllocListBrowserNodeA(1, [LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, reqItem.titleText, TAG_END]))
      AddTail(self.browserlist, n)
    ELSE 
      Raise("MEM")    
    ENDIF
    SetGadgetAttrsA(self.gadgetList[REQGAD_LIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  ELSE
    END reqItem
  ENDIF
  END reqItemSettingsForm
ENDPROC

PROC deleteItem(nself,gadget,id,code) OF requesterSettingsForm
  DEF win,node
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  IF self.selectedItem>=0
    self.tempRequesterItems.remove(self.selectedItem)
    node:=Gets(self.gadgetList[REQGAD_LIST],LISTBROWSER_SELECTEDNODE)
    remNode(self.gadgetList[REQGAD_LIST],win,0,node)
    self.selectItem(self,0,0,-1)
    DoMethod(self.windowObj, WM_RETHINK)
  ENDIF
ENDPROC

PROC editItem(nself,gadget,id,code) OF requesterSettingsForm
  DEF reqItemSettingsForm:PTR TO requesterItemSettingsForm
  DEF reqItem:PTR TO requesterItem
  DEF res,n,node
  self:=nself
  
  reqItem:=self.tempRequesterItems.item(self.selectedItem)
  NEW reqItemSettingsForm.create()
  res:=reqItemSettingsForm.editSettings(reqItem)
  IF res
    node:=self.findNode(self.selectedItem)

    SetListBrowserNodeAttrsA(node,[LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, reqItem.titleText, TAG_END])
  ENDIF
  END reqItemSettingsForm
ENDPROC

PROC findNode(n) OF requesterSettingsForm
  DEF node:PTR TO ln
  node:=self.browserlist.head
  WHILE (node)
    IF n=0 THEN RETURN node
    n--
    node:=node.succ
  ENDWHILE
ENDPROC 0

PROC editSettings(comp:PTR TO requesterObject) OF requesterSettingsForm
  DEF res,i,j,n
  DEF reqItem:PTR TO requesterItem
  DEF oldItem:PTR TO requesterItem

  self.requesterObject:=comp

  FOR i:=0 TO comp.requesterItems.count()-1
    NEW reqItem.create()
    oldItem:=comp.requesterItems.item(i)
    reqItem.reqType:=oldItem.reqType
    AstrCopy(reqItem.titleText,oldItem.titleText)
    AstrCopy(reqItem.gadgetsText,oldItem.gadgetsText)
    reqItem.image:=oldItem.image
    FOR j:=0 TO oldItem.bodyText.count()-1
      reqItem.bodyText.add(oldItem.bodyText.item(j))
    ENDFOR
    self.tempRequesterItems.add(reqItem)
  ENDFOR

  SetGadgetAttrsA(self.gadgetList[REQGAD_LIST],0,0,[LISTBROWSER_LABELS, -1, TAG_END])

  FOR i:=0 TO comp.requesterItems.count()-1
    IF (n:=AllocListBrowserNodeA(1, [LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, comp.requesterItems.item(i)::requesterItem.titleText, TAG_END]))
      AddTail(self.browserlist, n)
    ELSE 
      Raise("MEM")    
    ENDIF
  ENDFOR

  SetGadgetAttrsA(self.gadgetList[REQGAD_LIST],0,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  self.selectItem(self,0,0,-1)

  res:=self.showModal()
  IF res=MR_OK
    FOR i:=0 TO comp.requesterItems.count()-1 
      reqItem:=comp.requesterItems.item(i)
      END reqItem
    ENDFOR
    comp.requesterItems.clear()
    FOR i:=0 TO self.tempRequesterItems.count()-1
      NEW reqItem.create()
      oldItem:=self.tempRequesterItems.item(i)
      reqItem.reqType:=oldItem.reqType
      AstrCopy(reqItem.titleText,oldItem.titleText)
      AstrCopy(reqItem.gadgetsText,oldItem.gadgetsText)
      reqItem.image:=oldItem.image
      FOR j:=0 TO oldItem.bodyText.count()-1
        reqItem.bodyText.add(oldItem.bodyText.item(j))
      ENDFOR
      comp.requesterItems.add(reqItem)
    ENDFOR
  ENDIF
ENDPROC res=MR_OK

PROC end() OF requesterSettingsForm
  DEF i
  DEF reqItem:PTR TO requesterItem
  FOR i:=0 TO self.tempRequesterItems.count()-1
    reqItem:=self.tempRequesterItems.item(i)
    END reqItem
  ENDFOR

  END self.tempRequesterItems
  freeBrowserNodes(self.browserlist)
  END self.gadgetList[NUM_REQ_GADS]
  END self.gadgetActions[NUM_REQ_GADS]
ENDPROC

EXPORT PROC create(parent) OF requesterObject
  DEF strlist:PTR TO stringlist
  DEF itemList:PTR TO stdlist
  self.type:=TYPE_REQUESTER
  SUPER self.create(parent)
  AstrCopy(self.name,'')
  AstrCopy(self.ident,'Requesters')

  NEW itemList.stdlist(10)
  self.requesterItems:=itemList
ENDPROC

EXPORT PROC editSettings() OF requesterObject
  DEF editForm:PTR TO requesterSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

PROC end() OF requesterObject
  END self.requesterItems
  SUPER self.end()  
ENDPROC

EXPORT PROC getTypeName() OF requesterObject
  RETURN 'Requester'
ENDPROC

EXPORT PROC serialise(fser:PTR TO fileStreamer) OF requesterObject
  DEF tempStr[200]:STRING
  DEF reqItem:PTR TO requesterItem
  DEF i,j

  SUPER self.serialise(fser)

  FOR i:=0 TO self.requesterItems.count()-1
    reqItem:=self.requesterItems.item(i)
    StringF(tempStr,'REQTYPE: \d',reqItem.reqType)
    fser.writeLine(tempStr)
    StringF(tempStr,'TITLETEXT: \s',reqItem.titleText)
    fser.writeLine(tempStr)
    StringF(tempStr,'GADGETSTEXT: \s',reqItem.gadgetsText)
    fser.writeLine(tempStr)
    StringF(tempStr,'IMAGE: \d',reqItem.image)
    fser.writeLine(tempStr)
    FOR j:=0 TO reqItem.bodyText.count()-1
      StringF(tempStr,'BODYTEXT: \s',reqItem.bodyText.item(j))
      fser.writeLine(tempStr)
    ENDFOR
  ENDFOR
  fser.writeLine('-')
  self.serialiseChildren(fser)
ENDPROC

EXPORT PROC deserialise(fser:PTR TO fileStreamer) OF requesterObject
  DEF tempStr[200]:STRING
  DEF done=FALSE
  DEF i
  DEF reqItem:PTR TO requesterItem

  SUPER self.deserialise(fser)

  FOR i:=0 TO self.requesterItems.count()-1
    reqItem:=self.requesterItems.item(i)
    END reqItem
  ENDFOR
  self.requesterItems.clear()

  REPEAT
    IF fser.readLine(tempStr)
      IF StrCmp('-',tempStr)
        done:=TRUE
      ELSEIF StrCmp('REQTYPE: ',tempStr,STRLEN)
        NEW reqItem.create()
        self.requesterItems.add(reqItem)
        reqItem.reqType:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('TITLETEXT: ',tempStr,STRLEN)
        AstrCopy(reqItem.titleText,tempStr+STRLEN)
      ELSEIF StrCmp('GADGETSTEXT: ',tempStr,STRLEN)
        AstrCopy(reqItem.gadgetsText,tempStr+STRLEN)
      ELSEIF StrCmp('IMAGE: ',tempStr,STRLEN)
        reqItem.image:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('BODYTEXT: ',tempStr,STRLEN)
        reqItem.bodyText.add(tempStr+STRLEN)
      ENDIF
    ELSE
      done:=TRUE
    ENDIF
  UNTIL done  
ENDPROC


EXPORT PROC createRequesterObject(parent)
  DEF requester:PTR TO requesterObject
  
  NEW requester.create(parent)
ENDPROC requester


