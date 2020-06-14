/obj/screen/plane_master/hud_general
	name = "general hud plane master"
	plane = HUD_PLANE
	render_target = HUD_RENDER_TARGET
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE

/obj/screen/plane_render_target/hud_general
	name = "Render Holder - HUD - General"
	render_source = HUD_RENDER_TARGET

/obj/screen/plane_master/volumetric_box
	name = "volumetric storage box plane master"
	plane = VOLUMETRIC_STORAGE_BOX_PLANE
	render_target = VOLUMETRIC_STORAGE_BOX_RENDER_TARGET
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE

/obj/screen/plane_render_target/volumetric_box
	name = "Render Holder - HUD - Volumetric Storage Boxes"
	render_source = VOLUMETRIC_STORAGE_BOX_RENDER_TARGET

/obj/screen/plane_mster/volumetric_item
	name = "volumetric storage item plane master"
	plane = VOLUMETRIC_STORAGE_ITEM_PLANE
	render_target = VOLUMETRIC_STORAGE_ITEM_RENDER_TARGET
	appearance_flags = PLANE_MASTER | PIXEL_SCALE

/obj/screen/plane_render_target/volumetric_item
	name = "Render Holder - HUD - Volumetric Storage Items"
	render_source = VOLUMETRIC_STORAGE_ITEM_RENDER_TARGET

/obj/screen/plane_master/above_hud
	name = "above hud plane master"
	plane = ABOVE_HUD_PLANE
	render_target = ABOVE_HUD_RENDER_TARGET
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR | PIXEL_SCALE

/obj/screen/plane_render_target/above_hud
	name = "Render Holder - HUD - Above HUD Objects"
	render_source = ABOVE_HUD_RENDER_TARGET
