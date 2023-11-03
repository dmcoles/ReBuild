  OPT MODULE
  
  MODULE '*stringlist'
  
  DEF reactionLists:PTR TO stdlist
  
  EXPORT PROC initReactionLists()
    NEW reactionLists.stdlist(20)
  ENDPROC
  
  EXPORT PROC freeReactionLists()
    END reactionLists
  ENDPROC
  
  EXPORT PROC getReactionLists() IS reactionLists
  