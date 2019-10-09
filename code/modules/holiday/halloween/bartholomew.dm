/obj/effect/landmark/barthpot
    name = "barthpot"

/obj/effect/landmark/barthpot/Initialize()
    new /obj/item/barthpot(loc)
    new /mob/living/simple_animal/jacq(loc)

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
    if(I)
        for(var/obj/item/I2 in items_list)
            if(I.type == I2.type)
                qdel(I)
                new /obj/item/reagent_containers/food/snacks/special_candy(loc)
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
    //var/mob/living/carbon/C = user

    /* I'm putting too much effort into this, so I'm dialing it back
    var/choices_pot = list("Check items", "Ask a question")
    var/choice_pot = input(usr, "What will you do?", "What will you do?") in choices_reward
    switch(choice_pot)
        if("Check items")*/
    var/message = "From what I can tell, "
    if(LAZYLEN(items_list) < 5)
        generate_items()
    for(var/obj/item/I2 in items_list)
        message += "[I2.name], "
    message += "currently seem to have the most magic potential."
    say("[message]")

/obj/item/barthpot/proc/generate_items()
    var/length = LAZYLEN(items_list)
    if(length == 5)
        return TRUE
    var/metalist = GLOB.maintenance_loot
    for(var/i = length, i <= 5, i+=1)
        items_list += pick(metalist)
    return TRUE
