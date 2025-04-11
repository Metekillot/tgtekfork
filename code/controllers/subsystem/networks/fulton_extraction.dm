/*
 * Fulton Extraction
 * Does a lot of heavy lifting for the networked aspects of fulton extraction,
 * as well as having a few utility procs and variables to keep the code clean and
 * centralized.
 *
 * restricted_beacon_networks:
 * 	An associative list: Keys being network names, and values being requirements
 * 	Supports any of the following:
 * 		- A trait
 * 		- An alist of:
 * 			(A) signal[s] key[s] sent to the user, whose AND for a value must be true
 * 		- Any combinations of the above
 *
 * 	Example:
 * 			"nt_vip" = "TRAIT_NT_VIP",
 * 			"syndicate" = list("TRAIT_SYNDICATE"),
 * 			"felinid" = alist(SIGNAL_SPECIES_FLAG = COMPONENT_FELINID_SPECIES),
 * 			"ashwalker" = list("TRAIT_ASHWALKER", alist(
 * 												COMSIG_SPECIES_RESPONSE = COMPONENT_TIZARAN_SPECIES,
 * 												COMSIG_FACTION_RESPONSE = COMPONENT_FACTION_ASHWALKER | ~COMPONENT_FACTION_NEUTRAL)
 */
SUBSYSTEM_DEF(fulton_extraction)
	name = "Fulton Extraction"
	flags = SS_NO_FIRE

	var/alist/restricted_beacon_networks

	var/alist/pack_beacon_links

	var/default_beacon_network = "ss13"

/datum/controller/subsystem/fulton_extraction/Initialize()

	CONFIG_GET()

	return SS_INIT_SUCCESS


