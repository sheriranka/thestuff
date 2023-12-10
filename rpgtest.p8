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
"wwwwwwwwwdaaqaawwaaaaaawwaaaxaawwaaaaaawwaaaaaawwaaaaaawwwwwwwww"
}

pix = 1/8
spd = 2


//add up and down locations
//so the place u go to when u go
//downstairs and upstairs is dif
stagexup = {2,3}
stageyup = {3,2}

stagexdown = {4,3}
stageydown = {3,5}

w = 8
h = 8

up = true


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
selected=0
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




//character stats
//mx = max hp
//h = hp
//p = power
//m = magic
//s = speed


stats = {
mx = 30,
h = 30,
p = 5,
m = 5,
s = 5
}



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
{n="fire",oc=false,d="flame spell",f=-2,e="f",s=nil,x=10,t=1},
{n="ice",oc=false,d="frost spell",f=-2,e="i",s=nil,x=10,t=1},
{n="thunder",oc=false,d="electric spell",f=-2,e="t",s=nil,x=10,t=1},
{n="heal",oc=true,d="healing spell",f=2,e="f",s=nil,x=10,t=1}
}

//equipment ids
//n = name
//s = strength
//w = weakness
//d = description
//t = type
//e = equipped

equip = {
{n="red",s="f",w="i",d="fiery armor",t=0,e=false}

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
{n="blade",e="n",a=2,x=99,d="a regular blade",t=0,e=false},
{n="firesword",e="f",a=5,x=20,d="fiery blade",t=0,e=false}
}


//main menu options
mainmenu = {"e","p","w","s"}
subsel = 0

//combat menu options
combatm = {"attack", "magic", "weapon", "defend", "flee"}

function _init()

	
	stage = 1
	stageset()
	up = true
	state = "map"
	
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
	selection = 0
	
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
	add(menucontents.p, spells[1])
	add(menucontents.p, spells[2])
	add(menucontents.p, spells[3])
 add(menucontents.p, spells[4])
	
	add(menucontents.w,weapon[1])
	//add(menucontents.w,weapon[2])
	
end


function _update()

	menutime = (menutime+1)%8
	if(menutime == 0) then
		menutimeset = true
	end

//move on map
	if state == "map" then
		updatemap()
	elseif state == "combat" then
		updatecombat()
	end
	
	
end


function _draw()

	if state == "map" then
		drawmaps()
	elseif state == "combat" then
		drawcombat()
	end
	
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
	drawsprite(1)
	
	//menu window
	
	if window then
		drawmenu(window)
	end
	
	
	//fix collission
	
	print("x:"..x..",y:"..y,12)
	print("offsetx:"..offsetx..",offsety:"..offsety,0,8,12)

end

function drawsprite(face)

	spr(0,55,55)
	spr(1,63,55)
	spr(16,55,63)
	spr(17,63,63)

end


function drawmap(h,w,grid)

	for i=1,h do
		for j=1,w do
			local s = grid[j+((i-1)*w)]
			local x = ((j-1)*16)+offsetx-((centerx-.5)*16)
			local y = ((i-1)*16)+offsety-((centery-.5)*16)
			if s == "w" then		
				spr(36,x,y,2,2)
			elseif s == "q" or s=="x" or s=="y" then		
				spr(2,x,y,2,2)
			elseif s == "e" then
				spr(34,x,y,2,2)
			elseif s == "d" then
				spr(6,x,y,2,2)
			elseif s == "u" then
				spr(4,x,y,2,2)
			end
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
			
			if i-1 == selection then
				print("★"	,18,i*8+12)
			end
			print(menucontents.m[i],28,i*8+12)
		end
		
	elseif w == "c" then
	
		rectfill(16,16,56,64,0)
		rect(16,16,56,64,7)
		
		for i=1,#menucontents.m do
			
			if i-1 == subsel then
				print("★"	,18,i*8+12)
			end
			print(menucontents.m[i],28,i*8+12)
		end
	
	
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
	
		for i=1,#chara[menucontents.selected].equips do
				if i-1 == selection then
						print("★"	,35,i*8+12)
				end
				print(chara[menucontents.selected].equips[i])
		end
	
	elseif w == "p" then
	
		rectfill(32,16,96,52,0)
		rect(32,16,96,52,7)
		
		for i=1,#chara[menucontents.selected].spells do
				if i-1 == selection then
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
				if i-1 == selection then
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
	
		rectfill(32,16,96,48,0)
		rect(32,16,96,48,7)
		
		print("hp", 40, 20)
		print("atk")
		print("mag")
		print("spd")
		
		print(chara[menucontents.selected].h.."/"..chara[menucontents.selected].mx, 64, 20)
		print(chara[menucontents.selected].p)
		print(chara[menucontents.selected].m)
		print(chara[menucontents.selected].s)
	
	elseif w == "t" then
	
		rectfill(32,32,90,56,0)
		rect(32,32,90,56,7)
		
		print(subwin[subsel+1].n, 35,34)
		print(subwin[subsel+1].x, 80,34)
		for i=1,#menucontents.t do
				if i-1 == selection then
						print("★"	,35,i*8+34)
				end
				print(menucontents.t[i],44,i*8+34)
		end
		
	elseif w == "d" then
	
		rectfill(7,91,120,120,0)
		rect(7,91,120,120,7)
		
		print(windowtxt[windowcount],9,93)
	
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
			if s == "w" or s == "x" or s == "e" or s == "q" or s == "y" then
						
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
	
		if #menucontents.e < 4 then		
			add(menucontents.e, equip[n])
			windowtxt = {"you found "..equip[n].n..".", "stored in bag."}
		else
			windowtxt = {"you found "..equip[n].n..".","but your equip inventory\nis full."}
			get = false
		end

	elseif c == "x" then
		local n = flr(rnd())%#weapon+1
		
		if #menucontents.w < 4 then
			add(menucontents.w, weapon[n])
			windowtxt = {"you found "..weapon[n].n..".", "stored in bag."}
		else
			windowtxt = {"you found "..weapon[n].n..".","but your weapon inventory\nis full."}
	 	get = false
	 end

	elseif c == "y" then
		local n = flr(rnd())%#spells+1
		
		if #menucontents.p < 4 then
			add(menucontents.p, spells[flr(rnd())%#spells+1])
			windowtxt = {"you found "..spells[n].n..".", "stored in bag."}
		else
			windowtxt = {"you found "..spells[n].n..".","but your spell inventory\nis full."}
	 	get = false
	 end
	end
	
	window = "d"
	resetmenu()
	return get

end

function interact(grid)

	local index = flr(x) + (flr(y)-1)*w
	local i = false
	local inx = nil
	local get = false
	
	
	if grid[index - 1] == "x" or grid[index-1] == "q" or grid[index-1] == "y" then
		 i = true
		 inx = index - 1
		 get = getitem(grid[index-1])
	elseif grid[index + 1] == "x" or grid[index + 1] == "q" or grid[index + 1] == "y" then
			i = true
			inx = index + 1
			get = getitem(grid[index+1])
	elseif grid[index - w] == "x" or grid[index - w] == "q" or grid[index - w] == "y" then
			i = true
			inx = index - w
			get = getitem(grid[index-w])
	elseif grid[index + w] == "x" or grid[index + w] == "q" or grid[index + w] == "y" then
		 i = true
		 inx = index + w
		 get = getitem(grid[index-w])
	end
	
	
	//if interact is true, mod mapstring
	
	if i and get then
		stagemap[stage] = sub(grid, 1, inx-1).."e"..sub(grid, inx+1, #grid)
	end

end


function updatemenu(window)

	local w = window
	
	local len = 0
	
	if w == "m" then
		len = #menucontents.m
	elseif w == "c" then
		len = #menucontents.chars
	elseif w == "i" then
		len = #menucontents.i
	elseif w == "e" then
	 len = #menucontents.e
	elseif w == "w" then
		len = #menucontents.w
	elseif w == "p" then
		len = #menucontents.p
	elseif w == "t" then
		len = #menucontents.t
	else
		len = 0
	end


	if menutimeset then
		if(btn(3)) then
			selection = (selection + 1) % len
			resetmenu()
		end
		
		if(btn(2)) then
			selection = (selection - 1) % len
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
	
	if state == "map" then
		local w = window
		
		if w == "m" then
			window = nil
			selection = 0
		elseif w == "s" or w=="e" or w=="p" or w=="w" then
			window = "m"
			selection = 0
		elseif w == "t" then
			window = prev
			selection = 0
		end
	
	elseif state == "combat" then
		
		local c = combat
		
		if c == 2 or c == 4 then
			combat = 0
		end
	
	end

end


function nextmenu()

	if state == "map" then
		local w = window
		if w == "m" then
			window = "c"
			subsel = selection+1
			selection = 0	
		elseif w == "c" then
			window = mainmenu[subsel]
			menucontents.selected = selection+1
			selection = 0
		elseif w == "p" then
			window = "t"
			subwin = menucontents.p
			subsel = selection
			selection = 0
			prev = mainmenu[2]	
		elseif w == "w" then
			window = "t"
			subwin = menucontents.w
			subsel = selection
			selection = 0
			prev = mainmenu[3]
		elseif w == "t" then		
			if selection == 0 then
				useitem()
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
		end
		
	elseif state == "combat" then
		
		local c = combat
		
		if c == 0 then
			
			if selection == 0 then
				c = 1
			elseif selection == 1 then
				c = 2
			elseif selection == 2 then
				c = 4
			elseif selection == 3 then
				c = 6
			elseif selection == 4 then
				c = 7
			end
			
		end
	
	end

end


function useitem()

	if subwin[subsel+1].t == 1 then
		
		if subwin[subsel+1].oc then
			//run item effect
			//effect()
			subwin[subsel+1].x -= 1
			if subwin[subsel+1].x == 0 then
				del(subwin,subwin[subsel+1])
			end
			prevmenu()
		end
		
	else
		//unequip all item and then
		//equip one
		for i in all(subwin) do
			i.e = false
		end
		
		subwin[subsel+1].e = true
		
		prevmenu()
	end

end


function resetmenu()

	menutime = 1
	menutimeset = false
	
end


function updatemap()

if not window then
		if(btn(0)) then
		
			offsetx += spd
			position(-1,true)
			stairs(stagemap[stage])
			
			if col(stagemap[stage]) then
				position(1,true)
				offsetx -= spd
			else
				dosteps()
			end
			
		end
		
		if(btn(1)) then
			
			offsetx -= spd
			position(1,true)
			stairs(stagemap[stage])
			
			if col(stagemap[stage]) then
				position(-1,true)
				offsetx += spd
			else
				dosteps()
			end
			
		end
		
		if(btn(2)) then
		
			offsety += spd
			position(-1,false)
			stairs(stagemap[stage])
			
			if col(stagemap[stage]) then
				position(1,false)
				offsety -= spd
			else
				dosteps()
			end
			
		end
		
		if(btn(3)) then
		
			offsety -= spd
			position(1,false)
			stairs(stagemap[stage])
	
			if col(stagemap[stage]) then
				position(-1,false)
				offsety += spd
			else
				dosteps()
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

else

 updatemenu(window)
 
end


end


function dosteps()

	steps = (steps + 1)%256
	
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
//combat logic stuff



function drawcombat()

	cls(0)
	drawcmenu()
		


end

function drawcmenu()

	if combat == 0 then
		rectfill(7,7,55,55,0)
		rect(7,7,55,55,7)
		
		for i=1,#combatm do
		
			print(combatm[i], 23, 4+(i*8))
			if selection + 1 == i then
				print("★", 12, 4+(i*8))
			end
		
		end
		
	elseif combat == 2 then
	
		
	end


end

function combatmenu()

	
end


//references nextmenu and prevmenu from
//prev window
function updatecombatmenu()


	local len = #combatm
	if menutimeset then
		if(btn(3)) then
			selection = (selection + 1) % len
			resetmenu()
		end
		
		if(btn(2)) then
			selection = (selection - 1) % len
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


function updatecombat()

	updatecombatmenu()
	
end
-->8
//event + stage stuff
__gfx__
00000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000099999900000099999999997900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000099999990000099999999a9aa7900000056666500000000001dddd1000000000000000000000000000000000000000000000000000000000000000000000
000009999999000009944a4444944aa0000056666665000000001dddddd100000000000000000000000000000000000000000000000000000000000000000000
00000999999900000944494444944490000567777776500000015151515150000000000000000000000000000000000000000000000000000000000000000000
000009999999000009444944449444900056777777776500005dddd66dddd5000000000000000000000000000000000000000000000000000000000000000000
00000009999000990944494444944490055555555555555005555555555555500000000000000000000000000000000000000000000000000000000000000000
99999999000999900944494444944490556777777777765555666666666666550000000000000000000000000000000000000000000000000000000000000000
900000090990000009999a96799aa770566666777766666556666677776666650000000000000000000000000000000000000000000000000000000000000000
0000000999000000099999956999aa90555555555555555555555555555555550000000000000000000000000000000000000000000000000000000000000000
00000009000000000444444564444440666666666666666666777777777777660000000000000000000000000000000000000000000000000000000000000000
00000009000000000444444994444440666777777777666667777777777777760000000000000000000000000000000000000000000000000000000000000000
000000090000000004444449a4444440d66666666666666d77777777777777770000000000000000000000000000000000000000000000000000000000000000
00009999999900000444444994444440dd666666666666dd77777777777777770000000000000000000000000000000000000000000000000000000000000000
00999000000990000444444994444440151515155151515155555555555555550000000000000000000000000000000000000000000000000000000000000000
00900000000099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700001111110000700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000011000000700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000700000011000000700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000099999999999900700000700700000700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000951111111111590710000011000001700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000951111111111590710070011007001700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000951111111111590711101111110111700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000951111111111570711101111110111700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000009999999a999aa90710070011007001700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000004444449a4444440710000011000001700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000444444994444440700000700700000700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000004444449a4444440700000011000000700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000444444994444440700000011000000700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000444444994444440700001111110000700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000077777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
