Class {
	#name : 'PiafDocument',
	#superclass : 'Piaf',
	#instVars : [
		'documentHash',
		'documentSourceBlock',
		'documentHashBlock'
	],
	#category : 'Piaf',
	#package : 'Piaf'
}

{ #category : 'accessing' }
PiafDocument >> asRSShapeForInspection [

	| shape |
	shape := super asRSShapeForInspection.
	shape color: Color orange.

	^ shape
]

{ #category : 'as yet unclassified' }
PiafDocument >> computeNewDocumentHash [

	| documentSource |
	documentSource := self documentSourceBlock value.
	^ self documentHashBlock value: documentSource
]

{ #category : 'as yet unclassified' }
PiafDocument >> defaultVerifications [

	^ super defaultVerifications , { (PiafVerification new
		   description:
			   'I verify if the hash of the document is still the same.';
		   executionBlock: [ :anEvent :verif |
				   self computeNewDocumentHash = self documentHash ifTrue: [
						   verif verify ] ];
		   yourself) }
]

{ #category : 'accessing' }
PiafDocument >> documentHash [

	^ documentHash
]

{ #category : 'accessing' }
PiafDocument >> documentHashBlock [

	^ documentHashBlock
]

{ #category : 'accessing' }
PiafDocument >> documentHashBlock: anObject [

	documentHashBlock := anObject.
	self updateDocumentHash
]

{ #category : 'accessing' }
PiafDocument >> documentSourceBlock [

	^ documentSourceBlock
]

{ #category : 'accessing' }
PiafDocument >> documentSourceBlock: anObject [

	documentSourceBlock := anObject.
	self updateDocumentHash
]

{ #category : 'accessing' }
PiafDocument >> initialize [

	super initialize.
	documentHashBlock := [ :source |
		                     source isNil
			                     ifTrue: [ nil ]
			                     ifFalse: [ MD5 hashStream: source binaryReadStream contents base64Encoded readStream ] ]
]

{ #category : 'accessing' }
PiafDocument >> updateDocumentHash [

	self documentHashBlock ifNil: [ ^ self ].
	self documentSourceBlock ifNil: [ ^ self ].
	documentHash := self computeNewDocumentHash
]
