/obj/item/storage/box/syndicate

/obj/item/storage/box/syndicate/PopulateContents() //balance pickweight around making less destructive bundles more common please.
	switch (pickweight(list("bloodyspai" = 3, "energyknight" = 2, "donk" = 2, "stealth" = 3, "bond" = 2, "screwed" = 2, "sabotage" = 3, "baseball" = 2, "implant" = 1, "hacker" = 2, "darklord" = 1, "sniper" = 1, "metaops" = 1, "ninja" = 1)))
		if("bloodyspai") // ~32 TC https://youtu.be/OR4N5OhcY9s
			new /obj/item/clothing/under/chameleon(src)
			new /obj/item/clothing/mask/chameleon(src)
			new /obj/item/clothing/shoes/chameleon/noslip(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/camera_bug(src)
			new /obj/item/multitool/ai_detect(src)
			new /obj/item/encryptionkey/syndicate(src)
			new /obj/item/reagent_containers/syringe/mulligan(src)
			new /obj/item/gun/ballistic/revolver(src)
			new /obj/item/ammo_box/a357(src)
			new /obj/item/ammo_box/a357(src)
			new /obj/item/ammo_box/a357(src)
			new /obj/item/switchblade(src)
			new /obj/item/storage/fancy/cigarettes/cigpack_syndicate (src)
			new /obj/item/flashlight/emp(src)
			new /obj/item/chameleon(src)

		if("stealth") // ~36 TC Toxin damage + Avoiding getting caught even during a search
			new /obj/item/storage/box/syndie_kit/chameleon(src)
			new /obj/item/gun/energy/kinetic_accelerator/crossbow(src)
			new /obj/item/pen/sleepy(src)
			new /obj/item/implanter/storage(src)
			new /obj/item/healthanalyzer/rad_laser(src)
			new /obj/item/chameleon(src)
			new /obj/item/soap/syndie(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)

		if("bond") // ~29 TC Professional stealth
			new /obj/item/gun/ballistic/automatic/pistol/suppressed(src)
			new /obj/item/ammo_box/magazine/m10mm(src)
			new /obj/item/ammo_box/magazine/m10mm/ap(src)
			new /obj/item/ammo_box/magazine/m10mm/ap(src)
			new /obj/item/ammo_box/magazine/m10mm/hp(src)
			new /obj/item/ammo_box/magazine/m10mm/hp(src)
			new /obj/item/ammo_box/magazine/m10mm/soporific(src)
			new /obj/item/ammo_box/magazine/m10mm/soporific(src)
			new /obj/item/clothing/under/chameleon(src)
			new /obj/item/clothing/accessory/kevlar(src)
			new /obj/item/clothing/neck/tie/red(src)
			new /obj/item/encryptionkey/syndicate(src)
			new /obj/item/codespeak_manual/unlimited(src)
			new /obj/item/jammer(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/reagent_containers/syringe/stimulants(src)
			new /obj/item/storage/briefcase/launchpad(src)

		if("screwed") // ~41/27 TC Basically the engineering sabotage starter pack. Potential for a lot of destruction so no weapons please.
			new /obj/item/sbeacondrop/bomb(src)
			new /obj/item/sbeacondrop/powersink(src)
			new /obj/item/sbeacondrop(src) // not necessarily useful
			new /obj/item/grenade/syndieminibomb(src)
			new /obj/item/clothing/suit/space/syndicate/black/red(src)
			new /obj/item/clothing/head/helmet/space/syndicate/black/red(src)
			new /obj/item/storage/toolbox/syndicate(src)
			new /obj/item/encryptionkey/syndicate(src)

		if("donk") // 30 TC "harmless" prank kit
			new /obj/item/gun/ballistic/automatic/toy/pistol/riot(src)
			new /obj/item/ammo_box/foambox/riot(src)
			new /obj/item/ammo_box/foambox/riot(src)
			new /obj/item/chameleon(src) // Become a walking talking toilet
			new /obj/item/storage/box/syndie_kit/chameleon/broken(src)
			new /obj/item/storage/box/syndie_kit/cutouts(src) // art
			new /obj/item/toy/cards/deck/syndicate(src)
			new /obj/item/toy/syndicateballoon(src) // not even an exclusive item, not counting it towards TC
			new /obj/item/storage/box/syndie_kit/imp_freedom(src) // for when your japes get you arrested
			new /obj/item/grenade/chem_grenade/teargas/moustache(src)
			new /obj/item/soap/syndie(src)
			new /obj/item/disk/nuclear/fake
			new /obj/item/cartridge/virus/frame(src)
			new /obj/item/card/id/syndicate(src) // for giving yourself dumb names
			new /obj/item/clothing/mask/gas/clown_hat(src)

		if("energyknight") // 33 TC
			new /obj/item/melee/transforming/energy/sword/saber(src)
			new /obj/item/shield/energy(src)
			new /obj/item/card/emag(src) // the door shall not stop me!
			new /obj/item/clothing/shoes/chameleon/noslip(src)
			new /obj/item/clothing/glasses/phantomthief/syndicate(src)
			new /obj/item/reagent_containers/syringe/stimulants(src)

		if("baseball") // ~32 TC meme kit
			new /obj/item/melee/baseball_bat/ablative/syndi(src)
			new /obj/item/clothing/glasses/sunglasses/garb(src)
			new /obj/item/card/emag(src)
			new /obj/item/clothing/shoes/sneakers/noslip(src)
			new /obj/item/encryptionkey/syndicate(src)
			new /obj/item/autosurgeon/anti_drop(src)
			new /obj/item/clothing/under/syndicate/baseball(src)
			new /obj/item/clothing/head/soft/baseball(src)
			new /obj/item/reagent_containers/hypospray/medipen/stimulants/baseball(src)

		if("implant") // 52+ TC holy shit what the fuck this is a lottery disguised as fun boxes isn't it?
			new /obj/item/implanter/freedom(src)
			new /obj/item/implanter/uplink/precharged(src)
			new /obj/item/implanter/emp(src)
			new /obj/item/implanter/adrenalin(src)
			new /obj/item/implanter/explosive(src)
			new /obj/item/implanter/storage(src)
			new /obj/item/implanter/radio/syndicate(src)
			new /obj/item/implanter/stealth(src)

		if("hacker") // ~27 TC + malf ability upgrade. remember citadel.
			new /obj/item/wrench/citadel(src)
			new /obj/item/aiModule/syndicate(src)
			new /obj/item/malf_upgrade(src) //The hard part is reaching the AI
			new /obj/item/card/emag(src)
			new /obj/item/emagrecharge(src)
			new /obj/item/emagrecharge(src)
			new /obj/item/encryptionkey/binary(src)
			new /obj/item/aiModule/toyAI(src)
			new /obj/item/multitool/ai_detect(src)
			new /obj/item/flashlight/emp(src)
			new /obj/item/storage/toolbox/syndicate(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/camera_bug(src)
			new /obj/item/storage/backpack/duffelbag/syndie/med/surgery(src)

		if("sabotage") // ~33 TC
			new /obj/item/grenade/plastic/c4 (src)
			new /obj/item/grenade/plastic/c4 (src)
			new /obj/item/grenade/plastic/x4 (src)
			new /obj/item/grenade/plastic/x4 (src)
			new /obj/item/card/emag(src)
			new /obj/item/doorCharge(src)
			new /obj/item/doorCharge(src)
			new /obj/item/camera_bug(src)
			new /obj/item/sbeacondrop/powersink(src)
			new /obj/item/cartridge/virus/syndicate(src)
			new /obj/item/storage/toolbox/syndicate(src) //To actually get to those places
			new /obj/item/pizzabox/bomb

		if("darklord") // ~30 TC + tk + summon item = fun!
			new /obj/item/twohanded/dualsaber(src)
			new /obj/item/dnainjector/telemut/darkbundle(src)
			new /obj/item/autosurgeon/thermal_eyes(src)
			new /obj/item/storage/box/syndie_kit/imp_adrenal(src)
			new /obj/item/clothing/suit/hooded/chaplain_hoodie(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/clothing/shoes/chameleon/noslip(src) //because slipping while being a dark lord sucks
			new /obj/item/book/granter/spell/summonitem(src)

		if("sniper") // ~40 TC. https://youtu.be/9NZDwZbyDus
			new /obj/item/gun/ballistic/automatic/sniper_rifle(src)
			new /obj/item/ammo_box/magazine/sniper_rounds(src)
			new /obj/item/ammo_box/magazine/sniper_rounds/penetrator(src)
			new /obj/item/ammo_box/magazine/sniper_rounds/penetrator(src)
			new /obj/item/kitchen/knife/combat(src)
			new /obj/item/grenade/chem_grenade/facid(src) //Hmmm...
			new /obj/item/clothing/glasses/thermal/syndi(src)
			new /obj/item/clothing/gloves/fingerless(src)
			new /obj/item/clothing/head/cowboyhat(src)
			new /obj/item/clothing/suit/armor/vest/alt(src)

		if("metaops") // ~40 TC. Basically a lone op, theoretically just as rare.
			new /obj/item/clothing/under/syndicate(src)
			new /obj/item/radio/headset/syndicate/alt(src)
			new /obj/item/clothing/glasses/night(src)
			new /obj/item/storage/belt/military(src)
			new /obj/item/clothing/suit/space/hardsuit/syndi(src)
			new /obj/item/tank/jetpack/oxygen/harness(src)
			new /obj/item/tank/internals/oxygen(src)
			new /obj/item/gun/ballistic/automatic/shotgun/bulldog/unrestricted(src)
			new /obj/item/card/emag(src)
			new /obj/item/card/id/syndicate(src)
			new /obj/item/ammo_box/magazine/m12g(src)
			new /obj/item/ammo_box/magazine/m12g(src)
			new /obj/item/ammo_box/magazine/m12g/slug(src)
			new /obj/item/ammo_box/magazine/m12g/slug(src)
			new /obj/item/ammo_box/magazine/m12g/stun(src)
			new /obj/item/ammo_box/magazine/m12g/stun(src)
			new /obj/item/implanter/explosive(src)
			new /obj/item/grenade/plastic/c4 (src)
			new /obj/item/grenade/plastic/c4 (src)
			new /obj/item/grenade/plastic/c4 (src)

		if("ninja") // ~30 TC + RTA Budget space ninja
			new /obj/item/katana(src)
			new /obj/item/card/emag(src)
			new /obj/item/implanter/adrenalin(src)
			new /obj/item/throwing_star(src)
			new /obj/item/throwing_star(src)
			new /obj/item/throwing_star(src)
			new /obj/item/throwing_star(src)
			new /obj/item/throwing_star(src)
			new /obj/item/throwing_star(src)
			new /obj/item/throwing_star(src)
			new /obj/item/implanter/emp(src)
			new /obj/item/grenade/smokebomb(src)
			new /obj/item/grenade/smokebomb(src)
			new /obj/item/clothing/glasses/phantomthief/syndicate(src)
			new /obj/item/clothing/suit/armor/reactive/teleport(src)
			new /obj/item/storage/belt/chameleon(src)
			new /obj/item/card/id/syndicate(src)

/obj/item/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box."
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_freedom/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/freedom(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_microbomb
	name = "Microbomb Implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_microbomb/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/explosive(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_macrobomb
	name = "Macrobomb Implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_macrobomb/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/explosive/macro(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_uplink/PopulateContents()
	..()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/uplink(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/bioterror
	name = "bioterror syringe box"

/obj/item/storage/box/syndie_kit/bioterror/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/syringe/bioterror(src)

/obj/item/storage/box/syndie_kit/imp_adrenal
	name = "boxed adrenal implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_adrenal/PopulateContents()
	var/obj/item/implanter/O = new(src)
	O.imp = new /obj/item/implant/adrenalin(O)
	O.update_icon()

/obj/item/storage/box/syndie_kit/imp_storage
	name = "boxed storage implant (with injector)"

/obj/item/storage/box/syndie_kit/imp_storage/PopulateContents()
	new /obj/item/implanter/storage(src)

/obj/item/storage/box/syndie_kit/imp_emp
	name = "boxed EMP kit"

/obj/item/storage/box/syndie_kit/imp_emp/PopulateContents()
	new /obj/item/implanter/emp(src)

/obj/item/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"

/obj/item/storage/box/syndie_kit/space/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.can_hold = typecacheof(list(/obj/item/clothing/suit/space/syndicate, /obj/item/clothing/head/helmet/space/syndicate))

/obj/item/storage/box/syndie_kit/space/PopulateContents()
	new /obj/item/clothing/suit/space/syndicate/black/red(src) // Black and red is so in right now
	new /obj/item/clothing/head/helmet/space/syndicate/black/red(src)

/obj/item/storage/box/syndie_kit/emp
	name = "box"

/obj/item/storage/box/syndie_kit/emp/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/grenade/empgrenade(src)

/obj/item/storage/box/syndie_kit/flashbang
	name = "box"

/obj/item/storage/box/syndie_kit/flashbag/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/grenade/flashbang(src)

/obj/item/storage/box/syndie_kit/chemical
	name = "boxed chemical kit"

/obj/item/storage/box/syndie_kit/chemical/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 14

/obj/item/storage/box/syndie_kit/chemical/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/polonium(src)
	new /obj/item/reagent_containers/glass/bottle/venom(src)
	new /obj/item/reagent_containers/glass/bottle/fentanyl(src)
	new /obj/item/reagent_containers/glass/bottle/formaldehyde(src)
	new /obj/item/reagent_containers/glass/bottle/spewium(src)
	new /obj/item/reagent_containers/glass/bottle/cyanide(src)
	new /obj/item/reagent_containers/glass/bottle/histamine(src)
	new /obj/item/reagent_containers/glass/bottle/initropidril(src)
	new /obj/item/reagent_containers/glass/bottle/pancuronium(src)
	new /obj/item/reagent_containers/glass/bottle/sodium_thiopental(src)
	new /obj/item/reagent_containers/glass/bottle/coniine(src)
	new /obj/item/reagent_containers/glass/bottle/curare(src)
	new /obj/item/reagent_containers/glass/bottle/amanitin(src)
	new /obj/item/reagent_containers/syringe(src)

/obj/item/storage/box/syndie_kit/nuke
	name = "box"

/obj/item/storage/box/syndie_kit/nuke/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/nuke_core_container(src)
	new /obj/item/paper/guides/antag/nuke_instructions(src)

/obj/item/storage/box/syndie_kit/supermatter
	name = "box"

/obj/item/storage/box/syndie_kit/supermatter/PopulateContents()
	new /obj/item/scalpel/supermatter(src)
	new /obj/item/hemostat/supermatter(src)
	new /obj/item/nuke_core_container/supermatter(src)
	new /obj/item/paper/guides/antag/supermatter_sliver(src)

/obj/item/storage/box/syndie_kit/tuberculosisgrenade
	name = "boxed virus grenade kit"

/obj/item/storage/box/syndie_kit/tuberculosisgrenade/PopulateContents()
	new /obj/item/grenade/chem_grenade/tuberculosis(src)
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/hypospray/medipen/tuberculosiscure(src)
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/glass/bottle/tuberculosiscure(src)

/obj/item/storage/box/syndie_kit/chameleon
	name = "chameleon kit"

/obj/item/storage/box/syndie_kit/chameleon/PopulateContents()
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/suit/chameleon(src)
	new /obj/item/clothing/gloves/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)
	new /obj/item/clothing/glasses/chameleon(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/storage/backpack/chameleon(src)
	new /obj/item/radio/headset/chameleon(src)
	new /obj/item/stamp/chameleon(src)
	new /obj/item/pda/chameleon(src)
	new /obj/item/clothing/neck/cloak/chameleon(src)

//5*(2*4) = 5*8 = 45, 45 damage if you hit one person with all 5 stars.
//Not counting the damage it will do while embedded (2*4 = 8, at 15% chance)
/obj/item/storage/box/syndie_kit/throwing_weapons/PopulateContents()
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/throwing_star(src)
	new /obj/item/restraints/legcuffs/bola/tactical(src)
	new /obj/item/restraints/legcuffs/bola/tactical(src)

/obj/item/storage/box/syndie_kit/cutouts/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/cardboard_cutout/adaptive(src)
	new/obj/item/toy/crayon/rainbow(src)

/obj/item/storage/box/syndie_kit/romerol/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/romerol(src)
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/dropper(src)

/obj/item/storage/box/syndie_kit/ez_clean/PopulateContents()
	for(var/i in 1 to 3)
		new/obj/item/grenade/chem_grenade/ez_clean(src)

/obj/item/storage/box/hug/reverse_revolver/PopulateContents()
	new /obj/item/gun/ballistic/revolver/reverse(src)

/obj/item/storage/box/syndie_kit/mimery/PopulateContents()
	new /obj/item/book/granter/spell/mimery_blockade(src)
	new /obj/item/book/granter/spell/mimery_guns(src)

/obj/item/storage/box/syndie_kit/imp_radio/PopulateContents()
	new /obj/item/implanter/radio/syndicate(src)

/obj/item/storage/box/syndie_kit/centcom_costume/PopulateContents()
	new /obj/item/clothing/under/rank/centcom_officer/syndicate(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/radio/headset/headset_cent/empty(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/storage/backpack/satchel(src)
	new /obj/item/pda/heads(src)
	new /obj/item/clipboard(src)

/obj/item/storage/box/syndie_kit/chameleon/broken/PopulateContents()
	new /obj/item/clothing/under/chameleon/broken(src)
	new /obj/item/clothing/suit/chameleon/broken(src)
	new /obj/item/clothing/gloves/chameleon/broken(src)
	new /obj/item/clothing/shoes/chameleon/noslip/broken(src)
	new /obj/item/clothing/glasses/chameleon/broken(src)
	new /obj/item/clothing/head/chameleon/broken(src)
	new /obj/item/clothing/mask/chameleon/broken(src)
	new /obj/item/storage/backpack/chameleon/broken(src)
	new /obj/item/radio/headset/chameleon/broken(src)
	new /obj/item/stamp/chameleon/broken(src)
	new /obj/item/pda/chameleon/broken(src)
	// No chameleon laser, they can't randomise for //REASONS//

/obj/item/storage/box/syndie_kit/bee_grenades
	name = "buzzkill grenade box"
	desc = "A sleek, sturdy box with a buzzing noise coming from the inside. Uh oh."

/obj/item/storage/box/syndie_kit/bee_grenades/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/spawnergrenade/buzzkill(src)

/obj/item/storage/box/syndie_kit/kitchen_gun
	name = "Kitchen Gun (TM) package"

/obj/item/storage/box/syndie_kit/kitchen_gun/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/m1911/kitchengun(src)
	new /obj/item/ammo_box/magazine/m45/kitchengun(src)
	new /obj/item/ammo_box/magazine/m45/kitchengun(src)


/obj/item/storage/box/strange_seeds_10pack

/obj/item/storage/box/strange_seeds_10pack/PopulateContents()
	for(var/i in 1 to 10)
		new /obj/item/seeds/random(src)

	if(prob(50))
		new /obj/item/seeds/random(src) //oops, an additional packet might have slipped its way into the box

/obj/item/storage/box/syndie_kit/pistol

/obj/item/storage/box/syndie_kit/pistol/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol(src)
	new /obj/item/ammo_box/magazine/m10mm(src)

/obj/item/storage/box/syndie_kit/pistolammo

/obj/item/storage/box/syndie_kit/pistolammo/PopulateContents()
	new /obj/item/ammo_box/magazine/m10mm(src)
	new /obj/item/ammo_box/magazine/m10mm(src)

/obj/item/storage/box/syndie_kit/revolver

/obj/item/storage/box/syndie_kit/revolver/PopulateContents()
	new /obj/item/gun/ballistic/revolver(src)
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/a357(src)
	new /obj/item/ammo_box/a357/ap(src)
	new /obj/item/ammo_box/a357/ap(src)
	new /obj/item/ammo_box/a357/rubber(src)
	new /obj/item/ammo_box/a357/rubber(src)

/obj/item/storage/box/syndie_kit/machinepistol

/obj/item/storage/box/syndie_kit/machinepistol/PopulateContents()
	new /obj/item/gun/ballistic/automatic/pistol/machinepistol(src)
	new /obj/item/ammo_box/magazine/pistolm9mm(src)

/obj/item/storage/box/syndie_kit/doublebarrel

/obj/item/storage/box/syndie_kit/doublebarrel/PopulateContents()
	new /obj/item/gun/ballistic/revolver/doublebarrel/sawn(src)
	new /obj/item/ammo_casing/shotgun/buckshot(src)
	new /obj/item/ammo_casing/shotgun/buckshot(src)
	new /obj/item/ammo_casing/shotgun/buckshot(src)
	new /obj/item/ammo_casing/shotgun/buckshot(src)
	new /obj/item/ammo_casing/shotgun/buckshot(src)
	new /obj/item/ammo_casing/shotgun/buckshot(src)

/obj/item/storage/box/syndie_kit/shotgun

/obj/item/storage/box/syndie_kit/shotgun/PopulateContents()
	new /obj/item/gun/ballistic/shotgun/automatic/combat/traitor(src)
	new /obj/item/storage/box/lethalshot(src)
	new /obj/item/storage/box/lethalslugs(src)
	new /obj/item/storage/box/lethalslugs(src)
	new /obj/item/storage/box/rubbershot(src)
	new /obj/item/storage/box/rubbershot(src)
	new /obj/item/storage/box/lasershot(src)