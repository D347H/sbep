AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
--include('entities/base_wire_entity/init.lua')
include( 'shared.lua' )

function ENT:Initialize()

	self:SetModel( "models/Slyfo/finfunnel.mdl" ) 
	self:SetName("MineLayer")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	if WireAddon then
		self.Inputs = WireLib.CreateInputs( self, { "Fire", "Force", "Homing" } )
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self:SetKeyValue("rendercolor", "255 255 255")
	self.PhysObj = self:GetPhysicsObject()
	
	--self.val1 = 0
	--RD_AddResource(self, "Munitions", 0)
	
	self.MineProof = true
	self.LForce = 0
	
	self.CDL 		= {}
	self.CDL[1] 	= 0
	self.CDL["1r"] 	= true
	self.CDL[2] 	= 0
	self.CDL["2r"] 	= true
	self.CDL[3] 	= 0
	self.CDL["3r"] 	= true
	self.CDL[4] 	= 0
	self.CDL["4r"] 	= true
	self.CDL[5] 	= 0
	self.CDL["5r"] 	= true
	self.CDL[6] 	= 0
	self.CDL["6r"] 	= true
	self:SetNetworkedInt("Shots",6)


end

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16 + Vector( 0,0,30 )
	
	local ent = ents.Create( "SF-MineLayer" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent.SPL = ply
	
	return ent
	
end

function ENT:TriggerInput(iname, value)		
	if (iname == "Fire") then
		if (value > 0) then
			self:HPFire()
		end
	
	elseif (iname == "Force") then
		if (value > 0) then
			self.LForce = value
		end
	
	elseif (iname == "Homing") then
		if (value > 0) then
			self.Homer = true
		else
			self.Homer = false
		end
		
	end
end

function ENT:PhysicsUpdate()

end

function ENT:Think()
	for n = 1, 6 do
		if (CurTime() >= self.CDL[n]) then
			if self.CDL[n.."r"] == false then
				self.CDL[n.."r"] = true
				self:EmitSound("Buttons.snd26")
				self:ShotsAdd(1)
			end
		end
	end
end

function ENT:PhysicsCollide( data, physobj )
	
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:Use( activator, caller )

end

function ENT:Touch( ent )
	if ent.HasHardpoints then
		if ent.Cont and ent.Cont:IsValid() then
			HPLink( ent.Cont, ent.Entity, self ) 
			ent.Cont.MineProof = true
			ent.MineProof = true
		end
	end
end

function ENT:HPFire()
	if (CurTime() >= self.MCDown) then
		for n = 1, 6 do
			if (CurTime() >= self.CDL[n]) then
				self:FFire(n)
				self:ShotsAdd(-1)
				return
			end
		end
	end
end

function ENT:FFire( CCD )
	local NewShell = ents.Create( "SF-SpaceMine" )
	if ( !NewShell:IsValid() ) then return end
	NewShell:SetPos( self:GetPos() + (self:GetUp() * -100) )
	--NewShell:SetAngles( self:GetForward():Angle() )
	NewShell.SPL = self.SPL
	NewShell:Spawn()
	NewShell:Initialize()
	NewShell:Activate()
	NewShell:SetOwner(self)
	NewShell.PhysObj:SetVelocity(self:GetUp() * -self.LForce)
	--NewShell:Fire("kill", "", 30)
	NewShell.ParL = self
	--RD_ConsumeResource(self, "Munitions", 1000)
	self.CDL[CCD] = CurTime() + 6
	self.CDL[CCD.."r"] = false
	self.MCDown = CurTime() + 0.4
	self:EmitSound("Buttons.snd24")
	NewShell:GetPhysicsObject():EnableGravity(false)
	if self.Homer then NewShell.Homer = true end
	
	timer.Simple(5,function() NewShell:Arm() 
	end)	
	--local effectdata = EffectData()
	--effectdata:SetOrigin(self:GetPos() +  self:GetUp() * 14)
	--effectdata:SetStart(self:GetPos() +  self:GetUp() * 14)
	--util.Effect( "Explosion", effectdata )
end

function ENT:PreEntityCopy()
	if WireAddon then
		duplicator.StoreEntityModifier(self,"WireDupeInfo",WireLib.BuildDupeInfo(self))
	end
end

function ENT:PostEntityPaste(ply, ent, createdEnts)
	local emods = ent.EntityMods
	if not emods then return end
	if WireAddon then
		WireLib.ApplyDupeInfo(ply, ent, emods.WireDupeInfo, function(id) return createdEnts[id] end)
	end
	ent.SPL = ply
end