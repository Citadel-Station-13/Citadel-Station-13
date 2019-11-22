//symptoms are common roc calls that simplify the actual trauma length into a less cumbersom format

/datum/organ_trauma/proc/fever(strength)
	owwner.temperature += strength

/datum/organ_trauma/proc/chill(strength)
	fever(-strength)
