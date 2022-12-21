obj/hud/screentext

	quest
		screen_loc = "WEST+1,SOUTH+1"
		maptext_width  = 320
		maptext_height = 320

		proc/update(mob/Player/p)
			maptext = null
			var/count = 0
			for(var/questName in p.questPointers)
				var/questPointer/pointer = p.questPointers[questName]
				if(!pointer.stage) continue
				if(!pointer.track) continue
				count++
				if(count > 4) break

				maptext = "[maptext]<b>[questName]</b><br>"
				for(var/i in pointer.reqs)
					maptext += "  - [i]: [pointer.reqs[i]]<br>"
			if(maptext)
				maptext = "<font color=[p.mapTextColor]>[maptext] </font>"
obj/hud/PMHome
	name = "Private Messaging"
	icon = 'HUD.dmi'
	icon_state = "PM"
	screen_loc = "EAST-1,NORTH"
	mouse_over_pointer = MOUSE_HAND_POINTER
	Click()
		var/mob/Player/M = usr
		M.PMHome()
obj/hud/reading
	icon = 'HUD.dmi'
	icon_state = "reading"
	screen_loc = "EAST-4,NORTH"


obj/hud/Meditate
	name		    = "Meditate"
	icon			= 'HUD.dmi'
	icon_state		= "meditate"
	screen_loc 		= "EAST-1,NORTH-1"
	Click()
		usr:Meditate()
obj/hud/Statpoint
	name		    = "Statpoint"
	icon			= 'HUD.dmi'
	icon_state		= "statpoint"
	screen_loc 		= "EAST-1,1"
	Click()
		usr:Use_Statpoints()

obj/hud/Who
	name		    = "WHO"
	icon			= 'HUD.dmi'
	icon_state		= "who"
	screen_loc 		= "EAST-1,NORTH-2"
	Click()
		usr:Who()

obj/hud/
	questbook
		name="Quest Book"
		icon='questbook.dmi'
		screen_loc 		= "EAST-2,NORTH"

		Click()
			..()
			var/mob/Player/p = usr
			p.buildQuestBook()