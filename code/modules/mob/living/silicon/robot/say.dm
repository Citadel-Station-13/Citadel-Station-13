<<<<<<< HEAD
/mob/living/silicon/robot/IsVocal()
	return !config.silent_borg
=======
/mob/living/silicon/robot/IsVocal()
	return !CONFIG_GET(flag/silent_borg)
>>>>>>> 4178c20... Configuration datum refactor (#30763)
