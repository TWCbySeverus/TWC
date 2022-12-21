/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

var/DailyProphet=""
var/const/dpheader = {"
<head>
	<title>Daily Prophet</title>
	<style>
		body
		{
			background-image: url('http://www.wizardschronicles.com/dpbg.jpg');
		}
		div.title
		{
			font-size: 38pt;
			text-align: center;
			font-weight: bold;
			font-family: Sans-serif;
		}
		div.subtitle
		{
			font-size: 22pt;
			margin-left: 20px;
			text-decoration: underline;
			font-family: Sans-serif;
		}
		div.byline
		{
			font-size: 8pt;
			text-align: right;
		}
		div
		{
			font-size: 11pt;
			margin-left: 5px;
			color:black;
		}
	</style>
</head>
<body>
	<div class = "title">
		Daily Prophet
	</div>
	"}

var/list
	DP = new

mob
	verb
	//	Refer_a_friend()
	//		usr << "<br><br><b>If you refer a new player to this game, 10% of any XP or 1% of any Gold they earn will be awarded to you whenever you log in. In order to refer someone, have them visit<br>http://wizardschronicles.com/?ref=[ckey]<b><br>Then have them download and join the game. Once they gain XP, then Save (either manually or by logging out), a percentage of that XP will become available to you automatically when <b>you</b> log in. If you've reached the level cap you will instead earn Gold.<br>"
		Daily_Prophet()
			set category = "Commands"
			var/dphtml = ""
			//for(var/i=DP.len, i>0, i--)
			src:lastreadDP = world.realtime
			for(var/i in DP)
				dphtml = DP[i] + "<br /><hr />" + dphtml
			dphtml = dpheader + dphtml
			usr << browse(dphtml,"window=1;size=700x550")

var/list
	dp_editors
	stories

obj
	DailyProphet
		icon = 'Hogwarts 32x32.dmi'
		icon_state = "Daily Prophet"
		density = 1
		mouse_over_pointer = MOUSE_HAND_POINTER
		Click()
			..()

			var/list/actions = list("Submit a story")

			if(usr.admin) actions += "Hire/Fire someone"
			if(usr.ckey in dp_editors)
				actions += "Review story"
				actions += "Remove story"
				actions += "Clear DP"
				actions += "Edit DP"


			if(has_story(usr))
				actions += "Edit your stories"

			var/i = input("What would you like to do?", "Daily Prophet") as null|anything in actions

			switch(i)
				if("Edit your stories")
					var/list/storylist = my_stories(usr)
					var/story/s = input("Which story?", "Review Story") as null|anything in storylist
					if(!s) return

					edit_story(usr, s)


				if("Submit a story")
					new_story(usr)

				if("Hire/Fire someone")
					i = alert(usr, "Would you like to hire/fire someone?", "Daily Prophet", "Hire", "Fire", "Cancel")
					if(i == "Hire")
						var/k = input("Enter ckey/key", "Hire DP") as text|null
						if(!k || k == "")return
						k = ckey(k)
						if(!dp_editors)
							dp_editors = list()
						if(k in dp_editors)
							usr << infomsg("[k] is already hired.")
						else
							dp_editors += k
							usr << infomsg("You hired [k].")
					else if(i == "Fire")
						var/k = input("Enter ckey/key", "Hire DP") as null|anything in dp_editors
						if(!k)return
						dp_editors -= k
						if(!dp_editors.len) dp_editors = null
						usr << infomsg("You fired [k].")

				if("Clear DP")
					clear_dp()
					usr << "<b>All stories and headlines have been cleared.</b>"
				if("Review story")
					var/story/s = input("Which story?", "Review Story") as null|anything in stories
					if(!s) return

					if(edit_story(usr, s))
						add_story(s)

						if(alert("Post extra extra message?",,"Yes","No") == "Yes")
							Players<<"<b><font color=red>EXTRA EXTRA! The Daily Prophet has been updated! Click <a href='?src=\ref[usr];action=daily_prophet'>here</a> to view."

				if("Remove story")
					var/story/s = input("Which story?", "Remove Story") as null|anything in stories
					if(!s) return

					stories -= s

					usr << "<b>[s] was removed.</b>"

				if("Edit DP")
					var/editstory = input("Which story do you wish to edit?") as null|anything in DP
					if(!editstory)return
					var/changes = input("Make your changes below","Changes",DP[editstory]) as message|null
					if(!changes)return
					if(lowertext(changes) == "delete")
						DP -= editstory
					else
						DP[editstory] = changes

		proc
			edit_story(mob/Player/p, story/s)
				var/approve = 0
				var/i
				while(!approve)
					p << browse({"[dpheader]
								<div class="subtitle">
									[s.name]
								</div>
								<div class="byline">
									[time2text(world.realtime,"DD Month")], by [s.who]
								</div>
								<div>
									[s.content]
								</div>"},"window=1;size=700x550")
					i = alert(p, "Edit or submit?", "Review Story", "Edit","Submit", "Cancel")
					if(i == "Submit")
						approve = 1
						break
					else if(i == "Cancel") return 0

					i = input(p, "What's the title of the story?", "Headline", s.name) as text|null
					if(!i)return 0
					s.name = i
					i = input(p, "Input the body of the story", "Content", s.content) as message|null
					if(!i) return 0
					s.content = i
				return 1

			new_story(mob/Player/p)
				var/Headline = input(p, "What's the title of your story?", "Headline") as text|null
				if(!Headline)return
				var/message = input(p, "Input the body of the story", "Content") as message|null
				if(!message) return

				var/story/s = new (message, Headline, p.name, p.ckey)

				if(edit_story(p, s))
					if(!stories) stories = list()
					stories += s

			add_story(story/s)
				DP[s.name] = {"
								<div class="subtitle">
									[s.name]
								</div>
								<div class="byline">
									[time2text(world.realtime,"DD Month")], by [s.who]
								</div>
								<div>
									[s.content]
								</div>"}
				dplastupdate = world.realtime
				stories -= s

			has_story(mob/Player/p)
				for(var/story/s in stories)
					if(s.ckey == p.ckey)
						return 1
						break
				return 0

			my_stories(mob/Player/p)
				var/list/storylist = list()
				for(var/story/s in stories)
					if(s.ckey == p.ckey)
						storylist += s
				return storylist

			remove_story(s)
				DP -= s

			clear_dp()
				DP = list()


story
	var
		content
		name
		who
		ckey

	New(content, name, who, ckey)
		..()
		src.content = content
		src.name    = name
		src.who     = who
		src.ckey    = ckey
