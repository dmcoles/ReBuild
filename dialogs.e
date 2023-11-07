OPT MODULE, OSVERSION=37

   MODULE 'requester','classes/requester'

EXPORT PROC warnRequest(win,title,bodytext,yesno=FALSE)
  DEF reqmsg:PTR TO orrequest
  DEF reqobj
  DEF res=0
  
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
ENDPROC res

EXPORT PROC errorRequest(win,title,bodytext)
  DEF reqmsg:PTR TO orrequest
  DEF reqobj
  DEF res=0
  
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
ENDPROC
