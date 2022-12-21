/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/var/StatMan
mob
	TalkNPC
		icon = 'NPCs.dmi'
		mouse_over_pointer = MOUSE_HAND_POINTER

		density = 1
		Immortal = 1
		NPC = 1
		Gm=1

		verb
			Talk()

		Click()
			if(src in oview(3))
				Talk()
			else
				usr << errormsg("You need to be closer.")

		StatChangeMan
			name = "Demetrius"
			icon_state = "goblin1"

			Talk()
				set src in oview(3)
			/*	if(usr.level < lvlcap)
					hearers(usr) << npcsay("Demetrius: Well hello there, [usr.gender == MALE ? "sonny" : "young lady"]. Unfortunately I cannot help you until you are of a higher level!")
				else*/
				if(usr.gold < 50000)
					hearers(usr) << npcsay("<font color = red><b>Demetrius </font></b>: Well hello there, [usr.gender == MALE ? "sonny" : "young lady"]. Unfortunately you need 50,000 gold before I am able to help you.")
				else
					switch(alert("Would you like to reset your stat points? It will cost 50,000 gold.",,"Yes","No"))
						if("Yes")
							if(usr.gold >= 50000)
								hearers(usr) << npcsay("<font color = red><b>Demetrius </font></b>: There you go, [usr.gender == MALE ? "sonny" : "young lady"] - your stats are reset!")
								usr.gold -= 50000
								usr.resetStatPoints()
								usr.HP = usr.MHP + usr.extraMHP
								usr.MP = usr.MMP + usr.extraMMP
								usr.updateHPMP()
						if("No")
							hearers(usr) << npcsay("<font color = red><b>Demetrius </font></b>: Maybe next time then. Have a nice day!")

		StatMan
			name="Mysterious Caped Fellow"
			icon_state="stat"

			verb
				Examine()
					set src in oview(3)
					usr << "I like his cape."
			Talk()
				set src in oview(3)
				switch(alert("Hello there... My name is not important, however I have a few special services I can offer you for a price...","Mysterious Caped Fellow", "Rename - 25 Spell Points", "Reset Kills/Deaths - 60 Spell Points", "No Thanks"))
					if("Reset Kills/Deaths - 60 Spell Points")
						if(usr:spellpoints >= 60)
							usr:spellpoints -= 60
							usr.pdeaths = 0
							usr.pkills = 0
							usr << infomsg("Your player kills and deaths have been reset.")
						else
							usr << errormsg("You don't have enough spell points. You need [60 - usr:spellpoints] more spell points.")
					if("Rename - 25 Spell Points")
						if(usr.derobe||usr.aurorrobe)
							usr << errormsg("You can not do this while wearing clan robes.")
							return
						if(usr:spellpoints >= 25)
							var/mob/create_character/c = new
							var/desiredname = input("What name would you like? (Keep in mind that you cannot use a popular name from the Harry Potter franchise, nor numbers or special characters)") as text|null
							if(!desiredname)
								del c
								return
							var/passfilter = c.name_filter(desiredname)
							while(passfilter)
								alert("Your desired name is not allowed as it [passfilter].")
								desiredname = input("Please select a name that does not use a popular name from the Harry Potter franchise, nor numbers or special characters.") as text|null
								if(!desiredname)
									del c
									return
								passfilter = c.name_filter(desiredname)
							del c
							if(name == desiredname) return
							Log_admin("[usr] has changed their name to [desiredname].")
							usr.name = desiredname
							usr.underlays = list()
							switch(usr.House)
								if("Hufflepuff")
									usr.GenerateNameOverlay(242,228,22)
								if("Slytherin")
									usr.GenerateNameOverlay(41,232,23)
								if("Gryffindor")
									usr.GenerateNameOverlay(240,81,81)
								if("Ravenclaw")
									usr.GenerateNameOverlay(13,116,219)
								if("Ministry")
									usr.GenerateNameOverlay(255,255,255)
							usr:spellpoints -= 25
						else
							usr << errormsg("You don't have enough spell points. You need [25 - usr:spellpoints] more spell points.")
		PyramidMan
			name="Mysterious Old Man"
			icon_state="pyramid"
			density=1
			Immortal=1

			verb
				Examine()
					set src in oview(3)
					usr << "I wonder how he got past the floating eyes..."

			Talk()
				set src in oview(3)
				alert("Go back the way you came...the pyramid is not ready to reveal itself yet...")
				alert("*The old man laughs very oddly*")
		VaultGoblin
			name="Vault Master"
			icon_state="goblinvault"

			Talk()
				set src in oview(2)
				if(worldData.globalvaults[usr.ckey])
					var/vault/V = worldData.globalvaults[usr.ckey]
					switch(input("What would you like to change about your vault?")as null|anything in list("Change who can enter my vault", "Transfer items from old vault to new vault"))
						if("Change who can enter my vault")
							if(V.allowedpeople && V.allowedpeople.len)
								switch(alert("Would you like to allow someone to enter your vault, or remove someone's permission from entering?",,"Allow someone","Deny someone","Cancel"))
									if("Allow someone")
										var/mob/Player/M = input("Who would you like to allow to enter your vault at any time?") as null|anything in Players(list(usr))
										if(M)
											if(V.allowedpeople.Find(M))
												usr<<"[M] is already in list"
											else
												if(istext(M))
													M = text2mob(M)
												V.allowedpeople+=M.ckey
											//	V.add_ckey_allowedpeople(M.ckey)
												usr << npcsay("<font color = red><b>Vault Master </font></b>: [M.prevname ? M.prevname : M.name] can now enter your vault at any time. See me again if you wish to change this.")
									if("Deny someone")
									//	var/list/name_ckey_assoc = V.name_ckey_assoc()
										var/M = input("Who would you like to deny entrance to vault?") as null|anything in V.allowedpeople
										if(M)
											V.allowedpeople-=M
										//	V.remove_ckey_allowedpeople(name_ckey_assoc[M])
											usr << npcsay("<font color = red><b>Vault Master </font></b>: [M] can no longer enter your vault.")
							else
								if(Players.len == 1)
									//Not any people to do anything with
									alert("There's nobody left you can add.")
									return
								var/mob/Player/M = input("Who would you like to allow to enter your vault at any time?") as null|anything in Players(list(usr))
								if(M)
									if(istext(M))
										M = text2mob(M)
									V.add_ckey_allowedpeople(M.ckey)
									usr << npcsay("<font color =red><b>Vault Master </font></b>: [M.prevname ? M.prevname : M.name] can now enter your vault at any time. See me again if you wish to change this.")
						else
							usr << npcsay("<font color = red><b>Vault Master </font></b>: See me again if you need to change anything with your vault.")

				else if(fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
					usr << npcsay("<font color = red><b>Vault Master </font></b>: Hi there.")
					worldData.globalvaults[usr.ckey] = new /vault()
					//Attempted fix for #373
				else
					if(alert("Do you want a free vault where you can store your belongings?","Vault","Yes","No") == "Yes")
						if(!fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
							usr << npcsay("<font color = red><b>Vault Master </font></b>: Okay, I've allocated you some space down in Vault [rand(10,99)][pick("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")]")
							usr << npcsay("<font color = red><b>Vault Master </font></b>: Anything you drop in there will be safely kept and available to you at any time. ((If you create a new character, your vault will retain its contents, so it's a good way to transfer your stuff if you want to remake.))")
							if(!islist(worldData.globalvaults))
								worldData.globalvaults = list()
							var/vault/v = new
							v.version = VAULT_VERSION
							worldData.globalvaults[usr.ckey] = v
							var/swapmap/map = SwapMaps_CreateFromTemplate("vault1")
							map.SetID("[usr.ckey]")
							map.Save()
					else
						usr << npcsay("<font color = red><b>Vault Master </font></b>: Maybe next time.")

		TrainMan
			name = "Train Conductor"
			icon_state = "conductor"

			verb
				Examine()
					set src in oview(3)
					usr << "Seems like he's the man I need to talk to around here to get from A to B."

			Talk()
				set src in oview(2)
				usr << "<font color = red><b>Train Conductor</b></font> : Hello [usr.Gender == FEMALE ? "young lady": "young man" ]!"
				sleep(30)
				usr << "<font color = red><b>Train Conductor</b></font> : Oh, you want to board the train? Certainly! It'll be here any minute now."
				sleep(10)
				usr << "With a quick nod, your train arrives and you swiftly board."
				usr.loc=locate(12,18,17)


		TrainManOnboard
			name = "Train Conductor"
			icon_state = "conductor"

			verb
				Examine()
					set src in oview(3)
					usr << "Seems like he's the man I need to talk to around here to get from A to B."

			Talk()
				set src in oview(2)
				usr << "<font color = red><b>Train Conductor</b></font> : Ready to get off? The train should be stopping any second now.. where are you going again?"
				var/turf/t
				if(alert("Where would you like to get off.","Pick a station?","Hogsmeade","Godric's Hollow")=="Hogsmeade")
					t = locate(2,80,18)
				else
					t = locate(8,43,17)
				if(t)
					sleep(10)
					usr:Transfer(t)
					usr << "As the conductor finishes his sentence, the train comes to a sudden stop. You compose yourself and get off."
