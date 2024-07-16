OPT MODULE,OSVERSION=37

  MODULE 'dos/dos'
  MODULE '*stringlist','*baseStreamer'

EXPORT OBJECT stringStreamer OF baseStreamer
PRIVATE
  data:PTR TO stringlist
  currpos:LONG
ENDOBJECT

PROC create() OF stringStreamer
  DEF str:PTR TO stringlist
  NEW str.stringlist(100)
  self.currpos:=0
  self.data:=str
ENDPROC

PROC end() OF stringStreamer
  END self.data
ENDPROC

PROC clear() OF stringStreamer
  self.data.clear()
  self.currpos:=0
ENDPROC

PROC writeLine(str:PTR TO CHAR) OF stringStreamer
  self.write(str)
  self.currpos:=self.currpos+1
ENDPROC

PROC write(str:PTR TO CHAR) OF stringStreamer
  DEF newval
  IF self.data
    IF self.data.count()>self.currpos
      newval:=String(StrLen(self.data.item(self.currpos))+StrLen(str))
      StrCopy(newval,self.data.item(self.currpos))
      StrAdd(newval,str)
      self.data.setItem(self.currpos,newval)
      DisposeLink(newval)
    ELSE
      self.data.add(str)
    ENDIF
  ENDIF
ENDPROC

PROC readLine(outStr:PTR TO CHAR) OF stringStreamer
  DEF r,l
  IF self.data
    AstrCopy(outStr,self.data.item(self.currpos),200)
    r:=StrLen(outStr)
    self.currpos:=self.currpos+1
  ENDIF
ENDPROC r

PROC reset() OF stringStreamer
  self.currpos:=0
ENDPROC

PROC compareTo(otherStream:PTR TO stringStreamer) OF stringStreamer
  DEF i
  
  IF otherStream.data.count()<>self.data.count()
    RETURN FALSE
  ELSE
    i:=otherStream.data.count()-1
    WHILE (i>=0)
      IF StrCmp(otherStream.data.item(i),self.data.item(i))=FALSE THEN RETURN FALSE
      i--
    ENDWHILE
  ENDIF    
ENDPROC TRUE
