  OPT MODULE

  MODULE '*stringlist','*reactionObject','*fileStreamer'

EXPORT OBJECT reactionListObject OF reactionObject
  listnode:LONG
  chooser:CHAR
  clicktab:CHAR
  listbrowser:CHAR
  radiobutton:CHAR
  items:PTR TO stringlist
ENDOBJECT

PROC create(parent) OF reactionListObject
  DEF items:PTR TO stringlist
  self.type:=TYPE_REACTIONLIST

  SUPER self.create(parent)
  NEW items.stringlist(10)
  self.items:=items
  WriteF('new list=\h\n',self)
  WriteF('new list items=\h\n',self.items)
ENDPROC

PROC end() OF reactionListObject
  END self.items
ENDPROC

EXPORT PROC serialise(fser:PTR TO fileStreamer) OF reactionListObject
  DEF tempStr[200]:STRING
  DEF i

  SUPER self.serialise(fser)

  StringF(tempStr,'CHOOSER: \d',self.chooser)
  fser.writeLine(tempStr)
  StringF(tempStr,'CLICKTAB: \d',self.clicktab)
  fser.writeLine(tempStr)
  StringF(tempStr,'LISTBROWSER: \d',self.listbrowser)
  fser.writeLine(tempStr)
  StringF(tempStr,'RADIOBUTTON: \d',self.radiobutton)
  fser.writeLine(tempStr)
  FOR i:=0 TO self.items.count()-1
    StringF(tempStr,'LISTITEM: \s',self.items.item(i))
    fser.writeLine(tempStr)
  ENDFOR
  fser.writeLine('-')
  self.serialiseChildren(fser)
  
ENDPROC

EXPORT PROC deserialise(fser:PTR TO fileStreamer) OF reactionListObject
  DEF tempStr[200]:STRING
  DEF done=FALSE
  DEF i

  SUPER self.deserialise(fser)
  self.items.clear()
  REPEAT
    IF fser.readLine(tempStr)
      IF StrCmp('-',tempStr)
        done:=TRUE
      ELSEIF StrCmp('CHOOSER: ',tempStr,STRLEN)
        self.chooser:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('CLICKTAB: ',tempStr,STRLEN)
        self.clicktab:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('LISTBROWSER: ',tempStr,STRLEN)
        self.listbrowser:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('RADIOBUTTON: ',tempStr,STRLEN)
        self.radiobutton:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('LISTITEM: ',tempStr,STRLEN)
        self.items.add(tempStr+STRLEN)
      ENDIF
    ELSE
      done:=TRUE
    ENDIF
  UNTIL done  
ENDPROC


EXPORT PROC getTypeName() OF reactionListObject
  RETURN 'ReactionList'
ENDPROC

EXPORT PROC createReactionListObject(parent)
  DEF list:PTR TO reactionListObject
  
  NEW list.create(parent)
ENDPROC list
