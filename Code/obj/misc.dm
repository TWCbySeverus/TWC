#define WORN 1
#define REMOVED 2

obj/items/pokeby
	icon = 'pokeby.dmi'
	desc = "Aww, isn't it cute?"



obj/items/trophies
	name = "Trophy"
	icon = 'trophies.dmi'
	Gold
		icon_state = "Gold"
	Yellow
		icon_state = "Yellow"
	Silver
		icon_state = "Silver"
	Bronze
		icon_state = "Bronze"
	desc = "It's blank!"

	New()
		..()
		spawn(1)
			if(desc != initial(desc))
				src.verbs -= /obj/items/trophies/verb/Inscribe

	verb/Inscribe()
		var/input = input("This trophy can only be written on once. What do you want it to say?") as null|text
		if(!input)return
		desc = input
		src.verbs.Remove(/obj/items/trophies/verb/Inscribe)


obj/items/bucket
	icon = 'bucket.dmi'

obj/items/wearable/halloween_bucket
	icon = 'halloween_bucket.dmi'
	dropable = 0
	desc = "A bucket of candy from halloween!"
	wear_layer = FLOAT_LAYER - 4
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] pulls out \his [src.name].")
			for(var/obj/items/wearable/halloween_bucket/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
	Click()
		if(src in usr)
			var/StatusEffect/S = usr.findStatusEffect(/StatusEffect/UsedHalloweenBucket)
			if(S && S.cantUseMsg(usr))
				return
			new /StatusEffect/UsedHalloweenBucket(usr,30)
			var/newtype = pick(typesof(/obj/items/food) - /obj/items/food)
			var/obj/O = new newtype (usr)
			O.gender = usr.gender
			viewers(usr) << infomsg("[usr] pulls \a [O] out of \his halloween bucket.")
			usr:Resort_Stacking_Inv()
		else
			..()

obj/items/scroll
	icon = 'Scroll.dmi'
	destroyable = 1
	accioable=1
	wlable = 1
	var/content
	var/tmp/inuse = 0
	New()
		..()
		pixel_x = rand(-5,5)
		pixel_y = rand(-5,5)
	Click()
		if(src in usr)
			usr << browse(content)
		else ..()
	verb
		Name(msg as text)
			set name = "Name Scroll"
			if(msg == "") return
			if(inuse)
				usr << "<font color=white>The scroll is currently being used.</font>"
				return
			src.name = copytext(html_encode(msg),1,25)
		write()
			set name = "Write"
			inuse = 1
			var/msg = input("What would you like to write on the scroll?","Write on scroll") as null|message
			if(!msg)
				inuse = 0
				return
			msg = copytext(msg,1,1000)
			msg = dd_replacetext(msg,"\n","<br>")
			content += "<body bgcolor=black><u><font color=blue><b><font size=3>[name]</u><p><font color=red><font size=1>by [usr] <p><p><font size=2><font color=white>[msg] <p>"
			src.icon_state = "wrote"
			inuse = 0