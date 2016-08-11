local pl = FindMetaTable("Player")

function Spawn_Classes( length, ply )
		
		local num = net.ReadFloat()
		local melee = net.ReadFloat()
		local secondary = net.ReadFloat()
		local primary = net.ReadFloat()
		
		
		local class = {}
		class[1] = 
		{
		
			name 			= "Supplier",
			color 			= Vector( .2, .2, .8 ), 
			model 			= { "models/player/group03/male_02.mdl", "models/player/group03/male_03.mdl", "models/player/group03/male_05.mdl", "models/player/group03/male_07.mdl" },
			walkspeed 		= 150,
			runspeed		= 195,
			health 			= 100,
			armor 			= 10,
			crouchspeed		= 0.4,
			duckspeed 		= 0.3,
			unduckspeed 	= 0.3,
			jumppower 		= 160,
			
		}
		
		
		class[2] = { 
			name 			= "Combat Medic",
			color 			= Vector( 0, .9, 0 ),
			model 			= { "models/player/group03m/male_01.mdl", "models/player/group03m/male_02.mdl", "models/player/group03m/male_03.mdl", "models/player/group03m/male_04.mdl", "models/player/group03m/male_05.mdl", "models/player/group03m/male_06.mdl", "models/player/group03m/male_07.mdl", "models/player/group03m/male_08.mdl", "models/player/group03m/male_09.mdl" },
			walkspeed 		= 165,
			runspeed		= 205,
			health 			= 85,
			armor 			= 0,
			crouchspeed		= 0.4,
			duckspeed 		= 0.3,
			unduckspeed 	= 0.3,
			jumppower 		= 175,
		}
		
		
		class[3] = { 
			name			= "Engineer", 
			color 			= Vector( 0, .9, .9 ), 
			model 			= { "models/player/breen.mdl", "models/player/kleiner.mdl" },
			walkspeed 		= 135,
			runspeed		= 180,
			health 			= 125,
			armor 			= 30,
			crouchspeed		= 0.4,
			duckspeed 		= 0.3,
			unduckspeed 	= 0.3,
			jumppower 		= 155,
		}
		
		
		class[4] = { 
			name 			= "Specialist", 
			color		 	= Vector( 0, .8, .2 ), 
			model 			= { "models/player/eli.mdl", "models/player/odessa.mdl" },
			walkspeed 		= 150,
			runspeed		= 200,
			health 			= 125,
			armor 			= 15,
			crouchspeed		= 0.4,
			duckspeed 		= 0.3,
			unduckspeed 	= 0.3,
			jumppower 		= 145,
		}
		
		
		class[5] = { 
			name 			= "Officer", 
			color 			= Vector( 0, .1, .6 ), 
			model 			= { "models/player/police.mdl", "models/player/barney.mdl" },
			walkspeed 		= 175,
			runspeed		= 215,
			health 			= 90,
			armor 			= 10,
			crouchspeed		= 0.4,
			duckspeed 		= 0.3,
			unduckspeed 	= 0.3,
			jumppower 		= 185,
		}
		
		
		class[6] = { 
			name 			= "Soldier", 
			color 			= Vector( .2, .6, .6 ), 
			model 			= { "models/player/combine_soldier.mdl", "models/player/combine_soldier_prisonguard.mdl", "models/player/combine_super_soldier.mdl" },
			walkspeed 		= 135,
			runspeed		= 165,
			health 			= 175,
			armor 			= 50,
			crouchspeed		= 0.3,
			duckspeed 		= 0.3,
			unduckspeed 	= 0.3,
			jumppower 		= 135,
		}
		
		ply:Spawn()
		ply:UnSpectate()
		ply:SetTeam( num )
		
		ply:SetPlayerColor( class[num].color )
		ply:SetModel( table.Random( class[num].model ) )
		ply:SetupHands()
		
		ply:SetWalkSpeed( class[num].walkspeed )
		ply:SetRunSpeed( class[num].runspeed )
		ply:SetMaxHealth( class[num].health )
		ply:SetHealth( class[num].health )
		ply:SetArmor( class[num].armor )
		ply:SetCrouchedWalkSpeed( class[num].crouchspeed )
		ply:SetDuckSpeed( class[num].duckspeed )
		ply:SetUnDuckSpeed( class[num].unduckspeed )
		ply:SetJumpPower( class[num].jumppower )
		
		ply:SetAvoidPlayers(true)
		ply:SetNoCollideWithTeammates(false)
		ply:ShouldDropWeapon(false)
		
		ply:StripWeapons()
		ply:RemoveAllAmmo()
		
		local melee_weapons = {}
		melee_weapons[1] = "weapon_crowbar"
		melee_weapons[2] = "weapon_physcannon"
		
		local secondary_weapons = {}
		secondary_weapons[1] = "weapon_pistol"
		secondary_weapons[2] = "weapon_357"
		
		local primary_weapons = {}
		primary_weapons[1] = "weapon_smg1"
		primary_weapons[2] = "weapon_ar2"
		
		ply:Give( melee_weapons[melee] )
		ply:Give( secondary_weapons[secondary] )
		ply:Give( primary_weapons[primary] )
			
		
end

