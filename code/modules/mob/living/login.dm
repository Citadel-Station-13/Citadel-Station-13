/mob/living/Login()
	..()
	//Mind updates
	sync_mind()
	mind.show_memory(src, 0)

	//Round specific stuff
	if(ticker && ticker.mode)
		switch(ticker.mode.name)
			if("sandbox")
				CanBuild()

	update_damage_hud()
	update_health_hud()

	//Vents
	if(ventcrawler)
		src << "<span class='notice'>You can ventcrawl! Use alt+click on vents to quickly travel about the station.</span>"

	if(ranged_ability)
		client.click_intercept = ranged_ability
		src << "<span class='notice'>You currently have <b>[ranged_ability.name]</b> active!</span>"