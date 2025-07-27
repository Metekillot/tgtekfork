/**
 * SSHolocall
 * The handler for interconnection between devices that possess holocall functionality
 * * holo_networks - A list of tags to be fed into locate() to return the holonetwork_interface component; tracked here for
 * 	debugging and admin reference.
 *	Should be in the format of: string_key_network_name = list(valid .tags for /datum/component/network_interfaces)
 * * static_network_keys - a list of keys we shouldn't completely delete from holo_networks even if their associated
 * 	list of holonetwork_interface becomes empty
 * * private_network_keys - a list of network keys that won't render network queries that have the capacity cross-network
 *	polling. Holopads on the nukie base or centcom shouldn't be reachable from the station without special conditions.
 *
*/
SUBSYSTEM_DEF(holocall)
	name = "Holocall"
	flags = SS_NO_FIRE
	dependencies = list(
		/datum/controller/subsystem/atoms,
		/datum/controller/subsystem/mapping,
	)
	var/list/holo_networks = list(
		"Space Station 13" = list(),
		"Centcom" = list(),
		"Syndicate" = list(),
	)
	var/list/static_network_keys = list("Space Station 13")
	var/list/private_network_keys = list("Syndicate", "Centcom")
	var/list/valid_interfaces = list(
		/obj/machinery/holopad,
		/obj/item/clothing/neck/link_scryer,
		/obj/machinery/new_holopad,
	)

/datum/controller/subsystem/holocall/Initialize()
	for(var/list/network in holo_networks)
		if(!islist(network))
			log_runtime("A network list under key [network] wasn't actually a list.")
			holo_networks.Remove(network)
			continue
		for(var/callsign in network)
			var/datum/component/holonetwork_interface/interface = network[callsign]
			if(isnull(interface))
				log_runtime("A holonetwork interface associated to [callsign] was missing.")
				network.Remove(callsign)
				continue
			if(!istype(interface.physical_interface))
				var/data = list()
				data[tag] = interface
				for(var/if_var in interface.vars)
					data["[if_var]"] = interface.vars[if_var]
				log_runtime("A holonetwork interface for [callsign] resolved, but it had an invalid .physical_interface.", data)
				network.Remove(callsign)
				qdel(callsign)
				continue
	return SS_INIT_SUCCESS

/datum/controller/subsystem/holocall/proc/make_callsign(datum/component/holonetwork_interface/tracked)
	if(tracked.physical_interface.anchored)
		var/area/area = get_area(tracked.physical_interface)
		. = area.name
	else
		. = tracked.physical_interface.name
	. = splittext(., " ")
	var/list/to_join = list()
	for(var/text in .)
		to_join += uppertext(copytext(text, 1, 4))
	. = jointext(to_join, "_")


/datum/controller/subsystem/holocall/proc/track(datum/component/holonetwork_interface/tracked)
	if(is_station_level(tracked.physical_interface.z))
		if(!isnull(holo_networks["Space Station 13"][tracked.callsign]))
			tracked.callsign = "[tracked.callsign]_2"
		holo_networks["Space Station 13"][tracked.callsign] = tracked
