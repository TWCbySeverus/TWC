var/list/parties_list = list()

mob/var/tmp/party=""

proc/check_party(party)
	for(var/obj/a in parties_list)
		if(a.name==party)
			return a


party
	parent_type=/obj
	var/list/members = list()
	Party


obj/hud/Leave
	name = "Party Leave"
	icon = 'HUD.dmi'
	icon_state = "leave"
	screen_loc = "EAST-1,NORTH-5"
	Click()
		usr:Leave()

obj/hud/Chat
	name = "Party Chat"
	icon = 'HUD.dmi'
	icon_state = "chat"
	screen_loc = "EAST-1,NORTH-4"
	Click()
		usr:Party_Chat(input("Type in Party Chat") as text)
obj/hud/Kick
	name = "Party Kick"
	icon = 'HUD.dmi'
	icon_state = "kick"
	screen_loc = "EAST-1,NORTH-6"
	Click()
		usr:Kick()
obj/hud/Disband
	name = "Party Disband"
	icon = 'HUD.dmi'
	icon_state = "disband"
	screen_loc = "EAST-1,NORTH-7"
	Click()
		usr:Disband()
obj/hud/team
	name		    = "Party"
	icon			= 'HUD.dmi'
	icon_state		= "team"
	screen_loc 		= "EAST-1,NORTH-3"
	Click()
		var/list/choosin = list()
		var/mobs = 0
		for(var/mob/M in oview())
			if(M.key&&M.party=="")
				choosin += M
				mobs++
		if(usr.name=="Deatheater")
			usr<<"You can't create a party while using clan robes."
			return 0
		if(usr.party=="")
			if(mobs>0)
				choosin += "Exit"
				var/mob/M = input("Choose Player") in choosin
				if(M!="Exit")
					if(alert(M,"Would you like to join [usr.name]'s Party?","Party Request","Yes","No")=="Yes")
						if(usr.party=="")
							var/party/Party/p = new()
							for(var/mob/Z in world)
								if(Z.party=="[usr.name] Party")
									Z.party=""
									Z:In_Party()
							p.name="[usr.name] Party"
							if(p.members.len>3)
								M<<"Party is already full."
							else
								p.members += usr
								p.members += M
								p.owner=usr.ckey
								parties_list.Add(p)
								//add people to party
								usr.party="[usr.name] Party"
								M.party="[usr.name] Party"
								//invitee
								M:In_Party()
								usr:In_Party()
						else
							usr:In_Party()
							var/party/Party/p = check_party(usr.party)
							if(p.members.len>3)
								usr<<"Party is full."
							else
								if(/mob/Party/verb/Invite in usr.verbs)
									if(mobs>0)
										usr:Invite(M)
								else
									usr<<"You can't invite people to the party."
			else
				usr<<"There's no one around to invite!"
		else
			var/party/Party/p = check_party(usr.party)
			if(p.members.len>3)
				usr<<"Party is full."
			else
				if(/mob/Party/verb/Invite in usr.verbs)
					if(mobs>0)
						choosin += "Exit"
						var/mob/M = input("Choose Player") in choosin
						if(M!="Exit")usr:Invite(M)
					else
						usr<<"There's no one around to invite!"
				else
					usr<<"You can't invite people to the party."


mob/Player/proc/party_hub()
	var/party/Party/ow = check_party(src.party)
	src.Interface=null
	src.client.screen=list()
	src.Interface=new(src)
	src:Interface.Update()
	Interface.Update()
	if(src.party!="")
		src:clean_up_screen()
		var/obj/hud/team/partyt = new()
		src.client.screen += partyt
		var/obj/hud/Leave/lv = new()
		var/obj/hud/Chat/pchat = new()
		src.client.screen+=lv
		src.client.screen+=pchat
		if(ow.owner==src.ckey)
			var/obj/hud/Kick/kky = new()
			src.client.screen+=kky
			var/obj/hud/Disband/ddy = new()
			src.client.screen+=ddy
	else
		src:clean_up_screen()
proc/reload_party(party)
	var/party/Party/Z = party
	Z.members=list()
	for(var/mob/M in world)
		if(M.party==Z.name)
			Z.members+=M
	if(length(Z.members)<2)
		for(var/mob/M in world)
			if(M.party==Z.name)
				M.party=""
				M<<"The party has been disbanded."
				M:Interface.Update()
				M:In_Party()
		parties_list-=Z
		del Z
mob/Party/verb
	Invite(mob/Player/P in oview())
		if(P.party=="")
			Join_Party(usr.party,P)
		else
			usr<<"[P] is already in a party."
	Kick(mob/P in (check_party(usr.party).members))
		var/party/Party/Z = check_party(usr.party)
		Z.members-=P
		P<<"You got kicked from [usr.party]."
		P.party=""
		P:In_Party()
		reload_party(Z)
	Leave()
		var/party/Party/Z = check_party(usr.party)
		var/old_party=usr.party
		usr.party=""
		usr:In_Party()
		Z.members=list()
		if(Z.name=="[usr.name]'s Party")Z.name=""
		for(var/mob/M in world)
			if(M.key&&M.party==old_party)
				if(Z.name=="")
					Z.name = "[M.name]'s Party"
				Z.members+=M
				M.party=Z.name
		for(var/mob/Player/M in Z.members)
			M:In_Party()
		reload_party(Z)
	Party_Chat(var/t as text)
		var/party/Party/Z = check_party(usr.party)
		for(var/mob/M in Z.members)
			M<<"<font color=white><b>(party chat)</font><font color=red>[usr] </b></font>: [html_decode(t)]"
			chatlog<<"<br><font color=white><b>(party chat)</font><font color=red>[usr] </b></font>: [html_decode(t)]<br>"
	Disband()
		var/party/Party/Par = check_party(usr.party)
		for(var/mob/M in world)
			if(M.party==Par.name)
				Par.members-=M
				M.party=""
				M:In_Party()
				M<<"The party has been disbanded."
		parties_list-=Par
		del Par
proc/Join_Party(party/P,mob/user)
	var/party/Party/Z = check_party(P)
	if(Z.members.len>3)
		usr<<"The party is full."
	else
		if(alert(user,"Would you like to join [Z.name]'s party?","Party Request","Yes","No")=="Yes")
			if(Z.members.len>3)
				usr<<"The party is full."
			else
				Z.members+=user
				user.party=Z.name
				user:In_Party()
				reload_party(Z)



mob/Player/proc/In_Party()
	if(src.party!="")
		var/party/Party/Z=check_party(src.party)
		if(Z.name=="[src.name]'s Party")
			src.verbs+=/mob/Party/verb/Invite
			src.verbs+=/mob/Party/verb/Kick
			src.verbs+=/mob/Party/verb/Disband
		src.verbs+=/mob/Party/verb/Leave
		src.verbs+=/mob/Party/verb/Party_Chat
	else
		src.verbs-=/mob/Party/verb/Disband
		src.verbs-=/mob/Party/verb/Invite
		src.verbs-=/mob/Party/verb/Kick
		src.verbs-=/mob/Party/verb/Leave
		src.verbs-=/mob/Party/verb/Party_Chat
	src:party_hub()


