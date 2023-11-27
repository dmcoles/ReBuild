OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'listbrowser','gadgets/listbrowser',
        'images/bevel',
        'string',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'exec/lists','exec/nodes'

  MODULE '*reactionObject','*reactionForm','*stringlist'

EXPORT ENUM REXXGAD_HOSTNAME, REXXGAD_EXTENSION, REXXGAD_NOSLOT, REXXGAD_REPLYHOOK, 
      REXXGAD_OK, REXXGAD_COMMANDS, REXXGAD_CANCEL

CONST NUM_REXX_GADS=REXXGAD_CANCEL+1

EXPORT ENUM REXXCMDGAD_CMDLIST, REXXCMDGAD_COMMAND, REXXCMDGAD_OK, REXXCMDGAD_DELETE, REXXCMDGAD_CANCEL

CONST NUM_REXXCMD_GADS=REXXCMDGAD_CANCEL+1

EXPORT OBJECT rexxObject OF reactionObject
  hostName[80]:ARRAY OF CHAR
  extension[80]:ARRAY OF CHAR
  noSlot:CHAR
  replyHook:CHAR
  commands:PTR TO stringlist
ENDOBJECT

OBJECT rexxSettingsForm OF reactionForm
PRIVATE
  rexxObject:PTR TO rexxObject
  tempCommands:PTR TO stringlist
ENDOBJECT

OBJECT rexxCommandSettingsForm OF reactionForm
  rexxObject:PTR TO rexxObject
  selectedItem:LONG
  browserlist:PTR TO mlh
ENDOBJECT

PROC create() OF rexxSettingsForm
  DEF gads:PTR TO LONG
  DEF cmds:PTR TO stringlist
  
  NEW cmds.stringlist(10)
  self.tempCommands:=cmds
  
  NEW gads[NUM_REXX_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_REXX_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Rexx Setup',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 250,
    WA_MINWIDTH, 250,
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
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDCHILD, self.gadgetList[ REXXGAD_HOSTNAME ]:=StringObject,
          GA_ID, REXXGAD_HOSTNAME,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Host _Name',
        LabelEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ REXXGAD_EXTENSION ]:=StringObject,
          GA_ID, REXXGAD_EXTENSION,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_Extension',
        LabelEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD, self.gadgetList[ REXXGAD_NOSLOT ]:=CheckBoxObject,
            GA_ID, REXXGAD_NOSLOT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'No_Slot',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ REXXGAD_REPLYHOOK ]:=CheckBoxObject,
            GA_ID, REXXGAD_REPLYHOOK,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_ReplyHook',
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
 
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ REXXGAD_OK ]:=ButtonObject,
            GA_ID, REXXGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ REXXGAD_COMMANDS ]:=ButtonObject,
            GA_ID, REXXGAD_COMMANDS,
            GA_TEXT, 'Co_mmands',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ REXXGAD_CANCEL ]:=ButtonObject,
            GA_ID, REXXGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[REXXGAD_COMMANDS]:={editCommands}
  self.gadgetActions[REXXGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[REXXGAD_OK]:=MR_OK
ENDPROC

PROC editCommands(nself,gadget,id,code) OF rexxSettingsForm
  DEF editForm:PTR TO rexxCommandSettingsForm
  DEF res
  self:=nself
  self.setBusy()
  NEW editForm.create()
  res:=editForm.editCommands(self.tempCommands)
  END editForm
  self.clearBusy()
ENDPROC res
  
PROC end() OF rexxSettingsForm
  END self.tempCommands
  END self.gadgetList[NUM_REXX_GADS]
  END self.gadgetActions[NUM_REXX_GADS]
ENDPROC

PROC editSettings(comp:PTR TO rexxObject) OF rexxSettingsForm
  DEF res
  DEF i

  self.rexxObject:=comp
  
  FOR i:=0 TO comp.commands.count()-1 DO self.tempCommands.add(comp.commands.item(i))

  SetGadgetAttrsA(self.gadgetList[ REXXGAD_HOSTNAME ],0,0,[STRINGA_TEXTVAL,comp.hostName,0])
  SetGadgetAttrsA(self.gadgetList[ REXXGAD_EXTENSION ],0,0,[STRINGA_TEXTVAL,comp.extension,0])
  SetGadgetAttrsA(self.gadgetList[ REXXGAD_NOSLOT ],0,0,[CHECKBOX_CHECKED,comp.noSlot,0]) 
  SetGadgetAttrsA(self.gadgetList[ REXXGAD_REPLYHOOK  ],0,0,[CHECKBOX_CHECKED,comp.replyHook,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.hostName,Gets(self.gadgetList[ REXXGAD_HOSTNAME ],STRINGA_TEXTVAL))
    AstrCopy(comp.extension,Gets(self.gadgetList[ REXXGAD_EXTENSION ],STRINGA_TEXTVAL))
    comp.noSlot:=Gets(self.gadgetList[ REXXGAD_NOSLOT ],CHECKBOX_CHECKED)
    comp.replyHook:=Gets(self.gadgetList[ REXXGAD_REPLYHOOK ],CHECKBOX_CHECKED)
    comp.commands.clear()
    FOR i:=0 TO self.tempCommands.count()-1 DO comp.commands.add(self.tempCommands.item(i))

  ENDIF
ENDPROC res=MR_OK


PROC create() OF rexxCommandSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_REXXCMD_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_REXXCMD_GADS]
  self.gadgetActions:=gads
  
  self.browserlist:=browserNodesA([0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Rexx Commands Setup',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 180,
    WA_WIDTH, 250,
    WA_MINWIDTH, 250,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 180,
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

        LAYOUT_ADDCHILD,self.gadgetList[REXXCMDGAD_CMDLIST]:=ListBrowserObject,
              GA_ID, REXXCMDGAD_CMDLIST,
              GA_RELVERIFY, TRUE,
              LISTBROWSER_POSITION, 0,
              LISTBROWSER_COLUMNTITLES, FALSE,
              LISTBROWSER_LABELS, self.browserlist,
        ListBrowserEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ REXXCMDGAD_COMMAND ]:=StringObject,
          GA_ID, REXXCMDGAD_COMMAND,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          STRINGA_MAXCHARS, 80,
        StringEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Co_mmand',
        LabelEnd,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,  self.gadgetList[ REXXCMDGAD_OK ]:=ButtonObject,
            GA_ID, REXXCMDGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ REXXCMDGAD_DELETE ]:=ButtonObject,
            GA_ID, REXXCMDGAD_DELETE,
            GA_TEXT, '_Delete',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_DISABLED, TRUE, 
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ REXXCMDGAD_CANCEL ]:=ButtonObject,
            GA_ID, REXXCMDGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[REXXCMDGAD_CMDLIST]:={selCommand}
  self.gadgetActions[REXXCMDGAD_COMMAND]:={addCommand}
  self.gadgetActions[REXXCMDGAD_DELETE]:={delCommand}
  self.gadgetActions[REXXCMDGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[REXXCMDGAD_OK]:=MR_OK
ENDPROC

PROC selCommand(nself,gadget,id,code) OF rexxCommandSettingsForm
  DEF win
  self:=nself
  self.selectedItem:=code
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  SetGadgetAttrsA(self.gadgetList[REXXCMDGAD_DELETE],win,0,[GA_DISABLED,code=-1, TAG_END])
ENDPROC

PROC addCommand(nself,gadget,id,code) OF rexxCommandSettingsForm
  DEF cmdtext,n,win
  self:=nself
  
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  cmdtext:=Gets(self.gadgetList[ REXXCMDGAD_COMMAND  ],STRINGA_TEXTVAL)

  SetGadgetAttrsA(self.gadgetList[REXXCMDGAD_CMDLIST],win,0,[LISTBROWSER_LABELS, Not(0), TAG_END])

  IF (n:=AllocListBrowserNodeA(1, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, cmdtext, TAG_END]))
    AddTail(self.browserlist, n)
  ELSE 
    Raise("MEM")    
  ENDIF
  SetGadgetAttrsA(self.gadgetList[REXXCMDGAD_COMMAND],win,0,[STRINGA_TEXTVAL, '', TAG_END])

  SetGadgetAttrsA(self.gadgetList[REXXCMDGAD_CMDLIST],win,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
ENDPROC

PROC delCommand(nself,gadget,id,code) OF rexxCommandSettingsForm
  DEF node,win
  self:=nself
  
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  node:=Gets(self.gadgetList[REXXCMDGAD_CMDLIST],LISTBROWSER_SELECTEDNODE)
  remNode(self.gadgetList[REXXCMDGAD_CMDLIST],win,0,node)
  self.selCommand(self,0,0,-1)
  DoMethod(self.windowObj, WM_RETHINK)
  
ENDPROC

PROC editCommands(commands:PTR TO stringlist) OF rexxCommandSettingsForm
  DEF res
  DEF i,n
  DEF node:PTR TO ln
  DEF strval

  SetGadgetAttrsA(self.gadgetList[REXXCMDGAD_CMDLIST],0,0,[LISTBROWSER_LABELS, -1, TAG_END])
  FOR i:=0 TO commands.count()-1
    IF (n:=AllocListBrowserNodeA(1, [LBNA_FLAGS,0, LBNA_COLUMN,0, LBNCA_COPYTEXT, TRUE, LBNCA_TEXT, commands.item(i), TAG_END]))
      AddTail(self.browserlist, n)
    ELSE 
      Raise("MEM")    
    ENDIF
  ENDFOR
  SetGadgetAttrsA(self.gadgetList[REXXCMDGAD_CMDLIST],0,0,[LISTBROWSER_LABELS, self.browserlist, TAG_END])
  self.selCommand(self,0,0,-1)

  res:=self.showModal()
  IF res=MR_OK
    commands.clear()
    node:=self.browserlist.head
    WHILE (node)
      GetListBrowserNodeAttrsA(node,[LBNCA_TEXT,{strval},TAG_END])
      IF strval
        IF StrLen(strval)
          commands.add(strval)
        ENDIF
      ENDIF
      node:=node.succ
    ENDWHILE
  ENDIF
ENDPROC res=MR_OK

PROC end() OF rexxCommandSettingsForm
  freeBrowserNodes(self.browserlist)
  END self.gadgetList[NUM_REXX_GADS]
  END self.gadgetActions[NUM_REXX_GADS]
ENDPROC

EXPORT PROC create(parent) OF rexxObject
  DEF cmds:PTR TO stringlist
  self.type:=TYPE_REXX
  SUPER self.create(parent)
  AstrCopy(self.name,'')
  AstrCopy(self.hostName,'')
  AstrCopy(self.extension,'rexx')
  self.noSlot:=FALSE
  self.replyHook:=FALSE
  NEW cmds.stringlist(10)
  self.commands:=cmds
  self.previewObject:=0
  self.previewChildAttrs:=0
ENDPROC

EXPORT PROC end() OF rexxObject
  END self.commands
  SUPER self.end()
ENDPROC

EXPORT PROC editSettings() OF rexxObject
  DEF editForm:PTR TO rexxSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF rexxObject IS
[
  makeProp(hostName,FIELDTYPE_STR),
  makeProp(extension,FIELDTYPE_STR),
  makeProp(noSlot,FIELDTYPE_CHAR),
  makeProp(replyHook,FIELDTYPE_CHAR),
  makeProp(commands,FIELDTYPE_STRLIST)
]

EXPORT PROC getTypeName() OF rexxObject
  RETURN 'Rexx'
ENDPROC

EXPORT PROC createRexxObject(parent)
  DEF rexx:PTR TO rexxObject
  
  NEW rexx.create(parent)
ENDPROC rexx
