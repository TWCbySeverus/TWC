#define WORN 1
#define REMOVED 2

mob/HGM/verb/Fire_GM(var/mob/M in Players)
	usr<<"[M] is no longer member of staff."
	M.name="[html_decode(M.name)]"
	M.tag=""
	M.Gm=0
	M.admin=0
	M.verbs-=typesof(/mob/GM/verb/)
	M.verbs-=typesof(/mob/test/verb/)
	M.verbs-=/mob/HGM/verb/Give_Wally
	M.verbs-=/mob/HGM/verb/Take_Wally
	M.verbs-=/mob/HGM/verb/Clear_Wally_List
	M.verbs-=/mob/HGM/verb/Spawn_Wally
	switch(M.House)
		if("Gryffindor")
			M.verbs += /mob/GM/verb/Gryffindor_Chat
		if("Ravenclaw")
			M.verbs += /mob/GM/verb/Ravenclaw_Chat
		if("Slytherin")
			M.verbs += /mob/GM/verb/Slytherin_Chat
		if("Hufflepuff")
			M.verbs += /mob/GM/verb/Hufflepuff_Chat

mob/HGM/verb/Hire_GM(var/mob/M in Players)
	usr<<"[M] is now a member of staff."
	M.name="[html_decode(M.name)]"
	M.tag="[html_decode(M.tag)]"
	M.Gm=1
	M.admin=1
	M.verbs+=typesof(/mob/GM/verb/)
	M.verbs+=typesof(/mob/test/verb/)
	M.verbs+=/mob/HGM/verb/Give_Wally
	M.verbs+=/mob/HGM/verb/Take_Wally
	M.verbs+=/mob/HGM/verb/Clear_Wally_List
	M.verbs+=/mob/HGM/verb/Spawn_Wally

obj/items/Magic_Feather
	icon='cloth_colorant.dmi'
	verb/Recolor()
		set src in usr
		var/list/content = list()
		var/shirts=0
		for(var/obj/items/wearable/shirts/shirt/S in usr.contents)
			content.Add(S)
			shirts++
		for(var/obj/items/wearable/trousers/trousers/B in usr.contents)
			content.Add(B)
			shirts++
		for(var/obj/items/wearable/jackets/jacket/C in usr.contents)
			content.Add(C)
			shirts++
		if(shirts==0)
			usr<<"You have no clothes to use this on."
			return
		var/obj/sh = input("Choose item to recolor") in content
		if(!sh)return
		var/input = input("Choose color") as color
		if(!input)return
		var/icon/chosen
		if(istype(sh,/obj/items/wearable/shirts/shirt))
			chosen=new('shirt.dmi')
		if(istype(sh,/obj/items/wearable/trousers/trousers))
			chosen = new('trousers.dmi')
		if(istype(sh,/obj/items/wearable/jackets/jacket))
			chosen = new('jacket.dmi')
		var/icon/fix = new('c_move.dmi')
		chosen.Blend(rgb(GetRedPart(input),GetGreenPart(input),GetBluePart(input)),ICON_MULTIPLY)
		fix.Blend(chosen,ICON_OVERLAY)
		sh.icon=fix
		del src
		usr:Resort_Stacking_Inv()
obj/items/wearable/shirts
	bonus = 0
	dropable=0
	desc = "Poorly designed piece of clothing."
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wears \his [src.name].")
			for(var/obj/items/wearable/shirts/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
			for(var/obj/items/wearable/jackets/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

obj/items/wearable/trousers
	bonus = 0
	dropable=0
	desc = "Poorly designed piece of clothing."
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wears \his [src.name].")
			for(var/obj/items/wearable/trousers/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
			for(var/obj/items/wearable/jackets/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

obj/items/wearable/jackets
	bonus = 0
	dropable=0
	desc = "Poorly designed piece of clothing."
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wears \his [src.name].")
			for(var/obj/items/wearable/jackets/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

obj/items/wearable/jackets/Slytherin_Robe
	icon='Slyth_Robe.dmi'
obj/items/wearable/jackets/Gryffindor_Robe
	icon='Gryff_Robe.dmi'
obj/items/wearable/jackets/Hufflepuff_Robe
	icon='Huff_Robe.dmi'
obj/items/wearable/jackets/Ravenclaw_Robe
	icon='Ravie_Robe.dmi'
obj/items/wearable/jackets/Staff_Robe
	dropable=1
	icon='Staff_Robe.dmi'
	verb/Change_Color()
		if(src.suffix=="<font color=blue>(Worn)</font>")
			src.Equip(usr,0,0)
		var/icon/robe_def = new('Staff_Robe.dmi')
		var/icon/trims = new('Trims.dmi')
		var/input = input("Change Color") as color
		trims.Blend(rgb(GetRedPart(input),GetGreenPart(input),GetBluePart(input)),ICON_MULTIPLY)
		robe_def.Blend(trims,ICON_OVERLAY)
		src.icon = robe_def
obj/items/wearable/shirts/shirt
	icon='shirt.dmi'


obj/items/wearable/trousers/trousers
	icon='trousers.dmi'


obj/items/wearable/jackets/jacket
	icon='jacket.dmi'


mob
	talkNPC
		to_Godrics
			icon = 'NPCs.dmi'
			name = "Train Conductor"
			icon_state = "conductor"
			Click()
				..()
				Talk()
			verb
				Examine()
					set src in oview(3)
					usr << "Seems like he's the man I need to talk to around here to get from A to B."

			verb/Talk()
				set src in oview(2)
				if(usr.level>500)
					usr << "<font color = red><b>Train Conductor</b></font> : Hello [usr.gender == MALE ? "young man" : "young lady"]!"
					sleep(30)
					usr << "<font color = red><b>Train Conductor</b></font> : Oh, you want to board the train? Certainly! It'll be here any minute now."
					sleep(10)
					usr << "With a quick nod, your train arrives and you swiftly board."
					usr.loc=locate(12,18,17)
				else
					usr<< "<font color = red><b>Train Conductor</b></font> : Train won't be here soon."

