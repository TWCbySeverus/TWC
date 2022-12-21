#define WORN 1
#define REMOVED 2

obj/items/wearable/hats
	wear_layer = FLOAT_LAYER - 4
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] puts on \his [src.name].")
			for(var/obj/items/wearable/hats/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
obj/items/wearable/hats/crown
	icon = 'crown.dmi'
obj/items/wearable/hats/tiara
	icon = 'tiara.dmi'
obj/items/wearable/hats/christmas_hat
	icon = 'xmas_hat.dmi'
	dropable = 1
obj/items/wearable/hats/bunny_ears
	icon = 'bunny_ears_hat.dmi'
	dropable = 1
obj/items/wearable/hats/blue_earmuffs
	icon = 'blue_earmuffs_hat.dmi'
obj/items/wearable/hats/white_earmuffs
	icon = 'white_earmuffs_hat.dmi'
obj/items/wearable/hats/green_earmuffs
	icon = 'green_earmuffs_hat.dmi'
obj/items/wearable/hats/red_earmuffs
	icon = 'red_earmuffs_hat.dmi'
obj/items/wearable/hats/yellow_earmuffs
	icon = 'yellow_earmuffs_hat.dmi'