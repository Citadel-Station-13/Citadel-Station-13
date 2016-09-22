//Salvaging hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/salvaging
	name = "salvaging hardsuit helmet"
	desc = "A hardsuit helmet worn by salvaging teams during EVA. Features three viewing ports, a mounted flashlight, adaptive padding, and UV shielding. Also, has radiation and explosion shielding."
	icon_state = "hardsuit0-engineering"
	item_state = "salv_helm"
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 80, bio = 100, rad = 40)
	item_color = "salvaging"

/obj/item/clothing/suit/space/hardsuit/salvaging
	name = "salvaging hardsuit"
	desc = "A hardsuit worn by salvaging teams during EVA. Features a robust, orange chassis, stylish leather, and comfortable gloves. Also, has radiation and explosion shielding."
	icon_state = "hardsuit-salvaging"
	item_state = "salv_hardsuit"
	armor = list(melee = 5, bullet = 5, laser = 5, energy = 5, bomb = 80, bio = 100, rad = 40)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/salvaging

/obj/machinery/suit_storage_unit/salvaging
	suit_type = /obj/item/clothing/suit/space/hardsuit/salvaging
	mask_type = /obj/item/clothing/mask/breath
	storage_type = /obj/item/clothing/shoes/magboots