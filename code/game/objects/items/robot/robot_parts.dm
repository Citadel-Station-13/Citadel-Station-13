

//The robot bodyparts have been moved to code/module/surgery/bodyparts/robot_bodyparts.dm


/obj/item/robot_suit
	name = "cyborg endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon =  'icons/obj/robot_parts.dmi'
	icon_state = "robo_suit"
	var/obj/item/bodypart/l_arm/robot/l_arm = null
	var/obj/item/bodypart/r_arm/robot/r_arm = null
	var/obj/item/bodypart/l_leg/robot/l_leg = null
	var/obj/item/bodypart/r_leg/robot/r_leg = null
	var/obj/item/bodypart/chest/robot/chest = null
	var/obj/item/bodypart/head/robot/head = null

	var/created_name = ""
	var/mob/living/silicon/ai/forced_ai
	var/locomotion = 1
	var/lawsync = 1
	var/aisync = 1
	var/panel_locked = 1

/obj/item/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_suit/proc/updateicon()
	src.cut_overlays()
	if(src.l_arm)
		src.add_overlay("l_arm+o")
	if(src.r_arm)
		src.add_overlay("r_arm+o")
	if(src.chest)
		src.add_overlay("chest+o")
	if(src.l_leg)
		src.add_overlay("l_leg+o")
	if(src.r_leg)
		src.add_overlay("r_leg+o")
	if(src.head)
		src.add_overlay("head+o")

/obj/item/robot_suit/proc/check_completion()
	if(src.l_arm && src.r_arm)
		if(src.l_leg && src.r_leg)
			if(src.chest && src.head)
				feedback_inc("cyborg_frames_built",1)
				return 1
	return 0

/obj/item/robot_suit/attackby(obj/item/W, mob/user, params)

	if(istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = W
		if(!l_arm && !r_arm && !l_leg && !r_leg && !chest && !head)
			if (M.use(1))
				var/obj/item/weapon/ed209_assembly/B = new /obj/item/weapon/ed209_assembly
				B.loc = get_turf(src)
				user << "<span class='notice'>You arm the robot frame.</span>"
				if (user.get_inactive_held_item()==src)
					user.unEquip(src)
					user.put_in_inactive_hand(B)
				qdel(src)
			else
				user << "<span class='warning'>You need one sheet of metal to start building ED-209!</span>"
				return
	else if(istype(W, /obj/item/bodypart/l_leg/robot))
		if(src.l_leg)
			return
		if(!user.unEquip(W))
			return
		W.forceMove(src)
		W.icon_state = initial(W.icon_state)
		W.cut_overlays()
		src.l_leg = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/r_leg/robot))
		if(src.r_leg)
			return
		if(!user.unEquip(W))
			return
		W.forceMove(src)
		W.icon_state = initial(W.icon_state)
		W.cut_overlays()
		src.r_leg = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/l_arm/robot))
		if(src.l_arm)
			return
		if(!user.unEquip(W))
			return
		W.forceMove(src)
		W.icon_state = initial(W.icon_state)
		W.cut_overlays()
		src.l_arm = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/r_arm/robot))
		if(src.r_arm)
			return
		if(!user.unEquip(W))
			return
		W.forceMove(src)
		W.icon_state = initial(W.icon_state)//in case it is a dismembered robotic limb
		W.cut_overlays()
		src.r_arm = W
		src.updateicon()

	else if(istype(W, /obj/item/bodypart/chest/robot))
		var/obj/item/bodypart/chest/robot/CH = W
		if(src.chest)
			return
		if(CH.wired && CH.cell)
			if(!user.unEquip(CH))
				return
			CH.forceMove(src)
			CH.icon_state = initial(CH.icon_state) //in case it is a dismembered robotic limb
			CH.cut_overlays()
			src.chest = CH
			src.updateicon()
		else if(!CH.wired)
			user << "<span class='warning'>You need to attach wires to it first!</span>"
		else
			user << "<span class='warning'>You need to attach a cell to it first!</span>"

	else if(istype(W, /obj/item/bodypart/head/robot))
		var/obj/item/bodypart/head/robot/HD = W
		for(var/X in HD.contents)
			if(istype(X, /obj/item/organ))
				user << "<span class='warning'>There are organs inside [HD]!</span>"
				return
		if(src.head)
			return
		if(HD.flash2 && HD.flash1)
			if(!user.unEquip(HD))
				return
			HD.loc = src
			HD.icon_state = initial(HD.icon_state)//in case it is a dismembered robotic limb
			HD.cut_overlays()
			src.head = HD
			src.updateicon()
		else
			user << "<span class='warning'>You need to attach a flash to it first!</span>"

	else if (istype(W, /obj/item/device/multitool))
		if(check_completion())
			Interact(user)
		else
			user << "<span class='warning'>The endoskeleton must be assembled before debugging can begin!</span>"

	else if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(check_completion())
			if(!isturf(loc))
				user << "<span class='warning'>You can't put the MMI in, the frame has to be standing on the ground to be perfectly precise!</span>"
				return
			if(!M.brainmob)
				user << "<span class='warning'>Sticking an empty MMI into the frame would sort of defeat the purpose!</span>"
				return

			var/mob/living/brain/BM = M.brainmob
			if(!BM.key || !BM.mind)
				user << "<span class='warning'>The mmi indicates that their mind is completely unresponsive; there's no point!</span>"
				return

			if(!BM.client) //braindead
				user << "<span class='warning'>The mmi indicates that their mind is currently inactive; it might change!</span>"
				return

			if(BM.stat == DEAD || (M.brain && M.brain.damaged_brain))
				user << "<span class='warning'>Sticking a dead brain into the frame would sort of defeat the purpose!</span>"
				return

			if(jobban_isbanned(BM, "Cyborg"))
				user << "<span class='warning'>This MMI does not seem to fit!</span>"
				return

			if(!user.unEquip(W))
				return

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(get_turf(loc))
			if(!O)
				return

			if(M.hacked || M.clockwork)
				aisync = 0
				lawsync = 0
				var/datum/ai_laws/L
				if(M.clockwork)
					L = new/datum/ai_laws/ratvar
				else
					L = new/datum/ai_laws/syndicate_override
				O.laws = L
				L.associate(O)

			O.invisibility = 0
			//Transfer debug settings to new mob
			O.custom_name = created_name
			O.locked = panel_locked
			if(!aisync)
				lawsync = 0
				O.connected_ai = null
			else
				O.notify_ai(1)
				if(forced_ai)
					O.connected_ai = forced_ai
			if(!lawsync)
				O.lawupdate = 0
				if(!M.hacked && !M.clockwork)
					O.make_laws()

			ticker.mode.remove_antag_for_borging(BM.mind)
			if(!M.clockwork)
				remove_servant_of_ratvar(BM, TRUE)
			BM.mind.transfer_to(O)

			if(O.mind && O.mind.special_role)
				O.mind.store_memory("As a cyborg, you must obey your silicon laws and master AI above all else. Your objectives will consider you to be dead.")
				O << "<span class='userdanger'>You have been robotized!</span>"
				O << "<span class='danger'>You must obey your silicon laws and master AI above all else. Your objectives will consider you to be dead.</span>"

			O.job = "Cyborg"

			O.cell = chest.cell
			chest.cell.loc = O
			chest.cell = null
			W.loc = O//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.
			if(O.mmi) //we delete the mmi created by robot/New()
				qdel(O.mmi)
			O.mmi = W //and give the real mmi to the borg.
			O.updatename()

			feedback_inc("cyborg_birth",1)

			src.loc = O
			O.robot_suit = src

			if(!locomotion)
				O.lockcharge = 1
				O.update_canmove()
				O << "<span class='warning'>Error: Servo motors unresponsive.</span>"

		else
			user << "<span class='warning'>The MMI must go in after everything else!</span>"

	else if(istype(W,/obj/item/weapon/pen))
		user << "<span class='warning'>You need to use a multitool to name [src]!</span>"
	else
		return ..()

/obj/item/robot_suit/proc/Interact(mob/user)
			var/t1 = text("Designation: <A href='?src=\ref[];Name=1'>[(created_name ? "[created_name]" : "Default Cyborg")]</a><br>\n",src)
			t1 += text("Master AI: <A href='?src=\ref[];Master=1'>[(forced_ai ? "[forced_ai.name]" : "Automatic")]</a><br><br>\n",src)

			t1 += text("LawSync Port: <A href='?src=\ref[];Law=1'>[(lawsync ? "Open" : "Closed")]</a><br>\n",src)
			t1 += text("AI Connection Port: <A href='?src=\ref[];AI=1'>[(aisync ? "Open" : "Closed")]</a><br>\n",src)
			t1 += text("Servo Motor Functions: <A href='?src=\ref[];Loco=1'>[(locomotion ? "Unlocked" : "Locked")]</a><br>\n",src)
			t1 += text("Panel Lock: <A href='?src=\ref[];Panel=1'>[(panel_locked ? "Engaged" : "Disengaged")]</a><br>\n",src)
			var/datum/browser/popup = new(user, "robotdebug", "Cyborg Boot Debug", 310, 220)
			popup.set_content(t1)
			popup.open()

/obj/item/robot_suit/Topic(href, href_list)
	if(usr.incapacitated() || !Adjacent(usr))
		return

	var/mob/living/living_user = usr
	var/obj/item/item_in_hand = living_user.get_active_held_item()
	if(!istype(item_in_hand, /obj/item/device/multitool))
		living_user << "<span class='warning'>You need a multitool!</span>"
		return

	if(href_list["Name"])
		var/new_name = reject_bad_name(input(usr, "Enter new designation. Set to blank to reset to default.", "Cyborg Debug", src.created_name),1)
		if(!in_range(src, usr) && src.loc != usr)
			return
		if(new_name)
			created_name = new_name
		else
			created_name = ""

	else if(href_list["Master"])
		forced_ai = select_active_ai(usr)
		if(!forced_ai)
			usr << "<span class='error'>No active AIs detected.</span>"

	else if(href_list["Law"])
		lawsync = !lawsync
	else if(href_list["AI"])
		aisync = !aisync
	else if(href_list["Loco"])
		locomotion = !locomotion
	else if(href_list["Panel"])
		panel_locked = !panel_locked

	add_fingerprint(usr)
	Interact(usr)

