//Houses the ash tree, a lava land tree that has been burning for quite some time making a maple like sweetener.

/obj/structure/flora/ashtree
	gender = PLURAL //same as other tree
	icon = 'icons/obj/lavaland/ash_tree.dmi'
	icon_state = "ashtree"
	var/sap_icon_state = "ashtree_maple" //Are icon when we are full of honey or other sap
	var/tabbed_icon_state = "ashtree_maple" //What we look like when tapping
	name = "ashed tree"
	desc = "A once large tree now burnt like the lands around it."
	density = TRUE
	pixel_x = -16
	layer = FLY_LAYER
	var/coal_amount = 5 //amout of coal in are tree, simular to logs
	var/sap = FALSE //Do we have sap?
	var/are_sap = /datum/reagent/consumable/honey //What reagent we have
	//var/tapping_items = list(/obj/item/reagent_containers/glass) - current dosnt work commiting it out
	var/harvest_sap_time = 60 //This is in seconds, and now long we wait till are tree is tapped
	var/container_used
	var/sap_amount

/obj/structure/flora/ashtree/New()
	..()
	if(prob(50))
		sap = TRUE
		icon_state = sap_icon_state
		desc = "A once large tree now burnt like the lands around it. This one seems to have a sap still inside."
		sap_amount = rand(20,60) //good amout of honey
	coal_amount = rand(5,15) //We give a random amout

//So we dont lose are bowls, stolen form closet code
/obj/structure/flora/ashtree/Destroy()
	dump_contents(override = FALSE)
	return ..()

/obj/structure/flora/ashtree/proc/dump_contents(override = TRUE) //Override is for not revealing the locker electronics when you open the locker, for example
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)

/obj/structure/flora/ashtree/proc/harvest_sap()
	desc = "A once large tree now burnt like the lands around it."
	icon_state = "ashtree"
	var/obj/item/reagent_containers/RG = container_used
	if(RG.is_refillable()) //Incase someone was a dumb and used a lidded container
		if(!RG.reagents.holder_full()) //Make sure that its not filling something thats full
			RG.reagents.add_reagent(are_sap, min(RG.volume - RG.reagents.total_volume, sap_amount))
	RG.forceMove(drop_location()) //We drop are used beaker and try to fill it with sap

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
			W.forceMove(src) //So we dont lose are bowl when cutting it down + needed for the harvest sap proc
			addtimer(CALLBACK(src, .proc/harvest_sap), harvest_sap_time SECONDS)
		else
			to_chat(user, "<span class='notice'>There is no sap to collect.</span>")

	if(coal_amount && (!(flags_1 & NODECONSTRUCT_1)))
		if(W.sharpness && W.force > 0)
			if(W.hitsound)
				playsound(get_turf(src), W.hitsound, 100, 0, 0)
			user.visible_message("<span class='notice'>[user] begins to cut down [src] with [W].</span>","<span class='notice'>You begin to cut down [src] with [W].</span>", "You hear the sound of brittle sawing.")
			if(do_after(user, 500/W.force, target = src)) //2.5 seconds with 20 force, 4 seconds with a hatchet, 10 seconds with a shard.
				user.visible_message("<span class='notice'>[user] fells [src] with the [W].</span>","<span class='notice'>You fell [src] with the [W].</span>", "You hear the sound of a crumbling tree.")
				playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 100 , 0, 0)
				for(var/i=1 to coal_amount)
					new /obj/item/stack/sheet/mineral/coal(get_turf(src))
				qdel(src)

	else
		return ..()

