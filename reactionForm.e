OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'classes/window',
        'intuition/gadgetclass',
        'reaction/reaction_lib',
        'gadgets/button',
        'amigalib/boopsi',
        'intuition/intuition'
        
EXPORT ENUM MR_NONE, MR_OK, MR_CANCEL

EXPORT OBJECT reactionForm
  windowObj:LONG
  modalResult:LONG
  gadgetList:PTR TO LONG
  gadgetActions:PTR TO LONG
  hintInfo:PTR TO hintinfo
ENDOBJECT

EXPORT PROC gadgetPress(id,codeval) OF reactionForm
  DEF action,gadget
  IF (action:=self.gadgetActions[id])
    IF (action=MR_OK) OR (action=MR_CANCEL)
      IF self.canClose(action) THEN self.modalResult:=action
    ELSE
      gadget:=self.gadgetList[id]
      action(self,gadget,id,codeval)
    ENDIF
  ENDIF
ENDPROC

EXPORT PROC setBusy() OF reactionForm
  IF self.windowObj THEN Sets(self.windowObj,WA_BUSYPOINTER,TRUE)
ENDPROC

EXPORT PROC clearBusy() OF reactionForm
  IF self.windowObj THEN Sets(self.windowObj,WA_BUSYPOINTER,FALSE)
ENDPROC

EXPORT PROC canClose(modalRes) OF reactionForm IS TRUE
EXPORT PROC ticker() OF reactionForm IS 0
EXPORT PROC menuPick(menu,menuitem,subItem) OF reactionForm IS 0

PROC updateHint(gadid,hintText:PTR TO CHAR) OF reactionForm
  DEF win
  win:=Gets(self.windowObj,WINDOW_WINDOW)

  IF self.hintInfo=0
    self.hintInfo:=New(SIZEOF hintinfo*2)
    self.hintInfo.code:=-1
    self.hintInfo[1].gadgetid:=-1
    self.hintInfo[1].code:=-1
  ENDIF
  self.hintInfo.gadgetid:=gadid

  SetGadgetAttrsA(self.gadgetList[ gadid ],win,0,[BUTTON_TEXTPEN,IF hintText THEN 2 ELSE 1,0])
  self.hintInfo.text:=hintText
  Sets(self.windowObj,WINDOW_HINTINFO,self.hintInfo)
  Sets(self.windowObj,WINDOW_GADGETHELP,TRUE)
ENDPROC

EXPORT PROC showModal() OF reactionForm HANDLE
  DEF running=TRUE,menu,menuitem,subitem
  DEF win:PTR TO window,wsig,code,tmp,sig,result=0
  self.modalResult:=MR_NONE
  IF (win:=RA_OpenWindow(self.windowObj))
    GetAttr( WINDOW_SIGMASK, self.windowObj, {wsig} )

    WHILE running AND (self.modalResult=MR_NONE)
      sig:=Wait(wsig)
      IF (sig AND (wsig))
        
        WHILE ((result:=RA_HandleInput(self.windowObj,{code}+2)) <> WMHI_LASTMSG)
          tmp:=(result AND WMHI_CLASSMASK)
          SELECT tmp
            CASE WMHI_GADGETUP
              self.gadgetPress(result AND $FFFF,code AND $FFFF)
            CASE WMHI_CLOSEWINDOW
              IF self.canClose(MR_CANCEL) THEN running:=FALSE
            CASE WMHI_INTUITICK
              self.ticker()
            CASE WMHI_MENUPICK
              menu:=MENUNUM(result)
              menuitem:=ITEMNUM(result)
              subitem:=SUBNUM(result)
              self.menuPick(menu,menuitem,subitem)
          ENDSELECT
        ENDWHILE
      ENDIF
    ENDWHILE
    RA_CloseWindow(self.windowObj)
  ELSE
    Raise("WIN")
  ENDIF
  
  IF self.hintInfo THEN Dispose(self.hintInfo)
  
EXCEPT DO
ENDPROC self.modalResult
