#define WORN 1
#define REMOVED 2
mob/Player/var/list/Lwearing

area
	var/tmp
		antiTheft    = FALSE
		antiTeleport = FALSE
		antiFly      = FALSE

	inside
		antiTheft
			antiTheft = TRUE
			antiFly   = TRUE
		antiTeleport
			antiTeleport = TRUE
			antiFly      = TRUE

	Entered(atom/movable/Obj,atom/OldLoc)
		.=..()
		if(isplayer(Obj))
			Obj:nofly()

obj/items
	var
		dropable    = 1
		takeable    = 1
		destroyable = 0
		price       = 0

	mouse_over_pointer = MOUSE_HAND_POINTER

obj/items/Click()
	if((src in oview(1)) && takeable)
		Take()
	..()
obj/items/verb/Take()
	set src in oview(1)

	if(loc.loc:antiTheft && owner && owner != usr.ckey)
		usr << errormsg("This item isn't yours, a charm prevents you from picking it up.")
		return

	viewers() << infomsg("[usr] takes \the [src.name].")
	loc = usr
	usr.Resort_Stacking_Inv()

obj/items/verb/Drop()
	set src in usr
	var/mob/Player/owner = usr
	loc = owner.loc
	src.owner = usr.ckey
	viewers(owner) << infomsg("[owner] drops \his [src.name].")
	owner.Resort_Stacking_Inv()
obj/items/MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
	if(isturf(over_object))
		if(src in usr)
			if(dropable && destroyable)
				switch(alert("Do you wish to drop or destroy this item?","","Drop","Destroy","Cancel"))
					if("Drop")
						if(src in usr)Drop(usr)
					if("Destroy")
						if(src in usr)Destroy(usr)
			else if(dropable)
				Drop(usr)
			else if(destroyable)
				Destroy(usr)
	..()

obj/items/verb/Examine()
	set src in view(3)
	usr << infomsg("<i>[desc]</i>")
obj/items/proc/Destroy(var/mob/Player/owner)
	if(alert(owner,"Are you sure you wish to destroy your [src.name]?",,"Yes","Cancel") == "Yes")
		var/obj/item = src
		src = null
		del(item)
		owner.Resort_Stacking_Inv()
		return 1

obj/items/New()


	spawn(1) // spawn will ensure this works on edited items as well
		if(!src.desc)
			src.verbs -= /obj/items/verb/Examine

		if(!src.dropable)
			src.verbs -= /obj/items/verb/Drop
			src.verbs -= /obj/items/wearable/Drop
		if(!src.takeable)
			src.verbs -= /obj/items/verb/Take
	..()


obj/items/wearable
	icon_state = "item"
	var/showoverlay = 1
	var/wear_layer = FLOAT_LAYER - 5

	var
		const
			NOUPGRADE = -1 // -1 can't be upgraded
			UPGRADE   = 0  // 0  can be upgraded
			DAMAGE    = 1  // 1 damage
			DEFENSE   = 2  // 2 defense

		bonus   = NOUPGRADE
		quality = 0

obj/items/wearable/Destroy(var/mob/Player/owner)
	. = ..(owner)
	if(. == 1) //If user chooses to destroy
		if(src in owner.Lwearing)
			owner.Lwearing.Remove(src)
obj/items/wearable/Drop()
	var/mob/Player/owner = usr
	if(src in owner.Lwearing)
		Equip(owner)
	..()
obj/items/wearable/verb/Wear()
	if(src in usr)
		Equip(usr)
obj/items/wearable/Click()
	if(src in usr)
		Equip(usr)
	..()
obj/items/focus_amulet
	icon='amulet.dmi'
	icon_state=""
	dropable=0
	dragandrop=0
	var/def_animal='patronus.dmi'
	var/animal='patronus.dmi'
	Click()
		Equip()
	verb/Equip()
		if(usr.patronus_mode==2)
			usr.patronus_mode=1
			src.suffix=""
			usr.focus_animal=src.def_animal
		else
			usr.patronus_mode=2
			src.suffix = "<font color=blue>(Worn)</font>"
			usr.focus_animal=src.animal

obj/items/wearable/proc/Equip(var/mob/Player/owner)
	src.gender = owner.gender
	if(src in owner.Lwearing)
		owner.Lwearing.Remove(src)
		if(!owner.Lwearing) owner.Lwearing = null// deinitiliaze the list if not in use
		if(showoverlay)
			var/obj/o = new
			o.icon = src.icon
			o.layer = wear_layer
			owner.overlays -= o
		src.suffix = null
		if(bonus != -1)
			if(bonus & DAMAGE)
				owner.clothDmg -= 300 * quality
			if(bonus & DEFENSE)
				owner.clothDef -= 350 * quality
				owner.resetMaxHP()
		return REMOVED
	else
		if(showoverlay && !owner.trnsed)
			var/obj/o = new
			o.icon = src.icon
			o.layer = wear_layer
			owner.overlays += o
		suffix = "<font color=blue>(Worn)</font>"
		if(!owner.Lwearing) owner.Lwearing = list()
		owner.Lwearing.Add(src)
		if(bonus != -1)
			if(bonus & DAMAGE)
				owner.clothDmg += 300 * quality
			if(bonus & DEFENSE)
				owner.clothDef += 350 * quality
				owner.resetMaxHP()
		return WORN
