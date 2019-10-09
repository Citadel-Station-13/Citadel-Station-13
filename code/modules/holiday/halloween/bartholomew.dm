/obj/effect/landmark/barthpot
    name = "barthpot"

/obj/effect/landmark/barthpot/Initialize()
    new /obj/item/barthpot(loc)

/obj/item/barthpot
    name = "Bartholomew"
    icon = 'icons/obj/halloween_items.dmi'
    icon_state = "barthpot"
    anchored = TRUE
    var/list/items_list

/obj/item/barthpot/Destroy()
    var/n = new src(loc)
    n.items_list = items_list
    ..()


/obj/item/barthpot/attackby(obj/item/I, mob/user, params)
    if(I)
        for(var/obj/item/I2 in items_list)
            if(I == I2)
                qdel(I)
                new /obj/item/reagent_containers/food/snacks/special_candy(loc)
                say("Hooray! Thank you!")
                return

    say("Hello there, I'm Bartholomew, Jacqueline's Familiar.")
    sleep(20)
    say("I'm currently seeking items to put into my pot, if we get the right items, it should crystalise into a magic candy!")
    if(!iscarbon(user))
        say("Though... I'm not sure you can help me.")
    var/mob/living/carbon/C = user

    /* I'm putting too much effort into this, so I'm dialing it back
    var/choices_pot = list("Check items", "Ask a question")
    var/choice_pot = input(usr, "What will you do?", "What will you do?") in choices_reward
    switch(choice_pot)
        if("Check items")
            var/message = "From what I can tell, "
            if(LAZYLEN(items_list) < 5)
                generate_items()
            for(var/obj/item/I2 in items_list)
                message += "[I2.name], "
            message += "currently seem to have the most magic potential."
        if("Ask a question")

/obj/item/barthpot


/obj/item/barthpot/proc/chit_chat(mob/living/carbon/C)
