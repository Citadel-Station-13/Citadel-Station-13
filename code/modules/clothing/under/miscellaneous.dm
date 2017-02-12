/obj/item/clothing/under/pj/red
	name = "red pj's"
	desc = "Sleepwear."
	icon_state = "red_pyjamas"
	item_color = "red_pyjamas"
	item_state = "w_suit"
	can_adjust = 0

/obj/item/clothing/under/pj/blue
	name = "blue pj's"
	desc = "Sleepwear."
	icon_state = "blue_pyjamas"
	item_color = "blue_pyjamas"
	item_state = "w_suit"
	can_adjust = 0

/obj/item/clothing/under/patriotsuit
	name = "Patriotic Suit"
	desc = "Motorcycle not included."
	icon_state = "ek"
	item_state = "ek"
	item_color = "ek"
	can_adjust = 0

/obj/item/clothing/under/scratch
	name = "white suit"
	desc = "A white suit, suitable for an excellent host"
	icon_state = "scratch"
	item_state = "scratch"
	item_color = "scratch"
	can_adjust = 0

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon_state = "sl_suit"
	item_color = "sl_suit"
	can_adjust = 0

/obj/item/clothing/under/roman
	name = "roman armor"
	desc = "Ancient Roman armor. Made of metallic and leather straps."
	icon_state = "roman"
	item_color = "roman"
	item_state = "armor"
	can_adjust = 0
	strip_delay = 100
	resistance_flags = 0

/obj/item/clothing/under/waiter
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tip."
	icon_state = "waiter"
	item_state = "waiter"
	item_color = "waiter"
	can_adjust = 0

/obj/item/clothing/under/rank/prisoner
	name = "prison jumpsuit"
	desc = "It's standardised Nanotrasen prisoner-wear. Its suit sensors are stuck in the \"Fully On\" position."
	icon_state = "prisoner"
	item_state = "o_suit"
	item_color = "prisoner"
	has_sensor = 2
	sensor_mode = 3
	random_sensor = 0

/obj/item/clothing/under/rank/mailman
	name = "mailman's jumpsuit"
	desc = "<i>'Special delivery!'</i>"
	icon_state = "mailman"
	item_state = "b_suit"
	item_color = "mailman"

/obj/item/clothing/under/rank/psyche
	name = "psychedelic jumpsuit"
	desc = "Groovy!"
	icon_state = "psyche"
	item_state = "p_suit"
	item_color = "psyche"

/obj/item/clothing/under/rank/clown/sexy
	name = "sexy-clown suit"
	desc = "It makes you look HONKable!"
	icon_state = "sexyclown"
	item_state = "sexyclown"
	item_color = "sexyclown"
	can_adjust = 0

/obj/item/clothing/under/jabroni
	name = "Jabroni Outfit"
	desc = "The leather club is two sectors down."
	icon_state = "darkholme"
	item_state = "darkholme"
	item_color = "darkholme"
	can_adjust = 0

/obj/item/clothing/under/rank/vice
	name = "vice officer's jumpsuit"
	desc = "It's the standard issue pretty-boy outfit, as seen on Holo-Vision."
	icon_state = "vice"
	item_state = "gy_suit"
	item_color = "vice"
	can_adjust = 0

/obj/item/clothing/under/rank/centcom_officer
	desc = "It's a jumpsuit worn by Centcom Officers."
	name = "\improper Centcom officer's jumpsuit"
	icon_state = "officer"
	item_state = "g_suit"
	item_color = "officer"
	alt_covers_chest = 1

/obj/item/clothing/under/rank/centcom_commander
	desc = "It's a jumpsuit worn by Centcom's highest-tier Commanders."
	name = "\improper Centcom officer's jumpsuit"
	icon_state = "centcom"
	item_state = "dg_suit"
	item_color = "centcom"

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	item_state = "bl_suit"
	item_color = "black"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST | GROIN | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	can_adjust = 0
	resistance_flags = 0

/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state = "bl_suit"
	item_color = "syndicate"
	desc = "A cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100, fire = 100, acid = 100)
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	can_adjust = 0
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/under/owl
	name = "owl uniform"
	desc = "A soft brown jumpsuit made of synthetic feathers and strong conviction."
	icon_state = "owl"
	item_color = "owl"
	can_adjust = 0

/obj/item/clothing/under/griffin
	name = "griffon uniform"
	desc = "A soft brown jumpsuit with a white feather collar made of synthetic feathers and a lust for mayhem."
	icon_state = "griffin"
	item_color = "griffin"
	can_adjust = 0

/obj/item/clothing/under/cloud
	name = "cloud"
	desc = "cloud"
	icon_state = "cloud"
	item_color = "cloud"
	can_adjust = 0

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "captain's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	item_color = "green_suit"
	can_adjust = 0

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "head of personnel's suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state = "g_suit"
	item_color = "teal_suit"
	can_adjust = 0

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state = "bl_suit"
	item_color = "black_suit"
	can_adjust = 0

/obj/item/clothing/under/suit_jacket/really_black
	name = "executive suit"
	desc = "A formal black suit and red tie, intended for the station's finest."
	icon_state = "really_black_suit"
	item_state = "bl_suit"
	item_color = "black_suit"

/obj/item/clothing/under/suit_jacket/female
	name = "executive suit"
	desc = "A formal trouser suit for women, intended for the station's finest."
	icon_state = "black_suit_fem"
	item_state = "black_suit_fem"
	item_color = "black_suit_fem"

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	item_color = "red_suit"

/obj/item/clothing/under/suit_jacket/charcoal
	name = "charcoal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon_state = "charcoal_suit"
	item_state = "charcoal_suit"
	item_color = "charcoal_suit"

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the station's finest."
	icon_state = "navy_suit"
	item_state = "navy_suit"
	item_color = "navy_suit"

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state = "burgundy_suit"
	item_color = "burgundy_suit"

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state = "checkered_suit"
	item_color = "checkered_suit"

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit with a yellow tie. Smart, but casual."
	icon_state = "tan_suit"
	item_state = "tan_suit"
	item_color = "tan_suit"

/obj/item/clothing/under/suit_jacket/white
	name = "white suit"
	desc = "A white suit and jacket with a blue shirt. You wanna play rough? OKAY!."
	icon_state = "white_suit"
	item_state = "white_suit"
	item_color = "white_suit"

/obj/item/clothing/under/burial
	name = "burial garments"
	desc = "Traditional burial garments from the early 22nd century."
	icon_state = "burial"
	item_state = "burial"
	item_color = "burial"

/obj/item/clothing/under/skirt/black
	name = "black skirt"
	desc = "A black skirt, very fancy!"
	icon_state = "blackskirt"
	item_color = "blackskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/skirt/blue
	name = "blue skirt"
	desc = "A blue, casual skirt."
	icon_state = "blueskirt"
	item_color = "blueskirt"
	item_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/skirt/red
	name = "red skirt"
	desc = "A red, casual skirt."
	icon_state = "redskirt"
	item_color = "redskirt"
	item_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/skirt/purple
	name = "purple skirt"
	desc = "A purple, casual skirt."
	icon_state = "purpleskirt"
	item_color = "purpleskirt"
	item_state = "p_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0


/obj/item/clothing/under/schoolgirl
	name = "blue schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state = "schoolgirl"
	item_color = "schoolgirl"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/schoolgirl/red
	name = "red schoolgirl uniform"
	icon_state = "schoolgirlred"
	item_state = "schoolgirlred"
	item_color = "schoolgirlred"

/obj/item/clothing/under/schoolgirl/green
	name = "green schoolgirl uniform"
	icon_state = "schoolgirlgreen"
	item_state = "schoolgirlgreen"
	item_color = "schoolgirlgreen"

/obj/item/clothing/under/schoolgirl/orange
	name = "orange schoolgirl uniform"
	icon_state = "schoolgirlorange"
	item_state = "schoolgirlorange"
	item_color = "schoolgirlorange"

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	item_color = "overalls"
	can_adjust = 0

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	item_color = "pirate"
	can_adjust = 0

/obj/item/clothing/under/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state = "soviet"
	item_color = "soviet"
	can_adjust = 0

/obj/item/clothing/under/redcoat
	name = "redcoat uniform"
	desc = "Looks old."
	icon_state = "redcoat"
	item_state = "redcoat"
	item_color = "redcoat"
	can_adjust = 0

/obj/item/clothing/under/kilt
	name = "kilt"
	desc = "Includes shoes and plaid."
	icon_state = "kilt"
	item_state = "kilt"
	item_color = "kilt"
	body_parts_covered = CHEST|GROIN|FEET
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/kilt/highlander
	desc = "You're the only one worthy of this kilt."
	flags = NODROP

/obj/item/clothing/under/sexymime
	name = "sexy mime outfit"
	desc = "The only time when you DON'T enjoy looking at someone's rack."
	icon_state = "sexymime"
	item_state = "sexymime"
	item_color = "sexymime"
	body_parts_covered = CHEST|GROIN|LEGS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state = "gladiator"
	item_color = "gladiator"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = 0
	resistance_flags = 0

/obj/item/clothing/under/gladiator/ash_walker
	desc = "This gladiator uniform appears to be covered in ash and fairly dated."
	has_sensor = 0

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon_state = "sundress"
	item_state = "sundress"
	item_color = "sundress"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/captainparade
	name = "captain's parade uniform"
	desc = "A captain's luxury-wear, for special occasions."
	icon_state = "captain_parade"
	item_state = "by_suit"
	item_color = "captain_parade"
	can_adjust = 0

/obj/item/clothing/under/hosparademale
	name = "head of security's parade uniform"
	desc = "A male head of security's luxury-wear, for special occasions."
	icon_state = "hos_parade_male"
	item_state = "r_suit"
	item_color = "hos_parade_male"
	can_adjust = 0

/obj/item/clothing/under/hosparadefem
	name = "head of security's parade uniform"
	desc = "A female head of security's luxury-wear, for special occasions."
	icon_state = "hos_parade_fem"
	item_state = "r_suit"
	item_color = "hos_parade_fem"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon_state = "assistant_formal"
	item_state = "gy_suit"
	item_color = "assistant_formal"
	can_adjust = 0

/obj/item/clothing/under/blacktango
	name = "black tango dress"
	desc = "Filled with Latin fire."
	icon_state = "black_tango"
	item_state = "wcoat"
	item_color = "black_tango"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/stripeddress
	name = "striped dress"
	desc = "Fashion in space."
	icon_state = "striped_dress"
	item_state = "stripeddress"
	item_color = "striped_dress"
	fitted = FEMALE_UNIFORM_FULL
	can_adjust = 0

/obj/item/clothing/under/sailordress
	name = "sailor dress"
	desc = "Formal wear for a leading lady."
	icon_state = "sailor_dress"
	item_state = "sailordress"
	item_color = "sailor_dress"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/redeveninggown
	name = "red evening gown"
	desc = "Fancy dress for space bar singers."
	icon_state = "red_evening_gown"
	item_state = "redeveninggown"
	item_color = "red_evening_gown"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/maid
	name = "maid costume"
	desc = "Maid in China."
	icon_state = "maid"
	item_state = "maid"
	item_color = "maid"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/janimaid
	name = "maid uniform"
	desc = "A simple maid uniform for housekeeping."
	icon_state = "janimaid"
	item_state = "janimaid"
	item_color = "janimaid"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/plaid_skirt
	name = "red plaid skirt"
	desc = "A preppy red skirt with a white blouse."
	icon_state = "plaid_red"
	item_state = "plaid_red"
	item_color = "plaid_red"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 1
	alt_covers_chest = 1

/obj/item/clothing/under/plaid_skirt/blue
	name = "blue plaid skirt"
	desc = "A preppy blue skirt with a white blouse."
	icon_state = "plaid_blue"
	item_state = "plaid_blue"
	item_color = "plaid_blue"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 1
	alt_covers_chest = 1

/obj/item/clothing/under/plaid_skirt/purple
	name = "purple plaid skirt"
	desc = "A preppy purple skirt with a white blouse."
	icon_state = "plaid_purple"
	item_state = "plaid_purple"
	item_color = "plaid_purple"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 1
	alt_covers_chest = 1

/obj/item/clothing/under/singery
	name = "yellow performer's outfit"
	desc = "Just looking at this makes you want to sing."
	icon_state = "ysing"
	item_state = "ysing"
	item_color = "ysing"
	fitted = NO_FEMALE_UNIFORM
	alternate_worn_layer = ABOVE_SHOES_LAYER
	can_adjust = 0

/obj/item/clothing/under/singerb
	name = "blue performer's outfit"
	desc = "Just looking at this makes you want to sing."
	icon_state = "bsing"
	item_state = "bsing"
	item_color = "bsing"
	alternate_worn_layer = ABOVE_SHOES_LAYER
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 0

/obj/item/clothing/under/plaid_skirt/green
	name = "green plaid skirt"
	desc = "A preppy green skirt with a white blouse."
	icon_state = "plaid_green"
	item_state = "plaid_green"
	item_color = "plaid_green"
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = 1
	alt_covers_chest = 1

/obj/item/clothing/under/jester
	name = "jester suit"
	desc = "A jolly dress, well suited to entertain your master, nuncle."
	icon_state = "jester"
	item_color = "jester"
	can_adjust = 0

/obj/item/clothing/under/geisha
	name = "geisha suit"
	desc = "Cute space ninja senpai not included."
	icon_state = "geisha"
	item_color = "geisha"
	can_adjust = 0

/obj/item/clothing/under/villain
	name = "villain suit"
	desc = "A change of wardrobe is necessary if you ever want to catch a real superhero."
	icon_state = "villain"
	item_color = "villain"
	can_adjust = 0

/obj/item/clothing/under/sailor
	name = "sailor suit"
	desc = "Skipper's in the wardroom drinkin gin'."
	icon_state = "sailor"
	item_state = "b_suit"
	item_color = "sailor"
	can_adjust = 0

/obj/item/clothing/under/plasmaman
	name = "plasma envirosuit"
	desc = "A special containment suit that allows plasma-based lifeforms to exist safely in an oxygenated environment, and automatically extinguishes them in a crisis. Despite being airtight, it's not spaceworthy."
	icon_state = "plasmaman"
	item_state = "plasmaman"
	item_color = "plasmaman"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 0, fire = 95, acid = 95)
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	can_adjust = 0
	strip_delay = 80
	var/next_extinguish = 0
	var/extinguish_cooldown = 100
	var/extinguishes_left = 5


/obj/item/clothing/under/plasmaman/examine(mob/user)
	..()
	user << "<span class='notice'>There are [extinguishes_left] extinguisher charges left in this suit.</span>"


/obj/item/clothing/under/plasmaman/proc/Extinguish(mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(H.on_fire)
		if(extinguishes_left)
			if(next_extinguish > world.time)
				return
			next_extinguish = world.time + extinguish_cooldown
			extinguishes_left--
			H.visible_message("<span class='warning'>[H]'s suit automatically extinguishes them!</span>","<span class='warning'>Your suit automatically extinguishes you.</span>")
			H.ExtinguishMob()
			new /obj/effect/particle_effect/water(get_turf(H))
	return 0

/obj/item/clothing/under/plasmaman/attackby(obj/item/E, mob/user, params)
	if (istype(E, /obj/item/device/extinguisher_refill))
		if (extinguishes_left == 5)
			user << "<span class='notice'>The inbuilt extinguisher is full.</span>"
			return
		else
			extinguishes_left = 5
			user << "<span class='notice'>You refill the suit's built-in extinguisher, using up the cartridge.</span>"
			qdel(E)
			return
		return
	return

/obj/item/device/extinguisher_refill
	name = "envirosuit extinguisher cartridge"
	desc = "A cartridge loaded with a compressed extinguisher mix, used to refill the automatic extinguisher on plasma envirosuits."
	icon_state = "plasmarefill"
	origin_tech = "materials=2;plasmatech=3;biotech=1"

/obj/item/clothing/under/rank/security/navyblue/russian
	name = "russian officer's uniform"
	desc = "The latest in fashionable russian outfits."
	icon_state = "hostanclothes"
	item_state = "hostanclothes"
	item_color = "hostanclothes"

/obj/item/clothing/under/stripper_pink
	name = "pink stripper outfit"
	icon_state = "stripper_p"
	item_state = "stripper_p"
	item_color = "stripper_p"
	can_adjust = 0

/obj/item/clothing/under/stripper_green
	name = "green stripper outfit"
	icon_state = "stripper_g"
	item_state = "stripper_g"
	item_color = "stripper_g"
	can_adjust = 0


/obj/item/clothing/under/wedding/bride_orange
	name = "orange wedding dress"
	desc = "A big and puffy orange dress."
	icon_state = "bride_orange"
	item_state = "bride_orange"
	item_color = "bride_orange"
	can_adjust = 0

/obj/item/clothing/under/wedding/bride_purple
	name = "purple wedding dress"
	desc = "A big and puffy purple dress."
	icon_state = "bride_purple"
	item_state = "bride_purple"
	item_color = "bride_purple"
	can_adjust = 0

/obj/item/clothing/under/wedding/bride_blue
	name = "blue wedding dress"
	desc = "A big and puffy blue dress."
	icon_state = "bride_blue"
	item_state = "bride_blue"
	item_color = "bride_blue"
	can_adjust = 0

/obj/item/clothing/under/wedding/bride_red
	name = "red wedding dress"
	desc = "A big and puffy red dress."
	icon_state = "bride_red"
	item_state = "bride_red"
	item_color = "bride_red"
	can_adjust = 0

/obj/item/clothing/under/wedding/bride_white
	name = "white wedding dress"
	desc = "A white wedding gown made from the finest silk."
	icon_state = "bride_white"
	item_state = "bride_white"
	item_color = "bride_white"
	can_adjust = 0

/obj/item/clothing/under/mankini
	name = "pink mankini"
	icon_state = "mankini"
	item_state = "mankini"
	item_color = "mankini"
	can_adjust = 0

/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state = "psysuit"
	item_color = "psysuit"
	can_adjust = 0

/obj/item/clothing/under/officeruniform
	name = "officer's uniform"
	desc = "Bestraft die Juden fur ihre Verbrechen."
	icon_state = "officeruniform"
	item_state = "officeruniform"
	item_color = "officeruniform"
	can_adjust = 0

/obj/item/clothing/under/soldieruniform
	name = "soldier's uniform"
	desc = "Bestraft die Verbundeten fur ihren Widerstand."
	icon_state = "soldieruniform"
	item_state = "soldieruniform"
	item_color = "soldieruniform"
	can_adjust = 0

/obj/item/clothing/under/squatter_outfit
	name = "slav squatter tracksuit"
	desc = "Cyka blyat."
	icon_state = "squatteroutfit"
	item_state = "squatteroutfit"
	item_color = "squatteroutfit"
	can_adjust = 0

/obj/item/clothing/under/russobluecamooutfit
	name = "russian blue camo"
	desc = "Drop and give me dvadtsat!"
	icon_state = "russobluecamo"
	item_state = "russobluecamo"
	item_color = "russobluecamo"
	can_adjust = 0

/obj/item/clothing/under/stilsuit
	name = "stillsuit"
	desc = "Designed to preserve bodymoisture."
	icon_state = "stilsuit"
	item_state = "stilsuit"
	item_color = "stilsuit"
	can_adjust = 0

/obj/item/clothing/under/aviatoruniform
	name = "aviator uniform"
	desc = "Now you can look absolutely dashing!"
	icon_state = "aviator_uniform"
	item_state = "aviator_uniform"
	item_color = "aviator_uniform"
	can_adjust = 0

/obj/item/clothing/under/bikersuit
	name = "biker's outfit"
	icon_state = "biker"
	item_state = "biker"
	item_color = "biker"
	can_adjust = 0

/obj/item/clothing/under/jacketsuit
	name = "richard's outfit"
	desc = "Do you know what time it is?"
	icon_state = "jacket"
	item_state = "jacket"
	item_color = "jacket"
	can_adjust = 0

obj/item/clothing/under/mega
	name = "\improper DRN-001 suit"
	desc = "The original. Simple, yet very adaptable."
	icon_state = "mega"
	item_state = "mega"
	item_color = "mega"
	can_adjust = 0

/obj/item/clothing/under/proto
	name = "The Prototype Suit"
	desc = "Even robots know scarves are the perfect accessory for a brooding rival."
	icon_state = "proto"
	item_state = "proto"
	item_color = "proto"
	can_adjust = 0

/obj/item/clothing/under/megax
	name = "\improper Maverick Hunter regalia"
	desc = "The best outfit for taking out rogue borgs."
	icon_state = "megax"
	item_state = "megax"
	item_color = "megax"
	can_adjust = 0

/obj/item/clothing/under/joe
	name = "The Sniper Suit"
	desc = "Mass produced combat robots with a rather unfitting name."
	icon_state = "joe"
	item_state = "joe"
	item_color = "joe"
	can_adjust = 0

/obj/item/clothing/under/roll
	name = "\improper DRN-002 Dress"
	desc = "A simple red dress, the good doctor's second robot wasn't quite as exciting as the first."
	icon_state = "roll"
	item_state = "roll"
	item_color = "roll"
	can_adjust = 0

/obj/item/clothing/under/gokugidown
	name = "turtle hermit undershirt"
	desc = "Something seems oddly familiar about this outfit..."
	icon_state = "gokugidown"
	item_state = "gokugidown"
	item_color = "gokugidown"
	can_adjust = 0

/obj/item/clothing/under/gokugi
	name = "turtle hermit outfit"
	desc = "An outfit from one trained by the great Turtle Hermit."
	icon_state = "gokugi"
	item_state = "gokugi"
	item_color = "gokugi"
	can_adjust = 0

/obj/item/clothing/under/doomguy
	name = "\improper Doomguy's pants"
	desc = ""
	icon_state = "doom"
	item_state = "doom"
	item_color = "doom"
	can_adjust = 0

/obj/item/clothing/under/vault13
	name = "vault 13 Jumpsuit"
	desc = "Oddly similar to the station's usual jumpsuits, but with a rustic charm to it. Has a large thirteen emblazened on the back."
	icon_state = "v13-jumpsuit"
	item_state = "v13-jumpsuit"
	item_color = "v13-jumpsuit"
	can_adjust = 0

/obj/item/clothing/under/vault
	name = "vault jumpsuit"
	desc = "Oddly similar to the station's usual jumpsuits, but with a rustic charm to it."
	icon_state = "v-jumpsuit"
	item_state = "v-jumpsuit"
	item_color = "v-jumpsuit"
	can_adjust = 0

/obj/item/clothing/under/clownpiece
	name = "Clownpiece's Pierrot suit"
	desc = "A female-sized set of leggings and shirt with a pattern similar to the American flag, featuring a frilled collar."
	icon_state = "clownpiece"
	item_state = "clownpiece"
	item_color = "clownpiece"
	can_adjust = 0

/obj/item/clothing/under/cia
	name = "casual IAA outfit"
	desc = "Just looking at this makes you feel in charge."
	icon_state = "cia"
	item_state = "cia"
	item_color = "cia"
	can_adjust = 0

/obj/item/clothing/under/greaser
	name = "greaser outfit"
	desc = "The one that you want!"
	icon_state = "greaser_default"
	item_state = "greaser_default"
	can_adjust = 0

/obj/item/clothing/under/greaser/New()
	var/greaser_colour = "default"
	switch(rand(1,4))
		if(1)
			greaser_colour = "default"
		if(2)
			greaser_colour = "cult"
		if(3)
			greaser_colour = "spider"
		if(4)
			greaser_colour = "snakes"
			desc = "Tunnel Snakes Rule!"
	icon_state = "greaser_[greaser_colour]"
	item_state = "greaser_[greaser_colour]"
	item_color = "greaser_[greaser_colour]"
	can_adjust = 0

/obj/item/clothing/under/wintercasualwear
	name = "winter casualwear"
	desc = "Perfect for winter!"
	icon_state = "shizunewinter"
	item_state = "shizunewinter"
	item_color = "shizunewinter"
	can_adjust = 0


/obj/item/clothing/under/casualwear
	name = "spring casualwear"
	desc = "Perfect for spring!"
	icon_state = "shizunenormal"
	item_state = "shizunenormal"
	item_color = "shizunenormal"
	can_adjust = 0

/obj/item/clothing/under/keyholesweater
	name = "keyhole sweater"
	desc = "What is the point of this, anyway?"
	icon_state = "keyholesweater"
	item_state = "keyholesweater"
	item_color = "keyholesweater"
	can_adjust = 0

/obj/item/clothing/under/casualhoodie
	name = "casual hoodie"
	desc = "Pefect for lounging about in."
	icon_state = "hoodiejeans"
	item_state = "hoodiejeans"
	item_color = "hoodiejeans"
	can_adjust = 0


/obj/item/clothing/under/casualhoodie/skirt
	icon_state = "hoodieskirt"
	item_state = "hoodieskirt"
	item_color = "hoodieskirt"
	can_adjust = 0

/obj/item/clothing/under/mummy_rags
	name = "mummy rags"
	desc = "Ancient rags taken off from some mummy."
	icon_state = "mummy"
	item_state = "mummy"
	item_color = "mummy"
	can_adjust = 0
	has_sensor = 0

/obj/item/clothing/under/neorussian
	name = "neo-Russian uniform"
	desc = "Employs a special toshnit pattern, will render you invisible when you eat a potato on an empty stomach."
	icon_state = "nr_uniform"
	item_state = "nr_uniform"
	item_color = "nr_uniform"
	can_adjust = 0

/obj/item/clothing/under/rottensuit
	name = "rotten suit"
	desc = "This suit seems perfect for wearing underneath a disguise."
	icon_state = "rottensuit"
	item_state = "rottensuit"
	item_color = "rottensuit"
	can_adjust = 0
