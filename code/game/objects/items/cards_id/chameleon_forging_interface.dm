
/datum/chameleon_card_forging_interface
	var/name = "Chameleon Card Forge"
	// The card that is being forged
	var/obj/item/card/id/advanced/chameleon/my_card
	var/static/list/fields_set = list(
		"registered_name" = "None",
		"assignment" = "None",
		"registered_age" = 25,
		"trim_assignment_override" = "None",
		"is_wallet_spoofing" = FALSE,
		"gender_presented" = null
	)
	var/list/alist/card_presets[5]
	var/using_preset = 1

/datum/chameleon_card_forging_interface/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChameleonCardForge", name)
		ui.open()

/datum/chameleon_card_forging_interface/New(mob/living/user, obj/item/card/id/advanced/chameleon/forging_card)
	. = ..()
	if(!istype(forging_card) || !istype(user))
		return
	my_card = forging_card
	init_presets()
	ui_interact(user)

/datum/chameleon_card_forging_interface/proc/invoke_var_setter(var_name, randomize = FALSE, var_value)
	if(!istype(my_card) || !fields_set[var_name])
		return
	my_card.vars[var_name] = var_value
	my_card.update_label()
	card_presets[using_preset][var_name] = var_value

/datum/chameleon_card_forging_interface/proc/init_presets()
	#ifndef SPACEMAN_DMM
	card_presets = list(
		alist(),
		alist(),
		alist(),
		alist(),
		alist()
	)
	for(var/alist/preset as anything in card_presets)
		for(var/field in fields_set)
			preset[field] = my_card.vars[field] ||= fields_set[field]
	#endif

/datum/chameleon_card_forging_interface/proc/set_preset(index, field, value)
	if(!istype(my_card))
		return
	card_presets[index][field] = value

/datum/chameleon_card_forging_interface/ui_status(mob/living/user)
	if(!istype(user) || !istype(my_card))
		return UI_CLOSE
	if(isAdminObserver(user))
		return UI_INTERACTIVE
	if(isobserver(user))
		return UI_UPDATE
	if(get(my_card, /mob/living != user))
		return UI_CLOSE
	if(user.IsUnconscious() || user.IsParalyzed())
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/chameleon_card_forging_interface/ui_data(mob/user)
	var/list/data = list()
	var/alist/current_preset = card_presets[using_preset]
	#ifndef SPACEMAN_DMM
	for(var/field, entry in current_preset)
		data[field] = entry
	#endif

	return data

/datum/chameleon_card_forging_interface/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("set")
			invoke_var_setter(var_name = params["field"], var_value = params["value"])
		if("randomize")
			var/list/fields_to_randomize = params["fields_to_randomize"]
			for(var/field in fields_to_randomize)
				invoke_var_setter(var_name = field, randomize = TRUE)

