Extension { #name : 'BlSpace' }

{ #category : '*Piaf-Bloc' }
BlSpace >> enableCommentsOnPiaf: aPiaf [

	self root
		piaf: aPiaf;
		addShortcut: (BlShortcutWithAction new
				 combination: (BlKeyCombination builder
						  alt;
						  key: KeyboardKey C;
						  build);
				 action: [ :anEvent :aShortcut |
						 | lastMousePosition allPossibleChildren allChildren |
						 lastMousePosition := self mouseProcessor lastMouseMoveEvent
							                      position.
						 allPossibleChildren := anEvent target withAllChildrenAt:
							                        lastMousePosition.
						 allChildren := allPossibleChildren select: [ :each |
							                each hasPiaf ].
						(allChildren flatCollect: #piafs) asSet.
						 self halt ])
]
