ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "Police Wing - Large"
ENT.Author			= "Paradukes + SlyFo"
ENT.Category		= "SBEP - Other"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true


function ENT:SetActive( val )
	self:SetNetworkedBool("ClTracking",val,true)
end

function ENT:GetActive()
	return self:GetNetworkedBool("ClTracking")
end