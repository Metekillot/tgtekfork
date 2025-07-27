/datum/holonet_request
	var/datum/component/holonetwork_interface/connecting_from
	var/datum/component/holonetwork_interface/connecting_to
	var/list/datum/component/holonetwork_interface/participants = list()

/datum/holonet_request/New(datum/component/holonetwork_interface/connecting_from, datum/component/holonetwork_interface/connecting_to, list/participants)
	src.connecting_from = connecting_from
	src.connecting_to = connecting_to
	src.participants = participants.Copy()
	SEND_SIGNAL(connecting_to, COMSIG_HOLONET_CONNECTION_REQUEST, src)

/datum/holonet_request/Destroy()
	connecting_from = null
	connecting_to = null
	participants = null
	. = ..()

/datum/holonet_connection
	var/datum/component/holonetwork_interface/list/participants = list()
