obj/vore_preferences
	// 0 = current vore mode, 1 = inside view, 2 = vore abilities, 3 = banned vores
	var/current_tab = 0
	var/tab_mod = 0

	var/mob/living/target

	var/loop //might as well make this a global list later instead

/obj/vore_preferences/New(client/C)
	//Get preferences
	loop=src
	if(!target) return
	for(var/obj/vore_preferences/VP in world)
		if(VP!=src&&VP.target==target)
			if(target.ckey=="jayehh" && "poojawa" && "nebulacallisto" && "leonleonardo" && "brimcon" && "cyrema" && "mrsebbi" && "subtumaka")
				target << "<B>DEBUG:</B> Deleted an old vore panel with a tab of [VP.current_tab]."
					//VP.loop=0
	return

/obj/vore_preferences

	proc/GetOrgan(var/organ)
		switch(organ)
			if("cock")
				return target.vore_cock_datum
			if("balls")
				return target.vore_balls_datum
			if("womb")
				return target.vore_womb_datum
			if("breast")
				return target.vore_breast_datum
			if("tail")
				return target.vore_tail_datum
			if("insole")
				return target.vore_insole_datum
			if("insuit")
				return target.vore_insuit_datum
			else
				return target.vore_stomach_datum

	proc/GenerateMethodSwitcher(var/method,var/alt_name)
		var/dat=""
		dat += "<a href='?src=\ref[src];preference=current;method=[method]' [target.vore_current_method == method ? "class='linkOn'" : ""]>[alt_name]</a> "
		return dat

	proc/GenerateAbilitySwitcher(var/method,var/alt_name)
		var/dat=""
		dat += "<B>[alt_name]:</B> "
		if(method!=VORE_METHOD_ORAL)
			dat += AbilityHelper(method,VORE_SIZEDIFF_DISABLED,"Disable")
		dat += AbilityHelper(method,VORE_SIZEDIFF_TINY,"Tiny")
		dat += AbilityHelper(method,VORE_SIZEDIFF_SMALLER,"Smaller")
		dat += AbilityHelper(method,VORE_SIZEDIFF_SAMESIZE,"Same-Size")
		dat += AbilityHelper(method,VORE_SIZEDIFF_DOUBLE,"Bigger")
		if(target.vore_ability[num2text(VORE_METHOD_ORAL)]==VORE_SIZEDIFF_ANY)
			dat += AbilityHelper(method,VORE_SIZEDIFF_ANY,"Any")
		dat += "<BR>"
		return dat

	proc/AbilityHelper(var/method,var/size,var/alt_name)
		var/dat=""
		if(method==VORE_METHOD_ORAL||size<=target.vore_ability[num2text(VORE_METHOD_ORAL)])
			dat += "<a href='?src=\ref[src];preference=ability;method=[method];size=[size]' [target.vore_ability[num2text(method)]==size ? "class='linkOn'" : ""]>[alt_name]</a> "
		return dat

	proc/GenerateBanSwitcher(var/method,var/alt_name)
		var/dat=""
		dat += "[target.vore_banned_methods&method ? "<B>" : ""]<a href='?src=\ref[src];preference=ban;method=[method]'>[alt_name]</a>[target.vore_banned_methods&method ? "</B>" : ""] "
		return dat

	proc/GenerateExBanSwitcher(var/method,var/alt_name)
		var/dat=""
		dat += "[target.vore_extra_bans&method ? "<B>" : ""]<a href='?src=\ref[src];preference=exban;method=[method]'>[alt_name]</a>[target.vore_extra_bans&method ? "</B>" : ""] "
		return dat

	proc/GenerateDigestionSwitcher(var/organ)
		var/dat=""
		var/datum/vore_organ/VD=GetOrgan(organ)
		var/datum/vore_organ/temp_chk=GetOrgan("stomach")
		dat += "<B>Digestion: </B>"
		if(temp_chk.factor_offset<0)dat += "<a href='?src=\ref[src];preference=digest_h;organ=[organ]' [VD.healing_factor > 0 ? "class='linkOn'" : ""]>Heal</a> "
		if(temp_chk.factor_offset<1)dat += "<a href='?src=\ref[src];preference=digest;speed=[VORE_DIGESTION_SPEED_NONE];organ=[organ]' [(VD.digestion_factor+VD.healing_factor) == VORE_DIGESTION_SPEED_NONE ? "class='linkOn'" : ""]>None</a> "
		dat += "<a href='?src=\ref[src];preference=digest;speed=[VORE_DIGESTION_SPEED_SLOW];organ=[organ]' [VD.digestion_factor == VORE_DIGESTION_SPEED_SLOW ? "class='linkOn'" : ""]>Slow</a> "
		if(temp_chk.factor_offset>-1)dat += "<a href='?src=\ref[src];preference=digest;speed=[VORE_DIGESTION_SPEED_FAST];organ=[organ]' [VD.digestion_factor == VORE_DIGESTION_SPEED_FAST ? "class='linkOn'" : ""]>Normal</a> "
		if(temp_chk.factor_offset>0)dat += "<a href='?src=\ref[src];preference=digest;speed=[VORE_DIGESTION_SPEED_ABNORMAL];organ=[organ]' [VD.digestion_factor == VORE_DIGESTION_SPEED_ABNORMAL ? "class='linkOn'" : ""]>Fast</a> "
		dat += "<BR>"
		return dat

	proc/GenerateRelease(var/organ)
		var/dat=""
		var/datum/vore_organ/VD=GetOrgan(organ)
		dat += "You will <a href='?src=\ref[src];preference=trap;organ=[organ];keep=[VD.escape ? "0" : "1"]'>[VD.escape ? "" : "not "]let</a> people escape. "
		dat += "<a href='?src=\ref[src];preference=release;organ=[organ]'>Release</a>"
		if(organ=="stomach")
			dat += "<a href='?src=\ref[src];preference=release;organ=[organ];extra_info=[VORE_EXTRA_FULLTOUR]'>Fulltour</a>"
		if(organ=="cock"||organ=="breast"||organ=="womb")
			dat += "<a href='?src=\ref[src];preference=tab;tab=7;mod=[organ]'>Into</a>"
		dat+="<BR>"
		return dat


	proc/ShowChoices(mob/user)
		loop=src
		if(!user || !user.client)	return

		if(!target) return //the =="kingpygmy" was alerting me to this.

		var/dat = "<center>"

		if(istype(target,/datum/preferences))
			if(current_tab<2||current_tab>3)
				if(current_tab!=8)
					current_tab=2
			dat += "<a href='?src=\ref[src];preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>\[Ability\]</a> "
			dat += "<a href='?src=\ref[src];preference=tab;tab=3' [current_tab == 3 ? "class='linkOn'" : ""]>\[Bans\]</a> "
			dat += "<a href='?src=\ref[src];preference=tab;tab=8' [current_tab == 8 ? "class='linkOn'" : ""]>\[Other\]</a>"
		else
			dat += "<a href='?src=\ref[src];preference=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>\[Manage\]</a> "
			//if(target.get_last_organ_in())
			dat += "<a href='?src=\ref[src];preference=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>\[Inside\]</a> "
			dat += "<a href='?src=\ref[src];preference=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>\[Ability\]</a> "
			dat += "<a href='?src=\ref[src];preference=tab;tab=3' [current_tab == 3 ? "class='linkOn'" : ""]>\[Bans\]</a> "
			dat += "<a href='?src=\ref[src];preference=tab;tab=8' [current_tab == 8 ? "class='linkOn'" : ""]>\[Other\]</a>"
			if(target.ckey=="jayehh")
				dat += " <a href='?src=\ref[src];preference=tab;tab=4' [current_tab == 4 ? "class='linkOn'" : ""]>\[Debug\]</a>"

		dat += "</center>"


		switch(current_tab)
			if (0) //Manage Organs

				dat += "<BR>"
				dat += " <h2>Current Vore Method</h2>"
				dat += GenerateMethodSwitcher(VORE_METHOD_ORAL,"Oral")
				dat += GenerateMethodSwitcher(VORE_METHOD_ANAL,"Anal")
				dat += GenerateMethodSwitcher(VORE_METHOD_COCK,"Cock")
				dat += GenerateMethodSwitcher(VORE_METHOD_UNBIRTH,"Unbirth")
				dat += GenerateMethodSwitcher(VORE_METHOD_BREAST,"Breast")
				dat += GenerateMethodSwitcher(VORE_METHOD_TAIL,"Tail")
				dat += "<BR>"
				dat += GenerateMethodSwitcher(VORE_METHOD_INSOLE,"Insole")
				dat += GenerateMethodSwitcher(VORE_METHOD_INSUIT,"In Suit")
				dat += "(These two aren't vore)"
				dat += "<BR>"
				dat += "On clicking self, <a href='?src=\ref[src];preference=click;mode=[target.vore_mode==VORE_MODE_EAT ? VORE_MODE_FEED : VORE_MODE_EAT]'>[target.vore_mode==VORE_MODE_EAT ? "eat" : "feed"]</a> the grabbed person"
				dat += "<a href='?src=\ref[src];preference=headfirst;mode=[!target.vore_head_first]'>[target.vore_head_first ? "head-first" : "feet-first"]</a>."
				if(!target.vore_head_first)
					dat+="<br>(Foot-first not currently not finsihed. Only works when you are the one eating prey.)"

				dat += "<BR><BR>"
				dat += "<B>Remains:</B>"
				dat += " <a href='?src=\ref[src];preference=set_remains;mode=[VORE_REMAINS_NONE]'[target.vore_remains_mode == VORE_REMAINS_NONE ? "class='linkOn'" : ""]>None</a>"
				dat += " <a href='?src=\ref[src];preference=set_remains;mode=[VORE_REMAINS_GENERIC]'[target.vore_remains_mode == VORE_REMAINS_GENERIC ? "class='linkOn'" : ""]>Generic</a>"
				dat += " <a href='?src=\ref[src];preference=set_remains;mode=[VORE_REMAINS_NAMED]'[target.vore_remains_mode == VORE_REMAINS_NAMED ? "class='linkOn'" : ""]>Named</a>"

				dat += " <h2>Stomach</h2>"
				dat += GenerateDigestionSwitcher("stomach")
				dat += GenerateRelease("stomach")

				if(target.has_vagina())
					dat += " <h2>Womb</h2>"
					dat += GenerateDigestionSwitcher("womb")
					dat += "<B>Transformation: </B><a href='?src=\ref[src];preference=tab;tab=6;mod=womb'>Set</a>[target.vore_womb_datum.tf_factor ? "(On)" : ""]<BR>"
					dat += GenerateRelease("womb")

				if(target.has_cock())
					dat += " <h2>Cock</h2>"
					dat += GenerateDigestionSwitcher("cock")
					dat += "<B>Balls </B>"
					dat += GenerateDigestionSwitcher("balls")
					dat += "<B>Cock Transformation: </B><a href='?src=\ref[src];preference=tab;tab=6;mod=cock'>Set</a>[target.vore_cock_datum.tf_factor ? "(On)" : ""]<BR>"
					dat += "<B>Balls Transformation: </B><a href='?src=\ref[src];preference=tab;tab=6;mod=balls'>Set</a>[target.vore_balls_datum.tf_factor ? "(On)" : ""]<BR>"
					dat += "<B>Move to balls: </B>"
					dat += "<a href='?src=\ref[src];preference=transfer;speed=[VORE_TRANSFER_SPEED_NONE];organ=cock;dest=balls' [target.vore_cock_datum.transfer_factor == VORE_TRANSFER_SPEED_NONE ? "class='linkOn'" : ""]>No</a> "
					dat += "<a href='?src=\ref[src];preference=transfer;speed=[VORE_TRANSFER_SPEED_FAST];organ=cock;dest=balls' [target.vore_cock_datum.transfer_factor == VORE_TRANSFER_SPEED_FAST ? "class='linkOn'" : ""]>Yes</a> "
					dat += "<BR>"
					dat += GenerateRelease("cock")

				if(target.has_boobs())
					dat += " <h2>Breast</h2>"
					dat += GenerateDigestionSwitcher("breast")
					dat += GenerateRelease("breast")

				if(target.kpcode_mob_has_tail())
					dat += " <h2>Tail</h2>"
					dat += GenerateDigestionSwitcher("tail")
					dat += "<B>Move to stomach: </B>"
					dat += "<a href='?src=\ref[src];preference=transfer;speed=[VORE_TRANSFER_SPEED_NONE];organ=tail;dest=stomach' [target.vore_tail_datum.transfer_factor == VORE_TRANSFER_SPEED_NONE ? "class='linkOn'" : ""]>No</a> "
					dat += "<a href='?src=\ref[src];preference=transfer;speed=[VORE_TRANSFER_SPEED_SLOW];organ=tail;dest=stomach' [target.vore_tail_datum.transfer_factor == VORE_TRANSFER_SPEED_SLOW ? "class='linkOn'" : ""]>Yes</a> "
					dat += "<BR>"
					dat += GenerateRelease("tail")
				else if(target.vore_tail_datum.contents.len)
					target.vore_tail_datum.release()

				dat += " <h2>Inside your Suit</h2>"
				dat += "<a href='?src=\ref[src];preference=release;organ=insuit'>Unzip your suit</a>"

			if (1) //Inside View

				dat += "<BR>"
				var/datum/vore_organ/container=target.get_last_organ_in()
				if(!container)
					dat += "You are not currently inside someone."
				else if(istype(container,/datum/vore_organ/stomach))
					dat += "You are in [container.owner]'s stomach. It is soft, wet, and moving.The walls gently squeeze around you from all sides as their heartbeat and breathing echo in your ears. The gurgles of their digestive system rumble all around you."
					if(container.digestion_factor==VORE_DIGESTION_SPEED_SLOW)
						dat += "You feel a slight, burning tingle on your skin.The walls work at kneading over your form to soften you up. You're being digested! "
					else if(container.digestion_factor)
						dat += "Your body is quickly digesting and the air is getting more and more thin after that belch! You won't last long! "
					if(container.has_people()>1)
						dat += "You can feel [container.has_people()-1] other [container.has_people()>2 ? "people" : "person"] in the stomach. "
				else if(istype(container,/datum/vore_organ/cock)||istype(container,/datum/vore_organ/balls))
					dat += "You are in [container.owner]'s [istype(container,/datum/vore_organ/cock) ? "cock" : "balls"]. "
					if(container.digestion_factor==VORE_DIGESTION_SPEED_SLOW)
						dat += "You feel a slight, burning tingle on your skin. You're being melted! "
					else if(container.digestion_factor)
						dat += "Your body is quickly turning into [container.owner] [pick("spooge","cum","semen","batter","seed")] and the air is scarce. You won't last long! "
					if(container.has_people()>1)
						dat += "You can feel [container.has_people()-1] other [container.has_people()>2 ? "people" : "person"] in your cum-drenched and musky prison. Their forms press up close to your own. "
					if(container.digestion_count)
						dat += "It seems the cum was once a person or thing... or maybe even multiple? "
				else if(istype(container,/datum/vore_organ/womb))
					dat += "You are in [container.owner]'s womb. The smooth walls press over you, suspending you in a feeling of almost zero gravity. Their heartbeat and breathing is quieter here, and the gurgles of their digestive system join the internal song."
					if(container.digestion_factor==VORE_DIGESTION_SPEED_SLOW||container.tf_factor)
						dat += "You feel a slight, odd tingle on your skin. The warmth should make you doze off soon enough. "
					else if(container.digestion_factor)
						dat += "Your body is quickly digesting within [container.owner]'s womb, the air is thin and you're already having trouble staying awake  "
					if(container.has_people()>1)
						dat += "You can feel [container.has_people()-1] other [container.has_people()>2 ? "people" : "person"] in your fleshy prison. "
				else if(istype(container,/datum/vore_organ/breast))
					dat += "You are in [container.owner]'s breast. "
					if(container.digestion_factor)
						dat += "Your body is getting rather milky, you're being melted inside these breasts! "
					if(container.has_people()>1)
						dat += "You can feel [container.has_people()-1] other [container.has_people()>2 ? "people" : "person"] in your jiggly prison. "
				else if(istype(container,/datum/vore_organ/tail))
					dat += "You are in [container.owner]'s tail. Each shift of their hips causes your world to move about ever so much. "
					if(container.digestion_factor==VORE_DIGESTION_SPEED_SLOW)
						dat += "You feel a slight, burning tingle on your skin. The swaying is luring you to just close your eyes and give in. "
					else if(container.digestion_factor)
						dat += "Your body is quickly digesting as a lump inside [container.owner]'s tail. The air is thin and you won't last much longer! "
					if(container.has_people()>1)
						dat += "You can feel [container.has_people()-1] other [container.has_people()>2 ? "people" : "person"] in your fleshy prison. "
					if(container.transfer_factor)
						dat += "The tail's muscles are sliding you somewhere deeper inside of your predator, you can already feel parts of you being squeezed into the wrinkled folds of that stomach."
				else if(istype(container,/datum/vore_organ/insole))
					dat += "You are pressed against [container.owner]'s foot. Each step they take presses over your form. "
				else if(istype(container,/datum/vore_organ/insuit))
					dat += "You are pressed against [container.owner]'s form. It is very stuffy, and their scent is all around you. "
				else
					dat += "You're not sure where you are. "
				dat += "<BR>"
				dat += "<BR>"
				var/datum/vore_organ/orgch
				orgch=GetOrgan("stomach")
				if(orgch.has_people())
					dat += "Your [orgch.digestion_factor ? "gurgly " : ""]stomach [pick("bulges","swells","is distended")] with [orgch.has_people()] [orgch.has_people()>1 ? "people" : "person"]. "
					dat += "<BR>"
				orgch=GetOrgan("womb")
				if(orgch.has_people())
					dat += "You have [orgch.digestion_factor ? "kneading " : ""] womb [pick("bulges","swells","is distended")] with [orgch.has_people()] [orgch.has_people()>1 ? "people" : "person"] withing your lower belly. Their weight is liable to be a pleasent addition to your hips. "
					dat += "<BR>"
				orgch=GetOrgan("cock")
				if(orgch.has_people()||orgch.digestion_count)
					dat += "Your cock swells with [orgch.has_people()+orgch.digestion_count] [orgch.has_people()+orgch.digestion_count>1 ? "people" : "person"]. "
					if(orgch.digestion_count)
						dat += "Not that they're not [pick("spooge","batter","seed")] by now. "
					dat += "<BR>"
				orgch=GetOrgan("balls")
				if(orgch.has_people()||orgch.digestion_count)
					dat += "Your balls swell with [orgch.has_people()+orgch.digestion_count] [orgch.has_people()+orgch.digestion_count>1 ? "people" : "person"]. "
					if(orgch.digestion_count)
						dat += "Not that they're not [pick("spooge","batter","seed")] by now. "
					dat += "<BR>"
				orgch=GetOrgan("breast")
				if(orgch.has_people()||orgch.digestion_count)
					dat += "Your breasts swell with [orgch.has_people()+orgch.digestion_count] [orgch.has_people()+orgch.digestion_count>1 ? "people" : "person"]. "
					if(orgch.digestion_count)
						dat += "They may just be milk, though. "
					dat += "<BR>"
				orgch=GetOrgan("tail")
				if(orgch.has_people())
					dat += "Your tail has a wriggly lump[orgch.has_people()>1 ? "s" : ""] within it[orgch.transfer_factor ? " that slowly moves toward the base of it, your stomach will swell out soon" : ""]. "
					dat += "<BR>"
				orgch=GetOrgan("insole")
				if(orgch.has_people())
					dat += "Your insole[orgch.has_people()>1 ? "s" : ""] fit[orgch.has_people()>1 ? "" : "s"] snugly against your [orgch.has_people()>1 ? "feet" : "foot"]. Each step you make is pressing against them. "
					dat += "<BR>"
				orgch=GetOrgan("insuit")
				if(orgch.has_people())
					dat += "[orgch.has_people()>1 ? "Smaller people" : "A smaller person"] squirm[orgch.has_people()>1 ? "" : "s"] in your clothes, against your form."
					dat += "<BR>"

			if (2) //Vore Abilities

				target.vore_ability=sanitize_vore_list(target.vore_ability)
				dat += "<BR>"
				dat += " <B>Select what size difference you can vore at.</B> As a failsafe, alternative vore can not be raised past oral. To change alternative vores to go higher, please adjust oral.<BR>"
				dat += GenerateAbilitySwitcher(VORE_METHOD_ORAL,"Oral")
				dat += GenerateAbilitySwitcher(VORE_METHOD_ANAL,"Anal")
				dat += GenerateAbilitySwitcher(VORE_METHOD_COCK,"Cock")
				dat += GenerateAbilitySwitcher(VORE_METHOD_UNBIRTH,"Unbirth")
				dat += GenerateAbilitySwitcher(VORE_METHOD_BREAST,"Breast")
				if(istype(target,/datum/preferences)||target.kpcode_mob_has_tail())
					dat += GenerateAbilitySwitcher(VORE_METHOD_TAIL,"Tail")

				if(istype(target,/datum/preferences))
					var/datum/preferences/PD=target
					dat += "<BR>"
					dat += "<h2>Sex Organs</h2>"
					dat += "<B>Cock: </B>"
					var/youhavea="no"
					switch(PD.p_cock["has"])
						if(1)
							youhavea="one"
						if(2)
							youhavea="a huge"
						if(3)
							youhavea="two"

					dat += "You have <a href='?src=\ref[src];preference=cock;change=has'>[youhavea]</a> cock[youhavea=="two" ? "s" : ""]."
					dat += "<BR>Type: <a href='?src=\ref[src];preference=cock;change=type'>[PD.p_cock["type"]]</a>"
					dat += "<BR>Colour: <span style='border:1px solid #161616; background-color: #[PD.p_cock["color"]];'>&nbsp;&nbsp;&nbsp;</span> "
					dat += "<a href='?src=\ref[src];preference=cock;change=color'>(Change)</a><BR>"
					dat += "<B>Vagina: </B>"
					dat += "<a href='?src=\ref[src];preference=vagina;change=has'>You [PD.p_vagina ? "have" : "don't have"] one.</a><BR>"
					//dat += "<BR>Show extra info when examining others? "
					//dat += "<a href='?src=\ref[src];preference=showgen'>[PD.show_gen ? "Yes" : "No"]</a><BR>"


			if (3) //Vore Bans

				dat += "<BR>"
				dat += " <B>Click a method to ban it.</B> Banned methods will appear in bold. When banned, you cannot be eaten with this vore type.<BR>"
				//dat += GenerateBanSwitcher(VORE_METHOD_ORAL,"Oral") Doesn't work yet
				dat += GenerateBanSwitcher(VORE_METHOD_COCK,"Cock")
				dat += GenerateBanSwitcher(VORE_METHOD_ANAL,"Anal")
				dat += GenerateBanSwitcher(VORE_METHOD_UNBIRTH,"Unbirth")
				dat += GenerateBanSwitcher(VORE_METHOD_BREAST,"Breast")
				dat += GenerateBanSwitcher(VORE_METHOD_TAIL,"Tail")
				dat += "<BR>"
				dat += GenerateBanSwitcher(VORE_METHOD_INSOLE,"Insole")
				dat += GenerateBanSwitcher(VORE_METHOD_INSUIT,"In Suit")
				dat += "<BR>"
				dat += " <B>These ones involve release.</B> If you are digested while one of these bans are enabled, the predator will have to use a non-banned release to use the banned method again.<BR>"
				dat += GenerateExBanSwitcher(VORE_EXTRA_FULLTOUR,"Fulltour")
				dat += GenerateExBanSwitcher(VORE_EXTRA_REMAINS,"Remains")

			if (4) //Debug?!

		//		dat += "<BR>"
		//		if(target.ckey=="jayehh"|| "poojawa"|| "nebulacallisto"|| "leonleonardo"|| "brimcon"|| "cyrema"|| "mrsebbi"|| "subtumaka")
		//			dat += "<h2>Debug Options</h2>"
		//			dat +=     "<B>Vore Log:</B> <a href='?src=\ref[src];preference=tab;tab=5;mod=vore'>Check</a>"
		//			dat += "<BR><B>Observe Log:</B> <a href='?src=\ref[src];preference=tab;tab=5;mod=observe'>Check</a>"
		//			dat += "<BR><B>Whitelist:</B> <a href='?src=\ref[src];preference=tab;tab=5;mod=whitelist'>Check</a>"
		//			//dat += "<BR><B>World Log:</B> <a href='?src=\ref[src];preference=tab;tab=5;mod=world'>Check</a>"
		//			dat += "<BR><B>Size: </B>"
		//			dat += "<a href='?src=\ref[src];preference=grow'>Grow</a>"
		//			dat += "<a href='?src=\ref[src];preference=shrink'>Shrink</a>"
		//			dat += "<BR><B>Taur: </B>"
		//			dat += "<a href='?src=\ref[src];preference=taur'>Toggle</a>"
		//			//dat += "<BR><B>Naga: </B>"
		//			//dat += "<a href='?src=\ref[src];preference=naga'>On</a>"
		//			dat += "<BR><B>Spawn: </B>"
		//			//dat += "<a href='?src=\ref[src];preference=spawn;item=narky'>Narky Gear</a>"
		//			dat += "<a href='?src=\ref[src];preference=spawn;item=shrink'>Shrink Ray</a>"
		//			dat += "<a href='?src=\ref[src];preference=spawn;item=grow'>Growth Ray</a>"

		//	if (5) //Log menu. Logically, if Poojawa bastardizes enough code, it'll work, right?

		//		dat += "<BR>"
		//		if(target.ckey=="jayehh"|| "poojawa"|| "nebulacallisto"|| "leonleonardo"|| "brimcon"|| "cyrema"|| "mrsebbi"|| "subtumaka")
		//			switch(tab_mod)
		//				if("observe")
		//					dat += "<h2>Observe Log</h2>"
		//					dat += global_observe_log
						//if("world")
						//	dat += "<h2>World Log</h2>"
		//				if("whitelist")
		//					dat += "<h2>Whitelist</h2>"
		//					for(var/txt in whitelist_keys)
		//						dat+="[txt]<BR>"
		//				else
		//					dat += "<h2>Vore Log</h2>"
		//					dat += global_vore_log

			if (6) //Transformation menu.
				dat += "<BR>"
				dat += "<h2>Transformation Menu</h2>"
				var/datum/vore_organ/VO=GetOrgan(tab_mod)
				dat += "Transformation for [tab_mod]: <a href='?src=\ref[src];preference=transform;organ=[tab_mod]'>Set</a>[VO.tf_factor ? "(On)" : ""]<BR>"
				dat += "Work in progress. This button will be replaced with a full menu here."

			if (7) //Transfer menu.
				dat += BuildTransfer()

			if (8) //Donate menu
				dat += "<BR>"
				dat += "<h2>Whitelist</h2>"
				dat += "Due to issues with griefers, we have whitelisted a few features. This is only to prevent one-shot griefing, and the list will not be difficult to get into."
				dat += "<BR><b>Status:</b> "
				if(is_whitelisted(target.ckey))
					dat +="<img src=large_stamp-deny.png>You are whitelisted. You will be able to respawn and play as head roles."
				else
					dat +="<img src=large_stamp-ok.png>You are not whitelisted. You will not be able to use head roles while the head whitelisting is toggled on. To become whitelisted, keep playing until we know you're not around just to cause trouble. You can also have someone trusted vouch for you."
				dat += "<BR><h2>Donations</h2>"
				dat += "In order to keep the server running, payment is required monthly. It is greatly appreciated for even the smallest amount of donations. Without them, it becomes difficult to keep the server afloat."
				dat += "By donating you can prevent this issue and allow it to continue running. As well as helping out the server, your name will be added to the donator list and you will be priority in having suggestions, ideas, and <b>certain</b> cosmetics added for personal use."
				dat += "<BR>"
				dat += {"
				<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
				<input type="hidden" name="cmd" value="_s-xclick">
				<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----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-----END PKCS7-----
">
				<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
				<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
				</form>



				"}


		var/datum/browser/popup = new(user, "voreprefs", "<div align='center'>Vore Panel</div>", 0, 0, src)
		popup.set_content(dat)
		popup.open(0)

	Topic(href, href_list)
		if(..())
			return
		if(istype(target,/mob) && usr!=target)
			usr<<"They are not you."
			return
		if(href_list["preference"] == "tab")
			current_tab=text2num(href_list["tab"])
			if(href_list["mod"])
				tab_mod=href_list["mod"]

		if(href_list["preference"] == "current")
			target.vore_current_method = text2num(href_list["method"])

		if(href_list["preference"] == "click")
			target.vore_mode = text2num(href_list["mode"])

		if(href_list["preference"] == "headfirst")
			target.vore_head_first = text2num(href_list["mode"])

		if(href_list["preference"] == "ability")
			target.vore_ability[href_list["method"]] = text2num(href_list["size"])
			if(text2num(href_list["method"])==VORE_METHOD_ORAL)
				var/list/check_methods=list(VORE_METHOD_ANAL,VORE_METHOD_COCK,VORE_METHOD_UNBIRTH,VORE_METHOD_BREAST,VORE_METHOD_TAIL)
				for(var/N in check_methods)
					if(target.vore_ability[num2text(N)]>text2num(href_list["size"]))
						target.vore_ability[num2text(N)]=text2num(href_list["size"])


		if(href_list["preference"] == "ban")
			var/method=text2num(href_list["method"])
			if(target.vore_banned_methods&method)
				target.vore_banned_methods &= ~method
			else
				target.vore_banned_methods |= method

		if(href_list["preference"] == "exban")
			var/method=text2num(href_list["method"])
			if(target.vore_extra_bans&method)
				target.vore_extra_bans &= ~method
			else
				target.vore_extra_bans |= method

		if(href_list["preference"] == "digest")
			var/datum/vore_organ/VD=GetOrgan(href_list["organ"])
			var/set_speed=text2num(href_list["speed"])
			if(target.reagents)
				if(target.reagents.has_reagent("noantacid")&&set_speed<VD.digestion_factor)
					target << "It's not working!"
					return
				if(target.reagents.has_reagent("antacid")&&set_speed>VD.digestion_factor)
					target << "It's not working!"
					return
			VD.digestion_factor = set_speed
			VD.healing_factor = 0
			VD.tf_factor = 0
			if(VD.has_people())
				vore_admins("[VD.owner]'s [VD.type] digestion changed to [VD.digestion_factor].",VD.owner)

		if(href_list["preference"] == "digest_h")
			if(target.reagents)
				if(target.reagents.has_reagent("antacid")||target.reagents.has_reagent("noantacid"))
					target << "You can't control your ability to heal."
					return
			var/datum/vore_organ/VD=GetOrgan(href_list["organ"])
			VD.digestion_factor = 0
			VD.healing_factor = 1
			VD.tf_factor = 0
			if(VD.has_people())
				vore_admins("[VD.owner]'s [VD.type] set to heal.",VD.owner)

		if(href_list["preference"] == "release")
			var/datum/vore_organ/VD=GetOrgan(href_list["organ"])
			if(href_list["extra_info"])
				VD.release(extra_info=text2num(href_list["extra_info"]))
			else
				VD.release()

		if(href_list["preference"] == "set_remains")
			target.vore_remains_mode=text2num(href_list["mode"])

		if(href_list["preference"] == "dispense")
			var/datum/vore_organ/VD=GetOrgan(href_list["organ"])
			VD.dispense(text2num(href_list["amount"]),href_list["name"])

		if(href_list["preference"] == "trap")
			var/datum/vore_organ/VD=GetOrgan(href_list["organ"])
			VD.escape=text2num(href_list["keep"])
			if(href_list["organ"]=="cock")
				VD=GetOrgan("balls")
				VD.escape=text2num(href_list["keep"])

		if(href_list["preference"] == "transfer")
			var/datum/vore_organ/VD=GetOrgan(href_list["organ"])
			VD.transfer_factor = text2num(href_list["speed"])
			VD.transfer_target = GetOrgan(href_list["dest"])

		if(href_list["preference"] == "transform")
			target.set_vore_transform(GetOrgan(href_list["organ"]))
			//vore_admins("[VD.owner]'s [VD.type] set to transform.",VD.owner)

		if(href_list["preference"] == "cock")
			var/datum/preferences/PD=target
			switch(href_list["change"])
				if("has")
					var/change_val=input(usr, "Choose your cock:", "Character Preference")  as null|anything in list("None","Normal","Hyper","Double")
					switch(change_val)
						if("None")
							PD.p_cock["has"]=0
						if("Normal")
							PD.p_cock["has"]=1
						if("Hyper")
							PD.p_cock["has"]=2
						if("Double")
							PD.p_cock["has"]=3

				if("type")
					var/change_val=input(usr, "Choose your cock type:", "Character Preference")  as null|anything in cock_list+"custom"
					if(change_val=="custom")
						change_val=input(usr, "Choose your cock type:", "Character Preference")  as text
					if(change_val)
						PD.p_cock["type"]=change_val
				if("color")
					var/new_color = input(usr, "Choose your cock's colour:", "Character Preference") as null|color
					if(new_color)
						PD.p_cock["color"] = sanitize_hexcolor(new_color)

		if(href_list["preference"] == "vagina")
			var/datum/preferences/PD=target
			PD.p_vagina=!PD.p_vagina

		//if(href_list["preference"] == "showgen")
			//var/datum/preferences/PD=target
			//PD.show_gen=!PD.show_gen

		if(href_list["preference"] == "grow")
			target.sizeplay_grow()

		if(href_list["preference"] == "shrink")
			target.sizeplay_shrink()

		if(href_list["preference"] == "taur")
			if(target.has_dna())
				var/mob/living/carbon/C=target
				C.dna.taur=!C.dna.taur
			//	updateappearance
			else
				target<<"Not going to work."

		/*if(href_list["preference"] == "naga")
			if(check_dna_integrity(target))
				var/seg_cnt=input("How many segments?", "Naga Time!", "6")
				seg_cnt=text2num(seg_cnt)
				if(!seg_cnt)
					target<<"Invalid."
				else
					var/mob/living/carbon/C=target
					C.dna.naga=new/mob/living/simple_animal/naga_segment/main(target.loc,seg_cnt)
					target.pixel_y=8
			else
				target<<"Not going to work."*/

		/*if(href_list["preference"] == "spawn")
			if(href_list["item"] == "narky")
				new /obj/item/clothing/suit/narkycuff(target.loc)
				new /obj/item/clothing/shoes/narkyanklet(target.loc)
				new /obj/item/clothing/under/maid/narky(target.loc)
			if(href_list["item"] == "grow")
				new /obj/item/weapon/gun/energy/laser/sizeray/two(target.loc)
			if(href_list["item"] == "shrink")
				new /obj/item/weapon/gun/energy/laser/sizeray/one(target.loc)*/


		if(usr)
			ShowChoices(usr)





//datum/mind/var/vore_admins=""
//var/global_vore_log=""
//proc/vore_admins(var/T,var/mob/living/pred=null,var/mob/living/prey=null)
//	global_vore_log+="<B>-</B>"+T+"<BR>"
//	if(pred&&pred.mind)
//		pred.mind.vore_admins+="-"+T+"\n"
//	if(prey&&prey.mind)
//		prey.mind.vore_admins+="-"+T+"\n"
//var/global_observe_log=""
//proc/kp_log_observe(var/T)
//	global_observe_log+="<B>-</B>"+T+"<BR>"

/proc/vore_admins(var/msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	admins << msg


proc/sanitize_vore_list(var/list/lst=null)
	if(!lst||!lst.len)
		lst=list(
		"1"=2,
		"2"=0,
		"4"=0,
		"8"=0,
		"16"=0,
		"32"=0,
		"64"=1,
		"128"=0,
		"256"=2)
	lst[num2text(VORE_METHOD_INSOLE)]=1
	lst[num2text(VORE_METHOD_INSUIT)]=2
	return lst
