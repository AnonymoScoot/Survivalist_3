AddCSLuaFile()

ENT.Type = "point"
 
ENT.PrintName		= "Zombie Spawner"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.AdminSpawnable 	= false
ENT.Spawnable 		= false

if SERVER then
	
	function ENT:Initialize()
	end
	 
	function ENT:Think()
	end

end

if CLIENT then
	function ENT:Draw()
	end
end
