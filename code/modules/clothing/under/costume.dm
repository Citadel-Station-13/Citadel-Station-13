/obj/item/clothing/under/costume/roman
	name = "\improper Roman armor"
	desc = "Ancient Roman armor. Made of metallic and leather straps."
	icon_state = "roman"
	item_state = "armor"
	can_adjust = FALSE
	strip_delay = 100
	resistance_flags = NONE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/costume/jabroni
	name = "Jabroni Outfit"
	desc = "The leather club is two sectors down."
	icon_state = "darkholme"
	item_state = "darkholme"
	can_adjust = FALSE

/obj/item/clothing/under/costume/owl
	name = "owl uniform"
	desc = "A soft brown jumpsuit made of synthetic feathers and strong conviction."
	icon_state = "owl"
	can_adjust = FALSE

/obj/item/clothing/under/costume/griffin
	name = "griffon uniform"
	desc = "A soft brown jumpsuit with a white feather collar made of synthetic feathers and a lust for mayhem."
	icon_state = "griffin"
	can_adjust = FALSE

/obj/item/clothing/under/costume/schoolgirl
	name = "blue schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state = "schoolgirl"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/costume/schoolgirl/red
	name = "red schoolgirl uniform"
	icon_state = "schoolgirlred"
	item_state = "schoolgirlred"

/obj/item/clothing/under/costume/schoolgirl/green
	name = "green schoolgirl uniform"
	icon_state = "schoolgirlgreen"
	item_state = "schoolgirlgreen"

/obj/item/clothing/under/costume/schoolgirl/orange
	name = "orange schoolgirl uniform"
	icon_state = "schoolgirlorange"
	item_state = "schoolgirlorange"

/obj/item/clothing/under/costume/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "pirate"
	can_adjust = FALSE

/obj/item/clothing/under/costume/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state = "soviet"
	can_adjust = FALSE

/obj/item/clothing/under/costume/redcoat
	name = "redcoat uniform"
	desc = "Looks old."
	icon_state = "redcoat"
	item_state = "redcoat"
	can_adjust = FALSE

/obj/item/clothing/under/costume/kilt
	name = "kilt"
	desc = "Includes shoes and plaid."
	icon_state = "kilt"
	item_state = "kilt"
	body_parts_covered = CHEST|GROIN|LEGS|FEET
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE

/obj/item/clothing/under/costume/kilt/highlander
	desc = "You're the only one worthy of this kilt."

/obj/item/clothing/under/costume/kilt/highlander/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HIGHLANDER)

/obj/item/clothing/under/costume/kilt/polychromic
	name = "polychromic kilt"
	desc = "It's not a skirt!"
	icon_state = "polykilt"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/costume/kilt/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, list("#FFFFFF", "#F08080"), 2)

/obj/item/clothing/under/costume/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state = "gladiator"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	resistance_flags = NONE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/costume/gladiator/ash_walker
	desc = "This gladiator uniform appears to be covered in ash and fairly dated."
	has_sensor = NO_SENSORS

/obj/item/clothing/under/costume/maid
	name = "maid costume"
	desc = "Maid in China."
	icon_state = "maid"
	item_state = "maid"
	body_parts_covered = CHEST|GROIN
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/costume/maid/Initialize()
	. = ..()
	var/obj/item/clothing/accessory/maidapron/A = new (src)
	attach_accessory(A)

/obj/item/clothing/under/costume/singer
	desc = "Just looking at this makes you want to sing."
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON
	body_parts_covered = CHEST|GROIN|ARMS
	alternate_worn_layer = ABOVE_SHOES_LAYER
	can_adjust = FALSE

/obj/item/clothing/under/costume/singer/yellow
	name = "yellow performer's outfit"
	icon_state = "ysing"
	item_state = "ysing"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE

/obj/item/clothing/under/costume/singer/blue
	name = "blue performer's outfit"
	icon_state = "bsing"
	item_state = "bsing"
	alternate_worn_layer = ABOVE_SHOES_LAYER
	fitted = FEMALE_UNIFORM_TOP

/obj/item/clothing/under/costume/geisha
	name = "geisha suit"
	desc = "Cute space ninja senpai not included."
	icon_state = "geisha"
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/costume/villain
	name = "villain suit"
	desc = "A change of wardrobe is necessary if you ever want to catch a real superhero."
	icon_state = "villain"
	can_adjust = FALSE

/obj/item/clothing/under/costume/sailor
	name = "sailor suit"
	desc = "Skipper's in the wardroom drinkin gin'."
	icon_state = "sailor"
	item_state = "b_suit"
	can_adjust = FALSE

/obj/item/clothing/under/costume/russian_officer
	name = "\improper Russian officer's uniform"
	desc = "The latest in fashionable russian outfits."
	icon_state = "hostanclothes"
	item_state = "hostanclothes"

/obj/item/clothing/under/costume/mummy
	name = "mummy wrapping"
	desc = "Return the slab or suffer my stale references."
	icon_state = "mummy"
	item_state = "mummy"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	resistance_flags = NONE

/obj/item/clothing/under/costume/scarecrow
	name = "scarecrow clothes"
	desc = "Perfect camouflage for hiding in botany."
	icon_state = "scarecrow"
	item_state = "scarecrow"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	resistance_flags = NONE

/obj/item/clothing/under/costume/draculass
	name = "draculass coat"
	desc = "A dress inspired by the ancient \"Victorian\" era."
	icon_state = "draculass"
	item_state = "draculass"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/costume/drfreeze
	name = "doctor freeze's jumpsuit"
	desc = "A modified scientist jumpsuit to look extra cool."
	icon_state = "drfreeze"
	item_state = "drfreeze"
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/costume/lobster
	name = "foam lobster suit"
	desc = "Who beheaded the college mascot?"
	icon_state = "lobster"
	item_state = "lobster"
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/costume/gondola
	name = "gondola hide suit"
	desc = "Now you're cooking."
	icon_state = "gondola"
	item_state = "lb_suit"
	can_adjust = FALSE

/obj/item/clothing/under/costume/skeleton
	name = "skeleton jumpsuit"
	desc = "A black jumpsuit with a white bone pattern printed on it. Spooky!"
	icon_state = "skeleton"
	item_state = "skeleton"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	resistance_flags = NONE

//Christmas Clothes
/obj/item/clothing/under/costume/christmas
	name = "red christmas suit"
	desc = "A simple red christmas suit that looks close to Santa's!"
	icon_state = "christmasmaler"
	item_state = "christmasmaler"
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/costume/christmas/green
	name = "green christmas suit"
	desc = "A simple green christmas suit. Smells minty!"
	icon_state = "christmasmaleg"
	item_state = "christmasmaleg"

/obj/item/clothing/under/costume/christmas/croptop
	name = "red croptop christmas suit"
	desc = "A simple red christmas suit that doesn't quite looks like Mrs Claus'."
	icon_state = "christmasfemaler"
	item_state = "christmasfemaler"
	body_parts_covered = CHEST|GROIN
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON|USE_TAUR_CLIP_MASK

/obj/item/clothing/under/costume/christmas/croptop/green
	name = "green croptop christmas suit"
	desc = "A simple green christmas suit. Smells minty!"
	icon_state = "christmasfemaleg"
	item_state = "christmasfemaleg"

// Lunar Clothes
/obj/item/clothing/under/costume/qipao
	name = "Black Qipao"
	desc = "A Qipao, traditionally worn in ancient Earth China by women during social events and lunar new years. This one is black."
	icon_state = "qipao"
	item_state = "qipao"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_NO_ANTHRO_ICON

/obj/item/clothing/under/costume/qipao/white
	name = "White Qipao"
	desc = "A Qipao, traditionally worn in ancient Earth China by women during social events and lunar new years. This one is white."
	icon_state = "qipao_white"
	item_state = "qipao_white"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE

/obj/item/clothing/under/costume/qipao/red
	name = "Red Qipao"
	desc = "A Qipao, traditionally worn in ancient Earth China by women during social events and lunar new years. This one is red."
	icon_state = "qipao_red"
	item_state = "qipao_red"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE

/obj/item/clothing/under/costume/cheongsam
	name = "Black Cheongsam"
	desc = "A Cheongsam, traditionally worn in ancient Earth China by men during social events and lunar new years. This one is black."
	icon_state = "cheong"
	item_state = "cheong"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	mutantrace_variation = USE_TAUR_CLIP_MASK

/obj/item/clothing/under/costume/cheongsam/white
	name = "White Cheongsam"
	desc = "A Cheongsam, traditionally worn in ancient Earth China by men during social events and lunar new years. This one is white."
	icon_state = "cheongw"
	item_state = "cheongw"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	mutantrace_variation = NONE

/obj/item/clothing/under/costume/cheongsam/red
	name = "Red Cheongsam"
	desc = "A Cheongsam, traditionally worn in ancient Earth China by men during social events and lunar new years. This one is red.."
	icon_state = "cheongr"
	item_state = "cheongr"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE

/obj/item/clothing/under/costume/cloud
	name = "cloud"
	desc = "cloud"
	icon_state = "cloud"
	can_adjust = FALSE

/obj/item/clothing/under/costume/kimono
	name = "Kimono"
	desc = "A traditional piece of clothing from japan"
	icon_state = "kimono"
	item_state = "kimono"

/obj/item/clothing/under/costume/kimono/black
	name = "Black Kimono"
	icon_state = "kimono_a"
	item_state = "kimono_a"

/obj/item/clothing/under/costume/kimono/kamishimo
	name = "Kamishimo"
	icon_state = "kamishimo"
	item_state = "kamishimo"

/obj/item/clothing/under/costume/kimono/fancy
	name = "Fancy Kimono"
	icon_state = "fancy_kimono"
	item_state = "fancy_kimono"

/obj/item/clothing/under/costume/kimono/sakura
	name = "Sakura Kimono'"
	icon_state = "sakura_kimono"
	item_state = "sakura_kimono"

/obj/item/clothing/under/costume/swagoutfit
	name = "Swag outfit"
	desc = "Why don't you go secure some bitches?"
	icon_state = "SwagOutfit"
	item_state = "SwagOutfit"
	can_adjust = FALSE
