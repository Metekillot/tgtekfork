/mob/eye/holonet_projection
	move_on_shuttle = TRUE
	has_emotes = TRUE
	invisibility = NONE
	mouse_opacity = MOUSE_OPACITY_ICON

/mob/eye/holonet_projection/Initialize(mapload, atom/movable/projecting_from, mob/living/holonet_user)
	. = ..()
	AddComponent(/datum/component/leash, projecting_from, 5)
	icon = holonet_user.icon
	icon_state = holonet_user.icon_state
	holonet_user.remote_control = src
	holonet_user.reset_perspective(src)
