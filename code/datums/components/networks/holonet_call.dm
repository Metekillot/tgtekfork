/datum/holonet_request
	var/datum/component/holonetwork_interface/connecting_from
	var/datum/component/holonetwork_interface/connecting_to
	var/list/datum/component/holonetwork_interface/participants = list()

/datum/holonet_request/New(datum/component/holonetwork_interface/connecting_from, datum/component/holonetwork_interface/connecting_to, list/participants)
	src.connecting_from = connecting_from
	src.connecting_to = connecting_to
	src.participants = participants.Copy()
	SEND_SIGNAL(connecting_to.physical_interface, COMSIG_HOLONET_CONNECTION_REQUEST, src)

/datum/holonet_request/Destroy()
	connecting_from = null
	connecting_to = null
	participants = null
	. = ..()

/datum/holonet_connection
	var/list/datum/component/holonetwork_interface/participants = list()

/datum/holonet_connection/New(
	datum/component/holonetwork_interface/host_interface,
	list/participants
)
	src.participants = participants
	for(var/datum/component/holonetwork_interface/projecting as anything in src.participants)
		projecting.connect_to(host_interface = host_interface, current_call = src)

