#define WHITE_TEAM "white"
#define RED_TEAM "red"
#define BLUE_TEAM "blue"
#define FLAG_RETURN_TIME 200 // 20 seconds
#define INSTAGIB_RESPAWN 50 //5 seconds
#define DEFAULT_RESPAWN 150 //15 seconds



/obj/item/weapon/twohanded/required/ctf
	name = "banner"
	icon = 'icons/obj/items.dmi'
	icon_state = "banner"
	item_state = "banner"
	desc = "A banner with Nanotrasen's logo on it."
	slowdown = 2
	throw_speed = 0
	throw_range = 1
	force = 200
	armour_penetration = 1000
	anchored = TRUE
	flags = HANDSLOW
	var/team = WHITE_TEAM
	var/reset_cooldown = 0
	var/obj/effect/ctf/flag_reset/reset
	var/reset_path = /obj/effect/ctf/flag_reset

/obj/item/weapon/twohanded/required/ctf/New()
	if(!reset)
		reset = new reset_path(get_turf(src))

/obj/item/weapon/twohanded/required/ctf/Destroy()
	if(reset)
		qdel(reset)
		reset = null
	. = ..()

/obj/item/weapon/twohanded/required/ctf/initialize()
	if(!reset)
		reset = new reset_path(get_turf(src))

/obj/item/weapon/twohanded/required/ctf/process()
	if(world.time > reset_cooldown)
		forceMove(get_turf(src.reset))
		for(var/mob/M in player_list)
			var/area/mob_area = get_area(M)
			if(istype(mob_area, /area/ctf))
				M << "<span class='userdanger'>\The [src] has been returned \
					to base!</span>"
		STOP_PROCESSING(SSobj, src)

/obj/item/weapon/twohanded/required/ctf/attack_hand(mob/living/user)
	if(!user)
		return
	if(team in user.faction)
		user << "You can't move your own flag!"
		return
	if(loc == user)
		if(!user.unEquip(src))
			return
	anchored = FALSE
	pickup(user)
	if(!user.put_in_active_hand(src))
		dropped(user)
		return
	for(var/mob/M in player_list)
		var/area/mob_area = get_area(M)
		if(istype(mob_area, /area/ctf))
			M << "<span class='userdanger'>\The [src] has been taken!</span>"
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/twohanded/required/ctf/dropped(mob/user)
	..()
	reset_cooldown = world.time + 200 //20 seconds
	START_PROCESSING(SSobj, src)
	for(var/mob/M in player_list)
		var/area/mob_area = get_area(M)
		if(istype(mob_area, /area/ctf))
			M << "<span class='userdanger'>\The [src] has been dropped!</span>"
	anchored = TRUE


/obj/item/weapon/twohanded/required/ctf/red
	name = "red flag"
	icon_state = "banner-red"
	item_state = "banner-red"
	desc = "A red banner used to play capture the flag."
	team = RED_TEAM
	reset_path = /obj/effect/ctf/flag_reset/red


/obj/item/weapon/twohanded/required/ctf/blue
	name = "blue flag"
	icon_state = "banner-blue"
	item_state = "banner-blue"
	desc = "A blue banner used to play capture the flag."
	team = BLUE_TEAM
	reset_path = /obj/effect/ctf/flag_reset/blue

/obj/effect/ctf/flag_reset
	name = "banner landmark"
	icon = 'icons/obj/items.dmi'
	icon_state = "banner"
	desc = "This is where a banner with Nanotrasen's logo on it would go."
	layer = LOW_ITEM_LAYER

/obj/effect/ctf/flag_reset/red
	name = "red flag landmark"
	icon_state = "banner-red"
	desc = "This is where a red banner used to play capture the flag \
		would go."

/obj/effect/ctf/flag_reset/blue
	name = "blue flag landmark"
	icon_state = "banner-blue"
	desc = "This is where a blue banner used to play capture the flag \
		would go."

/obj/machinery/capture_the_flag
	name = "CTF Controller"
	desc = "Used for running friendly games of capture the flag."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"
	anchored = 1
	var/team = WHITE_TEAM
	//Capture the Flag scoring
	var/points = 0
	var/points_to_win = 3
	var/respawn_cooldown = DEFAULT_RESPAWN
	//Capture Point/King of the Hill scoring
	var/control_points = 0
	var/control_points_to_win = 180
	var/list/team_members = list()
	var/ctf_enabled = FALSE
	var/ctf_gear = /datum/outfit/ctf
	var/instagib_gear = /datum/outfit/ctf/instagib
	var/list/dead_barricades = list()

	var/static/ctf_object_typecache
	var/static/arena_cleared = FALSE

/obj/machinery/capture_the_flag/New()
	..()
	if(!ctf_object_typecache)
		ctf_object_typecache = typecacheof(list(
			/turf,
			/mob,
			/area,
			/obj/machinery,
			/obj/structure,
			/obj/effect/ctf,
			/obj/item/weapon/twohanded/required/ctf
		))
	poi_list |= src

/obj/machinery/capture_the_flag/Destroy()
	poi_list.Remove(src)
	..()

/obj/machinery/capture_the_flag/red
	name = "Red CTF Controller"
	icon_state = "syndbeacon"
	team = RED_TEAM
	ctf_gear = /datum/outfit/ctf/red
	instagib_gear = /datum/outfit/ctf/red/instagib

/obj/machinery/capture_the_flag/blue
	name = "Blue CTF Controller"
	icon_state = "bluebeacon"
	team = BLUE_TEAM
	ctf_gear = /datum/outfit/ctf/blue
	instagib_gear = /datum/outfit/ctf/blue/instagib

/obj/machinery/capture_the_flag/attack_ghost(mob/user)
	if(ctf_enabled == FALSE)
		return
	if(ticker.current_state != GAME_STATE_PLAYING)
		return
	if(user.ckey in team_members)
		if(user.mind.current && user.mind.current.timeofdeath + respawn_cooldown > world.time)
			user << "It must be more than [respawn_cooldown/10] seconds from your last death to respawn!"
			return
		var/client/new_team_member = user.client
		dust_old(user)
		spawn_team_member(new_team_member)
		return

	for(var/obj/machinery/capture_the_flag/CTF in machines)
		if(CTF == src || CTF.ctf_enabled == FALSE)
			continue
		if(user.ckey in CTF.team_members)
			user << "No switching teams while the round is going!"
			return
		if(CTF.team_members.len < src.team_members.len)
			user << "[src.team] has more team members than [CTF.team]. Try joining [CTF.team] to even things up."
			return
	team_members |= user.ckey
	var/client/new_team_member = user.client
	dust_old(user)
	spawn_team_member(new_team_member)

/obj/machinery/capture_the_flag/proc/dust_old(mob/user)
	if(user.mind && user.mind.current && user.mind.current.z == src.z)
		new /obj/item/ammo_box/magazine/recharge/ctf (get_turf(user.mind.current))
		new /obj/item/ammo_box/magazine/recharge/ctf (get_turf(user.mind.current))
		user.mind.current.dust()


/obj/machinery/capture_the_flag/proc/spawn_team_member(client/new_team_member)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(get_turf(src))
	new_team_member.prefs.copy_to(M)
	M.key = new_team_member.key
	M.faction += team
	M.equipOutfit(ctf_gear)

/obj/machinery/capture_the_flag/Topic(href, href_list)
	if(href_list["join"])
		var/mob/dead/observer/ghost = usr
		if(istype(ghost))
			attack_ghost(ghost)

/obj/machinery/capture_the_flag/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/twohanded/required/ctf))
		var/obj/item/weapon/twohanded/required/ctf/flag = I
		if(flag.team != src.team)
			user.unEquip(flag)
			flag.loc = get_turf(flag.reset)
			points++
			for(var/mob/M in player_list)
				var/area/mob_area = get_area(M)
				if(istype(mob_area, /area/ctf))
					M << "<span class='userdanger'>[user.real_name] has captured \the [flag], scoring a point for [team] team! They now have [points]/[points_to_win] points!</span>"
		if(points >= points_to_win)
			victory()

/obj/machinery/capture_the_flag/proc/victory()
	for(var/mob/M in mob_list)
		var/area/mob_area = get_area(M)
		if(istype(mob_area, /area/ctf))
			M << "<span class='narsie'>[team] team wins!</span>"
			M << "<span class='userdanger'>The game has been reset! Teams have been cleared. The machines will be active again in 30 seconds.</span>"
			for(var/obj/item/weapon/twohanded/required/ctf/W in M)
				M.unEquip(W)
			M.dust()
	for(var/obj/machinery/control_point/control in machines)
		control.icon_state = "dominator"
		control.controlling = null
	for(var/obj/machinery/capture_the_flag/CTF in machines)
		if(CTF.ctf_enabled == TRUE)
			CTF.points = 0
			CTF.control_points = 0
			CTF.ctf_enabled = FALSE
			CTF.team_members = list()
			CTF.arena_cleared = FALSE
			addtimer(CTF, "start_ctf", 300)

/obj/machinery/capture_the_flag/proc/toggle_ctf()
	if(!ctf_enabled)
		start_ctf()
		. = TRUE
	else
		stop_ctf()
		. = FALSE

/obj/machinery/capture_the_flag/proc/start_ctf()
	ctf_enabled = TRUE
	for(var/obj/effect/ctf/dead_barricade/ded in dead_barricades)
		ded.respawn()
	dead_barricades.Cut()
	notify_ghosts("[name] has been activated!", enter_link="<a href=?src=\ref[src];join=1>(Click to join the [team] team!)</a> or click on the controller directly!", source = src, action=NOTIFY_ATTACK)

	if(!arena_cleared)
		clear_the_arena()
		arena_cleared = TRUE

/obj/machinery/capture_the_flag/proc/clear_the_arena()
	var/area/A = get_area(src)
	for(var/atm in A)
		if(!is_type_in_typecache(atm, ctf_object_typecache))
			qdel(atm)

/obj/machinery/capture_the_flag/proc/stop_ctf()
	ctf_enabled = FALSE
	var/area/A = get_area(src)
	for(var/i in mob_list)
		var/mob/M = i
		if((get_area(A) == A) && (M.ckey in team_members))
			M.dust()
	team_members.Cut()

/obj/machinery/capture_the_flag/proc/instagib_mode()
	for(var/obj/machinery/capture_the_flag/CTF in machines)
		if(CTF.ctf_enabled == TRUE)
			CTF.ctf_gear = CTF.instagib_gear
			CTF.respawn_cooldown = INSTAGIB_RESPAWN

/obj/machinery/capture_the_flag/proc/normal_mode()
	for(var/obj/machinery/capture_the_flag/CTF in machines)
		if(CTF.ctf_enabled == TRUE)
			CTF.ctf_gear = initial(ctf_gear)
			CTF.respawn_cooldown = DEFAULT_RESPAWN

/obj/item/weapon/gun/projectile/automatic/pistol/deagle/CTF
	desc = "This looks like it could really hurt in melee."
	force = 75

/obj/item/weapon/gun/projectile/automatic/laser/ctf
	mag_type = /obj/item/ammo_box/magazine/recharge/ctf
	desc = "This looks like it could really hurt in melee."
	force = 50

/obj/item/ammo_box/magazine/recharge/ctf
	ammo_type = /obj/item/ammo_casing/caseless/laser/ctf

/obj/item/ammo_casing/caseless/laser/ctf
	projectile_type = /obj/item/projectile/beam/ctf

/obj/item/projectile/beam/ctf
	damage = 150

/obj/item/weapon/gun/projectile/automatic/laser/ctf/red
	mag_type = /obj/item/ammo_box/magazine/recharge/ctf/red

/obj/item/ammo_box/magazine/recharge/ctf/red
	ammo_type = /obj/item/ammo_casing/caseless/laser/ctf/red

/obj/item/ammo_casing/caseless/laser/ctf/red
	projectile_type = /obj/item/projectile/beam/ctf/red

/obj/item/projectile/beam/ctf/red
	icon_state = "laser"

/obj/item/weapon/gun/projectile/automatic/laser/ctf/blue
	mag_type = /obj/item/ammo_box/magazine/recharge/ctf/blue

/obj/item/ammo_box/magazine/recharge/ctf/blue
	ammo_type = /obj/item/ammo_casing/caseless/laser/ctf/blue

/obj/item/ammo_casing/caseless/laser/ctf/blue
	projectile_type = /obj/item/projectile/beam/ctf/blue

/obj/item/projectile/beam/ctf/blue
	icon_state = "bluelaser"

/datum/outfit/ctf
	name = "CTF"
	/obj/item/device/radio/headset
	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/space/hardsuit/shielded/ctf
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/combat
	id = /obj/item/weapon/card/id/syndicate
	belt = /obj/item/weapon/gun/projectile/automatic/pistol/deagle/CTF
	l_pocket = /obj/item/ammo_box/magazine/recharge/ctf
	r_pocket = /obj/item/ammo_box/magazine/recharge/ctf
	r_hand = /obj/item/weapon/gun/projectile/automatic/laser/ctf

/datum/outfit/ctf/instagib
	r_hand = /obj/item/weapon/gun/energy/laser/instakill
	shoes = /obj/item/clothing/shoes/jackboots/fast

/datum/outfit/ctf/red
	ears = /obj/item/device/radio/headset/syndicate/alt
	suit = /obj/item/clothing/suit/space/hardsuit/shielded/ctf/red
	r_hand = /obj/item/weapon/gun/projectile/automatic/laser/ctf/red

/datum/outfit/ctf/red/instagib
	r_hand = /obj/item/weapon/gun/energy/laser/instakill/red
	shoes = /obj/item/clothing/shoes/jackboots/fast

/datum/outfit/ctf/blue
	ears = /obj/item/device/radio/headset/headset_cent/commander
	suit = /obj/item/clothing/suit/space/hardsuit/shielded/ctf/blue
	r_hand = /obj/item/weapon/gun/projectile/automatic/laser/ctf/blue

/datum/outfit/ctf/blue/instagib
	r_hand = /obj/item/weapon/gun/energy/laser/instakill/blue
	shoes = /obj/item/clothing/shoes/jackboots/fast

/datum/outfit/ctf/red/post_equip(mob/living/carbon/human/H)
	var/obj/item/device/radio/R = H.ears
	R.set_frequency(SYND_FREQ)
	R.freqlock = 1

/datum/outfit/ctf/blue/post_equip(mob/living/carbon/human/H)
	var/obj/item/device/radio/R = H.ears
	R.set_frequency(CENTCOM_FREQ)
	R.freqlock = 1



/obj/structure/divine/trap/ctf
	name = "Spawn protection"
	desc = "Stay outta the enemy spawn!"
	icon_state = "trap"
	health = INFINITY
	maxhealth = INFINITY
	var/team = WHITE_TEAM
	constructable = FALSE
	time_between_triggers = 1
	alpha = 255

/obj/structure/divine/trap/examine(mob/user)
	return

/obj/structure/divine/trap/ctf/trap_effect(mob/living/L)
	if(!(src.team in L.faction))
		L << "<span class='danger'><B>Stay out of the enemy spawn!</B></span>"
		L.dust()


/obj/structure/divine/trap/ctf/red
	team = RED_TEAM
	icon_state = "trap-fire"

/obj/structure/divine/trap/ctf/blue
	team = BLUE_TEAM
	icon_state = "trap-frost"

/obj/structure/barricade/security/ctf
	name = "barrier"
	desc = "A barrier. Provides cover in fire fights."

/obj/structure/barricade/security/ctf/make_debris()
	new /obj/effect/ctf/dead_barricade(get_turf(src))

/obj/effect/ctf
	density = FALSE
	anchored = TRUE
	invisibility = INVISIBILITY_OBSERVER
	alpha = 100

/obj/effect/ctf/dead_barricade
	icon = 'icons/obj/objects.dmi'
	icon_state = "barrier0"

/obj/effect/ctf/dead_barricade/New()
	for(var/obj/machinery/capture_the_flag/CTF in machines)
		CTF.dead_barricades += src

/obj/effect/ctf/dead_barricade/proc/respawn()
	if(!qdeleted(src))
		new /obj/structure/barricade/security/ctf(get_turf(src))
		qdel(src)

//Areas

/area/ctf
	name = "Capture the Flag"
	icon_state = "yellow"
	requires_power = 0
	has_gravity = 1

/area/ctf/control_room
	name = "Control Room A"

/area/ctf/control_room2
	name = "Control Room B"

/area/ctf/central
	name = "Central"

/area/ctf/main_hall
	name = "Main Hall A"

/area/ctf/main_hall2
	name = "Main Hall B"

/area/ctf/corridor
	name = "Corridor A"

/area/ctf/corridor2
	name = "Corridor B"

/area/ctf/flag_room
	name = "Flag Room A"

/area/ctf/flag_room2
	name = "Flag Room B"


//Control Point

/obj/machinery/control_point
	name = "control point"
	desc = "You should capture this."
	icon = 'icons/obj/machines/dominator.dmi'
	icon_state = "dominator"
	anchored = 1
	var/obj/machinery/capture_the_flag/controlling
	var/team = "none"
	var/point_rate = 1

/obj/machinery/control_point/process()
	if(controlling)
		controlling.control_points += point_rate
		if(controlling.control_points >= controlling.control_points_to_win)
			controlling.victory()

/obj/machinery/control_point/attackby(mob/user, params)
	capture(user)

/obj/machinery/control_point/attack_hand(mob/user)
	capture(user)

/obj/machinery/control_point/proc/capture(mob/user)
	if(do_after(user, 30, target = src))
		for(var/obj/machinery/capture_the_flag/CTF in machines)
			if(CTF.ctf_enabled && (user.ckey in CTF.team_members))
				controlling = CTF
				icon_state = "dominator-[CTF.team]"
				for(var/mob/M in player_list)
					var/area/mob_area = get_area(M)
					if(istype(mob_area, /area/ctf))
						M << "<span class='userdanger'>[user.real_name] has captured \the [src], claiming it for [CTF.team]! Go take it back!</span>"
				break
