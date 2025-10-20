Class {
	#name : 'PiafDocumentTest',
	#superclass : 'PiafTest',
	#instVars : [
		'file'
	],
	#category : 'Piaf-Tests',
	#package : 'Piaf-Tests'
}

{ #category : 'accessing' }
PiafDocumentTest >> piafClass [

	^ PiafDocument
]

{ #category : 'as yet unclassified' }
PiafDocumentTest >> piafDocumentWithSourceBlock [

	^ self piafClass new documentSourceBlock: [ 'PiafDocumentTest.txt' asFileReference ]; yourself
]

{ #category : 'running' }
PiafDocumentTest >> setUp [

	super setUp.

	file := 'PiafDocumentTest.txt' asFileReference.
	file ensureCreateFile.
	file writeStreamDo: [ :stream | stream << 'hello' ].

]

{ #category : 'running' }
PiafDocumentTest >> tearDown [

	super tearDown.
	
	file ensureDelete
]

{ #category : 'tests' }
PiafDocumentTest >> testComputeNewDocumentHash [

	| piaf |
	piaf := self piafDocumentWithSourceBlock.
	self
		assert: piaf computeNewDocumentHash hex
		equals: '0733351879b2fa9bd05c7ca3061529c0'
]

{ #category : 'tests' }
PiafDocumentTest >> testDocumentHash [

	| piaf |
	piaf := self piafDocumentWithSourceBlock.
	piaf cleanUp.

	self deny: piaf isVerified.

	self piaf: piaf.
	self assert: piaf isVerified.

	piaf cleanUp.
	file writeStreamDo: [ :stream | stream << 'toto' ].
	self deny: piaf isVerified.
]

{ #category : 'tests' }
PiafDocumentTest >> testDocumentSourceBlock [

	| piaf |
	piaf := self piafDocumentWithSourceBlock.
	self assert: piaf documentSourceBlock value contents equals: 'hello'
]

{ #category : 'tests' }
PiafDocumentTest >> testUpdateDocumentHash [

	| piaf |
	piaf := self piafDocumentWithSourceBlock.
	
	self assert: piaf documentSourceBlock value contents equals: 'hello'.
	self
		assert: piaf documentHash hex
		equals: '0733351879b2fa9bd05c7ca3061529c0'.
	
	file writeStreamDo: [ :stream | stream << 'hello' ].
	piaf updateDocumentHash.
	
	self assert: piaf documentSourceBlock value contents equals: 'hello'.
	self
		assert: piaf documentHash hex
		equals: '0733351879b2fa9bd05c7ca3061529c0'.
		
	file writeStreamDo: [ :stream | stream << 'abcdefghi' ].
	piaf updateDocumentHash.
	
	self assert: piaf documentSourceBlock value contents equals: 'abcdefghi'.
	self
		assert: piaf documentHash hex
		equals: '6c1ba12834b2ea43d5167eb290c5c50d'.
]
