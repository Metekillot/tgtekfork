/mob/eye/camera/remote/holonet_projection
	move_on_shuttle = TRUE
	has_emotes = TRUE
	invisibility = NONE
	mouse_opacity = MOUSE_OPACITY_ICON
	var/static/standard_maximum_distance = 3
	var/current_maximum_distance
	var/atom/movable/projecting_from
	var/mob/living/active_user

/mob/eye/camera/remote/holonet_projection/Initialize(mapload, atom/movable/projecting_from, mob/living/holonet_user, maximum_distance = standard_maximum_distance)
	. = ..()
	src.projecting_from = projecting_from
	AddComponent(/datum/component/leash, projecting_from, maximum_distance)
	current_maximum_distance = maximum_distance
	icon = holonet_user.icon
	icon_state = holonet_user.icon_state
	active_user = holonet_user
	copy_overlays(holonet_user, TRUE)
	makeHologram()
	holonet_user.remote_control = src
	holonet_user.reset_perspective(src)

/mob/eye/camera/remote/holonet_projection/setLoc(turf/destination, force_update)
	if(get_dist(destination, projecting_from) > current_maximum_distance)
		return balloon_alert(active_user, "too far!")
	..()

