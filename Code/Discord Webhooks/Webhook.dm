embedded
	var
		title = ""
		description = ""
		color = null
		url = "";

mob
	proc
		Class_Host_hook(classname)
			var/embedded/O = new/embedded
			switch (classname)
				if("Muggle Studies")
					O.title="[classname]"
					O.description="[classname] class is starting."
					O.url = "https://www.shareicon.net/data/256x256/2015/09/15/641070_hat_512x512.png"
				if("Charms")
					O.title="[classname]"
					O.description="[classname] class is starting."
					O.url = "https://www.shareicon.net/data/256x256/2015/09/15/641070_hat_512x512.png"
				if("Headmasters")
					O.title="[classname] Class"
					O.description="Come and learn from our finest!"
					O.url = "https://static.wikia.nocookie.net/harrypotter/images/3/30/OwlLecturnWU.png"
				if("DADA")
					O.title="Defence Against the Dark Arts Class"
					O.description="Defence Against the Dark Arts class is starting."
					O.url = "https://www.shareicon.net/data/256x256/2015/09/15/641070_hat_512x512.png"
				if("Duel")
					O.title="[classname] Class"
					O.description="[classname] class is starting."
					O.url = "https://www.shareicon.net/data/256x256/2015/09/15/641070_hat_512x512.png"
				if("Transfiguration")
					O.title="[classname]"
					O.description="Come and experience wonders of [classname] class."
					O.url = "https://static.wikia.nocookie.net/harrypotter/images/f/f0/HM_y3_Felifors.png"
				if("COMC")
					O.title="Care of Magical Creatures Class"
					O.description="Come and discover the wonderful creatures who inhabit our world."
					O.url = "https://gamepress.gg/wizardsunite/sites/wizardsunite/files/2019-04/Hippogriff%20Brown-foundable.png"
				if("GCOM")
					O.title="General Course of Magic"
					O.description="General Course of Magic class is starting."
					O.url = "https://www.shareicon.net/data/256x256/2015/09/15/641070_hat_512x512.png"


			var/ez = "\[ "+ json_encode(list("title" = O.title, "description" = O.description, "thumbnail" = list("url"=O.url), "color" = O.color)) +"\]"
			var/embedd =  {"
			{
			  "content": "<@&1051563880226230312>",
			  "embeds": [ez],
			  "attachments": null,
			  "avatar_url" : "https://www.shareicon.net/data/256x256/2015/09/15/641070_hat_512x512.png",
			  "username"   : "Class Bot"
			}
			"}
			usr << output(list2params(list("webhook address",embedd)), "mainwindow.LoginBro:post")
		Event_Announce_(message)
			var/embedded/O = new/embedded
			O.title=null
			O.description="[message]"
			O.url = "https://b.thumbs.redditmedia.com/RKyGw916CAeWEsXNTqtDcQ9vKetMLQ8i15aMnGi71dM.png"
			var/ez = "\[ "+ json_encode(list("title" = O.title, "description" = O.description, "thumbnail" = list("url"=O.url), "color" = O.color)) +"\]"
			var/embedd =  {"
			{
			  "content": "<@&1051568122445955122>",
			  "embeds": [ez],
			  "attachments": null,
			  "avatar_url" : "https://b.thumbs.redditmedia.com/RKyGw916CAeWEsXNTqtDcQ9vKetMLQ8i15aMnGi71dM.png",
			  "username"   : "Event Bot"
			}
			"}
			usr << output(list2params(list("webhook address",embedd)), "mainwindow.LoginBro:post")

		Updates_(message)
			var/embedded/O = new/embedded
			O.title=null
			O.description="[message]"
			O.url = "https://b.thumbs.redditmedia.com/RKyGw916CAeWEsXNTqtDcQ9vKetMLQ8i15aMnGi71dM.png"
			var/ez = "\[ "+ json_encode(list("title" = O.title, "description" = O.description, "color" = O.color)) +"\]"
			var/embedd =  {"
			{
			  "embeds": [ez],
			  "avatar_url" : "https://uxwing.com/wp-content/themes/uxwing/download/file-and-folder-type/log-file-icon.png",
			  "username"   : "Updates"
			}
			"}
			usr << output(list2params(list("webhook address",embedd)), "mainwindow.LoginBro:post")


mob/HGM/verb
	Sent_Update_Log()
		var/m = input("Input Changes Log") as message
		if(m)
			Updates_(m)