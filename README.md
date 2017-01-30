# trickle-engine
a json rule engine experiment


Generic rule evaluation:
* Validate and perform the initial field change
* Pass field path to the trickle engine (1)
* Starting with the first rule that list that field as a trigger
* If that rule's condition is true
* Set each point of impact to the value(s) listed
* Foreach point of impact, pass that field path back into the rule engine
* If trickle is set to true, announce those triggers to the rule engine in (1)

Rule shape:
* Trigger - array/single jsons path to watch
* Impact - array/single json path to set
* Value - array/single json path to use in set
* Condition - obj representing condition (if conditional)
 * [['d.field1','==','t.fact1'],'&&',['d.field2','>=','t.fact2']]
* Trickle - array/single json path to true/false value

An rpc. namespace should be reserved in which to perform non-trivial-matrixized processes
An d. namespace should be reserved for the current data object scope
A t. namespace should created for table facts
