Class {
	#name : 'PiafTest',
	#superclass : 'TestCase',
	#instVars : [
		'eventReceiver',
		'eventMethod',
		'eventPiaf',
		'hasReceiveEvent',
		'instancesOfPiafTests'
	],
	#category : 'Piaf-Tests',
	#package : 'Piaf-Tests'
}

{ #category : 'running' }
PiafTest class >> cycleExample [

	^ (Pragma allNamed: #piafTest) collect: [ :each | each method valueWithReceiver: PiafTest new ]
]

{ #category : 'tests' }
PiafTest >> eventMethod [

	^ eventMethod
]

{ #category : 'tests' }
PiafTest >> eventPiaf [

	^ eventPiaf
]

{ #category : 'tests' }
PiafTest >> eventReceive: anEvent [

	eventReceiver := anEvent piafReceiver.
	eventMethod := anEvent piafMethod.
	eventPiaf := anEvent piafSource.
	hasReceiveEvent := true
]

{ #category : 'tests' }
PiafTest >> eventReceiver [

	^ eventReceiver
]

{ #category : 'tests' }
PiafTest >> hasReceiveEvent [

	^ hasReceiveEvent
]

{ #category : 'running' }
PiafTest >> makeCycleTestPiafA [
	"
A → B
A → C
B → D
C → D
"

	<piafTest>
	^ self piafClass new
		  piaf: self makeCycleTestPiafB;
		  piaf: self makeCycleTestPiafC;
		  yourself
]

{ #category : 'running' }
PiafTest >> makeCycleTestPiafB [
	"
A → B
A → C
B → D
C → D
"

	<piafTest>
	^ self piafClass new
		  piaf: self makeCycleTestPiafD;
		  yourself
]

{ #category : 'running' }
PiafTest >> makeCycleTestPiafC [
	"
A → B
A → C
B → D
C → D
"

	<piafTest>
	^ self piafClass new
		  piaf: self makeCycleTestPiafD;
		  yourself
]

{ #category : 'running' }
PiafTest >> makeCycleTestPiafD [
	"
A → B
A → C
B → D
C → D
"

	<piafTest>
	^ self piafClass new
]

{ #category : 'piaf-generated' }
PiafTest >> makeTestPiaf [

	^ self piafClass new
]

{ #category : 'accessing' }
PiafTest >> piafClass [

	^ Piaf
]

{ #category : 'running' }
PiafTest >> setUp [

	super setUp.

	self makeTestPiaf announcer
		when: PiafIsEvaluatedEvent
		send: #eventReceive:
		to: self.

	self makeTestPiaf allRelatedPiafs do: [ :piaf |
		piaf piafParents removeAll ].

	eventReceiver := nil.
	hasReceiveEvent := false.
	instancesOfPiafTests := (Pragma allNamed: #piafTest) collect: [ :each |
		                        each method valueWithReceiver: self ]
]

{ #category : 'running' }
PiafTest >> tearDown [

	super tearDown.

	self makeTestPiaf announcer removeSubscription: self.
	self makeTestPiaf initializeVerifications.
	instancesOfPiafTests := nil.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect
]

{ #category : 'tests' }
PiafTest >> testAddVerification [

	| piaf |
	piaf := self makeTestPiaf.

	self deny: piaf isVerified.
	self piaf: piaf.
	self assert: piaf isVerified.

	piaf addVerification: PiafVerification new.
	self deny: piaf isVerified.
	self piaf: piaf.
	self deny: piaf isVerified
]

{ #category : 'tests' }
PiafTest >> testAllRelatedPiafs [

	| piaf collection |
	piaf := self makeTestPiaf.
	collection := piaf allRelatedPiafs.

	self assert: collection size equals: 1.
	self assert: collection anyOne equals: self makeTestPiaf
]

{ #category : 'tests' }
PiafTest >> testAllRelatedPiafs1 [

	| piaf collection |
	piaf := self makeCycleTestPiafC.
	collection := piaf allRelatedPiafs.

	self assert: collection size equals: 4.
	self assert: (collection includes: self makeCycleTestPiafA).
	self assert: (collection includes: self makeCycleTestPiafB).
	self assert: (collection includes: self makeCycleTestPiafC).
	self assert: (collection includes: self makeCycleTestPiafD)
]

{ #category : 'tests' }
PiafTest >> testAllRelatedPiafs2 [

	| piaf collection |
	piaf := self makeCycleTestPiafA.
	collection := piaf allRelatedPiafs.

	self assert: collection size equals: 4.
	self assert: (collection includes: self makeCycleTestPiafA).
	self assert: (collection includes: self makeCycleTestPiafB).
	self assert: (collection includes: self makeCycleTestPiafC).
	self assert: (collection includes: self makeCycleTestPiafD)
]

{ #category : 'tests' }
PiafTest >> testAllRelatedPiafs3 [

	| piaf collection |
	piaf := self makeCycleTestPiafB.
	collection := piaf allRelatedPiafs.

	self assert: collection size equals: 4.
	self assert: (collection includes: self makeCycleTestPiafA).
	self assert: (collection includes: self makeCycleTestPiafB).
	self assert: (collection includes: self makeCycleTestPiafC).
	self assert: (collection includes: self makeCycleTestPiafD)
]

{ #category : 'tests' }
PiafTest >> testAllRelatedPiafs4 [

	| piaf collection |
	piaf := self makeCycleTestPiafD.
	collection := piaf allRelatedPiafs.

	self assert: collection size equals: 4.
	self assert: (collection includes: self makeCycleTestPiafA).
	self assert: (collection includes: self makeCycleTestPiafB).
	self assert: (collection includes: self makeCycleTestPiafC).
	self assert: (collection includes: self makeCycleTestPiafD)
]

{ #category : 'tests' }
PiafTest >> testEvent1 [

	| test |
	test := Object new.

	test piaf: self makeTestPiaf.
	self assert: self hasReceiveEvent.
	self assert: self eventReceiver equals: test.
	self assert: self eventPiaf equals: self makeTestPiaf.
	self assert: self eventMethod equals: thisContext method
]

{ #category : 'tests' }
PiafTest >> testEvent2 [

	| test |
	test := Object new.

	Object new piaf: self makeTestPiaf.
	self assert: self hasReceiveEvent.
	self deny: self eventReceiver equals: test.
	self assert: self eventPiaf equals: self makeTestPiaf.
	self assert: self eventMethod equals: thisContext method
]

{ #category : 'tests' }
PiafTest >> testEvent3 [

	| test |
	test := Object new.

	test piaf: self makeTestPiaf.
	self assert: self hasReceiveEvent.
	self assert: self eventReceiver equals: test.
	self assert: self eventPiaf equals: self makeTestPiaf.
	self assert: self eventMethod equals: thisContext method
]

{ #category : 'tests' }
PiafTest >> testIsChildOf [

	| piafA piafB piafC piafD |
	piafA := self makeCycleTestPiafA.
	piafB := self makeCycleTestPiafB.
	piafC := self makeCycleTestPiafC.
	piafD := self makeCycleTestPiafD.
	self deny: (piafA isChildOf: piafA).
	self assert: (piafC isChildOf: piafD).
	self assert: (piafB isChildOf: piafD).
	self assert: (piafA isChildOf: piafB).
	self assert: (piafA isChildOf: piafC)
]

{ #category : 'tests' }
PiafTest >> testIsParentOf [

	| piafA piafB piafC piafD |
	piafA := self makeCycleTestPiafA.
	piafB := self makeCycleTestPiafB.
	piafC := self makeCycleTestPiafC.
	piafD := self makeCycleTestPiafD.
	self deny: (piafA isParentOf: piafA).
	self assert: (piafD isParentOf: piafC).
	self assert: (piafD isParentOf: piafB).
	self assert: (piafB isParentOf: piafA).
	self assert: (piafC isParentOf: piafA).
]

{ #category : 'tests' }
PiafTest >> testIsVerified [

	| piaf |
	piaf := self makeTestPiaf.

	self deny: piaf isVerified.
	self piaf: piaf.
	self assert: piaf isVerified
]

{ #category : 'tests' }
PiafTest >> testIsVerified1 [

	| piaf1 piaf2 |
	piaf1 := self makeTestPiaf.
	piaf2 := self makeTestPiaf.

	self deny: piaf1 isVerified.
	self deny: piaf2 isVerified.
	self piaf: piaf1.
	self assert: piaf1 isVerified.
	self assert: piaf2 isVerified
]

{ #category : 'tests' }
PiafTest >> testPiafAreUnique [

	| piaf anotherPiaf |
	piaf := self makeTestPiaf.
	anotherPiaf := self makeTestPiaf.
	self assert: piaf equals: anotherPiaf.
	self assert: self makeTestPiaf equals: piaf.
	self deny: Piaf new equals: piaf
]

{ #category : 'tests' }
PiafTest >> testPiafHaveNoCycles1 [

	| piaf |
	piaf := Piaf new.
	self should: [ piaf piaf: piaf ] raise: PiafCycleException
]

{ #category : 'tests' }
PiafTest >> testPiafHaveNoCycles2 [

	| piafA piafD |
	piafA := self makeCycleTestPiafA.
	piafD := self makeCycleTestPiafD.
	self should: [ piafD piaf: piafA ] raise: PiafCycleException
]

{ #category : 'tests' }
PiafTest >> testPiafHaveNoCycles3 [

	| piafA piafB |
	piafA := self makeCycleTestPiafA.
	piafB := self makeCycleTestPiafB.
	self should: [ piafB piaf: piafA ] raise: PiafCycleException
]

{ #category : 'tests' }
PiafTest >> testPiafHaveParents1 [

	| piaf parent |
	parent := self makeTestPiaf.
	piaf := Piaf new.
	piaf piaf: parent.

	self assert: (piaf piafParents includes: parent).
	self assert: (parent piafChildren includes: piaf)
]

{ #category : 'tests' }
PiafTest >> testPiafHaveParents2 [

	| piaf parent |
	parent := Piaf new.
	piaf := self makeTestPiaf.
	piaf piaf: parent.

	self assert: (piaf piafParents includes: parent).
	self assert: (parent piafChildren includes: piaf)
]
