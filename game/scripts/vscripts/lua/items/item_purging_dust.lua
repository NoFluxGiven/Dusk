item_purging_dust = class({})

function item_purging_dust:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCaster()

	-- if caster:GetTeam() == target:GetTeam() then

	caster:Purge(false,true,false,false,false)

	-- else

		-- target:Purge(true,false,false,false,false)

	-- end

	self:SetCurrentCharges(self:GetCurrentCharges()-1) --[[Returns:void
	Set the number of charges on this item
	]]

	self:StartCooldown(self:GetCooldown(self:GetLevel()))

	ParticleManager:CreateParticle("particles/items/purging_dust.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster) --[[Returns:int
	Creates a new particle effect
	]]

	caster:EmitSound("PurgingDust")

	if self:GetCurrentCharges() <= 0 then
		self:RemoveSelf()
	end
end