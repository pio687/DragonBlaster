pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
//0: init and ui
//❎
//❎

function _init()

	defaults={
		friction=0.75,
		boost=5,
		max_dy=3,
		max_dx=1,
		acc=0.75
	}

	state="start"

	mode="peace"

	location="ocean"

	death_sound_played = false

	hit_cooldown = 0

	bullet_cooldown = 0
	
	axototal = 0
	
	music(0,0,0,3)

//player ❎❎❎

	player={
		x=0, 
		y=0,
		oldx=0,
		oldy=0,
		dx=0,
		dy=0,
		w=8,
		h=8,
		max_dx=0,
		max_dy=0,
		acc=0.5,
		moving=false,
		drifting=false,
		friction = 0.80,
		alive=true,
		position=0,
		fx=false,
		fy=false, 
		sp=1,
		ghost=4,
		pow=50,
		dam=25,
		health=100
		}
		
		//❎
		home = {
			tx=0,
			ty=0,
			set=false
			}
		
		
		//❎
		city = {
			tx=0,
			ty=0,
			sp=6,
			health=10000,
			safe=true,
			deadsp=8
			}
		
		//❎
		scores = {
		axototal=0,
		axokilled=0
		}
		
		//❎
		bullets = {}
		
		//❎
		bul={
		x=player.x,
		y=player.y,
		sp=player25,
		pow=20,
		speed=3
		}
		
		
		//❎
		bomb={
		sp=50,
		x=player.x,
		y=player.y,
		timer=2,
		flash=10,
		spawn=0
		}
	
		
		//❎	
		city1={
		cityspr=6,
		x=12*8,
		y=8*8
		}

		//❎
		enemies={}
		
		//❎
		pickups={}
		

	axo_init()
	
	home_init()


	//map limits
	map_start=0
	map_end=1024
	map_height=512

end

//end init
//❎
//❎

//6: menus and notifications
//❎❎❎❎❎❎
//❎❎❎❎❎❎


-->8
//1: draw
//❎
//❎

function _draw()


	//World map

	if state=="play" then

		cls() // clear screen
		draw_map() // call draw_map from tab 3


		
	//city
		spr(city1.cityspr, city1.x, city1.y, 2, 2) // city sprite
	
	//ghost
	
		if player.alive then
			spr(player.sp,player.x,player.y,1,1,player.fx,player.fy)
			// num, x, y, width, flip
		end
	
		if not player.alive then
	
			spr(player.ghost,player.x,player.y,2,2,player.fx,player.fy)

		end
		
	
		//axo boss sprite

		axo_behavior()
		
			//bullets

		for b in all(bullets) do
			spr(b.sp, b.x, b.y)
		end
		
	//hearts
		
		for h in all(pickups) do
			spr(h.sp, h.x, h.y)
		end

		//health bar
		draw_health() // call draw_health from tab 2

		//power bar
		draw_power()
		
	//points(axo.e.sp, 5, 5, count, total)

    points(36, 2, 20, scores.axokilled, scores.axototal)

	
	//start and menu
	elseif state=="start" then
		cls(19)
		print("time to wake up.", 30,60)
		
		elseif state=="menu" then
		dialog("time to get moving.")	

	end


end // end draw


//end draw
//❎
//❎❎

//update
//❎
//❎

function _update()

	old_state = state
	if state=="play" then
		if player.health <= 0
			and not death_sound_played then 
			player.health = 0
			player.alive = false
			sfx(9,2)
			death_sound_played=true
	 end
	 
	 if #enemies == 0 then
			mode="peace"
			set_music()
	end
	    
	 if not player.alive
	 	then mode = "death"
	  set_music()
	 end
	
//	   if (btnp(4)) 
//	   then state="menu" //call menu
//    end
   
	update_health()
	update_power()

	player.oldx=player.x
	player.oldy=player.y

	update_player()
	
	bullet_fire()
	update_bullets()

	if hit_cooldown > 0 then
		hit_cooldown -= 1
	end
	
	if bullet_cooldown > 0 then
		bullet_cooldown -= 1
	end

	map_flip()
	
	bad_col()
	bullhit()

	axo_spawn()
	axo_update()
	
	respawn_check()


for e in all(enemies) do

	if e.flash_timer > 0 then
		e.flash_timer -= 1
	end

	if e.health<= 0
		and e.alive then			
		sfx(e.deathsfx,2)
		e.alive=false
		if e.type == "axo" then
		scores.axokilled += 1
		axo_loot(e.x,e.y)
		end
		e.dead = true
	end
	
end

axo_pickup()
			
for e in all(enemies) do
	if e.dead then
		if e.type == "axo" then
		del(axo,e) 
		end
		del(enemies,e)
	end
end

	elseif state=="start" or state=="menu" then
		if (btnp(❎)) then state="play"
  end
 end
end

//end update
//❎❎
//❎❎❎
-->8
//2: player behavior

// player movement
function update_player()

player.dx*=player.friction
player.dy*=player.friction
player.x+=player.dx
player.y+=player.dy


//check collision

if collide_map(player,"down",0) then
	player.dy-=player.acc
	elseif collide_map(player,"up",0) then
	player.dy+=player.acc
	elseif collide_map(player,"left",0) then
	player.dx+=player.acc
	elseif collide_map(player,"right",0) then
	player.dx-=player.acc
end



//movement

if btn(➡️) and
btn(⬆️) then
	player.dy-=player.acc/2
	player.dx+=player.acc/2
	player.sp=18
	player.fx=false
elseif btn(➡️)
and btn(⬇️) then
	player.dy+=player.acc/2
	player.dx+=player.acc/2
	player.sp=19
	player.fx=true
elseif btn(⬇️) and
btn(⬅️) then
	player.dy+=player.acc/2
	player.dx-=player.acc/2
	player.sp=19
	player.fx=false
elseif btn(⬆️) and
btn(⬅️) then
	player.dy-=player.acc/2
	player.dx-=player.acc/2
	player.sp=18
	player.fx=true
elseif btn(➡️) then
  player.dx+=player.acc
  player.moving=true
  player.fx=true
  player.sp=1
elseif btn(⬇️) then
  player.dy+=player.acc
  player.moving=true
  player.sp=3
  player.fy=false
elseif btn(⬅️) then
	player.dx-=player.acc
	player.moving=true
	player.fx=false
	player.sp=1
elseif btn(⬆️) then
	player.dy-=player.acc
	player.moving=true
	player.sp=2
	player.fy=false
end

//drifting
if player.moving
and not btn(0)
and not btn(1)
and not btn(2)
and not btn(3) then
	player.moving=false
	player.drifting=true
end

//if player.drifting then
//	player.acc-=.2
//	if abs(player.dx)<.05 and
//	abs(player.dy)<.05 then
//		player.dx=0
//		player.dy=0
//		player.drifting=false
//	end
//end

	if on_tile_flag(player,2) then
		player.friction=.85
		player.max_dy=0.5
		player.max_dx=0.5
		player.acc=0.9
	else
		player.friction=defaults.friction
		player.max_dy=defaults.max_dy
		player.max_dx=defaults.max_dx
		player.acc=defaults.acc

	end

end
-->8
//3: health and powerups
//❎❎
//❎❎❎


function update_health()
	hbarw=60*player.health/150
	if player.health>250 then
		player.pow+=5
		player.health=250
	end
end

function draw_health()
	if player.health>0 then
	rrectfill((mapx+15),(mapy+2),hbarw,8,2,14)
	else
	rrectfill((mapx+15),(mapy+2),0,8,2,14)
	end
	print(player.health,mapx+2,mapy+3,7)
end

//end health
//❎❎❎
//❎❎❎

function update_power()
	pbarw=60*player.pow/150
	if player.pow>250 then
		player.health+=5
		player.pow=250
	end
end

function draw_power()
	if player.pow>0 then
	rrectfill((mapx+15),(mapy+11),pbarw,8,2,8)
	else
	rrectfill((mapx+15),(mapy+11),0,8,2,8)
	end
	print(player.pow,mapx+2,mapy+12,7)
end

//3: pickups
//❎❎❎
//❎❎❎

function axo_loot(x,y)
	local h = {
		x=x,
		y=y,
		sp=64
	}
	add(pickups, h)
end


function axo_pickup()

for p in all(pickups) do
	if player.x < p.x + 8 and
	player.x + 8 > p.x and
	player.y < p.y + 8 and
	player.y + 8 > p.y then
	
	player.health+=10
	sfx(10,2)
	del(pickups,p)
	end
end
end
			

function dialog(l1, l2, l3)
    camera()
    rrectfill(14, 88, 100, 22, 3, 0)
    rrect(14, 88, 100, 22, 3, 7)
    if l1 then print(l1, 19, 93, 7) end
    if l2 then print(l2, 19, 100, 7) end
    if l3 then print(l3, 19, 107, 7) end
    camera(cam_x, cam_y)
end

function points(sp, x, y, count, total)
    camera()
    spr(sp, x, y)
    print(count.."/"..total, x+9, y+3, 7)
    camera(cam_x, cam_y)
end

//end pickups/hud
//❎❎❎
//❎❎❎❎
-->8
//4: music and map
//❎❎❎
//❎❎❎❎

function set_music()

	local new_music = -1
			
		if mode == "peace" 
		 and location == "ocean" 
		 then new_music = 0 
	
		elseif mode == "war" 
 		and location == "ocean" 
		 then new_music = 1 
		 
		elseif mode == "death"
			then new_music = 2
	
		end
		
		
	if new_music ~= current_music
	 then music(new_music, 0, 3)
	 current_music = new_music
	end
	
end

//end music
//❎❎❎❎
//❎❎❎❎

//4: map
//❎❎❎❎
//❎❎❎❎

function draw_map()

	mapx=flr(player.x)-63
	mapy=flr(player.y)-63
	camera(mapx,mapy)
	map(0,0,0,0,128,64)
	palt(0,true)
	
end

function map_flip()
	if player.x<map_start then
		player.x=map_end
	end
		
	if player.x>map_end then
		player.x=map_start
	end
			
	if player.y<map_start then
		player.y=map_height
	end
	
	if player.y>map_height then
		player.y=map_start
	end
end

function home_init()
	for tx=60,65 do
	for ty=30,35 do
		local t = mget(tx,ty)
		if fget(t,1) then
			player.x=(tx*8)+5
			player.y=(ty*8)+5
			sfx(10,2)
			home.tx=tx
			home.ty=ty
			home.set=true
		end
	end
	end
end

function respawn_check()

	if player.alive==false then

		for tx=0,128 do
		for ty=0,64 do
		local t = mget(tx,ty)
			if fget(t,1) and
			abs(player.x - tx*8) < 16 and
			abs(player.y - ty*8) < 16 then
			player.alive=true
			player.health=50
			player.pow=50
			sfx(10,2)
			set_music()
			end
		end
		end
	end
end


--function city_init
--	for tx=0,128 do
--	for ty=0,64 do
--	local t = mget(tx,ty)
--			if fget(t,4) then
--			city.tx=tx*8
--			city.ty=ty*8
--end
			
			
			
			
//end map
//❎❎❎❎
//❎❎❎❎❎
-->8
//5: axolotl
//❎❎❎❎❎
//❎❎❎❎❎

		//❎
		axo={}

function axo_init()
	for tx=0,127 do
		for ty=0,63 do
			local t = mget(tx,ty)
			if fget(t,4) then
				local e = {	
				sp=36,
				type="axo",
				h=8,
				w=8,
				x=tx*8,
				y=ty*8,
				flash_timer=10,
				spawn=false,
				alive=true,
				health=100,
				pow=25,
				dam=25,
				hurtsfx=7,
				spawnsfx=3,
				deathsfx=3,
				speed=0.15,
				palone=8,
				paltwo=10
				}
				
				add(axo, e)
				add(enemies, e)
			end
		end
	end
end

function axo_spawn()

	for e in all(axo) do
		if e.alive
		and player.alive 
		and not e.spawn then
			if abs(player.x - e.x) < 56 and
			abs(player.y - e.y) < 56 then
				e.spawn=true
				mode="war"
				sfx(e.spawnsfx,2)
				set_music()
				scores.axototal += 1
			end
		end
	end
end

function axo_behavior()
	for e in all(axo) do
		if e.alive and 
		e.spawn then
			if e.flash_timer > 0
				and e.flash_timer % 6 < 3 then
					pal(8,10)
			end
			spr(e.sp,e.x,e.y,1,1,true,false)
			pal()
			
			
		end
	end
end

function axo_update()

	for e in all(axo) do
	
	if player.alive then
	
	if on_tile_flag(player, 2) or 
	on_tile_flag(player,1) then
	
	if player.x > e.x then
	e.x += e.speed 
	end
	if player.x < e.x then
	e.x -= e.speed 
	end
	if player.y > e.y then
	e.y += e.speed 
	end
	if player.y < e.y then
	e.y -= e.speed 
	end
	
	end
	
	if on_tile_flag(player, false) or
	on_tile_flag(e,0) then
	
	if player.x > e.x then
	e.x -= e.speed 
	end
	if player.x < e.x then
	e.x += e.speed 
	end
	if player.y > e.y then
	e.y -= e.speed 
	end
	if player.y < e.y then
	e.y += e.speed 
	end
	
	end
	
	end
	
	end
end



//end axolotl
//❎❎❎❎❎
//❎❎❎❎❎
-->8
//6: violent actions
//❎❎❎❎❎
//❎❎❎❎❎❎


//function flash_bomb()
	
//	spr(bomb.sp,player.x,player.y,1,1) // explosion
//	flash_sprite(bomb,50,51,2)
//	bomb.timer -= 1
//end

	
//bullets
	function bullet_fire()
		if btnp(5) and 
		bullet_cooldown==0 and
		player.alive then
			sfx(1,2)
			bullet_cooldown=5
			local new_bullet = {
				x = player.x,
				y = player.y,
				sp = 16,
				pow = player.pow,
				dead = false // update this
				}

		if player.sp==18 and player.fx then
			new_bullet.dx = -bul.speed/2
			new_bullet.dy = -bul.speed/2
		elseif player.sp==18 and not player.fx then
			new_bullet.dx = bul.speed/2
			new_bullet.dy = -bul.speed/2
		elseif player.sp==19 and player.fx then
			new_bullet.dx = bul.speed/2
			new_bullet.dy = bul.speed/2
		elseif player.sp==19 and not player.fx then
			new_bullet.dx = -bul.speed/2
			new_bullet.dy = bul.speed/2
		elseif player.sp==1 and player.fx then
			new_bullet.dx = bul.speed
			new_bullet.dy = 0
		elseif player.sp==1 and not player.fx then
			new_bullet.dx = -bul.speed
			new_bullet.dy = 0
		elseif player.sp==2 then
			new_bullet.dx = 0
			new_bullet.dy = -bul.speed
		elseif player.sp==3 then
			new_bullet.dx = 0
			new_bullet.dy = bul.speed			
		end
			new_bullet.dx += player.dx
			new_bullet.dy += player.dy
			add(bullets, new_bullet)
		end
	end
		
	function update_bullets()
		for b in all(bullets) do
			b.x += b.dx
			b.y += b.dy
				
		if b.x < player.x-128
			or b.x > player.x+128
			or b.y < player.y-128
			or b.y > player.y+128
			or b.x < 0 or b.x > 1006
			or b.y < 0 or b.y > 503 then
				del(bullets,b)
		end
	
	end
		
end

//COLLISION WITH ENEMY 
function bad_col()
	for e in all(enemies) do
		if e.spawn 
		and e.alive
		and player.alive then
	
			if check_collision(e)
			and hit_cooldown == 0 then
			
			flash_sprite(e,e.palone, e.paltwo, 10)
			
			player.health -= e.dam
			e.health -= player.dam/10
			
			e.flash_timer = 20
			
			sfx(e.hurtsfx, 2)
			
			hit_cooldown = 10
			
			if player.x > e.x then
				player.x=player.oldx+5
			else player.x=player.oldx-5
			
			end
		
			if player.y > e.y then 
				player.y=player.oldy+5
			else player.y=player.oldy-5
		
			end
			end
		end
	end
end


function bullhit()

	for e in all(enemies) do

		for b in all(bullets) do
		
			if e.alive and e.spawn then
	
			if b.x < e.x + 8 and
				b.x + 8 > e.x and
				b.y < e.y + 8 and
				b.y + 8 > e.y then
			
				e.health -= b.pow
				e.flash_timer = 20
			
				sfx(3,3)
				b.dead = true
				
			end
			
			end
			
		end
			
	end
	
	for b in all(bullets) do
		if b.dead then del(bullets,b)
	end
	end
end
	
//end violence
//❎❎❎❎❎❎
//❎❎❎❎❎❎❎
-->8
//7: utilities
//❎❎❎❎❎❎
//❎❎❎❎❎❎❎

//find object position

function collide_map(obj,aim,flag)
	--ojb= table, needs x,y,w,h
	
	local x=obj.x local y=obj.y
	local w=obj.w local h=obj.h
		
	local x1=0 local y1=0
	local x2=0 local y2=0
		
	if aim=="left" then
		x1=x-1	y1=y
		x2=x	y2=y+h-1

		elseif aim=="right" then
			x1=x+w-1	y1=y
			x2=x+w+1	y2=y+h-1
			
		elseif aim=="up" then
			x1=x+1		y1=y-1
			x2=x+w-2	y2=y
		
		elseif aim=="down" then
			x1=x+1		y1=y+h
			x2=x+w-2	y2=y+h
		end	

	//pixels to tiles
	
	x1/=8	y1/=8
	x2/=8	y2/=8
	
	if fget(mget(x1,y1), flag)
	or fget(mget(x1,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
	
		return true
	else
		return false
	end	
	
end

function on_tile_flag(obj, flag)
	local tx=flr((obj.x+obj.w/2)/8)
	local ty=flr((obj.y+obj.h/2)/8)
	return fget(mget(tx,ty),flag)
end

function check_collision(obj)
	return
		player.x < obj.x + obj.w and
		player.x + 8 > obj.x and
		player.y < obj.y + obj.h and
		player.y + 8 > obj.y
	end
	
	function flash_sprite(obj, palone, paltwo, speed)
	if obj.flash_timer < speed then
		obj.flash_timer += 1
	else
		if obj.flash_timer % 2 == 0 then
			pal(palone,paltwo)
		end
		obj.flash_timer = 0
	end
end

--function calcdist(tx,ty)
--	local cand={}
--	add(cand,{x=tx,y=ty}
--	
--	for c in all(cand) do
--	dist[c.x][c.y]=step
--	for d=1,4 do
--		local dx=c.x+
--	
--	end
--	
--end
__gfx__
0000000000000e00000ee000000ee00000000000000000003333333333333333888888888888888833333333b333333300900000000000908880008000808880
000000000000ee00000ee000000ee0000000eeeeeee00000333cccccccccc333888000000000088833b333333333b33309009990909990090808080808080808
000000000cceeeee00eeee0000ecce00000e8eeeeeeee00033cccccccccccc3388000000000000883333337333b3333300909990909990900808080808080808
000000000ceeeee800e88e000ecccce0000e88eeee88ee003cccccccccccccc38000800080000008333336763333333300909000000090900080080808080080
000000000eeeee0000eeee00eeeeeeee000e88eee888ee003cccccccccccccc38008880088880008333367763333333300009088088090000808080808880808
0000000000eee000eeeeeeee00eeee0000ee88eee88eeee03c66666ccc666cc380589850899880083b3367776337333300900088088000900808080808080808
00000000000e0000000ee000000ee00000eee8eee8eeeee03c67a76cc6a7a6c38058988008998508333644444566633309009088088090090808080808080808
000000000000000000000000000000000eeeeeeeeeeeeee03c6a766cc67a76c38089a985089a8508335544544554553309009088088090090808008008080808
00e00e000000000000000000000000000eee8888888eee003c676666c6a7a6c38089aa9808899508335444444455455300909088088090900000000000000000
00088000000000000ee0eee00ee0eee000ee8888888eee003c6a67a6666a666380588aa855505558355444454545445309009080080090090000000000000000
e089980e000000000eee8ee00eeccce0000eee8888eeeee036676a767a6667a38556899560865608354454444445545500009000000090000000000000000000
0897a9800000000000eee8e000eecce00000eeeeeeeeeee0376a67a6a6666a738650560508885068354444544544554500900088088000900000000000000000
089a79800000000000eeee0000eeec00000000eeeeeeeee036666a76767a67638555506568898658544544444444453300909088088090900000000000000000
e089980e00000000000eeee0000eeee00000000eeeeeeeee337a67a6a6a7663388065605089a5588544444445444455309009000000090090000000000000000
000880000000000000000ee000000ee0000000000eeeeeee33376a76767a63338880506565605888544444544444545309009990909990090000000000000000
00e00e00000000000000000000000000000000000000000033333333333333338888888888888888444545445545444500900000000000900000000000000000
000000000000000000a00a0000000000808008080000000000000000acc00ccabbbbbbbbcccccccc11111111333333334444444455555555ffffffff66566666
00000000000000000a8aa8a0000000000898898000000000000000000cccccc0bbbbbabbccbccccc111111113b333b334444444455555555fffff9ff66666656
0000000000000000aaa88aaa00000000898668980000000000000000009cc900bbbbbbbbcccccccc11111111333b33334434444355555545ffffffff66566666
0000000000000000aaaaaaaa0000000008666680000000000000000000cccc00bebbbbbbccccc7cc11111111333333334444444454555555ff9fffff66566656
0000000000000000a0aaaa0a0000000080899808000000000000000000c99c00bbbbbbbbcccccccc11c111113b3333b34444444455555555ffffff9f66666656
0000000000000000a0aaaa0a00000000000880000000000000000000ccccccccbbbbbbbbcc7ccccc11111131333333334444344455554555ffffffff66566666
0000000000000000009aa90000000000088888800000000000000000c0cccc0cbbbbbb8bcccccacc111111113333b3334344444455555555fff9ffff66666656
0000000000000000099009900000000000888800000000000000000000c00c00bbbbbbbbcccccccc11111111333333334444444455555555ffffffff66666656
0000000000e00e000e0000e000e00e0011111111000000000000000000000000bbbbbbbbcccccccc11111111333333330000000000000000cac88ccc00000000
0000000000088000e880088e0008800011c11111000000000000000000000000bbbbbabbcc7ccccc11111c11333338330000000000000000cccaaccc00000000
00e00e00e089980e08899880e089980e11115111000000000000000000000000bbbbbbbbcccccccc11111111333333330000000000000000cc8888cc00000000
000ee0000897a980009a79000897a98011111151000000000000000000000000bebbbbbbcccccccc11111111333333330000000000000000ac8888ca00000000
000ee000089a79800097a900089a798011511111000000000000000000000000bbbb8bbbccccc7cc111111713a3333330000000000000000cf8778fc00000000
00e00e00e089980e08899880e089980e11115111000000000000000000000000bbbbbbbbcccccccc11c11111333333330000000000000000ff8888ff00000000
0000000000088000e880088e00088000111c1111000000000000000000000000bbbbbb8bcccccccc111111113333e3330000000000000000f388883f00000000
0000000000e00e000e0000e000e00e0011111111000000000000000000000000bbbbbbbbcccccccc111111113333333300000000000000003333333300000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06566560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65666656000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
60655606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
a2a2a2a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a3a2a3a3a2a2a2a2a2a3a3a2a3a2a3a3a3a3a3a392e282828282b2b2b2b2b2b3b2b2b2b3b2b2a1
b1b2b2b2b2b2b28282e2e2e292939393a2a2a2a2a3a343a2a2a2a2a2a2a2a2a243a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a3a2a3a2a2a3a3a2a3a3a3a2a2a2a2a2a2a392e2828283828382b2b2b2b2b2b2b2b2b2b2b2
b2b2b39392b3b2b282e2e2e2e2929393a2a3a3a3a3a3a2a2a2929292a2a2a2a3a243a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a3a2a2a3a3a3a2a3a3a3a3a3a392e2e2e2828282828282b2b2b2b2b2b2b2b2b2
b2b2b393939392b28282e2e2e2929293a2a2a2a2a2a2a2a29292e2929292a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a3a3a3a2a2a3a3a2a3a2a3a3a3a2a2a39292e2e2e2e2828382838282838382b2b2b282
82b2b2b2b3b39292b28282e2e2929293a2a2a2a3a2a2a29292e2e2e2e292a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a2a2a2a3a3a3a3a2a2929292e2e2e2e2e2e2e2e282828283838283
838282b2b2b2b29292828282e2929293a2a3a3a3a2929292e2838383e292a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a2a2a2a2a2a2a3a3a2a3a3a3a2a3a2a2a2929292929292e2e2e2e2e2e2e2828383e2
e2e2e2828282b3b392928282e2929293a2a343a2a292e3e2838383e29292a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a3a3a3a3a2a2a2a2a3a3a2a2a2a292929292929292929292e2e2e2e2e2e2
e2e2e2e2e2e2e2b3b392828282929293a2a2a2a2a292e2e28383b2e2e292a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a2a2a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a292929292e2e2e2
e2e2e2e2e2e2e2e2b392607082929293a2a3a3a2a39292e2e292e2e29292a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a2a2a2a2a3a3a3a2a2a2a2a2a3a3a3a2a2a3a2a2a2a2929292e2
e2e2e2e2e2e2e2b3b392617182929293a2a2a2a2a2a292929292929292a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a3a2a3a3a3a3a3a3a3a3a3a3a3a2a3a3a2a2a2a2a2a29292
9292e2e2e2e2929292928282829293a2a2a2a2a2a2a2a2a2a2a2a2a2a2a243a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a3a3a3a2a2a3a3a3a2a3a2a3a3a3a3a3a2a2a2a29292
929292e29292929292929282e293a2a2a3a2a2a3a3a3a2a2a2a343a2a2a2a3a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a3a3a3a2a2a3a3a3a3a3a2a3a2a2a2a2a2a2a2a2a3a3a3
9393929292939393939393e2e29343a2a243a2a2a2a2a2a2a3a3a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a3a3a2a3a2a3a2a3a3a2a3a3a2a2a2a2a2a2a2a2a2a3a2a3
a2a293929293a2a2a2a2a2a293e3a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a3a2a2a3a3a2a2a2a3a3a3a2a2a2a3a2a2a3a2a2a2a3
43a2a293a2a2a3a3a2a2a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a243a2a2a3a3a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a2a2a2a2a2a3a2a2a2a2a3a3a2a3a2a3a3a3a2a3a2a2a2a3
a2a2a2a2a2a243a2a3a2a243a2a2a2a2a2a2a2a2a3a3a343a3a3a3a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a2a2a2a2a2a2a2a3a3a3a2a3a3a2a2a3a2a3
a2a2a2a2a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a2a2a2a2a2a2a3a2a2a2a3a3a2a2a3a3a2
a3a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a343a2a3a3a2a3a3a3a2a2a3a3a3a3a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2
a2a3a3a3a3a2a343a2a2a2a2a2a2a2a2a3a2a2a2a2a3a3a2a2a3a3a2a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3
a3a3a2a2a3a2a2a2a2a2a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2
a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a3a2a3a3a2a2a2a2a2a2a3a343a3a3a3a2a3a3a2a2a3a2a2a3a3a2a3a3a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a3a3a3a2a2a3a3a3a3a3a3a2a3a3a3a3a2a3a3a2a3a3a3a2a2a3a3a2a2a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a3a3a2a2a2a2a3a3a2a2a3a3a3a2a2a3a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a3a3a2a2a2a2a3a3a2a2a3a3a3a2a2a3a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a3a3a2a2a2a2a3a3a2a2a3a3a3a2a2a3a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
__label__
ccccccccccccccccccccc7ccccc33333333bbbbbbbbbbbbbbbbffffffffffffffffffffffffcc7ccccccc7ccccccccccccc11111131111111311111113111111
ccccccccccccccccccccccccacc3333b333bbbbbb8bbbbbbb8bfff9fffffff9fffffff9ffffcccccacccccccacccccccccc11111111111111111111111111111
ccccccccccccccccceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffffffcccccccccccccccccccccccc11111111111111111111111111111
3377337733777333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebffffffffffffffffcccccccccccccccccccccccc11111111111111111111111111111
b33733378373733eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffff9fffffff9ffccbcccccccbccccccc7ccccc11111111111111111111111111111
333733373373733eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffffffffffffffcccccccccccccccccccccccc11111111111111111111111111111
333733373373733eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeff9fffffff9fffffccccc7ccccccc7cccccccccc11111111111111111111111111111
3b7773777377733eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeffffff9fffffff9fccccccccccccccccccccc7cc11c1111111c1111111c1111111111
3333333333333333eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeebffffffffffffffffcc7ccccccc7ccccccccccccc11111131111111311111113111c11
3333333e3333333e3eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee8bfff9fffffff9ffffcccccacccccccacccccccccc11111111111111111111111111111
3333333333333333333cccccccccccccccc33333333bbbbbbbbbbbbbbbbffffffffffffffffcccccccccccccccccccccccc11111111111111111111111111111
333333333333333338888888888888888ccccccccccbbbbbbbbbbbbbbbbbbbbbbbbffffffffcccccccccccccccccccccccc11111111111111111111111111111
b37773777333b333888888888888888888cccbcccccbbbbbabbbbbbbabbbbbbbabbfffff9ffccbcccccccbccccccc7ccccc1111111111111c1111111c1111111
33733373733333b88888888888888888888ccccccccbbbbbbbbbbbbbbbbbbbbbbbbffffffffcccccccccccccccccccccccc11111111111111111111111111111
33777373733333388888888888888888888ccccc7ccbebbbbbbbebbbbbbbebbbbbbff9fffffccccc7ccccccc7cccccccccc11111111111111111111111111111
3b3373737b33b3388888888888888888888ccccccccbbbbbbbbbbbbbbbbbbbbbbbbffffff9fccccccccccccccccccccc7cc11c11111111111711111117111111
33777377733333388888888888888888888cc7cccccbbbbbbbbbbbbbbbbbbbbbbbbffffffffcc7ccccccc7ccccccccccccc1111113111c1111111c1111111c11
3333333b3333333b888888888888888888ccccccaccbbbbbb8bbbbbbb8bbbbbbb8bfff9ffffcccccacccccccacccccccccc11111111111111818118181111111
333333333333333338888888888888888ccccccccccbbbbbbbbbbbbbbbbbbbbbbbbffffffffcccccccccccccccccccccccc11111111111111189889811111111
bbbbbbbbbbbbbbbbbbb3333333333333333ccccccccccccccccbbbbbbbbbbbbbbbbffffffffcccccccccccccccccccccccc11111111111111898668981111111
ab8b8bb8a8bbbbbbabb3333383333333833ccbcccccccbcccccbbbbbabbbbbbbabbfffff9ffccbcccccccbccccccc7ccccc1111111111111c186666811111111
bbb898898bbbbbbbbbb3333333333333333ccccccccccccccccbbbbbbbbbbbbbbbbffffffffcccccccccccccccccccccccc11111111111111818998581111111
bb89866898bbebbbbbb3333333333333333ccccc7ccccccc7ccbebbbbbbbebbbbbbff9fffffccccc7ccccccc7cccccccccc11111111111111111881115111111
bbb866668bb777bbb7b777333333a333333ccccccccccccccccbbbbbbbbbbbbbbbbffffff9fccccccccccccccccccccc7cc11c11111111111788888811111c11
bb8b8998b8bbb7bb7bb7373333333333333cc7ccccccc7cccccbbbbbbbbbbbbbbbbffffffffcc7ccccccc7ccccccccccccc1111113111c111118888511111111
b8bbb88bb8b777bb78b7773e3333333e333cccccacccccccaccbbbbbb8bbbbbbb8bfff9ffffcccccacccccccacccccccccc1111111111111111111c111111111
bbb888888bb7bbbb7bb3373333333333333ccccccccccccccccbbbbbbbbbbbbbbbbffffffffcccccccccccccccccccccccc11111111111111111111111111111
ffff8888fff777f7fffff7fffff3333333333333333ccccccccbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
9fffffff9fffffff9fffffff9ff3333383333333833ccbcccccbbbbbabbbbbbbabbbbbbbabbccbcccccccbccccccc7ccccc11111111111111111111111111111
fffffffffffffffffffffffffff3333333333333333ccccccccbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
fffff9fffffff9fffffff9fffff3333333333333333ccccc7ccbebbbbbbbebbbbbbbebbbbbbccccc7ccccccc7cccccccccc11111111111111111111111111111
f9fffffff9fffffff9fffffff9f3a3333333a333333ccccccccbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccc7cc11c1111111c1111111c1111111c11
fffffffffffffffffffffffffff3333333333333333cc7cccccbbbbbbbbbbbbbbbbbbbbbbbbcc7ccccccc7ccccccccccccc11111131111111311111113111111
ffffff9fffffff9fffffff9ffff3333e3333333e333cccccaccbbbbbb8bbbbbbb8bbbbbbb8bcccccacccccccacccccccccc11111111111111111111111111111
fffffffffffffffffffffffffff3333333333333333ccccccccbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
fffffffffffffffffffffffffffffffffff33333333cccccccc3333333333333333bbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
9fffffff9fffffff9fffffff9fffffff9ff33333833ccbccccc333cccccccccc333bbbbbabbccbcccccccbccccccc7ccccc1111111111111c1111111c1111111
fffffffffffffffffffffffffffffffffff33333333cccccccc33cccccccccccc33bbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
fffff9fffffff9fffffff9fffffff9fffff33333333ccccc7cc3cccccccccccccc3bebbbbbbccccc7ccccccc7cccccccccc11111111111111111111111111111
f9fffffff9fffffff9fffffff9fffffff9f3a333333cccccccc3cccccccccccccc3bbbbbbbbccccccccccccccccccccc7cc11c11111111111711111117111c11
fffffffffffffffffffffffffffffffffff33333333cc7ccccc3c66666ccc666cc3bbbbbbbbcc7ccccccc7ccccccccccccc1111113111c1111111c1111111111
ffffff9fffffff9fffffff9fffffff9ffff3333e333cccccacc3c67a76cc6a7a6c3bbbbbb8bcccccacccccccacccccccccc11111111111111111111111111111
fffffffffffffffffffffffffffffffffff33333333cccccccc3c6a766cc67a76c3bbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
fffffffffffffffffffffffffff3333333333333333cccccccc3c676666c6a7a6c3bbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
9fffffff9fffffff9fffffff9ff3333383333333833ccbccccc3c6a67a6666a6663bbbbbabbccbcccccccbccccccc7ccccc11111111111111111111111111111
fffffffffffffffffffffffffff3333333333333333cccccccc36676a767a6667a3bbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
fffff9fffffff9fffffff9fffff3333333333333333ccccc7cc376a67a6a6666a73bebbbbbbccccc7ccccccc7cccccccccc11111111111111111111111111111
f9fffffff9fffffff9fffffff9f3a3333333a333333cccccccc36666a76767a6763bbbbbbbbccccccccccccccccccccc7cc11c1111111c1111111c1111111c11
fffffffffffffffffffffffffff3333333333333333cc7ccccc337a67a6a6a76633bbbbbbbbcc7ccccccc7ccccccccccccc11111131111111311111113111111
ffffff9fffffff9fffffff9ffff3333e3333333e333cccccacc33376a76767a6333bbbbbb8bcccccacccccccacccccccccc11111111111111111111111111111
fffffffffffffffffffffffffff3333333333333333cccccccc3333333333333333bbbbbbbbcccccccccccccccccccccccc11111111111111111111111111111
fffffffffffffffffffccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccc1111111111111111111111111111111111111
9fffffff9fffffff9ffccbcccccccbcccccccbcccccccbcccccbbbbbabbbbbbbabbbbbbbabbccbccccccc7ccccc1111111111111111111111111111111111111
fffffffffffffffffffccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccc1111111111111111111111111111111111111
fffff9fffffff9fffffccccc7ccccccc7ccccccc7ccccccc7ccbebbbbbbbebbbbbbbebbbbbbccccc7cccccccccc1111111111111111111111111111111111111
f9fffffff9fffffff9fccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccc7cc11c1111111c1111111c1111111c1111111c11
fffffffffffffffffffcc7ccccccc7ccccccc7ccccccc7cccccbbbbbbbbbbbbbbbbbbbbbbbbcc7ccccccccccccc1111113111111131111111311111113111111
ffffff9fffffff9ffffcccccacccccccacccccccacccccccaccbbbbbb8bbbbbbb8bbbbbbb8bcccccacccccccccc1111111111111111111111111111111111111
fffffffffffffffffffccccccccccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbbbbcccccccccccccccc1111111111111111111111111111111111111
fffccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbffffffffcccccccc111111111111111111111111111111111111111111111
9ffccbcccccccbcccccccbcccccccbcccccccbcccccccbcccccccbcccccbbbbbabbfffff9ffcc7ccccc111111111111111111111c11111111111111111111111
fffccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbffffffffcccccccc111111111111111111111111111111111111111111111
fffccccc7ccccccc7ccccccc7ccccccc7ccccccc7ccccccc7ccccccc7ccbebbbbbbff9fffffcccccccc111111111111111111111111111111111111111111111
f9fccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbbbbfeffff9fccccc7cc11c1111111c111111111117111c1111111c1111111111
fffcc7ccccccc7ccccccc7ccccccc7ccccccc7ccccccc7ccccccc7cccccbbbbbbbbeeffffffcccccccc111111311111113111c11111111111311111113111c11
fffcccccacccccccacccccccacccccccacccccccacccccccacccccccaccbbbbbcceeeeeffffcccccc8c811818111111111111111181811818111111111111111
fffccccccccccccccccccccccccccccccccccccccccccccccccccccccccbbbbbceeeee8ffffccccccc8988981111111111111111118988981111111111111111
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccfffffeeeeeffffffcccccc89866898111111111111111189866898111111111111111
cccccbccccccc7ccccccc7ccccccc7ccccccc7ccccccc7ccccccc7cccccfffff9eeeffff9ffcc7cccc8666681111111111111111118666681111111111111111
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccfffffffeffffffffcccccc8c899858111111111111111181899858111111111111111
7ccccccc7ccccccccccccccccccccccccccccccccccccccccccccccccccff9fffffff9fffffcccccccc188111511111111111111111188111511111111111111
cccccccccccccccc7ccccccc7ccccccc7ccccccc7ccccccc7ccccccc7ccffffff9fffffff9fccccc7c88888811111c1111111c111188888811111c1111111c11
ccccc7cccccccccccccccccccccccccccccccccccccccccccccccccccccffffffffffffffffcccccccc888851111111113111111131888851111111113111111
acccccccaccccccccccccccccccccccccccccccccccccccccccccccccccfff9fffffff9ffffcccccccc111c11111111111111111111111c11111111111111111
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccffffffffffffffffcccccccc111111111111111111111111111111111111111111111
ccccccccccccccccccc111111111111111111111111111111111111111111111111cccccccccac88ccc111111111111111111111111111111111111111111111
cccccbccccccc7ccccc111111111111111111111111111111111111111111111111cc7ccccccccaaccc111111111111111111111111111111111111111111111
ccccccccccccccccccc111111111111111111111111111111111111111111111111cccccccccc8888cc111111111111111111111111111111111111111111111
7ccccccc7cccccccccc111111111111111111111111111111111111111111111111ccccccccac8888ca111111111111111111111111111111111111111111111
cccccccccccccccc7cc11c1111111c1111111c1111111c1111111c1111111c11111ccccc7cccf8778fc11c1111111c1111111c1111111c1111111c1111111c11
ccccc7ccccccccccccc111111311111113111111131111111311111113111111131ccccccccff8888ff111111311111113111111131111111311111113111111
acccccccacccccccccc111111111111111111111111111111111111111111111111ccccccccf388883f111111111111111111111111111111111111111111111
ccccccccccccccccccc111111111111111111111111111111111111111111111111cccccccc33333333111111111111111111111111111111111111111111111
ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccc111111111111111111111c1111111c111111111111111111111111111111111111111111111111111111111111111c1111111c11111111111111111111111
ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccc11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
7cc11c1111111c11111111111711111117111c1111111c1111111c1111111c1111111c1111111c1111111c11111111111711111117111c1111111c1111111c11
ccc111111311111113111c1111111c111111111113111111131111111311111113111111131111111311111113111c1111111c11111111111311111113111111
ccc11111111111111118181181811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
ccc11111111111111111898898111111111111111111111111111111161111116111111111111111111111111111111111111111111111111111111111111111
11111111111111111118986689811111111111111111111111111111116566561111111111111111111111111111111111111111111111111111111111111111
1111111111111111111186666811111111111111c111111111111111165666656111111111111111111111111111111111111111111111111111111111111111
11111111111111111118189981811111111111111111111111111111116666661111111111111111111111111111111111111111111111111111111111111111
11111111111111111111118815111111111111111111111111111111161655616511111111111111111111111111111111111111111111111111111111111111
11111c1111111c111111888888111c111111111117111c1111111c111111661111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c11
1311111113111111131118888111111113111c111111111113111111131111151111111113111111131111111311111113111111131111111311111113111111
1111111111111111111111c111111111111111111111111111111111111111c11111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111111111111111111111111111111c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111c1111111c1111111c1111111c111111111117111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c11
1311111113111111131111111311111113111c111111111113111111131111111311111113111111131111111311111113111111131111111311111113111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111181811818111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111118988981111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111189866898111111111111111
11111111c11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c18666681111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111181899858111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111188111511111111111111
1111111117111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c11111111111788888811111c1111111111
13111c11111111111311111113111111131111111311111113111111131111111311111113111111131111111311111113111c11111888851111111113111c11
11111111111111111111111111818118181111111111111111111111111111111111111111111111111111111111111111111111111111c11111111111111111
11111111111111111111111111189889811111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111898668981111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
c1111111c111111111111111c1186666811111111111111111111111111111111111111111111111111111111111111111111111c11111111111111111111111
11111111111111111111111111818998181111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111881151111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1711111117111c11111111111718888881111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c111111111117111c1111111c1111111c11
11111c111111111113111c1111118888111111111311111113111111131111111311111113111111131111111311111113111c11111111111311111113111111
111111111111111111111111111111c1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111c111111111111111111111111111111111111111111111111111111111111111111111111111111111111111c1111111c11111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111111117111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111c11111111111711111117111c1111111c1111111c11

__gff__
0000000000001101110102020000000004000000000001010101020200000000000000000000000008040408080808080004040414000000080404080000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a3a3a3a2a3a3a2a3a3a3a3a3a3a3a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a2a2a3a2a3a3a2a2a2a2a2a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a3a3a2a2a3a3a2a2a2a2a2a3a3a2a2a3a3a3a3a2a2a2a2a3a3a2a2a3a3a2a2a2a2a2a3a3a2a2a2a3a2a2a2a3a2a2a3a3a3a3a3a2a2a2a2a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a3a3a2a2a2a2a3a2a3a2a3a3a2a3a3a3a3a3a2a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a3a3a3a3a3a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a2a2a2a3a3a3a3a2a2a3a3a3a3a2a2a2a2a3a3a2a2a3a3a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a3a2a2a3a3a2a3a3a2a2a3a3a3a3a3a3a3a3a2a3a3a2a2a3a2a2a3a3a2a3a3a2a2a3a3a2a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a3a3a2a2a3a3a2a2a3a3a3a3a2a2a3a3a3a3a2a3a3a2a3a3a3a2a2a3a3a2a2a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a3a3a3a3a2a3a3a2a3a2a2a3a3a3a2a2a3a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a2a2a3a3a3a3a3a3a3a3a3a2a3a3a2a2a3a2a2a3a3a2a3a3a2a2a3a3a2a2a2a2a3a3a2a2a3a3a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a3a3a3a2a3a2a3a3a3a3a3a3a3a2a2a3a3a3a3a2a2a3a3a3a3a3a2a3a2a3a3a3a3a3a3a3a2a2a2a3a3a3a3a2a3a3a2a3a3a3a2a2a3a3a2a2a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a3a3a3a3a3a2a2a3a2a3a3a3a3a2a2a3a2a2a3a3a3a2a2a3a3a3a3a3a2a2a3a2a3a3a3a3a2a2a3a3a2a2a3a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a2a2a3a2a2a2a2a2a2a2a3a3a3a3a3a2a2a2a3a3a2a2a2a2a2a2a3a3a3a3a2a2a2a2a3a3a2a2a3a3a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a2a3a3a2a2a2a3a2a2a3a2a2a3a3a3a3a2a3a3a3a3a2a3a2a3a3a2a2a2a3a2a2a3a2a2a3a3a2a2a2a3a3a3a3a2a2a3a3a3a3a3a2a3a2a3a3a3a3a3a3a3a2a3a3a2a2a3a2a2a3a3a2a3a3a2a2a3a3a2a2a2a2a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a3a2a3a3a3a3a3a3a2a2a2a2a3a2a2a2a2a2a3a2a2a3a3a3a2a3a3a3a3a3a3a2a2a2a2a3a3a3a2a2a3a2a2a3a3a3a2a2a3a3a3a3a3a2a2a3a2a3a3a3a3a3a3a2a3a3a3a2a2a3a3a2a2a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a3a2a2a2a2a3a3a3a3a3a3a3a2a3a3a3a3a3a3a2a3a3a2a3a2a2a2a2a3a3a3a3a3a3a3a2a2a2a3a3a3a2a3a3a3a3a2a3a2a3a3a2a2a2a3a2a2a3a2a2a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a2a2a3a2a2a2a2a3a3a3a3a3a3a2a3a3a2a2a3a2a2a3a3a2a3a3a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a3a2a2a2a2a3a3a3a2a2a2a2a2a3a3a3a2a2a3a3a2a3a2a3a2a2a2a2a3a3a3a2a2a2a2a2a2a3a2a2a2a2a2a3a3a2a3a3a3a2a3a3a3a3a3a3a2a2a2a2a3a2a2a3a3a3a3a3a2a3a2a3a3a3a3a3a3a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a3a3a2a2a3a3a2a2a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a3a3a2a2a2a2a3a3a2a2a2a3a2a2a2a2a2a2a2a2a2a3a2a3a3a3a3a3a3a3a3a3a2a3a2a2a2a2a3a3a3a3a3a3a3a2a3a3a2a2a3a3a3a3a3a2a2a3a2a3a3a3a3a2a2a2a2a3a3a2a2a3a3a2a2a2a2a2a3a3a3a3a2a3a3a2a3a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a3a2a3a2a2a2a2a2a2a3a2a2a3a3a3a3a2a2a3a3a2a3a2a3a2a2a2a2a3a3a3a2a3939392a3a3a2a3a2a3a3a2a2a2a3a2a2a3a2a2a3a2a2a2a2a2a2a3a3a3a3a2a2a3a3a3a3a3a2a3a2a3a3a3a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a3a2a2a2a2a2a3a3a2a2a3a3a3a3a3a2a2a2a2a3a3a2a2a2a39392a2a2a39393939393939393a3a2a3a3a3a3a3a3a2a2a2a2a3a2a2a2a2a2a2a3a2a2a3a3a3a2a2a3a3a3a3a3a2a2a3a2a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a2a3a2a2a2a3a2a3a3a3a3a2a2a2a2a2a3a39393939393939393939393939393929392a393939392a3a3a3a3a3a3a3a2a3a342a2a3a3a3a2a3a3a3a3a2a3a2a3a3a2a2a2a3a2a2a3a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a2a2a2a2a3a3a3a3a3a3a3a3a39392a39393939392939392929292e2e2e2e2e29393929392939393a3a3a2a2a2a2a2a2a3a3a2a2a2a2a2a2a3a2a2a3a3a3a2a3a3a3a3a3a3a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a2a3a3a3a2a2a3a3a3a3a2a3a3a3a39393939393939392e2e2e2e2e2e28282838282e2e2e2e2e2939392a2a2a2a2a2a2a2a2a343a3a3a3a3a3a3a3a2a3a3a2a3a2a2a2a2a3a3a3a3a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a2a3a3a2a3a2a3a3a3a2a3a393939393939392939292e2e2828382828282828282828282e2e2828393939392a2a2a2a2a2a2a2a2a2a3a3a3a2a2a3a3a2a3a2a3a2a2a2a2a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a2a2a3a2a3a3a3a3a2a3a3939393939292939392e2e2828282828282b2b2b2b2b28282e2e392839393939392a2a2a2a2a2a3a3a2a2a2a3a3a2a2a2a2a3a3a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a3a3a3a2a3939392929292e2e2828282838282b2b2b2b3b2b2b2b28283939282839393939392a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a3a3a3a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a3a3a3a3a2a2a2a3939392e2e2e2e2828282b2b2b2b2b2b3b3b2b2b2b2b2b282828282828283939392a2a2a2a3a3a3a2a2a2a2a2a2a2a2a2a2a2a2a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a2a2a3a3a2a2a2a2a2a2a2a2a2a2a3a3a3a3a2a2a3a3a3a3a3a2a3a2a3a3a3a3a3a3a3a3a2a3a2a2a2a3939392e282828382b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b28283838282839392a2a2a2a343a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a2a2a2a2a3a3a3a3a3a3a3a2a2a2a3a2a2a3a3a3a2a2a3a3a3a3a3a2a2a3a2a3a3a3a3a2a3a2a2a2a393939392e3828382b2b2b3b2b2b2b3b2b2b2b3b2b2b2b2b2b2b2b28383828283939392a2a2a2a2a3a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a3a2a3a3a3a3a3a2a2a2a3a3a3a3a3a2a3a3a3a3a2a3a2a3a3a2a2a2a3a2a2a3a2a2a3a3a3a3a3a3a393939292e2828282b2b2b2b2b2b2b3b2b2b2b2b3b2b2b2b2b3b2b2b283838383939392a2a2a3a3a3a3a2a2a2a2a2a2a2a342a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a3a3a3a2a3a3a3a3a3a3a2a3a2a2a2a2a2a3a2a2a3a3a3a2a3a3a3a3a3a3a2a2a2a2a3a3a3a3a3a3a3a3939292e282828282b2b2b3b3b2b2b2b3b2b2b2b2b2b2b2b2b2b2b2b2828382e3939392a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
3a2a2a2a3a3a2a3a3a2a3a3a3a3a3a3a3a3a3a2a3a3a2a3a2a2a2a2a3a3a3a3a3a3a3a2a3a3a3a3a3a2a2939292e2e38282b2b3b2b2b2b2b2b2b2b2b2b2b2b3b2b2b2b2b2b2b2828382e2e393939392a3a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a2a3a2a2a3a2a3a2a3a2a3a3a3a3a2a2a3a3a2a3a2a3a2a2a2a2a3a3a3a2a2a3a3a3a3a2a3a2a2a3a393a292e2e28282b2b2b2b2b2b3b2b2b2b3b2b2b2b2b2b2b2b2b2b2b28282e2e2e393939392a2a3a3a2a2a2a2a2a2a2a2a2a2a342a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
2a2a3a3a2a2a2a3a3a2a2a2a2a2a2a3a3a2a2a2a2a3a3a2a2a2a3a2a3a2a2a2a2a3a2a3a2a2a3a2a2a3a3a2a29292e3828282b2b2b2b2b2b2b2b2b2b2b2b2b0a0b2b2b2b2b2b28282e2e2e293939392a2a3a342a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a
__sfx__
a0160020156101361012610136101461017610196101c6101d6101e6101d6101a61018610166101361013610146101561017610196101d6101f6102061021610216101f6101e6101b61019610176101661016610
a40100002255023550235502355023550235502255021550205501f5501e5501c5501c5501b5501a5501a5501a5501a5501a5501a5501b5501c5501d5501e5501f5502055022550245502555026550285502a550
300200200c3400c3400c3400c3400c3400d3400e3400f34011340133401435015350163501735018350193501a3501a3501a3501a3501a3501935018350173501635014350133401134010340103401034010340
36020000011500115002150041500515007150081500a1500c1500d1500f1501115012150141501515016150161501715017150161501415013150111500d1500c15009150081500615004150031500215001150
000e00200031001310013100131001310013100131001310133101731014310173101531017310153101231003310033100331003310033100331004310043101b31018310193101531017310153101731014310
00100010234531f4531c453244531d4531c453264531d4531b453274531e4531b453254531b4531e453224530f403124031240314403164030c4030e40310403114031340315403184031a4031c4031d40321403
300200201301612016110161101610016100160f0160e0160d0160c0160c0160b0160b0160b0160b0160a0160a0160a0160a0160a0160a0160a0160a0160a0160a0160b0160b0160c0160d0160e0160f01612016
0001000000b0031b5032b5032b5032b5031b5031b5030b5030b5030b502fb502fb502fb502eb502db502bb502bb5029b5028b5024b5022b5020b501eb501ab5018b5016b5015b5013b5013b5012b5011b5010b50
d240001019334193341c3341c3341933419334163341633418334183341b3341b3341833418334153341533415304183040d3040c3040b3040c3040c3040c3040b3040a304083040630405304043040330402304
0e0300001e63023640286402b6502e650316603266033660316502d6402864026640216301d650196501665013650106500e6500c65009650076500565003650026500165000650006502d600286002660025600
00010000120501305016050190501b0501d0501e0501f0501f050200501f0501e0501c0501b0501a05018050170501405012050100500e0500c0500b0500b0500a0500b0500c0500d05010050110501405015050
__music__
02 004b4844
03 04424344
03 08464344
00 02424344

