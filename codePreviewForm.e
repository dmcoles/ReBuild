OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'images/bevel',
        'gadgets/textEditor','texteditor',
        'gadgets/scroller','scroller',
        'images/label','label',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'intuition/cghooks',
        'intuition/icclass'

        MODULE '*reactionForm','*stringStreamer'

EXPORT DEF texteditorbase

EXPORT ENUM PREVIEWGAD_TEXT, PREVIEWGAD_SCROLL
CONST NUM_PREVIEW_GADS=PREVIEWGAD_SCROLL+1

EXPORT OBJECT codePreviewForm OF reactionForm
ENDOBJECT

EXPORT PROC create() OF codePreviewForm
  DEF gads:PTR TO LONG
  DEF tempbase,map

  NEW gads[NUM_PREVIEW_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_PREVIEW_GADS]

  tempbase:=textfieldbase
  textfieldbase:=texteditorbase

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

      LAYOUT_ADDCHILD, self.gadgetList[ PREVIEWGAD_TEXT ]:=NewObjectA( TextEditor_GetClass(), NIL,[
        GA_ID, PREVIEWGAD_TEXT,
        GA_TEXTEDITOR_WRAPBORDER,-1,
        GA_TEXTEDITOR_FIXEDFONT,TRUE,
        GA_TEXTEDITOR_HORIZONTALSCROLL, TRUE,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        GA_READONLY, TRUE,
      TAG_END]),

      LAYOUT_ADDCHILD, self.gadgetList[ PREVIEWGAD_SCROLL ]:=NewObjectA(Scroller_GetClass(),NIL,[
        GA_ID, PREVIEWGAD_SCROLL,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        SCROLLER_ARROWS, TRUE,
        SCROLLER_ORIENTATION, SORIENT_VERT,
      TAG_END]),

    LayoutEnd,
  WindowEnd

  map:=[GA_TEXTEDITOR_PROP_FIRST, SCROLLER_TOP,
		GA_TEXTEDITOR_PROP_ENTRIES, SCROLLER_TOTAL,
		GA_TEXTEDITOR_PROP_VISIBLE, SCROLLER_VISIBLE,
    TAG_DONE]

  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],0,0,[ICA_MAP,map,ICA_TARGET,self.gadgetList[ PREVIEWGAD_SCROLL ],0])

  map:=[
		SCROLLER_TOP, GA_TEXTEDITOR_PROP_FIRST,
		SCROLLER_TOTAL, GA_TEXTEDITOR_PROP_ENTRIES,
		SCROLLER_VISIBLE, GA_TEXTEDITOR_PROP_VISIBLE,
		TAG_DONE]

  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_SCROLL ],0,0,[ICA_MAP,map,ICA_TARGET,self.gadgetList[ PREVIEWGAD_TEXT ],0])

  textfieldbase:=tempbase

ENDPROC

PROC end() OF codePreviewForm
  self.close()
  END self.gadgetList[NUM_PREVIEW_GADS]
  END self.gadgetActions[NUM_PREVIEW_GADS]
  DisposeObject(self.windowObj)
ENDPROC

EXPORT PROC showCode(strStream:PTR TO stringStreamer) OF codePreviewForm
  DEF str[201]:ARRAY OF CHAR
  DEF win
  strStream.reset()
  win:=Gets(self.windowObj,WINDOW_WINDOW)
  DoGadgetMethodA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GM_TEXTEDITOR_CLEARTEXT, 0]:gp_texteditor_cleartext)
  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GA_TEXTEDITOR_QUIET,1,TAG_END])
  WHILE strStream.readLine(str)<>-1
    str[StrLen(str)+1]:=0
    str[StrLen(str)]:="\n"   
    DoGadgetMethodA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GM_TEXTEDITOR_INSERTTEXT, 0, str, GV_TEXTEDITOR_INSERTTEXT_BOTTOM]:gp_texteditor_inserttext)
  ENDWHILE
  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GA_TEXTEDITOR_QUIET,FALSE,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_TEXT ],win,0,[GA_TEXTEDITOR_CURSORY,0,TAG_END])
  SetGadgetAttrsA(self.gadgetList[ PREVIEWGAD_SCROLL ],win,0,[SCROLLER_TOP,0,TAG_END]) 
  
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
