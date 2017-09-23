timekeeper_chronoshift_end = class({})

function timekeeper_chronoshift_end:OnSpellStart()
	local mod,ab,target
	local delay = self:GetSpecialValueFor("delay")

	mod = self.chronoshift_modifier
	ab = self.chronoshift_ability
	target = self.chronoshift_target

	self:StartCooldown(delay+0.2)

	if mod and ab and target then
		local chronomod = target:AddNewModifier(self:GetCaster(), ab, "modifier_chronoshift_end", {Duration=delay}) --[[Returns:void
		No Description Set
		]]
		chronomod.chronoshift_link = mod
		mod:SetDuration(mod:GetDuration()+delay+0.1,true)
	end
end