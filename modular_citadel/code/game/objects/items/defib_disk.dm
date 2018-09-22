/obj/item/disk/medical
	name = "Defibrillator Upgrade Disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'modular_citadel/icons/obj/defib_disks.dmi'
	icon_state = "upgrade_disk"
	item_state = "heal_disk"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/disk/medical/defib_heal
	name = "Defibrillator Healing Disk"
	desc = "A disk alowing for grater amounts of healing"
	icon_state = "heal_disk"
	materials = list(MAT_METAL=16000, MAT_GLASS = 18000, MAT_GOLD = 6000, MAT_SILVER = 6000)

/obj/item/disk/medical/defib_shock
	name = "Defibrillator Anti-Shock Disk"
	desc = "A disk that helps agains shocking anyone, other then the intented target"
	icon_state = "zap_disk"
	materials = list(MAT_METAL=16000, MAT_GLASS = 18000, MAT_GOLD = 6000, MAT_SILVER = 6000)

/obj/item/disk/medical/defib_decay
	name = "Defibrillator Body-Decay Extender Disk"
	desc = "A disk that helps defibrillators revive the longer decayed"
	icon_state = "body_disk"
	materials = list(MAT_METAL=16000, MAT_GLASS = 18000, MAT_GOLD = 16000, MAT_SILVER = 6000, MAT_TITANIUM = 2000)

/obj/item/disk/medical/defib_speed
	name = "Defibrllator Pre-Primer Disk"
	desc = "A disk that cuts the time charg time in half for defibrillator use"
	icon_state = "fast_disk"
	materials = list(MAT_METAL=16000, MAT_GLASS = 8000, MAT_GOLD = 26000, MAT_SILVER = 26000)
