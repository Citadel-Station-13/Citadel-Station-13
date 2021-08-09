/obj/item/clothing/under/pants
	gender = PLURAL
	body_parts_covered = GROIN|LEGS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	mutantrace_variation = STYLE_DIGITIGRADE //how do they show up on taurs otherwise?

/obj/item/clothing/under/pants/classicjeans
	name = "classic jeans"
	desc = "You feel cooler already."
	icon_state = "jeansclassic"

/obj/item/clothing/under/pants/mustangjeans
	name = "Must Hang jeans"
	desc = "Made in the finest space jeans factory this side of Alpha Centauri."
	icon_state = "jeansmustang"
	custom_price = PRICE_ABOVE_NORMAL

/obj/item/clothing/under/pants/blackjeans
	name = "black jeans"
	desc = "Only for those who can pull it off."
	icon_state = "jeansblack"

/obj/item/clothing/under/pants/youngfolksjeans
	name = "Young Folks jeans"
	desc = "For those tired of boring old jeans. Relive the passion of your youth!"
	icon_state = "jeansyoungfolks"

/obj/item/clothing/under/pants/white
	name = "white pants"
	desc = "Plain white pants. Boring."
	icon_state = "whitepants"

/obj/item/clothing/under/pants/red
	name = "red pants"
	desc = "Bright red pants. Overflowing with personality."
	icon_state = "redpants"

/obj/item/clothing/under/pants/black
	name = "black pants"
	desc = "These pants are dark, like your soul."
	icon_state = "blackpants"

/obj/item/clothing/under/pants/tan
	name = "tan pants"
	desc = "Some tan pants. You look like a white collar worker with these on."
	icon_state = "tanpants"

/obj/item/clothing/under/pants/polypants/polychromic
	name = "polychromic pants"
	desc = "Some stylish pair of pants made from polychrome."
	icon_state = "polypants"
	item_state = "polypants"
	var/list/poly_colors = list("#75634F", "#3D3D3D", "#575757")

/obj/item/clothing/under/pants/polypants/polychromic/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/polychromic, poly_colors, 3)

/obj/item/clothing/under/pants/track
	name = "track pants"
	desc = "A pair of track pants, for the athletic."
	icon_state = "trackpants"

/obj/item/clothing/under/pants/jeans
	name = "jeans"
	desc = "A nondescript pair of tough blue jeans."
	icon_state = "jeans"

/obj/item/clothing/under/pants/khaki
	name = "khaki pants"
	desc = "A pair of dust beige khaki pants."
	icon_state = "khaki"

/obj/item/clothing/under/pants/camo
	name = "camo pants"
	desc = "A pair of woodland camouflage pants. Probably not the best choice for a space station."
	icon_state = "camopants"

/obj/item/clothing/under/pants/jeanripped
	name = "ripped jeans"
	desc = "If you're wearing this you're poor or a rebel"
	icon_state = "jean_ripped"

/obj/item/clothing/under/pants/jeanshort
	name = "jean shorts"
	desc = "These are really just jeans cut in half"
	icon_state = "jean_shorts"

/obj/item/clothing/under/pants/denimskirt
	name = "denim skirt"
	desc = "These are really just a jean leg hole cut from a pair"
	icon_state = "denim_skirt"

/obj/item/clothing/under/pants/chaps
	name = "black chaps"
	body_parts_covered = LEGS
	desc = "Yeehaw"
	icon_state = "chaps"

/obj/item/clothing/under/pants/yoga
	name = "yoga pants"
	desc = "Comfy!"
	icon_state = "yoga_pants"
