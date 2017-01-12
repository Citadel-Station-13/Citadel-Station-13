/obj/item/device/soulstone
	name = "soulstone shard"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'. The shard still flickers with a fraction of the full artefact's power."
	w_class = 1
	slot_flags = SLOT_BELT
	origin_tech = "bluespace=4;materials=5"
	var/usability = 0

	var/reusable = TRUE
	var/spent = FALSE

/obj/item/device/soulstone/proc/was_used()
	if(!reusable)
		spent = TRUE
		name = "dull [name]"
		desc = "A fragment of the legendary treasure known simply as \
			the 'Soul Stone'. The shard lies still, dull and lifeless; \
			whatever spark it once held long extinguished."

/obj/item/device/soulstone/anybody
	usability = 1

/obj/item/device/soulstone/anybody/chaplain
	name = "mysterious old shard"
	reusable = FALSE

/obj/item/device/soulstone/pickup(mob/living/user)
	..()
	if(!iscultist(user) && !iswizard(user) && !usability)
		user << "<span class='danger'>An overwhelming feeling of dread comes over you as you pick up the soulstone. It would be wise to be rid of this quickly.</span>"
		user.Dizzy(120)

/obj/item/device/soulstone/examine(mob/user)
	..()
	if(usability || iscultist(user) || iswizard(user) || isobserver(user))
		user << "<span class='cult'>A soulstone, used to capture souls, either from unconscious or sleeping humans or from freed shades.</span>"
		user << "<span class='cult'>The captured soul can be placed into a construct shell to produce a construct, or released from the stone as a shade.</span>"
		if(spent)
			user << "<span class='cult'>This shard is spent; it is now just \
				a creepy rock.</span>"

//////////////////////////////Capturing////////////////////////////////////////////////////////

/obj/item/device/soulstone/attack(mob/living/carbon/human/M, mob/user)
	if(!iscultist(user) && !iswizard(user) && !usability)
		user.Paralyse(5)
		user << "<span class='userdanger'>Your body is wracked with debilitating pain!</span>"
		return
	if(spent)
		user << "<span class='warning'>There is no power left in the shard.\
			</span>"
		return
	if(!istype(M, /mob/living/carbon/human))//If target is not a human.
		return ..()
	if(iscultist(M))
		user << "<span class='cultlarge'>\"Come now, do not capture your fellow's soul.\"</span>"
		return
	add_logs(user, M, "captured [M.name]'s soul", src)

	transfer_soul("VICTIM", M, user)

///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/device/soulstone/attack_self(mob/user)
	if(!in_range(src, user))
		return
	if(!iscultist(user) && !iswizard(user) && !usability)
		user.Paralyse(5)
		user << "<span class='userdanger'>Your body is wracked with debilitating pain!</span>"
		return
	for(var/mob/living/simple_animal/shade/A in src)
		A.status_flags &= ~GODMODE
		A.canmove = 1
		A.forceMove(get_turf(user))
		A.cancel_camera()
		icon_state = "soulstone"
		name = initial(name)
		if(iswizard(user) || usability)
			A << "<b>You have been released from your prison, but you are still bound to [user.real_name]'s will. Help them succeed in their goals at all costs.</b>"
		else if(iscultist(user))
			A << "<b>You have been released from your prison, but you are still bound to the cult's will. Help them succeed in their goals at all costs.</b>"
		was_used()

///////////////////////////Transferring to constructs/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct-cult"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/examine(mob/user)
	..()
	if(iscultist(user) || iswizard(user) || user.stat == DEAD)
		user << "<span class='cult'>A construct shell, used to house bound souls from a soulstone.</span>"
		user << "<span class='cult'>Placing a soulstone with a soul into this shell allows you to produce your choice of the following:</span>"
		user << "<span class='cult'>An <b>Artificer</b>, which can produce <b>more shells and soulstones</b>, as well as fortifications.</span>"
		user << "<span class='cult'>A <b>Wraith</b>, which does high damage and can jaunt through walls, though it is quite fragile.</span>"
		user << "<span class='cult'>A <b>Juggernaut</b>, which is very hard to kill and can produce temporary walls, but is slow.</span>"

/obj/structure/constructshell/attackby(obj/item/O, mob/user, params)
	if(istype(O, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/SS = O
		if(!iscultist(user) && !iswizard(user) && !SS.usability)
			user << "<span class='danger'>An overwhelming feeling of dread comes over you as you attempt to place the soulstone into the shell. It would be wise to be rid of this quickly.</span>"
			user.Dizzy(120)
			return
		SS.transfer_soul("CONSTRUCT",src,user)
		SS.was_used()
	else
		return ..()

////////////////////////////Proc for moving soul in and out off stone//////////////////////////////////////


/obj/item/device/soulstone/proc/transfer_soul(choice as text, target, mob/user).
	switch(choice)
		if("FORCE")
			if(!iscarbon(target))		//TODO: Add sacrifice stoning for non-organics, just because you have no body doesnt mean you dont have a soul
				return 0
			if(contents.len)
				return 0
			var/mob/living/carbon/T = target
			if(T.client != null)
				for(var/obj/item/W in T)
					T.unEquip(W)
				init_shade(T, user)
				return 1
			else
				user << "<span class='userdanger'>Capture failed!</span>: The soul has already fled its mortal frame. You attempt to bring it back..."
				return getCultGhost(T,user)

		if("VICTIM")
			var/mob/living/carbon/human/T = target
			if(ticker.mode.name == "cult" && T.mind == ticker.mode:sacrifice_target)
				if(iscultist(user))
					user << "<span class='cult'><b>\"This soul is mine.</b></span> <span class='cultlarge'>SACRIFICE THEM!\"</span>"
				else
					user << "<span class='danger'>The soulstone doesn't work for no apparent reason.</span>"
				return 0
			if(contents.len)
				user << "<span class='userdanger'>Capture failed!</span>: The soulstone is full! Free an existing soul to make room."
			else
				if(T.stat != CONSCIOUS)
					if(T.client == null)
						user << "<span class='userdanger'>Capture failed!</span>: The soul has already fled its mortal frame. You attempt to bring it back..."
						getCultGhost(T,user)
					else
						for(var/obj/item/W in T)
							T.unEquip(W)
						init_shade(T, user, vic = 1)
						qdel(T)
				else
					user << "<span class='userdanger'>Capture failed!</span>: Kill or maim the victim first!"

		if("SHADE")
			var/mob/living/simple_animal/shade/T = target
			if(contents.len)
				user << "<span class='userdanger'>Capture failed!</span>: The soulstone is full! Free an existing soul to make room."
			else
				T.loc = src //put shade in stone
				T.status_flags |= GODMODE
				T.canmove = 0
				T.health = T.maxHealth
				icon_state = "soulstone2"
				name = "soulstone: Shade of [T.real_name]"
				T << "<span class='notice'>Your soul has been captured by the soulstone. Its arcane energies are reknitting your ethereal form.</span>"
				if(user != T)
					user << "<span class='info'><b>Capture successful!</b>:</span> [T.real_name]'s soul has been captured and stored within the soulstone."

		if("CONSTRUCT")
			var/obj/structure/constructshell/T = target
			var/mob/living/simple_animal/shade/A = locate() in src
			if(A)
				var/construct_class = alert(user, "Please choose which type of construct you wish to create.",,"Juggernaut","Wraith","Artificer")
				if(!T || !T.loc)
					return
				switch(construct_class)
					if("Juggernaut")
						makeNewConstruct(/mob/living/simple_animal/hostile/construct/armored, A, user, 0, T.loc)

					if("Wraith")
						makeNewConstruct(/mob/living/simple_animal/hostile/construct/wraith, A, user, 0, T.loc)

					if("Artificer")
						if(iscultist(user) || iswizard(user))
							makeNewConstruct(/mob/living/simple_animal/hostile/construct/builder, A, user, 0, T.loc)

						else
							makeNewConstruct(/mob/living/simple_animal/hostile/construct/builder/noncult, A, user, 0, T.loc)

				qdel(T)
				user.drop_item()
				qdel(src)
			else
				user << "<span class='userdanger'>Creation failed!</span>: The soul stone is empty! Go kill someone!"


/proc/makeNewConstruct(mob/living/simple_animal/hostile/construct/ctype, mob/target, mob/stoner = null, cultoverride = 0, loc_override = null)
	var/mob/living/simple_animal/hostile/construct/newstruct = new ctype((loc_override) ? (loc_override) : (get_turf(target)))
	newstruct.faction |= "\ref[stoner]"
	newstruct.key = target.key
	if(newstruct.mind)
		if(stoner && iscultist(stoner) || cultoverride)
			if(ticker.mode.name == "cult")
				ticker.mode:add_cultist(newstruct.mind, 0)
			else
				ticker.mode.cult += newstruct.mind
			ticker.mode.update_cult_icons_added(newstruct.mind)
	newstruct << newstruct.playstyle_string
	if(iscultist(stoner))
		newstruct << "<b>You are still bound to serve the cult and [stoner], follow their orders and help them complete their goals at all costs.</b>"
	else
		newstruct << "<b>You are still bound to serve your creator, [stoner], follow their orders and help them complete their goals at all costs.</b>"
	newstruct.cancel_camera()


/obj/item/device/soulstone/proc/init_shade(mob/living/carbon/human/T, mob/U, vic = 0)
	new /obj/effect/decal/remains/human(T.loc) //Spawns a skeleton
	T.invisibility = INVISIBILITY_ABSTRACT
	var/atom/movable/overlay/animation = new /atom/movable/overlay( T.loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = T
	flick("dust-h", animation)
	qdel(animation)
	var/mob/living/simple_animal/shade/S = new /mob/living/simple_animal/shade(src)
	S.status_flags |= GODMODE //So they won't die inside the stone somehow
	S.canmove = 0//Can't move out of the soul stone
	S.name = "Shade of [T.real_name]"
	S.real_name = "Shade of [T.real_name]"
	S.key = T.key
	if(U)
		S.faction |= "\ref[U]" //Add the master as a faction, allowing inter-mob cooperation
	if(U && iscultist(U))
		ticker.mode.add_cultist(S.mind, 0)
	S.cancel_camera()
	name = "soulstone: Shade of [T.real_name]"
	icon_state = "soulstone2"
	if(U && (iswizard(U) || usability))
		S << "Your soul has been captured! You are now bound to [U.real_name]'s will. Help them succeed in their goals at all costs."
	else if(U && iscultist(U))
		S << "Your soul has been captured! You are now bound to the cult's will. Help them succeed in their goals at all costs."
	if(vic && U)
		U << "<span class='info'><b>Capture successful!</b>:</span> [T.real_name]'s soul has been ripped from their body and stored within the soul stone."


/obj/item/device/soulstone/proc/getCultGhost(mob/living/carbon/human/T, mob/U)
	var/mob/dead/observer/chosen_ghost

	for(var/mob/dead/observer/ghost in player_list) //We put them back in their body
		if(ghost.mind && ghost.mind.current == T && ghost.client)
			chosen_ghost = ghost
			break

	if(!chosen_ghost)	//Failing that, we grab a ghost
		var/list/consenting_candidates = pollCandidates("Would you like to play as a Shade?", "Cultist", null, ROLE_CULTIST, poll_time = 100)
		if(consenting_candidates.len)
			chosen_ghost = pick(consenting_candidates)
	if(!T)
		return 0
	if(!chosen_ghost)
		U << "<span class='danger'>There were no spirits willing to become a shade.</span>"
		return 0
	if(contents.len) //If they used the soulstone on someone else in the meantime
		return 0
	T.ckey = chosen_ghost.ckey
	for(var/obj/item/W in T)
		T.unEquip(W)
	init_shade(T, U)
	qdel(T)
	return 1
