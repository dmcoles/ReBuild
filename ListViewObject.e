OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'gadgets/listview','listview',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'exec/lists',
        'exec/nodes',
        'amigalib/lists',
        'exec/memory',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/screens',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*listPicker','*stringlist','*reactionListObject','*reactionLists','*sourceGen','*validator'

EXPORT ENUM LVIEWGAD_IDENT, LVIEWGAD_LABEL, LVIEWGAD_HINT, LVIEWGAD_LISTSELECT, LVIEWGAD_MULTISELECT,
      LVIEWGAD_OK, LVIEWGAD_CHILD, LVIEWGAD_CANCEL
      

CONST NUM_LVIEW_GADS=LVIEWGAD_CANCEL+1

EXPORT OBJECT listViewObject OF reactionObject
  listObjectId:LONG
  multiSelect:CHAR
PRIVATE
  labels1:PTR TO LONG
ENDOBJECT

OBJECT listViewSettingsForm OF reactionForm
PRIVATE
  listViewObject:PTR TO listViewObject
  selectedListId:LONG
ENDOBJECT

PROC create() OF listViewSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_LVIEW_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_LVIEW_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'ListView Attribute Setting',
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
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD, self.gadgetList[ LVIEWGAD_IDENT ]:=StringObject,
          GA_ID, LVIEWGAD_IDENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Identifier',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LVIEWGAD_LABEL ]:=StringObject,
          GA_ID, LVIEWGAD_LABEL,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Label',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LVIEWGAD_HINT ]:=ButtonObject,
          GA_ID, LVIEWGAD_HINT,
          GA_TEXT, 'Hint',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,          
      LayoutEnd,
      
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LVIEWGAD_LISTSELECT ]:=ButtonObject,
          GA_ID, LVIEWGAD_LISTSELECT,
          GA_TEXT, '_Pick a List',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ LVIEWGAD_MULTISELECT ]:=CheckBoxObject,
          GA_ID, LVIEWGAD_MULTISELECT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Multi-select',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,     
      LayoutEnd,
      
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ LVIEWGAD_OK ]:=ButtonObject,
          GA_ID, LVIEWGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LVIEWGAD_CHILD ]:=ButtonObject,
          GA_ID, LVIEWGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ LVIEWGAD_CANCEL ]:=ButtonObject,
          GA_ID, LVIEWGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
      CHILD_WEIGHTEDHEIGHT,0,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[LVIEWGAD_LISTSELECT]:={selectList}
  self.gadgetActions[LVIEWGAD_CHILD]:={editChildSettings}
  self.gadgetActions[LVIEWGAD_HINT]:={editHint}  
  self.gadgetActions[LVIEWGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[LVIEWGAD_OK]:=MR_OK
ENDPROC

PROC selectList(nself,gadget,id,code) OF listViewSettingsForm
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

PROC editChildSettings(nself,gadget,id,code) OF listViewSettingsForm
  self:=nself
  self.setBusy()
  self.listViewObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF listViewSettingsForm
  END self.gadgetList[NUM_LVIEW_GADS]
  END self.gadgetActions[NUM_LVIEW_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC canClose(modalRes) OF listViewSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.listViewObject,LVIEWGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editHint(nself,gadget,id,code) OF listViewSettingsForm
  self:=nself
  self.setBusy()
  self.listViewObject.editHint()
  self.clearBusy()
  self.updateHint(LVIEWGAD_HINT, self.listViewObject.hintText)
ENDPROC

PROC editSettings(comp:PTR TO listViewObject) OF listViewSettingsForm
  DEF res

  self.listViewObject:=comp
  self.selectedListId:=comp.listObjectId

  self.updateHint(LVIEWGAD_HINT, comp.hintText)
  SetGadgetAttrsA(self.gadgetList[ LVIEWGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ LVIEWGAD_LABEL ],0,0,[STRINGA_TEXTVAL,comp.label,0])
  SetGadgetAttrsA(self.gadgetList[ LVIEWGAD_MULTISELECT ],0,0,[LVIEWGAD_MULTISELECT,comp.multiSelect,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.listObjectId:=self.selectedListId
    AstrCopy(comp.ident,Gets(self.gadgetList[ LVIEWGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.label,Gets(self.gadgetList[ LVIEWGAD_LABEL ],STRINGA_TEXTVAL))
    comp.multiSelect:=Gets(self.gadgetList[ LVIEWGAD_MULTISELECT ],CHECKBOX_CHECKED)   
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF listViewObject
  self.previewObject:=0
  IF (listviewbase)
    IF self.labels1 THEN self.freeListViewLabels( self.labels1 )
    self.previewObject:=NewObjectA( ListView_GetClass(), NIL,[TAG_IGNORE,0,
        GA_ID, self.id,
        LISTVIEW_LABELS, self.labels1:=self.makeListViewList(self.listObjectId),
        LISTVIEW_MULTISELECT, self.multiSelect,
      TAG_END])
  ENDIF
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

  self.makePreviewChildAttrs(0)
ENDPROC

EXPORT PROC create(parent) OF listViewObject
  self.type:=TYPE_LISTVIEW
  SUPER self.create(parent)
  self.multiSelect:=0
  self.labels1:=0
  self.libsused:=[TYPE_LISTVIEW]
ENDPROC

PROC end() OF listViewObject
  self.freeListViewLabels( self.labels1 )
  SUPER self.end()
ENDPROC

PROC makeListViewList(id) OF listViewObject
  DEF i,res
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
  ELSE
    newlist:=List(1)
  ENDIF
    ListAddItem(newlist,0)
  res:=self.listViewLabelsA(newlist)
  DisposeLink(newlist)
ENDPROC res


PROC listViewLabelsA(text:PTR TO LONG) OF listViewObject
  DEF list:PTR TO lh
  DEF node:PTR TO listlabelnode
  DEF i=0

  IF (list:=AllocMem( SIZEOF lh, MEMF_PUBLIC ))
    newList(list)
    
    WHILE (text[])
      NEW node
      IF node=0
        self.freeListViewLabels(list)
        RETURN NIL
      ENDIF
      node.node.type:=i
      node.renderforeground:=1
      node.renderbackground:=0
      node.selectforeground:=2
      node.selectbackground:=3
      node.node.name:=text[]++
      AddTail(list,node)
    ENDWHILE
  ENDIF
ENDPROC list

->**************************************************************************

PROC freeListViewLabels(list:PTR TO lh) OF listViewObject
  DEF node:PTR TO listlabelnode
  DEF nextnode:PTR TO ln
  DEF i
  
  IF list
    node:= list.head
   WHILE (nextnode := node.node.succ)
      END node
      node := nextnode
   ENDWHILE
   FreeMem(list,SIZEOF lh)
  ENDIF
ENDPROC


EXPORT PROC editSettings() OF listViewObject
  DEF editForm:PTR TO listViewSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC getTypeName() OF listViewObject
  RETURN 'ListView'
ENDPROC

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF listViewObject IS
[
  makeProp(listObjectId,FIELDTYPE_CHAR),
  makeProp(multiSelect,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF listViewObject
  DEF tempStr[200]:STRING
  srcGen.componentProperty('GA_RelVerify','TRUE',FALSE)
  srcGen.componentProperty('GA_TabCycle','TRUE',FALSE)
  IF self.multiSelect THEN srcGen.componentProperty('LISTVIEW_MultiSelect','TRUE',FALSE)
  
  IF self.listObjectId >=0
    StringF(tempStr,'labels\d',self.id)
    srcGen.componentProperty('LISTVIEW_Labels',tempStr,FALSE)
  ENDIF
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF listViewObject
  srcGen.componentAddChildLabel(self.label)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC hasCreateMacro() OF listViewObject IS FALSE

EXPORT PROC getTypeEndName() OF listViewObject
  RETURN 'End'
ENDPROC

EXPORT PROC createListViewObject(parent)
  DEF listView:PTR TO listViewObject
  
  NEW listView.create(parent)
ENDPROC listView


