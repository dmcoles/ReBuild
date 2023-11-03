OPT MODULE,OSVERSION=37

  MODULE 'dos/dos'

EXPORT OBJECT fileStreamer
  fname:PTR TO CHAR
  fh:LONG
ENDOBJECT

PROC create(fn:PTR TO CHAR,mode) OF fileStreamer
  self.fh:=Open(fn,mode)
ENDPROC

PROC end() OF fileStreamer
  IF self.fh<>0 THEN Close(self.fh)
ENDPROC

PROC writeLine(str:PTR TO CHAR) OF fileStreamer
  IF self.fh<>0
    Fwrite(self.fh,str,StrLen(str),1)
    Fwrite(self.fh,'\n',1,1)
  ENDIF
ENDPROC

PROC write(str:PTR TO CHAR) OF fileStreamer
  IF self.fh<>0
    Fwrite(self.fh,str,StrLen(str),1)
  ENDIF
ENDPROC


PROC readLine(outStr:PTR TO CHAR) OF fileStreamer
  DEF r,l
  IF self.fh<>0
    r:=Fgets(self.fh,outStr,200)
    l:=StrLen(outStr)
    IF (l>0) AND (outStr[l-1]="\n") THEN outStr[l-1]:=0
  ENDIF
ENDPROC r
