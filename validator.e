OPT MODULE, OSVERSION=37

  MODULE 'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*stringlist','*dialogs'

//access to main rebuild object list
EXPORT DEF objectList:PTR TO stdlist


EXPORT PROC checkIdent(form:PTR TO reactionForm, editComp:PTR TO reactionObject, id)
  DEF str:PTR TO CHAR
  DEF comp:PTR TO reactionObject
  DEF i
  str:=Gets(form.gadgetList[ id ],STRINGA_TEXTVAL)
  
  IF StrLen(str)=0
    errorRequest(form.windowObj,'Error','The identifer cannot be blank')
    RETURN FALSE
  ENDIF
  
  FOR i:=0 TO StrLen(str)-1
    IF (str[i]==["_","a" TO "z","A" TO "Z","0" TO "9"])=FALSE
      errorRequest(form.windowObj,'Error','The identifer is not valid (A-Z, 0-9 and _)')
      RETURN FALSE
    ENDIF
  ENDFOR
  
  IF objectList
    FOR i:=0 TO objectList.count()-1
      comp:=objectList.item(i)
      IF comp
        IF StrCmp(comp.ident,str) AND (editComp<>comp)
          errorRequest(form.windowObj,'Error','The identifer is already used')
          RETURN FALSE
        ENDIF
      ENDIF
    ENDFOR
  ENDIF

ENDPROC TRUE
