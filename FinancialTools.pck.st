'From Cuis7.3 [latest update: #7092] on 1 April 2025 at 9:24:16 am'!
'Description '!
!provides: 'FinancialTools' 1 0!
SystemOrganization addCategory: 'FinancialTools'!


!classDefinition: #FinancialHistory category: 'FinancialTools'!
Object subclass: #FinancialHistory
	instanceVariableNames: 'cashOnHand expenditures incomes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialTools'!
!classDefinition: 'FinancialHistory class' category: 'FinancialTools'!
FinancialHistory class
	instanceVariableNames: ''!

!classDefinition: #BarChart category: 'FinancialTools'!
BoxMorph subclass: #BarChart
	instanceVariableNames: 'backgroundColor bars colors font fontHeight hoverLabel labels maxBarHeight maxValue separation valueAxisIncrement valueLabelDelta valueLabelWidth values barWidth'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialTools'!
!classDefinition: 'BarChart class' category: 'FinancialTools'!
BarChart class
	instanceVariableNames: 'backgroundColor aColor'!

!classDefinition: #FinancialHistoryView category: 'FinancialTools'!
SystemWindow subclass: #FinancialHistoryView
	instanceVariableNames: 'expendituresChart financialHistory incomeChart'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialTools'!
!classDefinition: 'FinancialHistoryView class' category: 'FinancialTools'!
FinancialHistoryView class
	instanceVariableNames: ''!


!FinancialHistory methodsFor: 'accessing' stamp: 'rmv 3/31/2025 12:58:40'!
cashOnHand
	
	^ cashOnHand! !

!FinancialHistory methodsFor: 'accessing' stamp: 'rmv 3/31/2025 12:56:41'!
cashOnHand: aNumber
	
	cashOnHand := aNumber! !

!FinancialHistory methodsFor: 'accessing' stamp: 'rmv 3/30/2025 18:39:49'!
expenditures
	"Answer the Dictionary of expenditures."
	
	^ expenditures! !

!FinancialHistory methodsFor: 'accessing' stamp: 'rmv 3/30/2025 18:40:06'!
incomes
	"Answer the Dictionary of incomes."
	
	^ incomes! !

!FinancialHistory methodsFor: 'accessing' stamp: 'rmv 3/31/2025 06:39:48'!
totalReceivedFrom: source
	"Answer the total amount of money received from source."
	
	^ incomes at: source ifAbsent: 0! !

!FinancialHistory methodsFor: 'accessing' stamp: 'rmv 3/31/2025 06:39:54'!
totalSpentFor: reason
	"Answer the total amount of money spent for reason."
	
	^ expenditures at: reason ifAbsent: 0! !

!FinancialHistory methodsFor: 'initialization' stamp: 'rmv 3/31/2025 12:56:15'!
initialize
	
	cashOnHand := 0.
	incomes := Dictionary new.
	expenditures := Dictionary new.! !

!FinancialHistory methodsFor: 'transactions' stamp: 'rmv 3/31/2025 13:00:36'!
receive: amount from: source
	"Receive amount of money from source and increment cash on hand by this amount."
	
	incomes
		at: source
		put: (self totalReceivedFrom: source) + amount.
	cashOnHand := cashOnHand + amount.! !

!FinancialHistory methodsFor: 'transactions' stamp: 'rmv 3/31/2025 13:00:32'!
spend: amount for: reason
	"Spend amount of money for reason and decrement cash on hand by this amount."
		
	expenditures
		at: reason
		put: (self totalSpentFor: reason) + amount.
	cashOnHand := cashOnHand - amount.! !

!FinancialHistory class methodsFor: 'instance creation' stamp: 'rmv 3/31/2025 12:56:55'!
initialBalance: aNumber
	"Create a FinancialHistory with aNumber as the initial balance."

	^ super new cashOnHand: aNumber! !

!FinancialHistory class methodsFor: 'instance creation' stamp: 'rmv 3/31/2025 12:55:17'!
new
	"Create a FinancialHistory with 0 as the initial balance."

	^ self initialBalance: 0! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/30/2025 11:24:58'!
addBar: labelString value: aNumber

	self addBar: labelString value: aNumber color: Color black! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 06:25:02'!
addBar: labelString value: aNumber color: aColor
	
	labels add: labelString.
	values add: aNumber.
	colors add: aColor.
	self update.! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/30/2025 14:52:38'!
backgroundColor: aColor

	backgroundColor := aColor.
	self redrawNeeded.! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/30/2025 14:46:46'!
drawBackgroundOn: aCanvas

	aCanvas fillRectangle: self localBounds color: backgroundColor.
! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 13:16:01'!
drawOn: aCanvas
	
	self drawBackgroundOn: aCanvas.
	self drawYAxisLabelsOn: aCanvas.
	self drawXAxisLabelsAndBarsOn: aCanvas.
! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/30/2025 15:02:41'!
drawString: aString on: aCanvas at: aPoint
	
	aCanvas
		drawString: aString
		from: 1
		to: aString size
		atBaseline: aPoint
		font: font
		color: Color black.
! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 13:28:05'!
drawXAxisLabelsAndBarsOn: aCanvas
	| barHeight color indent origin rect value x y|

	x := separation + valueLabelWidth + separation.
	y := extent y - separation.
	labels withIndexDo: [ :aLabel :index |
		color := colors at: index.
		value := values at: index.
		
		"Draw x-axis label centered below its bar."
		indent := barWidth - (font widthOfString: aLabel) / 2.
		origin := x + indent @ y.
		self drawString: aLabel on: aCanvas at: origin.
		
		"Draw bar above the its x-axis label."
		barHeight := maxBarHeight * value / maxValue.
		origin := x @ (separation + maxBarHeight - barHeight).
		rect := Rectangle origin: origin extent: barWidth @ barHeight.
		aCanvas fillRectangle: rect color: color.
		
		"Add rect to bars collection, ensuring that an element exists at the index."
		[index > bars size] whileTrue: [ bars add: nil].
		bars at: index put: rect.
		
		x := x + separation + barWidth.
	].
! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/30/2025 15:10:52'!
drawYAxisLabelsOn: aCanvas
	| label value valueLabelY x |
			
	valueLabelY := separation + maxBarHeight + (fontHeight / 2).
	value := 0.
	[value <= maxValue] whileTrue: [
		"Compute x to right-align this y-axis label."	
		label := value asString.
		x := separation + valueLabelWidth - (font widthOfString: label).
		
		self drawString: label on: aCanvas at: x @ valueLabelY.
		
		"Prepare for next y-axis label."
		valueLabelY := valueLabelY - valueLabelDelta.
		value := value + valueAxisIncrement.
	].! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 06:25:23'!
gap: aNumber

	separation := aNumber.
	self update.! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 13:12:39'!
handlesMouseHover

	^ true! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 13:49:47'!
initialize
	
	super initialize.
	
	backgroundColor := Color transparent.
	font := FontFamily defaultFamilyAndPointSize.
	fontHeight := font pointSize.
	hoverLabel := LabelMorph contents: ''.
	self addMorph: hoverLabel.
	separation := 20.
	valueAxisIncrement := 100.	
	
	bars := OrderedCollection new.
	labels := OrderedCollection new.
	values := OrderedCollection new.
	colors := OrderedCollection new.
	
	self layoutSpec
		proportionalHeight: 1;
		proportionalWidth: 1.
		
	self morphExtent: 400 @ 600.! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 06:32:35'!
morphExtent:  anExtent

	super morphExtent: anExtent.
	values isEmpty ifFalse: [ self update ].
! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 13:54:48'!
mouseHover: aMouseButtonEvent localPosition: aPoint
	| index value width |

	index := bars findFirst: [ :bar | bar containsPoint: aPoint ].
	index = 0
		ifTrue: [ hoverLabel contents: '' ]
		ifFalse: [
			value := values at: index :: asString.
			width := font widthOfString: value.
			hoverLabel contents: value.
			hoverLabel morphPosition: (aPoint x - (width / 2)) @ (aPoint y - (fontHeight * 2)).
		].! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/30/2025 10:17:29'!
requiresVectorCanvas

	^ true! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 06:25:54'!
update
	"Set instance variables used by other methods.
	 Call every time a bar is added to recompute."
	| chartWidth count gaps maxLabelWidth |
		
	"Compute instance variables needed to draw y-axis labels."
	maxBarHeight := extent y - (3 * separation) - fontHeight.
	maxValue :=  values fold: [ :acc :v | acc max: v ].
	valueLabelDelta := maxBarHeight / (maxValue / valueAxisIncrement).
	valueLabelWidth := font widthOfString: maxValue asString.
		
	"Compute width to use for each bar."
	count := labels size.
	gaps := count + 2 * separation.
	barWidth := (extent x - valueLabelWidth - gaps) / count.
	
	"Adjust the bar width to be at least as wide as the widest label."
	maxLabelWidth := labels
		inject: 0
		into: [ :acc :aLabel | acc max: (font widthOfString: aLabel) ].
	maxLabelWidth > barWidth ifTrue: [
		barWidth := maxLabelWidth.
		chartWidth := valueLabelWidth + (count * barWidth) + gaps.
		self morphExtent: chartWidth @ (self morphExtent y).
	].
	
	self redrawNeeded.
! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 08:29:27'!
updateBar: labelString value: aNumber
	| index |

	index := labels indexOf: labelString.
	index = 0
		ifTrue: [ self addBar: labelString value: aNumber ]
		ifFalse: [
			values at: index put: aNumber.
			self update.
		].! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/31/2025 08:38:36'!
updateBar: labelString value: aNumber color: aColor
	| index |

	index := labels indexOf: labelString.
	index = 0
		ifTrue: [ self addBar: labelString value: aNumber color: aColor ]
		ifFalse: [
			values at: index put: aNumber.
			self update.
		].! !

!BarChart methodsFor: 'as yet unclassified' stamp: 'rmv 3/30/2025 13:30:18'!
valueAxisIncrement: aNumber

	valueAxisIncrement := aNumber! !

!FinancialHistoryView methodsFor: 'private' stamp: 'rmv 3/31/2025 13:07:39'!
makeBarChart

	^ BarChart new
		backgroundColor: Color tan muchLighter;
		morphExtent: 400 @ 600;
		valueAxisIncrement: 200
! !

!FinancialHistoryView methodsFor: 'accessing' stamp: 'rmv 3/31/2025 13:10:02'!
financialHistory: aFinancialHistory
	| amount |

	financialHistory := aFinancialHistory.
	
	"Create the expenditures bar chart."
	expendituresChart := self makeBarChart.
	aFinancialHistory expenditures keys sort do: [ :key |
		amount := aFinancialHistory expenditures at: key.
		expendituresChart addBar: key value: amount color: Color red.
	].
	self addMorph: expendituresChart.
			
	"Create the incomes bar chart."
	incomeChart := self makeBarChart.
	aFinancialHistory incomes keys sort do: [ :key |
		amount := aFinancialHistory incomes at: key.
		incomeChart addBar: key value: amount color: Color green.
	].
	self addMorph: incomeChart.! !

!FinancialHistoryView methodsFor: 'events' stamp: 'rmv 4/1/2025 09:09:42'!
handlesMouseDown: aMouseEvent
	| localPoint |
	
	localPoint := self internalizeFromWorld: aMouseEvent eventPosition.
	^ localPoint y > self labelHeight.
! !

!FinancialHistoryView methodsFor: 'events' stamp: 'rmv 3/31/2025 09:07:46'!
mouseButton2Down: anEvent localPosition: aPoint
	| choice |
		
	choice := PopUpMenu withCaption: 'Transaction' chooseFrom: #('spend' 'receive').
	choice caseOf: {
		[1] -> [ self spend ].
		[2] -> [ self receive ]
	}.! !

!FinancialHistoryView methodsFor: 'events' stamp: 'rmv 3/31/2025 12:49:43'!
receive
	| amount what |
	
	what := StringRequestMorph request: 'Receive from what?'.
	what isNil or: [ what isEmpty ] :: ifFalse: [
		amount := StringRequestMorph
			request: ('How much from {1}?' format: { what })
			initialAnswer: ''
			verifying: [ :answer | answer allSatisfy: [:char | char isDigit] ].
		amount isNil or: [ amount isEmpty ] :: ifFalse: [
			amount := amount asNumber.
			financialHistory receive: amount asNumber from: what.
			amount := financialHistory incomes at: what.
			incomeChart updateBar: what value: amount color: Color green.
		]
	]! !

!FinancialHistoryView methodsFor: 'events' stamp: 'rmv 3/31/2025 12:47:24'!
spend
	| amount what |
	
	what := StringRequestMorph request: 'Spent on what?'.
	what isNil or: [ what isEmpty ] :: ifFalse: [
		amount := StringRequestMorph
			request: ('How much on {1}?' format: { what })
			initialAnswer: ''
			verifying: [ :answer | answer allSatisfy: [:char | char isDigit] ].
		amount isNil or: [ amount isEmpty ] :: ifFalse: [
			amount := amount asNumber.
			financialHistory spend: amount for: what.
			amount := financialHistory expenditures at: what.
			expendituresChart updateBar: what value: amount color: Color red.
		]
	]! !

!FinancialHistoryView methodsFor: 'updating' stamp: 'rmv 3/31/2025 08:08:19'!
update

	expendituresChart update.
	incomeChart update.! !

!FinancialHistoryView class methodsFor: 'instance creation' stamp: 'rmv 3/31/2025 13:01:25'!
example
	| history |
	
	history := FinancialHistory initialBalance: 1560 ::
		spend: 700 for: #rent;
		spend: 78.53 for: #food;
		receive: 820 from: #pay;
		receive: 22.15 from: #interest;
		spend: 135.65 for: #utilities;
		spend: 146.14 for: #food.
	FinancialHistoryView open: history.
		
		! !

!FinancialHistoryView class methodsFor: 'instance creation' stamp: 'rmv 3/31/2025 08:50:48'!
open: aFinancialHistory
	"Create a window view of aFinancialHistory that consists of
	 two bar charts, one for expenditures and one for income."	
	| layout window |

	window := super new
		setLabel: 'Financial History';
		financialHistory: aFinancialHistory.
	
	layout := window layoutMorph.
	layout beRow; separation: 20.
	window morphExtent: 800 @ 600.
	window openInWorld.
	layout color: Color black muchLighter. "TODO: Why must this follow openInWorld?"! !
