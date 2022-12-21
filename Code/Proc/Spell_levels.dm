var/list/editable = list("spell_mpl","phaseblock","MHP","MMP",
					"Counter_Sp","StatPoints","incindia_level",
					"glacius_level","tremorio_level",
					"waddiwasi_level","aqua_level")//,""

mob/var/incindia_level  = 1
mob/var/glacius_level   = 1
mob/var/tremorio_level  = 1
mob/var/waddiwasi_level = 1
mob/var/aqua_level      = 1


var/list/incindia  = list(1=0.5,2=0.6,3=0.7,4=0.75,5=0.8,6=0.9,7=1,8=1.05,9=1.1,10=1.2)
var/list/glacius   = list(1=0.5,2=0.6,3=0.7,4=0.75,5=0.8,6=0.9,7=1,8=1.02,9=1.06,10=1.08)
var/list/waddiwasi = list(1=0.5,2=0.6,3=0.7,4=0.75,5=0.8,6=0.9,7=1,8=1.02,9=1.06,10=1.08)
var/list/tremorio  = list(1=0.5,2=0.6,3=0.7,4=0.75,5=0.8,6=0.9,7=1,8=1.02,9=1.06,10=1.08)
var/list/aqua      = list(1=0.5,2=0.6,3=0.7,4=0.75,5=0.8,6=0.9,7=1,8=1.02,9=1.06,10=1.08)


mob/proc/spell_upgrade()
	var/output={"
	<title>Spells</title>
	<style>
	a,a:link,a:hover{
		color:white;
		text-decoration:none;
	}
	a:hover{
		color:#80dfff;
	}
	body{
		background-color:black;
		color:white;
	}
	td{
		border-spacing:25px;
		border-collapse: separate;
	}
	</style>
	<center>
	<table cellpadding="15">
	<tr><td>Spell</td><td>Level</td><td>Upgrade</td></tr>
	[(/mob/Spells/verb/Incindia in src.verbs) ? "<tr><td>Incindia</td><td>[src.incindia_level]</td><td><a href='?src=\ref[src];action=upgrade_incindia'>Upgrade</a></td></tr>" : "" ]
	[(/mob/Spells/verb/Glacius in src.verbs) ? "<tr><td>Glacius</td><td>[src.glacius_level]</td><td><a href='?src=\ref[src];action=upgrade_glacius'>Upgrade</a></td></tr>" : "" ]
	[(/mob/Spells/verb/Waddiwasi in src.verbs) ? "<tr><td>Waddiwasi</td><td>[src.waddiwasi_level]</td><td><a href='?src=\ref[src];action=upgrade_waddiwasi'>Upgrade</a></td></tr>" : "" ]
	[(/mob/Spells/verb/Tremorio in src.verbs) ? "<tr><td>Tremorio</td><td>[src.tremorio_level]</td><td><a href='?src=\ref[src];action=upgrade_tremorio'>Upgrade</a></td></tr>" : "" ]
	[(/mob/Spells/verb/Aqua_Eructo in src.verbs) ? "<tr><td>Aqua Eructo</td><td>[src.aqua_level]</td><td><a href='?src=\ref[src];action=upgrade_aqua'>Upgrade</a></td></tr>" : "" ]
	"}
	usr<<browse(output,"window=1;size=500x500")

var/list/required_sp = list(1=0,2=15,3=20,4=25,5=25,6=30,7=35,8=35,9=40,10=45)

mob/Topic(href,href_list[])
	..()
	switch(href_list["action"])
		if("upgrade_incindia")
			if(usr.incindia_level==10)
				usr<<"You've Maxed out Incindia"
			else
				var/requiredsp = required_sp[usr.incindia_level+1]
				if(usr.StatPoints >= requiredsp)
					switch(input("Do you want to upgrade Incindia?") in list("Yes","No"))
						if("Yes")
							if(usr.incindia_level==10)
								usr<<"You've Maxed out Incindia"
							else
								if(usr.StatPoints >= requiredsp)
									usr.StatPoints -= requiredsp
									usr.incindia_level++
									var/text = {"
										<style>
											a,a:link,a:hover{
												color:white;
												text-decoration:none;
											}
											a:hover{
												color:#80dfff;
											}
											body{
												background-color:#333;
												color:white;
											}
										</style>
									"}
									text += get_spell_info("Incindia")
									usr<<browse(text,"window=winspells.spelbr")
								else
									usr<<"You dont have enough statpoints"
						if("No")
							var/text = {"
								<style>
									a,a:link,a:hover{
										color:white;
										text-decoration:none;
									}
									a:hover{
										color:#80dfff;
									}
									body{
										background-color:#333;
										color:white;
									}
								</style>
							"}
							text += get_spell_info("Incindia")
							usr<<browse(text,"window=winspells.spelbr")
				else
					usr<<"You dont have enough statpoints"

		if("upgrade_glacius")
			if(usr.glacius_level==10)
				usr<<"You've Maxed out Glacius"
			else
				var/requiredsp = required_sp[usr.glacius_level+1]
				if(usr.StatPoints >= requiredsp)
					switch(input("Do you want to upgrade Glacius?") in list("Yes","No"))
						if("Yes")
							if(usr.glacius_level==10)
								usr<<"You've Maxed out Glacius"
							else
								if(usr.StatPoints >= requiredsp)
									usr.StatPoints -= requiredsp
									usr.glacius_level++
									var/text = {"
										<style>
										a,a:link,a:hover{
											color:white;
											text-decoration:none;
										}
										a:hover{
											color:#80dfff;
										}
										body{
											background-color:#333;
											color:white;
										}
										</style>
									"}
									text += get_spell_info("Glacius")
									usr<<browse(text,"window=winspells.spelbr")
								else
									usr<<"You dont have enough statpoints"
						if("No")
							var/text = {"
								<style>
									a,a:link,a:hover{
										color:white;
										text-decoration:none;
									}
									a:hover{
										color:#80dfff;
									}
									body{
										background-color:#333;
										color:white;
									}
								</style>
							"}
							text += get_spell_info("Glacius")
							usr<<browse(text,"window=winspells.spelbr")
				else
					usr<<"You dont have enough statpoints"
		if("upgrade_waddiwasi")
			if(usr.waddiwasi_level==10)
				usr<<"You've Maxed out Waddiwasi"
			else
				var/requiredsp = required_sp[usr.waddiwasi_level+1]
				if(usr.StatPoints >= requiredsp)
					switch(input("Do you want to upgrade Waddiwasi?") in list("Yes","No"))
						if("Yes")
							if(usr.waddiwasi_level==10)
								usr<<"You've Maxed out Waddiwasi"
							else
								if(usr.StatPoints >= requiredsp)
									usr.StatPoints -= requiredsp
									usr.waddiwasi_level++
									var/text = {"
										<style>
										a,a:link,a:hover{
											color:white;
											text-decoration:none;
										}
										a:hover{
											color:#80dfff;
										}
										body{
											background-color:#333;
											color:white;
										}
										</style>
									"}
									text += get_spell_info("Waddiwasi")
									usr<<browse(text,"window=winspells.spelbr")
								else
									usr<<"You dont have enough statpoints"
						if("No")
							var/text = {"
										<style>
										a,a:link,a:hover{
											color:white;
											text-decoration:none;
										}
										a:hover{
											color:#80dfff;
										}
										body{
											background-color:#333;
											color:white;
										}
										</style>
									"}
							text += get_spell_info("Waddiwasi")
							usr<<browse(text,"window=winspells.spelbr")
				else
					usr<<"You dont have enough statpoints"
		if("upgrade_tremorio")
			if(usr.tremorio_level==10)
				usr<<"You've Maxed out Tremorio"
			else
				var/requiredsp = required_sp[usr.tremorio_level+1]
				if(usr.StatPoints >= requiredsp)
					switch(input("Do you want to upgrade Tremorio?") in list("Yes","No"))
						if("Yes")
							if(usr.tremorio_level==10)
								usr<<"You've Maxed out Tremorio"
							else
								if(usr.StatPoints >= requiredsp)
									usr.StatPoints -= requiredsp
									usr.tremorio_level++
									var/text = {"
										<style>
										a,a:link,a:hover{
											color:white;
											text-decoration:none;
										}
										a:hover{
											color:#80dfff;
										}
										body{
											background-color:#333;
											color:white;
										}
										</style>
									"}
									text += get_spell_info("Tremorio")
									usr<<browse(text,"window=winspells.spelbr")
								else
									usr<<"You dont have enough statpoints"
						if("No")
							var/text = {"
										<style>
										a,a:link,a:hover{
											color:white;
											text-decoration:none;
										}
										a:hover{
											color:#80dfff;
										}
										body{
											background-color:#333;
											color:white;
										}
										</style>
									"}
							text += get_spell_info("Tremorio")
							usr<<browse(text,"window=winspells.spelbr")
				else
					usr<<"You dont have enough statpoints"
		if("upgrade_aqua")
			if(usr.aqua_level==10)
				usr<<"You've Maxed out Aqua Eructo"
			else
				var/requiredsp = required_sp[usr.aqua_level+1]
				if(usr.StatPoints >= requiredsp)
					switch(input("Do you want to upgrade Aqua Eructo?") in list("Yes","No"))
						if("Yes")
							if(usr.aqua_level==10)
								usr<<"You've Maxed out Aqua Eructo"
							else
								if(usr.StatPoints >= requiredsp)
									usr.StatPoints -= requiredsp
									usr.aqua_level++
									var/text = {"
												<style>
												a,a:link,a:hover{
													color:white;
													text-decoration:none;
												}
												a:hover{
													color:#80dfff;
												}
												body{
													background-color:#333;
													color:white;
												}
												</style>
											"}
									text += get_spell_info("Aqua-Eructo")
									usr<<browse(text,"window=winspells.spelbr")
								else
									usr<<"You dont have enough statpoints"
						if("No")
							var/text = {"
										<style>
										a,a:link,a:hover{
											color:white;
											text-decoration:none;
										}
										a:hover{
											color:#80dfff;
										}
										body{
											background-color:#333;
											color:white;
										}
										</style>
									"}
							text += get_spell_info("Aqua-Eructo")
							usr<<browse(text,"window=winspells.spelbr")
				else
					usr<<"You dont have enough statpoints"


