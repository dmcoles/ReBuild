OPT MODULE

  MODULE 'reaction/reaction_macros',
        'classes/window',
        'reaction/reaction_lib',
        'amigalib/boopsi',
        'intuition/intuition'

EXPORT ENUM MR_NONE, MR_OK, MR_CANCEL

EXPORT OBJECT reactionForm
  windowObj:LONG
  modalResult:LONG
  gadgetList:PTR TO LONG
  gadgetActions:PTR TO LONG
ENDOBJECT

EXPORT PROC gadgetPress(id,code) OF reactionForm
  DEF action,gadget
  WriteF('press id =\d code=\d\n',id,code)
  IF (action:=self.gadgetActions[id])
    WriteF('do action\n')
    IF (action=MR_OK) OR (action=MR_CANCEL)
      self.modalResult:=action
    ELSE
      gadget:=self.gadgetList[id]
      action(self,gadget,id,code)
    ENDIF
  ENDIF
ENDPROC

EXPORT PROC canClose() OF reactionForm IS TRUE
EXPORT PROC ticker() OF reactionForm IS 0
EXPORT PROC menuPick(menu,menuitem,subItem) OF reactionForm IS 0

EXPORT PROC showModal() OF reactionForm HANDLE
  DEF running=TRUE,menu,menuitem,subitem
  DEF win:PTR TO window,wsig,code,tmp,sig,result
  self.modalResult:=MR_NONE
  IF (win:=RA_OpenWindow(self.windowObj))
    GetAttr( WINDOW_SIGMASK, self.windowObj, {wsig} )

    WHILE running AND (self.modalResult=MR_NONE)
      sig:=Wait(wsig)
      IF (sig AND (wsig))
        WHILE ((result:=RA_HandleInput(self.windowObj,{code})) <> WMHI_LASTMSG)
          tmp:=(result AND WMHI_CLASSMASK)
          SELECT tmp
            CASE WMHI_GADGETUP
              self.gadgetPress(result AND $FFFF,Shr(code,16))
            CASE WMHI_CLOSEWINDOW
              IF self.canClose() THEN running:=FALSE
            CASE WMHI_CLOSEWINDOW
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
  
EXCEPT DO
ENDPROC self.modalResult
