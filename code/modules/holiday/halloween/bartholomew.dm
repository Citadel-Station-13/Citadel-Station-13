/obj/effect/landmark/barthpot
    name = "barthpot"
    var/created = FALSE

/obj/effect/landmark/barthpot/Initialize()
    if(!created) //I dunno why they spawn twice but, this is to prevent that.
        new /obj/item/barthpot(loc)
        new /mob/living/simple_animal/jacq(loc)
        created = TRUE
    ..()

/obj/item/barthpot
    name = "Bartholomew"
    icon = 'icons/obj/halloween_items.dmi'
    icon_state = "barthpot"
    anchored = TRUE
    var/items_list = list()
    speech_span = "spooky"

/obj/item/barthpot/Destroy()
    var/obj/item/barthpot/n = new src(loc)
    n.items_list = items_list
    ..()


/obj/item/barthpot/attackby(obj/item/I, mob/user, params)
    for(var/I2 in items_list)
        if(I.type == I2)
            qdel(I)
            new /obj/item/reagent_containers/food/snacks/special_candy(loc)
            to_chat(user, "<span class='notice'>You add the [I.name] to the pot and watch as it melts into the mixture, a candy crystalising in it's wake.</span>")
            say("Hooray! Thank you!")
            items_list -= I2
            return
    say("It doesn't seem like that's magical enough!")

/obj/item/barthpot/attack_hand(mob/user)
    say("Hello there, I'm Bartholomew, Jacqueline's Familiar.")
    sleep(20)
    say("I'm currently seeking items to put into my pot, if we get the right items, it should crystalise into a magic candy!")
    if(!iscarbon(user))
        say("Though... I'm not sure you can help me.")

    var/message = "From what I can tell, "
    if(LAZYLEN(items_list) < 5)
        generate_items()
    for(var/I2 in items_list)
        var/obj/item/I3 = new I2
        message += "a [I3.name], "
    message += "currently seem to have the most magic potential."
    say("[message]")

/obj/item/barthpot/proc/generate_items()
    var/length = LAZYLEN(items_list)
    var/no_list = list(/obj/effect/spawner/lootdrop/glowstick,
    /obj/effect/spawner/lootdrop/mre,
    /obj/item/stack/cable_coil/random,
    /obj/item/stack/cable_coil/random/five,
    /obj/item/stack/rods/ten,
    /obj/item/stack/rods/twentyfive,
    /obj/item/stack/rods/fifty,
    /obj/item/stack/sheet/metal/twenty)
    if(length == 5)
        return TRUE
    //var/metalist = pickweight(GLOB.maintenance_loot)
    for(var/i = length, i <= 5, i+=1)
        var/obj/item = pickweight(GLOB.maintenance_loot)
        if(item in no_list)
            i-=1
            continue
        items_list += item
    return TRUE
