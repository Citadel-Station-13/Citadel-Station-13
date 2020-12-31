
//Reminders-
// If you add something to this list, please group it by type and sort it alphabetically instead of just jamming it in like an animal
// cost = 700- Minimum cost, or infinite points are possible.
//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical
	group = "Medical"
	crate_type = /obj/structure/closet/crate/medical

//////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Equipment ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical/bodybags
	name = "Bodybags"
	desc = "For when the bodies hit the floor. Contains 4 boxes of bodybags."
	cost = 1200
	contains = list(/obj/item/storage/box/bodybags,
					/obj/item/storage/box/bodybags,
					/obj/item/storage/box/bodybags,
					/obj/item/storage/box/bodybags,)
	crate_name = "bodybag crate"

/datum/supply_pack/medical/bloodpacks
	name = "Blood Pack Variety Crate"
	desc = "Contains nine different blood packs for reintroducing blood to patients, plus two universal synthetic blood packs."
	cost = 3000
	contains = list(/obj/item/reagent_containers/blood/synthetics,
					/obj/item/reagent_containers/blood/synthetics,
					/obj/item/reagent_containers/blood/random,
					/obj/item/reagent_containers/blood/APlus,
					/obj/item/reagent_containers/blood/AMinus,
					/obj/item/reagent_containers/blood/BPlus,
					/obj/item/reagent_containers/blood/BMinus,
					/obj/item/reagent_containers/blood/OPlus,
					/obj/item/reagent_containers/blood/OMinus,
					/obj/item/reagent_containers/blood/lizard,
					/obj/item/reagent_containers/blood/jellyblood,
					/obj/item/reagent_containers/blood/insect)
	crate_name = "blood freezer"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/chemical
	name = "Chemical Starter Kit Crate"
	desc = "Contains twelve different chemicals, for all the fun experiments you can make."
	cost = 1700
	contains = list(/obj/item/reagent_containers/glass/bottle/hydrogen,
					/obj/item/reagent_containers/glass/bottle/carbon,
					/obj/item/reagent_containers/glass/bottle/nitrogen,
					/obj/item/reagent_containers/glass/bottle/oxygen,
					/obj/item/reagent_containers/glass/bottle/fluorine,
					/obj/item/reagent_containers/glass/bottle/phosphorus,
					/obj/item/reagent_containers/glass/bottle/silicon,
					/obj/item/reagent_containers/glass/bottle/chlorine,
					/obj/item/reagent_containers/glass/bottle/radium,
					/obj/item/reagent_containers/glass/bottle/sacid,
					/obj/item/reagent_containers/glass/bottle/ethanol,
					/obj/item/reagent_containers/glass/bottle/potassium,
					/obj/item/clothing/glasses/science,
					/obj/item/reagent_containers/dropper,
					/obj/item/storage/box/beakers)
	crate_name = "chemical crate"

/datum/supply_pack/medical/defibs
	name = "Defibrillator Crate"
	desc = "Contains two defibrillators for bringing the recently deceased back to life."
	cost = 2500
	contains = list(/obj/item/defibrillator/loaded,
					/obj/item/defibrillator/loaded)
	crate_name = "defibrillator crate"

/datum/supply_pack/medical/iv_drip
	name = "IV Drip Crate"
	desc = "Contains a single IV drip stand for intravenous delivery."
	cost = 800
	contains = list(/obj/machinery/iv_drip)
	crate_name = "iv drip crate"

/datum/supply_pack/medical/medicalhardsuit
	name = "Medical Hardsuit"
	desc = "Got people being spaced left and right? Hole in the same room as the dead body of Hos or cap? Fear not, now you can buy one medical hardsuit with a mask and air tank to save your fellow crewmembers. Requires medical access to open."
	cost = 2750
	access = ACCESS_MEDICAL
	contains = list(/obj/item/tank/internals/air,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/suit/space/hardsuit/medical)
	crate_name = "medical hardsuit"
	crate_type = /obj/structure/closet/crate/secure/medical

/datum/supply_pack/medical/paramedicevasuit
	name = "Paramedic EVA Suit"
	desc = "Greytide pushing up daisies with the carp outside the station? Chemistry vented in a meth experiment gone wrong? Be the blue saviour this station desperately needs and get your Paramedical EVA suit today! Requires medical access to open."
	cost = 1975
	access = ACCESS_MEDICAL
	contains = list(/obj/item/tank/internals/emergency_oxygen,
					/obj/item/clothing/head/helmet/space/eva/paramedic,
					/obj/item/clothing/suit/space/eva/paramedic,
					/obj/item/clothing/mask/breath)
	crate_name = "paramedic EVA suit"
	crate_type = /obj/structure/closet/crate/secure/medical

/datum/supply_pack/medical/supplies
	name = "Medical Supplies Crate"
	desc = "Contains seven beakers, syringes, and bodybags. Three morphine bottles, four insulin pills. Two charcoal bottles, epinephrine bottles, antitoxin bottles, and large beakers. Finally, a single roll of medical gauze, as well as a bottle of stimulant pills for long, hard work days. German doctor not included."
	cost = 2500
	contains = list(/obj/item/reagent_containers/glass/bottle/charcoal,
					/obj/item/reagent_containers/glass/bottle/charcoal,
					/obj/item/reagent_containers/glass/bottle/epinephrine,
					/obj/item/reagent_containers/glass/bottle/epinephrine,
					/obj/item/reagent_containers/glass/bottle/morphine,
					/obj/item/reagent_containers/glass/bottle/morphine,
					/obj/item/reagent_containers/glass/bottle/morphine,
					/obj/item/reagent_containers/glass/bottle/toxin,
					/obj/item/reagent_containers/glass/bottle/toxin,
					/obj/item/reagent_containers/glass/beaker/large,
					/obj/item/reagent_containers/glass/beaker/large,
					/obj/item/reagent_containers/pill/insulin,
					/obj/item/reagent_containers/pill/insulin,
					/obj/item/reagent_containers/pill/insulin,
					/obj/item/reagent_containers/pill/insulin,
					/obj/item/stack/medical/gauze,
					/obj/item/storage/box/beakers,
					/obj/item/storage/box/medsprays,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/bodybags,
					/obj/item/storage/pill_bottle/stimulant,
					/obj/item/stack/medical/bone_gel,
					/obj/item/stack/medical/bone_gel)
	crate_name = "medical supplies crate"

/datum/supply_pack/medical/adv_surgery_tools
	name = "Med-Co Advanced Surgery Tools"
	desc = "A full set of Med-Co advanced surgery tools, this crate also comes with a spay of synth flesh as well as a can of . Requires Surgery access to open."
	cost = 5500
	access = ACCESS_SURGERY
	contains = list(/obj/item/storage/belt/medical/surgery_belt_adv,
					/obj/item/reagent_containers/medspray/synthflesh,
					/obj/item/reagent_containers/medspray/sterilizine)
	crate_name = "medco surgery tools"
	crate_type = /obj/structure/closet/crate/secure/medical

/datum/supply_pack/medical/surgery
	name = "Surgical Supplies Crate"
	desc = "Do you want to perform surgery, but don't have one of those fancy shmancy degrees? Just get started with this crate containing a medical duffelbag, Sterilizine spray and collapsible roller bed."
	cost = 1300
	contains = list(/obj/item/storage/backpack/duffelbag/med/surgery,
					/obj/item/reagent_containers/medspray/sterilizine,
					/obj/item/roller)
	crate_name = "surgical supplies crate"

//////////////////////////////////////////////////////////////////////////////
///////////////////////////// Medical Kits ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical/sprays
	name = "Medical Sprays"
	desc = "Contains two cans of Styptic Spray, Silver Sulfadiazine Spray, Synthflesh Spray and Sterilizer Compound Spray."
	cost = 2250
	contains = list(/obj/item/reagent_containers/medspray/styptic,
					/obj/item/reagent_containers/medspray/styptic,
					/obj/item/reagent_containers/medspray/silver_sulf,
					/obj/item/reagent_containers/medspray/silver_sulf,
					/obj/item/reagent_containers/medspray/synthflesh,
					/obj/item/reagent_containers/medspray/synthflesh,
					/obj/item/reagent_containers/medspray/sterilizine,
					/obj/item/reagent_containers/medspray/sterilizine)
	crate_name = "medical supplies crate"

/datum/supply_pack/medical/advrad
	name = "Radiation Treatment Crate Deluxe"
	desc = "A crate for when radiation is out of hand... Contains two rad-b-gone kits, one bottle of anti radiation deluxe pills, as well as a radiation treatment deluxe pill bottle!"
	cost = 3500
	contains = list(/obj/item/storage/pill_bottle/antirad_plus,
					/obj/item/storage/pill_bottle/mutarad,
					/obj/item/storage/firstaid/radbgone,
					/obj/item/storage/firstaid/radbgone,
					/obj/item/geiger_counter,
					/obj/item/geiger_counter)
	crate_name = "radiation protection crate"
	crate_type = /obj/structure/closet/crate/radiation

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////// Virology ////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/medical/virus
	name = "Virus Crate"
	desc = "Contains twelve different bottles, containing several viral samples for virology research. Also includes seven beakers and syringes. Balled-up jeans not included. Requires CMO access to open."
	cost = 2500
	access = ACCESS_CMO
	contains = list(/obj/item/reagent_containers/glass/bottle/flu_virion,
					/obj/item/reagent_containers/glass/bottle/cold,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/random_virus,
					/obj/item/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/reagent_containers/glass/bottle/magnitis,
					/obj/item/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/reagent_containers/glass/bottle/brainrot,
					/obj/item/reagent_containers/glass/bottle/anxiety,
					/obj/item/reagent_containers/glass/bottle/beesease,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers,
					/obj/item/reagent_containers/glass/bottle/mutagen)
	crate_name = "virus crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	dangerous = TRUE
	can_private_buy = FALSE

/datum/supply_pack/medical/anitvirus
	name = "Virus Containment Crate"
	desc = "Viro let out a death plague Mk II again? Someone didn't wash their hands? Old plagues born anew? Well, this crate is for you! Hope you cure it before it breaks out of the station... This crate needs medical access to open and has two bio suits, a box of needles and beakers, five spaceacillin needles, and a medibot."
	cost = 3000
	access = ACCESS_MEDICAL
	contains = list(/mob/living/simple_animal/bot/medbot,
					/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/head/bio_hood,
					/obj/item/clothing/suit/bio_suit,
					/obj/item/clothing/suit/bio_suit,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/reagent_containers/syringe/antiviral,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers)
	crate_name = "virus containment unit crate"
	crate_type = /obj/structure/closet/crate/secure/plasma

/datum/supply_pack/medical/medipen_variety
	name = "Medipen Variety-Pak"
	desc = "Contains eight different medipens in three different varieties, to assist in quickly treating seriously injured patients."
	cost = 2000
	contains = list(/obj/item/reagent_containers/hypospray/medipen/,
					/obj/item/reagent_containers/hypospray/medipen/,
					/obj/item/reagent_containers/hypospray/medipen/ekit,
					/obj/item/reagent_containers/hypospray/medipen/ekit,
					/obj/item/reagent_containers/hypospray/medipen/ekit,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss)

	crate_name = "medipen crate"
