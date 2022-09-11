alexander_lightburst = class({})

LinkLuaModifier("modifier_lightburst","lua/abilities/alexander_lightburst",LUA_MODIFIER_MOTION_NONE)

function alexander_lightburst:OnSpellStart()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local debuff_duration = self:GetSpecialValueFor("debuff_duration")
	local heal = self:GetSpecialValueFor("heal")
	local base_heal = self:GetSpecialValueFor("base_heal")

	local enemies = FindEnemies(self:GetCaster(),self:GetCaster():GetAbsOrigin(),radius)
	local allies = FindAllies(self:GetCaster(),self:GetCaster():GetAbsOrigin(),radius)

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_alexander/lightburst.vpcf", PATTACH_CENTER_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

	self:GetCaster():EmitSound("Alexander.Lightburst")

	for k,v in pairs(allies) do
		local heal_amount = ( (heal / 100) * v:GetMaxHealth() ) + base_heal

		if v == self:GetCaster() then heal_amount = heal_amount*2 end

		v:Heal(heal_amount, self:GetCaster())
	end

	

	for k,v in pairs(enemies) do
		DealDamage(v,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL,self,0)
		v:AddNewModifier(self:GetCaster(), self, "modifier_lightburst", {Duration=debuff_duration})
	end
end

--------------------------------------------------------------------------------------------------------------

modifier_lightburst = class({})

function modifier_lightburst:IsHidden() return false end
function modifier_lightburst:IsPurgable() return true end

function modifier_lightburst:OnCreated(kv)
	self.debuff_damage = self:GetAbility():GetSpecialValueFor("debuff_damage")
	self:StartIntervalThink(1.0)
	self:GetParent():EmitSound("Alexander.Lightburst.Fire")
end

function modifier_lightburst:OnIntervalThink()
	local damage = (self.debuff_damage/100) * self:GetParent():GetMaxHealth()
	if self:GetParent():IsRoshan() then damage = damage / 4 end
	DealDamage(self:GetParent(), self:GetAbility():GetCaster(), damage, DAMAGE_TYPE_MAGICAL, self:GetAbility(), 0)
end

function modifier_lightburst:OnDestroy()
	self:GetParent():StopSound("Alexander.Lightburst.Fire")
end

function modifier_lightburst:GetEffectName()
	return "particles/units/heroes/hero_alexander/lightburst_flames.vpcf"
end
