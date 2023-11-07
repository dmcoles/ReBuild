OPT MODULE, OSVERSION=37

   MODULE 'requester','classes/requester','intuition/intuition','classes/window'

EXPORT PROC warnRequest(windowObj,title,bodytext,yesno=FALSE)
  DEF reqmsg:PTR TO orrequest
  DEF reqobj
  DEF res=0
  DEF win
  
  Sets(windowObj,WA_BUSYPOINTER,TRUE)
  win:=Gets(windowObj,WINDOW_WINDOW)
  
  NEW reqmsg
  reqmsg.methodid:=RM_OPENREQ
  reqmsg.window:=win
  reqmsg.attrs:=[REQ_TYPE, REQTYPE_INFO, REQ_IMAGE, REQIMAGE_WARNING, REQ_TITLETEXT,title,REQ_BODYTEXT,bodytext,REQ_GADGETTEXT,IF yesno THEN '_Yes|_No' ELSE '_Ok|_Cancel',TAG_END]
  reqobj:=NewObjectA(Requester_GetClass(),0,[TAG_END])
  IF reqobj
    res:=DoMethodA(reqobj, reqmsg)
    DisposeObject(reqobj)
  ENDIF
  END reqmsg
  Sets(windowObj,WA_BUSYPOINTER,FALSE)
ENDPROC res

EXPORT PROC errorRequest(windowObj,title,bodytext)
  DEF reqmsg:PTR TO orrequest
  DEF reqobj
  DEF res=0
  DEF win
  
  Sets(windowObj,WA_BUSYPOINTER,TRUE)
  win:=Gets(windowObj,WINDOW_WINDOW)

  NEW reqmsg
  reqmsg.methodid:=RM_OPENREQ
  reqmsg.window:=win
  reqmsg.attrs:=[REQ_TYPE, REQTYPE_INFO, REQ_IMAGE, REQIMAGE_ERROR, REQ_TITLETEXT,title,REQ_BODYTEXT,bodytext,REQ_GADGETTEXT,'_Ok',TAG_END]
  reqobj:=NewObjectA(Requester_GetClass(),0,[TAG_END])
  IF reqobj
    res:=DoMethodA(reqobj, reqmsg)
    DisposeObject(reqobj)
  ENDIF
  END reqmsg
  Sets(windowObj,WA_BUSYPOINTER,FALSE)
ENDPROC
