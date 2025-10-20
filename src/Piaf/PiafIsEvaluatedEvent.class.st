Class {
	#name : 'PiafIsEvaluatedEvent',
	#superclass : 'Announcement',
	#instVars : [
		'piafSource',
		'piafReceiver',
		'piafMethod'
	],
	#category : 'Piaf',
	#package : 'Piaf'
}

{ #category : 'accessing' }
PiafIsEvaluatedEvent >> piafMethod [

	^ piafMethod
]

{ #category : 'accessing' }
PiafIsEvaluatedEvent >> piafMethod: anObject [

	piafMethod := anObject
]

{ #category : 'accessing' }
PiafIsEvaluatedEvent >> piafReceiver [

	^ piafReceiver
]

{ #category : 'accessing' }
PiafIsEvaluatedEvent >> piafReceiver: anObject [

	piafReceiver := anObject
]

{ #category : 'accessing' }
PiafIsEvaluatedEvent >> piafSource [

	^ piafSource
]

{ #category : 'accessing' }
PiafIsEvaluatedEvent >> piafSource: anObject [

	piafSource := anObject
]
