OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'images/bevel',
        'gadgets/textEditor','texteditor',
        '*textfield',
        'gadgets/scroller','scroller',
        'graphics/gfxbase',
        'images/label','label',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'intuition/cghooks',
        'intuition/icclass'

        MODULE '*reactionForm','*stringStreamer'

EXPORT DEF texteditorbase

CONST TEXTFIELD_TEXT=$84000001
CONST TEXTFIELD_TEXTFONT=$84000003
CONST TEXTFIELD_BORDER_BEVEL=1
CONST TEXTFIELD_BORDER=$8400000C
CONST TEXTFIELD_SIZE=$84000007
CONST TEXTFIELD_READONLY=$8400001F
CONST TEXTFIELD_TOP=$84000005
CONST TEXTFIELD_LINES=$84000009
CONST TEXTFIELD_VISIBLE=$84000008
CONST TEXTFIELD_INSERTTEXT=$84000002


EXPORT ENUM PREVIEWGAD_TEXT, PREVIEWGAD_SCROLL
CONST NUM_PREVIEW_GADS=PREVIEWGAD_SCROLL+1

EXPORT OBJECT codePreviewForm OF reactionForm
ENDOBJECT

PROC createTextFieldGad() OF codePreviewForm
  DEF gfxb:PTR TO gfxbase
  DEF res
  gfxb:=gfxbase
  res:=NewObjectA( TextField_GetClass(), NIL,[
        GA_ID, PREVIEWGAD_TEXT,       
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        TEXTFIELD_TEXTFONT, gfxb.defaultfont,
        TEXTFIELD_READONLY, TRUE,
        TEXTFIELD_BORDER, TEXTFIELD_BORDER_BEVEL,
      TAG_END])
ENDPROC res

EXPORT PROC create() OF codePreviewForm
  DEF gads:PTR TO LONG
  DEF tempbase=0,map

  NEW gads[NUM_PREVIEW_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_PREVIEW_GADS]

  IF texteditorbase
    tempbase:=textfieldbase
    textfieldbase:=texteditorbase

    self.gadgetList[ PREVIEWGAD_TEXT ]:=NewObjectA( TextEditor_GetClass(), NIL,[
        GA_ID, PREVIEWGAD_TEXT,
        GA_TEXTEDITOR_WRAPBORDER,-1,
        GA_TEXTEDITOR_FIXEDFONT,TRUE,
        GA_TEXTEDITOR_HORIZONTALSCROLL, TRUE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_READONLY, TRUE,
      TAG_END])
  ELSE  
    self.gadgetList[ PREVIEWGAD_TEXT ]:=self.createTextFieldGad()
  ENDIF

  self.gadgetActions:=gads
    self.windowObj:=WindowObject,
    WA_TITLE, 'Code Preview',
    WA_LEFT, 0,
    WA_TOP, 20,
    WA_HEIGHT, 100,
    WA_WIDTH, 200,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, FALSE,
    WA_PUBSCREEN, 0,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_NOCAREREFRESH, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR IDCMP_NEWSIZE, 

    WINDOW_PARENTGROUP, HLayoutObject,
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,

      LAYOUT_ADDCHILD, self.gadgetList[ PREVIEWGAD_TEXT ],

      LAYOUT_ADDCHILD, self.gadgetList[ PREVIEWGAD_SCROLL ]:=NewObjectA(Scroller_GetClass(),NIL,[
        GA_ID, PREVIEWGAD_SCROLL,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        SCROLLER_ARROWS, TRUE,
        SCROLLER_ORIENTATION, SORIENT_VERT,
      TAG_END]),

    LayoutEnd,
  WindowEnd

  IF texteditorbase
    map:=[GA_TEXTEDITOR_PROP_FIRST, SCROLLER_TOP,
      GA_TEXTEDITOR_PROP_ENTRIES, SCROLLER_TOTAL,
      GA_TEXTEDITOR_PROP_VISIBLE, SCROLLER_VISIBLE,
      TAG_DONE]
  ELSE
    map:=[TEXTFIELD_TOP, SCROLLER_TOP,
      TEXTFIELD_LINES, SCROLLER_TOTAL,
      TEXTFIELD_VISIBLE, SCROLLER_VISIBLE,
      TAG_DONE]
  ENDIF

  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],0,0,[ICA_MAP,map,ICA_TARGET,self.gadgetList[ PREVIEWGAD_SCROLL ],0])

  IF texteditorbase
    map:=[
      SCROLLER_TOP, GA_TEXTEDITOR_PROP_FIRST,
      SCROLLER_TOTAL, GA_TEXTEDITOR_PROP_ENTRIES,
      SCROLLER_VISIBLE, GA_TEXTEDITOR_PROP_VISIBLE,
      TAG_DONE]
  ELSE
    map:=[
      SCROLLER_TOP, TEXTFIELD_TOP,
      SCROLLER_TOTAL, TEXTFIELD_LINES,
      SCROLLER_VISIBLE, TEXTFIELD_VISIBLE,
      TAG_DONE]
  ENDIF

  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_SCROLL ],0,0,[ICA_MAP,map,ICA_TARGET,self.gadgetList[ PREVIEWGAD_TEXT ],0])

  IF tempbase THEN textfieldbase:=tempbase

ENDPROC

PROC end() OF codePreviewForm
  self.close()
  END self.gadgetList[NUM_PREVIEW_GADS]
  END self.gadgetActions[NUM_PREVIEW_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC showCode(strStream:PTR TO stringStreamer) OF codePreviewForm
  DEF str[201]:ARRAY OF CHAR
  DEF win,top
  DEF newgad,tempdata,size
  strStream.reset()
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  top:=Gets(self.gadgetList[ PREVIEWGAD_SCROLL ],SCROLLER_TOP)
  IF texteditorbase
    DoGadgetMethodA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GM_TEXTEDITOR_CLEARTEXT, 0]:gp_texteditor_cleartext)
    SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GA_TEXTEDITOR_QUIET,1,TAG_END])
  ELSE
    SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[TEXTFIELD_TEXT,'',0])
    newgad:=self.createTextFieldGad()
  ENDIF
  WHILE strStream.readLine(str)<>-1
    str[StrLen(str)+1]:=0
    str[StrLen(str)]:="\n"   
    IF texteditorbase
      DoGadgetMethodA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GM_TEXTEDITOR_INSERTTEXT, 0, str, GV_TEXTEDITOR_INSERTTEXT_BOTTOM]:gp_texteditor_inserttext)
    ELSE
      SetGadgetAttrsA(newgad,0,0,[TEXTFIELD_INSERTTEXT,str,0])
    ENDIF
  ENDWHILE
  IF texteditorbase
    SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GA_TEXTEDITOR_QUIET,FALSE,TAG_END])
    SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GA_TEXTEDITOR_PROP_FIRST,top,TAG_END])
  ELSE
    size:=Gets(newgad,TEXTFIELD_SIZE)
    tempdata:=New(size)
    IF tempdata
      CopyMem(Gets(newgad,TEXTFIELD_TEXT),tempdata,size)
      SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[TEXTFIELD_TEXT,tempdata,TAG_END])
      Dispose(tempdata)
    ENDIF
    DisposeObject(newgad)

    SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[TEXTFIELD_TOP,top,TAG_END])
  ENDIF
  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_SCROLL ],win,0,[SCROLLER_TOP,top,TAG_END]) 
  
ENDPROC

EXPORT PROC close() OF codePreviewForm
  RA_CloseWindow(self.windowObj)
ENDPROC

EXPORT PROC show(left,top,width,height) OF codePreviewForm
  SetAttrsA(self.windowObj,[
    WA_LEFT, left,
    WA_TOP, top,
    WA_HEIGHT, height,
    WA_WIDTH, width,
    TAG_DONE])

  RA_OpenWindow(self.windowObj)
ENDPROC
