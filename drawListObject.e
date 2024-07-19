OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'drawlist','images/drawlist',
        'images/bevel',
        'string',
        'gadgets/integer','integer',
        'gadgets/chooser','chooser',
        'gadgets/checkbox','checkbox',
        'gadgets/listbrowser','listbrowser',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/screens',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec/lists',
        'exec/nodes',
        'amigalib/lists'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*baseStreamer','*sourceGen','*stringlist','*validator'

EXPORT ENUM DRAWLISTGAD_IDENT, DRAWLISTGAD_LIST,DRAWLISTGAD_ADD, DRAWLISTGAD_EDIT, DRAWLISTGAD_DEL,
      DRAWLISTGAD_OK, DRAWLISTGAD_CHILD, DRAWLISTGAD_CANCEL

CONST NUM_DRAWLIST_GADS=DRAWLISTGAD_CANCEL+1

ENUM DRAWITEMGAD_ACTION, DRAWITEMGAD_X1, DRAWITEMGAD_Y1, DRAWITEMGAD_X2, DRAWITEMGAD_Y2, DRAWITEMGAD_PEN,
      DRAWITEMGAD_OK, DRAWITEMGAD_CANCEL
CONST NUM_DRAWITEM_GADS=DRAWITEMGAD_CANCEL+1

EXPORT OBJECT drawListObject OF reactionObject
  drawItemsList:PTR TO stdlist
PRIVATE
  directives:PTR TO LONG
ENDOBJECT

OBJECT drawListItemForm OF reactionForm
PRIVATE
  tmpPen:INT
  labels1:PTR TO LONG
ENDOBJECT

OBJECT drawListSettingsForm OF reactionForm
PRIVATE
  drawListObject:PTR TO drawListObject
  columninfo[7]:ARRAY OF columninfo
  nodes:PTR TO stdlist
  browserlist:PTR TO mlh
  selectedItem:INT
ENDOBJECT

PROC create() OF drawListItemForm
  DEF gads:PTR TO LONG
  DEF arrows,scr:PTR TO screen

  NEW gads[NUM_DRAWITEM_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_DRAWITEM_GADS]
  self.gadgetActions:=gads

  scr:=LockPubScreen(NIL)
  arrows:=(scr.width>=800)
  UnlockPubScreen(NIL,scr)
  
  self.labels1:=chooserLabelsA(['DLST_END', 'DLST_LINE', 'DLST_RECT', 'DLST_LINEPAT','DLST_FILLPAT','DLST_LINESIZE','DLST_AMOVE','DLST_ADRAW','DLST_AFILL','DLST_FILL','DLST_ELLIPSE','DLST_CIRCLE',0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'DrawList Item Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 120,
    WA_WIDTH, 320,
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

        LAYOUT_ADDCHILD, self.gadgetList[ DRAWITEMGAD_ACTION ]:=ChooserObject,
          GA_ID, DRAWITEMGAD_ACTION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          CHOOSER_POPUP, TRUE,
          CHOOSER_MAXLABELS, 12,
          CHOOSER_ACTIVE, 0,
          CHOOSER_WIDTH, -1,
          CHOOSER_LABELS, self.labels1,
        ChooserEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWITEMGAD_PEN ]:=ButtonObject,
          GA_ID, DRAWITEMGAD_PEN,
          GA_TEXT, 'PenColor',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWITEMGAD_X1 ]:=IntegerObject,
          GA_ID, DRAWITEMGAD_X1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X1',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWITEMGAD_Y1 ]:=IntegerObject,
          GA_ID, DRAWITEMGAD_Y1,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y1',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWITEMGAD_X2 ]:=IntegerObject,
          GA_ID, DRAWITEMGAD_X2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'X2',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWITEMGAD_Y2 ]:=IntegerObject,
          GA_ID, DRAWITEMGAD_Y2,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_ARROWS, arrows,
          INTEGER_MAXCHARS, 10,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 8192,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Y2',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWITEMGAD_OK ]:=ButtonObject,
          GA_ID, DRAWITEMGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ DRAWITEMGAD_CANCEL ]:=ButtonObject,
          GA_ID, DRAWITEMGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[DRAWITEMGAD_PEN]:={selectPen}
  self.gadgetActions[DRAWITEMGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[DRAWITEMGAD_OK]:=MR_OK
ENDPROC

PROC addItem() OF drawListItemForm 
  DEF res
  DEF drawitem=0:PTR TO drawlist
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_ACTION ],0,0,[CHOOSER_SELECTED,0,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_X1 ],0,0,[INTEGER_NUMBER,1,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_Y1 ],0,0,[INTEGER_NUMBER,1,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_X2 ],0,0,[INTEGER_NUMBER,1,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_Y2 ],0,0,[INTEGER_NUMBER,1,0]) 
  self.tmpPen:=1
  res:=(self.showModal()=MR_OK)
  IF res
    NEW drawitem
    drawitem.directive:=Gets(self.gadgetList[ DRAWITEMGAD_ACTION ],CHOOSER_SELECTED)
    drawitem.x1:=Gets(self.gadgetList[ DRAWITEMGAD_X1 ],INTEGER_NUMBER)
    drawitem.y1:=Gets(self.gadgetList[ DRAWITEMGAD_Y1 ],INTEGER_NUMBER)
    drawitem.x2:=Gets(self.gadgetList[ DRAWITEMGAD_X2 ],INTEGER_NUMBER)
    drawitem.y2:=Gets(self.gadgetList[ DRAWITEMGAD_Y2 ],INTEGER_NUMBER)
    drawitem.pen:=self.tmpPen
  ENDIF
ENDPROC res,drawitem

PROC editItem(drawitem:PTR TO drawlist) OF drawListItemForm
  DEF res
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_ACTION ],0,0,[CHOOSER_SELECTED,drawitem.directive,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_X1 ],0,0,[INTEGER_NUMBER,drawitem.x1,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_Y1 ],0,0,[INTEGER_NUMBER,drawitem.y1,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_X2 ],0,0,[INTEGER_NUMBER,drawitem.x2,0]) 
  SetGadgetAttrsA(self.gadgetList[ DRAWITEMGAD_Y2 ],0,0,[INTEGER_NUMBER,drawitem.y2,0]) 
  self.tmpPen:=drawitem.pen
  res:=(self.showModal()=MR_OK)
  IF res
    drawitem.directive:=Gets(self.gadgetList[ DRAWITEMGAD_ACTION ],CHOOSER_SELECTED)
    drawitem.x1:=Gets(self.gadgetList[ DRAWITEMGAD_X1 ],INTEGER_NUMBER)
    drawitem.y1:=Gets(self.gadgetList[ DRAWITEMGAD_Y1 ],INTEGER_NUMBER)
    drawitem.x2:=Gets(self.gadgetList[ DRAWITEMGAD_X2 ],INTEGER_NUMBER)
    drawitem.y2:=Gets(self.gadgetList[ DRAWITEMGAD_Y2 ],INTEGER_NUMBER)
    drawitem.pen:=self.tmpPen
  ENDIF
ENDPROC res

PROC selectPen(nself,gadget,id,code) OF drawListItemForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour

  self:=nself

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(self.tmpPen))<>-1
    self.tmpPen:=selColour
  ENDIF
  END frmColourPicker
ENDPROC


PROC end() OF drawListItemForm
  freeChooserLabels( self.labels1 )
ENDPROC

PROC create() OF drawListSettingsForm
  DEF gads:PTR TO LONG
  DEF nodes:PTR TO stdlist

  NEW gads[NUM_DRAWLIST_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_DRAWLIST_GADS]
  self.gadgetActions:=gads
 
  NEW nodes.stdlist(10)
  self.nodes:=nodes

  self.columninfo[0].width:=2
  self.columninfo[0].title:='Action'
  self.columninfo[0].flags:=CIF_WEIGHTED
  
  self.columninfo[1].width:=1
  self.columninfo[1].title:='X1'
  self.columninfo[1].flags:=CIF_WEIGHTED

  self.columninfo[2].width:=1
  self.columninfo[2].title:='Y1'
  self.columninfo[2].flags:=CIF_WEIGHTED

  self.columninfo[3].width:=1
  self.columninfo[3].title:='X2'
  self.columninfo[3].flags:=CIF_WEIGHTED

  self.columninfo[4].width:=1
  self.columninfo[4].title:='Y2'
  self.columninfo[4].flags:=CIF_WEIGHTED

  self.columninfo[5].width:=1
  self.columninfo[5].title:='Pen'
  self.columninfo[5].flags:=CIF_WEIGHTED


  self.columninfo[6].width:=-1
  self.columninfo[6].title:=-1
  self.columninfo[6].flags:=-1

  self.browserlist:=browserNodesA([0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'DrawList Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 220,
    WA_WIDTH, 420,
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


      LAYOUT_ADDCHILD, self.gadgetList[ DRAWLISTGAD_IDENT ]:=StringObject,
        GA_ID, DRAWLISTGAD_IDENT,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,

      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Identifier',
      LabelEnd,

      LAYOUT_ADDCHILD,self.gadgetList[DRAWLISTGAD_LIST]:=ListBrowserObject,
          GA_ID, DRAWLISTGAD_LIST,
          GA_RELVERIFY, TRUE,
          LISTBROWSER_POSITION, 0,
          LISTBROWSER_SHOWSELECTED, TRUE,
          LISTBROWSER_COLUMNTITLES, TRUE,
          LISTBROWSER_HIERARCHICAL, FALSE,
          LISTBROWSER_COLUMNINFO, self.columninfo,
          LISTBROWSER_LABELS, self.browserlist,
      ListBrowserEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_ADD ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_ADD,
            GA_TEXT, '_Add',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_EDIT ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_EDIT,
            GA_TEXT, '_Edit',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_DEL ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_DEL,
            GA_TEXT, '_Delete',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT,0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_OK ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_CHILD ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_CHILD,
            GA_TEXT, 'C_hild',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ DRAWLISTGAD_CANCEL ]:=ButtonObject,
            GA_ID, DRAWLISTGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[DRAWLISTGAD_LIST]:={selectItem}
  self.gadgetActions[DRAWLISTGAD_CHILD]:={editChildSettings}
  self.gadgetActions[DRAWLISTGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[DRAWLISTGAD_ADD]:={addDrawItem}
  self.gadgetActions[DRAWLISTGAD_DEL]:={deleteItem}
  self.gadgetActions[DRAWLISTGAD_EDIT]:={editDrawItem}  
  self.gadgetActions[DRAWLISTGAD_OK]:=MR_OK

ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF drawListSettingsForm
  self:=nself
  self.setBusy()
  self.drawListObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC selectItem(nself,gadget,id,code) OF drawListSettingsForm
  DEF win,dis,tmp
  self:=nself

  IF gadget
    tmp:=Gets(gadget,LISTBROWSER_RELEVENT)
    IF tmp=LBRE_DOUBLECLICK
      self.editDrawItem(nself,gadget,id,code)
      RETURN
    ENDIF
  ENDIF

  win:=Gets(self.windowObj,WINDOW_WINDOW)
  self.selectedItem:=code
  dis:=IF code=-1 THEN TRUE ELSE FALSE
  SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_EDIT],win,0,[GA_DISABLED, dis, TAG_END])
  SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_DEL],win,0,[GA_DISABLED, dis, TAG_END])
  DoMethod(self.windowObj, WM_RETHINK)
ENDPROC

PROC addDrawItem(nself,gadget,id,code) OF drawListSettingsForm
  DEF itemSettings:PTR TO drawListItemForm
  DEF drawitem:PTR TO drawlist
  DEF win,res
  self:=nself
  
  NEW itemSettings.create()
  res,drawitem:=itemSettings.addItem()
  IF res
    win:=Gets(self.windowObj,WINDOW_WINDOW)
    SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_LIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
    self.addNode(drawitem)
    SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_LIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  ENDIF
  END drawitem
  END itemSettings
ENDPROC

PROC editDrawItem(nself,gadget,id,code) OF drawListSettingsForm
  DEF itemSettings:PTR TO drawListItemForm
  DEF drawitem:PTR TO drawlist
  DEF win
  self:=nself

  drawitem:=self.createItemFromNode(self.nodes.item(self.selectedItem))

  NEW itemSettings.create()
  IF itemSettings.editItem(drawitem)
    win:=Gets(self.windowObj,WINDOW_WINDOW)
    SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_LIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
    self.updateNode(self.nodes.item(self.selectedItem),drawitem)
    SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_LIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  ENDIF
  
  END itemSettings
  END drawitem
ENDPROC

PROC deleteItem(nself,gadget,id,code) OF drawListSettingsForm
  DEF win,node
  self:=nself
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  IF self.selectedItem>=0
    self.nodes.remove(self.selectedItem)
    node:=Gets(self.gadgetList[DRAWLISTGAD_LIST],LISTBROWSER_SELECTEDNODE)
    remNode(self.gadgetList[DRAWLISTGAD_LIST],win,0,node)
    self.selectItem(self,0,0,-1)
    DoMethod(self.windowObj, WM_RETHINK)
  ENDIF
ENDPROC

PROC end() OF drawListSettingsForm
  freeBrowserNodes(self.browserlist)
  
  END self.nodes

  END self.gadgetList[NUM_DRAWLIST_GADS]
  END self.gadgetActions[NUM_DRAWLIST_GADS]
  DisposeObject(self.windowObj)
ENDPROC

PROC updateNode(node,drawitem:PTR TO drawlist) OF drawListSettingsForm
  DEF actionText[20]:STRING
  DEF x1Text[10]:STRING
  DEF y1Text[10]:STRING
  DEF x2Text[10]:STRING
  DEF y2Text[10]:STRING
  DEF penText[10]:STRING

    StrCopy(actionText,ListItem(['DLST_END', 'DLST_LINE', 'DLST_RECT', 'DLST_LINEPAT','DLST_FILLPAT','DLST_LINESIZE','DLST_AMOVE','DLST_ADRAW','DLST_AFILL','DLST_FILL','DLST_ELLIPSE','DLST_CIRCLE',0],drawitem.directive))
    StringF(x1Text,'\d',drawitem.x1)
    StringF(y1Text,'\d',drawitem.y1)
    StringF(x2Text,'\d',drawitem.x2)
    StringF(y2Text,'\d',drawitem.y2)
    StringF(penText,'\d',drawitem.pen)

    SetListBrowserNodeAttrsA(node,[
              LBNA_USERDATA,drawitem.directive, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, actionText,
                                                    LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, x1Text,
                                                    LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, y1Text,
                                                    LBNA_COLUMN,3, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, x2Text,
                                                    LBNA_COLUMN,4, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, y2Text,
                                                    LBNA_COLUMN,5, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, penText,
        TAG_END])
ENDPROC

PROC addNode(drawitem:PTR TO drawlist) OF drawListSettingsForm
  DEF actionText[20]:STRING
  DEF x1Text[10]:STRING
  DEF y1Text[10]:STRING
  DEF x2Text[10]:STRING
  DEF y2Text[10]:STRING
  DEF penText[10]:STRING
  DEF n

    StrCopy(actionText,ListItem(['DLST_END', 'DLST_LINE', 'DLST_RECT', 'DLST_LINEPAT','DLST_FILLPAT','DLST_LINESIZE','DLST_AMOVE','DLST_ADRAW','DLST_AFILL','DLST_FILL','DLST_ELLIPSE','DLST_CIRCLE',0],drawitem.directive))
    StringF(x1Text,'\d',drawitem.x1)
    StringF(y1Text,'\d',drawitem.y1)
    StringF(x2Text,'\d',drawitem.x2)
    StringF(y2Text,'\d',drawitem.y2)
    StringF(penText,'\d',drawitem.pen)

    IF (n:=AllocListBrowserNodeA(6, [LBNA_FLAGS,0, LBNA_USERDATA,drawitem.directive, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, actionText,
                                                    LBNA_COLUMN,1, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, x1Text,
                                                    LBNA_COLUMN,2, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, y1Text,
                                                    LBNA_COLUMN,3, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, x2Text,
                                                    LBNA_COLUMN,4, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, y2Text,
                                                    LBNA_COLUMN,5, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, penText,
        TAG_END]))
      AddTail(self.browserlist, n)
      self.nodes.add(n)
    ELSE 
      Raise("MEM")    
    ENDIF
ENDPROC

PROC createItemFromNode(node:PTR TO LONG) OF drawListSettingsForm
  DEF action,x1,y1,x2,y2,pen
  DEF drawitem:PTR TO drawlist
  
  NEW drawitem
  GetListBrowserNodeAttrsA(node,[LBNA_USERDATA,{action},LBNA_COLUMN,1,LBNCA_TEXT,{x1},LBNA_COLUMN,2,LBNCA_TEXT,{y1},LBNA_COLUMN,3,LBNCA_TEXT,{x2},LBNA_COLUMN,4,LBNCA_TEXT,{y2},LBNA_COLUMN,5,LBNCA_TEXT,{pen},TAG_END])
  drawitem.directive:=action
  drawitem.x1:=Val(x1)
  drawitem.y1:=Val(y1)
  drawitem.x2:=Val(x2)
  drawitem.y2:=Val(y2)
  drawitem.pen:=Val(pen)
ENDPROC drawitem

EXPORT PROC canClose(modalRes) OF drawListSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.drawListObject,DRAWLISTGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO drawListObject) OF drawListSettingsForm
  DEF res,i,n
  DEF drawitem:PTR TO drawlist

  self.drawListObject:=comp

  SetGadgetAttrsA(self.gadgetList[ DRAWLISTGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0]) 
  SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_LIST],0,0,[LISTBROWSER_LABELS, Not(0), TAG_END])
  FOR i:=0 TO comp.drawItemsList.count()-1 
    drawitem:=comp.drawItemsList.item(i)
    self.addNode(drawitem)
  ENDFOR
  SetGadgetAttrsA(self.gadgetList[DRAWLISTGAD_LIST],0,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])

  self.selectItem(self,0,0,-1)

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ DRAWLISTGAD_IDENT ],STRINGA_TEXTVAL))
    FOR i:=0 TO comp.drawItemsList.count()-1
      drawitem:=comp.drawItemsList.item(i)
      END drawitem
    ENDFOR
    comp.drawItemsList.clear()
    
    FOR i:=0 TO self.nodes.count()-1 
      drawitem:=self.createItemFromNode(self.nodes.item(i))
      comp.drawItemsList.add(drawitem)
      
    ENDFOR

  ENDIF
ENDPROC res=MR_OK

PROC makeDrawlist() OF drawListObject
  DEF newlist:PTR TO drawlist
  DEF drawitem:PTR TO drawlist
  DEF i
  Dispose(self.directives)
  newlist:=New(SIZEOF drawlist*(self.drawItemsList.count()+1))
  FOR i:=0 TO self.drawItemsList.count()-1
    drawitem:=self.drawItemsList.item(i)
    
    newlist[i].directive:=drawitem.directive
    newlist[i].x1:=drawitem.x1
    newlist[i].y1:=drawitem.y1
    newlist[i].x2:=drawitem.x2
    newlist[i].y2:=drawitem.y2
    newlist[i].pen:=drawitem.pen
  ENDFOR
  i:=self.drawItemsList.count()
  newlist[i].directive:=DLST_END
  newlist[i].x1:=0
  newlist[i].y1:=0
  newlist[i].x2:=0
  newlist[i].y2:=0
  newlist[i].pen:=0
ENDPROC newlist

EXPORT PROC createPreviewObject(scr) OF drawListObject
  self.previewObject:=DrawListObject,
      DRAWLIST_DIRECTIVES, self.directives:=self.makeDrawlist(),
      DRAWLIST_DRAWINFO, self.drawInfo,
    DrawListEnd
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

EXPORT PROC create(parent) OF drawListObject
  DEF i
  DEF drawItemsList:PTR TO stdlist
  DEF drawitem:PTR TO drawlist
  self.type:=TYPE_DRAWLIST

  SUPER self.create(parent)
  
  NEW drawItemsList.stdlist(10)
  self.drawItemsList:=drawItemsList

  self.libsused:=[TYPE_DRAWLIST]
ENDPROC

PROC end() OF drawListObject
  DEF drawitem:PTR TO drawlist
  DEF i
  FOR i:=0 TO self.drawItemsList.count()-1
    drawitem:=self.drawItemsList.item(i)
    END drawitem
  ENDFOR
  END self.drawItemsList
  Dispose(self.directives)
ENDPROC

EXPORT PROC editSettings() OF drawListObject
  DEF editForm:PTR TO drawListSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
  
ENDPROC res

EXPORT PROC getTypeName() OF drawListObject
  RETURN 'DrawList'
ENDPROC

EXPORT PROC serialise(fser:PTR TO baseStreamer) OF drawListObject
  DEF tempStr[200]:STRING
  DEF drawItem:PTR TO drawlist
  DEF i

  SUPER self.serialise(fser)

  FOR i:=0 TO self.drawItemsList.count()-1
    drawItem:=self.drawItemsList.item(i)
    StringF(tempStr,'DIRECTIVE: \d',drawItem.directive)
    fser.writeLine(tempStr)
    StringF(tempStr,'PEN: \d',drawItem.pen)
    fser.writeLine(tempStr)
    StringF(tempStr,'X1: \d',drawItem.x1)
    fser.writeLine(tempStr)
    StringF(tempStr,'Y1: \d',drawItem.y1)
    fser.writeLine(tempStr)
    StringF(tempStr,'X2: \d',drawItem.x2)
    fser.writeLine(tempStr)
    StringF(tempStr,'Y2: \d',drawItem.y2)
    fser.writeLine(tempStr)
  ENDFOR
  fser.writeLine('-')
  self.serialiseChildren(fser)
ENDPROC

EXPORT PROC deserialise(fser:PTR TO baseStreamer) OF drawListObject
  DEF tempStr[200]:STRING
  DEF done=FALSE
  DEF i
  DEF drawitem:PTR TO drawlist

  SUPER self.deserialise(fser)
  
  i:=-1
  REPEAT
    IF fser.readLine(tempStr)
      IF StrCmp('-',tempStr)
        done:=TRUE
      ELSEIF StrCmp('DIRECTIVE: ',tempStr,STRLEN)
        i++
        NEW drawitem
        drawitem.directive:=Val(tempStr+STRLEN)
        self.drawItemsList.add(drawitem)
      ELSEIF StrCmp('PEN: ',tempStr,STRLEN)
        self.drawItemsList.item(i)::drawlist.pen:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('X1: ',tempStr,STRLEN)
        self.drawItemsList.item(i)::drawlist.x1:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('Y1: ',tempStr,STRLEN)
        self.drawItemsList.item(i)::drawlist.y1:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('X2: ',tempStr,STRLEN)
        self.drawItemsList.item(i)::drawlist.x2:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('Y2: ',tempStr,STRLEN)
        self.drawItemsList.item(i)::drawlist.y2:=Val(tempStr+STRLEN)
      ENDIF
    ELSE
      done:=TRUE
    ENDIF
  UNTIL done  
ENDPROC

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF drawListObject
  DEF tempStr[200]:STRING
  
  IF srcGen.type=CSOURCE_GEN
    StringF(tempStr,'&DLST_DrawList\d',self.id)
  ELSE
    StringF(tempStr,'dlstDrawList\d',self.id)
  ENDIF
  srcGen.componentProperty('DRAWLIST_Directives',tempStr,FALSE) 
ENDPROC

EXPORT PROC isImage() OF drawListObject IS TRUE

EXPORT PROC createDrawListObject(parent)
  DEF drawlist:PTR TO drawListObject
  
  NEW drawlist.create(parent)
ENDPROC drawlist
