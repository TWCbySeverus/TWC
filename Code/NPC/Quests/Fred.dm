obj
	inside_roof
		end_roof
			layer=MOB_LAYER+1
			icon='NTurfs.dmi'
			icon_state="end_roof"
		Hogwarts_Roof_Edge
			layer=MOB_LAYER+1
			icon='NTurfs.dmi'
			icon_state="hogwarts end roof"
		Green_Roof_Edge
			layer=MOB_LAYER+1
			icon='NTurfs.dmi'
			icon_state="green roof end"
obj
	Quests
		Fred
			Barrier
turf
	Quest
		Fred
			Barrier_Lock
				flyblock=1
				Enter(mob/Player/M)
					if("On House Arrest" in M.questPointers)
						var/questPointer/pointer = M.questPointers["On House Arrest"]
						if(!pointer.stage)return 1
						else return 0
					else return 0
mob/proc/Its()
	var/mob/Player/M = src
	if("On House Arrest" in M.questPointers)
		var/questPointer/pointer = M.questPointers["On House Arrest"]
		if(!pointer.stage)
			for(var/image/C in client.images)
				if(C.icon=='Fredb.dmi')
					client.images.Remove(C)
		else
			M.add_freds_barrier()
	else
		M.add_freds_barrier()


mob/proc/add_freds_barrier()
	for(var/obj/Quests/Fred/Barrier/MB in world)
		if(MB.z==18)
			var/image/i=new('Fredb.dmi')
			usr<<i
			i.loc = MB.loc
/*
	if("On House Arrest" in M.questPointers)
		var/questPointer/pointer = M.questPointers["On House Arrest"]
		if(!pointer.stage)
			M.Transfer(locate("@Fred"))
			return
	M.Transfer(locate("@FredTrap"))
*/