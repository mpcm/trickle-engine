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
 * [[data.field1, op.eq, fact.fact1], op.and, [data.field2, op.gteq, fact.fact2]]
* Trickle - array/single json path to true/false value

A rpc. namespace should be reserved in which to perform non-trivial-matrixized processes
A data. namespace should be reserved for the current data object scope
A fact. namespace should be reserved for table facts
A op. namespace should be reserved for operations like &&, ||, ==, >=

Dynamic inline replacements like data.containter.{containter.current}.field1 should be supported, with containter.current being a value populated by either an expansion over the container list, or via the current containter trigger context.

One of the sticking points becomes variables where intermediate observable values are skipped due to traditional programing habits. Make sure you create points that are observable if they are needed, for cleaner rules or simply outside observability.
