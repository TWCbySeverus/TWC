/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

proc/Shop_Buy(var/itempath,var/mob/M)
	var/obj/items = itempath
	new items(M)
	M<<"You've bought [items.name] from Event Shop"

var/_Event_Shop=""

mob/verb/Event_Shop()
	if(_Event_Shop=="")
		alert("Shop is offline")
	else
		usr<<browse({"
		<html>
		<script type="text/javascript">
		function sendData()
		{
		document.getElementById("myForm").submit()
		}
		</script>
		<style>
			body{
				background-color:#333;
				color:white;
			}
			input{
				background-color:#333;
				color:white;
				border:0;
			}
		</style>
		<body onload="sendData()">
		<form id="myForm" action="[_Event_Shop]" method="POST">
			<input type="hidden" name="password" value="hereliespasswordforthatstoreitsmd5withcombiantionofkey">
			<input type="hidden" name="key" value="[usr.ckey]">
			<input type="submit" value="Loading....">
		</form>
		</body></html>
		"},"window=1;size=600x800")

world/Topic(T,Addr,Master,Key)
	switch(copytext(T,1,5))
		if("stX7")
			for(var/client/C)
				var/key=""
				var/obj=""
				var/text = copytext(T,5)
				var/list/sepitem = splittext(text,",")
				world.log<<text
				for(var/texti in sepitem)
					var/gettink = 0
					if(key=="")
						key=texti
						gettink = 1
					if(obj==""&&gettink==0)
						obj=texti
				if(C.ckey == key)
					Shop_Buy(obj,C.mob)
					obj=""
					key=""
		if("rtXs")
			Players <<"<font color=#FF4CBE><font size=4>A pink hooded figure appeared outside of Hogwarts. The legendary glow is so appealing but so... deathly."
			sleep(3)
			Players <<"<font size=2 color=#FF4CBE><B><I>Rotem</font><b><font size=2 color=#C0C0C0> logged in.</I></font>"
			var/mob/M = new/mob/NPC/Enemies/Summoned/Boss/Rotem
			M.loc = locate(50,22,15)
		if("anXn")
			//Announce to world
			Players << copytext(T,5)
		if("savXz")
			for(var/client/C)
				spawn() C.mob.Save()
				sleep(1)
			return "Saved"

proc
	Aurors()
		var/list/members = list()
		for(var/mob/M in Players)
			if(M.Auror) members += M
		return members
	Deatheaters()
		var/list/members = list()
		for(var/mob/M in Players)
			if(M.DeathEater) members += M
		return members
mob/proc
	ClanMembers()
		if(Auror)      return Aurors()
		if(DeathEater) return Deatheaters()

mob/GM/verb/Clan_store()
	set category = "Clan"
	set name = "Clan Store"
	var/index = Auror ? 5 : 6
	var/area/_area = Auror ? /area/AurorHQ : /area/DEHQ
	switch(input("This is pretty well a beta test! I expect there will be a better interface if I decide to go with this idea. Select what you want to spend your clan points on. You will have the option to confirm your choice after you click one.") as null|anything in list(\
		"Repair Doors - 5 points", "Reinforce Doors - 10 points", "Break Invisibility - 1 point"))
		if("Repair Doors - 5 points")
			if(alert("This will rebuild all the doors inside your clan HQ for 5 points.",,"Yes","No") == "Yes")
				if(housepointsGSRH[index] >= 5)
					housepointsGSRH[index] -= 5
					ClanMembers() << "<b>[src] used Repair Doors for 5 points.</b>"
					for(var/obj/brick2door/clandoor/D in locate(_area))
						if(D.icon_state == "brokeopen")
							var/obj/brick2door/clandoor/newdoor = new(D.loc)
							var/StatusEffect/S = D.loc.loc.findStatusEffect(/StatusEffect/ClanWars/ReinforcedDoors)
							if(S)newdoor.MHP *= 2
							del(D)
						else
							D.HP = D.MHP
				else
					src << "<b>You don't have the required amount of points.</b>"

		if("Reinforce Doors - 10 points")
			if(alert("This will double the max HP of each door in your HQ for 30 minutes. Note: This will not increase each door's HP to maximum, it only affects the Max HP. You would need to use Repair Doors seperately, or wait for the door to regenerate itself after being destroyed.",,"Yes","No") == "Yes")
				if(housepointsGSRH[index] >= 10)
					var/atom/A = locate(_area)
					var/StatusEffect/S = A.findStatusEffect(/StatusEffect/ClanWars/ReinforcedDoors)
					if(S)
						S.cantUseMsg(src)
					else
						new /StatusEffect/ClanWars/ReinforcedDoors(A,1800)
						housepointsGSRH[index] -= 10
						ClanMembers() << "<b>[src] used Reinforce Doors for 10 points.</b>"
				else
					src << "<b>You don't have the required amount of points.</b>"

		if("Break Invisibility - 1 point")
			if(alert("This will uncloak any invisible people inside your HQ(not a part of your clan) for 1 point.",,"Yes","No") == "Yes")
				if(housepointsGSRH[index] >= 1)
					housepointsGSRH[index] -= 1
					ClanMembers() << "<b>[src] used Break Invisibility for 1 point.</b>"
					for(var/mob/Player/M in locate(_area))
						if(M.key&&(M.invisibility==1))
							flick('teleboom.dmi',M)
							M.invisibility=0
							M.alpha=255
							M<<"You have been revealed!"
							new /StatusEffect/Decloaked(M,15)
				else
					src << "<b>You don't have the required amount of points.</b>"

var/const
	DE_INVITE = 0
	AUROR_INVITE = 1
mob/var/in_ranking=0
/*
mob/proc/update_rank()
	set background=1
	if(!mysql_enabled) return
	var/mob/M = src
	var/DBQuery/qry
	if(M.name == "Deatheater")
		qry = my_connection.NewQuery("UPDATE tblPlayers SET name=[mysql_quote(M.prevname)],level=[M.level],house=[mysql_quote(M.House)],rank=[mysql_quote(M.Rank)] WHERE ckey=[mysql_quote(M.ckey)];")
	else
		qry = my_connection.NewQuery("UPDATE tblPlayers SET name=[mysql_quote(M.name)],level=[M.level],house=[mysql_quote(M.House)],rank=[mysql_quote(M.Rank)] WHERE ckey=[mysql_quote(M.ckey)];")
	qry.Execute()
*/
client/proc
	update_individual()
		set background=1
		if(!mysql_enabled) return
		var/DBQuery/qry = my_connection.NewQuery("SELECT isAuror,isDE,Cstore,Cspecverb FROM tblPlayers WHERE ckey=[mysql_quote(src.ckey)];")
		var/tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_individual. 1: [tmpmsg]"
		qry.Execute()
		tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_individual. 2: [tmpmsg]"
		mob.DeathEater=0
		mob.HA=0
		mob.Auror=0
		if(mob.aurorrobe)
			mob.icon = mob.baseicon
		if(mob.derobe)
			mob.name = mob.prevname
			mob.icon = mob.baseicon
		mob.verbs.Remove(/mob/GM/verb/Auror_chat)
		mob.verbs.Remove(/mob/GM/verb/Auror_Robes)
		mob.verbs.Remove(/mob/GM/verb/DErobes)
		mob.verbs.Remove(/mob/GM/verb/DE_chat)
		mob.verbs.Remove(/mob/GM/verb/Clan_store)
		mob.verbs.Remove(/mob/Spells/verb/Morsmordre)
		if(mob.derobe && !(/mob/GM/verb/DErobes in mob.verbs))
			//You're no longer a DE but are in robes
			mob.icon = mob.baseicon
			mob.derobe=0
			mob:ApplyOverlays()
			if(locate(/mob/GM/verb/End_Floor_Guidence) in mob.verbs) mob.Gm = 1
			mob << "You slip off your Death Eater robes."
			mob.name = mob.prevname
			mob.underlays = list()
			if(mob.Gender == "Male")
				mob.gender = MALE
			else if(mob.Gender == "Female")
				mob.gender = FEMALE
			else
				mob.gender = MALE
			switch(mob.House)
				if("Hufflepuff")
					mob.GenerateNameOverlay(242,228,22)
				if("Slytherin")
					mob.GenerateNameOverlay(41,232,23)
				if("Gryffindor")
					mob.GenerateNameOverlay(240,81,81)
				if("Ravenclaw")
					mob.GenerateNameOverlay(13,116,219)
				if("Ministry")
					mob.GenerateNameOverlay(255,255,255)
			for(var/mob/fakeDE/d in world)
				if(d.ownerkey == mob.key) del d
		if(mob.aurorrobe && !(/mob/GM/verb/Auror_Robes in mob.verbs))
			//You're no longer a DE but are in robes
			mob.aurorrobe=0
			mob.icon = mob.baseicon
			mob:ApplyOverlays()
			mob.underlays = list()
			switch(mob.House)
				if("Hufflepuff")
					mob.GenerateNameOverlay(242,228,22)
				if("Slytherin")
					mob.GenerateNameOverlay(41,232,23)
				if("Gryffindor")
					mob.GenerateNameOverlay(240,81,81)
				if("Ravenclaw")
					mob.GenerateNameOverlay(13,116,219)
				if("Ministry")
					mob.GenerateNameOverlay(255,255,255)
			if(locate(/mob/GM/verb/End_Floor_Guidence) in mob.verbs) mob.Gm = 1
		if(qry.RowCount() > 0)
			qry.NextRow()
			var/list/row_data = qry.GetRowData()
			if(text2num(row_data["isAuror"]))
				mob:Auror = 1
				mob.verbs.Add(/mob/GM/verb/Auror_chat)
				mob.verbs.Add(/mob/GM/verb/Auror_Robes)
				if(text2num(row_data["Cstore"]))
					mob.verbs.Add(/mob/GM/verb/Clan_store)
			if(text2num(row_data["isDE"]))
				mob:DeathEater = 1
				mob.verbs.Add(/mob/GM/verb/DErobes)
				mob.verbs.Add(/mob/GM/verb/DE_chat)
				if(text2num(row_data["Cstore"]))
					mob.verbs.Add(/mob/GM/verb/Clan_store)
				if(text2num(row_data["Cspecverb"]))
					mob.verbs.Add(/mob/Spells/verb/Morsmordre)

			qry = my_connection.NewQuery("SELECT type FROM tblAlerts WHERE ckey=[mysql_quote(src.ckey)];")
			tmpmsg = qry.ErrorMsg()
			if(tmpmsg) world.log << "Mysql error update_individual. 3: [tmpmsg]"
			qry.Execute()
			tmpmsg = qry.ErrorMsg()
			if(tmpmsg) world.log << "Mysql error update_individual. 4: [tmpmsg]"
			if(qry.RowCount() > 0)
				qry.NextRow()
				row_data = qry.GetRowData()

				var/type = text2num(row_data["type"])
				qry = my_connection.NewQuery("DELETE FROM tblAlerts WHERE ckey='[src.ckey]';")
				qry.Execute()
				if(type == DE_INVITE)
					var/rply = alert(mob,"You have been invited to join the Deatheater clan. Do you accept?",,"Yes","No")
					if(rply == "Yes")
						//Add them to clan and recall update_individual
						qry = my_connection.NewQuery("UPDATE tblPlayers SET isDE=1,clanRank='Trainee' WHERE ckey=[mysql_quote(src.ckey)];")
						qry.Execute()
						mob << "You can access Deatheater HQ by clicking the PM button on your HUD."
				if(type == AUROR_INVITE)
					var/rply = alert(mob,"You have been invited to join the Auror clan. Do you accept?",,"Yes","No")
					if(rply == "Yes")
							//Add them to clan and recall update_individual
						qry = my_connection.NewQuery("UPDATE tblPlayers SET isAuror=1,clanRank='Trainee' WHERE ckey=[mysql_quote(src.ckey)];")
						qry.Execute()
						mob << "You can access Auror HQ by clicking the PM button on your HUD."
				update_individual()
