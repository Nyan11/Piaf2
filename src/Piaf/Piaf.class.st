Class {
	#name : 'Piaf',
	#superclass : 'Object',
	#instVars : [
		'announcer',
		'originMethod',
		'piafParents',
		'verifications'
	],
	#category : 'Piaf',
	#package : 'Piaf'
}

{ #category : 'as yet unclassified' }
Piaf class >> allPiafs [

	^ (self withAllSubclasses flatCollect: [ :each | each allInstances ])
		  asSet
]

{ #category : 'cleanup' }
Piaf class >> cleanUp [

	<script>
	self allInstances do: [ :each | each cleanUp ]
]

{ #category : 'instance creation' }
Piaf class >> new [

	| method |
	method := thisContext sender method.

	(self allInstances select: [ :each |
			 each originMethod methodClass = method methodClass and: [
				 each originMethod selector = method selector ] ]) ifNotEmpty: [
		:selection | ^ selection first ].

	^ super new
		  originMethod: method;
		  yourself
]

{ #category : 'comparing' }
Piaf >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	originMethod ifNil: [ ^ false ].
	anObject ifNil: [ ^ false ].
	 
	^ originMethod methodClass = anObject originMethod methodClass and: [
		  originMethod selector = anObject originMethod selector ]
]

{ #category : 'initialization' }
Piaf >> addVerification: aVerification [

	self verifications add: aVerification.

	self announcer
		when: PiafIsEvaluatedEvent
		send: #receivePiafIsEvaluatedEvent:
		to: aVerification
]

{ #category : 'accessing' }
Piaf >> allRelatedPiafs [

	| accu |
	accu := Set new.
	self allRelatedPiafs: accu.
	^ accu
]

{ #category : 'accessing' }
Piaf >> allRelatedPiafs: anAccumulator [

	(anAccumulator includes: self) ifTrue: [ ^ self ].
	anAccumulator add: self.
	self piafParents do: [ :each | each allRelatedPiafs: anAccumulator ].
	self piafChildren do: [ :each | each allRelatedPiafs: anAccumulator ].
]

{ #category : 'announcer' }
Piaf >> announce: aPiafIsEvaluatedEvent [

	self announcer announce: aPiafIsEvaluatedEvent 
]

{ #category : 'initialization' }
Piaf >> announcer [

	^ announcer
]

{ #category : 'accessing' }
Piaf >> asRSShapeForInspection [

	| shape |
	shape := RSBox model: self.
	shape @ RSPopup.

	shape color: Color gray.

	^ shape
]

{ #category : 'cleanup' }
Piaf >> cleanUp [
	self verifications do: [ :v | v isVerified: false ].
]

{ #category : 'as yet unclassified' }
Piaf >> defaultVerifications [

	^ { (PiafVerification new
		   description:
			   'I verify if the piaf has been executed at least once.';
		   executionBlock: [ :anEvent :verif | verif verify ];
		   yourself) }
]

{ #category : 'comparing' }
Piaf >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ originMethod hash
]

{ #category : 'initialization' }
Piaf >> initialize [

	super initialize.
	announcer := Announcer new.
	piafParents := Set new.
	self initializeVerifications
]

{ #category : 'initialization' }
Piaf >> initializeVerifications [

	verifications := OrderedCollection new.
	self defaultVerifications do: [ :verification |
		self addVerification: verification ]
]

{ #category : 'accessing' }
Piaf >> inspectionGraph: aBuilder [

	<inspectorPresentationOrder: 1000 title: 'Piafs Dependencies Map'>
	| shapes canvas |
	shapes := self allRelatedPiafs
		          collect: [ :each | each asRSShapeForInspection draggable ]
		          as: OrderedCollection.

	canvas := RSCanvas new.
	canvas addAll: shapes.
	canvas @ RSCanvasController.
	canvas shapes @ RSHighlightable red.

	RSLineBuilder orthoVertical
		color: Color black;
		arrowMarkerEnd;
		withVerticalAttachPoint;
		canvas: canvas;
		shapes: shapes;
		connectFromAll: #piafParents.

	RSTreeLayout on: shapes.

	^ (aBuilder instantiate: SpRoassalInspectorPresenter)
		  canvas: canvas;
		  yourself
]

{ #category : 'accessing' }
Piaf >> isChildOf: aPiaf [

	^ aPiaf isParentOf: self
]

{ #category : 'accessing' }
Piaf >> isParentOf: aPiaf [

	| parentOfPiafToTest |
	self = aPiaf ifTrue: [ ^ false ].
	parentOfPiafToTest := aPiaf piafParents.
	parentOfPiafToTest ifEmpty: [ ^ false ].
	(parentOfPiafToTest anySatisfy: [ :each | self = each ]) ifTrue: [
		^ true ].
	^ parentOfPiafToTest anySatisfy: [ :each | self isParentOf: each ]
]

{ #category : 'testing' }
Piaf >> isVerified [

	^ self verifications allSatisfy: #isVerified
]

{ #category : 'accessing' }
Piaf >> originMethod [

	^ originMethod
]

{ #category : 'accessing' }
Piaf >> originMethod: anObject [

	originMethod ifNotNil: [ ^ self error: 'Cannot set the origin method twice.' ].

	originMethod := anObject
]

{ #category : 'accessing' }
Piaf >> piaf: aPiaf [

	(self = aPiaf or: [ self isParentOf: aPiaf ]) ifTrue: [
		^ PiafCycleException new signal ].
	piafParents add: aPiaf.

]

{ #category : 'accessing' }
Piaf >> piafChildren [

	^ (Piaf allPiafs select: [ :each |
		   each isChildOf: self ]) asSet
]

{ #category : 'accessing' }
Piaf >> piafParents [

	piafParents ifNil: [ piafParents := Set new ].
	^ piafParents
]

{ #category : 'testing' }
Piaf >> verifications [

	^ verifications
]
