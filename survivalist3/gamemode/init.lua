AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_spawn.lua" )

include( "shared.lua" )
include( "player_spawn.lua" )

----------------------
----------------------

function GM:ShowTeam()

	local ply = player.GetAll()[1]

	net.Start("Spawn_Menu")
	net.Send(ply)

end

function GM:ShowHelp()

	local ply = player.GetAll()[1]
	
	ply:Spawn()
	ply:UnSpectate()
	ply:SetTeam( 1 )

end


function GM:PlayerInitialSpawn( ply )
	
	Msg("Player "..ply:Nick().." has entered the server.\n")
	
	if ply:IsBot() then
		
		ply:SetTeam( math.random(1,6) )
		ply:SetModel( "models/player/gman_high.mdl" )
		ply:SetPlayerColor( Vector( math.Rand(0,1), math.Rand(0,1), math.Rand(0,1) ) )
		
	else
	
		timer.Simple(0,function()
		
			GAMEMODE:PlayerSpawnAsSpectator( ply )
			ply:SetTeam( TEAM_SPECTATOR )
			ply:Spectate( OBS_MODE_ROAMING )
			ply:SetPos( ply:GetPos() + Vector(0,0,50) )
		
		end)
	
	end
	
	net.Start("Spawn_Menu")
	net.Send(ply)
	
end


function GM:PlayerSpawn( ply )
		
	ply:SetModel( "models/player/gman_high.mdl" )
	ply:SetPlayerColor( Vector( math.Rand(0,1), math.Rand(0,1), math.Rand(0,1) ) )
	
	ply:SetupHands()
	
end


function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

--------------------NET.RECEIVE-----------------------

net.Receive( "player_spawn_class", Spawn_Classes )
	
-------------------------------------------------------


function GM:CanPlayerSuicide( ply )

	if ply:Team() == TEAM_SPECTATOR then
	
		return false
		
	end
	
	return true

end


function GM:PlayerDeath( ply, ent, att )

	timer.Simple( 0, function()
	
	if ply:IsValid() then
	
		ply:SetTeam( TEAM_SPECTATOR )
		ply:Spectate( OBS_MODE_ROAMING )
		
		if team.NumPlayers( TEAM_SPECTATOR ) == #player.GetAll() then
	
			PrintMessage( HUD_PRINTTALK, "Everyone is dead! Changing Map\n" )
	
		end
		
	end
	
	end)
	
	//----------------------------//
	
	timer.Create( "DeathTimer"..ply:UserID(), 10, 1, function()
		
		if ply:IsValid() and !ply:Alive() then
			ply:UnSpectate()
			ply:SetTeam( 1 )
			ply:Spawn()
			net.Start( "Spawn_Menu" )
			net.Send( ply )
		end
		
	end)
	
	net.Start("player_death")
		net.WriteFloat( 10 )
		net.WriteFloat( math.Round( CurTime() ) )
	net.Send(ply)
		
end


function GM:PlayerDisconnected( ply )

	if team.NumPlayers( TEAM_SPECTATOR ) == #player.GetAll() then
	
		PrintMessage( HUD_PRINTTALK, "Everyone is dead! Changing Map\n" )
	
	end

end


function GM:PlayerShouldTakeDamage( ply, attacker )

	/*if attacker:IsPlayer() then
		return false
	end*/
	
	return true
	
end


function GM:PlayerDeathThink()

	return false
	
end


function GM:GetFallDamage( ply, speed )
 
	return ( speed / 12 )
 
end


function GM:PlayerSwitchFlashlight(ply, SwitchOn)

	if ply:Team() == TEAM_SPECTATOR then
	
		return false
		
	end
	
	return true
	
end


function Broadcast(Text)

	for k, v in pairs(player.GetAll()) do
	
		v:ChatPrint(Text)
		
	end
	
end


function ChangeMap( maps )

	game.ConsoleCommand("changelevel " ..table.Random(maps).. "\n")
	
end
