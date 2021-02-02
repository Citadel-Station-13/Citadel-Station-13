/////////////////////////////////////
//////////Limb Grower Designs ///////
/////////////////////////////////////

/datum/design/leftarm
	name = "Left Arm"
	id = "leftarm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/l_arm
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/rightarm
	name = "Right Arm"
	id = "rightarm"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/r_arm
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/leftleg
	name = "Left Leg"
	id = "leftleg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/l_leg
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/rightleg
	name = "Right Leg"
	id = "rightleg"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/bodypart/r_leg
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/armblade
	name = "Arm Blade"
	id = "armblade"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 75)
	build_path = /obj/item/melee/synthetic_arm_blade
	category = list("other","emagged")

//Extra limbs

/datum/design/chest
	name = "Chest"
	id = "chest"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 50)
	build_path = /obj/item/bodypart/chest
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/head
	name = "Head"
	id = "head"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 75)
	build_path = /obj/item/bodypart/head
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

//Organs
/datum/design/brain
	name = "Brain"
	id = "brain"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 50)
	build_path = /obj/item/organ/brain
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/heart
	name = "Heart"
	id = "heart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/heart
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/lungs
	name = "Lungs"
	id = "lungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/lungs
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/liver
	name = "Liver"
	id = "liver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/liver
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/stomach
	name = "Stomach"
	id = "stomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/stomach
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/appendix
	name = "Appendix"
	id = "appendix"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 10)
	build_path = /obj/item/organ/appendix
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/tail
	name = "Tail"
	id = "tail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/tail
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/ears
	name = "Ears"
	id = "ears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/ears
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/eyes
	name = "Eyes"
	id = "eyes"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 30)
	build_path = /obj/item/organ/eyes
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/tongue
	name = "Tongue"
	id = "tongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/tongue
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/vocal_cords
	name = "Vocal cords"
	id = "vocal_cords"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/vocal_cords
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

//genitals

/datum/design/penis
	name = "Penis"
	id = "penis"
	build_type = LIMBGROWER
	research_icon_state = "penis_human_3_s"
	research_icon = 'icons/obj/genitals/penis.dmi'
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/genital/penis
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/vagina
	name = "Vagina"
	id = "vagina"
	research_icon_state = "vagina-s"
	research_icon = 'icons/obj/genitals/vagina.dmi'
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/genital/vagina
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/womb
	name = "Womb"
	id = "womb"
	research_icon_state = "womb"
	research_icon = 'icons/obj/genitals/vagina.dmi'
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/genital/womb
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/testicles
	name = "Testicles"
	id = "testicles"
	research_icon_state = "testicles_single_3_s"
	research_icon = 'icons/obj/genitals/testicles.dmi'
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/genital/testicles
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")

/datum/design/breasts
	name = "Breasts"
	id = "breasts"
	research_icon_state = "breasts_pair_e_s"
	research_icon = 'icons/obj/genitals/breasts.dmi'
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/synthflesh = 25)
	build_path = /obj/item/organ/genital/breasts
	category = list("initial","human","lizard","fly","insect","plasmaman","mammal","xeno")
