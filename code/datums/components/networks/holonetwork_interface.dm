/datum/component/holonetwork_interface
	var/obj/physical_interface
	var/datum/holonet_connection/current_call = null
	///user's eye, once connected
	var/mob/eye/camera/remote/holo/eye
	///user's hologram, once connected
	var/obj/effect/overlay/holo_pad_hologram/hologram
	var/list/datum/holonet_request/waiting = list()
	var/callsign

/datum/component/holonetwork_interface/Initialize()
	var/failure_to_attach = TRUE
	for(var/valid_type in SSholocall.valid_interfaces)
		if(!istype(parent, valid_type))
			continue
		failure_to_attach = FALSE
		break
	if(failure_to_attach)
		return COMPONENT_INCOMPATIBLE
	physical_interface = parent
	callsign = SSholocall.make_callsign(src)
	SSholocall.track(src)

/datum/component/holonetwork_interface/RegisterWithParent()
	RegisterSignals(parent, list(
		COMSIG_ITEM_ATTACK_SELF_SECONDARY,
		COMSIG_ATOM_ATTACK_HAND_SECONDARY,
		COMSIG_ATOM_UI_INTERACT,
		), PROC_REF(display_ui))
	/*
	register examine
	*/
	RegisterSignal(parent, COMSIG_HOLONET_CONNECTION_REQUEST, PROC_REF(receive_request))

/datum/component/holonetwork_interface/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_ATTACK_SELF_SECONDARY,
		COMSIG_ATOM_ATTACK_HAND_SECONDARY,
		COMSIG_ATOM_UI_INTERACT,
	))

/datum/component/holonetwork_interface/Destroy()
	physical_interface = null
	return ..()

/datum/component/holonetwork_interface/proc/receive_request(datum/source, datum/holonet_request/request)
	SIGNAL_HANDLER
	if(current_call)
		. = COMPONENT_HOLOREQUEST_BUSY
		waiting += request
	else
		. = COMPONENT_HOLOREQUEST_RECEIVED
	physical_interface.say("Incoming call from [request.connecting_from.physical_interface.name]")

/datum/component/holonetwork_interface/proc/display_ui(datum/source, mob/user)
	SIGNAL_HANDLER
	// Most will be subtyped under /mob/living, but if not, the null return will still satisfy
	if(!(astype(user, /mob/living)?.combat_mode))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/datum, ui_interact), user)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/holonetwork_interface/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HolonetworkInterface", physical_interface.name)
		ui.open()

/datum/component/holonetwork_interface/ui_data(mob/user)
	var/list/data = list()
	data["available_interfaces"] = is_station_level(physical_interface.z) ? SSholocall.holo_networks["Space Station 13"] : null
	return data
