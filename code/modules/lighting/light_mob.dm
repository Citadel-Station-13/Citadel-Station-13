/*mob
	//var/obj/screen/plane/master/master_plane
	var/obj/screen/backdrop/backdrop
	var/seedarkness = 1

/mob/proc/create_lighting_planes()
	//if(!master_plane)
		//master_plane = new(client)
	//else
		//client.screen |= master_plane
	if(!backdrop)
		backdrop = new(client)
	else
		client.screen |= backdrop*/
	//if(client)
		//update_darkness()

/*mob/Login()
	. = ..()
	create_lighting_planes()*/

/*/mob/proc/update_darkness()
	if(seedarkness)
		master_plane.color = LIGHTING_PLANEMASTER_COLOR
	else
		master_plane.color = ""*/

/mob/living/carbon/human/update_contained_lights(var/list/specific_contents)
	. = ..(contents-(internal_organs))
