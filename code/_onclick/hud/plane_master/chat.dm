///Reserved to chat messages, so they are still displayed above the field of vision masking.
/obj/screen/plane_master/chat_messages
	name = "chat messages plane master"
	plane = CHAT_PLANE
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = CHAT_RENDER_TARGET

/obj/screen/plane_render_target/chat_messages
	name = "Render Holder - Game - Runechat"
	render_source = CHAT_RENDER_TARGET
	appearance_flags = APPEARANCE_UI
