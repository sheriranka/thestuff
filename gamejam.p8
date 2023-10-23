pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
 elchi = {x=60,y=60}
	score = 0
	life = 3
	bombs = 3
	shots = {}
	wait = 0
	invul = 0
	bombframe = 0
	power = 0
	dmg = 1

	treex = {}
	treey = {}
	tree = {}
	for i=0,72 do
		add(treex,flr(rnd(16))*8)
		add(treey,flr(rnd(16))*8)
		add(tree,flr(rnd(3)))
	end
	
	animate = 0
	
 speed = 1
 screen = "game"
 //level = 1
 --tick of stage, to gen
 --stage enemies at dif
 --points of stage
 t = 0
 stagetime = 0
 //bosstime to manage
 //boss fight time
 bosst = 0
 
 
 pickups = {}
 explosion = {}
 --x, y, frame
 
 enemies = {}
 enemyshots = {}
 
 //scroll screen
 scroll = true
 
 
 //boss fight check
 boss = {}
 bossfight = false
 bossxx = 0
 bossyy = 0
 
 
 //event scene counter
 //starts at 0
 ct = 0
 
 //event id
 eventid = 1
 
 txt = false
 //txt = true
 txtwait = 0
 
 dialogue = {t = "",sp = 0,left = 0}
 
// generateboss()
 
 
 
end



function _draw()

	if(screen == "menu") then
		
	
	elseif(screen == "game") then
		drawgame()
		
	elseif(screen=="event") then
		drawgame()
		if txt then
			drawevent()			
		end
		txtwait += 1
		
		
	elseif(screen == "gameover") then
	
	
	elseif(screen == "ending") then
	
	
	end
	
end


function _update()
	
	if(screen == "menu") then
	
	
	elseif(screen == "game") then
		updategame()
		
	elseif(screen == "event") then
	
		animatesprite()
		eventman(ct,eventid)
	
		
	elseif(screen == "gameover") then
	
	
	elseif(screen == "ending") then
	
	
	end
	
	
end
-->8

function dia(char,lr,txt)

	dialogue.t = txt
	
	if(char == 1) then
		dialogue.sp = 129
	elseif(char == 2) then
		dialogue.sp = 134
	end
	
	dialogue.left = lr //1 or 0
	//left or right side
	//of portrait

end


function eventman(c,id)

	if(id == 1) then
	
		local enddialogue = 4
		
		if(c == 0) then
			generateboss()
			ct += 1
			
		elseif(c == 1) then
		
			for s in all(boss) do
				s.y += 1
				if(s.y > 32) then
					ct += 1
					txtwait = 0
				end	
			end
	
	elseif(c == 2) then

		if txtwait > 30 then
			txt = true
			dia(1,true,"hello!")
			txtwait = 0
			ct += 1
		end
		
	elseif(c == 3) then
			
		if txtwait > 30 then
			dia(2,false,"bye!")
			txtwait = 0
			ct += 1
		end
			
			
	//add more dialogue later
	
	elseif(c == enddialogue) then
	
		if txtwait > 30 then
			txt = false
			screen = "game"
			ct = 0
			bossfight = true
		end
		
	elseif(id == 2) then
	
	
	end
	
end
	
	
	
end



function drawevent()

	
	//dialogue box
	rectfill(0,104,128,128,0)
	
	rect(0,104,127,127,7)
	
	print(dialogue.t,3,106,7)
	
	drawportrait(dialogue.left,dialogue.sp)

end



function drawportrait(left,sp)

		if left then
		
			offset = 0
			
		else
		
			offset = 96
		end
		
		
		for i=0,3 do
			for j=0,3 do
				spr(sp+j+(i*16),offset+(j*8),72+(i*8))
			end
		end

end
-->8
//enemy behavior


function generateenemy(a,_x,_y,xx,yy)

//goalx and goaly are arrays

//shot type 0 normal
//shot type 1 spread 8
//shot type 2 homing
//shot type 3 spread 16
//other shot types pending

--test enemy

	if(a == 0) then
	
		add(enemies,{
		x = _x,
		y = _y,
		hp = 1,
		sp = 36,
		dx = 1,
		dy = 0.5,
		goalx = xx,
		goaly = yy,
		//counter to goals
		//how many goals
		goals = 1,
		//how often shoot
		tick = 1,
		maxbul = 70,
		curbul = 0,
		timeout = 0,
		timeoutset = 30,
		//bullet speed
		speed = 0.5,
		//shot sprite
		shot = 7,
		//shot type
		shottype = 4,
		//points on death
		points = 0,
		times = false
		})
		
	//demon thang forward shot
	elseif(a == 1) then
	
		
		add(enemies,{
			x = _x,
			y = _y,
			hp = 3,
			sp = 49,
			dx = 0.5,
			dy = 0.5,
			goalx = xx,
			goaly = yy,
			//counter to goals
			//how many goals
			goals = 1,
			//how often shoot
			tick = 5,
			maxbul = 3,
			curbul = 0,
			timeout = 0,
			timeoutset = 60,
			//bullet speed
			speed = 2,
			//shot sprite
			shot = 8,
			//shot type
			shottype = 0,
			//points on death
			points = 1000,
			times = false
			})
			
	//demon thang circle shot
	elseif(a == 2) then
	
		add(enemies,{
				x = _x,
				y = _y,
				hp = 3,
				sp = 49,
				dx = 0.5,
				dy = 0.5,
				goalx = xx,
				goaly = yy,
				//counter to goals
				//how many goals
				goals = 1,
				//how often shoot
				tick = 5,
				maxbul = 8,
				curbul = 0,
				timeout = 0,
				timeoutset = 60,
				//bullet speed
				speed = 1,
				//shot sprite
				shot = 8,
				//shot type
				shottype = 1,
				//points on death
				points = 1000,
				times = false
				})
	
	
	elseif(a == 3) then
	
	//ghost big shot
	
		add(enemies,{
					x = _x,
					y = _y,
					hp = 25,
					sp = 55,
					dx = 0.2,
					dy = 0.2,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 30,
					maxbul = 1,
					curbul = 0,
					timeout = 0,
					timeoutset = 60,
					//bullet speed
					speed = 0.5,
					//shot sprite
					shot = 8,
					//shot type
					shottype = 5,
					//points on death
					points = 5000,
					times = false
					})
		
	
	elseif(a == 4)  then
	
	//ghost big circle shot
	add(enemies,{
					x = _x,
					y = _y,
					hp = 15,
					sp = 55,
					dx = 0.2,
					dy = 0.2,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 30,
					maxbul = 1,
					curbul = 0,
					timeout = 0,
					timeoutset = 60,
					//bullet speed
					speed = 0.5,
					//shot sprite
					shot = 8,
					//shot type
					shottype = 6,
					//points on death
					points = 5000,
					times = false
					})
		
	
	
	elseif(a == 5) then
	
	//skell aim shot
	add(enemies,{
					x = _x,
					y = _y,
					hp = 5,
					sp = 36,
					dx = 1,
					dy = 0.5,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 30,
					maxbul = 3,
					curbul = 0,
					timeout = 0,
					timeoutset = 45,
					//bullet speed
					speed = 1,
					//shot sprite
					shot = 7,
					//shot type
					shottype = 2,
					//points on death
					points = 2000,
					times = false
					})
	
	elseif(a == 6) then
	
	//skell forward shot
		add(enemies,{
					x = _x,
					y = _y,
					hp = 5,
					sp = 36,
					dx = 0.5,
					dy = 1,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 5,
					maxbul = 3,
					curbul = 0,
					timeout = 0,
					timeoutset = 20,
					//bullet speed
					speed = 0.8,
					//shot sprite
					shot = 7,
					//shot type
					shottype = 0,
					//points on death
					points = 2000,
					times = false
					})
	
	
	elseif(a == 7) then
	
	//spider spread 16
		add(enemies,{
					x = _x,
					y = _y,
					hp = 2,
					sp = 39,
					dx = 0.5,
					dy = 0.5,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 5,
					maxbul = 3,
					curbul = 0,
					timeout = 0,
					timeoutset = 75,
					//bullet speed
					speed = 0.7,
					//shot sprite
					shot = 8,
					//shot type
					shottype = 3,
					//points on death
					points = 1500,
					times = false
					})
	
	
	elseif(a == 8) then
	
	//skull spiral
	add(enemies,{
					x = _x,
					y = _y,
					hp = 7,
					sp = 52,
					dx = 0.2,
					dy = 0.2,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 10,
					maxbul = 20,
					curbul = 0,
					timeout = 0,
					timeoutset = 75,
					//bullet speed
					speed = 0.7,
					//shot sprite
					shot = 23,
					//shot type
					shottype = 4,
					//points on death
					points = 1500,
					times = false
					})
	
	
	//pumpkin big bounce
	elseif(a == 9) then
	
		add(enemies,{
					x = _x,
					y = _y,
					hp = 15,
					sp = 52,
					dx = 0.2,
					dy = 0.2,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 10,
					maxbul = 1,
					curbul = 0,
					timeout = 0,
					timeoutset = 90,
					//bullet speed
					speed = 1.2,
					//shot sprite
					shot = 23,
					//shot type
					shottype = 8,
					//points on death
					points = 5000,
					times = false
					})
	
	
	end
	
	


end


//takes stage as argument later
function generateboss()

	//3x3 boss sprite
	local _x = 64 - 8*2
	local _y = 0 - 8*2
	
	local size = 3

	local sp = 81
	
	
	//change sp for animation
	add(boss, {
	x = _x,
	y = _y,
	dx = 1,
	dy = 1,
	sz = size,
	s = sp,
	phase = 1,
	phases = 3,
	hp = 200,
	maxhp = 200,
	xx = 0,
	yy = 0,
	shottype = 0,
	shot = 0,
	timeout = 0,
	timeoutset = 60,
	curbul = 0,
	maxbul = 30,
	tick = 5,
	times = false,
	speed = 1
	})

end


function bossmanager(t,b,stage)

	local s = t%48
	//stage 1 phases
		if(stage == 1) then
			if(b.phase == 1) then
					
					//1.5 second
					if(s < 6) then
						b.xx = 96
						b.yy = 32
						b.shottype = 7
						b.shot = 8
						b.timeoutset = 30
						b.maxbul = 3
						b.tick = 10
						b.speed = 0.5
					//4 seconds
					elseif(s < 22 ) then
						b.xx = b.x
						b.yy = b.y
						b.shot = 23
						b.shottype = 4
						b.timeoutset = 60
						b.maxbul = 50
						b.tick = 6
						b.speed = 0.7
					//1.5 seconds
					elseif(s < 28) then
						b.xx = 64
						b.yy = 16
						b.shottype = 7
						b.shot = 8
						b.timeoutset = 30
						b.maxbul = 3
						b.tick = 10
						b.speed = 0.5
					//1.5 seconds
					elseif(s < 34) then
						b.xx = 24
						b.yy = 32
						b.shottype = 7
						b.shot = 8
						b.timeoutset = 30
						b.maxbul = 3
						b.tick = 10
						b.speed = 0.5
					//4 seconds
					elseif(s < 42) then
						b.xx = b.x
						b.yy = b.y
						b.shot = 23
						b.shottype = 4
						b.timeoutset = 60
						b.maxbul = 50
						b.tick = 6
						b.speed = 0.7
					//1.5 seconds
					elseif(s < 48) then
						b.xx = 64
						b.yy = 80
						b.shottype = 6
						b.timeoutset = 30
						b.maxbul = 2
						b.tick = 30
						b.speed = 0.5
					end
							
					
			elseif(b.phase == 2) then
			
					if(s < 4) then
						b.xx = 96
						b.yy = 16
						b.shottype = 3
						b.timeoutset = 1
						b.maxbul = 3
						b.tick = 15
						b.speed = 0.7
						b.shot = 8
						
						
					elseif(s < 16) then
						b.xx = b.x
						b.yy = b.y
						b.shottype = 8
						b.timeoutset = 1
						b.maxbul = 2
						b.tick = 30
						b.speed = 0.5
						b.shot = 7
						
					elseif(s < 24) then
					
						b.xx = 16
						b.yy = 48
						b.dx = 0.5
						b.shottype = 3
						b.timeoutset = 1
						b.maxbul = 3
						b.tick = 15
						b.speed = 0.7
						b.shot = 8
					
					elseif(s < 32) then
					
						b.xx = b.x
						b.yy = b.y
						b.shottype = 8
						b.timeoutset = 1
						b.maxbul = 2
						b.tick = 30
						b.speed = 0.5
						b.shot = 7
						
					elseif(s < 40) then
					
						b.xx = 96
						b.yy = 96
						b.shottype = 3
						b.timeoutset = 1
						b.maxbul = 3
						b.tick = 15
						b.speed = 0.7
						b.shot = 8
						
					else
					
						b.xx = b.x
						b.yy = b.y
						b.dx = 1
						b.shottype = 8
						b.timeoutset = 0
						b.maxbul = 2
						b.tick = 30
						b.speed = 0.5
						b.shot = 7
					
					end
					
			
			elseif(b.phase == 3) then
			
					b.xx = 52
					b.yy = 28
					b.dx = 1
					
					
					if(s < 8) then
					
					
						b.shottype = 6
						b.timeout = 0
						b.maxbul = 20
						b.tick = 10
						b.speed = 0.7
						b.shot = 8
					
					
					elseif(s<16) then
					
						b.shottype = 4
						b.timeout = 0
						b.maxbul = 400
						b.tick = 1
						b.speed = 1
						b.shot = 23
					
					
					elseif(s<24) then
					
						b.shottype = 9
						b.timeout = 0
						b.maxbul = 12
						b.tick = 2
						b.speed = 0.7
						b.shot = 7
					
					elseif(s<32) then
					
						b.shottype = 4
						b.timeout = 0
						b.maxbul = 400
						b.tick = 1
						b.speed = 1
						b.shot = 23
					
					
					elseif(s<40) then
					
						
						b.shottype = 7
						b.timeout = 0
						b.maxbul = 12
						b.tick = 2
						b.speed = 0.5
						b.shot = 8
					
					else
					
						b.shottype = 4
						b.timeout = 0
						b.maxbul = 400
						b.tick = 1
						b.speed = 1
						b.shot = 23
						
					end
			
			end
			
		end
		

end

//not in use yet

function bossatk(b,t,stage)


	if(b.phase == 1) then
	
		if(stage == 1) then
	
	
		end
	end

end


function bossmove(b,stage)

		//phases for movement
		if(b.phase == 1) then
		
			phase1(b,stage)
			
		elseif(b.phase == 2) then
		
		
		elseif(b.phase == 3) then
		
		
		elseif(b.phase == 4) then
		
		
		elseif(b.phase == 5) then
		
		end

end

-->8
function stage(t)


	//local t!!!!!
	
	//all the way to 120 t\
	//for a full minute stage
	
	//always start enemies from
	//outside the screen and make
	//them go to >128 y
	//or >128 x
	
	//generate more enemy types
	//later
	
	//check datanotebook for
	//patterns
	
	//1 demon forward
	//2 demon spread 8
	//3 ghost big
	//4 ghost big circle
	//5 skell aim
	//6 skell forward
	//7 spider spread 16
	//8 skull spiral ?
	//9 pumpkin big bounce
	
	//adjust difficulty later
	
	if(t < 3) then

		pattern4(2)
	
	elseif(t > 7 and t < 15) then
	
		pattern1(1)
		
	
 elseif(t == 20) then
 
 	pattern5(6)
 	pattern7(6)
		
	elseif(t == 24) then
	
		pattern6(3)
	

	elseif(t>29 and t<35) then
	
		pattern6(7)
	
	
	elseif(t==45) then
	
		//pattern5(4)
		pattern9(9)
		
 elseif(t>49 and t<53) then
 
 	pattern6(8)
	
	
 elseif(t>60 and t<63) then
	
		pattern2(7)
	
	
	elseif(t>68 and t<78) then
	
		pattern4(5)
	
	
	elseif(t>80 and t<94) then
	
		pattern2(1)
		if(t < 84) then
			pattern4(2)
		end
	
	
	elseif(t > 99 and t < 102) then
		pattern8(7)
	
	
 elseif(t>105 and t<110) then
 
 	pattern1(1)
	
	
	elseif(t == 120) then
	
		scroll = false
	//start boss dialogue
	//start boss fight
	
	elseif(t == 145) then
	
		screen = "event"
		
	end


end


function pattern1(e)

	local xx = {108,8,108}
 local yy = {32,96,130}
 generateenemy(e,20,20,xx,yy)

end


function pattern2(e)

		local xx = {64,96,64,32,130}
		local yy = {64,48,32,48,112}
		generateenemy(e,0,48,xx,yy)

end


function pattern3(e)

		local xx = {64,96,104,48,130}
		local yy = {64,96,64,96,32}
		generateenemy(e,0,48,xx,yy)
		
end


function pattern4(e)

		local xx1	= {80,96,112}
		local xx2	= {48,32,8}
		local yy = {48,32,130}
		
		generateenemy(e,64,0,xx1,yy)
		generateenemy(e,64,0,xx2,yy)
	
end


function pattern5(e)

		local xx = {64}
		local yy = {130}
		
		generateenemy(e,16,0,xx,yy)
		generateenemy(e,104,0,xx,yy)

end


function pattern6(e)

	local xx = {64,104,64,32,64,80,64}
	local yy = {8,64,104,64,48,64,130}
		
	generateenemy(e,0,64,xx,yy)

end


function pattern7(e)

		local xx1	= {8,56}
		local xx2	= {112,72}
		local yy = {64,130}
		
		generateenemy(e,56,0,xx1,yy)
		generateenemy(e,72,0,xx2,yy)

end


function pattern8(e)

	local xx1 = {48,32,16,16}
	local xx2 = {80,96,112,112}
	local yy = {32,16,32,130}

	generateenemy(e,56,120,xx1,yy)
	generateenemy(e,72,120,xx2,yy)


end


function pattern9(e)

	local xx1 = {48,32,16}
	local xx2 = {80,96,112}
	local yy = {32,64,130}

	generateenemy(e,64,16,xx1,yy)
	generateenemy(e,64,16,xx2,yy)

end


function pattern10(e)

	local xx = {64,130}
	local yy = {104,48}

	generateenemy(e,0,48,xx,yy)

end
-->8
function drawgame()

--clear screen
	cls(2)
	drawforest()
	
--draw bullets
	for s in all(shots) do
		spr(s.s, s.x, s.y)
	end
	
	for s in all(enemyshots) do
		spr(s.s, s.x, s.y)
	end	
	
	
--draw character
	if (invul % 3 == 1) then
		spr(17,elchi.x,elchi.y)
	else
		spr(animate+1,elchi.x,
		elchi.y)
	end
		
--draw enemies

	for s in all(enemies) do
		spr(s.sp+animate,s.x,s.y)
	end

--draw boss

	for c in all(boss) do
		for i=0,c.sz-1 do
			for j=0,c.sz-1 do
				spr(c.s+(i*16)+j,c.x+(j*8),c.y+(i*8))
			end
		end
	end


--draw explosions
	for i in all(explosion) do
		spr(i.frame+9, i.x, i.y)
	end
	
--draw pickups
	for p in all(pickups) do
		spr(42, p.x, p.y)
	end
	
--bg stuff
	print("score:"..score,0,120)
	print("lives:"..life,100,120)	
	print("bombs:"..bombs,100,112)
	print("power:"..power,0,112)
	
	if scroll then
		aniforest()
	end
--draw bomb

if(bombframe > 0) then
	circ(64,64,bombframe*4,7)
	
	shkx = ((bombframe%2)*-2)+1
	shky = ((bombframe%2)*-2)+1
	
	camera(shkx,shky)
	
else
	
	camera(0,0)
	
end

	if(bossfight) then
	for b in all(boss) do
		print(b.hp,0,0)
	end
	end
	
end

function drawforest()
	for i=1,#treex do
		spr(tree[i]+3,treex[i], treey[i])
	end
end


function aniforest()
	for i=1,#treey do
		treey[i] += 1
		
		if(treey[i] > 128) then
			treey[i] = 1
		end
	end
end
-->8
function updategame()


	
//12 second time tracker
	t = (t + 1)%360
	
	if(t%15 == 0) then		
		if not bossfight then
			stagetime += 1
			stage(stagetime)
		else
			bosst += 1
		end
		
	end
	
//update bomb
	if(bombframe > 0 and bombframe <= 20) then
		//erase all enemies onscreen
		for e in all(enemies) do
			del(enemies, e)
			add(explosion, {x = e.x,
				y=e.y,frame=0})
			score += flr(e.points*0.75)
		end
		//erase bullets
		for b in all(enemyshots) do
			del(enemyshots, b)
		end
		bombframe += 1
		
	elseif(bombframe > 20) then
		bombframe = 0
	end

--animate :)

	animate = (t/4)%2
	
	
	
--enemy movement & shots

	for s in all(enemies) do
	
		local xgoal = false
		local ygoal = false
		
		if(s.x < s.goalx[s.goals]) then
			s.x += s.dx
		elseif(s.x > s.goalx[s.goals]) then
		 s.x -= s.dx
		else
			xgoal = true
		end
		
		if(s.y < s.goaly[s.goals]) then
			s.y += s.dy
		elseif(s.y > s.goaly[s.goals]) then
		 s.y -= s.dy
		else
			ygoal = true
		end
		
		if(xgoal and ygoal) then
			s.goals += 1
		end
		
		if(s.curbul == s.maxbul) then
			s.times = true
		end
		
		if(s.times) then
			s.timeout -= 1
		end
		
		if(s.timeout <= 0) then
			s.curbul = 0
			s.timeout = s.timeoutset
			s.times = false
		end
		
		if(t%s.tick == 0 and s.curbul < s.maxbul) then
			enemyshot(s,s.x,s.y)
			s.curbul += 1
		end
		
		if (s.y > 128 or s.x > 128) then
			del(enemies, s)
		end
	end
		
--boss move
	if bossfight then
		for b in all(boss) do
	
			bossmanager(bosst,b,1)
		//movement
			if(b.x < b.xx) then
			b.x += b.dx
			elseif(b.x > b.xx) then
			 b.x -= b.dx
			end
			
			if(b.y < b.yy) then
					b.y += b.dy
			elseif(b.y > b.yy) then
				 b.y -= b.dy
			end
			
		if(b.curbul == b.maxbul) then
			b.times = true
		end
		
		if(b.times) then
			b.timeout -= 1
		end
		
		if(b.timeout <= 0) then
			b.curbul = 0
			b.timeout = b.timeoutset
			b.times = false
		end
		
		if(t%b.tick == 0 and b.curbul < b.maxbul) then
			enemyshot(b,b.x+8,b.y+8)
			b.curbul += 1
		end
	
			
		end
	end
	
-- boundaries
 if(elchi.x > 120) then
 	elchi.x = 120
 elseif(elchi.x < 0) then
 	elchi.x = 0
 end
 
 if(elchi.y > 120) then
 	elchi.y = 120
 elseif(elchi.y < 0) then
 	elchi.y = 0
	end
	
	
--invul frames
	invul -= 1
	if(invul < 0) then invul = 0 end
	

	
--controls
--only work when not
--dialogue event
--fix this please
--doesnt work when not event 


	if btn(0) then elchi.x-=speed end
	if btn(1) then elchi.x+=speed end
	if btn(2) then elchi.y-=speed end
	if btn(3) then elchi.y+=speed end	
	
--bullet


 if btn(4) then
 	shot()
	end
	
	if btn(5) then
		if(bombs > 0 and bombframe == 0) then
			bombs -= 1
			if(bossfight) then
				for b in all(boss) do
					b.hp -= 100
				end
			end
			bomb()
		end
	end

 
 if wait>0 then
  wait-=1
 end
 
 doshots()

	
--collision

--player
if(invul == 0) then
//enemy
	for e in all(enemies) do
		if colplayer(elchi,e) then
			add(explosion, {x = elchi.x,
				y=elchi.y,frame=0})
			life -= 1
			elchi.x = 64
			elchi.y = 112
			invul = 30
			power -= 25
			clearbullet()
			updatedmg()
		end
	end

//enemy bullets
	for b in all(enemyshots) do
	if colplayer(elchi,b) then
			add(explosion, {x = elchi.x,
				y=elchi.y,frame=0})
			life -= 1
			elchi.x = 64
			elchi.y = 112
			invul = 60
			power -= 25
			updatedmg()
			clearbullet()
		end
	end
	
end

--enemy

	for s in all(shots) do
		for e in all(enemies) do
		
			if colother(s,e) then
				del(shots, s)
				e.hp -= dmg
				if (e.hp <= 0) then
					del(enemies, e)
					add(explosion, {x = e.x,
				y=e.y,frame=0})
					score += e.points
					pickup(e)
				end
			end
		end
		
		//boss
		for b in all(boss) do
		
			if(colboss(b,s)) then
				del(shots,s)
				b.hp -= dmg
				if(b.hp <= 0) then
					b.hp = b.maxhp
					b.phase += 1
					if(b.phase > b.phases) then
						screen = "event"
						evendid = 2
					end
				end
			end
		end
	end	
	
--pickups + update pickup

	for p in all(pickups) do
	
		if p.y > 128 then
			del(pickups, p)
		end
		
		if colother(p, elchi) then
			power += 5
			del(pickups, p)
			updatedmg()
			
		end
		
		p.y += p.dy
	
	end
	
	
--update explosion frame
	for e in all(explosion) do
		e.frame += 1
		if(e.frame > 3) then
			del(explosion, e)
		end
	end
		
end

--shots enemy + player

function enemyshot(enemy,_x,_y)

	//easier enemy shot type
	local tpe = enemy.shottype
	
	
	//regular shot
	if (tpe == 0) then
		add(enemyshots, {
		x = _x,
		y = _y+8,
		dy = enemy.speed,
		dx = 0,
		s = enemy.shot
		})
		
	//spread shot 8
	elseif (tpe == 1) then
	
		for i=0,1,0.125 do
		
			add(enemyshots, {
				x = _x,
				y = _y,
				dy = cos(i)*enemy.speed,
				dx = sin(i)*enemy.speed,
				s = enemy.shot,
				sp = false,
				spd = enemy.speed
			})
		end
		
	//aimed shot
	elseif(tpe == 2) then
	
		if(_x > elchi.x) then
			_dx = -1
		else
			_dx = 1
		end
		
		add(enemyshots, {
				x = _x,
				y = _y+8,
				dy = enemy.speed*1.5,
				dx = enemy.speed*_dx,
				s = enemy.shot,
				sp = false,
				spd = enemy.speed
			})
	
	//spread shot 16
	elseif(tpe == 3) then
	
	for i=0,1,0.0755 do
			add(enemyshots, {
				x = _x,
				y = _y,
				dy = cos(i)*enemy.speed,
				dx = sin(i)*enemy.speed,
				s = enemy.shot,
				sp = false,
				spd = enemy.speed
			})
		end
		
	//spiral shot 
	//doesnt work
	elseif(tpe == 4) then
	
			
		add(enemyshots, {
			x = _x,
			y = _y,
			dy = cos(t*8/360)*enemy.speed,
			dx = sin(t*8/360)*enemy.speed,
			s = enemy.shot,
			sp = false,
			spd = enemy.speed
		})
		
	//big shot
	elseif (tpe == 5) then
	
			add(enemyshots, {
				x = _x-4,
				y = _y-4,
				dy = enemy.speed,
				dx = 0,
				s = 44,
				sp = false,
				spd = enemy.speed
			})
			
			add(enemyshots, {
				x = _x+4,
				y = _y-4,
				dy = enemy.speed,
				dx = 0,
				s = 45,
				sp = false,
				spd = enemy.speed
			})
	
	
			add(enemyshots, {
				x = _x-4,
				y = _y+4,
				dy = enemy.speed,
				dx = 0,
				s = 60,
				sp = false,
				spd = enemy.speed
			})
			
			
			add(enemyshots, {
				x = _x+4,
				y = _y+4,
				dy = enemy.speed,
				dx = 0,
				s = 61,
				sp = false,
				spd = enemy.speed
			})
	
	//big shot circle
	elseif (tpe == 6) then
	
		for i=0,1,0.125 do
	
			add(enemyshots, {
					x = _x-4,
					y = _y-4,
					dy = cos(i)*enemy.speed,
					dx = sin(i)*enemy.speed,
					s = 44,
					sp = false,
					spd = enemy.speed
				})
				
				add(enemyshots, {
					x = _x+4,
					y = _y-4,
					dy = cos(i)*enemy.speed,
					dx = sin(i)*enemy.speed,
					s = 45,
					sp = false,
					spd = enemy.speed
				})
		
		
				add(enemyshots, {
					x = _x-4,
					y = _y+4,
					dy = cos(i)*enemy.speed,
					dx = sin(i)*enemy.speed,
					s = 60,
					sp = false,
					spd = enemy.speed
				})
				
				
				add(enemyshots, {
					x = _x+4,
					y = _y+4,
					dy = cos(i)*enemy.speed,
					dx = sin(i)*enemy.speed,
					s = 61,
					sp = false,
					spd = enemy.speed
				})
	
		end
	
	//forward bounce
	elseif (tpe == 7) then
		
		for i=0.1,0.4,0.05 do
			
			add(enemyshots, {
				x = _x,
				y = _y,
				dy = sin(-i)*enemy.speed,
				dx = cos(-i)*enemy.speed,
				s = enemy.shot,
				sp = true,
				spd = enemy.speed
			})
		end	
	
	
	//big shot bounce
	elseif (tpe == 8) then
	
	for i=0.2,0.4,0.1 do
			
			add(enemyshots, {
					x = _x-4,
					y = _y-4,
					dy = sin(-i)*enemy.speed,
					dx = cos(-i)*enemy.speed,
					s = 44,
					sp = true,
					spd = enemy.speed
				})
				
				add(enemyshots, {
					x = _x+4,
					y = _y-4,
					dy = sin(-i)*enemy.speed,
					dx = cos(-i)*enemy.speed,
					s = 45,
					sp = true,
					spd = enemy.speed
				})
		
		
				add(enemyshots, {
					x = _x-4,
					y = _y+4,
					dy = sin(-i)*enemy.speed,
					dx = cos(-i)*enemy.speed,
					s = 60,
					sp = true,
					spd = enemy.speed
				})
				
				
				add(enemyshots, {
					x = _x+4,
					y = _y+4,
					dy = sin(-i)*enemy.speed,
					dx = cos(-i)*enemy.speed,
					s = 61,
					sp = true,
					spd = enemy.speed
				})
	end	
	
	
	//circle bounce
	//doesnt work
	elseif (tpe == 9) then
	
		for i=0,1,0.0755 do
			add(enemyshots, {
				x = _x,
				y = _y,
				dy = cos(i)*enemy.speed,
				dx = sin(i)*enemy.speed,
				s = enemy.shot,
				sp = true,
				spd = enemy.speed
			})
		end
		
	//type 10 or -1 for nothing 
	//for a pause
	
	end
		
end


function shot()

	if(wait <= 0 and #shots < 50) then
	
		local speed = -7
		
		wait = 3
		
		add(shots, {
			x = elchi.x,
			y = elchi.y,
			dy = speed,
			dx = 0,
			s = 0
		})
		
	end		

end


function doshots()

	for s in all(shots) do
	
		s.y += s.dy
		s.x += s.dx
		
		if(s.y < 0) then
			del(shots,s)
		end
		
	end
	
	for s in all(enemyshots) do
	

		s.y += s.dy
		s.x += s.dx
	
		
		if(s.y > 128) then
			del(enemyshots,s)
		end
		
		if(not s.sp) then
			if(s.y < 0 or s.x > 128 or s.x < 0) then
				del(enemyshots,s)
			end
		else
			if(s.y < 0) then s.dy = -s.dy end
			if(s.x > 128 or s.x < 0) then s.dx = -s.dx end
		end
		
	end
	
end


--col function

function colplayer(a,b)

	if(abs(a.x+2 - b.x+2) < 2 and
				abs(a.y+2 - b.y+2) < 2) then
				
				return true
				
	else
		return false
		
	end
end


function colother(a,b)

	if(abs(a.x - b.x) < 8 and
				abs(a.y - b.y) < 8) then
				
				return true
				
	else
		return false
		
	end

end


function colboss(a,b)

	//a is boss sorry
	if(abs(a.x+12 - b.x) < 12 and
				abs(a.y+12 - b.y) < 12) then
				
				return true
				
	else
		return false
		
	end

end


function bomb()

	invul = 20
	bombframe = 1

end

//50% chance of drop
function pickup(enemy)

	if rnd()>0.1 then
		add(pickups,{
		x = enemy.x,
		y = enemy.y,
		dy = 1})
	end

end


function updatedmg()

//update dmg
			if power > 100 then
				power = 100
			end
			
			if power == 100 then
				dmg = 10
			elseif power > 75 then
				dmg = 7
			elseif power > 50 then
				dmg = 5
			elseif power > 25 then
				dmg = 3
			else
				dmg = 1
			end
			
			if power < 0 then
				power = 0
			end

end


function clearbullet()


	for b in all(enemyshots) do
		del(enemyshots,b)
	end

end

function animatesprite()

	t = (t + 1)%360
	
	if(t%15 == 0) then
		animate = t%2
	end

end
__gfx__
0000000000bb800000bb800000000000003000000000000000000000000000000000000000000000000000000000000007000070000000000000000000000000
0000000000bb300000bb300000030000033300300010033000000000009999000011110000000000000000000070070070000007000000000000000000000000
007007000bb33c000bb33c000033300003330b330010333300000000090000900100001000000000000770000700007000000000000000000000000000000000
000770000ccccc000ccccc00003330b00333bbb30111333300000000090aa090010cc01000077000007007000000000000000000000000000000000000000000
000770000f111f000f111f0000333bbb0333bbb30111033000000000090aa090010cc01000077000007007000000000000000000000000000000000000000000
007007000cccc0000cccc00003333bbb0333bbbb0111004000000000090000900100001000000000000770000700007000000000000000000000000000000000
000000000010f00000f0100000040bbb004004000040040000000000009999000011110000000000000000000070070070000007000000000000000000000000
00000000000010000010000000000040004000000040040000000000000000000000000000000000000000000000000007000070000000000000000000000000
00000000000000000000000000000000000000000000000000000000000090000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000090000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000000
00000000000b3000000000000000000000000000000000000000000009999a990000000000000000000000000000000000000000000000000000000000000000
000000000003b0000000000000000000000000000000000000000000009999900000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000009999900000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000099000990000000000000000000000000000000000000000000000000000000000000000
0000000000005000000050000000000000777000007770000000000000000000000000000000000000c00c000000000000000999999000000000000000000000
000000000005300000053000000000000037300000373000000000000001111000011110000000000c1111c00000000000099000000990000000000000000000
00000000099999900999999000000000007770000077700000000000050111100501111000000000c1a11a1c0000000000900000000009000000000000000000
000000009449944998999989000000000707070007070700000000005051151550511515000000000111aaa00000000009000000000000900000000000000000
0000000099999999998998990000000080777080807770800000000050881505508815050000000001111a1000000000090000aaaa0000900000000000000000
00000000994994999499994900000000000700000007000000000000505505055055050500000000c11a111c0000000090000a0000a000090000000000000000
000000000997499009444490000000000070700000707000000000000001050050000005000000000c1111c0000000009000a000000a00090000000000000000
0000000000000000000000000000000000007000007000000000000000000000000000000000000000c00c00000000009000a007700a00090000000000000000
00000000000000000000000000000000000c0000000ccc000000000000000000000000000000000000000000000000009000a007700a00090000000000000000
00000000020200000202000200000000000ccc00000cccc00000000007770000077700000000000000000000000000009000a000000a00090000000000000000
0000000008280002082800020000000000c777c000c777cc00000000087800000878000000000000000000000000000090000a0000a000090000000000000000
000000000222200202222002000000000cc070c000c070cc000000000777000007770000000000000000000000000000090000aaaa0000900000000000000000
000000000002220200022202000000000cc777c000c777cc00000000077070000777700000000000000000000000000009000000000000900000000000000000
000000006620222266202220000000000ccc7cc0000c7ccc00000000077777070777770000000000000000000000000000900000000009000000000000000000
0000000000666600006666000000000000cccc000000ccc000000000007070700077070700000000000000000000000000099000000990000000000000000000
0000000066000000660000000000000000cc00000000c00000000000000707000000707000000000000000000000000000000999999000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000001111888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000111188111188888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001118811111118888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011181111111111888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011811111111111888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000118111111111111188888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000188811111111111188888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000181811111188811188888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000188881888188111188888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000881181818118818888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888881888188818188888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000811111111111118888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000811111111118888888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000881111111111118888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888111111111188888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888881111118888888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888888888888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888888888888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888888888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888888888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000888888888888888888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000088888888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000008888888888888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088888888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000033333330000000000000000000000000000000003333333000000000000000000000000000000000000000000000000000000000000
00000000000000000033300000003330000000000000000000000000003330000000333000000000000000000000000000000000000000000000000000000000
00000000000000003300000000000003300000000000000000000000330000000000000330000000000000000000000000000000000000000000000000000000
00000000000000030000000000000000030000000000000000000003000000000000000003000000000000000000000000000000000000000000000000000000
00000000000000300000000000000000003000000000000000000030000000000000000000300000000000000000000000000000000000000000000000000000
00000000000003000000000000000000000300000000000000000300000000000000000000030000000000000000000000000000000000000000000000000000
00000000000030000000000000000000000030000000000000003000000000000000000000003000000000000000000000000000000000000000000000000000
000000000003000000000000000000000000030000000000000300000000cccccc00000000000300000000000000000000000000000000000000000000000000
00000000000300000000000880000000000003000000000000030000000000000cc0000000000300000000000000000000000000000000000000000000000000
0000000000300000000000088000000000000030000000000030000000000000000c000000000030000000000000000000000000000000000000000000000000
0000000000300000000000808000000000000030000000000030000000000000000c000000000030000000000000000000000000000000000000000000000000
0000000000300000000008808000000000000030000000000030000000000000000c000000000030000000000000000000000000000000000000000000000000
0000000003000000000008008000000000000003000000000300000000000000000c000000000003000000000000000000000000000000000000000000000000
000000000300000000000000800000000000000300000000030000000000000000c0000000000003000000000000000000000000000000000000000000000000
000000000300000000000000800000000000000300000000030000000000000000c0000000000003000000000000000000000000000000000000000000000000
0000000003000000000000000800000000000003000000000300000000000000cc00000000000003000000000000000000000000000000000000000000000000
0000000003000000000000000800000000000003000000000300000000000000c000000000000003000000000000000000000000000000000000000000000000
00000000030000000000000008000000000000030000000003000000000000cc0000000000000003000000000000000000000000000000000000000000000000
0000000003000000000000000800000000000003000000000300000000000cc00000000000000003000000000000000000000000000000000000000000000000
00000000003000000000000008000000000000300000000000300000000ccccccc00000000000030000000000000000000000000000000000000000000000000
00000000003000000000000008000000000000300000000000300000000000000ccc000000000030000000000000000000000000000000000000000000000000
00000000003000000000000008000000000000300000000000300000000000000000000000000030000000000000000000000000000000000000000000000000
00000000000300000000888888888000000003000000000000030000000000000000000000000300000000000000000000000000000000000000000000000000
00000000000300000000000000000000000003000000000000030000000000000000000000000300000000000000000000000000000000000000000000000000
00000000000030000000000000000000000030000000000000003000000000000000000000003000000000000000000000000000000000000000000000000000
00000000000003000000000000000000000300000000000000000300000000000000000000030000000000000000000000000000000000000000000000000000
00000000000000300000000000000000003000000000000000000030000000000000000000300000000000000000000000000000000000000000000000000000
00000000000000030000000000000000030000000000000000000003000000000000000003000000000000000000000000000000000000000000000000000000
00000000000000003300000000000003300000000000000000000000330000000000000330000000000000000000000000000000000000000000000000000000
00000000000000000033300000003330000000000000000000000000003330000000333000000000000000000000000000000000000000000000000000000000
00000000000000000000033333330000000000000000000000000000000003333333000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888eeeeee888777777888eeeeee888eeeeee888eeeeee888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88ee88eee88778887788ee888ee88ee8e8ee88ee888ee88888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee8eeee8eee8777778778eeeee8ee8eee8e8ee8eee8eeee88888e88888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8eeee8eee8777888778eeee88ee8eee888ee8eee888ee8888eee8888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee8eeee8eee8777877778eeeee8ee8eeeee8ee8eeeee8ee88888e88888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee8eee888ee8777888778eee888ee8eeeee8ee8eee888ee888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee8eeeeeeee8777777778eeeeeeee8eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111117111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111117771111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111117777111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111171111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d1ddd1ddd1ddd1ddd1ddd1ddd1ddd1ddd1ddd1ddd1ddd1ddd1111
11d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d1111d111d111d111d111d111d111d111d111d111d111d111d1111
11d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d1111d111d111d111d111d111d111d111d111d111d111d111d1111
11d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d1111d111d111d111d111d111d111d111d111d111d111d111d1111
1d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d111d11111d111d111d111d111d111d111d111d111d111d111d111d1111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822882228222888282288282828288888888888888888888888888888888888882228222822282228882822282288222822288866688
82888828828282888888882882828282882888288282828288888888888888888888888888888888888888828282828282828828828288288282888288888888
82888828828282288888882882828222882888288222822288888888888888888888888888888888888882228222828282828828822288288222822288822288
82888828828282888888882882828282882888288882888288888888888888888888888888888888888882888882828282828828828288288882828888888888
82228222828282228888822282228222828882228882888288888888888888888888888888888888888882228882822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

