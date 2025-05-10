/datum/chameleon_card_forging_interface
	var/name = "Chameleon Card Forge"
	// The card that is being forged
	var/obj/item/card/id/advanced/chameleon/my_card

/datum/chameleon_card_forging_interface/New(mob/living/user, obj/item/card/id/advanced/chameleon/forging_card)
	. = ..()
	if(!istype(forging_card) || !istype(user))
		return
	my_card = forging_card
	ui_interact(user)

/datum/chameleon_card_forging_interface/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChameleonCardForge", name)
		ui.open()

/datum/chameleon_card_forging_interface/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/chameleon_card_forging_interface/ui_data(mob/user)
	var/list/data = list()
	data["current_name"] = (my_card.registered_name ||= "None")
	data["current_assignment"] = (my_card.assignment ||= "None")
	data["current_trim"] = (my_card.trim ||= "None")
	data["current_age"] = my_card.registered_age || 25
	data["currently_wallet_spoofing"] = HAS_TRAIT(my_card, TRAIT_MAGNETIC_ID_CARD)
	return data
