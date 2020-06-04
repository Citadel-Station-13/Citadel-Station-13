//This one's from bay12
/obj/machinery/vending/engineering
	name = "\improper Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	products = list(/obj/item/clothing/under/rank/engineering/chief_engineer = 4,
					/obj/item/clothing/under/rank/engineering/engineer = 4,
					/obj/item/clothing/shoes/sneakers/orange = 4,
					/obj/item/clothing/head/hardhat = 4,
					/obj/item/storage/belt/utility = 4,
					/obj/item/clothing/glasses/meson/engine = 4,
					/obj/item/clothing/gloves/color/yellow = 4,
					/obj/item/clothing/head/welding = 8,
					/obj/item/clothing/suit/fire = 4,
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 50)
	resistance_flags = FIRE_PROOF
	default_price = 100
	extra_price = 100
	payment_department = ACCOUNT_ENG
	cost_multiplier_per_dept = list(ACCOUNT_ENG = 0)
