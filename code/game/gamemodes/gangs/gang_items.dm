/datum/gang_item
	var/name
	var/item_path
	var/cost
	var/spawn_msg
	var/category
	var/list/gang_whitelist = list()
	var/list/gang_blacklist = list()
	var/id

/datum/gang_item/proc/purchase(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool, check_canbuy = TRUE)
	if(check_canbuy && !can_buy(user, gang, gangtool))
		return FALSE
	var/real_cost = get_cost(user, gang, gangtool)
	if(!spawn_item(user, gang, gangtool))
		gang.adjust_influence(-real_cost)
		to_chat(user, "<span class='notice'>You bought \the [name].</span>")
		return TRUE

/datum/gang_item/proc/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool) // If this returns anything other than null, something fucked up and influence won't lower.
	if(item_path)
		var/obj/item/O = new item_path(user.loc)
		user.put_in_hands(O)
	else
		return TRUE
	if(spawn_msg)
		to_chat(user, "[spawn_msg]")

/datum/gang_item/proc/can_buy(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	return gang && (gang.influence >= get_cost(user, gang, gangtool)) && can_see(user, gang, gangtool)

/datum/gang_item/proc/can_see(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	return TRUE

/datum/gang_item/proc/get_cost(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	return cost

/datum/gang_item/proc/get_cost_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	return "([get_cost(user, gang, gangtool)] Influence)"

/datum/gang_item/proc/get_name_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	return name

/datum/gang_item/proc/get_extra_info(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	return

///////////////////
//CLOTHING
///////////////////

/datum/gang_item/clothing
	category = "Purchase Gang Clothes (Only the jumpsuit and suit give you added influence):"

/datum/gang_item/clothing/under
	name = "Gang Uniform"
	id = "under"
	cost = 1

/datum/gang_item/clothing/under/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(gang.inner_outfits.len)
		var/outfit = pick(gang.inner_outfits)
		if(outfit)
			var/obj/item/O = new outfit(user.loc)
			user.put_in_hands(O)
			to_chat(user, "<span class='notice'> This is your gang's official uniform, wearing it will increase your influence")
			return
	return TRUE

/datum/gang_item/clothing/suit
	name = "Gang Armored Outerwear"
	id = "suit"
	cost = 1

/datum/gang_item/clothing/suit/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(gang.outer_outfits.len)
		var/outfit = pick(gang.outer_outfits)
		if(outfit)
			var/obj/item/O = new outfit(user.loc)
			O.armor = O.armor.setRating(melee = 25, bullet = 35, laser = 15, energy = 10, bomb = 30, bio = 0, rad = 0, fire = 30, acid = 30)
			O.desc += " Tailored for the [gang.name] Gang to offer the wearer moderate protection against ballistics and physical trauma."
			user.put_in_hands(O)
			to_chat(user, "<span class='notice'> This is your gang's official outerwear, wearing it will increase your influence")
			return
	return TRUE

/datum/gang_item/clothing/hat
	name = "Pimp Hat"
	id = "hat"
	cost = 16
	item_path = /obj/item/clothing/head/collectable/petehat/gang

/obj/item/clothing/head/collectable/petehat/gang
	name = "pimpin' hat"
	desc = "The undisputed king of style."

/datum/gang_item/clothing/mask
	name = "Golden Death Mask"
	id = "mask"
	cost = 18
	item_path = /obj/item/clothing/mask/gskull

/obj/item/clothing/mask/gskull
	name = "golden death mask"
	icon_state = "gskull"
	desc = "Strike terror, and envy, into the hearts of your enemies."

/datum/gang_item/clothing/shoes
	name = "Bling Boots"
	id = "boots"
	cost = 20
	item_path = /obj/item/clothing/shoes/gang

/obj/item/clothing/shoes/gang
	name = "blinged-out boots"
	desc = "Stand aside peasants."
	icon_state = "bling"

/datum/gang_item/clothing/neck
	name = "Gold Necklace"
	id = "necklace"
	cost = 9
	item_path = /obj/item/clothing/neck/necklace/dope

/datum/gang_item/clothing/hands
	name = "Decorative Brass Knuckles"
	id = "hand"
	cost = 11
	item_path = /obj/item/clothing/gloves/gang

/obj/item/clothing/gloves/gang
	name = "braggadocio's brass knuckles"
	desc = "Purely decorative, don't find out the hard way."
	icon_state = "knuckles"
	w_class = 3

datum/gang_item/clothing/shades //Addition: Why not have cool shades on a gang member anyways?
	name = "Cool Sunglasses"
	id = "glasses"
	cost = 5
	item_path = /obj/item/clothing/glasses/sunglasses

/datum/gang_item/clothing/belt
	name = "Badass Belt"
	id = "belt"
	cost = 13
	item_path = /obj/item/storage/belt/military/gang

/obj/item/storage/belt/military/gang
	name = "badass belt"
	icon_state = "gangbelt"
	item_state = "gang"
	desc = "The belt buckle simply reads 'BAMF'."

///////////////////
//WEAPONS
///////////////////

/datum/gang_item/weapon
	category = "Purchase Weapons:"

/datum/gang_item/weapon/ammo

/datum/gang_item/weapon/shuriken
	name = "Shuriken"
	id = "shuriken"
	cost = 2
	item_path = /obj/item/throwing_star

/datum/gang_item/weapon/switchblade
	name = "Switchblade"
	id = "switchblade"
	cost = 5
	item_path = /obj/item/switchblade

/datum/gang_item/weapon/surplus //For when a gang boss is extra broke or cheap.
	name = "Surplus Rifle"
	id = "surplus"
	cost = 6
	item_path = /obj/item/gun/ballistic/automatic/surplus

/datum/gang_item/weapon/ammo/surplus_ammo
	name = "Surplus Rifle Ammo"
	id = "surplus_ammo"
	cost = 3
	item_path = /obj/item/ammo_box/magazine/m10mm/rifle

/datum/gang_item/weapon/improvised
	name = "Sawn-Off Improvised Shotgun"
	id = "sawn"
	cost = 5
	item_path = /obj/item/gun/ballistic/revolver/doublebarrel/improvised/sawn

/datum/gang_item/weapon/ammo/improvised_ammo
	name = "Box of Buckshot"
	id = "buckshot"
	cost = 5
	item_path = /obj/item/storage/box/lethalshot

/datum/gang_item/weapon/pistol
	name = "10mm Pistol"
	id = "pistol"
	cost = 25
	item_path = /obj/item/gun/ballistic/automatic/pistol

/datum/gang_item/weapon/ammo/pistol_ammo
	name = "10mm Ammo"
	id = "pistol_ammo"
	cost = 10
	item_path = /obj/item/ammo_box/magazine/m10mm

/datum/gang_item/weapon/sniper
	name = "Black Market .50cal Sniper Rifle"
	id = "sniper"
	cost = 35
	item_path = /obj/item/gun/ballistic/automatic/sniper_rifle

/datum/gang_item/weapon/ammo/sniper_ammo
	name = "Smuggled .50cal Sniper Rounds"
	id = "sniper_ammo"
	cost = 15
	item_path = /obj/item/ammo_box/magazine/sniper_rounds

/*/datum/gang_item/weapon/ammo/sleeper_ammo	//no. absolutely no.
	name = "Illicit Soporific Cartridges"
	id = "sniper_ammo"
	cost = 15	//who the fuck thought a ONE-HIT K.O. for 15 gbp IN AN ENVIRONMENT WHERE WE'RE GETTING RID OF HARDSTUNS is a GOOD IDEA
	item_path = /obj/item/ammo_box/magazine/sniper_rounds/soporific*/

/datum/gang_item/weapon/machinegun
	name = "Mounted Machine Gun"
	id = "MG"
	cost = 45
	item_path = /obj/machinery/manned_turret
	spawn_msg = "<span class='notice'>The mounted machine gun features enhanced responsiveness. Hold down on the trigger while firing to control where you're shooting.</span>"

/datum/gang_item/weapon/machinegun/spawn_item(mob/living/carbon/user, obj/item/device/gangtool/gangtool)
	new item_path(user.loc)
	to_chat(user, spawn_msg)

/datum/gang_item/weapon/uzi
	name = "Uzi SMG"
	id = "uzi"
	cost = 50
	item_path = /obj/item/gun/ballistic/automatic/mini_uzi

/datum/gang_item/weapon/ammo/uzi_ammo
	name = "Uzi Ammo"
	id = "uzi_ammo"
	cost = 20
	item_path = /obj/item/ammo_box/magazine/uzim9mm

///////////////////
//EQUIPMENT
///////////////////

/datum/gang_item/equipment
	category = "Purchase Equipment:"

/datum/gang_item/equipment/spraycan
	name = "Territory Spraycan"
	id = "spraycan"
	cost = 1
	item_path = /obj/item/toy/crayon/spraycan/gang

/datum/gang_item/equipment/spraycan/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	var/obj/item/O = new item_path(user.loc, gang)
	user.put_in_hands(O)

/datum/gang_item/equipment/sharpener
	name = "Sharpener"
	id = "whetstone"
	cost = 3
	item_path = /obj/item/sharpener

/datum/gang_item/equipment/emp
	name = "EMP Grenade"
	id = "EMP"
	cost = 7
	item_path = /obj/item/grenade/empgrenade

/datum/gang_item/equipment/c4
	name = "C4 Explosive"
	id = "c4"
	cost = 7
	item_path = /obj/item/grenade/plastic/c4

/datum/gang_item/equipment/frag
	name = "Fragmentation Grenade"
	id = "frag nade"
	cost = 5
	item_path = /obj/item/grenade/syndieminibomb/concussion/frag

/datum/gang_item/equipment/implant_breaker
	name = "Implant Breaker"
	id = "implant_breaker"
	cost = 10
	item_path = /obj/item/implanter/gang

/datum/gang_item/equipment/implant_breaker/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	var/obj/item/O = new item_path(user.loc, gang)
	user.put_in_hands(O)
	to_chat(user, "<span class='notice'>The <b>implant breaker</b> is a single-use device that destroys all implants within the target before trying to recruit them to your gang. Also works on enemy gangsters.</span>")

/datum/gang_item/equipment/wetwork_boots
	name = "Wetwork boots"
	id = "wetwork"
	cost = 8
	item_path = /obj/item/clothing/shoes/combat/gang

/obj/item/clothing/shoes/combat/gang
	name = "Wetwork boots"
	desc = "A gang's best hitmen are prepared for anything."
	permeability_coefficient = 0.01
	clothing_flags = NOSLIP

datum/gang_item/equipment/shield
	name = "Riot Shield"
	id = "riot_shield"
	cost = 25
	item_path = /obj/item/shield/riot

datum/gang_item/equipment/gangsheild
	name = "Tower Shield"
	id = "metal"
	cost = 45 //High block of melee and even higher for bullets
	item_path = /obj/item/shield/riot/tower

/datum/gang_item/equipment/pen
	name = "Recruitment Pen"
	id = "pen"
	cost = 20
	item_path = /obj/item/pen/gang
	spawn_msg = "<span class='notice'>More <b>recruitment pens</b> will allow you to recruit gangsters faster. Only gang leaders can recruit with pens.</span>"

/datum/gang_item/equipment/pen/purchase(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(..())
		gangtool.free_pen = FALSE
		return TRUE
	return FALSE

/datum/gang_item/equipment/pen/get_cost(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(gangtool && gangtool.free_pen)
		return 0
	return ..()

/datum/gang_item/equipment/pen/get_cost_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(gangtool && gangtool.free_pen)
		return "(GET ONE FREE)"
	return ..()

/datum/gang_item/equipment/gangtool
	id = "gangtool"
	cost = 5

/datum/gang_item/equipment/gangtool/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	var/item_type
	if(gang)
		item_type = /obj/item/device/gangtool/spare/lt
		if(gang.leaders.len < MAX_LEADERS_GANG)
			to_chat(user, "<span class='notice'><b>Gangtools</b> allow you to promote a gangster to be your Lieutenant, enabling them to recruit and purchase items like you. Simply have them register the gangtool. You may promote up to [MAX_LEADERS_GANG-gang.leaders.len] more Lieutenants</span>")
	else
		item_type = /obj/item/device/gangtool/spare
	var/obj/item/device/gangtool/spare/tool = new item_type(user.loc)
	user.put_in_hands(tool)

/datum/gang_item/equipment/gangtool/get_name_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(gang && (gang.leaders.len < gang.max_leaders))
		return "Promote a Gangster"
	return "Spare Gangtool"

/datum/gang_item/equipment/dominator
	name = "Station Dominator"
	id = "dominator"
	cost = 30
	item_path = /obj/machinery/dominator
	spawn_msg = "<span class='notice'>The <b>dominator</b> will secure your gang's dominance over the station. Turn it on when you are ready to defend it.</span>"

/datum/gang_item/equipment/dominator/can_buy(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return FALSE
	return ..()

/datum/gang_item/equipment/dominator/get_name_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return ..()
	return "<b>[..()]</b>"

/datum/gang_item/equipment/dominator/get_cost_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return "(Out of stock)"
	return ..()

/datum/gang_item/equipment/dominator/get_extra_info(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	if(gang)
		return "This device requires a 5x5 area clear of walls to FUNCTION. (Estimated Takeover Time: [round(gang.determine_domination_time()/60,0.1)] minutes)"

/datum/gang_item/equipment/dominator/purchase(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	var/area/userarea = get_base_area(user)
	if(!(userarea.type in gang.territories|gang.new_territories))
		to_chat(user,"<span class='warning'>The <b>dominator</b> can be spawned only on territory controlled by your gang!</span>")
		return FALSE
	for(var/obj/obj in get_turf(user))
		if(obj.density)
			to_chat(user, "<span class='warning'>There's not enough room here!</span>")
			return FALSE

	return ..()

/datum/gang_item/equipment/dominator/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/device/gangtool/gangtool)
	new item_path(user.loc)
	to_chat(user, spawn_msg)
