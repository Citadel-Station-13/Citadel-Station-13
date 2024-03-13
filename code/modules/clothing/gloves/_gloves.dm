/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.5
	body_parts_covered = HANDS
	slot_flags = ITEM_SLOT_GLOVES
	attack_verb = list("challenged")
	var/transfer_prints = FALSE
	var/transfer_blood = 0
	strip_delay = 20
	equip_delay_other = 40
	var/strip_mod = 1 //how much they alter stripping items time by, higher is quicker
	var/strip_silence = FALSE //if it shows a warning when stripping

/obj/item/clothing/gloves/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, TYPE_PROC_REF(/atom, clean_blood))

/obj/item/clothing/gloves/clean_blood(datum/source, strength)
	. = ..()
	transfer_blood = 0

/obj/item/clothing/gloves/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>\the [src] are forcing [user]'s hands around [user.p_their()] neck! It looks like the gloves are possessed!</span>")
	return OXYLOSS

/obj/item/clothing/gloves/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedgloves")
		if(blood_DNA)
			. += mutable_appearance('icons/effects/blood.dmi', "bloodyhands", color = blood_DNA_to_color(), blend_mode = blood_DNA_to_blend())

/obj/item/clothing/gloves/update_clothes_damaged_state()
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_gloves()

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(atom/A, proximity)
	return FALSE // return TRUE to cancel attack_hand()
