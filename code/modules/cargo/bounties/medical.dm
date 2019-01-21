/datum/bounty/item/medical/heart
	name = "Heart"
	description = "Commander Johnson is in critical condition after suffering yet another heart attack. Doctors say he needs a new heart fast. Ship one, pronto!"
	reward = 3000
	wanted_types = list(/obj/item/organ/heart)

/datum/bounty/item/medical/lung
	name = "Lungs"
	description = "A recent explosion at Central Command has left multiple staff with punctured lungs. Ship spare lungs to be rewarded."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/organ/lungs)

/datum/bounty/item/medical/appendix
	name = "Appendix"
	description = "Chef Gibb of Central Command wants to prepare a meal using a very special delicacy: an appendix. If you ship one, he'll pay."
	reward = 5000 //there are no synthetic appendixes
	wanted_types = list(/obj/item/organ/appendix)

/datum/bounty/item/medical/ears
	name = "Ears"
	description = "Multiple staff at Station 12 have been left deaf due to unauthorized clowning. Ship them new ears."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/organ/ears)

/datum/bounty/item/medical/liver
	name = "Livers"
	description = "Multiple high-ranking CentCom diplomats have been hospitalized with liver failure after a recent meeting with Third Soviet Union ambassadors. Help us out, will you?"
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/organ/liver)

/datum/bounty/item/medical/eye
	name = "Organic Eyes"
	description = "Station 5's Research Director Willem is requesting a few pairs of non-robotic eyes. Don't ask questions, just ship them."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/organ/eyes)
	exclude_types = list(/obj/item/organ/eyes/robotic)

/datum/bounty/item/medical/tongue
	name = "Tongues"
	description = "A recent attack by Mime extremists has left staff at Station 23 speechless. Ship some spare tongues."
	reward = 10000
	required_count = 3
	wanted_types = list(/obj/item/organ/tongue)

/datum/bounty/item/medical/lizard_tail
	name = "Lizard Tail"
	description = "The Wizard Federation has made off with Nanotrasen's supply of lizard tails. While CentCom is dealing with the wizards, can the station spare a tail of their own?"
	reward = 3000
	wanted_types = list(/obj/item/organ/tail/lizard)

/datum/bounty/item/medical/cat_tail
	name = "Cat Tail"
	description = "Central Command has run out of heavy duty pipe cleaners. Can you ship over a cat tail to help us out?"
	reward = 3000
	wanted_types = list(/obj/item/organ/tail/cat)

/datum/bounty/item/medical/bloodl
	name = "Lizzard blood bag"
	description = "After a small scuffle with Sec, a few of are lizzard friends need a transfusion again..."
	reward = 5000
	wanted_types = list(/obj/item/reagent_containers/blood/lizard)

/datum/bounty/item/medical/bloodu
	name = "Universal blood bag"
	description = "Central Command, after dealing with a small revolt is need of some new blood for the CMO. Sadly the spare blood bags were destroyed and we need a new one."
	reward = 5500 // Rarer blood
	wanted_types = list(/obj/item/reagent_containers/blood/universal)

/datum/bounty/item/medical/blood
	name = "Any type of blood bag"
	description = "Blood dontions are needed for are new medical wing here at Central command. Were taking any type of blood you send us."
	reward = 3500
	required_count = 3
	wanted_types = list(/obj/item/reagent_containers/blood)
	exclude_types = list(/obj/item/reagent_containers/blood/lizard)

*/
/datum/bounty/item/medical/medibot // Mob so this dosn't work yet*
	name = "Medibot"
	description = "A sister station is dealing with um problem, they need a medibot to help treat their wounded..."
	reward = 3000
	wanted_types = list(/mob/living/simple_animal/bot/medbot)
/*
