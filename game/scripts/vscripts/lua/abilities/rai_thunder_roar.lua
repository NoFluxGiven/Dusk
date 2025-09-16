rai_thunder_roar = class({})

LinkLuaModifier("modifier_thunder_roar","lua/abilities/rai_thunder_roar",LUA_MODIFIER_MOTION_NONE)

function rai_thunder_roar:OnAbilityPhaseStart()
	local pos = self:GetCaster():GetAbsOrigin()
	self.thunder_roar_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/thunder_roar_start_up.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.thunder_roar_particle, 0, pos)
	return true
end

function rai_thunder_roar:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.thunder_roar_particle, false)
end

function rai_thunder_roar:OnSpellStart()
	ParticleManager:DestroyParticle(self.thunder_roar_particle, false)

	Timers:CreateTimer(0.03,function()
		self:FireBolt(true)
	end)
end

function rai_thunder_roar:FireBolt(fire_at_parent_origin)
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Righteous")

	self:GetCaster():AddNewModifier(caster, self, "modifier_thunder_roar", {duration=duration})

	self:GetCaster():GetAbilityCount()

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/thunder_roar_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(p, 0, self:GetCaster():GetAbsOrigin()+Vector(0,0,1200))
	ParticleManager:SetParticleControl(p, 1, self:GetCaster():GetAbsOrigin()+Vector(0,0,100))
end

modifier_thunder_roar = class({})

function modifier_thunder_roar:OnCreated()
	self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.stacks = self:GetAbility():GetSpecialValueFor("stacks")

	self:SetStackCount(self.stacks)
end

function modifier_thunder_roar:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_thunder_roar:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

function modifier_thunder_roar:OnAbilityFullyCast(event)
	if (event.unit ~= self:GetParent()) then return end

	if (event.ability:IsItem()) then return end

	if (self:GetStackCount() <= 0) then return end

	self:DecrementStackCount()

	if (self:GetStackCount() <= 0) then
		self:SetDuration(3.5, true)
	end

	event.ability:EndCooldown()
	event.ability:StartCooldown( 0.25 )
	-- event.ability:StartCooldown( event.ability:GetCooldown( event.ability:GetLevel() ) * (1 - self.cooldown_reduction/100) )

	local static_blade = self:GetParent():FindAbilityByName("rai_static_blade")

	local en = FindEnemies(self:GetParent(), self:GetParent():GetAbsOrigin(), self.radius, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC)

	for k,v in pairs(en) do
		static_blade:Proc( v, false )
	end
end