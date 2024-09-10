/**
 * # Point Follower
 *
 * Notice when something in its FOV is pointed at; returns point target and whoever is pointing.
 */
/obj/item/circuit_component/point_follower
	display_name = "Point Follower"
	desc = "A component that returns the entity pointing and the entity pointed at, as long as they are within its FOV."
	category = "Sensors"

	/// The person we're meant to be watching for pointing
	var/datum/port/input/listen_to

	/// The pointing target
	var/datum/port/output/target
	/// The trigger sent when this event occurs
	var/datum/port/output/trigger_port
	var/max_range = 7

/obj/item/circuit_component/direction/get_ui_notices()
	. = ..()
	. += create_ui_notice("Maximum Range: [max_range] tiles", "orange", "info")

/obj/item/circuit_component/point_follower/populate_ports()
	listen_to = add_input_port("Pointer", PORT_TYPE_ATOM)
	target = add_output_port("Target", PORT_TYPE_ATOM)


/obj/item/circuit_component/point_follower/register_shell(atom/movable/shell)
	if(parent.loc != shell)
		shell.become_hearing_sensitive(CIRCUIT_HEAR_TRAIT)
		RegisterSignal(shell, COMSIG_MOVABLE_HEAR, PROC_REF(on_shell_hear))

/obj/item/circuit_component/point_follower/input_received/(datum/port/input/port)

	if
