
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self:SetModel( "models/jaanus/wiretool/wiretool_range.mdl" ) 
	self:SetName("Flare Launcher")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.Inputs = Wire_CreateInputs( self, { "Launch" } )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end

    	self:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self:GetPhysicsObject()


end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "FlareLauncher" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:TriggerInput(iname, value)

	if (iname == "Launch") then
		if (value > 0) then
			local Flare = ents.Create( "prop_physics" )
			if ( !Flare:IsValid() ) then return end
			Flare:SetModel( "models/Slyfo_2/acc_food_stridernugsml.mdl" )
			Flare:SetPos( self:GetPos() + (self:GetUp() * 5) )
			Flare:SetAngles( self:GetAngles() )
			Flare.Flare = true
			Flare:Spawn()
			Flare:Activate()
			Flare:SetColor(Color( 0,0,0,1 ))
			local phys = Flare:GetPhysicsObject()
			phys:EnableGravity(true)
			phys:EnableDrag(true)
			phys:EnableCollisions(true)
			Flare:Fire("kill","",5)
			phys:SetVelocity( self:GetUp() * 1500 )
			
			FlareTrail = ents.Create("env_flare")
			FlareTrail:SetAngles( Flare.Entity:GetAngles()  )
			FlareTrail:SetPos( Flare.Entity:GetPos() )
			FlareTrail:SetParent( Flare.Entity )
			FlareTrail:Spawn()
			FlareTrail:Activate()
			
			local Contact = SBEP_S.AddContact( Flare, 15000, 1 )
			Contact.FadeRate = 200
		end
	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
	if (self.Launched == 1) then
		local Flare = ents.Create( "prop_physics" )
		if ( !Flare:IsValid() ) then return end
		Flare:SetModel( "models/Slyfo_2/acc_food_stridernugsml.mdl" )
		Flare:SetPos( self:GetPos() + (self:GetUp() * 5) )
		Flare:SetAngles( self:GetAngles() )
		Flare.Flare = true
		Flare:Spawn()
		Flare:Activate()
		Flare:SetColor(Color( 0,0,0,1 ))
		local phys = Flare:GetPhysicsObject()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
		Flare:Fire("kill","",5)
		phys:SetVelocity( self:GetUp() * 500 )
		
		FlareTrail = ents.Create("env_flare")
		FlareTrail:SetAngles( Flare.Entity:GetAngles()  )
		FlareTrail:SetPos( Flare.Entity:GetPos() )
		FlareTrail:SetParent( Flare.Entity )
		FlareTrail:Spawn()
		FlareTrail:Activate()
		
		local Contact = SBEP_S.AddContact( Flare, 1000, 1 )
		Contact.FadeRate = 200
		
		
		self.Launched = 2
	end
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Use( activator, caller )

end