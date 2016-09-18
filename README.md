# trickle-engine
a json rule engine experiment


Generic rule evaluation:
* Validate and perform the initial field change
* Pass field path to the trickle engine
* Starting with the first rule that list that field as a trigger
* If that rule's condition is true
* Set each point of impact of that rule to the value(s) listed
* Foreach point of impact, pass that field path back into the rule engine
* If trickle is set to true, announce those triggers to the rule engine
