
/obj/item/card/id/advanced/chameleon
	name = "agent card"
	desc = "A highly advanced chameleon ID card. Touch this card on another ID card or player to choose which accesses to copy. \
		Has special magnetic properties which force it to the front of wallets."
	trim = /datum/id_trim/chameleon
	wildcard_slots = WILDCARD_LIMIT_GOLD
	actions_types = list(/datum/action/item_action/chameleon/change/id, /datum/action/item_action/chameleon/change/id_trim)
	action_slots = ALL

	/// Have we set a custom name and job assignment, or will we use what we're given when we chameleon change?
	var/forged = FALSE
	/// Anti-metagaming protections. If TRUE, anyone can change the ID card's details. If FALSE, only syndicate agents can.
	var/anyone = FALSE
	/// Weak ref to the ID card we're currently attempting to steal access from.
	var/datum/weakref/theft_target
	var/datum/chameleon_card_forging_interface/forging_interface

/obj/item/card/id/advanced/chameleon/crummy
	desc = "A surplus version of a chameleon ID card. Can only hold a limited number of access codes."
	wildcard_slots = WILDCARD_LIMIT_CHAMELEON

/obj/item/card/id/advanced/chameleon/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/card/id/advanced/chameleon/Destroy()
	theft_target = null
	return ..()

/obj/item/card/id/advanced/chameleon/equipped(mob/user, slot)
	. = ..()
	if (slot & ITEM_SLOT_ID)
		RegisterSignal(user, COMSIG_LIVING_CAN_TRACK, PROC_REF(can_track))

/obj/item/card/id/advanced/chameleon/dropped(mob/user)
	UnregisterSignal(user, COMSIG_LIVING_CAN_TRACK)
	return ..()

/obj/item/card/id/advanced/chameleon/proc/can_track(datum/source, mob/user)
	SIGNAL_HANDLER

	return COMPONENT_CANT_TRACK

/obj/item/card/id/advanced/chameleon/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isidcard(interacting_with))
		theft_target = WEAKREF(interacting_with)
		ui_interact(user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/card/id/advanced/chameleon/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	// If we're attacking a human, we want it to be covert. We're not ATTACKING them, we're trying
	// to sneakily steal their accesses by swiping our agent ID card near them. As a result, we
	// return ITEM_INTERACT_BLOCKING to cancel any part of the following the attack chain.
	if(ishuman(interacting_with))
		interacting_with.balloon_alert(user, "scanning ID card...")

		if(!do_after(user, 2 SECONDS, interacting_with, hidden = TRUE))
			interacting_with.balloon_alert(user, "interrupted!")
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_target = interacting_with
		var/list/target_id_cards = human_target.get_all_contents_type(/obj/item/card/id)

		if(!length(target_id_cards))
			interacting_with.balloon_alert(user, "no IDs!")
			return ITEM_INTERACT_BLOCKING

		var/selected_id = pick(target_id_cards)
		interacting_with.balloon_alert(user, UNLINT("IDs synced"))
		theft_target = WEAKREF(selected_id)
		ui_interact(user)
		return ITEM_INTERACT_SUCCESS

	if(isitem(interacting_with))
		var/obj/item/target_item = interacting_with

		interacting_with.balloon_alert(user, "scanning ID card...")

		var/list/target_id_cards = target_item.get_all_contents_type(/obj/item/card/id)
		var/target_item_id = target_item.GetID()

		if(target_item_id)
			target_id_cards |= target_item_id

		if(!length(target_id_cards))
			interacting_with.balloon_alert(user, "no IDs!")
			return ITEM_INTERACT_BLOCKING

		var/selected_id = pick(target_id_cards)
		interacting_with.balloon_alert(user, UNLINT("IDs synced"))
		theft_target = WEAKREF(selected_id)
		ui_interact(user)
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/card/id/advanced/chameleon/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChameleonCard", name)
		ui.open()

/obj/item/card/id/advanced/chameleon/ui_static_data(mob/user)
	var/list/data = list()
	data["wildcardFlags"] = SSid_access.wildcard_flags_by_wildcard
	data["accessFlagNames"] = SSid_access.access_flag_string_by_flag
	data["accessFlags"] = SSid_access.flags_by_access
	return data

/obj/item/card/id/advanced/chameleon/ui_host(mob/user)
	// Hook our UI to the theft target ID card for UI state checks.
	return theft_target?.resolve()

/obj/item/card/id/advanced/chameleon/ui_state(mob/user)
	return GLOB.always_state

/obj/item/card/id/advanced/chameleon/ui_status(mob/user, datum/ui_state/state)
	var/target = theft_target?.resolve()

	if(!target)
		return UI_CLOSE

	var/status = min(
		ui_status_user_strictly_adjacent(user, target),
		ui_status_user_is_advanced_tool_user(user),
		max(
			ui_status_user_is_conscious_and_lying_down(user),
			ui_status_user_is_abled(user, target),
		),
	)

	if(status < UI_INTERACTIVE)
		return UI_CLOSE

	return status

/obj/item/card/id/advanced/chameleon/ui_data(mob/user)
	var/list/data = list()

	data["showBasic"] = FALSE

	var/list/regions = list()

	var/obj/item/card/id/target_card = theft_target.resolve()
	if(target_card)
		var/list/tgui_region_data = SSid_access.all_region_access_tgui
		for(var/region in SSid_access.station_regions)
			regions += tgui_region_data[region]

	data["accesses"] = regions
	data["ourAccess"] = access
	data["ourTrimAccess"] = trim ? trim.access : list()
	data["theftAccess"] = target_card.access.Copy()
	data["wildcardSlots"] = wildcard_slots
	data["selectedList"] = access
	data["trimAccess"] = list()

	return data

/obj/item/card/id/advanced/chameleon/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/obj/item/card/id/target_card = theft_target?.resolve()
	if(QDELETED(target_card))
		to_chat(usr, span_notice("The ID card you were attempting to scan is no longer in range."))
		target_card = null
		return TRUE

	// Wireless ID theft!
	var/turf/our_turf = get_turf(src)
	var/turf/target_turf = get_turf(target_card)
	if(!our_turf.Adjacent(target_turf))
		to_chat(usr, span_notice("The ID card you were attempting to scan is no longer in range."))
		target_card = null
		return TRUE

	switch(action)
		if("mod_access")
			var/access_type = params["access_target"]
			var/try_wildcard = params["access_wildcard"]
			if(access_type in access)
				remove_access(list(access_type))
				LOG_ID_ACCESS_CHANGE(usr, src, "removed [SSid_access.get_access_desc(access_type)]")
				return TRUE

			if(!(access_type in target_card.access))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(!can_add_wildcards(list(access_type), try_wildcard))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(!add_access(list(access_type), try_wildcard))
				to_chat(usr, span_notice("ID error: ID card rejected your attempted access modification."))
				LOG_ID_ACCESS_CHANGE(usr, src, "failed to add [SSid_access.get_access_desc(access_type)][try_wildcard ? " with wildcard [try_wildcard]" : ""]")
				return TRUE

			if(access_type in ACCESS_ALERT_ADMINS)
				message_admins("[ADMIN_LOOKUPFLW(usr)] just added [SSid_access.get_access_desc(access_type)] to an ID card [ADMIN_VV(src)] [(registered_name) ? "belonging to [registered_name]." : "with no registered name."]")
			LOG_ID_ACCESS_CHANGE(usr, src, "added [SSid_access.get_access_desc(access_type)]")
			return TRUE

/obj/item/card/id/advanced/chameleon/attack_self(mob/user)
	if(!user.can_perform_action(user, NEED_DEXTERITY| FORBID_TELEKINESIS_REACH))
		return ..()
	var/popup_input = tgui_input_list(user, "Choose Action", "Agent ID", list("Show", "Forge/Reset", "Change Account ID"))
	if(!popup_input || !after_input_check(user))
		return TRUE
	switch(popup_input)
		if ("Change Account ID")
			set_new_account(user)
			return
		if("Show")
			return ..()

	if(isnull(forging_interface))
		forging_interface = new(user, src)

	forging_interface.ui_interact(user)
	return TRUE


/obj/item/card/id/advanced/chameleon/add_item_context(obj/item/source, list/context, atom/target, mob/living/user,)
	. = ..()

	if(!in_range(user, target))
		return .
	if(ishuman(target))
		context[SCREENTIP_CONTEXT_RMB] = "Copy access"
		return CONTEXTUAL_SCREENTIP_SET
	if(isitem(target))
		context[SCREENTIP_CONTEXT_RMB] = "Scan for access"
		return CONTEXTUAL_SCREENTIP_SET
	return .

/// A special variant of the classic chameleon ID card which is black. Cool!
/obj/item/card/id/advanced/chameleon/black
	icon_state = "card_black"
	assigned_icon_state = "assigned_syndicate"
