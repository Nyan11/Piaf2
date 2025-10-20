Extension { #name : 'BlElement' }

{ #category : '*Piaf-Bloc' }
BlElement >> hasPiaf [

	self userData
		at: #piafs
		ifPresent: [ :col | ^ col isNotEmpty ]
		ifAbsent: [ ^ false ]
]

{ #category : '*Piaf-Bloc' }
BlElement >> piaf: aPiaf [

	super piaf: aPiaf.
	self userData
		at: #piafs
		ifPresent: [ :col | col add: self ]
		ifAbsentPut: [ Set with: aPiaf ]
]

{ #category : '*Piaf-Bloc' }
BlElement >> piafs [

	^ self userData at: #piafs ifAbsent: [ {  } ]
]
