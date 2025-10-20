Class {
	#name : 'PiafVerification',
	#superclass : 'Object',
	#instVars : [
		'executionBlock',
		'isVerified',
		'description'
	],
	#category : 'Piaf',
	#package : 'Piaf'
}

{ #category : 'accessing' }
PiafVerification >> description [

	^ description
]

{ #category : 'accessing' }
PiafVerification >> description: anObject [

	description := anObject
]

{ #category : 'tests' }
PiafVerification >> eventReceive: aPiafIsEvaluatedEvent [ 
	
]

{ #category : 'accessing' }
PiafVerification >> executionBlock [

	^ executionBlock
]

{ #category : 'accessing' }
PiafVerification >> executionBlock: anObject [

	executionBlock := anObject
]

{ #category : 'accessing enum camelcased' }
PiafVerification >> initialize [

	super initialize.
	isVerified := false.
	executionBlock := [ :piaf :verif | ]
]

{ #category : 'accessing' }
PiafVerification >> isVerified [

	^ isVerified
]

{ #category : 'accessing' }
PiafVerification >> isVerified: anObject [

	isVerified := anObject
]

{ #category : 'look event handling' }
PiafVerification >> receivePiafIsEvaluatedEvent: anEvent [

	self executionBlock value: anEvent value: self
]

{ #category : 'accessing enum camelcased' }
PiafVerification >> verify [

	isVerified := true
]
