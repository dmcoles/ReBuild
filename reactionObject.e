OPT MODULE,OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'gadtools',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*stringlist','*reactionForm','*fileStreamer','*sourceGen'

EXPORT ENUM TYPE_REACTIONLIST,TYPE_SCREEN,TYPE_REXX, TYPE_WINDOW, TYPE_MENU, 
            TYPE_BUTTON, TYPE_BITMAP, TYPE_CHECKBOX, TYPE_CHOOSER, 
            TYPE_CLICKTAB, TYPE_FUELGAUGE, TYPE_GETFILE, TYPE_GETFONT,
            TYPE_GETSCREENMODE, TYPE_INTEGER, TYPE_PALETTE, TYPE_PENMAP,
            TYPE_LAYOUT, TYPE_LISTBROWSER, TYPE_RADIO, TYPE_SCROLLER,
            TYPE_SPEEDBAR, TYPE_SLIDER, TYPE_STATUSBAR, TYPE_STRING,
            TYPE_SPACE, TYPE_TEXTFIELD, TYPE_BEVEL, TYPE_DRAWLIST,
            TYPE_GLYPH, TYPE_LABEL
         
EXPORT ENUM CHIGAD_MINWIDTH, CHIGAD_MINHEIGHT, CHIGAD_MAXWIDTH, CHIGAD_MAXHEIGHT,
      CHIGAD_WEIGHTEDWIDTH, CHIGAD_WEIGHTEDHEIGHT, CHIGAD_SCALEWIDTH, CHIGAD_SCALEHEIGHT,
      CHIGAD_NOMINALSIZE, CHIGAD_WEIGHTMINIMUM, CHIGAD_CACHEDOMAIN, CHIGAD_NODISPOSE,
      CHIGAD_OK, CHIGAD_CANCEL

EXPORT SET LIB_BUTTON, LIB_CHECKBOX, LIB_CHOOSER, LIB_CLICKTAB, LIB_FUELGAUGE, LIB_GETFILE,
            LIB_GETFONT, LIB_GETSCREEN, LIB_INTEGER, LIB_PALETTE, LIB_LISTB,
            LIB_RADIO, LIB_SCROLLER, LIB_STRING, LIB_SPACE, LIB_TEXTFIELD,
            LIB_BEVEL, LIB_DRAWLIST, LIB_GLYPH, LIB_LABEL

EXPORT ENUM FIELDTYPE_CHAR=1, FIELDTYPE_INT=2, FIELDTYPE_LONG=3, FIELDTYPE_STR=4, FIELDTYPE_STRLIST=5, FIELDTYPE_INTLIST=6

CONST NUM_CHI_GADS=CHIGAD_CANCEL+1

DEF objCount

EXPORT OBJECT reactionObject
  name[80]:ARRAY OF CHAR
  parent:PTR TO reactionObject
  children:PTR TO stdlist
  libused:LONG
  type:INT
  id:INT
  minWidth:LONG
  minHeight:LONG
  maxWidth:LONG
  maxHeight:LONG
  weightedWidth:LONG
  weightedHeight:LONG
  scaleWidth:LONG
  scaleHeight:LONG
  nominalSize:CHAR
  weightMinimum:CHAR
  cacheDomain:CHAR
  noDispose:CHAR
  
  tempParentId:INT
  drawInfo:LONG
  visInfo:LONG
  previewObject:LONG
  previewChildAttrs:LONG
ENDOBJECT

OBJECT childSettingsForm OF reactionForm
  childObject:PTR TO reactionObject
ENDOBJECT

PROC create() OF childSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_CHI_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_CHI_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'Label Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
    WA_PUBSCREEN, 0,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_NOCAREREFRESH, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,

    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_BOTTOMSPACING, 2,
        LAYOUT_TOPSPACING, 2,
        LAYOUT_LEFTSPACING, 2,
        LAYOUT_RIGHTSPACING, 2,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,
        LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
        LAYOUT_VERTALIGNMENT, LALIGN_TOP,
        LAYOUT_BEVELSTATE, IDS_SELECTED,
        LAYOUT_FIXEDHORIZ, TRUE,
        LAYOUT_FIXEDVERT, TRUE,
        LAYOUT_SHRINKWRAP, TRUE,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,
          LAYOUT_EVENSIZE, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_MINWIDTH ]:=IntegerObject,
            GA_ID, CHIGAD_MINWIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, -1,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MinWidth',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_MINHEIGHT ]:=IntegerObject,
            GA_ID, CHIGAD_MINHEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, -1,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MinHeight',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_MAXWIDTH ]:=IntegerObject,
            GA_ID, CHIGAD_MAXWIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, -1,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MaxWidth',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_MAXHEIGHT ]:=IntegerObject,
            GA_ID, CHIGAD_MAXHEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, -1,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'MaxHeight',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,
          LAYOUT_EVENSIZE, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_WEIGHTEDWIDTH ]:=IntegerObject,
            GA_ID, CHIGAD_WEIGHTEDWIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 3,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 100,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'WeightedWidth',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_WEIGHTEDHEIGHT ]:=IntegerObject,
            GA_ID, CHIGAD_WEIGHTEDHEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 3,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 100,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'WeightedHeight',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_SCALEWIDTH ]:=IntegerObject,
            GA_ID, CHIGAD_SCALEWIDTH,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'ScaleWidth',
          LabelEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_SCALEHEIGHT ]:=IntegerObject,
            GA_ID, CHIGAD_SCALEHEIGHT,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            INTEGER_MAXCHARS, 4,
            INTEGER_MINIMUM, 0,
            INTEGER_MAXIMUM, 9999,
          IntegerEnd,
          CHILD_LABEL, LabelObject,
            LABEL_TEXT, 'ScaleHeight',
          LabelEnd,
        LayoutEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD, self.gadgetList[ CHIGAD_NOMINALSIZE ]:=CheckBoxObject,
            GA_ID, CHIGAD_NOMINALSIZE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_NominalSize',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ CHIGAD_WEIGHTMINIMUM ]:=CheckBoxObject,
            GA_ID, CHIGAD_WEIGHTMINIMUM,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_WeightMinimum',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ CHIGAD_CACHEDOMAIN ]:=CheckBoxObject,
            GA_ID, CHIGAD_CACHEDOMAIN,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, '_CacheDomain',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,

          LAYOUT_ADDCHILD, self.gadgetList[ CHIGAD_NODISPOSE ]:=CheckBoxObject,
            GA_ID, CHIGAD_NODISPOSE,
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            GA_TEXT, 'No_Dispose',
            CHECKBOX_TEXTPEN, 1,
            CHECKBOX_BACKGROUNDPEN, 0,
            CHECKBOX_FILLTEXTPEN, 1,
            CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
          CheckBoxEnd,
        LayoutEnd,
 
        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_DEFERLAYOUT, FALSE,
          LAYOUT_SPACEOUTER, FALSE,
          LAYOUT_BOTTOMSPACING, 2,
          LAYOUT_TOPSPACING, 2,
          LAYOUT_LEFTSPACING, 2,
          LAYOUT_RIGHTSPACING, 2,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,
          LAYOUT_HORIZALIGNMENT, LALIGN_LEFT,
          LAYOUT_VERTALIGNMENT, LALIGN_TOP,
          LAYOUT_BEVELSTATE, IDS_SELECTED,
          LAYOUT_FIXEDHORIZ, TRUE,
          LAYOUT_FIXEDVERT, TRUE,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_OK ]:=ButtonObject,
            GA_ID, CHIGAD_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,

          LAYOUT_ADDCHILD,  self.gadgetList[ CHIGAD_CANCEL ]:=ButtonObject,
            GA_ID, CHIGAD_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
            BUTTON_TEXTPEN, 1,
            BUTTON_BACKGROUNDPEN, 0,
            BUTTON_FILLTEXTPEN, 1,
            BUTTON_FILLPEN, 3,
            BUTTON_BEVELSTYLE, BVS_BUTTON,
            BUTTON_JUSTIFICATION, BCJ_CENTER,
          ButtonEnd,
        LayoutEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[CHIGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[CHIGAD_OK]:=MR_OK
ENDPROC

PROC end() OF childSettingsForm
  END self.gadgetList[NUM_CHI_GADS]
  END self.gadgetActions[NUM_CHI_GADS]
ENDPROC

PROC editSettings(comp:PTR TO reactionObject) OF childSettingsForm
  DEF res

  SetGadgetAttrsA(self.gadgetList[ CHIGAD_MINWIDTH ],0,0,[INTEGER_NUMBER,comp.minWidth,0])
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_MINHEIGHT ],0,0,[INTEGER_NUMBER,comp.minHeight,0])
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_MAXWIDTH ],0,0,[INTEGER_NUMBER,comp.maxWidth,0])
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_MAXHEIGHT ],0,0,[INTEGER_NUMBER,comp.maxHeight,0])
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_WEIGHTEDWIDTH ],0,0,[INTEGER_NUMBER,comp.weightedWidth,0])
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_WEIGHTEDHEIGHT ],0,0,[INTEGER_NUMBER,comp.weightedHeight,0])
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_SCALEWIDTH ],0,0,[INTEGER_NUMBER,comp.scaleWidth,0])
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_SCALEHEIGHT ],0,0,[INTEGER_NUMBER,comp.scaleHeight,0])

  SetGadgetAttrsA(self.gadgetList[ CHIGAD_NOMINALSIZE ],0,0,[CHECKBOX_CHECKED,comp.nominalSize,0]) 
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_WEIGHTMINIMUM ],0,0,[CHECKBOX_CHECKED,comp.weightMinimum,0]) 
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_CACHEDOMAIN ],0,0,[CHECKBOX_CHECKED,comp.cacheDomain,0]) 
  SetGadgetAttrsA(self.gadgetList[ CHIGAD_NODISPOSE ],0,0,[CHECKBOX_CHECKED,comp.noDispose,0]) 

  res:=self.showModal()
  IF res=MR_OK
    comp.minWidth:=Gets(self.gadgetList[ CHIGAD_MINWIDTH ],INTEGER_NUMBER)
    comp.minHeight:=Gets(self.gadgetList[ CHIGAD_MINHEIGHT ],INTEGER_NUMBER)
    comp.maxWidth:=Gets(self.gadgetList[ CHIGAD_MAXWIDTH ],INTEGER_NUMBER)
    comp.maxHeight:=Gets(self.gadgetList[ CHIGAD_MAXHEIGHT ],INTEGER_NUMBER)
    comp.weightedWidth:=Gets(self.gadgetList[ CHIGAD_WEIGHTEDWIDTH ],INTEGER_NUMBER)
    comp.weightedHeight:=Gets(self.gadgetList[ CHIGAD_WEIGHTEDHEIGHT ],INTEGER_NUMBER)
    comp.scaleWidth:=Gets(self.gadgetList[ CHIGAD_SCALEWIDTH ],INTEGER_NUMBER)
    comp.scaleHeight:=Gets(self.gadgetList[ CHIGAD_SCALEHEIGHT ],INTEGER_NUMBER)
    comp.nominalSize:=Gets(self.gadgetList[ CHIGAD_NOMINALSIZE ],CHECKBOX_CHECKED)
    comp.weightMinimum:=Gets(self.gadgetList[ CHIGAD_WEIGHTMINIMUM ],CHECKBOX_CHECKED)
    comp.cacheDomain:=Gets(self.gadgetList[ CHIGAD_CACHEDOMAIN ],CHECKBOX_CHECKED)
    comp.noDispose:=Gets(self.gadgetList[ CHIGAD_NODISPOSE ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC create(parent) OF reactionObject
  DEF stdlist:PTR TO stdlist
  DEF name[80]:STRING
  DEF scr
  self.parent:=parent
  self.id:=objCount
  objCount:=objCount+1
  StringF(name,'\s_\d',self.getTypeName(),self.id)
  AstrCopy(self.name,name)

  NEW stdlist.stdlist(20)
  self.children:=stdlist

  self.minWidth:=-1
  self.minHeight:=-1
  self.maxWidth:=-1
  self.maxHeight:=-1
  self.weightedWidth:=100
  self.weightedHeight:=100
  self.scaleWidth:=0
  self.scaleHeight:=0
  self.nominalSize:=0
  self.weightMinimum:=0
  self.cacheDomain:=TRUE
  self.noDispose:=0
  
  self.tempParentId:=-1
  self.previewObject:=0
  self.previewChildAttrs:=0

  scr:=LockPubScreen(NIL)
  self.drawInfo:=GetScreenDrawInfo(scr)
  self.visInfo:=GetVisualInfoA(scr,[TAG_END])
  UnlockPubScreen(NIL,scr)
ENDPROC

EXPORT PROC end() OF reactionObject
  DEF i,scr
  DEF child:PTR TO reactionObject
  FOR i:=0 TO self.children.count()-1
    child:=self.children.item(i)
    END child
  ENDFOR
  END self.children
  IF self.previewObject THEN DisposeObject(self.previewObject)
  IF self.previewChildAttrs THEN DisposeObject(self.previewChildAttrs)
  IF self.drawInfo
    scr:=LockPubScreen(NIL)
    FreeScreenDrawInfo(scr,self.drawInfo)
    UnlockPubScreen(NIL,scr)
  ENDIF
  IF self.visInfo THEN FreeVisualInfo(self.visInfo)
    
ENDPROC

EXPORT PROC createPreviewObject() OF reactionObject IS -1

EXPORT PROC getTypeName() OF reactionObject
  RETURN ''
ENDPROC

EXPORT PROC getTypeEndName() OF reactionObject
  RETURN ''
ENDPROC

EXPORT PROC getChildIndex() OF reactionObject
  DEF i
  IF self.parent=0 THEN RETURN -1
  FOR i:=0 TO self.parent.children.count()-1 DO IF self.parent.children.item(i)=self THEN RETURN i
ENDPROC -1

EXPORT PROC addChild(child:PTR TO reactionObject) OF reactionObject
  self.children.add(child)
  child.parent:=self
ENDPROC

EXPORT PROC removeChild(child:PTR TO reactionObject) OF reactionObject
  DEF i
  i:=self.children.count()-1
  WHILE i>=0
    IF self.children.item(i)=child 
      child.parent:=0
      self.children.remove(i)
    ENDIF
    i--
  ENDWHILE
ENDPROC

EXPORT PROC swapChildren(i1,i2) OF reactionObject
  DEF tmp
  tmp:=self.children.item(i1)
  self.children.setItem(i1,self.children.item(i2))
  self.children.setItem(i2,tmp)
ENDPROC

EXPORT PROC editSettings() OF reactionObject IS -1

EXPORT PROC editChildSettings() OF reactionObject
  DEF editForm:PTR TO childSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

EXPORT PROC serialiseData() OF reactionObject IS []

EXPORT PROC serialise(fser:PTR TO fileStreamer) OF reactionObject
  DEF tempStr[200]:STRING
  DEF tempStr2[200]:STRING
  DEF list:PTR TO LONG,i,j,count
  DEF strlist:PTR TO stringlist
  DEF intlist:PTR TO stdlist
  DEF fieldname,fieldtype,fieldptr
  DEF childcomp:PTR TO reactionObject


  StringF(tempStr,'TYPE: \d',self.type)  
  fser.writeLine(tempStr)
  StringF(tempStr,'ID: \d',self.id)
  fser.writeLine(tempStr)
  IF self.parent
    StringF(tempStr,'PARENTID: \d',self.parent.id)
  ELSE
    StrCopy(tempStr,'PARENTID:')
  ENDIF
  
  fser.writeLine(tempStr)
  StringF(tempStr,'NAME: \s',self.name)
  fser.writeLine(tempStr)
  StringF(tempStr,'MINWIDTH: \d',self.minWidth)
  fser.writeLine(tempStr)
  StringF(tempStr,'MINHEIGHT: \d',self.minHeight)
  fser.writeLine(tempStr)
  StringF(tempStr,'MAXWIDTH: \d',self.maxWidth)
  fser.writeLine(tempStr)
  StringF(tempStr,'MAXHEIGHT: \d',self.maxHeight)
  fser.writeLine(tempStr)
  StringF(tempStr,'WEIGHTEDWIDTH: \d',self.weightedWidth)
  fser.writeLine(tempStr)
  StringF(tempStr,'WEIGHTEDHEIGHT: \d',self.weightedHeight)
  fser.writeLine(tempStr)
  StringF(tempStr,'SCALEWIDTH: \d',self.scaleWidth)
  fser.writeLine(tempStr)
  StringF(tempStr,'SCALEHEIGHT: \d',self.scaleHeight)
  fser.writeLine(tempStr)
  StringF(tempStr,'NOMINALSIZE: \d',self.nominalSize)
  fser.writeLine(tempStr)
  StringF(tempStr,'WEIGHTMINIMUM: \d',self.weightMinimum)
  fser.writeLine(tempStr)
  StringF(tempStr,'CACHEDOMAIN: \d',self.cacheDomain)
  fser.writeLine(tempStr)
  StringF(tempStr,'NODISPOSE: \d',self.noDispose)
  fser.writeLine(tempStr)
  fser.writeLine('--')
  
  list:=self.serialiseData()
  count:=ListLen(list)
  IF count>0
    i:=0
    WHILE i<count
      fieldname:=list[i++]
      IF fieldname
        StrCopy(tempStr,fieldname)
        StrAdd(tempStr,': ')
        UpperStr(tempStr)
        fieldptr:=list[i++]
        IF fieldptr
          fieldtype:=list[i++]
          SELECT fieldtype
            CASE FIELDTYPE_CHAR
              StringF(tempStr2,'\s\d',tempStr,Char(fieldptr))
              fser.writeLine(tempStr2)
            CASE FIELDTYPE_INT
              StringF(tempStr2,'\s\d',tempStr,Int(fieldptr))
              fser.writeLine(tempStr2)
            CASE FIELDTYPE_LONG
              StringF(tempStr2,'\s\d',tempStr,Long(fieldptr))
              fser.writeLine(tempStr2)
            CASE FIELDTYPE_STR
              StringF(tempStr2,'\s\s',tempStr,fieldptr)
              fser.writeLine(tempStr2)
            CASE FIELDTYPE_STRLIST
              strlist:=Long(fieldptr)
              FOR j:=0 TO strlist.count()-1
                StringF(tempStr2,'\s\s',tempStr,strlist.item(j))
                fser.writeLine(tempStr2)
              ENDFOR
            CASE FIELDTYPE_INTLIST
              intlist:=Long(fieldptr)
              FOR j:=0 TO intlist.count()-1
                StringF(tempStr2,'\s\d',tempStr,intlist.item(j))
                fser.writeLine(tempStr2)
              ENDFOR
          ENDSELECT
        ENDIF
      ENDIF
    ENDWHILE
    fser.writeLine('-')
    self.serialiseChildren(fser)
  ENDIF 
ENDPROC

PROC deserialise(fser:PTR TO fileStreamer) OF reactionObject
  DEF tempStr[200]:STRING
  DEF done=FALSE
  DEF tempStr2[200]:STRING
  DEF list:PTR TO LONG,i,count
  DEF strlist:PTR TO stringlist
  DEF intlist:PTR TO stdlist
  DEF fieldname,fieldtype,fieldptr

  REPEAT
    IF fser.readLine(tempStr)
      IF StrCmp('--',tempStr)
        done:=TRUE
      ELSEIF StrCmp('ID: ',tempStr,4)
        self.id:=Val(tempStr+4)
      ELSEIF StrCmp('PARENTID: ',tempStr,STRLEN)
        IF StrLen(tempStr+STRLEN)=0
          self.tempParentId:=-1
        ELSE
          self.tempParentId:=Val(tempStr+STRLEN)
        ENDIF
      ELSEIF StrCmp('NAME: ',tempStr,STRLEN)
        AstrCopy(self.name,tempStr+STRLEN,80)
      ELSEIF StrCmp('MINWIDTH: ',tempStr,STRLEN)
        self.minWidth:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('MINHEIGHT: ',tempStr,STRLEN)
        self.minHeight:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('MAXWIDTH: ',tempStr,STRLEN)
        self.minHeight:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('MAXHEIGHT: ',tempStr,STRLEN)
        self.maxHeight:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('WEIGHTEDWIDTH: ',tempStr,STRLEN)
        self.weightedWidth:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('WEIGHTEDHEIGHT: ',tempStr,STRLEN)
        self.weightedHeight:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('SCALEWIDTH: ',tempStr,STRLEN)
        self.scaleWidth:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('SCALEHEIGHT: ',tempStr,STRLEN)
        self.scaleHeight:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('NOMINALSIZE: ',tempStr,STRLEN)
        self.nominalSize:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('WEIGHTMINIMUM: ',tempStr,STRLEN)
        self.weightMinimum:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('CACHEDOMAIN: ',tempStr,STRLEN)
        self.cacheDomain:=Val(tempStr+STRLEN)
      ELSEIF StrCmp('NODISPOSE: ',tempStr,STRLEN)
        self.noDispose:=Val(tempStr+STRLEN)
      ENDIF
    ELSE
      done:=TRUE
    ENDIF
  UNTIL done  

  list:=self.serialiseData()
  count:=ListLen(list)
  IF count>0
    done:=FALSE
    REPEAT
      IF fser.readLine(tempStr)
        IF StrCmp('-',tempStr)
          done:=TRUE
        ELSE
          i:=0
          WHILE i<count
            fieldname:=list[i++]
            fieldptr:=list[i++]
            fieldtype:=list[i++]
            StrCopy(tempStr2,fieldname)
            StrAdd(tempStr2,': ')
            UpperStr(tempStr2)
            IF StrCmp(tempStr2,tempStr,EstrLen(tempStr2))
              SELECT fieldtype
                CASE FIELDTYPE_CHAR
                  PutChar(fieldptr,Val(tempStr+StrLen(tempStr2)))
                CASE FIELDTYPE_INT
                  PutInt(fieldptr,Val(tempStr+StrLen(tempStr2)))
                CASE FIELDTYPE_LONG
                  PutLong(fieldptr,Val(tempStr+StrLen(tempStr2)))
                CASE FIELDTYPE_STR
                  AstrCopy(fieldptr,tempStr+StrLen(tempStr2))
                CASE FIELDTYPE_STRLIST
                  strlist:=Long(fieldptr)
                  strlist.add(tempStr+StrLen(tempStr2))
                CASE FIELDTYPE_INTLIST
                  intlist:=Long(fieldptr)
                  intlist.add(Val(tempStr+StrLen(tempStr2)))
              ENDSELECT
            ENDIF
          ENDWHILE
        ENDIF
      ELSE
        done:=TRUE
      ENDIF
    UNTIL done  
  ENDIF
ENDPROC

PROC serialiseChildren(fser:PTR TO fileStreamer) OF reactionObject
  DEF child:PTR TO reactionObject
  DEF i
  FOR i:=0 TO self.children.count()-1
    child:=self.children.item(i)
    child.serialise(fser)
  ENDFOR
ENDPROC

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF reactionObject IS -1

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF reactionObject
  IF self.minWidth<>-1 THEN srcGen.componentPropertyInt('CHILD_MinWidth',self.minWidth)
  IF self.minHeight<>-1 THEN srcGen.componentPropertyInt('CHILD_MinHeight',self.minHeight)
  IF self.maxWidth<>-1 THEN srcGen.componentPropertyInt('CHILD_MaxWidth',self.maxWidth)
  IF self.maxHeight<>-1 THEN srcGen.componentPropertyInt('CHILD_MaxHeight',self.maxHeight)
  IF self.minWidth<>-1 THEN srcGen.componentPropertyInt('CHILD_MinWidth',self.minWidth)
  IF self.weightedWidth<>100 THEN srcGen.componentPropertyInt('CHILD_WeightedWidth',self.weightedWidth)
  IF self.weightedHeight<>100 THEN srcGen.componentPropertyInt('CHILD_WeightedHeight',self.weightedHeight)
  IF self.scaleWidth<>0 THEN srcGen.componentPropertyInt('CHILD_ScaledWidth',self.scaleWidth)
  IF self.scaleHeight<>0 THEN srcGen.componentPropertyInt('CHILD_ScaledHeight',self.scaleHeight)
  IF self.nominalSize THEN srcGen.componentProperty('CHILD_NominalSize',TRUE,FALSE)
  IF self.weightMinimum THEN srcGen.componentProperty('CHILD_WeightMinimum',TRUE,FALSE)
  IF self.cacheDomain=0 THEN srcGen.componentProperty('CHILD_CacheDomain',FALSE,FALSE)
  IF self.noDispose THEN srcGen.componentProperty('CHILD_NoDispose',TRUE,FALSE)
ENDPROC

EXPORT PROC isImage() OF reactionObject IS 0

EXPORT PROC objectInitialise(n=1)
  objCount:=n
ENDPROC

EXPORT PROC getObjId()
  objCount:=1
ENDPROC

