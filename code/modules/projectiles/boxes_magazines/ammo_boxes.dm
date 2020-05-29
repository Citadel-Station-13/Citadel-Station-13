/obj/item/ammo_box/a357
	name = "speed loader (.357)"
	desc = "Designed to quickly reload revolvers."
	icon_state = "357"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = "357"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_box/a357/ap
	name = "speed loader (.357 AP)"
	ammo_type = /obj/item/ammo_casing/a357/ap

/obj/item/ammo_box/c38
	name = "speed loader (.38 rubber)"
	desc = "Designed to quickly reload revolvers."
	icon_state = "38"
	caliber = "38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1
	custom_materials = list(/datum/material/iron = 20000)

/obj/item/ammo_box/c38/lethal
	name = "speed loader (.38)"
	ammo_type = /obj/item/ammo_casing/c38/lethal

/obj/item/ammo_box/c38/trac
	name = "speed loader (.38 TRAC)"
	desc = "Designed to quickly reload revolvers. TRAC bullets embed a tracking implant within the target's body."
	ammo_type = /obj/item/ammo_casing/c38/trac

/obj/item/ammo_box/c38/hotshot
	name = "speed loader (.38 Hot Shot)"
	desc = "Designed to quickly reload revolvers. Hot Shot bullets contain an incendiary payload."
	ammo_type = /obj/item/ammo_casing/c38/hotshot

/obj/item/ammo_box/c38/iceblox
	name = "speed loader (.38 Iceblox)"
	desc = "Designed to quickly reload revolvers. Iceblox bullets contain a cryogenic payload."
	ammo_type = /obj/item/ammo_casing/c38/iceblox

/obj/item/ammo_box/c32mm
	name = "ammo box (.32 acp)"
	desc = "Lethal .32 acp bullets, there's forty in the box."
	ammo_type = /obj/item/ammo_casing/c32acp
	max_ammo = 40

/obj/item/ammo_box/r32mm
	name = "ammo box (rubber .32 acp)"
	desc = "Non-lethal .32 acp bullets, there's forty in the box."
	ammo_type = /obj/item/ammo_casing/r32acp
	max_ammo = 40

/obj/item/ammo_box/c9mm
	name = "ammo box (9mm)"
	icon_state = "9mmbox"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_box/c10mm
	name = "ammo box (10mm)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 20

/obj/item/ammo_box/c10mm/fire
	name = "ammo box (10mm Incendiary)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm/fire
	max_ammo = 20

/obj/item/ammo_box/c10mm/hp
	name = "ammo box (10mm Hollow Point)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm/hp
	max_ammo = 20

/obj/item/ammo_box/c10mm/ap
	name = "ammo box (10mm Armour Piercing)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm/ap
	max_ammo = 20

/obj/item/ammo_box/c10mm/soporific
	name = "ammo box (10mm Soporific)"
	ammo_type = /obj/item/ammo_casing/c10mm/soporific
	max_ammo = 20

/obj/item/ammo_box/c45
	name = "ammo box (.45)"
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 20

/obj/item/ammo_box/a40mm
	name = "ammo box (40mm grenades)"
	icon_state = "40mm"
	ammo_type = /obj/item/ammo_casing/a40mm
	max_ammo = 4
	multiple_sprites = 1

/obj/item/ammo_box/a762
	name = "stripper clip (7.62mm)"
	desc = "A stripper clip."
	icon_state = "762"
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_box/n762
	name = "ammo box (7.62x38mmR)"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/n762
	max_ammo = 14

/obj/item/ammo_box/foambox
	name = "ammo box (Foam Darts)"
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foambox"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	max_ammo = 40
	custom_materials = list(/datum/material/iron = 500)

/obj/item/ammo_box/foambox/mag
	name = "ammo box (Magnetic Foam Darts)"
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foambox"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag
	max_ammo = 42

/obj/item/ammo_box/foambox/riot
	icon_state = "foambox_riot"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot
	custom_materials = list(/datum/material/iron = 50000)

//Shotgun clips
/obj/item/ammo_box/shotgun
	name = "stripper clip (shotgun shells)"
	desc = "A stripper clip, designed to help with loading a shotgun slightly faster."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "shotgunclip"
	caliber = "shotgun" // slapped in to allow shell mix n match
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 4
	var/pixeloffsetx = 4
	start_empty = TRUE

/obj/item/ammo_box/shotgun/update_overlays()
	. = ..()
	if(stored_ammo.len)
		var/offset = -4
		for(var/A in stored_ammo)
			var/obj/item/ammo_casing/shotgun/C = A
			offset += pixeloffsetx
			var/mutable_appearance/shell_overlay = mutable_appearance(icon, "[initial(C.icon_state)]-clip")
			shell_overlay.pixel_x += offset
			shell_overlay.appearance_flags = RESET_COLOR
			. += shell_overlay

/obj/item/ammo_box/shotgun/loaded
	start_empty = FALSE

/obj/item/ammo_box/shotgun/loaded/rubbershot
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot

/obj/item/ammo_box/shotgun/loaded/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/shotgun/loaded/beanbag
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_box/shotgun/loaded/stunslug
	ammo_type = /obj/item/ammo_casing/shotgun/stunslug

/obj/item/ammo_box/shotgun/loaded/techshell
	ammo_type = /obj/item/ammo_casing/shotgun/techshell

/obj/item/ammo_box/shotgun/loaded/incendiary
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary

/obj/item/ammo_box/shotgun/loaded/dart
	ammo_type = /obj/item/ammo_casing/shotgun/dart
