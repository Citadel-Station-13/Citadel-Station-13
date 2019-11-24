/datum/component/storage/concrete/secret_satchel/can_be_inserted(obj/item/I, stop_messages = FALSE, mob/M)
	if(SSpersistence.spawned_objects[I])
		to_chat(M, "<span class='warning'>[I] is unstable after its journey through space and time, it wouldn't survive another trip.</span>")
		return FALSE
	return ..()
