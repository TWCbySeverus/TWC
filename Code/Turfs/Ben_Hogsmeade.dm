obj/var/tmp/lightin=0

obj/lan_light
	plane = 1
	name=""
	dragandrop=0
	blend_mode = BLEND_ADD
	icon = 'spotlight.dmi'

	pixel_x = -64
	pixel_y = 18

	canSave = FALSE


obj/Ben_Hogsmeade_Objects
	icon = 'Hogsmeade Objects.dmi'

	Low_Brick_Wall
		icon_state = "Low Brick"
		layer = MOB_LAYER+1

	Low_Brick_Left
		icon_state = "Brick Left"
		density = 0

	Low_Brick_Right
		icon_state = "Brick Right"
		density = 0

	Lamp_Post
		icon = 'Lamp Post.dmi'
		icon_state = "Unlit"
		density = 1
		layer = MOB_LAYER+1
		dragandrop=0
		proc
			Light_up()
				if(src.lightin==0)
					var/obj/lan_light/L = new()
					src.lightin=1
					L.loc=src.loc//locate(src.x,src.y+2,src.z)
					animate(L, transform = matrix() * 0.3, time = 10, loop = -1)
					animate(   transform = matrix() * 0.35,   time = 10)


	Bar_Table
		icon_state = "Bar Table"
		density = 1

	Bar_Stool
		icon_state = "Square Stool"

	Bin_Bag
		icon_state = "Bin Bag"
		density = 1

	Wooden_Crate
		icon_state = "Wooden Crate"
		density = 1

	Cardboard_Box
		icon_state = "Cardboard boxes"
		density = 1

	Wood_Pallet
		icon_state = "Wood Pallet"
		density = 1

	Bollard
		icon_state = "Bollard"
		density = 1

	Desk
		icon_state = "Desk"
		density = 1

	Desk_Filled
		icon_state = "Desk Filled"
		density = 1

	Small_Square_Window
		icon_state = "Square"
		pixel_y = 8

	Rectangle_Window
		icon_state = "Rectangle"
		pixel_y = 8

	Arch_Window
		icon_state = "Arch"
		pixel_y = 8

	Window_Style1
		icon_state = "Style 1"
		pixel_y = 8

	Window_Style2
		icon_state = "Style 2"
		pixel_y = 8

	Fire_Hydrant
		icon_state = "Fire Hydrant"
		density = 1

	Postbox
		icon_state = "Post Box"
		density = 1

	Bus_Stop
		icon_state = "Bus Stop"
		density = 1

	Phone_Box
		icon_state = "Phone Box"
		density = 1

	Bike_Stand
		icon_state = "Bike Stand"
		density = 1

	Bin
		icon_state = "Bin"
		density = 1

	Newspaper_Stand
		icon_state = "Newspaper Stand"
		density = 1

	Oildrum
		icon_state = "Oildrum"
		density = 1

	Recycling_Bin
		icon_state = "Recycling Bin"
		density = 1

	Traffic_Cone
		icon_state = "Traffic Cones"
		density = 1

	Bench_Middle
		icon_state = "Middle"

	Bench_Left
		icon_state = "Left"

	Bench_Right
		icon_state = "Right"

	Nightstand
		icon_state = "Nightstand"
		density = 1

	Holy_Cross
		icon_state = "Cross"
		density = 1

	Train_Track
		icon_state = "train track"
		density = 1

	Train_Track_End
		icon_state = "train track end"
		density = 1