///from /datum/holonet_call/New():
/// (datum/holonetwork_interface/connecting_from, datum/holonetwork_interface/connecting_to, datum/holonetwork_interface/list/participants)
#define COMSIG_HOLONET_CONNECTION_REQUEST "holonet_connection_request"
	#define COMPONENT_HOLOREQUEST_RECEIVED (1<<0)
	#define COMPONENT_HOLOREQUEST_BUSY (1<<1)
