GM.Name = "Mission Games"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

function GM:Initialize()

	if SERVER then

	util.AddNetworkString( "Spawn_Menu" )
	
	util.AddNetworkString( "player_spawn_class" )
	
	util.AddNetworkString( "player_death" )
	
	end
	
	if CLIENT then
	
		surface.CreateFont( "HUDHealth",
		{
		font = "DermaLarge",
		size = ( ScrH() * 0.05 ),
		weight = 400,
		antialias = true,
		shadow = false
		})
		surface.CreateFont( "HUDArmor",
		{
		font = "DermaLarge",
		size = ( ScrH() * 0.04 ),
		weight = 400,
		antialias = true,
		shadow = false
		})
		surface.CreateFont( "HUDAmmo",
		{
		font = "DermaLarge",
		size = ( ScrH() * 0.065 ),
		weight = 400,
		antialias = true,
		shadow = false
		})
		surface.CreateFont( "HUDSecondaryAmmo",
		{
		font = "DermaLarge",
		size = ( ScrH() * 0.054 ),
		weight = 400,
		antialias = true,
		shadow = false
		})
		surface.CreateFont( "HUDName",
		{
		font = "DermaLarge",
		size = ( ScrH() * 0.045 ),
		weight = 400,
		antialias = true,
		shadow = false
		})
		surface.CreateFont( "HUDTime",
		{
		font = "DermaLarge",
		size = ( ScrH() * 0.05 ),
		weight = 400,
		antialias = true,
		shadow = false
		})
	
	end
	
	game.AddAmmoType( {
	name = "sv_ammo_primary", 
	dmgtype = DMG_BULLET, 
	tracer = TRACER_LINE, 
	plydmg = 0, 
	npcdmg = 0, 
	force = 1, 
	minsplash = 10, 
	maxsplash = 5
	} )
	
	game.AddAmmoType( {
	name = "sv_ammo_secondary", 
	dmgtype = DMG_BULLET, 
	tracer = TRACER_LINE, 
	plydmg = 0, 
	npcdmg = 0, 
	force = 1, 
	minsplash = 10, 
	maxsplash = 5
	} )

end

//--------TEAMS----------------

team.SetUp( 1, "Supplier", Color( 85, 85, 255, 255 ) )

team.SetUp( 2, "Combat Medic", Color( 50, 255, 50, 255 ) )

team.SetUp( 3, "Engineer", Color( 0, 225, 225, 255 ) )

team.SetUp( 4, "Specialist", Color( 0, 185, 80, 255 ) )

team.SetUp( 5, "Officer", Color( 0, 50, 165, 255 ) )

team.SetUp( 6, "Soldier", Color( 85, 165, 165, 255 ) )

//----------------------------


function GM:PlayerNoClip( ply )

	return false
	
end


function GM:PlayerFootstep( ply, pos, foot )
	
	if ply:KeyDown(IN_SPEED) then
	
		if ply:KeyDown(IN_FORWARD) then
		
			if foot == 0 then
			
				ply:ViewPunch( Angle( 0.5, 0, -0.5 ) )
			
			elseif foot == 1 then
			
				ply:ViewPunch( Angle( 0.5, 0, 0.5 ) )
			
			end
		
		elseif ply:KeyDown(IN_BACK) then
		
			if foot == 0 then
			
				ply:ViewPunch( Angle( -0.5, 0, -0.5 ) )
			
			elseif foot == 1 then
			
				ply:ViewPunch( Angle( -0.5, 0, 0.5 ) )
			
			end
		
		elseif ply:KeyDown(IN_MOVERIGHT) then
		
			ply:ViewPunch( Angle( 0, 0, 0.6 ) )
		
		elseif ply:KeyDown(IN_MOVELEFT) then
		
			ply:ViewPunch( Angle( 0, 0, -0.6 ) )
		
		end
		
	else
	
		if ply:KeyDown(IN_FORWARD) then
		
			if foot == 0 then
			
				ply:ViewPunch( Angle( 0.25, 0, -0.25 ) )
			
			elseif foot == 1 then
			
				ply:ViewPunch( Angle( 0.25, 0, 0.25 ) )
			
			end
		
		elseif ply:KeyDown(IN_BACK) then
		
			if foot == 0 then
			
				ply:ViewPunch( Angle( -0.25, 0, -0.25 ) )
			
			elseif foot == 1 then
			
				ply:ViewPunch( Angle( -0.25, 0, 0.25 ) )
			
			end
		
		elseif ply:KeyDown(IN_MOVERIGHT) then
		
			ply:ViewPunch( Angle( 0, 0, 0.35 ) )
		
		elseif ply:KeyDown(IN_MOVELEFT) then
		
			ply:ViewPunch( Angle( 0, 0, -0.35 ) )
		
		end
		
	end
	
	if ply:KeyPressed(IN_JUMP) then
	
		ply:ViewPunch( Angle( 5, 0, 0 ) )
		
	end
	
end


function GM:PostGamemodeLoaded()

	round_time = 1200
	
	if SERVER then
	
		first_round = true
	
		--ZombieTimer()
	
	end
	
	if CLIENT then
	
		respawning_allowed = true
	
	end

end


function GM:Think()

	if SERVER then

		if round_time then
			
			if !timer.Exists( "ZombieSpawn" ) then
			
				--ZombieTimer()
			
			end
			
			if ( round_time - math.Round( CurTime() ) ) == 1180 and first_round == true then
			
				Broadcast("Map change in " .. ( round_time - math.Round( CurTime() ) ) / 60 .. " minutes!\n")
				first_round = false
			
			
			end
			
			--ChangeMap( { "sv2_abandonhouse", "sv2_sewers", "sv2_warehouse" } )
			
		end
	
	end

end


function ZombieTimer()

	timer.Create( "ZombieSpawn", 8, 0, function()
	
		local classes = {}
		classes[1] = "npc_zombie"
		--classes[2] = "sv_npc_slowzombie_security"
		--classes[3] = "sv_npc_slowzombie_medic"
		--classes[4] = "sv_npc_fastzombie"
		--classes[5] = "sv_npc_bigzombie"
		local spawnpos = table.Random( ents.FindByClass("sv_zombie_spawner") )
	
		if #ents.FindByClass("npc_*") >= 60 then
		
			return
			
		end
	
		local zombie = ents.Create( table.Random(classes) )
		
		if zombie:IsValid() then
		
			if !spawnpos then 
				zombie:SetPos( Vector(0,0,0) )
			else
				zombie:SetPos( spawnpos:GetPos() )
			end
			
			zombie:Spawn()
			zombie:Activate()
	
		end
	
	end )

end

