/**********************Mint**************************/


/obj/machinery/mineral/mint
	name = "coin press"
	icon = 'icons/obj/economy.dmi'
	icon_state = "coinpress0"
	density = 1
	anchored = 1
	var/amt_silver = 0 //amount of silver
	var/amt_gold = 0   //amount of gold
	var/amt_diamond = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_clown = 0
	var/amt_adamantine = 0
	var/amt_mythril = 0
	var/newCoins = 0   //how many coins the machine made in it's last load
	var/processing = 0
	var/chosen = "metal" //which material will be used to make coins
	var/coinsToProduce = 10
	speed_process = 1

/obj/machinery/mineral/mint/process()
	var/turf/T = get_step(src,input_dir)
	if(T)
		for(var/obj/item/stack/sheet/O in T)
			if (istype(O, /obj/item/stack/sheet/mineral/gold))
				amt_gold += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			if (istype(O, /obj/item/stack/sheet/mineral/silver))
				amt_silver += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			if (istype(O, /obj/item/stack/sheet/mineral/diamond))
				amt_diamond += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			if (istype(O, /obj/item/stack/sheet/mineral/plasma))
				amt_plasma += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			if (istype(O, /obj/item/stack/sheet/mineral/uranium))
				amt_uranium += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			if (istype(O, /obj/item/stack/sheet/metal))
				amt_iron += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			if (istype(O, /obj/item/stack/sheet/mineral/bananium))
				amt_clown += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			if (istype(O, /obj/item/stack/sheet/mineral/adamantine))
				amt_adamantine += MINERAL_MATERIAL_AMOUNT * O.amount
				O.loc = null
			return


/obj/machinery/mineral/mint/attack_hand(mob/user)

	var/dat = "<b>Coin Press</b><br>"

	dat += text("<br><font color='#ffcc00'><b>Gold inserted: </b>[amt_gold] cm3</font> ")
	if (chosen == "gold")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=gold'>Choose</A>")
	dat += text("<br><font color='#888888'><b>Silver inserted: </b>[amt_silver] cm3</font> ")
	if (chosen == "silver")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=silver'>Choose</A>")
	dat += text("<br><font color='#555555'><b>Iron inserted: </b>[amt_iron] cm3</font> ")
	if (chosen == "metal")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=metal'>Choose</A>")
	dat += text("<br><font color='#8888FF'><b>Diamond inserted: </b>[amt_diamond] cm3</font> ")
	if (chosen == "diamond")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=diamond'>Choose</A>")
	dat += text("<br><font color='#FF8800'><b>Plasma inserted: </b>[amt_plasma] cm3</font> ")
	if (chosen == "plasma")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=plasma'>Choose</A>")
	dat += text("<br><font color='#008800'><b>Uranium inserted: </b>[amt_uranium] cm3</font> ")
	if (chosen == "uranium")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=uranium'>Choose</A>")
	if(amt_clown > 0)
		dat += text("<br><font color='#AAAA00'><b>Bananium inserted: </b>[amt_clown] cm3</font> ")
		if (chosen == "clown")
			dat += text("chosen")
		else
			dat += text("<A href='?src=\ref[src];choose=clown'>Choose</A>")
	dat += text("<br><font color='#888888'><b>Adamantine inserted: </b>[amt_adamantine] cm3</font> ")//I don't even know these color codes, so fuck it.
	if (chosen == "adamantine")
		dat += text("chosen")
	else
		dat += text("<A href='?src=\ref[src];choose=adamantine'>Choose</A>")

	dat += text("<br><br>Will produce [coinsToProduce] [chosen] coins if enough materials are available.<br>")
	//dat += text("The dial which controls the number of conins to produce seems to be stuck. A technician has already been dispatched to fix this.")
	dat += text("<A href='?src=\ref[src];chooseAmt=-10'>-10</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=-5'>-5</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=-1'>-1</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=1'>+1</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=5'>+5</A> ")
	dat += text("<A href='?src=\ref[src];chooseAmt=10'>+10</A> ")

	dat += text("<br><br>In total this machine produced <font color='green'><b>[newCoins]</b></font> coins.")
	dat += text("<br><A href='?src=\ref[src];makeCoins=[1]'>Make coins</A>")
	user << browse("[dat]", "window=mint")

/obj/machinery/mineral/mint/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(processing==1)
		usr << "<span class='notice'>The machine is processing.</span>"
		return
	if(href_list["choose"])
		chosen = href_list["choose"]
	if(href_list["chooseAmt"])
		coinsToProduce = Clamp(coinsToProduce + text2num(href_list["chooseAmt"]), 0, 1000)
	if(href_list["makeCoins"])
		var/temp_coins = coinsToProduce
		processing = 1;
		icon_state = "coinpress1"
		var/coin_mat = MINERAL_MATERIAL_AMOUNT * 0.2
		switch(chosen)
			if("metal")
				while(amt_iron >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/iron)
					amt_iron -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
			if("gold")
				while(amt_gold >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/gold)
					amt_gold -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
			if("silver")
				while(amt_silver >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/silver)
					amt_silver -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
			if("diamond")
				while(amt_diamond >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/diamond)
					amt_diamond -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
			if("plasma")
				while(amt_plasma >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/plasma)
					amt_plasma -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
			if("uranium")
				while(amt_uranium >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/uranium)
					amt_uranium -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5)
			if("clown")
				while(amt_clown >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/clown)
					amt_clown -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
			if("adamantine")
				while(amt_adamantine >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/adamantine)
					amt_adamantine -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
			if("mythril")
				while(amt_adamantine >= coin_mat && coinsToProduce > 0)
					create_coins(/obj/item/weapon/coin/mythril)
					amt_mythril -= coin_mat
					coinsToProduce--
					newCoins++
					src.updateUsrDialog()
					sleep(5);
		icon_state = "coinpress0"
		processing = 0;
		coinsToProduce = temp_coins
	src.updateUsrDialog()
	return

/obj/machinery/mineral/mint/proc/create_coins(P)
	var/turf/T = get_step(src,output_dir)
	if(T)
		var/obj/item/O = new P(src)
		var/obj/item/weapon/storage/bag/money/M = locate(/obj/item/weapon/storage/bag/money, T)
		if(!M)
			M = new /obj/item/weapon/storage/bag/money(src)
			unload_mineral(M)
		O.loc = M