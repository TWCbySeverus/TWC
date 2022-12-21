#define WORN 1
#define REMOVED 2

obj/items/wearable/brooms
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && (owner.loc.loc:antiFly||istype(owner.loc.loc, /area/nofly)||istype(owner.loc.loc,/area/arenas)||istype(owner.loc.loc,/area/ministry_of_magic)))
			owner << errormsg("You cannot fly here.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.findStatusEffect(/StatusEffect/Knockedfrombroom))
			owner << errormsg("You can't get back on your broom right now because you were recently knocked off.")
			return
		if(owner.trnsed && !owner.derobe || (owner.derobe && owner.icon != 'Deatheater.dmi') || (owner.derobe && owner.icon != 'HDE.dmi'))
			owner << errormsg("You can't fly while transfigured.")
			return
		if(locate(/obj/items/wearable/invisibility_cloak) in owner.Lwearing)
			owner << errormsg("Your cloak isn't big enough to cover you and your broom.")
			return
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] jumps on \his [src.name].")
			owner.density = 0
			owner.flying = 1
			if(owner.derobe)
				owner.overlays -= src.icon
			owner.icon_state = "flying"
			for(var/obj/items/wearable/brooms/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] dismounts from \his [src.name].")
			owner.density = 1
			owner.flying = 0
			owner.icon_state = ""
obj/items/wearable/brooms/firebolt
	icon = 'firebolt_broom.dmi'
obj/items/wearable/brooms/nimbus_2000
	icon = 'nimbus_2000_broom.dmi'
obj/items/wearable/brooms/cleansweep_seven
	icon = 'cleansweep_seven_broom.dmi'

