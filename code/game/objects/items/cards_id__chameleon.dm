
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

	///"Forge/Reset", kept outside the switch() statement to reduce indentation.
	if(forged) //reset the ID if forged
		var/datum/chameleon_card_interface/my_interface = new(user, src)
		registered_name = initial(registered_name)
		assignment = initial(assignment)
		SSid_access.remove_trim_override(src)
		REMOVE_TRAIT(src, TRAIT_MAGNETIC_ID_CARD, CHAMELEON_ITEM_TRAIT)
		user.log_message("reset \the [initial(name)] named \"[src]\" to default.", LOG_GAME)
		update_label()
		update_icon()
		forged = FALSE
		to_chat(user, span_notice("You successfully reset the ID card."))
		return

	///forge the ID if not forged.s
	var/input_name = tgui_input_text(user, "What name would you like to put on this card? Leave blank to randomise.", "Agent card name", registered_name ? registered_name : (ishuman(user) ? user.real_name : user.name), max_length = MAX_NAME_LEN, encode = FALSE)

	if(!after_input_check(user))
		return TRUE
	if(input_name)
		input_name = sanitize_name(input_name, allow_numbers = TRUE)
	if(!input_name)
		// Invalid/blank names give a randomly generated one.
		if(user.gender == MALE)
			input_name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
		else if(user.gender == FEMALE)
			input_name = "[pick(GLOB.first_names_female)] [pick(GLOB.last_names)]"
		else
			input_name = "[pick(GLOB.first_names)] [pick(GLOB.last_names)]"

	var/change_trim = tgui_alert(user, "Adjust the appearance of your card's trim?", "Modify Trim", list("Yes", "No"))
	if(!after_input_check(user))
		return TRUE
	var/selected_trim_path
	var/static/list/trim_list
	if(change_trim == "Yes")
		trim_list = list()
		for(var/trim_path in typesof(/datum/id_trim))
			var/datum/id_trim/trim = SSid_access.trim_singletons_by_path[trim_path]
			if(trim && trim.trim_state && trim.assignment)
				var/fake_trim_name = "[trim.assignment] ([trim.trim_state])"
				trim_list[fake_trim_name] = trim_path
		selected_trim_path = tgui_input_list(user, "Select trim to apply to your card.\nNote: This will not grant any trim accesses.", "Forge Trim", sort_list(trim_list, GLOBAL_PROC_REF(cmp_typepaths_asc)))
		if(!after_input_check(user))
			return TRUE

	var/target_occupation = tgui_input_text(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels.", "Agent card job assignment", assignment ? assignment : "Assistant", max_length = MAX_NAME_LEN)
	if(!after_input_check(user))
		return TRUE

	var/new_age = tgui_input_number(user, "Choose the ID's age", "Agent card age", AGE_MIN, AGE_MAX, AGE_MIN)
	if(!after_input_check(user))
		return TRUE

	var/wallet_spoofing = tgui_alert(user, "Activate wallet ID spoofing, allowing this card to force itself to occupy the visible ID slot in wallets?", "Wallet ID Spoofing", list("Yes", "No"))
	if(!after_input_check(user))
		return

	registered_name = input_name
	if(selected_trim_path)
		SSid_access.apply_trim_override(src, trim_list[selected_trim_path])
	if(target_occupation)
		assignment = sanitize(target_occupation)
	if(new_age)
		registered_age = new_age
	if(wallet_spoofing  == "Yes")
		ADD_TRAIT(src, TRAIT_MAGNETIC_ID_CARD, CHAMELEON_ITEM_TRAIT)

	update_label()
	update_icon()
	forged = TRUE
	to_chat(user, span_notice("You successfully forge the ID card."))
	user.log_message("forged \the [initial(name)] with name \"[registered_name]\", occupation \"[assignment]\" and trim \"[trim?.assignment]\".", LOG_GAME)

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/owner = user
	if (!selected_trim_path) // Ensure that even without a trim update, we update user's sechud
		owner.sec_hud_set_ID()

	if (registered_account)
		return

	var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[owner.account_id]"]
	if(account)
		account.bank_cards += src
		registered_account = account
		to_chat(user, span_notice("Your account number has been automatically assigned."))

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
