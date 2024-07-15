  OPT MODULE

  MODULE '*stringlist','*reactionObject','*baseStreamer'

EXPORT OBJECT reactionListObject OF reactionObject
  listnode:LONG
  items:PTR TO stringlist
ENDOBJECT

PROC create(parent) OF reactionListObject
  DEF items:PTR TO stringlist
  self.type:=TYPE_REACTIONLIST

  SUPER self.create(parent)
  NEW items.stringlist(10)
  self.items:=items
ENDPROC

PROC end() OF reactionListObject
  END self.items
  SUPER self.end()
ENDPROC

EXPORT PROC serialise(fser:PTR TO baseStreamer) OF reactionListObject
  DEF tempStr[200]:STRING
  DEF i

  SUPER self.serialise(fser)

  FOR i:=0 TO self.items.count()-1
    StringF(tempStr,'LISTITEM: \s',self.items.item(i))
    fser.writeLine(tempStr)
  ENDFOR
  fser.writeLine('-')
  self.serialiseChildren(fser)
  
ENDPROC

EXPORT PROC deserialise(fser:PTR TO baseStreamer) OF reactionListObject
  DEF tempStr[200]:STRING
  DEF done=FALSE
  DEF i

  SUPER self.deserialise(fser)
  self.items.clear()
  REPEAT
    IF fser.readLine(tempStr)
      IF StrCmp('-',tempStr)
        done:=TRUE
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
