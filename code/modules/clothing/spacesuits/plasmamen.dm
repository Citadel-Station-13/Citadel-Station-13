 //Suits for the pink and grey skeletons! //EVA version no longer used in favor of the Jumpsuit version


/obj/item/clothing/suit/space/eva/plasmaman
	name = "EVA plasma envirosuit"
	desc = "A special plasma containment suit designed to be space-worthy, as well as worn over other clothing. Like its smaller counterpart, it can automatically extinguish the wearer in a crisis, and holds twice as many charges."
	allowed = list(/obj/item/gun, /obj/item/ammo_casing, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/transforming/energy/sword, /obj/item/restraints/handcuffs, /obj/item/tank)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 0, FIRE = 100, ACID = 75, WOUND = 10)
	resistance_flags = FIRE_PROOF
	icon_state = "plasmaman_suit"
	item_state = "plasmaman_suit"
	var/next_extinguish = 0
	var/extinguish_cooldown = 100
	var/extinguishes_left = 10

/obj/item/clothing/suit/space/eva/plasmaman/examine(mob/user)
	. = ..()
	. += "<span class='notice'>There [extinguishes_left == 1 ? "is" : "are"] [extinguishes_left] extinguisher charge\s left in this suit.</span>"


/obj/item/clothing/suit/space/eva/plasmaman/proc/Extinguish(mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(H.fire_stacks)
		if(extinguishes_left)
			if(next_extinguish > world.time)
				return
			next_extinguish = world.time + extinguish_cooldown
			extinguishes_left--
			H.visible_message("<span class='warning'>[H]'s suit automatically extinguishes [H.p_them()]!</span>","<span class='warning'>Your suit automatically extinguishes you.</span>")
			H.ExtinguishMob()
			new /obj/effect/particle_effect/water(get_turf(H))


//I just want the light feature of the hardsuit helmet
/obj/item/clothing/head/helmet/space/plasmaman
	name = "plasma envirosuit helmet"
	desc = "A special containment helmet that allows plasma-based lifeforms to exist safely in an oxygenated environment. It is space-worthy, and may be worn in tandem with other EVA gear."
	icon_state = "plasmaman-helm"
	item_state = "plasmaman-helm"
	strip_delay = 80
	flash_protect = 2
	tint = 2
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 0, FIRE = 100, ACID = 75, WOUND = 10)
	resistance_flags = FIRE_PROOF
	var/brightness_on = 4 //luminosity when the light is on
	var/helmet_on = FALSE
	var/smile = FALSE
	var/smile_color = "#FF0000"
	var/light_overlay = "envirohelm-light"
	var/visor_icon = "envisor"
	var/smile_state = "envirohelm_smile"
	actions_types = list(/datum/action/item_action/toggle_helmet_light, /datum/action/item_action/toggle_welding_screen/plasmaman)
	visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSMOUTH|HEADCOVERSEYES
	visor_flags_inv = HIDEEYES|HIDEFACE|HIDEFACIALHAIR
	mutantrace_variation = NONE

/obj/item/clothing/head/helmet/space/plasmaman/Initialize(mapload)
	. = ..()
	visor_toggling()
	update_icon()

/obj/item/clothing/head/helmet/space/plasmaman/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(wipe_that_smile_off_your_face))
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/head/helmet/space/plasmaman/AltClick(mob/user)
	. = ..()
	if(user.canUseTopic(src, BE_CLOSE))
		toggle_welding_screen(user)
		return TRUE

/obj/item/clothing/head/helmet/space/plasmaman/proc/toggle_welding_screen(mob/living/user)
	if(weldingvisortoggle(user))
		if(helmet_on)
			to_chat(user, "<span class='notice'>Your helmet's torch can't pass through your welding visor!</span>")
			helmet_on = FALSE
			set_light(0)
		playsound(src, 'sound/mecha/mechmove03.ogg', 50, TRUE) //Visors don't just come from nothing
		update_icon()

/obj/item/clothing/head/helmet/space/plasmaman/update_overlays()
	. = ..()
	if(!up)
		. += visor_icon
	if(helmet_on)
		. += light_overlay
	if(smile)
		var/mutable_appearance/M = mutable_appearance(icon, smile_state)
		M.color = smile_color
		. += M

/obj/item/clothing/head/helmet/space/plasmaman/attackby(obj/item/C, mob/living/user)
	. = ..()
	if(istype(C, /obj/item/toy/crayon))
		if(!smile)
			var/obj/item/toy/crayon/CR = C
			to_chat(user, "<span class='notice'>You start drawing a smiley face on the helmet's visor..</span>")
			if(do_after(user, 25, target = src))
				smile = TRUE
				smile_color = CR.paint_color
				to_chat(user, "You draw a smiley on the helmet visor.")
				update_icon()
		else
			to_chat(user, "<span class='warning'>Seems like someone already drew something on this helmet's visor!</span>")

///gets called when receiving the CLEAN_ACT signal from something, i.e soap or a shower. exists to remove any smiley faces drawn on the helmet.
/obj/item/clothing/head/helmet/space/plasmaman/proc/wipe_that_smile_off_your_face()
	if(smile)
		smile = FALSE
		update_icon()

/obj/item/clothing/head/helmet/space/plasmaman/attack_self(mob/user)
	if(!light_overlay)
		return
	if(!up)
		to_chat(user, "<span class='notice'>Your helmet's torch can't pass through your welding visor!</span>")
		return
	helmet_on = !helmet_on

	if(helmet_on)
		set_light(brightness_on, 0.8, "#FFCC66")
	else
		set_light(0)

	update_icon()

/obj/item/clothing/head/helmet/space/plasmaman/visor_toggling() //handles all the actual toggling of flags
	up = !up
	clothing_flags ^= visor_flags
	flags_inv ^= visor_flags_inv
	if(visor_vars_to_toggle & VISOR_FLASHPROTECT)
		flash_protect ^= initial(flash_protect)
	if(visor_vars_to_toggle & VISOR_TINT)
		tint ^= initial(tint)

/obj/item/clothing/head/helmet/space/plasmaman/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands)
		if(smile)
			var/mutable_appearance/M = mutable_appearance(icon_file, smile_state)
			M.color = smile_color
			. += M
		if(!up)
			. += mutable_appearance(icon_file, visor_icon)
		if(helmet_on)
			. += mutable_appearance(icon_file, light_overlay)

/obj/item/clothing/head/helmet/space/plasmaman/security
	name = "security plasma envirosuit helmet"
	desc = "A plasmaman containment helmet designed for security officers, protecting them from being flashed and burning alive, along-side other undesirables."
	icon_state = "security_envirohelm"
	item_state = "security_envirohelm"
	armor = list(MELEE = 10, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 0, FIRE = 100, ACID = 75, WOUND = 20)

/obj/item/clothing/head/helmet/space/plasmaman/security/warden
	name = "warden's plasma envirosuit helmet"
	desc = "A plasmaman containment helmet designed for the warden, a pair of white stripes being added to differeciate them from other members of security."
	icon_state = "warden_envirohelm"
	item_state = "warden_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/security/hos
	name = "head of security's plasma envirosuit helmet"
	desc = "A plasmaman containment helmet designed for the head of security, manacing black with red stripes, to differenciate them from other members of security."
	icon_state = "hos_envirohelm"
	item_state = "hos_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/prisoner
	name = "prisoner's plasma envirosuit helmet"
	desc = "A plasmaman containment helmet for prisoners."

/obj/item/clothing/head/helmet/space/plasmaman/medical
	name = "medical's plasma envirosuit helmet"
	desc = "An envriohelmet designed for plasmaman medical doctors, having two stripes down it's length to denote as much."
	icon_state = "doctor_envirohelm"
	item_state = "doctor_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/cmo
	name = "chief medical officer's plasma envirosuit helmet"
	desc = "A blue and white envriohelmet designed for the chief medical officer."
	icon_state = "cmo_envirohelm"
	item_state = "cmo_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/genetics
	name = "geneticist's plasma envirosuit helmet"
	desc = "A plasmaman envirohelmet designed for geneticists."
	icon_state = "geneticist_envirohelm"
	item_state = "geneticist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/viro
	name = "virology plasma envirosuit helmet"
	desc = "The helmet worn by the safest people on the station, those who are completely immune to the monstrosities they create."
	icon_state = "virologist_envirohelm"
	item_state = "virologist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/chemist
	name = "chemistry plasma envirosuit helmet"
	desc = "A plasmaman envirosuit designed for chemists, two orange stripes going down it's face."
	icon_state = "chemist_envirohelm"
	item_state = "chemist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/science
	name = "science plasma envirosuit helmet"
	desc = "A plasmaman envirohelmet designed for scientists."
	icon_state = "scientist_envirohelm"
	item_state = "scientist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/rd
	name = "research director's plasma envirosuit helmet"
	desc = "A sturdier plasmaman envirohelmet designed for research directors."
	icon_state = "rd_envirohelm"
	item_state = "rd_envirohelm"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 10, BIO = 100, RAD = 0, FIRE = 100, ACID = 75, WOUND = 10)

/obj/item/clothing/head/helmet/space/plasmaman/robotics
	name = "robotics plasma envirosuit helmet"
	desc = "A plasmaman envirohelmet designed for roboticists."
	icon_state = "roboticist_envirohelm"
	item_state = "roboticist_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/engineering
	name = "engineering plasma envirosuit helmet"
	desc = "A space-worthy helmet specially designed for engineer plasmamen, the usual purple stripes being replaced by engineering's orange."
	icon_state = "engineer_envirohelm"
	item_state = "engineer_envirohelm"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, RAD = 10, FIRE = 100, ACID = 75, WOUND = 10)

/obj/item/clothing/head/helmet/space/plasmaman/engineering/ce
	name = "chief engineer's plasma envirosuit helmet"
	desc = "A space-worthy helmet specially designed for the chief engineer, white with gold stripes designed for high visibility."
	icon_state = "ce_envirohelm"
	item_state = "ce_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/atmospherics
	name = "atmospherics plasma envirosuit helmet"
	desc = "A space-worthy helmet specially designed for atmos technician plasmamen, the usual purple stripes being replaced by engineering's blue."
	icon_state = "atmos_envirohelm"
	item_state = "atmos_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/cargo
	name = "cargo plasma envirosuit helmet"
	desc = "An plasmaman envirohelmet designed for cargo techs and quartermasters."
	icon_state = "cargo_envirohelm"
	item_state = "cargo_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/mining
	name = "mining plasma envirosuit helmet"
	desc = "A khaki helmet given to plasmamen miners operating on lavaland."
	icon_state = "explorer_envirohelm"
	item_state = "explorer_envirohelm"
	visor_icon = "explorer_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/chaplain
	name = "chaplain's plasma envirosuit helmet"
	desc = "An envirohelmet specially designed for only the most pious of plasmamen."
	icon_state = "chap_envirohelm"
	item_state = "chap_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/white
	name = "white plasma envirosuit helmet"
	desc = "A generic white envirohelm."
	icon_state = "white_envirohelm"
	item_state = "white_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/hop
	name = "head of personell's plasma envirosuit helmet"
	desc = "A finely tailored azure envirohelm designed for head of personell."
	icon_state = "hop_envirohelm"
	item_state = "hop_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/captain
	name = "captain's plasma envirosuit helmet"
	desc = "A blue and gold envirohelm designed for the station's captain, nonetheless. Made of superior materials to protect them from the station hazards and more."
	icon_state = "captain_envirohelm"
	item_state = "captain_envirohelm"
	armor = list(MELEE = 10, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 100, RAD = 10, FIRE = 100, ACID = 85, WOUND = 15)

/obj/item/clothing/head/helmet/space/plasmaman/curator
	name = "curator's plasma envirosuit helmet"
	desc = "A slight modification on a tradiational voidsuit helmet, this helmet was Nano-Trasen's first solution to the *logistical problems* that come with employing plasmamen. Despite their limitations, these helmets still see use by historian and old-styled plasmamen alike."
	icon_state = "prototype_envirohelm"
	item_state = "prototype_envirohelm"
	light_overlay = null
	actions_types = list(/datum/action/item_action/toggle_welding_screen/plasmaman)
	smile_state = "prototype_smile"
	visor_icon = "prototype_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/botany
	name = "botany plasma envirosuit helmet"
	desc = "A green and blue envirohelmet designating it's wearer as a botanist. While not specially designed for it, it would protect against minor planet-related injuries."
	icon_state = "botany_envirohelm"
	item_state = "botany_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/janitor
	name = "janitor's plasma envirosuit helmet"
	desc = "A grey helmet bearing a pair of purple stripes, designating the wearer as a janitor."
	icon_state = "janitor_envirohelm"
	item_state = "janitor_envirohelm"

/obj/item/clothing/head/helmet/space/plasmaman/mime
	name = "mime envirosuit helmet"
	desc = "The make-up is painted on, it's a miracle it doesn't chip. It's not very colourful."
	icon_state = "mime_envirohelm"
	item_state = "mime_envirohelm"
	light_overlay = "mime_envirohelm-light"
	visor_icon = "mime_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/clown
	name = "clown envirosuit helmet"
	desc = "The make-up is painted on, it's a miracle it doesn't chip. <i>'HONK!'</i>"
	icon_state = "clown_envirohelm"
	item_state = "clown_envirohelm"
	light_overlay = "clown_envirohelm-light"
	item_state = "clown_envirohelm"
	visor_icon = "clown_envisor"
	smile_state = "clown_smile"
