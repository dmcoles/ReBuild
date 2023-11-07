# Compile rebuild

debugoptions=DEBUG IGNORECACHE NILCHECK SYM SHOWFNAME ADDBUF 50
releaseoptions=IGNORECACHE OPTI SHOWFNAME ADDBUF 50
compiler=EVO

ifeq ($(build),release)
options=$(releaseoptions)
else
options=$(debugoptions)
endif

all:					rebuild

release:				options=$(releaseoptions)
release:				rebuild

rebuild:			rebuild.e dialogs.m reactionLists.m getScreenModeObject.m getFontObject.m getFileObject.m textFieldObject.m drawListObject.m fuelGaugeObject.m bevelObject.m listBrowserObject.m clickTabObject.m chooserObject.m radioObject.m menuObject.m rexxObject.m reactionListObject.m listManagerForm.m codeGenForm.m eSourceGen.m cSourceGen.m sourcegen.m fileStreamer.m reactionForm.m objectPicker.m windowObject.m screenObject.m paletteObject.m scrollerObject.m glyphObject.m spaceObject.m integerObject.m labelObject.m checkboxObject.m stringObject.m buttonObject.m layoutObject.m reactionObject.m stringlist.m
							$(compiler) rebuild $(options)

reactionLists.m:			reactionLists.e stringlist.m
							$(compiler) reactionLists $(options)

stringlist.m:			stringlist.e
							$(compiler) stringlist $(options)

paletteObject.m:			paletteObject.e reactionObject.m reactionForm.m
							$(compiler) paletteObject $(options)

screenObject.m:			screenObject.e reactionObject.m reactionForm.m
							$(compiler) screenObject $(options)

windowObject.m:			windowObject.e reactionObject.m reactionForm.m sourceGen.m
							$(compiler) windowObject $(options)

glyphObject.m:			glyphObject.e reactionObject.m reactionForm.m
							$(compiler) glyphObject $(options)

spaceObject.m:			spaceObject.e reactionObject.m reactionForm.m
							$(compiler) spaceObject $(options)

eSourceGen.m:			eSourceGen.e fileStreamer.m sourceGen.m reactionObject.m stringlist.m menuObject.m
							$(compiler) eSourceGen $(options)

cSourceGen.m:			cSourceGen.e fileStreamer.m sourceGen.m reactionObject.m stringlist.m menuObject.m
							$(compiler) cSourceGen $(options)

sourceGen.m:			sourceGen.e fileStreamer.m menuObject.m
							$(compiler) sourceGen $(options)

layoutObject.m:			layoutObject.e reactionObject.m reactionForm.m sourceGen.m
							$(compiler) layoutObject $(options)

integerObject.m:			integerObject.e reactionObject.m reactionForm.m
							$(compiler) integerObject $(options)
              
scrollerObject.m:			scrollerObject.e reactionObject.m reactionForm.m
							$(compiler) scrollerObject $(options)

stringObject.m:			stringObject.e reactionObject.m reactionForm.m sourceGen.m
							$(compiler) stringObject $(options)

checkboxObject.m:			checkboxObject.e reactionObject.m reactionForm.m colourPicker.m
							$(compiler) checkboxObject $(options)

labelObject.m:			labelObject.e reactionObject.m reactionForm.m colourPicker.m
							$(compiler) labelObject $(options)

rexxObject.m:			rexxObject.e reactionObject.m reactionForm.m stringlist.m
							$(compiler) rexxObject $(options)

menuObject.m:			menuObject.e reactionObject.m reactionForm.m stringlist.m fileStreamer.m dialogs.m
							$(compiler) menuObject $(options)

buttonObject.m:			buttonObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m
							$(compiler) buttonObject $(options)

bevelObject.m:			bevelObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m
							$(compiler) bevelObject $(options)

textFieldObject.m:			textFieldObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m
							$(compiler) textFieldObject $(options)

drawListObject.m:			drawListObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m fileStreamer.m
							$(compiler) drawListObject $(options)

fuelGaugeObject.m:			fuelGaugeObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m
							$(compiler) fuelGaugeObject $(options)

getFileObject.m:			getFileObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m
							$(compiler) getFileObject $(options)

getFontObject.m:			getFontObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m
							$(compiler) getFontObject $(options)

getScreenModeObject.m:			getScreenModeObject.e reactionObject.m reactionForm.m colourPicker.m sourceGen.m
							$(compiler) getScreenModeObject $(options)

radioObject.m:			radioObject.e reactionObject.m reactionForm.m listPicker.m stringlist.m reactionLists.m sourceGen.m reactionListObject.m
							$(compiler) radioObject $(options)

chooserObject.m:			chooserObject.e reactionObject.m reactionForm.m listPicker.m stringlist.m reactionLists.m sourceGen.m reactionListObject.m
							$(compiler) chooserObject $(options)

listBrowserObject.m:			listBrowserObject.e reactionObject.m reactionForm.m listPicker.m stringlist.m reactionLists.m sourceGen.m reactionListObject.m
							$(compiler) listBrowserObject $(options)
              
clickTabObject.m:			clickTabObject.e reactionObject.m reactionForm.m listPicker.m stringlist.m reactionLists.m sourceGen.m reactionListObject.m
							$(compiler) clickTabObject $(options)
              
reactionListObject.m:			reactionListObject.e stringlist.m reactionObject.m fileStreamer.m
							$(compiler) reactionListObject $(options)

fileStreamer.m:			fileStreamer.e 
							$(compiler) fileStreamer $(options)

dialogs.m:			dialogs.e 
							$(compiler) dialogs $(options)

colourPicker.m:			colourPicker.e 
							$(compiler) colourPicker $(options)

listManagerForm.m:			listManagerForm.e reactionListObject.m stringlist.m reactionLists.m
							$(compiler) listManagerForm $(options)

codeGenForm.m:			codeGenForm.e 
							$(compiler) codeGenForm $(options)

objectPicker.m:			objectPicker.e 
							$(compiler) objectPicker $(options)

listPicker.m:			listPicker.e  stringlist.m reactionListObject.m reactionLists.m
							$(compiler) listPicker $(options)

reactionObject.m:			reactionObject.e  stringlist.m reactionForm.m fileStreamer.m sourcegen.m
							$(compiler) reactionObject $(options)

reactionForm.m:			reactionForm.e 
							$(compiler) reactionForm $(options)

clean:
							delete dialogs.m getScreenModeObject.m getFontObject.m getFileObject.m textFieldObject.m fuelGaugeObject.m drawListObject.m bevelObject.m listBrowserObject.m clickTabObject.m chooserObject.m radioObject.m menuObject.m rexxObject.m reactionListObject.m listPicker.m reactionForm.m listManagerForm.m codeGenForm.m cSourcegen.m eSourceGen.m sourceGen.m objectPicker.m colourPicker.m fileStreamer.m windowObject.m screenObject.m paletteObject.m scrollerObject.m glyphObject.m spaceObject.m integerObject.m labelObject.m checkboxObject.m stringObject.m buttonObject.m layoutObject.m reactionObject.m reactionLists.m stringlist.m rebuild
