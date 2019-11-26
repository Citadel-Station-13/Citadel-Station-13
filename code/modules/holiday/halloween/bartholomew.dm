/obj/effect/landmark/barthpot
	name = "barthpot"

/obj/item/barthpot
	name = "Bartholomew"
	icon = 'icons/obj/halloween_items.dmi'
	icon_state = "barthpot"
	anchored = TRUE
	var/items_list = list()
	speech_span = "spooky"
	var/active = TRUE

/obj/item/barthpot/Destroy()
	var/obj/item/barthpot/n = new src(loc)
	n.items_list = items_list
	..()


/obj/item/barthpot/attackby(obj/item/I, mob/user, params)
	if(!active)
		say("Meow!")
		return

	for(var/I2 in items_list)
		if(istype(I, I2))
			qdel(I)
			new /obj/item/reagent_containers/food/snacks/special_candy(loc)
			to_chat(user, "<span class='notice'>You add the [I.name] to the pot and watch as it melts into the mixture, a candy crystalising in it's wake.</span>")
			say("Hooray! Thank you!")
			items_list -= I2
			return
	say("It doesn't seem like that's magical enough!")

/obj/item/barthpot/attack_hand(mob/user)
	if(!active)
		say("Meow!")
		return
	say("Hello there, I'm Bartholomew, Jacqueline's Familiar.")
	sleep(20)

	say("I'm currently seeking items to put into my pot, if we get the right items, it should crystalise into a magic candy!")
	if(!iscarbon(user))
		say("Though... I'm not sure you can help me.")

	var/message = "From what I can tell, "
	if(LAZYLEN(items_list) < 5)
		generate_items()
	for(var/I2 in items_list)
		if(!I2)
			items_list -= I2
			continue
		var/obj/item/I3 = new I2
		message += "a [I3.name], "
	message += "currently seem to have the most magic potential."
	sleep(15)
	say("[message]")
	sleep(15)
	//To help people find her
	for(var/mob/living/simple_animal/jacq/J in GLOB.simple_animals[1])
		var/turf/L1 = J.loc
		if(!L1) //Incase someone uh.. puts her in a locker
			return
		var/area/L2 = L1.loc
		if(L2)
			say("Also, it seems that Jacqueline is currently at the [L2], if you're looking for her too.")

/obj/item/barthpot/proc/generate_items()
	var/length = LAZYLEN(items_list)
	var/rand_items = list(/obj/item/bodybag = 1,
	/obj/item/clothing/glasses/meson = 2,
	/obj/item/clothing/glasses/sunglasses = 1,
	/obj/item/clothing/gloves/color/fyellow = 1,
	/obj/item/clothing/head/hardhat = 1,
	/obj/item/clothing/head/hardhat/red = 1,
	/obj/item/clothing/head/that = 1,
	/obj/item/clothing/head/ushanka = 1,
	/obj/item/clothing/head/welding = 1,
	/obj/item/clothing/mask/gas = 10,
	/obj/item/clothing/suit/hazardvest = 1,
	/obj/item/clothing/suit/hooded/flashsuit = 1,
	/obj/item/assembly/prox_sensor = 4,
	/obj/item/assembly/timer = 3,
	/obj/item/flashlight = 6,
	/obj/item/flashlight/pen = 1,
	/obj/item/flashlight/glowstick = 4,
	/obj/item/multitool = 2,
	/obj/item/radio = 2,
	/obj/item/t_scanner = 5,
	/obj/item/airlock_painter = 1,
	/obj/item/stack/cable_coil = 6,
	/obj/item/stack/medical/bruise_pack = 1,
	/obj/item/stack/rods = 3,
	/obj/item/stack/sheet/cardboard = 2,
	/obj/item/stack/sheet/metal = 1,
	/obj/item/stack/sheet/mineral/plasma = 1,
	/obj/item/stack/sheet/rglass = 1,
	/obj/item/coin = 1,
	/obj/item/crowbar = 4,
	/obj/item/extinguisher = 3,
	/obj/item/hand_labeler = 1,
	/obj/item/paper = 6,
	/obj/item/pen = 5,
	/obj/item/reagent_containers/spray/pestspray = 1,
	/obj/item/reagent_containers/rag = 3,
	/obj/item/stock_parts/cell = 3,
	/obj/item/storage/belt/utility = 2,
	/obj/item/storage/box = 4,
	/obj/item/reagent_containers/food/drinks/sillycup = 1,
	/obj/item/storage/box/donkpockets = 1,
	/obj/item/storage/box/lights/mixed = 1,
	/obj/item/storage/box/hug/medical = 1,
	/obj/item/storage/fancy/cigarettes = 1,
	/obj/item/storage/toolbox = 1,
	/obj/item/screwdriver = 3,
	/obj/item/tank/internals/emergency_oxygen = 2,
	/obj/item/vending_refill/cola = 1,
	/obj/item/weldingtool = 3,
	/obj/item/wirecutters = 2,
	/obj/item/wrench = 4,
	/obj/item/weaponcrafting/receiver = 1,
	/obj/item/geiger_counter = 3,
	/obj/item/reagent_containers/food/snacks/grown/citrus/orange = 5,
	/obj/item/assembly/infra = 1,
	/obj/item/assembly/igniter = 2,
	/obj/item/assembly/signaler = 2,
	/obj/item/assembly/mousetrap = 5,
	/obj/item/reagent_containers/syringe = 5,
	/obj/item/clothing/gloves = 8,
	/obj/item/storage/toolbox = 2,
	/obj/item/reagent_containers/pill = 2,
	/obj/item/clothing/shoes = 8,
	/obj/item/clothing/head = 3,
	/obj/item/reagent_containers/food/snacks = 3,
	/obj/item/reagent_containers/syringe/dart = 2,
	/obj/item/reagent_containers/food/drinks/soda_cans = 5)
	if(length >= 5)
		return TRUE
	//var/metalist = pickweight(GLOB.maintenance_loot)
	for(var/i = length, i <= 5, i+=1)
		var/obj/item = pickweight(rand_items)
		if(!item)
			i-=1
			continue
		for(var/obj/item_dupe in items_list) //No duplicates
			if(item_dupe == item)
				i-=1
				continue
		items_list += item
	return TRUE

/obj/item/pinpointer/jacq
	name = "The Jacq-Tracq"
	desc = "A handheld tracking device that locks onto witchy signals."

/obj/item/pinpointer/jacq/attack_self(mob/living/user)
	for(var/mob/living/simple_animal/jacq/J in GLOB.simple_animals[1])
		target = J
	..()
