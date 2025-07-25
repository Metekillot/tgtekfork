///Main proc for primary alt click
/mob/proc/AltClickOn(atom/target)
	base_click_alt(target)

/**
 * ### Base proc for alt click interaction left click. Returns if the click was intercepted & handled
 *
 * If you wish to add custom `click_alt` behavior for a single type, use that proc.
 */
/mob/proc/base_click_alt(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	// Check if they've hooked in to prevent src from alt clicking anything
	if(SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON, target) & COMSIG_MOB_CANCEL_CLICKON)
		return TRUE

	// If it has a signal handler that returns a click action, done.
	if(SEND_SIGNAL(target, COMSIG_CLICK_ALT, src) & CLICK_ACTION_ANY)
		return TRUE

	// If it has a custom click_alt that returns success/block, done.
	if(can_perform_action(target, (target.interaction_flags_click | SILENT_ADJACENCY)))
		return target.click_alt(src) & CLICK_ACTION_ANY

	return FALSE

/mob/living/base_click_alt(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	. = ..()
	if(. || !CAN_I_SEE(target) || (is_blind() && !IN_GIVEN_RANGE(src, target, 1)))
		return

	return TRUE

/**
 * ## Custom alt click interaction
 * Override this to change default alt click behavior. Return `CLICK_ACTION_SUCCESS`, `CLICK_ACTION_BLOCKING` or `NONE`.
 *
 * ### Guard clauses
 * Consider adding `interaction_flags_click` before adding unique guard clauses.
 *
 * ### Return flags
 * Forgetting your return will cause the default alt click behavior to occur thereafter.
 *
 * The difference between NONE and BLOCKING can get hazy, but I like to keep NONE limited to guard clauses and "never" cases.
 *
 * A good usage for BLOCKING over NONE is when it's situational for the item and there's some feedback indicating this.
 *
 * ### Examples:
 * User is a ghost, alt clicks on item with special disk eject: NONE
 *
 * Machine broken, no feedback: NONE
 *
 * Alt click a pipe to max output but its already max: BLOCKING
 *
 * Alt click a gun that normally works, but is out of ammo: BLOCKING
 *
 * User unauthorized, machine beeps: BLOCKING
 *
 * @param {mob} user - The person doing the alt clicking.
 */
/atom/proc/click_alt(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return NONE


///Main proc for secondary alt click
/mob/proc/AltClickSecondaryOn(atom/target)
	base_click_alt_secondary(target)

/**
 * ### Base proc for alt click interaction right click.
 *
 * If you wish to add custom `click_alt_secondary` behavior for a single type, use that proc.
 */
/mob/proc/base_click_alt_secondary(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	//Hook on the mob to intercept the click
	if(SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON_SECONDARY, target) & COMSIG_MOB_CANCEL_CLICKON)
		return

	//Hook on the atom to intercept the click
	if(SEND_SIGNAL(target, COMSIG_CLICK_ALT_SECONDARY, src) & COMPONENT_CANCEL_CLICK_ALT_SECONDARY)
		return

	// If it has a custom click_alt_secondary then do that
	if(can_perform_action(target, target.interaction_flags_click | SILENT_ADJACENCY))
		target.click_alt_secondary(src)

/**
 * ## Custom alt click secondary interaction
 * Override this to change default alt right click behavior.
 *
 * ### Guard clauses
 * Consider adding `interaction_flags_click` before adding unique guard clauses.
 **/
/atom/proc/click_alt_secondary(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return NONE

/**
 * ## Snowflake click interaction for TGUI loot_panel
 * Due to the immense utility of the tgui loot panel when it comes to interacting with
 * items on turfs that are cluttered or suffering from some chicanery with plane layers
 * or other such nonsense, this is defined and expressly intended to be the way to open
 * a tgui loot_panel for an item's given turf. It is, unlike the other ctrl/alt/shift click
 * interactions, meant to NOT BE OVERRIDDEN in any circumstance. For modifying the behavior of
 * objects/datums/etc in regards to the tgui loot_panel, it's recommended to instead make those
 * changes in the loot_panel's DM or TS code, instead.
 *
 * It is attached to Shift+Alt due to Shift being the longtime default bind for examination, and
 * adding the 'Alt' modifier as the way to then examine the contents of a turf in a TGUI window
 * seems like a reasonable extension.
 * * target - whatever we just shift+alt clicked on.
 */
/mob/proc/AltShiftClickOn(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)
	return NONE

/**
 * Here we steal most of the old code for determining whether a living mob with all the restrictions
 * on their sight should not be able to open a loot_panel for a given atom's turf.
 */
/mob/living/AltShiftClickOn(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!CAN_I_SEE(target) || (is_blind() && !IN_GIVEN_RANGE(src, target, 1)))
		return

	// No alt clicking to view turf from beneath
	if(HAS_TRAIT(src, TRAIT_MOVE_VENTCRAWLING))
		return

	/// No loot panel if it's on our person
	if(isobj(target) && (target in get_all_gear()))
		to_chat(src, span_warning("You can't search for this item, it's already in your inventory! Take it off first."))
		return

	client.loot_panel.open(get_turf(target))
	return TRUE

/**
 * There really shouldn't be any fathomable circumstance where observers aren't able to examine
 * the contents of a turf at their leisure, so we let dead mobs open up a lootpanel for anything they
 * can click on.
 */
/mob/dead/AltShiftClickOn(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	client.loot_panel.open(get_turf(target))
	return TRUE
