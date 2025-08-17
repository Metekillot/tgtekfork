/datum/component/holonetwork_interface
	var/obj/physical_interface
	var/datum/holonet_connection/current_call = null
	var/list/datum/holonet_request/waiting = list()
	var/callsign
	var/current_network
	///user's eye, once connected
	var/mob/eye/camera/remote/holonet_projection/eye
	///user's hologram, once connected
	var/obj/effect/overlay/holo_pad_hologram/hologram
	var/mob/living/current_user

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
	else
		. = COMPONENT_HOLOREQUEST_RECEIVED
	waiting += request
	physical_interface.say("Incoming call from [request.connecting_from.callsign]")

/datum/component/holonetwork_interface/proc/accept_request(datum/holonet_request/accepted)
	. = new /datum/holonet_connection(host_interface = src, participants = accepted.participants)
	waiting -= accepted
	qdel(accepted)

/datum/component/holonetwork_interface/proc/display_ui(datum/source, mob/user, always_display = FALSE)
	SIGNAL_HANDLER
	// Most will be subtyped under /mob/living, but if not, the null return will still satisfy
	if(always_display || !(astype(user, /mob/living)?.combat_mode))
		INVOKE_ASYNC(src, TYPE_PROC_REF(/datum, ui_interact), user)
		if(isliving(user))
			current_user = user
		return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/holonetwork_interface/proc/connect_to(datum/component/holonetwork_interface/host_interface, datum/holonet_connection/current_call)
	if(src.current_call && src.current_call != current_call)
		//disconnect_call(src.current_call)
		return
	src.current_call = current_call
	if(current_user)
		project_to(host_interface)

/datum/component/holonetwork_interface/proc/project_to(datum/component/holonetwork_interface/host_interface)
	if(!current_user)
		return
	eye = new(get_turf(host_interface.physical_interface), host_interface.physical_interface, current_user)

/datum/component/holonetwork_interface/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HolonetworkInterface", physical_interface.name)
		ui.open()

/datum/component/holonetwork_interface/ui_data(mob/user)
	var/list/data = list()
	data["available_interfaces"] = is_station_level(physical_interface.z) ? SSholocall.holo_networks["Space Station 13"] : null
	data["waiting"] = list()
	for(var/datum/holonet_request/request as anything in waiting)
		var/list/participant_callsigns = list()
		for(var/datum/component/holonetwork_interface/participant as anything in request.participants)
			participant_callsigns += participant.callsign
		data["waiting"] += list(
			list(
				"connecting_from_callsign" = request.connecting_from.callsign,
		 		"connecting_from_ref" = REF(request),
				"participant_callsigns" = participant_callsigns))
	return data

/datum/component/holonetwork_interface/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("send_call_request")
			send_call_request(usr, params["target"])
			return TRUE
		if("accept_request")
			accept_request(locate(params["accepted"]))
			return TRUE

/datum/component/holonetwork_interface/proc/send_call_request(mob/living/user, target_name)
	var/datum/component/holonetwork_interface/target = SSholocall.holo_networks[current_network][target_name]
	if(!target)
		physical_interface.say("Call attempt failed: couldn't find destination interface")
		return
	physical_interface.say("Contact made, prompting destination for call connection")
	. = new /datum/holonet_request(connecting_from = src, connecting_to = target, participants = list(src))
