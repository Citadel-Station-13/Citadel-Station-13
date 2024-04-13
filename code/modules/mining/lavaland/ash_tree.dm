//Houses the ash tree, a lava land tree that has been burning for quite some time making a maple like sweetener.

/obj/structure/flora/ashtree
	name = "ashed tree"
	desc = "A once large tree now burnt like the lands around it."
	layer = FLY_LAYER
	gender = PLURAL //same as other tree
	density = TRUE
	pixel_x = -16
	icon = 'icons/obj/lavaland/ash_tree.dmi'
	icon_state = "ashtree"
	//Are icon when we are full of honey or other sap
	var/sap_icon_state = "ashtree_maple"
	//What we look like when tapping
	var/tabbed_icon_state = "ashtree_maple"
	//amout of coal in are tree, simular to logs
	var/coal_amount = 5
	//Do we have sap?
	var/sap = FALSE
	//What reagent we have
	var/sap_type = /datum/reagent/consumable/honey
	//This is in seconds, and now long we wait till are tree is tapped
	var/harvest_sap_time = 60
	var/container_used
	var/sap_amount

/obj/structure/flora/ashtree/Initialize(mapload)
	. = ..()
	if(prob(50))
		sap = TRUE
		icon_state = sap_icon_state
		desc = "A once large tree now burnt like the lands around it. This one seems to have a sap still inside."
		//If we have sap, we can generate a bit of it
		sap_amount = rand(5,15)
	//Random coal or wood amount, so its not bog standered.
	coal_amount = rand(5,15)
	//If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	SSblackbox.record_feedback("tally", "Honey Tree", 1, "Trees Spawned")

//So we dont lose are bowls, stolen form closet code
/obj/structure/flora/ashtree/Destroy()
	dump_contents(override = FALSE)
	return ..()

//Override is for not revealing the locker electronics when you open the locker, for example
/obj/structure/flora/ashtree/proc/dump_contents(override = TRUE)
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)

/obj/structure/flora/ashtree/proc/harvest_sap()
	desc = "A once large tree now burnt like the lands around it."
	icon_state = "ashtree"
	var/obj/item/reagent_containers/RG = container_used
	//Incase someone was a dumb and used a lidded container
	if(RG.is_refillable())
		//Make sure that its not filling something thats full
		if(!RG.reagents.holder_full())
			RG.reagents.add_reagent(sap_type, min(RG.volume - RG.reagents.total_volume, sap_amount))
	//We drop are used beaker and try to fill it with sap
	RG.forceMove(drop_location())
	SSblackbox.record_feedback("tally", "Honey Tree", 1, "Harvested Honey") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//Proc stolen from Trees
//If you hit it with a sharp force aboe 0 item it chops it down, unlike trees tho it dosnt give wood as its already charcoal
//Also dosnt have a stump
/obj/structure/flora/ashtree/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/reagent_containers))
		if(sap)
			user.visible_message("<span class='notice'>[user] pokes [src] and places a container under the [W].</span>","<span class='notice'>You set up [src] with [W].</span>")
			icon_state = tabbed_icon_state
			sap = FALSE
			container_used = W
			//So we dont lose are bowl when cutting it down + needed for the harvest sap proc
			user.transferItemToLoc(W, src)
			addtimer(CALLBACK(src, PROC_REF(harvest_sap)), harvest_sap_time SECONDS)
		else
			to_chat(user, "<span class='notice'>There is no sap to collect.</span>")

	if(coal_amount && (!(flags_1 & NODECONSTRUCT_1)))
		if(!W.sharpness || !W.force)
			return
		if(W.hitsound)
			playsound(get_turf(src), W.hitsound, 100, 0, 0)
		user.visible_message("<span class='notice'>[user] begins to cut down [src] with [W].</span>","<span class='notice'>You begin to cut down [src] with [W].</span>", "You hear the sound of brittle sawing.")
		//2.5 seconds with 20 force, 4 seconds with a hatchet, 10 seconds with a shard.
		if(do_after(user, 500/W.force, target = src))
			user.visible_message("<span class='notice'>[user] fells [src] with the [W].</span>","<span class='notice'>You fell [src] with the [W].</span>", "You hear the sound of a crumbling tree.")
			playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 100 , 0, 0)
			for(var/i=1 to coal_amount)
				new /obj/item/stack/sheet/mineral/coal(get_turf(src))
			qdel(src)//If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
			SSblackbox.record_feedback("tally", "Honey Tree", 1, "Cutted Tree")

		return ..()

