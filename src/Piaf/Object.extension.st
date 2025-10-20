Extension { #name : 'Object' }

{ #category : '*Piaf' }
Object >> piaf: aPiaf [

	aPiaf announce: (PiafIsEvaluatedEvent new
			 piafSource: aPiaf;
			 piafReceiver: self;
			 piafMethod: thisContext sender method;
			 yourself)
]
