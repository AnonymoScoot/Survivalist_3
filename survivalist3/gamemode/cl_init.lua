include( "shared.lua" )


--function GM:DrawDeathNotice(x, y)
--	return
--end


local HideHUD = { "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudCrosshair", "CHudWeaponSelection" }
function GM:HUDShouldDraw(name)

   for k, v in pairs(HideHUD) do
   
      if name == v then return false end
	  
   end

   return true
   
end


function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	local ply = LocalPlayer()
	local x, y = ScrW(), ScrH()
	
	valid_weapons = valid_weapons or {}
	no_weapons = { "weapon_healhands", }
	for k, v in pairs( ply:GetWeapons() ) do
		
		if !table.HasValue( no_weapons, v:GetClass() ) then
		
			if !table.HasValue( valid_weapons, v ) then
			
			table.insert( valid_weapons, v )
			
			end
		
		end
	
	end
	
	for k, v in pairs( valid_weapons ) do
	
		if !table.HasValue( ply:GetWeapons(), v ) then
		
			table.Empty( valid_weapons )
			WeaponSelectionSelected = nil
			WeaponSelecting = false
				
		end
	
		if v:IsValid() and !ply:HasWeapon( v:GetClass() ) then
			
			table.Empty( valid_weapons )
			WeaponSelectionSelected = nil
			WeaponSelecting = false
				
		end
	
	if IsValid( ply ) and IsValid( ply:GetActiveWeapon() ) then
	
		if table.HasValue( no_weapons, ply:GetActiveWeapon():GetClass() ) then
		
			WeaponSelectionSelected = nil
		
		end
	
		if ply:GetActiveWeapon() != v and WeaponSelectionSelected != CurWep() then
		
			if WeaponSelectionSelected == k then
			
				draw.RoundedBox( 10, 0.1 * x , ( 0.1 * y ) + ( ( y / 8 ) * k ) , 0.1 * x , 0.1 * y , Color( 0, 255, 0, 100 ) )
		
			end
		
		end
	
		if ply:GetActiveWeapon() == v then
		
			draw.RoundedBox( 10, 0.1 * x , ( 0.1 * y ) + ( ( y / 8 ) * k ) , 0.1 * x , 0.1 * y , Color( 200, 0, 0, 200 ) )
		
		end
		
		draw.RoundedBox( 10, 0.1 * x , ( 0.1 * y ) + ( ( y / 8 ) * k ) , 0.1 * x , 0.1 * y , Color( 0, 0, 0, 100 ) )
		
	end
		
	end
	
	if ply:IsValid() and !ply:Alive() and respawning_allowed == true then
	
		local time = ( CurrentTime + DeathTime ) - math.Round( CurTime() )
		
		draw.SimpleText( "Respawn in "..time.." seconds", DermaLarge, 0.5 * x, 0.5 * y, Color(255,255,255), 1, 1 )
	
	
	end
	
	if round_time then
	
		local tex_top = surface.GetTextureID("survivalist_3/hud/top_panel")
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetTexture( tex_top )
		surface.DrawTexturedRect( 0.45 * x , 0 * y, 0.1 * x, 0.1 * y )
	
		draw.SimpleText( string.FormattedTime( ( round_time ) - ( math.Round( CurTime() ) ), "%02i:%02i" ) , "HUDTime", 0.5 * x, 0.05 * y, Color(255,255,255), 1, 1 )
	
	end
	
	------------------------------
	
	local HP = ply:Health()
	local MAXHP = ply:GetMaxHealth()
	local ARMOR = ply:Armor()
	
	local tex_b_left = surface.GetTextureID("survivalist_3/hud/left_bottom_panel")
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex_b_left )
	surface.DrawTexturedRect( 0 , 0.75 * y, 0.25 * x, 0.25 * y )
	
	//HEALTH
	
	draw.RoundedBox( 4, 0.114 * x , 0.885 * y, math.Clamp(MAXHP * ( 0.00235 * x ) ,0,658), 0.07 * y, Color(30,30,30,255) )
	draw.RoundedBox( 0, 0.114 * x , 0.885 * y, math.Clamp(HP * ( 0.00235 * x ) ,0,658), 0.07 * y, Color( ( math.Clamp(MAXHP,0,255) - math.Clamp(HP,0,255) ) * 2,math.Clamp(HP,0,255) * 1.65,0,255) )
	draw.RoundedBox( 0, 0.114 * x , 0.885 * y, math.Clamp(HP * ( 0.00235 * x ) ,0,658), 0.04 * y, Color(255,255,255,25) )
	draw.RoundedBox( 0, 0.114 * x , 0.885 * y, math.Clamp(HP * ( 0.00235 * x ) ,0,658), 0.02 * y, Color( ( math.Clamp(MAXHP,0,255) - math.Clamp(HP,0,255) ) * 2,math.Clamp(HP,0,255) * 1.5,0,25) )
	
	local circle = surface.GetTextureID("survivalist_3/hud/health_circle")
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( circle )
	surface.DrawTexturedRect( 0.015 * x, 0.87 * y, 0.1 * x, 0.1 * y )
	
	local cross = surface.GetTextureID("survivalist_3/hud/health_cross")
	surface.SetDrawColor( ( math.Clamp(MAXHP,0,255) - math.Clamp(HP,0,255) ) * 2, math.Clamp(HP,0,255) * 1.65, 0 , 255 )
	surface.SetTexture( cross )
	surface.DrawTexturedRect( 0.033 * x, 0.887 * y, 0.065 * x, 0.065 * y )
	
	draw.SimpleText( HP, "HUDHealth", 0.065 * x, 0.917 * y, Color(255,255,255), 1, 1 )

	//ARMOR
		
	draw.RoundedBox( 4, 0.114 * x , 0.822 * y, 0.235 * x, 0.039 * y, Color(30,30,30,255) )
	draw.RoundedBox( 0, 0.114 * x , 0.822 * y, math.Clamp(ARMOR,0,100) * ( 0.00235 * x ), 0.039 * y, Color(85,85,255,255) )
	draw.RoundedBox( 0, 0.114 * x , 0.822 * y, math.Clamp(ARMOR,0,100) * ( 0.00235 * x ), 0.018 * y, Color(255,255,255,25) )
	draw.RoundedBox( 0, 0.114 * x , 0.822 * y, math.Clamp(ARMOR,0,100) * ( 0.00235 * x ), 0.008 * y, Color(85,85,255,25) )
	
	local circle = surface.GetTextureID("survivalist_3/hud/health_circle")
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( circle )
	surface.DrawTexturedRect( 0.06 * x, 0.815 * y, 0.055 * x, 0.055 * y )
	
	local battery = surface.GetTextureID("survivalist_3/hud/battery")
	surface.SetDrawColor( 85, 85, ( math.Clamp(ARMOR,0,100) * 1.7 ) + 85, 255 )
	surface.SetTexture( battery )
	surface.DrawTexturedRect( 0.079 * x, 0.825 * y, 0.019 * x, 0.035 * y )
	
	draw.SimpleText( ARMOR, "HUDArmor", 0.086 * x, 0.838 * y, Color(255,255,255), 1, 1 )
	
	//WEAPONS
	
	local tex_b_right = surface.GetTextureID("survivalist_3/hud/right_bottom_panel")
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex_b_right )
	surface.DrawTexturedRect( 0.75 * x, 0.75 * y, 0.25 * x, 0.25 * y )
	
	NoClipWeapons = {
		
		"weapon_sv_crowbar",
		"weapon_sv_shovel",
		"weapon_sv_sledge",
		"weapon_sv_tool_pammo",
		"weapon_sv_tool_sammo",
		"weapon_sv_tool_armor",
		"weapon_sv_tool_healthkit",
		
	}
	
	if ply:GetActiveWeapon():IsValid() and !table.HasValue( NoClipWeapons, ply:GetActiveWeapon():GetClass() ) then
	
	draw.SimpleText( math.Clamp( ply:GetActiveWeapon():Clip1(), 0, 999 ), "HUDAmmo", 0.85 * x, 0.917 * y, Color(255,255,255), 1, 1 )
	
	draw.SimpleText( "|" , "HUDAmmo", 0.895 * x, 0.917 * y, Color(255,255,255), 1, 1 )
	
	draw.SimpleText( ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() ), "HUDSecondaryAmmo", 0.935 * x, 0.92 * y, Color(255,255,255), 1, 1 )
	
	end
	
	if LocalPlayer():GetEyeTrace().Entity:IsPlayer() then
	
	local PlayerHealth = LocalPlayer():GetEyeTrace().Entity:Health()
	local PlayerMaxHealth = LocalPlayer():GetEyeTrace().Entity:GetMaxHealth()
	local PlayerNick = LocalPlayer():GetEyeTrace().Entity:Nick()
	local PlayerArmor = LocalPlayer():GetEyeTrace().Entity:Armor()
	local width, height = surface.GetTextSize( PlayerNick )
	
	
	local tex_top_hp = surface.GetTextureID("survivalist_3/hud/top_panel")
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex_top_hp )
	surface.DrawTexturedRect( 0.479 * x , 0.55 * y, 0.051 * x, 0.06 * y )
	
	local tex_top_ar = surface.GetTextureID("survivalist_3/hud/top_panel")
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex_top_ar )
	surface.DrawTexturedRect( 0.479 * x , 0.63 * y, 0.051 * x, 0.06 * y )
	
	local circle_hp = surface.GetTextureID("survivalist_3/hud/health_circle")
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetTexture( circle_hp )
	surface.DrawTexturedRect( 0.421 * x, 0.55 * y, 0.06 * x, 0.06 * y )
	
	local circle_ar = surface.GetTextureID("survivalist_3/hud/health_circle")
	surface.SetDrawColor( 200, 200, 200, 255 )
	surface.SetTexture( circle_ar )
	surface.DrawTexturedRect( 0.421 * x, 0.63 * y, 0.06 * x, 0.06 * y )
	
	local cross = surface.GetTextureID("survivalist_3/hud/health_cross")
	surface.SetDrawColor( ( math.Clamp(PlayerMaxHealth,0,255) - math.Clamp(PlayerHealth,0,255) ) * 2, math.Clamp(PlayerHealth,0,255) * 1.65, 0 , 255 )
	surface.SetTexture( cross )
	surface.DrawTexturedRect( 0.43 * x, 0.56 * y, 0.04 * x, 0.04 * y )
	
	local battery = surface.GetTextureID("survivalist_3/hud/battery")
	surface.SetDrawColor( 85, 85, ( math.Clamp(PlayerArmor,0,100) * 1.7 ) + 85, 255 )
	surface.SetTexture( battery )
	surface.DrawTexturedRect( 0.44 * x, 0.64 * y, 0.02 * x, 0.04 * y )
	
	draw.SimpleText( PlayerHealth, "HUDName", 0.505 * x, 0.58 * y, Color(255,255,255), 1, 1 )
	
	draw.SimpleText( PlayerArmor, "HUDName", 0.505 * x, 0.66 * y, Color(255,255,255), 1, 1 )
	
	draw.SimpleText( PlayerNick, "HUDName", 0.5 * x, 0.5 * y, Color(255,255,255), 1, 1 )
	
	end
	
end

net.Receive( "player_death", function()

	DeathTime = net.ReadFloat()
	CurrentTime = net.ReadFloat()

end )
--▲--▲--▲--▲--▲--▲--▲--▲--▲--▲--▲--▲--▲

function GM:HUDDrawTargetID()
end

function GM:HUDAmmoPickedUp( itemName, amount )
end

function GM:HUDItemPickedUp( itemName )
end

function GM:HUDDrawPickupHistory()
end

function GM:HUDWeaponPickedUp( weapon )
end


//----------------------------------------------------//

function CurWep()

	local ply = LocalPlayer()
	
	for k, v in pairs( valid_weapons ) do
	
		if ply:GetActiveWeapon() == v then
		
			return k
		
		end
	
	end
	
end


function NoWep( class )

	local no_weapons = { "weapon_healhands", }
	
	if table.HasValue( no_weapons, class ) then
	
		return true
	
	end
	
	return false

end


function GM:PlayerBindPress( ply, bind, pressed )

	if IsValid( ply ) and IsValid( ply:GetActiveWeapon() ) and table.HasValue( valid_weapons, ply:GetActiveWeapon() ) then
	
		local function Slot( slot )
		
			if #valid_weapons < slot then return end
		
			if !WeaponSelectionSelected then
			
				WeaponSelectionSelected = CurWep()
				
			end
		
			WeaponSelecting = true
			WeaponSelectionSelected = slot
		
			if WeaponSelectionSelected == CurWep() then
				
				WeaponSelecting = false
				
			end
		
		end

		if bind == "slot1" then Slot( 1 ) end
		if bind == "slot2" then Slot( 2 ) end
		if bind == "slot3" then Slot( 3 ) end
		if bind == "slot4" then Slot( 4 ) end
		if bind == "slot5" then Slot( 5 ) end
		if bind == "slot6" then Slot( 6 ) end

		if bind == "invprev" then
			
			if !WeaponSelectionSelected then
			
				WeaponSelectionSelected = CurWep()
				
			end
			
			WeaponSelecting = true
			WeaponSelectionSelected = WeaponSelectionSelected - 1
			if WeaponSelectionSelected < 1 then
				WeaponSelectionSelected = #valid_weapons
			end
			
			/*if NoWep( ply:GetWeapons()[WeaponSelectionSelected]:GetClass() ) then
			
				WeaponSelectionSelected = WeaponSelectionSelected - 1
				
				if WeaponSelectionSelected < 1 then
					WeaponSelectionSelected = #ply:GetWeapons()
				end
			
			end*/
			
			if WeaponSelectionSelected == CurWep() then
				
				WeaponSelecting = false
				
			end
			
		end
			
		if bind == "invnext" then
		
			if !WeaponSelectionSelected then
			
				WeaponSelectionSelected = CurWep()
				
			end
		
			WeaponSelecting = true
			WeaponSelectionSelected = WeaponSelectionSelected + 1
			if WeaponSelectionSelected > #valid_weapons then
				WeaponSelectionSelected = 1
			end
			
			/*if NoWep( ply:GetWeapons()[WeaponSelectionSelected]:GetClass() ) then
			
				WeaponSelectionSelected = WeaponSelectionSelected + 1
				
				if WeaponSelectionSelected > #ply:GetWeapons() then
					WeaponSelectionSelected = 1
				end
			
			end*/
			
			if WeaponSelectionSelected == CurWep() then
			
				WeaponSelecting = false
			
			end
			
		end
		
		if bind == '+attack' and ( WeaponSelecting ) then
		
		if IsValid( valid_weapons[WeaponSelectionSelected] ) then
			RunConsoleCommand( "use", valid_weapons[WeaponSelectionSelected]:GetClass() )
			WeaponSelecting = false
			return true
		end	
		
		end

		/*if ( string.find( bind, "invprev" ) ) then
		
		net.Start("nextwep")
		net.SendToServer()
		
		end
		
		if ( string.find( bind, "invnext" ) ) then
		
		net.Start("prevwep")
		net.SendToServer()
		
		end*/
		
		if bind == "+menu_context" and ply:HasWeapon( "weapon_healhands" ) then
		
			RunConsoleCommand( "use", "weapon_healhands" )
			WeaponSelecting = false
			return true
			
		end
	
	else
	
		WeaponSelectionSelected = nil
		WeaponSelecting = false
	
	end

end

function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end

function SpawnMenu()

		local x, y = ScrW(), ScrH()
		ClassSelect = 1
		PrimaryWeaponSelect = 1
		SecondaryWeaponSelect = 1
		MeleeWeaponSelect = 1
		

		local frame = vgui.Create( "DFrame" )
		frame:SetPos( 0.1 * x, 0.1 * y )
		frame:SetSize( 0.8 * x, 0.8 * y )
		frame:SetTitle( "" )
		frame:SetVisible( true )
		frame:SetDraggable( true )
		frame:ShowCloseButton( true )
		frame:MakePopup()
		function frame:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128 ) )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		local img = vgui.Create( "DImage", frame )
		img:SetPos( 0.5 * frame:GetWide(), 0.5 * frame:GetTall() )
		img:SetSize( 0.5 * frame:GetWide(), 0.5 * frame:GetTall() )	
		
		
		//---------------------------CLASSES---------------------------//
		
		local button_1 = vgui.Create( "DButton" )
		button_1:SetParent( frame )
		button_1:SetPos( 0.1 * frame:GetWide(), 0.1 * frame:GetTall() )
		button_1:SetSize( 0.2 * frame:GetWide(), 0.2 * frame:GetTall() )
		button_1:SetText( "" )
		button_1.DoClick = function()
			
			ClassSelect = 1
			
		end
		function button_1:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Supplier", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		local button_2 = vgui.Create( "DButton" )
		button_2:SetParent( frame )
		button_2:SetPos( 0.5 * frame:GetWide(), 0.5 * frame:GetTall() )
		button_2:SetSize( 0.2 * frame:GetWide(), 0.2 * frame:GetTall() )
		button_2:SetText( "" )
		button_2.DoClick = function()
			
			ClassSelect = 2
			
		end
		function button_2:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Combat Medic", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		
		//---------------------------PRIMARIES---------------------------//
		
		local button_primary_weapon_1 = vgui.Create( "DButton" )
		button_primary_weapon_1:SetParent( frame )
		button_primary_weapon_1:SetPos( 0.3 * frame:GetWide(), 0.2 * frame:GetTall() )
		button_primary_weapon_1:SetSize( 0.1 * frame:GetWide(), 0.1 * frame:GetTall() )
		button_primary_weapon_1:SetText( "" )
		button_primary_weapon_1.DoClick = function()
			
			PrimaryWeaponSelect = 1
			
		end
		function button_primary_weapon_1:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Primary", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		-------------------------------------------------------------------
		
		local button_primary_weapon_2 = vgui.Create( "DButton" )
		button_primary_weapon_2:SetParent( frame )
		button_primary_weapon_2:SetPos( 0.3 * frame:GetWide(), 0.3 * frame:GetTall() )
		button_primary_weapon_2:SetSize( 0.1 * frame:GetWide(), 0.1 * frame:GetTall() )
		button_primary_weapon_2:SetText( "" )
		button_primary_weapon_2.DoClick = function()
			
			PrimaryWeaponSelect = 2
			
		end
		function button_primary_weapon_2:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Primary2", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		
		//---------------------------SECONDARIES---------------------------//
		
		local button_secondary_weapon_1 = vgui.Create( "DButton" )
		button_secondary_weapon_1:SetParent( frame )
		button_secondary_weapon_1:SetPos( 0.3 * frame:GetWide(), 0.4 * frame:GetTall() )
		button_secondary_weapon_1:SetSize( 0.1 * frame:GetWide(), 0.1 * frame:GetTall() )
		button_secondary_weapon_1:SetText( "" )
		button_secondary_weapon_1.DoClick = function()
			
			SecondaryWeaponSelect = 1
			
		end
		function button_secondary_weapon_1:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Secondary", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		-------------------------------------------------------------------
		
		local button_secondary_weapon_2 = vgui.Create( "DButton" )
		button_secondary_weapon_2:SetParent( frame )
		button_secondary_weapon_2:SetPos( 0.3 * frame:GetWide(), 0.5 * frame:GetTall() )
		button_secondary_weapon_2:SetSize( 0.1 * frame:GetWide(), 0.1 * frame:GetTall() )
		button_secondary_weapon_2:SetText( "" )
		button_secondary_weapon_2.DoClick = function()
			
			SecondaryWeaponSelect = 2
			
		end
		function button_secondary_weapon_2:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Secondary2", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		
		//---------------------------MELEES---------------------------//
		
		local button_melee_weapon_1 = vgui.Create( "DButton" )
		button_melee_weapon_1:SetParent( frame )
		button_melee_weapon_1:SetPos( 0.3 * frame:GetWide(), 0.6 * frame:GetTall() )
		button_melee_weapon_1:SetSize( 0.1 * frame:GetWide(), 0.1 * frame:GetTall() )
		button_melee_weapon_1:SetText( "" )
		button_melee_weapon_1.DoClick = function()
			
			MeleeWeaponSelect = 1
			
		end
		function button_melee_weapon_1:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Melee", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		-------------------------------------------------------------------
		
		local button_melee_weapon_2 = vgui.Create( "DButton" )
		button_melee_weapon_2:SetParent( frame )
		button_melee_weapon_2:SetPos( 0.3 * frame:GetWide(), 0.7 * frame:GetTall() )
		button_melee_weapon_2:SetSize( 0.1 * frame:GetWide(), 0.1 * frame:GetTall() )
		button_melee_weapon_2:SetText( "" )
		button_melee_weapon_2.DoClick = function()
			
			MeleeWeaponSelect = 2
			
		end
		function button_melee_weapon_2:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 85, 85, 255, 255 ) )
			draw.SimpleText( "Melee2", CenterPrintText, w / 2, h / 2, Color(255,255,255), 1, 1 )
			surface.SetDrawColor( 0, 0, 0 )
			surface.DrawOutlinedRect( 4, 4, w-8, h-8 )
			surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
		end
		
		
		//---------------------------SPAWN---------------------------//
		
		local button_spawn = vgui.Create( "DButton", frame )
		button_spawn:SetPos( 0.5 * frame:GetWide(), 0.8 * frame:GetTall() )
		button_spawn:SetSize( 0.2 * frame:GetWide(), 0.2 * frame:GetTall() )
		button_spawn:SetText( "Spawn" )
		button_spawn.DoClick = function()
		
			net.Start("player_spawn_class")
				net.WriteFloat( ClassSelect )
				net.WriteFloat( MeleeWeaponSelect )
				net.WriteFloat( SecondaryWeaponSelect )
				net.WriteFloat( PrimaryWeaponSelect )
			net.SendToServer()
			frame:Close()
		
		end

end

net.Receive( "Spawn_Menu", SpawnMenu )

