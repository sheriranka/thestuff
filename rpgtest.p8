pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
//constants
//d stairs down
//u stairs up
//w = wall
//a = empty(can be replaced later)
//s = shop
//b = bossfight
//c = chest(item)
//q = chest(equip)
//x = chest(wpn)
//y = chest(spell)
//e = empty chest



//first floor pal


stagemap = {"wwwwwwwwwywuwawwwawawaawwaaawwawwwaaawawwwaaaaawwaaaaaawwwwwwwww",
"wwwwwwwwwdaaqaawwaaaaaawwaaaxaawwaaaaaawwaasaaawwaaaaaawwwwwwwww"
}

pix = 1/8
spd = 2
tick = 0


//add up and down locations
//so the place u go to when u go
//downstairs and upstairs is dif
stagexup = {2,3}
stageyup = {4,2}

stagexdown = {4,3}
stageydown = {3,5}

w = 8
h = 8

up = true
face = false

	//m = main
	//s = stats
	//e = equip
	//w = wpn
	//p = spells
	//d = dialogue
	//t = toss item menu, options are
	//use/equip or discard


menucontents = {
m={"equip","magic","weapn","stats","save"},
s={"hp","power","magic","defns","speed"},
i={},
w={},
p={},
e={},
t={"use","pass","toss"},
chars={"char1","char2","char3"},
selected=0,
g = 1000
}


//define character


chara = {}


add(chara,
{n="char1",
mx=30,
h=30,
p=5,
m=5,
s=5,
wpn=nil,
arm=nil,
equip={},
wpns={},
spells={}
})



add(chara,
{n="char2",
mx=30,
h=30,
p=5,
m=5,
s=5,
wpn=nil,
arm=nil,
equip={},
wpns={},
spells={}
})


add(chara,
{n="char3",
mx=30,
h=30,
p=5,
m=5,
s=5,
wpn=nil,
arm=nil,
equip={},
wpns={},
spells={}
})



//t os type
//t = 2 spell
//t = 1 armor
//t = 3 wpn


//spell ids, 1 and above
//n = name
//oc = can be used outside combat
//d = string description
//e = element
//f = effect/damage
//s = inflict ailment
//x = durability
//t = type, type 1 = spell, type 0 = equipabble

//add more spells later
spells = {
{n="fire",oc=false,d="flame spell",f=-2,e="f",s=nil,x=10,t=1,p=300},
{n="ice",oc=false,d="frost spell",f=-2,e="i",s=nil,x=10,t=1,p=300},
{n="thunder",oc=false,d="electric spell",f=-2,e="t",s=nil,x=10,t=1,p=300},
{n="heal",oc=true,d="healing spell",f=2,e="f",s=nil,x=10,t=1,p=300}
}

//equipment ids
//n = name
//s = strength
//w = weakness
//d = description
//t = type
//e = equipped 

equip = {
{n="red",s="f",w="i",d="fiery armor",t=0,e=false,x="웃",p=500}

}

//weapon ids

//n = name
//e = element
//a = atk
//x = durability
//d = description
//t = type
//e = equipped


weapon = {
{n="blade",e="n",a=2,x=99,d="a regular blade",t=2,e=false,p=50},
{n="firesword",e="f",a=5,x=20,d="fiery blade",t=2,e=false,p=200}
}


items = {equip,spells,weapon}

//main menu options
mainmenu = {"e","p","w","s"}
subsel = 0

//shop stuff
shopinv = {
{},
{},
{}
}

shoppage = 1
nms = {"armor","spellbooks","weapons"}


//pass as ids
add(shopinv[1], 1)
add(shopinv[2], 2)
add(shopinv[2], 4)
add(shopinv[3], 2)
add(shopinv[3], 1)

function _init()

	
	stage = 1
	stageset()
	up = true
	state = 1
	
	moving = false
	movex = 0
	movey = 0
	movetick = 0
	
	//menu time set stuff
	menutime = 0
	menutimeset = true
	steps = 0
	
	//for dialogue & menu
	//m = main
	//s = stats
	//e = equip
	//w = wpn
	//p = spells
	//i = items
	//d = dialogue
	//c = combatmain
	//cm = combat magic
	//cw = combatw wpn
	//
	
	windowtxt = ""
	windowcount = 1
	window = nil
	subsel = nil
	subwin = nil
	prev = nil
	
	//selection on menu
	selection = 1
	
	//combat event
	//numbers =
	
	//0 = main
	//1 = atk
	//2 = magic menu
	//3 = magic spell
	//4 = equip menu
	//5 = equip wpn
	//6 = defend
	//7 = flee
	//8 = enemy action
	//9 = player action
	//10 = animation
	
	combat = 0
	//store action -unused rn
	//action = nil
	
	
	//spell test
	add(chara[1].spells, getit(2,1))
	add(chara[1].spells, getit(2,2))
	add(chara[2].spells, getit(2,3))
 add(chara[3].spells, getit(2,4))
	
	
end


function _update()

	if moving then
	 tick = (tick+1)%8
	end
	menutime = (menutime+1)%8
	if(menutime == 0) then
		menutimeset = true
	end

//move on map
	if state == 0 then
		updatemap()
	elseif state == 1 then
		updatecombat()
	end
		
end


function _draw()

--0 is map
--1 is combat
--2 is transition screen

	if state == 0 then
		drawmaps()
	elseif state == 1 then
		drawcombat()
	end
	print("window")
	print(window)
	print("selection")
	print(selection)
	print("shoppage")
	print(shoppage)
	
end



//big changing functions stuff

function stageset()

	if up then
		centerx = stagexup[stage]
		centery = stageyup[stage]
	else
		centerx = stagexdown[stage]
		centery = stageydown[stage]
	end
		
	x = centerx
	y = centery
	
	offsetx = 63
	offsety = 63
	
end
-->8
function drawmaps()

cls(0)
	drawmap(h,w,stagemap[stage])
	drawsprite(tick)
	
	//menu window
	
	if window then
		drawmenu(window)
	end
	
	
	//fix collission
	
	print("x:"..x..",y:"..y,12)
	print("offsetx:"..offsetx..",offsety:"..offsety,0,8,12)

end


function drawspr(idx,idy,x,y)

	sspr(idx,idy,8,8,x,y,16,16)

end


function drawsprite(tick)

	if moving then
		spr(43,55,55,2,1,face)
		if tick < 4  then
			spr(61,55,63,2,1,face)	
		else
		 spr(45,55,63,2,1,face)
		end
	else
			spr(43,55,55,2,2,face)
	end
	
end

sprw = {w=72,q=80,x=80,y=80,e=88,d=88,u=80,s=72}
sprs = {w=16,x=8,y=8,e=8,q=8,u=0,d=0,s=8}

function drawmap(h,w,grid)

	for i=1,h do
		for j=1,w do
			local s = grid[j+((i-1)*w)]
			local x = ((j-1)*16)+offsetx-((centerx-.5)*16)
			local y = ((i-1)*16)+offsety-((centery-.5)*16)
			drawspr(sprw[s],sprs[s],x,y)
			
		end
	end

end


//true = change in x
//false = change in y
function position(d,xy)

	if xy then
		x += d*pix
	else
		y += d*pix
	end

end


function drawmenu(window)

	local w = window
	
	if w == "m" then
	
		rectfill(16,16,56,64,0)
		rect(16,16,56,64,7)
		
		for i=1,#menucontents.m do
			
			if i == selection then
				print("★"	,18,i*8+12)
			end
			print(menucontents.m[i],28,i*8+12)
		end
		
		rectfill(92,16,112,24,0)
		rect(92,16,112,24,7)
		print(menucontents.g.."g",94,18)
		
	elseif w == "c" then
	
		rectfill(16,16,56,64,0)
		rect(16,16,56,64,7)
		
		for i=1,#menucontents.m do
			
			if i == subsel then
				print("★"	,18,i*8+12)
			end
			print(menucontents.m[i],28,i*8+12)
		end
	
	
		rectfill(47,16,90,48,0)
		rect(47,16,90,48,7)
		
		for i=1,#menucontents.chars do
			
			if i == selection then
				print("★"	,52,i*8+12)
			end
			print(menucontents.chars[i],62,i*8+12)
		end
		
	elseif w == "ce" or w == "cp" or w == "k" then
	
		rectfill(47,16,90,48,0)
		rect(47,16,90,48,7)
		
		for i=1,#menucontents.chars do
			
			if i-1 == selection then
				print("★"	,52,i*8+12)
			end
			print(menucontents.chars[i],62,i*8+12)
		end
		
	elseif w == "e" then
	
		rectfill(32,16,96,56,0)
		rect(32,16,96,56,7)
	
		for i=1,#chara[menucontents.selected].equip do
				if i == selection then
						print("★"	,35,i*8+12)
						drawdescription(chara[menucontents.selected].equip[i])
				end
				print(chara[menucontents.selected].equip[i].n,44,i*8+12)
		 	if chara[menucontents.selected].equip[i].e	then
					print("e",90,i*8+12)
				end
		end
	 
	elseif w == "p" then
	
		rectfill(32,16,96,52,0)
		rect(32,16,96,52,7)
		
		for i=1,#chara[menucontents.selected].spells do
				if i == selection then
						print("★"	,35,i*8+12)
						drawdescription(chara[menucontents.selected].spells[i])
				end
				print(chara[menucontents.selected].spells[i].n,44,i*8+12)
				print(chara[menucontents.selected].spells[i].x,80,i*8+12)
		end
		
	
	elseif w == "w" then
	
		rectfill(32,16,104,52,0)
		rect(32,16,104,52,7)
		
		for i=1,#chara[menucontents.selected].wpns do
				if i == selection then
						print("★"	,35,i*8+12)
						drawdescription(chara[menucontents.selected].wpns[i])
				end
				print(chara[menucontents.selected].wpns[i].n,44,i*8+12)
				print(chara[menucontents.selected].wpns[i].x,80,i*8+12)
				if chara[menucontents.selected].wpns[i].e	then
					print("e",90,i*8+12)
				end
		end
	
	elseif w == "s" then
	
		rectfill(32,16,96,60,0)
		rect(32,16,96,60,7)
		
		print("hp", 40, 20)
		print("atk")
		print("mag")
		print("spd")
		print("wpn")
		print("eqp")
		
		print(chara[menucontents.selected].h.."/"..chara[menucontents.selected].mx, 64, 20)
		print(chara[menucontents.selected].p)
		print(chara[menucontents.selected].m)
		print(chara[menucontents.selected].s)
		if not chara[menucontents.selected].wpn == nil then
			print(chara[menucontents.selected].wpn.n)
		else
			print("none")
		end
		
		if not chara[menucontents.selected].arm == nil then
			print(chara[menucontents.selected].arm.n)
		else
			print("none")
		end
	
	
	elseif w == "t" then
	
		rectfill(32,32,90,64,0)
		rect(32,32,90,64,7)
		
		print(subwin[subsel].n, 35,34)
		print(subwin[subsel].x, 80,34)
		for i=1,#menucontents.t do
				if i == selection then
						print("★"	,35,i*8+34)
				end
				print(menucontents.t[i],44,i*8+34)
		end
		
	elseif w == "d" then
	
		rectfill(7,91,120,120,0)
		rect(7,91,120,120,7)
		
		print(windowtxt[windowcount],9,93)
	
	elseif w == "b" then
	
	 rectfill(32,16,104,52,0)
		rect(32,16,104,52,7)
		
				
		rectfill(32,16,80,15,0)
		rect(32,8,80,15,7)
		print(nms[shoppage],34,10)
		
		
		for i=1,#shopinv[shoppage] do
			if i == selection then
			 print("★"	,35,i*8+12)
				drawdescription(getit(shoppage, shopinv[shoppage][i]))
		 end
		 print(getit(shoppage, shopinv[shoppage][i]).n,44,i*8+12)
			print(getit(shoppage, shopinv[shoppage][i]).p,80,i*8+12)
		end
		
		rectfill(92,54,118,62,0)
		rect(92,54,118,62,7)
		print(menucontents.g.."g",94,56)
		
	end

end


function drawdescription(item)

	rectfill(15,96,111,114,0)
	rect(15,96,111,114,7)	
	
	print(item.d, 20, 99)

end
-->8
//map collissions
//and map logic


function col(grid)

	for i=1,h do
		for j=1,w do
		
			local s = grid[j+((i-1)*w)]
			if s == "w" or s == "x" or s == "e" or s == "q" or s == "y" or s == "s" then
						
				if abs(x - j) < 1 and abs(y-i) < 1 then
					//print("i:"..i..",j:"..j,0,32,10)
					return true
				end
				
			end
			
		end
	end

	return false
	
end


function stairs(grid)


	for i=1,h do
		for j=1,w do
		
			local s = grid[j+((i-1)*w)]
			if s == "d" then
						
				if abs(x - j) < .5 and abs(y-i) < .5 then
					//print("i:"..i..",j:"..j,0,32,10)
					stage -= 1
					up = false
					stageset()
				end
			
			elseif s == "u" then
				if abs(x - j) < .5 and abs(y-i) < .5 then
					//print("i:"..i..",j:"..j,0,32,10)
					stage += 1
					up = true
					stageset()
				end
			end
			
		end
	end

	return false


end



function getitem(c)

	local get = true
	
	if c == "q" then
		local n = flr(rnd())%#equip+1
	
		local stored = false
	
		for i=1,3 do
			if #chara[i].equip < 4 then
				add(chara[i].equip, getit(1,n))
				windowtxt = {"you found "..equip[n].n..".", "stored in bag."}
				stored = true
				break
			end
		end
			
		if not stored then
			windowtxt = {"you found "..equip[n].n..".","but your equip inventory\nis full."}
			get = false
		end

	elseif c == "x" then
		local n = flr(rnd())%#weapon+1
	 
	 local stored = false
	 
	 for i=1,3 do
			if #chara[i].wpns < 4 then
				add(chara[i].wpns, getit(3,n))
				windowtxt = {"you found "..weapon[n].n..".", "stored in bag."}
				stored = true
				break
			end
		end
			
		if not stored then
			windowtxt = {"you found "..weapon[n].n..".","but your equip inventory\nis full."}
			get = false
		end

	elseif c == "y" then
		local n = flr(rnd())%#spells+1
	
	 local stored = false
	 
	 for i=1,3 do
			if #chara[i].spells < 4 then
				add(chara[i].spells, getit(2,n))
				windowtxt = {"you found "..spells[n].n..".", "stored in bag."}
				stored = true
				break
			end
		end
			
		if not stored then
			windowtxt = {"you found "..spells[n].n..".","but your equip inventory\nis full."}
			get = false
		end
		
	end
	
	window = "d"
	resetmenu()
	return get

end

function interact(grid)

	local index = flr(x) + (flr(y)-1)*w
	local inx = nil
	local get = false
	
	local grid_table = {
	index-1,
	index+1,
	index-w,
	index+w
	}
	
	for x in all(grid_table) do
		if grid[x] == "x" or grid[x] == "q" then
			inx = x
			get = getitem(grid[x])
			break
		elseif grid[x] == "s" then
			window = "b"
			resetmenu()
			break
		end
	end
	//if itemget is true, mod mapstring
	
	if get then
		stagemap[stage] = sub(grid, 1, inx-1).."e"..sub(grid, inx+1, #grid)
	end

end


function updatemenu(window)

	local w = window
	
	local len = 0
	
	if w == "m" then
		len = #menucontents.m
	elseif w == "c" or w == "y" or w == "h" or w == "k" then
		len = #menucontents.chars
	elseif w == "i" then
		len = #chara[menucontents.selected].i
	elseif w == "e" then
	 len = #chara[menucontents.selected].equip
	elseif w == "w" then
		len = #chara[menucontents.selected].wpns
	elseif w == "p" then
		len = #chara[menucontents.selected].spells
	elseif w == "t" then
		len = #menucontents.t
	elseif w == "b" then
		len = #shopinv[shoppage]
	else
		len = 0
	end


	if menutimeset then
		if(btn(3)) then
			selection = (selection + 1)%len
			if selection == 0 then selection = len end
			resetmenu()
		end
		
		if(btn(2)) then
			selection = (selection - 1)%len
			if selection == 0 then selection = len end
			resetmenu()
		end
		
		//pending. one button doesnt work
		if(btn(1)) then
		 shoppage = (shoppage + 1)%3
		 if shoppage == 0 then shoppage = 3 end
			selection = 1
			resetmenu()
		end
	
		if(btn(0)) then
		 shoppage = (shoppage - 1)%3 + 1
	 	if shoppage == 0 then shoppage = 3 end
	 	selection = 1
	 	resetmenu()
	 end
	
		if(btn(4)) then
			nextmenu()
			resetmenu()
		end
		
		if(btn(5)) then
			prevmenu()
			resetmenu()
		end
	end
	
end


function prevmenu()
	
	if state == 0 then
		local v = window
		
		local window_table={
		m=nil,
		s="m",
		e="m",
		p="m",
		w="m",
		t=prev,
		k="b",
		b=nil
		}
		//
		//}
		window = window_table[v]
		selection = 1
	
	end

end


function nextmenu()

		local w = window
		
		if w == "m" then
			window = "c"
			subsel = selection
			selection = 1	
		elseif w == "c" then
			window = mainmenu[subsel]
			menucontents.selected = selection
			selection = 1
		elseif w == "p" and #chara[menucontents.selected].spells > 0 then
			window = "t"
			subwin = chara[menucontents.selected].spells
			subsel = selection
			selection = 1
			prev = mainmenu[2]				
		elseif w == "w" and #chara[menucontents.selected].wpns > 0 then
			window = "t"
			subwin = chara[menucontents.selected].wpns
			subsel = selection
			selection = 1
			prev = mainmenu[3]
		elseif w == "e" and #chara[menucontents.selected].equip > 0 then
			window = "t"
			subwin = chara[menucontents.selected].equip
			subsel = selection
			selection = 1
			prev = mainmenu[1]		
		elseif w == "y" then
			usingitem()
		elseif w == "h" then
			passitem()
		elseif w == "t" then		
			if selection == 1 then
				useitem()
			elseif selection == 2 then
				selection = 1
				window = "h"
				resetmenu()
			else
				del(subwin,subwin[subsel+1])
				prevmenu()
			end
		elseif w == "d" then
			windowcount += 1
			if windowcount > #windowtxt then
			 window = nil
			 windowcount = 1
			end
		elseif w == "b" then
			if menucontents.g >= getit(shoppage,shopinv[shoppage][selection]).p then
				window = "k"
				selected = selection
				selection = 1
				resetmenu()
			end
		elseif w == "k" then
			buyitem()
		end

end


function useitem()

	if subwin[subsel].t == 1 then
		
		if subwin[subsel].oc then
			
			resetmenu()
			window = "y"
			selected = 0
			//new menu
			
		else 
		
			resetmenu()
			window = "d"
			windowtxt = {"this item can't be used\noutside of battle."}
		end
	
		
	else
		//unequip all item and then
		//equip one
		
		if subwin[subsel].e == true then
			subwin[subsel].e = false
			
			//if wpn change wpn status
			//if arm change arm status
			if subwin[subsel].t == 2 then
				chara[menucontents.selected].wpn = nil
			else
				chara[menucontents.selected].arm = nil
		 end
		 
			prevmenu()
		else
		
			for i in all(subwin) do
				i.e = false
			end
			
			subwin[subsel].e = true
			
			if subwin[subsel].t == 2 then
				chara[menucontents.selected].wpn = subwin[subsel+1]
			else
				chara[menucontents.selected].arm = subwin[subsel+1]
		 end
			
			prevmenu()
		end
		
	end

end

function usingitem()


	//run item effect
	//effect()
	//pending
	
	subwin[subsel].x -= 1
		if subwin[subsel].x == 0 then
			del(subwin,subwin[subsel])
		end
		selection = q
		resetmenu()
		window = "m"


end

function passitem()

	local ob = subwin[subsel]
	
	if ob.t == 0 then
		if #chara[selection].equip < 4 then
		 ob.e = false
		 add(chara[selection].equip, ob)
		 del(subwin,subwin[subsel])
		 chara[menucontents.selected].arm = nil
		 resetmenu()
		 window = "m"
		else
			window = "d"
			windowtxt = {chara[selection].n.."'s inventory is full"}
			resetmenu()
		end
	elseif ob.t == 1 then
		if #chara[selection].spells < 4 then
		 add(chara[selection].spells, ob)
		 del(subwin,subwin[subsel])
		 resetmenu()
		 window = "m"
		else
			window = "d"
			windowtxt = {chara[selection].n.."'s inventory is full"}
			resetmenu()
			end
	elseif ob.t == 2 then
	 ob.e = false
		if #chara[selection].wpns < 4 then
		 add(chara[selection].wpns, ob)
		 del(subwin,subwin[subsel])
		 chara[menucontents.selected].wpn = nil
		 resetmenu()
		 window = "m"
		else
			window = "d"
			windowtxt = {chara[selection].n.."'s inventory is full"}
			resetmenu()
		end
	end

end


//change buy item later
function buyitem()

	if shoppage == 2 and #chara[selection].spells < 4 then
	 add(chara[selection].spells, getit(shoppage, shopinv[shoppage][selected+1]))
		menucontents.g -= getit(shoppage, shopinv[shoppage][selected]).p
		prevmenu()
		
	elseif shoppage == 3 and #chara[selection].wpns < 4 then
	 add(chara[selection].wpns, getit(shoppage, shopinv[shoppage][selected+1]))
	 menucontents.g -= getit(shoppage, shopinv[shoppage][selected]).p
		prevmenu()
	elseif shoppage == 1 and #chara[selection].equip < 4 then
  add(chara[selection].equip, getit(shoppage, shopinv[shoppage][selected+1]))
	 menucontents.g -= getit(shoppage, shopinv[shoppage][selected]).p
		prevmenu()
	else
		window = "d"
		windowcount = 1
		windowtxt = {"not enough space"}
	end
	
	resetmenu()
	
end


function resetmenu()

	menutime = 1
	menutimeset = false
	
end


function updatemap()

if not window then



		//do moving
		if moving == true then
		
			offsetx += 2*movex
			offsety += 2*movey
			movetick += 1
			
			if movetick%8 == 0 then		
				moving = false
				movex = 0
				movey = 0
				
				//at end of move
				//check if standing on stairs
				//or if speed goes up
				dosteps()	
				stairs(stagemap[stage])
			end
		
		
		//only do the following if
		//not moving
		//do not press menu open while
		//walking
		else
		

			if(btn(0)) then
	
				x -= 1
				
				if col(stagemap[stage]) then
					x += 1
					movex = 0
					moving = false
				else
				 movex = 1
				 moving = true
				end
				
				face = false
				
			elseif(btn(1)) then
				
				x += 1
				face = true
				
				if col(stagemap[stage]) then
					x -= 1
					movex = 0
					moving = false
				else
				 movex = -1
				 moving = true
				end
				
			
			elseif(btn(2)) then
			
			
			 y -= 1
			 
				if col(stagemap[stage]) then
					y += 1
					movey = 0
					moving = false
				else
					movey = 1
					moving = true
				end
				
			
			elseif(btn(3)) then
			
			 y += 1
		
				if col(stagemap[stage]) then
					y -= 1
					movey = 0
					moving = false
				else
				 movey = -1
				 moving = true
				end
				
			end
			
			
			if menutimeset then
			//interact w items
				if(btn(4)) then
					interact(stagemap[stage])	
				end
		
			//open menu
				if(btn(5)) then
					window = "m"
					resetmenu()
				end
			
		 end	
	end

else

 updatemenu(window)
 
end


end


function dosteps()

	steps = (steps + 1)%16
	
	if(steps == 0) then
	
	
	windowtxt = {}
	for i=1, #chara do
		if(rnd(3) > 2) then 
		add(windowtxt, chara[i].n.." speed increased by 1.")
		window = "d"
		chara[i].s += 1
		resetmenu()
		end
	end
	
	end
	
end
-->8
//combat variable manager
combatman = {
m={"attack", "magic","defend"},
turn=1,
sprites={192,194,196},
enemyselected=1,
enemytarget=1,
state=1,
//speed manager to run turns
//in order of speed
speedman={},
//action manager to run turns
actionman={}
}


//functions for running combat
//states
combatfunc ={}


function drawcombat()

	cls(0)
	drawcmenu()
		


end

combatdrawfunc = {}


function drawcmenu()

	if combat == 0 then
		rectfill(7,7,55,39,0)
		rect(7,7,55,39,7)
		
		for i=1,#combatman.m do
		
			print(combatman.m[i], 23, 4+(i*8))
			if selection == i then
				print("★", 12, 4+(i*8))
			end
		
		end
	
	rect(56,7,73,24)	
	spr(combatman.sprites[combatman.turn],57,8,2,2)
		
	elseif combat == 2 then
	
		
	end


end

function combatmenu()

	
end


//references nextmenu and prevmenu from
//prev window
function updatecombatmenu()


	local len = #combatman.m
	if menutimeset then
		if(btn(3)) then
			selection = (selection + 1) % len
			resetmenu()
		end
		
		if(btn(2)) then
			selection = (selection - 1) % len
			resetmenu()
		end
		
		if selection == 0 then selection = len end
	end
 //btwn 4 is confirm 5 is back

end


function updatecombat()

	updatecombatmenu()
	
end
-->8
//adding objects to inventories

function getit(typ,id)

	local item = {}
	
	
	item.n = items[typ][id].n
	item.p = items[typ][id].p
	item.e = items[typ][id].e
	item.t = items[typ][id].t
	item.d = items[typ][id].d
	
	
	if typ == 1 then
		item.w = equip[id].w
		item.s = equip[id].s
		
	elseif typ == 2 then
	
	 item.oc = spells[id].oc
	 item.f = spells[id].f
	 item.s = spells[id].s
	 item.x = spells[id].x
 
	else
	
	 item.a = weapon[id].a
	 item.x = weapon[id].x

	
	end
	
	return item

end
-->8
//big sprites and stuff

-- convert a hexadecimal string into a table of numbers.
--
-- arguments:
-- s = the hexadecimal string to decode
-- n = the size (in number of digits) of each item stored in the string
-- (eg. 2 digits gives 00..ff = 1 unsigned byte,
-- 4 digits = 0000..ffff = 16-bit unsigned integer, etc)
function unhex(s,n)
 n = n or 2
 local t = {}
 for i = 1, #s, n do
  add(t, ('0x' .. sub(s, i, i+n-1)) + 0)
 end
 return t
end

function drawenemy(id)

-- table with enemy ids and shit i guess



end
__gfx__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000555500001dd10000000000000000000000000000000000
000000000000000000999999999979000000000000000000000000000000000000000000000000000067760000dddd0000000000000000000000000000000000
0000000000000000099999999a9aa7900000056666500000000001dddd1000000000000000000000055555500151515000000000000000000000000000000000
000000000000000009944a4444944aa0000056666665000000001dddddd1000000000000000000000567775005d66d5000000000000000000000000000000000
00000000000000000944494444944490000567777776500000015151515150000000000000000000566666655677776500000000000000000000000000000000
000000000000000009444944449444900056777777776500005dddd66dddd5000000000000000000555555555555555500000000000000000000000000000000
00000000000000000944494444944490055555555555555005555555555555500000000000000000d666766d6777777600000000000000000000000000000000
000000000000000009444944449444905567777777777655556666666666665500000000000000001d6666d17777777700000000000000000000000000000000
000000000000000009999a96799aa77056666677776666655666667777666665000000000000333009999a700999999000000000000000000000000000000000
0000000000000000099999956999aa90555555555555555555555555555555550000000000030d0394a4494a9511115a00000000000000000000000000000000
00000000000000000444444564444440666666666666666666777777777777660000000000030d03949449499511115900000000000000000000000000000000
00000000000000000444444994444440666777777777666667777777777777760000000000003830999679a999999aa900000000000000000000000000000000
000000000000000004444449a4444440d66666666666666d777777777777777700000000000b333b444564444449944400000000000000000000000000000000
00000000000000000444444994444440dd666666666666dd777777777777777700000000003bb3bb444994444449944400000000000000000000000000000000
00000000000000000444444994444440151515155151515155555555555555550000000000333330544994455449944500000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000033339390554994555549945500000000000000000000000000000000
0000000000000000000000000000000007777777777777700000000000000000000000000777777003333000000000000000000000000003bb3b000000000000
000000000000000000000000000000007000011111100007000000033330000000000000700110070f137300000003333330000000000003333b000000000000
0000000000000000000000000000000070000001100000070000003ddddb000000000000707117073fff330000003f3333730000000000b2222bb00000000000
00000000000000000000000000000000700000011000000700000030dd03000000000000711001170011b0000003ffff33330000000000731337700000000000
00000000000000000099999999999900700000700700000700000030dd030000000000007110011700333b00000311ff11333000000007711433700000000000
0000000000000000095111111111159071000001100000170000003d88d300000000000070711707072227000000effffef33000000000711443300000000000
000000000000000009511111111115907100700110070017000000033330000000000000700110070011330000000fffff330000000000055743300000000000
0000000000000000095111111111159071110111111011170000033333300000000000000777777000707000000000011bb00000000000057770000000000000
000000000000000009511111111115707111011111101117000003333330000000000000000000000000000000000003bb3b000000000003bb3b000000000000
000000000000000009999999a999aa9071007001100700170000033b333b000000000000000000000000000000000003333b000000000003333b000000000000
000000000000000004444449a444444071000001100000170000033bb3bb0000000000000000000000000000000000b2222bb000000000b2222bb00000000000
00000000000000000444444994444440700000700700000700000333b3b000000000000000000000000000000000007133377000000000713337700000000000
000000000000000004444449a4444440700000011000000700000333333000000000000000000000000000000000071113337000000007111333700000000000
00000000000000000444444994444440700000011000000700000333333000000000000000000000000000000000001111333000000000411133300000000000
00000000000000000444444994444440700001111110000700033333333000000000000000000000000000000000007400740000000007440005500000000000
00000000000000000000000000000000077777777777777000000990099000000000000000000000000000000000007700770000000007700005500000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000033333333b3000000000888000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000333f3b3b33300000000888880000000000cccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333fff3b33730000000888888800000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0033ffff3337730000000888888800000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003300ff0037330000000888888800000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003f70ff7003333000000888888800000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f70ff70f3333000000888888800000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000ffffffff3333000000888888800000000cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000ffeefff33330000000888880000000000cccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00033fffff1333330000000888000000000000cccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003333fff11333300000000222000000000000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00003331111bb33000000082228800000000cc1111cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001bb11bbbb100000008882888000000cccc1111ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000
000113bbbbbb311000008888888888000cccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000
001333bbb333333100088888888888800ccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
