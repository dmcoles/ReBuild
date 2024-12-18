
OPT MODULE

  MODULE 'gadgets/layout','gadgets/virtual'

  MODULE '*baseStreamer','*stringlist'

EXPORT ENUM NONE, ESOURCE_GEN, CSOURCE_GEN

EXPORT OBJECT srcGen
  type:INT
  fser:PTR TO baseStreamer
  libsused:PTR TO CHAR
  stringDelimiter:CHAR
  orOperator:PTR TO CHAR
  extraPadding:CHAR
  upperCaseProperties:CHAR
  terminator:CHAR
  assignChars[10]:ARRAY OF CHAR
  indent:INT
  definitionOnly:CHAR
  useIds:CHAR
  useMacros:CHAR
  currentGadgetVar:INT
ENDOBJECT

PROC create(fser:PTR TO baseStreamer,libsused:PTR TO CHAR,definitionOnly,useIds,useMacros) OF srcGen
  self.type:=NONE
  self.fser:=fser
  self.libsused:=libsused
  self.stringDelimiter:=34
  self.orOperator:='|'
  AstrCopy(self.assignChars,'=')
  self.extraPadding:=TRUE
  self.upperCaseProperties:=FALSE
  self.terminator:=";"
  self.indent:=0
  self.definitionOnly:=definitionOnly
  self.useIds:=useIds
  self.useMacros:=useMacros
  self.currentGadgetVar:=0
ENDPROC

PROC genIndent() OF srcGen
  DEF str,i
  IF self.indent=0 THEN RETURN
  str:=String(self.indent)
  FOR i:=0 TO self.indent-1 DO str[i]:=32
  SetStr(str,self.indent)
  self.fser.write(str)
  DisposeLink(str)
ENDPROC

PROC writeLine(str:PTR TO CHAR,indent=TRUE) OF srcGen
  IF indent THEN self.genIndent()
  self.fser.writeLine(str)
ENDPROC

PROC write(str:PTR TO CHAR) OF srcGen
  self.fser.write(str)
ENDPROC

PROC increaseIndent() OF srcGen IS self.indent+=2

PROC decreaseIndent() OF srcGen IS self.indent-=2

PROC componentCreate(name:PTR TO CHAR) OF srcGen
  self.writeLine(name,FALSE)
  self.increaseIndent()
ENDPROC

PROC componentLibnameCreate(libname:PTR TO CHAR) OF srcGen
ENDPROC

PROC componentLibtypeCreate(libname:PTR TO CHAR) OF srcGen
ENDPROC

PROC componentProperty(propName:PTR TO CHAR, propValue:PTR TO CHAR, isString) OF srcGen
  DEF str,count=0,i
  FOR i:=0 TO StrLen(propValue)-1 DO IF propValue[i]=self.stringDelimiter THEN count++

  str:=String(StrLen(propName)+StrLen(propValue)+5+count)
  StrCopy(str,propName)
  IF self.upperCaseProperties THEN UpperStr(str)
  StrAdd(str,', ')
  IF isString THEN StrAddChar(str,self.stringDelimiter)
  FOR i :=0 TO StrLen(propValue)-1
    IF (propValue[i]=self.stringDelimiter) AND isString
      IF self.type=ESOURCE_GEN
        StrAdd(str,'\\a')
      ELSEIF self.type=CSOURCE_GEN
        StrAdd(str,'\\"')
      ENDIF
    ELSE
      StrAddChar(str,propValue[i])
    ENDIF
  ENDFOR
  IF isString THEN StrAddChar(str,self.stringDelimiter)
  StrAdd(str,',')
  self.writeLine(str)
  DisposeLink(str)
ENDPROC

PROC componentPropertyCreate(propName:PTR TO CHAR, libType:PTR TO CHAR) OF srcGen
ENDPROC

PROC componentPropertyInt(propName:PTR TO CHAR, propValue:LONG) OF srcGen
  DEF str
  DEF propValueStr[10]:STRING
  
  StringF(propValueStr,'\d',propValue)
  
  str:=String(StrLen(propName)+StrLen(propValueStr)+5)
  StrCopy(str,propName)
  IF self.upperCaseProperties THEN UpperStr(str)
  StrAdd(str,', ')
  StrAdd(str,propValueStr)
  StrAdd(str,',')
  self.writeLine(str)
  DisposeLink(str)
ENDPROC

PROC componentPropertyListOr(propName:PTR TO CHAR, propValues:PTR TO stringlist) OF srcGen
  DEF str,totlen,i
  DEF propValueStr
  
  totlen:=0
  FOR i:=0 TO propValues.count()-1
    totlen:=totlen+EstrLen(propValues.item(i))
    totlen:=totlen+2+StrLen(self.orOperator)
  ENDFOR

  propValueStr:=String(totlen)  
  FOR i:=0 TO propValues.count()-1
    IF i<>0 
      StrAdd(propValueStr,' ')
      StrAdd(propValueStr,self.orOperator)
      StrAdd(propValueStr,' ')
    ENDIF
    StrAdd(propValueStr,propValues.item(i))
  ENDFOR
  
  str:=String(StrLen(propName)+StrLen(propValueStr)+5)
  StrCopy(str,propName)
  IF self.upperCaseProperties THEN UpperStr(str)
  StrAdd(str,', ')
  StrAdd(str,propValueStr)
  StrAdd(str,',')
  self.writeLine(str)
  DisposeLink(str)
  DisposeLink(propValueStr)
ENDPROC

PROC componentEnd(name:PTR TO CHAR) OF srcGen
  self.decreaseIndent()
  self.writeLine(name)
ENDPROC

PROC componentEndNoMacro(addComma) OF srcGen
  self.decreaseIndent()
  IF addComma
    self.writeLine('TAG_END),')
  ELSE
    self.writeLine('TAG_END)')
  ENDIF
ENDPROC

PROC finalComponentEnd(name:PTR TO CHAR) OF srcGen
  self.decreaseIndent()
  self.genIndent()
  IF StrLen(name) AND (self.useMacros)
    self.write(name)
  ELSE
    self.write('TAG_END)')
  ENDIF
  self.addTerminator()
  self.writeLine('')
ENDPROC

PROC componentAddChildLabel(text) OF srcGen
  DEF tempStr[60]:STRING
  IF StrLen(text)>0
    StrCopy(tempStr,'CHILD_Label, ')
    IF self.upperCaseProperties THEN UpperStr(tempStr)
    IF self.useMacros
      StrAdd(tempStr,'LabelObject,')
    ELSE
      StrAdd(tempStr,'NewObject( LABEL_GetClass(), NULL, ')
    ENDIF
    self.writeLine(tempStr)
    self.increaseIndent()
    self.componentProperty('LABEL_Text',text,TRUE)
    IF self.useMacros
      self.decreaseIndent()
      self.writeLine('LabelEnd,')
    ELSE
      self.componentEndNoMacro(TRUE)
    ENDIF
  ENDIF
ENDPROC

PROC componentAddChild(addChildTag) OF srcGen
  DEF tempStr[20]:STRING
  self.genIndent()
  
  IF addChildTag=LAYOUT_ADDCHILD
    StrCopy(tempStr,'LAYOUT_AddChild, ')
  ELSEIF addChildTag=PAGE_ADD
    StrCopy(tempStr,'PAGE_Add, ')
  ELSEIF addChildTag=VIRTUALA_CONTENTS
    StrCopy(tempStr,'VIRTUALA_Contents, ')
  ELSE
    StrCopy(tempStr,'LAYOUT_AddChild, ')
  ENDIF
  
  IF self.upperCaseProperties THEN UpperStr(tempStr)
  self.write(tempStr)
ENDPROC

PROC componentAddImage(addImageTag) OF srcGen
  DEF tempStr[20]:STRING
  self.genIndent()

  IF addImageTag=LAYOUT_ADDIMAGE
    StrCopy(tempStr,'LAYOUT_AddImage, ')
  ELSEIF addImageTag=PAGE_ADD
    StrCopy(tempStr,'PAGE_Add, ')
  ELSEIF addImageTag=VIRTUALA_CONTENTS
    StrCopy(tempStr,'VIRTUALA_Contents, ')
  ELSE
    StrCopy(tempStr,'LAYOUT_AddImage, ')
  ENDIF
  IF self.upperCaseProperties THEN UpperStr(tempStr)
  self.write(tempStr)
ENDPROC

PROC assignWindowVar() OF srcGen
  DEF tempStr[50]:STRING
  DEF padding
  self.genIndent()
  IF self.extraPadding THEN padding:=' ' ELSE padding:=''
  StringF(tempStr,'window_object\s\s\s',padding,self.assignChars,padding)
  self.write(tempStr)
ENDPROC

PROC assignGadgetVar(ident,index) OF srcGen
  DEF tempStr[100]:STRING
  DEF padding
  IF self.extraPadding THEN padding:=' ' ELSE padding:=''
  StringF(tempStr,'main_Gadgets[\s\d\s]\s\s\s',padding,index,padding,padding,self.assignChars,padding)
  self.write(tempStr)
  self.currentGadgetVar:=index
ENDPROC

PROC componentPropertyGadgetId(idval) OF srcGen
ENDPROC

PROC addTerminator() OF srcGen
  DEF tempStr[10]:STRING
  IF self.terminator 
    StrCopy(tempStr,'')
    StrAddChar(tempStr,self.terminator)
    self.write(tempStr)
  ENDIF
ENDPROC

PROC genHeader(screenObject,rexxObject,requesterObject, windowItems, windowLayouts, sharedport) OF srcGen IS -1
PROC genFooter(windowObject,rexxObject) OF srcGen IS -1
PROC genWindowHeader(count, windowObject, menuObject, layoutObject, reactionLists) OF srcGen IS -1
PROC genWindowFooter(count, windowObject, menuObject, layoutObject, reactionLists) OF srcGen IS -1
PROC setIcaMap(header,mapText,mapSource,mapTarget) OF srcGen IS -1