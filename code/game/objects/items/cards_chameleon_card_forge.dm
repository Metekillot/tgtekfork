/datum/chameleon_card_forge
	var/obj/item/card/id/advanced/chameleon/my_card


/datum/chameleon_card_forge/New(mob/user, obj/item/card/id/advanced/chameleon/physical_card)
	if(!user || !physical_card)
		qdel(src)
		return
	my_card = physical_card
	ui_interact(user)
	return src

