
////////////////////////////////////////////OTHER////////////////////////////////////////////


/obj/item/food/cheese/wheel
	name = "cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/protein = 5, /datum/reagent/consumable/nutriment/vitamin = 5) //Hard cheeses contain about 25% protein
	w_class = WEIGHT_CLASS_NORMAL
	rat_heal = 35

/obj/item/food/cheese/wheel/Initialize()
	. = ..()
	AddComponent(/datum/component/food_storage)

/obj/item/food/cheese/wheel/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/cheese, 5, 30)

/obj/item/food/cheese/royal
	name = "royal cheese"
	desc = "Ascend the throne. Consume the wheel. Feel the POWER."
	icon_state = "royalcheese"
	food_reagents = list(/datum/reagent/consumable/nutriment = 15, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/gold = 20, /datum/reagent/toxin/mutagen = 5)
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("cheese" = 4, "royalty" = 1)
	rat_heal = 70

/obj/item/food/cheese
	name = "cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/nutriment/protein = 1, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("cheese" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL
	/// used to determine how much health rats/regal rats recover when they eat it.
	var/rat_heal = 10

/obj/item/food/cheese/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_RAT_INTERACT, .proc/on_rat_eat)

/obj/item/food/cheese/proc/on_rat_eat(mob/living/simple_animal/hostile/regalrat/king)
	SIGNAL_HANDLER

	king.cheese_heal(src, rat_heal, span_green("You eat [src], restoring some health."))

/obj/item/food/watermelonslice
	name = "watermelon slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	food_reagents = list(/datum/reagent/water = 1, /datum/reagent/consumable/nutriment/vitamin = 0.2, /datum/reagent/consumable/nutriment = 1)
	tastes = list("watermelon" = 1)
	foodtypes = FRUIT
	food_flags = FOOD_FINGER_FOOD
	juice_results = list(/datum/reagent/consumable/watermelonjuice = 5)
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Can be stored in a detective's hat."
	icon_state = "candy_corn"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 2)
	tastes = list("candy corn" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/candy_corn/prison
	name = "desiccated candy corn"
	desc = "If this candy corn were any harder Security would confiscate it for being a potential shiv."
	force = 1 // the description isn't lying
	throwforce = 1 // if someone manages to bust out of jail with candy corn god bless them
	tastes = list("bitter wax" = 1)
	foodtypes = GROSS

/obj/item/food/chocolatebar
	name = "chocolate bar"
	desc = "Such, sweet, fattening food."
	icon_state = "chocolatebar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2)
	tastes = list("chocolate" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("mushroom" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/popcorn
	name = "popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash_type = /obj/item/trash/popcorn
	food_reagents = list(/datum/reagent/consumable/nutriment = 2)
	bite_consumption = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	tastes = list("popcorn" = 3, "butter" = 1)
	foodtypes = JUNKFOOD
	eatverbs = list("bite","nibble","gnaw","gobble","chomp")
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("potato" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fries
	name = "space fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"

	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("fries" = 3, "salt" = 1)
	foodtypes = VEGETABLES | FRIED
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/fries/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/tatortot
	name = "tator tot"
	desc = "A large fried potato nugget that may or may not try to valid you."
	icon_state = "tatortot"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	tastes = list("potato" = 3, "valids" = 1)
	foodtypes = FRIED | VEGETABLES
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/tatortot/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/soydope
	name = "soy dope"
	desc = "Dope from a soy."
	icon_state = "soydope"

	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/protein = 1)
	tastes = list("soy" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"

	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("fries" = 3, "cheese" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cheesyfries/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/poutine
	name = "poutine"
	desc = "Fries covered in cheese curds and gravy."
	icon_state = "poutine"
	food_reagents = list(/datum/reagent/consumable/nutriment = 7, /datum/reagent/medicine/antihol = 4)
	tastes = list("potato" = 3, "gravy" = 1, "squeaky cheese" = 1)
	foodtypes = VEGETABLES | FRIED | MEAT
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/poutine/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/badrecipe
	name = "burned mess"
	desc = "Someone should be demoted from cook for this."
	icon_state = "badrecipe"
	food_reagents = list(/datum/reagent/toxin/bad_food = 30)
	foodtypes = GROSS
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE //Can't decompose any more than this

/obj/item/food/badrecipe/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_GRILLED, .proc/OnGrill)

/obj/item/food/badrecipe/moldy
	name = "moldy mess"
	desc = "A rancid, disgusting culture of mold and ants. Somewhere under there, at <i>some point,</i> there was food."
	food_reagents = list(/datum/reagent/consumable/mold = 30)

/obj/item/food/badrecipe/moldy/Initialize()
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 25)

///Prevents grilling burnt shit from well, burning.
/obj/item/food/badrecipe/proc/OnGrill()
	SIGNAL_HANDLER
	return COMPONENT_HANDLED_GRILLING

/obj/item/food/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"

	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/medicine/oculine = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	tastes = list("carrots" = 3, "salt" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/carrotfries/Initialize()
	. = ..()
	AddElement(/datum/element/dunkable, 10)

/obj/item/food/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	bite_consumption = 3
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/sugar = 3, /datum/reagent/consumable/caramel = 5)
	tastes = list("apple" = 2, "caramel" = 3)
	foodtypes = JUNKFOOD | FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/mint
	name = "mint"
	desc = "It is only wafer thin."
	icon_state = "mint"
	bite_consumption = 1
	food_reagents = list(/datum/reagent/toxin/minttoxin = 2)
	foodtypes = TOXIC | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spidereggs
	name = "spider eggs"
	desc = "A cluster of juicy spider eggs. A great side dish for when you care not for your health."
	icon_state = "spidereggs"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 4, /datum/reagent/toxin = 2)
	tastes = list("cobwebs" = 1)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/spiderling
	name = "spiderling"
	desc = "It's slightly twitching in your hand. Ew..."
	icon_state = "spiderling"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/toxin = 4)
	tastes = list("cobwebs" = 1, "guts" = 2)
	foodtypes = MEAT | TOXIC
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/spiderlollipop
	name = "spider lollipop"
	desc = "Still gross, but at least it has a mountain of sugar on it."
	icon_state = "spiderlollipop"
	worn_icon_state = "lollipop_stick"
	food_reagents = list(/datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/toxin = 1, /datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/omnizine = 2) //lollipop, but vitamins = toxins
	tastes = list("cobwebs" = 1, "sugar" = 2)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK

/obj/item/food/spiderlollipop/Initialize()
	. = ..()
	AddElement(/datum/element/chewable)

/obj/item/food/chococoin
	name = "chocolate coin"
	desc = "A completely edible but nonflippable festive coin."
	icon_state = "chococoin"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/coco = 1, /datum/reagent/consumable/sugar = 1)
	tastes = list("chocolate" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/fudgedice
	name = "fudge dice"
	desc = "A little cube of chocolate that tends to have a less intense taste if you eat too many at once."
	icon_state = "chocodice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/coco = 1, /datum/reagent/consumable/sugar = 1)
	trash_type = /obj/item/dice/fudge
	tastes = list("fudge" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/chocoorange
	name = "chocolate orange"
	desc = "A festive chocolate orange."
	icon_state = "chocoorange"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/sugar = 1)
	tastes = list("chocolate" = 3, "oranges" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/eggplantparm
	name = "eggplant parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"

	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/protein = 2, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("eggplant" = 3, "cheese" = 1)
	foodtypes = VEGETABLES | DAIRY
	w_class = WEIGHT_CLASS_SMALL
	venue_value = FOOD_PRICE_NORMAL

/obj/item/food/yakiimo
	name = "yaki imo"
	desc = "Made with roasted sweet potatoes!"
	icon_state = "yakiimo"

	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("sweet potato" = 1)
	foodtypes = VEGETABLES | SUGAR
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/roastparsnip
	name = "roast parsnip"
	desc = "Sweet and crunchy."
	icon_state = "roastparsnip"

	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 4)
	tastes = list("parsnip" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/melonfruitbowl
	name = "melon fruit bowl"
	desc = "For people who wants edible fruit bowls."
	icon_state = "melonfruitbowl"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("melon" = 1)
	foodtypes = FRUIT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/melonkeg
	name = "melon keg"
	desc = "Who knew vodka was a fruit?"
	icon_state = "melonkeg"
	food_reagents = list(/datum/reagent/consumable/nutriment = 9, /datum/reagent/consumable/ethanol/vodka = 15, /datum/reagent/consumable/nutriment/vitamin = 4)
	max_volume = 80
	bite_consumption = 5
	tastes = list("grain alcohol" = 1, "fruit" = 1)
	foodtypes = FRUIT | ALCOHOL

/obj/item/food/honeybar
	name = "honey nut bar"
	desc = "Oats and nuts compressed together into a bar, held together with a honey glaze."
	icon_state = "honeybar"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/honey = 5)
	tastes = list("oats" = 3, "nuts" = 2, "honey" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/powercrepe
	name = "Powercrepe"
	desc = "With great power, comes great crepes.  It looks like a pancake filled with jelly but packs quite a punch."
	icon_state = "powercrepe"
	food_reagents = list(/datum/reagent/consumable/nutriment = 10, /datum/reagent/consumable/nutriment/vitamin = 5, /datum/reagent/consumable/cherryjelly = 5)
	force = 30
	throwforce = 15
	block_chance = 55
	armour_penetration = 80
	wound_bonus = -50
	attack_verb_continuous = list("slaps", "slathers")
	attack_verb_simple = list("slap", "slather")
	w_class = WEIGHT_CLASS_BULKY
	tastes = list("cherry" = 1, "crepe" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR

/obj/item/food/lollipop
	name = "lollipop"
	desc = "A delicious lollipop. Makes for a great Valentine's present."
	icon = 'icons/obj/lollipop.dmi'
	icon_state = "lollipop_stick"
	inhand_icon_state = "lollipop_stick"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/omnizine = 2) //Honk
	var/mutable_appearance/head
	var/headcolor = rgb(0, 0, 0)
	tastes = list("candy" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/lollipop/Initialize()
	. = ..()
	head = mutable_appearance('icons/obj/lollipop.dmi', "lollipop_head")
	change_head_color(rgb(rand(0, 255), rand(0, 255), rand(0, 255)))
	AddElement(/datum/element/chewable)

/obj/item/food/lollipop/proc/change_head_color(C)
	headcolor = C
	cut_overlay(head)
	head.color = C
	add_overlay(head)

/obj/item/food/lollipop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..(hit_atom)
	throw_speed = 1
	throwforce = 0

/obj/item/food/lollipop/cyborg
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/iron = 10, /datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/psicodine = 2) //psicodine instead of omnizine, because the latter was making coders freak out

/obj/item/food/bubblegum
	name = "bubblegum"
	desc = "A rubbery strip of gum. Not exactly filling, but it keeps you busy."
	icon_state = "bubblegum"
	inhand_icon_state = "bubblegum"
	color = "#E48AB5" // craftable custom gums someday?
	food_reagents = list(/datum/reagent/consumable/sugar = 5)
	tastes = list("candy" = 1)
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

	/// The amount to metabolize per second
	var/metabolization_amount = REAGENTS_METABOLISM / 2

/obj/item/food/bubblegum/Initialize()
	. = ..()
	AddElement(/datum/element/chewable, metabolization_amount = metabolization_amount)

/obj/item/food/bubblegum/nicotine
	name = "nicotine gum"
	food_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/consumable/menthol = 5)
	tastes = list("mint" = 1)
	color = "#60A584"

/obj/item/food/bubblegum/happiness
	name = "HP+ gum"
	desc = "A rubbery strip of gum. It smells funny."
	food_reagents = list(/datum/reagent/drug/happiness = 15)
	tastes = list("paint thinner" = 1)
	color = "#EE35FF"

/obj/item/food/bubblegum/bubblegum
	name = "bubblegum gum"
	desc = "A rubbery strip of gum. You don't feel like eating it is a good idea."
	color = "#913D3D"
	food_reagents = list(/datum/reagent/blood = 15)
	tastes = list("hell" = 1)
	metabolization_amount = REAGENTS_METABOLISM

/obj/item/food/bubblegum/bubblegum/process()
	. = ..()
	if(iscarbon(loc))
		hallucinate(loc)

/obj/item/food/bubblegum/bubblegum/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				microwaved_type = microwaved_type,\
				junkiness = junkiness,\
				on_consume = CALLBACK(src, .proc/OnConsume))

/obj/item/food/bubblegum/bubblegum/proc/OnConsume(mob/living/eater, mob/living/feeder)
	if(iscarbon(eater))
		hallucinate(eater)

///This proc has a 5% chance to have a bubblegum line appear, with an 85% chance for just text and 15% for a bubblegum hallucination and scarier text.
/obj/item/food/bubblegum/bubblegum/proc/hallucinate(mob/living/carbon/victim)
	if(!prob(5)) //cursed by bubblegum
		return
	if(prob(15))
		new /datum/hallucination/oh_yeah(victim)
		to_chat(victim, span_colossus("<b>[pick("I AM IMMORTAL.","I SHALL TAKE YOUR WORLD.","I SEE YOU.","YOU CANNOT ESCAPE ME FOREVER.","NOTHING CAN HOLD ME.")]</b>"))
	else
		to_chat(victim, span_warning("[pick("You hear faint whispers.","You smell ash.","You feel hot.","You hear a roar in the distance.")]"))

/obj/item/food/gumball
	name = "gumball"
	desc = "A colorful, sugary gumball."
	icon = 'icons/obj/lollipop.dmi'
	icon_state = "gumball"
	worn_icon_state = "bubblegum"
	food_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/sal_acid = 2, /datum/reagent/medicine/oxandrolone = 2) //Kek
	tastes = list("candy")
	foodtypes = JUNKFOOD
	food_flags = FOOD_FINGER_FOOD
	slot_flags = ITEM_SLOT_MASK
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/gumball/Initialize()
	. = ..()
	color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	AddElement(/datum/element/chewable)

/obj/item/food/branrequests
	name = "Bran Requests Cereal"
	desc = "A dry cereal that satiates your requests for bran. Tastes uniquely like raisins and salt."
	icon_state = "bran_requests"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2, /datum/reagent/consumable/salt = 8)
	tastes = list("bran" = 4, "raisins" = 3, "salt" = 1)
	foodtypes = GRAIN | FRUIT | BREAKFAST
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter
	name = "stick of butter"
	desc = "A stick of delicious, golden, fatty goodness."
	icon_state = "butter"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("butter" = 1)
	foodtypes = DAIRY
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/butter/examine(mob/user)
	. = ..()
	. += span_notice("If you had a rod you could make <b>butter on a stick</b>.")

/obj/item/food/butter/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = W
		if(!R.use(1))//borgs can still fail this if they have no metal
			to_chat(user, span_warning("You do not have enough iron to put [src] on a stick!"))
			return ..()
		to_chat(user, span_notice("You stick the rod into the stick of butter."))
		var/obj/item/food/butter/on_a_stick/new_item = new(usr.loc)
		var/replace = (user.get_inactive_held_item() == R)
		if(!R && replace)
			user.put_in_hands(new_item)
		qdel(src)
		return TRUE
	..()

/obj/item/food/butter/on_a_stick //there's something so special about putting it on a stick.
	name = "butter on a stick"
	desc = "delicious, golden, fatty goodness on a stick."
	icon_state = "butteronastick"
	trash_type = /obj/item/stack/rods
	food_flags = FOOD_FINGER_FOOD

/obj/item/food/onionrings
	name = "onion rings"
	desc = "Onion slices coated in batter."
	icon_state = "onionrings"
	food_reagents = list(/datum/reagent/consumable/nutriment = 3)
	gender = PLURAL
	tastes = list("batter" = 3, "onion" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/pineappleslice
	name = "pineapple slice"
	desc = "A sliced piece of juicy pineapple."
	icon_state = "pineapple_slice"
	juice_results = list(/datum/reagent/consumable/pineapplejuice = 3)
	tastes = list("pineapple" = 1)
	foodtypes = FRUIT | PINEAPPLE
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/tinychocolate
	name = "chocolate"
	desc = "A tiny and sweet chocolate."
	icon_state = "tiny_chocolate"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sugar = 1, /datum/reagent/consumable/coco = 1)
	tastes = list("chocolate" = 1)
	foodtypes = JUNKFOOD | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY

/obj/item/food/canned
	name = "Canned Air"
	desc = "If you ever wondered where air came from..."
	food_reagents = list(/datum/reagent/oxygen = 6, /datum/reagent/nitrogen = 24)
	icon_state = "peachcan"
	food_flags = FOOD_IN_CONTAINER
	w_class = WEIGHT_CLASS_NORMAL
	max_volume = 30
	w_class = WEIGHT_CLASS_SMALL
	preserved_food = TRUE


/obj/item/food/canned/proc/open_can(mob/user)
	to_chat(user, span_notice("You pull back the tab of \the [src]."))
	playsound(user.loc, 'sound/items/foodcanopen.ogg', 50)
	reagents.flags |= OPENCONTAINER
	preserved_food = FALSE
	MakeDecompose()

/obj/item/food/canned/attack_self(mob/user)
	if(!is_drainable())
		open_can(user)
		icon_state = "[icon_state]_open"
	return ..()

/obj/item/food/canned/attack(mob/living/M, mob/user, def_zone)
	if (!is_drainable())
		to_chat(user, span_warning("[src]'s lid hasn't been opened!"))
		return FALSE
	return ..()

/obj/item/food/canned/beans
	name = "tin of beans"
	desc = "Musical fruit in a slightly less musical container."
	icon_state = "beans"
	trash_type = /obj/item/trash/can/food/beans
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/protein = 9, /datum/reagent/consumable/ketchup = 4)
	tastes = list("beans" = 1)
	foodtypes = VEGETABLES

/obj/item/food/canned/peaches
	name = "canned peaches"
	desc = "Just a nice can of ripe peaches swimming in their own juices."
	icon_state = "peachcan"
	trash_type = /obj/item/trash/can/food/peaches
	food_reagents = list(/datum/reagent/consumable/peachjuice = 20, /datum/reagent/consumable/sugar = 8, /datum/reagent/consumable/nutriment = 2)
	tastes = list("peaches" = 7, "tin" = 1)
	foodtypes = FRUIT | SUGAR

/obj/item/food/canned/peaches/maint
	name = "Maintenance Peaches"
	desc = "I have a mouth and I must eat."
	icon_state = "peachcanmaint"
	trash_type = /obj/item/trash/can/food/peaches/maint
	tastes = list("peaches" = 1, "tin" = 7)
	venue_value = FOOD_EXOTIC

/obj/item/food/crab_rangoon
	name = "Crab Rangoon"
	desc = "Has many names, like crab puffs, cheese won'tons, crab dumplings? Whatever you call them, they're a fabulous blast of cream cheesy crab."
	icon_state = "crabrangoon"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5, /datum/reagent/consumable/nutriment/protein = 7, /datum/reagent/consumable/nutriment/vitamin = 5)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("cream cheese" = 4, "crab" = 3, "crispiness" = 2)
	foodtypes = MEAT | DAIRY | GRAIN
	venue_value = FOOD_PRICE_CHEAP

/obj/item/food/cornchips
	name = "boritos corn chips"
	desc = "Triangular corn chips. They do seem a bit bland but would probably go well with some kind of dipping sauce."
	icon_state = "boritos"
	trash_type = /obj/item/trash/boritos
	bite_consumption = 2
	food_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/cooking_oil = 2, /datum/reagent/consumable/salt = 3)
	junkiness = 20
	tastes = list("fried corn" = 1)
	foodtypes = JUNKFOOD | FRIED
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cornchips/MakeLeaveTrash()
	if(trash_type)
		AddElement(/datum/element/food_trash, trash_type, FOOD_TRASH_POPABLE)


/obj/item/food/rationpack
	name = "ration pack"
	desc = "A square bar that sadly <i>looks</i> like chocolate, packaged in a nondescript grey wrapper. Has saved soldiers' lives before - usually by stopping bullets."
	icon_state = "rationpack"
	bite_consumption = 3
	junkiness = 15
	tastes = list("cardboard" = 3, "sadness" = 3)
	foodtypes = null //Don't ask what went into them. You're better off not knowing.
	food_reagents = list(/datum/reagent/consumable/nutriment/stabilized = 10, /datum/reagent/consumable/nutriment = 2) //Won't make you fat. Will make you question your sanity.

///Override for checkliked callback
/obj/item/food/rationpack/MakeEdible()
	AddComponent(/datum/component/edible,\
				initial_reagents = food_reagents,\
				food_flags = food_flags,\
				foodtypes = foodtypes,\
				volume = max_volume,\
				eat_time = eat_time,\
				tastes = tastes,\
				eatverbs = eatverbs,\
				bite_consumption = bite_consumption,\
				microwaved_type = microwaved_type,\
				junkiness = junkiness,\
				check_liked = CALLBACK(src, .proc/check_liked))

/obj/item/food/rationpack/proc/check_liked(fraction, mob/M) //Nobody likes rationpacks. Nobody.
	return FOOD_DISLIKED

/obj/item/food/ant_candy
	name = "ant candy"
	desc = "A colony of ants suspended in hardened sugar. Those things are dead, right?"
	icon_state = "ant_pop"
	food_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/sugar = 5, /datum/reagent/ants = 3)
	tastes = list("candy" = 1, "insects" = 1)
	foodtypes = JUNKFOOD | SUGAR | GROSS
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_TINY
