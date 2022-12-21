#define WORN 1
#define REMOVED 2

obj/items/wearable/scarves
	bonus = 0
	desc = "A finely knit scarf designed to keep your neck toasty warm."
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wraps \his [src.name] around \his neck.")
			for(var/obj/items/wearable/scarves/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")
obj/items/wearable/scarves/yellow_scarf
	icon = 'scarf_yellow.dmi'
obj/items/wearable/scarves/black_scarf
	icon = 'scarf_black.dmi'
obj/items/wearable/scarves/blue_scarf
	icon = 'scarf_lightblue.dmi'
	name = "light blue scarf"
obj/items/wearable/scarves/darkblue_scarf
	icon = 'scarf_darkblue.dmi'
	name = "dark blue scarf"
obj/items/wearable/scarves/cyan_scarf
	icon = 'scarf_cyan.dmi'
obj/items/wearable/scarves/green_scarf
	icon = 'scarf_green.dmi'
obj/items/wearable/scarves/grey_scarf
	icon = 'scarf_grey.dmi'
obj/items/wearable/scarves/orange_scarf
	icon = 'scarf_orange.dmi'
obj/items/wearable/scarves/pink_scarf
	icon = 'scarf_lightpink.dmi'
	name = "light pink scarf"
obj/items/wearable/scarves/darkpink_scarf
	icon = 'scarf_darkpink.dmi'
	name = "dark pink scarf"
obj/items/wearable/scarves/purple_scarf
	icon = 'scarf_lightpurple.dmi'
	name = "light purple scarf"
obj/items/wearable/scarves/darkpurple_scarf
	icon = 'scarf_darkpurple.dmi'
	name = "dark purple scarf"
obj/items/wearable/scarves/red_scarf
	icon = 'scarf_red.dmi'
obj/items/wearable/scarves/teal_scarf
	icon = 'scarf_teal.dmi'
obj/items/wearable/scarves/white_scarf
	icon = 'scarf_white.dmi'
obj/items/wearable/scarves/duel_scarf
	icon = 'scarf_dueling.dmi'

obj/items/wearable/scarves/lucifer_scarf
	icon = 'scarf_lucifer.dmi'
	name = "Lucifer's Scarf"
obj/items/wearable/scarves/lucifer2_scarf
	icon = 'scarf_lucifer2.dmi'
	name = "Lucifer's Scarf"
obj/items/wearable/scarves/casimir_scarf
	icon = 'scarf_casimir.dmi'
	name = "Casimir's Scarf"
obj/items/wearable/scarves/royale_scarf
	icon = 'scarf_royale.dmi'

//Holiday//
obj/items/wearable/scarves/candycane_scarf
	icon = 'scarf_candycane.dmi'
obj/items/wearable/scarves/american_scarf
	icon = 'scarf_american.dmi'
obj/items/wearable/scarves/halloween_scarf
	icon = 'scarf_halloween.dmi'
obj/items/wearable/scarves/pastel_scarf
	icon = 'scarf_pastel.dmi'
/////////
