pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
 elchi = {x=60,y=104,sp=90,spd=1}
	score = 0
	//for testing purposes
	//change to 3 each later
	life = 2
	bombs = 3
	
	
	shots = {}
	wait = 0
	invul = 0
	bombframe = 0
	power = 0
	dmg = 1
	animate = 0


	grassx = {}
	grassy = {}
	grass = {}
	for i=0,150 do
		add(grassx,flr(rnd(16))*8)
		add(grassy,flr(rnd(16))*8)
		add(grass,flr(rnd(3)))
	end
	
	treex = {}
	treey = {}
	tree = {}
	for i=0,72 do
		add(treex,flr(rnd(16))*8)
		add(treey,flr(rnd(16))*8)
		add(tree,flr(rnd(3)))
	end
	
	animate = 0
	
	//player spd
 speed = 1
 
 //state
 screen = "start"
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
 ct = 1
 
 //event id
 eventid = 1
 
 txt = false
 //txt = true
 txtwait = 0
 
 dialogue = {t = "",sp = 0,left = 0}
 
 //intro stuff
 
 introticks = 99
 
 introtxt = ""
 
 introcount = 1
 
 //ending stuff
 
 edticks = 99
 
 edtxt = ""
 
 edcount = 1
 
 //game over time restart
 //counter
 
 goticks = 0
 
 
	//tracks, 10 = stage
  
 //on start play sfx
 sfx(11)
	sfx(12)
	
	
	//intro music
	
	//stage music
	
	//boss music
	//music(6) //or music(20)
	//ed music 
	
	
end



function _draw()

	if(screen == "start") then
	 drawstart()
	 
	elseif(screen == "intro") then
		drawintro()
			
	elseif(screen == "game") then
		drawgame()
		
	elseif(screen=="event") then
		drawgame()
		if txt then
			drawevent()			
		end
		txtwait += 1
		
		
	elseif(screen == "gameover") then
		drawgameover()
	
	elseif(screen == "ending") then
		drawed()
	
	elseif(screen == "test") then
	
		cls(12)
		print("music test",48,64,0)
	end
	
end


function _update()
	
	if(screen == "start") then
		updatestart()
		
	elseif(screen == "intro") then
		updateintro(introticks,introcount)
		introticks += 1
	
	elseif(screen == "game") then
		updategame()
		
	elseif(screen == "event") then
	
		animatesprite()
		eventman(ct,eventid)
	
		
	elseif(screen == "gameover") then
		goticks += 1
		music(-1)
		if(goticks > 150) then
			_init()
		end
	
	elseif(screen == "ending") then
		updateed(edticks,edcount)
		edticks += 1
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


	//pre boss dialogue
	if(id == 1) then
	
		local enddialogue = 12
		local w = 120
		
		if(c == 0) then
			music(-1)
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
	
				txt = true
				dia(1,true,"hi aku! i haven't seen you\nin a while!")
				txtwait = 0
				ct += 1
			
		elseif(c == 3) then
				
			if txtwait > w then
				dia(2,false,"what is wrong with you?!\nwhy are you killing everything??")
				txtwait = 0
				ct += 1
			end
				
		elseif(c == 4) then
		
			if txtwait > w then
				dia(1,true,"i got a new gun. wanted\nto test it out.")
				txtwait = 0
				ct += 1
			end
		
		elseif(c==5) then
		
			if txtwait > w then
				dia(2,false,"are you stupid?? it's\n*our* month. go away!")
				txtwait = 0
				ct += 1
			end
			
		elseif(c==6) then
		
			if txtwait > w then
				dia(1,true,"but i'm having fun? it's\nfun. you should try it.")
				txtwait = 0
				ct += 1
			end
			
			
		elseif(c==7) then
		
			if txtwait > w then
				dia(2,false,"what, are you gonna shoot\nme too?")
				txtwait = 0
				ct += 1
			end
			
		elseif(c==8) then
			
			if txtwait > w then
				dia(1,true,"i would never do that! i love\nyou ^_^♥")
				txtwait = 0
				ct += 1
			end
			
		elseif(c==9) then
		
			if txtwait > w then
				dia(2,false,"as if i believe you.")
				txtwait = 0
				ct += 1
			end
			
		elseif(c==10) then
		
			if txtwait > w then
				dia(1,true,"aku, don't be like that ˇ")
				txtwait = 0
				ct += 1
			end
		
		elseif(c==11) then
		
			if txtwait > w then
				dia(2,false,"oh shut up!")
				txtwait = 0
				ct += 1
			end
		
		elseif(c == enddialogue) then
		
			if txtwait > w then
				txt = false
				screen = "game"
				ct = 0
				bossfight = true
				music(6)
			end
		end
			
		//end dialogue 
		
	elseif(id == 2) then
	
		//post battle dialogue
		local enddialogue = 12
		local w = 120
		
		if(c == 0) then
			//generateboss()
			if(txtwait > 20) then
					music(-1)
				for s in all(boss) do
						s.y += 1
						if(s.y > 32) then
							ct += 1
							txtwait = 0
							ct += 1
						end	
				end
			end
				
			
		elseif(c == 1) then
		
			txt = true
			dia(2,false,"leave me alone! you idiot!")
			txtwait = 0
			ct += 1
	
		elseif(c == 2) then
	
			if txtwait > w then
				dia(1,true,"aku!! i'm sorry!!!")
				txtwait = 0
				ct += 1
			end
			
		elseif(c == 3) then
		
			if txtwait > w then
				dia(2,false,"ughhh! i've had it with you!")
				txtwait = 0
				ct += 1
			end
		
		elseif(c==4) then
			
			if txtwait > w then
					dia(1,true,"but aku, you attacked me first.")
					txtwait = 0
					ct += 1
				end
		
		elseif(c==5) then
		
			if txtwait > w then
				dia(2,false,"and *why* do you think i did\nthat? hm?")
				txtwait = 0
				ct += 1
			end
		//boss leave
		
		elseif(c==6) then
		
			if txtwait > w then
				dia(1,true,"uhhh…,………")
				txtwait = 0
				ct += 1
			end
		
		elseif(c==7) then
		
			if txtwait > w then
					dia(2,false,"i can't take dealing with\nyou anymore. goodbye!")
					txtwait = 0
					ct += 1
				end
		
		elseif(c == 8) then
				
			if(txtwait > w) then
			//stop displaying text
				txt = false
			
				for s in all(boss) do
					s.y -= 1
					if(s.y < -32) then
						del(boss,s)
						ct += 1
						txtwait = 0
					end	
				end
			
			end
			
		elseif(c == 9) then
	
			if txtwait > w then
				txt = true
				dia(1,false,"aku, wait up!")
				txtwait = 0
				ct += 1
			end
		
		elseif(c == enddialogue) then
			
				if txtwait > w then
					txt = false
					elchi.y -= speed
					if(elchi.y<-16) then
						screen = "ending"
						music(26)
					end
				end
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
		
			offset = 1
			rectfill(1,72,32,103,0)
			rect(0,71,33,103,7)
			
		else
		
			offset = 95
			rectfill(95,72,126,103,0)
			rect(94,71,127,103,7)
		end
		
		
		
		for i=0,3 do
			for j=0,3 do
				spr(sp+j+(i*16),offset+(j*8),71+(i*8))
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
			points = 100,
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
				points = 100,
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
					points = 500,
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
					points = 500,
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
					points = 200,
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
					points = 200,
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
					points = 150,
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
					tick = 3,
					maxbul = 50,
					curbul = 0,
					timeout = 100,
					timeoutset = 75,
					//bullet speed
					speed = 0.7,
					//shot sprite
					shot = 23,
					//shot type
					shottype = 4,
					//points on death
					points = 150,
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
					points = 500,
					times = false
					})
	
		//bat cross shot
	
		elseif(a == 10) then
	
		add(enemies,{
					x = _x,
					y = _y,
					hp = 5,
					sp = 20,
					dx = 1,
					dy = 0.5,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 10,
					maxbul = 5,
					curbul = 0,
					timeout = 0,
					timeoutset = 50,
					//bullet speed
					speed = 1.2,
					//shot sprite
					shot = 7,
					//shot type
					shottype = 10,
					//points on death
					points = 500,
					times = false
					})
					
	//bat x shot
	elseif(a == 11) then
	
		add(enemies,{
					x = _x,
					y = _y,
					hp = 5,
					sp = 20,
					dx = 1,
					dy = 0.5,
					goalx = xx,
					goaly = yy,
					//counter to goals
					//how many goals
					goals = 1,
					//how often shoot
					tick = 10,
					maxbul = 5,
					curbul = 0,
					timeout = 0,
					timeoutset = 50,
					//bullet speed
					speed = 1.2,
					//shot sprite
					shot = 8,
					//shot type
					shottype = 11,
					//points on death
					points = 500,
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
	hp = 250,
	maxhp = 250,
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
	speed = 1,
	points = 5000
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
						b.timeoutset = 15
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
						b.dy = 2
						b.shottype = 8
						b.timeoutset = 15
						b.timeout = 0
						b.maxbul = 9
						b.tick = 15
						b.speed = 0.7
						b.shot = 7
						
						
					elseif(s < 16) then
						b.dy = 1
						b.xx = b.x
						b.yy = b.y
						b.shottype = 9
						b.timeoutset = 5
						b.maxbul = 10
						b.tick = 5
						b.speed = 0.8
						b.shot = 7
						
					elseif(s < 24) then
					
						b.xx = 8
						b.yy = 48
						b.dx = 0.5
						b.shottype = 3
						b.timeoutset = 15
						b.maxbul = 30
						b.timeout = 0
						b.tick = 10
						b.speed = 0.7
						b.shot = 8
					
					elseif(s < 32) then
					
						b.xx = b.x
						b.yy = b.y
						b.shottype = 4
						b.timeoutset = 20
						b.maxbul = 50
						b.tick = 2
						b.speed = 0.5
						b.shot = 7
						
					elseif(s < 40) then
					
						b.xx = 96
						b.yy = 96
						b.shottype = 1
						b.timeoutset = 10
						b.maxbul = 7
						b.tick = 3
						b.speed = 0.7
						b.shot = 7
						
					else
					
						b.xx = b.x
						b.yy = b.y
						b.dx = 1
						b.shottype = 9
						b.timeoutset = 30
						b.timeout = 0
						b.maxbul = 5
						b.tick = 3
						b.speed = 0.5
						b.shot = 7
					
					end
					
			
			elseif(b.phase == 3) then
			
					b.xx = 52
					b.yy = 28
					b.dx = 1
					b.dy = 1
					
					
					if(s < 8) then
					
					
						b.shottype = 6
						b.timeout = 0
						b.maxbul = 20
						b.tick = 10
						b.speed = 1.3
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
	
	
	elseif(t>40 and t<45) then
	
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
		pattern8(10)
		pattern1(11)
	
	
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
	cls(0)
	
	drawgrass()
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
				spr(c.s+(i*16)+j+(animate*4),c.x+(j*8),c.y+(i*8))
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
		anigrass()
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

	//print(stagetime,0,0)

	if(bossfight) then
		for b in all(boss) do
			for i=0,b.hp/2.6 do
				pset(i+25,2,15)
			end
				print("hp",16,0,7)
		end
	end
	
end


//forest
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


//grass
function drawgrass()
	for i=1,#grassx do
		spr(grass[i]+74,grassx[i], grassy[i])
	end
end


function anigrass()
	for i=1,#grassy do
		grassy[i] += 1
		
		if(grassy[i] > 128) then
			grassy[i] = 1
		end
	end
end



function animatesprite()

	t = (t + 1)%360
	
	if(t%15 == 0) then
		animate = t%2
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
			score += 50
		else
			bosst += 1
		end
		
		--animate :)
		animate = t%2
		
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
			
			if(life < 0) then
				screen = "gameover"
				sfx(14)
			end
			
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
			sfx(1)
			clearbullet()
			
			if(life < 0) then
				screen = "gameover"
				sfx(14)
			end
			
		end
	end
	
end

--enemy

	for s in all(shots) do
		for e in all(enemies) do
		
			if colother(s,e) then
				sfx(4)
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
					bomb()
					if(b.phase > b.phases) then
						score += b.points
						screen = "event"
						eventid = 2
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
			power += 3
			del(pickups, p)
			sfx(0)
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
	
		for i=0,1,1/9 do
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
		
	//cross shot
	elseif(tpe == 10) then
	
		for i=0,1,0.25 do
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
	elseif(tpe == 11) then
		
		//x shot
			for i=0.125,1,0.25 do
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
			
	end
		
end


function shot()

	if(wait <= 0 and #shots < 50) then
	
		local speed = -7
		
		wait = 3
		
		add(shots, {
			x = elchi.x,
			y = elchi.y,
			dy = elchi.spd*speed/2,
			dx = 0,
			s = elchi.sp
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

	sfx(4)
	//a is boss sorry
	if(abs(a.x+12 - b.x) < 12 and
				abs(a.y+12 - b.y) < 12) then
				
				return true
				
	else
		return false
		
	end

end


function bomb()

	sfx(6)
	invul = 30
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
				elchi.sp = 94
				elchi.spd = 3
			elseif power > 75 then
				dmg = 7
				elchi.sp = 93
				elchi.spd = 2.5
			elseif power > 50 then
				dmg = 5
				elchi.sp = 92
				elchi.spd = 2
			elseif power > 25 then
				dmg = 3
				elchi.spd = 1.5
				elchi.sp = 91
			else
				dmg = 1
				elchi.spd = 1
				elchi.sp = 90
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


-->8
//start screen


function updatestart()


	if(btn(5)) then
		screen = "intro"
		//sfx for start screen
		sfx(-1)
		sfx(-1)
		music(4)
			
		
	//press down for a buncha lives
	//and bombs
	elseif(btn(3))then
	
		//sfx for start screen
		sfx(-1)
		sfx(-1)
		screen = "intro"
		sfx(5)
		life = 9
		bombs = 9
		music(4)
		

	end
		

end

function drawstart()

	cls(0)
	
	//colors
	for i=0,100 do
		local _x = flr(rnd(128))
		local _y = flr(rnd(128))
		local clr = flr(rnd(15))+1
		
		pset(_x,_y,clr)
	end
	
	
	//sprite
	local sp = 139
	local x = 48
	local y = 24
	
	for i=0,3 do
		for j=0,3 do
			spr(sp+j+(i*16),x+(j*8),y+(i*8))
		end
	end
	
	
	//borders
	rectfill(0,0,15,127,7)
	rectfill(111,0,127,127,7)

	//title
	local x_ = 44
	local y_ = 80
	
	print("∧",x_,y_,7)
	x_ += 8
	print("h",x_,y_,8)
	x_ += 4
	print("e",x_,y_,9)
	x_ += 4
	print("l",x_,y_,10)
	x_ += 4
	print("e",x_,y_,11)
	x_ += 4
	print("n",x_,y_,12)
	x_ += 4
	print("a",x_,y_,2)
	x_ += 4
	print("∧",x_,y_,7)
	
	
	print("in october!",43,88)
	


	print("press 🅾️",48,96)

end


//intro screen

function updateintro(ticks,c)

	if(ticks > 100) then
		if(c == 1) then
			introtxt = "as october approaches,\nmonsters get stronger\nin preparation for"
			introcount += 1
		elseif(c == 2) then
			introtxt = "halloween. the time when\nmonsters come to terrorize\nthe public."
			introcount += 1
		elseif(c==3) then
			introtxt = "one nun thinks -this is my chance\nto test out my new \nmagic gun♪"
			introcount += 1
		elseif(c==4) then
			introtxt = "onwards, helena!"
			introcount += 1
		elseif(c==5) then
			screen = "game"
			music(-1)
			music(10)
		end
		
		//reset ticks
		introticks = 0
	end
	
	if(btn(4)) then
		screen = "game"
		music(-1)
		music(10)
	end

end



function drawintro()

	cls(0)
	
	local sp = 193
	local x = 48
	local y = 24
	
	for i=0,3 do
		for j=0,3 do
			spr(sp+j+(i*16),x+(j*8),y+(i*8))
		end
	end
	
	print(introtxt,16,96)
	print("❎skip",96,111)

end


//game over screen

function drawgameover()


	cls(0)
	
	for i=0,100 do
		local _x = flr(rnd(128))
		local _y = flr(rnd(128))
		local clr = 8
		
		pset(_x,_y,clr)
	end
	
	//bglines hoz
	for k=25,56,2 do
		line(47,k,80,k,3)
	end
	//bglines ver
	for k=49,80,2 do
		line(k,23,k,56,3)
	end
	
	
	local sp = 203
	local x = 48
	local y = 24
	
	
	for i=0,3 do
		for j=0,3 do
			spr(sp+j+(i*16),x+(j*8),y+(i*8))
		end
	end
	
	//borders
	rectfill(0,0,15,127,1)
	rectfill(111,0,127,127,1)

	print("game over",47,82,7)
	print("score:"..score,44,96,7)

end


//ending screen

function updateed(ticks,c)

	if(ticks > 100) then
		if(c == 1) then
			edtxt = "-why did you come after me?\nare you stupid or something?"
			edcount += 1
		elseif(c == 2) then
			edtxt = "-i couldn't let you go after\ni beat you up so badly. i\ndo care about you!"
			edcount += 1
		elseif(c==3) then
			edtxt = "-was a kiss really necessary???"
			edcount += 1
		elseif(c==4) then
			edtxt = "-kisses heal wounds faster♥"
			edcount += 1
		elseif(c==5) then
			edtxt = "-you should stop following me\naround. it's weird."
			edcount += 1
		elseif(c==6) then
			edtxt = "-i'll see you at next month's\nspellcasters' reunion ♪"
			edcount += 1
		elseif(c==7) then
			edtxt = "the end ♪"
			edcount += 1
		elseif(c==8) then
			music(-1)
			_init()
		end
		
		//reset ticks
		edticks = 0
	end

end



function drawed()

	cls(0)
	
	local sp = 198
	local x = 48
	local y = 24
	
	for i=0,3 do
		for j=0,3 do
			spr(sp+j+(i*16),x+(j*8),y+(i*8))
		end
	end
	
	print(edtxt,8,96)
	print("score:"..score,44,15,7)
	//print("🅾️skip",96,111)
	//ending cant be skipped
	//cause i said so

end



__gfx__
00000000001110000011100000000000003000000000000000000000000000000000000000000000000000000000000007000070000000000000000000000000
00000000001110000011100000030000033300300010033000000000009999000011110000000000000000000070070070000007000000000000000000000000
0070070001777100017771000033300003330b330010333300000000090000900100001000000000000770000700007000000000000000000000000000000000
000770000111110001111100003330b00333bbb30111333300000000090aa090010cc01000077000007007000000000000000000000000000000000000000000
000770000f111f000f111f0000333bbb0333bbb30111033000000000090aa090010cc01000077000007007000000000000000000000000000000000000000000
00700700001110000011100003333bbb0333bbbb0111004000000000090000900100001000000000000770000700007000000000000000000000000000000000
00000000001070000070100000040bbb004004000040040000000000009999000011110000000000000000000070070070000007000000000000000000000000
00000000000010000010000000000040004000000040040000000000000000000000000000000000000000000000000007000070000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000202000002020000000000000900000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000222000202220200000000009990000000000000000000000000000000000000000000000000000000000000000000
00000000000ea00000000000000000000220202202202022000000009999a9900000000000000000000000000000000000000000000000000000000000000000
00000000000b20000000000000000000020222020202220200000000099999000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000020222020002220000000000099999000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000020000000200000000000099099000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000090009000000000000000000000000000000000000000000000000000000000000000000
00000000000050000000500000000000007770000077700000000000000000000000000000000000000000000000000000000999999000000000000000000000
00000000000530000005300000000000003730000037300000000000000111100001111000000000007777000000000000099000000990000000000000000000
00000000099999900999999000000000007770000077700000000000050111100501111000000000071cc7700000000000900000000009000000000000000000
0000000094499449989999890000000007070700070707000000000050511515505115150000000007c01c700000000009000000000000900000000000000000
0000000099999999998998990000000080777080807770800000000050881505508815050000000007c10c7000000000090000aaaa0000900000000000000000
00000000994994999499994900000000000700000007000000000000505505055055050500000000077cc1700000000090000a0000a000090000000000000000
0000000009974990094444900000000000707000007070000000000000010500500000050000000000777700000000009000a000000a00090000000000000000
0000000000000000000000000000000000007000007000000000000000000000000000000000000000000000000000009000a007700a00090000000000000000
00000000000000000000000000000000000c0000000ccc000000000007700000077000000000000000000000000000009000a007700a00090000000000000000
00000000020200000202000200000000000ccc00000cccc00000000007770000077700000000000000000000000000009000a000000a00090000000000000000
0000000008280002082800020000000000c777c000c777cc00000000787800007878000000000000000000000000000090000a0000a000090000000000000000
000000000222200202222002000000000cc070c000c070cc000000007777000077770000000000000000000000000000090000aaaa0000900000000000000000
000000000002220200022202000000000cc777c000c777cc00000000777070007777700000000000000000000000000009000000000000900000000000000000
000000006620222266202220000000000ccc7cc0000c7ccc00000000077777070777770000000000000000000000000000900000000009000000000000000000
0000000000666600006666000000000000cccc000000ccc000000000007070700077070700000000000000000000000000099000000990000000000000000000
0000000066000000660000000000000000cc00000000c00000000000000707000000707000000000000000000000000000000999999000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000060000061000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000500000001000005000050000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000605000000700000700100100000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000066000000000006000001000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000005005000000010001005000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000500060000000100000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cc000000cc00000000000
0000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000cccc0000c77c0000000000
000000000000000000000000000000000000000000000a00000000800080000000000000000000000000000000700c00000cc000007007000c7777c000000000
0000000000000a000000000000000000000000000000000000000082228000000000000000000000000c7000000c700000cc7c000c07c0c00c7aa7c000000000
00000000000000a000000080008000000000000000000000000001222e20000100000000000000000007c0000007c00000c7cc000c0c70c00c7aa7c000000000
0000000000000000000000822280000000000000000002220000012f2222001100000000000000000000000000c00700000cc0000c7007c0c777777c00000000
0000000000000000000000222e200000000000000000022200001128f820011100000000000000000000000000000000000000000cccccc0ca7777ac00000000
00000000000002220000012f222200100000000000000002200181ffffff0211100000000000000000000000000000000000000000000000cccccccc00000000
000000000000022200001128f820011000000000000eee002228181fff2221111000000000000000000000000000000000000000000000000000000000000000
0000000000000002200181ffffff011110000000002eeee002e8e8f1ee2211110000000000000000000000000000000000000000000000000000000000000000
00000000000eee002228181fff221211100000000022eee000ee88ff8ffff1110000000000000000000000000000000000000000000000000000000000000000
00000000002eeee002e8e8f1ee2221111000000000222eeee00088f8888888800000000000000000000000000000000000000000000000000000000000000000
000000000022eee000ee88ff8ffff11110000000000222eee88888888808f0800000000000000000000000000000000000000000000000000000000000000000
0000000000222eeee00088f88888888010000000000222ee88888888800f88800000000000000000000000000000000000000000000000000000000000000000
00000000000222eee88888888808f080000000000002888fff888888000ff0000000000000000000000000000000000000000000000000000000000000000000
00000000000222ee88888888800f88800000000000888888ff8888800008f0000000000000000000000000000000000000000000000000000000000000000000
000000000002888fff888888000ff0000000000000888888f0000000000880000000000000000000000000000000000000000000000000000000000000000000
0000000000888888ff8888800008f000000000000088000000000000008800000000000000000000000000000000000000000000000000000000000000000000
0000000000888888f000000000088000000000000088880000000000008800000000000000000000000000000000000000000000000000000000000000000000
00000000008800000000000000880000000000000000888000000088888800000000000000000000000000000000000000000000000000000000000000000000
00000000008888000000000000880000000000000000088888000088800000000000000000000000000000000000000000000000000000000000000000000000
00000000000088800000008888880000000000000000000088800000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000008888800008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007777777700000070000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007772222222277700000070000000000
00000000000000000000001111100000000000000000000000000000000000080000000000000000000000000000000772222222222211177000777000000000
00000000000000000001117777770000000000000000000000000000000000880000000000000000000000000000007222227222220011111700070000000000
00000000000000000111177777777700000000000000000000000000000000880000000000000000000000000000072227722222266777771170000000000000
0000000000000000011177777777777000000000000000000000000000000088222222200000000000000000000072222772272d6d6777777717000000000000
000000000000000011177799999999900000000000000000000000000000002222222222200000000000000000072227222222d6d67999997771700000000000
0000000000000000117769999999999900000000000000000000000000002222f2222222200000000000000000722222555555dd699999aaa771170000000000
0000000000000000116699999a9999799000000000000000000000000000222ff2222222228000000000000000722555555555494999a7999777170000000000
00000000000000011166999a99999a9990000000000000000000000000022ffff22e22222880000000000000072555555555549499999aa9a9771c7000000000
0000000000000011116999999f9999a9900000000000000000000000000255fff222222888200000000000000725550005f55449499f99999a771c7000000000
00000000000000111664999f9ff999990000070000000000000000000ff2f85ff222e7288820000000000000072200000ff00994949fffff9a77117000000000
0000000000000011166499f55fff55090000000000000000000000000f22f87fff22ee22222000000000000072222222ffff9449fffff0ff99a7711700000000
000000000000011111699957cfff7c00000700000000000000000000002eeffff5222ee72220000000000000722ff222ffff24940fff0f0f99a771c700000000
0000000000001111111f99ffdffffd00007770000000000000000000000ffffff855222e2200000000000000722fff222fff2220f0ffffff99a771c700000000
0000000000001111111f9affffffff00000700000000000000110000000ffffff87222222000000000000000722ffff22fff2224ffffffee9a97711700000000
0000000000011111111499feefffee90000000000000000001110000000f8fffeeffff222000000000000000722ffff55fff222eefffffff9a94111700000000
000000000001111111449a9fffffff90000000000000000001110000000ff88ffffffffff0000000000000007222fff555ff5524ffff8fff99a2411700000000
0000000000011d11114499afff8ff9aa000000000000000011111000000ffffffffffffff0000000000000007222ffff22ff00044f88ffff9aa4211700000000
00000000001111111144299fffff999a0000000000000000888111000000fffffff28220000001100000000072222ffff2fff22944ffffff9a92422700000000
000000000011d1121242299afff0999a00ffff000000000081811100ff0000fefe228220000001100000000007222ffff2fff22944fffffd99a4247000000000
00000000001111d12422699addd09999afffff71000000001818111fffff00efef28882000001110000000000755552ffffff2294442ffdd9a97777000000000
0000000000111d1212426999add09999ffffff710000000081888ffffffffefefe228222000111100000000007255000fffffefff4422ddd9a97777000000000
000000000011d1d124276999a6dd099fffff06610000000018188fffffffefefffff222211121111000000000070000feffeefefff42ddd69aa7770000000000
00000000011d1d1427776999a66d699fff00661100000000818f8ffffffeffffffff222222211111000000000072222ffeeefffffffd66d699a7770000000000
00000000077766227777696996667693b00001110000000018f888fffffffffffffff222228888880000000000072fefffeffffffff666669aa7700000000000
000000000777662777777693b77777633700011100000000808ff8ffffffffffffffff22888181880000000000007ffeefeffffffff66da73b97000000000000
000000000776d21117777663376a7776a11000110000000008f8888ffffffffffffffff82828181800000000070007ffefeefeefff76daaa3b70000000000000
00000000000001111111112996aaa7729a110001000000008f88888feffffffffffff88181818188000000000000007ffeefefffff7122a17708080000000000
000000000001111111111122976a771299a1000100000000888888feffff88ffffff88f8f818181800000000000700077fefffff77d112a77088888000000000
00000000001d111111111129912a11129911100100000000ff88888ef88888888f888f8f8181808800000000007770000777ffff7dd177700008880000000000
00000000001ddd1111111222111111122211110100000000f88888888888888888f8f8f808188888000000000007000000007777777700000000800000000000
0000000022222e2777e2222222222222222222220000000000000000000000e0e0000000000000000000000033333333338333dd333333b33333333300000000
00000000202220e77722e0222022202220222022000000000000000000000eeeee000000000000000000000033333333383833d3333333a33b33383300000000
0000000022222e2777e2222222222222222222220000000000000000000000eee000000000000000000000003b33333b33383330303b3a33b333338300000000
00000000222022e0e2202220222022202220222000000000000000000000000e000000000000000000000000b3bc8b33338330380333b333b338833800000000
0000000020222022202220222011102110222022000000000000000000000080000777761112000000000000b3385d3ab3330000023333333383383800000000
0000000022202220222022201115111511202220000000000000080222220880009777766121200000000000b33355da33830000223c3c3c3383333800000000
000000000202020202020202020202020202020200000000000008222222288099999776d112100000000000333d355d53333000233c3cac9718338300000000
0000000020202020202020202020202020202020000000000000882e222222229a999776d1112100000000003333d035333d3303093c3cac9971883b00000000
0000000002020202020202020202020202020202000000000000827222228289aa999976d111120000000000333300333333d33333b399ddd971333b00000000
00000000002000200020002000200020002000200000000000002e2f22288288a99f99776d112100000000003b3b503f33333d3334999fffdd71333b00000000
0000000020002000200020002000200020002000000000000000222ff22222299fff99976d1112000000000033b333ff7711133344444f8fff91333300000000
00000000002000255520002000200020002000200000000000002200ff200288f0f0f9976d1121200000000033b3333ff71111111167477ff991117300000000
000000000000055555550000000000000000000000000000000222ff0f0f8f82ff0ff9996d1112120000000033a333333d111131111177744991179300000000
00000000200020051500200020002000200020000000000000022fd05ff00ff2ffeefa996d112120000000003d33333333dd31311111a17744499b3300000000
00000000000000000000000000000555000000000000000000022d078ff780fffffffa996d1112120000000033b3a3b333a33311111111171444d33300000000
0000000000200020002000200015551550200020000000000fff2fddfffffffffffff9999d112120000000003d3333333333111111111111114d33d300000000
0000000000000000000000000000055000000000000000000ffffeeffffffeeffffffa9911111212000000003333b3333111111111131113111333d300000000
0000000020002000200020002000200020c0200000000000000f82fffffffff00ffff99911112120000000003d33311111111111111133331111333300000000
000000000070000000000000000000000ccc0000000000000000822ff888ff020000a99dd67212020000000033311111111111611133a33dd13133bb00000000
000000000070700000000000000000001c7c00000000000000088822fffff0202002a99dd6777020000000003111111111166661111333b33331133300000000
000000000070700aa00000002020000150cc000000000000000082222effe202022a999d6777777700000000331111111166761111a33bb33331113300000000
00000000a33b3333a300000022200001100c000000000000000110222eeee020202a999667777777000000003333367777776111133a339b333d117300000000
000000003bb337733bb33000222020200d00003300000000011111222fefe202021a999a6777777700000000333333677777611111339993333dd77300000000
0000000033a377773333a33a2220222a0d033bb30000000011111102fefefe202111b3aaa677777200000000333337d667777111113e999333333fff00000000
000000003a37777763b333d33333a33333d33333000000001111ffffffefefffff11337a677fff2200000000333377733367111111199999333333f300000000
00000000b3307777633bd33a838333ab3334543300000000101eeefffffefffeeeff8a9a67fefff2000000003337773333361111111399993339933300000000
000000003b3777076333ba3388833333234500b30000000000ffffeefffffeefff88899871ffeff70000000017737333337d6611133339999339933300000000
0000000033370776d3333a333d3db3b333350413000000008888fffffffffffff8f8191811fffef700000000177333333776d111113339999939333300000000
000000003377776d133b333333d333b34433411300000000808f8fffffffffff8f8f8188111ffef7000000001133333377773333113d39999939333300000000
00000000337b71611113383833d33b3455533b330000000008f88ff88fff88f8f8f81818111ffee70000000013333311777333333dd399999999333b00000000
00000000b333111121233888353333455051333300000000808f888888f8888f8f8f8181112777210000000033333117733333aa3dd333999933333300000000
000000003333311112333333335344550041333b0000000008f8f88888888888f8f8181112211112000000003331111733bb3333a3d33333333333b300000000
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

__map__
0000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
950100000121002230022400325006250082500b2500e2501025011250132501625017250182501a2501c2501d2501e2502225025250282402b2202b2002d2002f200312003420036200382003a2003c2003e200
740300000000000000327502c750287502d75025750227501f7501c7501a7501775013750127500f7500c7500a750087500575002750007500175001750017500075000750007500075000250062000000000000
000100000000000000010500202006020090200a0200f02012020160201a0201d0201f0202202025020290202e0202f0200000000000000000000000000000000000000000000000000000000000000000000000
00010000000000c45012450154501a4501c4501d4501f4501f450214502245025450264502745027450284502745027450264502545023450214501f4501f4501c4501a4501845015450104500d4500945005450
000100001a0501905017050150501605013050100500e0500b0500805004050000500005000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a00002505026050230502505021050230501f050210500000026050000002b0502b0502b050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030000000001161015620186201b6301c6301c6301a640176401564012640106400f63010630166301a6101961017650126500b650026500000000000000000000000000000000000000000000000000000000
011e0000213271e327203271c3271e3271a3271c327193271a327173271932715327173271432715327123271532714327173271532719327173271a327193271c3271a3271e3271c327203271e3272132720327
00150020000001d0501a050000001a0501d050000001d050210501f0501f050230500000025050000002305023050230502005020050000001905016050170501605019050000001c0501c050000001f0501f050
001500200c0240d0200f0200502013020100200402016020120201502009020000000902000000090201502011020130200e0201002009020130200f020130200f020130201402016020120200d0201202016020
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000000022d5522d552285522a5522c552000022c552000022c552000022c552255022a552065021a5521e552215520000221552000022155200002195521c55220552255522155225552205522155221552
0110000000005195351953517535155350e5350000517535000051a535000051e535255052053506505285352553523535000051c53500005195350000523535205351a535235351c53523535175351a5351c535
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07100000007022d7522d7522d7522d7522d7522675226752267522075220752207522075220752237522375223752217522175221752217522175221752217522175221752217520070200702007020070200702
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0e00002453424532245322453527534275322753227532275322753227532275352b5342b5322b5322b5352c5342c5322c5322c5322c5322c5352e5342e5322e5322e5322e5322e53532534325352e5342e535
170e00002c5342c5352e5342e5322e5322e5352c5342c5352e5342e5322e5322e53533534335352e5342e5322e5322e5322753227535295342953229532295322953229532295322953229532295352c5342c532
170e00002c5322c53535534355323553235532355323553533534335353253432532325323253232532325352e5342e5322e5322e535325343253232532325323253232532325323253532534325352e5342e535
170e00002c5342c5352e5342e5322e5322e5352c5342c5352e5342e5322e5322e53533534335352e5342e5322e5322e5352753427535295342953229532295322953229532295322953229532295352c5342c535
170e000030534305353453434532345323453532534325323253232535305343053533534335323353535535375343753237535325353353433532335353553530534305352b5342b5322b5322b5352c5342c535
170e00002c5342c535305343053230532305353253432535305343053230532305352e5342e5352c5342c5322c5322c5322c5322c535007100271000710027100071202712007120371233534335323353535535
170e0000375343753237535325353353433532335353553530534305352b5342b5322b5322b5352c5342c5322c5322c535305343053230532305353253432535305343053230532305352e5342e5352c5342c532
170e00002c5322c5322c5322c5352b5342b535275342753227532275322753227532275322753529534295352e5342e5322e5322e5322e5322e5322e5322e5350271000710027100071032534325352e5342e535
910e00000c5200c5200f5200f52013520135200f5200f520135201352018520185200f5200f5200c5200c52011520115200c5200c52008520085200c520085200e5200a52011520115201352016520135201a520
910e0000145201452018520185201b5201b520185201852014520145201b5201b52018520185201f5201f520135201352016520165201a5201a520165201652013520135201a5201a52016520165201d5201d520
910e00000f5200f5201452014520185201852014520145200f5200f5201452014520185201852013520135200e5200e5201352013520165201652013520135200e5200e520135201352016520165201152011520
910e00000c5200c5200f5200f52014520145200f5200f5200c5200c5200f5200f520145201452013520135200a5200a5200e5200e52011520115200e5200e5200a5200a5200e5200e52011520115201452014520
910e000007520075200c5200c52010520105200c5200c52007520075200c5200c520105201052016520165200c5200c5200c5200f5201452014520145200f5200c5200c5200f5200f52014520145201652016520
910e00000e5200e5201152011520165201652011520115200e5200e52011520115201652016520155201552010520105201352013520185201852013520135201052010520135201352018520185201652016520
910e0000145201452018520185201b5201b5201852018520145201452018520185201b5201b5201f5201f52016520165201a5201a5201d5201d5201a5201a52016520165201a5201a5201d5201d5202052020520
910e000018520185201b5201b5201f5201f5201b5201b52018520185201b5201b5201f5201f52022520225201c5201c520205202052024520245201d5201d5201a5201a520165201652013520135201152011520
910e00000361300003012130000301213000030121300003036130000300213000030021300003002130000302613000030021300003002130000300213006030261300003002130000300213000030021300003
901e00000361301153012130115301213011530121301153036130015300213001530021300153002130015302613011530121301153012130115301213011530261300153002130015300213001530021300153
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1713000029550295502950029500295000e5500e5500e5501750011500185001155011550115502250022500225001855018550185501f5001f500225001f55018550215501a550225501b5501f5501f55000000
161300001f5501f5501f550000002255022550225500000026550265502655026500265500160029550016002d550016002e55000600305103250032550335503555037550355503755032550375502e55037550
17130000375503755037550395503555037550335503555032550335502f550325502e550305502d5502e5502b5502b5502b5502b550265502655026550265500000026550295502b5502b5502b5502b55000000
161300002b5502b5502b5502b550000002655026550265502655026550000002b5502b5502b5502b5502b550000002b5502b5502b5502b5502b5500000029550295502955023550235502355023550005001f510
910e00000361300003012130000301213000030121300003036130000300213000030021300003002130000302613000030021300003002130000300213006030261300003002130000300213000030021300003
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001300002b555265552d555305552655529555305552b55524555265552155522555265551155513555155551a5551155515555185551a55515555115552155518555175551b5552155523555295552855500005
001300001f5551f55522555225551f555255552555529555225552255522555225552255526555265552655526555265551f55526555295552b5551f5551f5551f55516555165551655516555165551655516555
0113000022555225552255522555305052e5552b5052d555295552e5052655526505265552655526505265551f5551f5551f5551f5551f555155551a5551d5552155524555285552f55526555285552655500005
0113000023555265552955526555235552155524555215551d5552155524555285552b5552e5552b555265552655526555265551f5051f5551f5551f5551f5551f5051b5551b5551b5551b555185551855518555
01100000002121355213552135520021217552175521755200212155521555215552002121a5521a5521a55200212175521755217552002121c5521c5521c552002121a5521a5521a552002121f5521f5521f552
__music__
00 01024344
00 08094344
00 0b0c4344
00 50424344
03 08094344
00 41424344
03 07214344
00 41424344
00 41424344
00 41424344
00 10182044
01 11192044
00 121a2044
00 131b2044
00 141c2044
00 151d2044
00 161e2044
02 171f2044
00 41424344
00 41424344
01 242c4344
00 252d4344
00 262e4344
02 272f4344
00 41424344
00 41424344
03 30424344

