rai_thunder_roar = class({})

LinkLuaModifier("modifier_thunder_roar","lua/abilities/rai_thunder_roar",LUA_MODIFIER_MOTION_NONE)

function rai_thunder_roar:OnAbilityPhaseStart()
	local pos = self:GetCursorPosition()
	self.thunder_roar_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/thunder_roar_start_up.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.thunder_roar_particle, 0, pos)

	--sound

	return true
end

function rai_thunder_roar:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.thunder_roar_particle, false)
end

function rai_thunder_roar:OnSpellStart()

	ParticleManager:DestroyParticle(self.thunder_roar_particle, false)

	local pos = self:GetCursorPosition()

	self:FireBolt(true)

	FindClearSpaceForUnit(self:GetCaster(), pos, true)

	Timers:CreateTimer(0.03,function()
		self:FireBolt(true)
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_thunder_roar", {Duration=1})
	end)
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_thunder_roar_inc", {Duration=self:GetSpecialValueFor("duration")})

	-- Particle effects
end

function rai_thunder_roar:FireBolt(fire_at_parent_origin)
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local bolt_radius = self:GetSpecialValueFor("bolt_radius")
	local t_stun_bonus = self:GetCaster():FindTalentValue("special_bonus_rai_5") or 0
	local ministun = self:GetSpecialValueFor("stun") + t_stun_bonus

	loc = self:GetCaster():GetAbsOrigin()

	-- local loc = self:GetCaster():GetAbsOrigin() + RandomVector(RandomInt(125,radius))

	-- if fire_at_parent_origin then
	-- 	loc = self:GetCaster():GetAbsOrigin()
	-- end

	-- self:InflictDamage(v,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
	-- v:AddNewModifier(self:GetCaster(), nil, "modifier_stunned", {Duration=ministun})

	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Righteous")

	local t = FindEnemies(self:GetCaster(),loc,bolt_radius)

	for k,v in pairs(t) do
		self:InflictDamage(v,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
		-- v:AddNewModifier(self:GetCaster(), self, "modifier_stunned", hModifierTable)
		v:AddSRModifier( self:GetCaster(), self, "modifier_stunned", ministun, nil )
	end

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/thunder_roar_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(p, 0, loc+Vector(0,0,1200)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, loc+Vector(0,0,100)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]
end

modifier_thunder_roar = class({})

function modifier_thunder_roar:OnCreated()
	if IsServer() then
		local bolts = self:GetAbility():GetSpecialValueFor("bolts")
		local duration = self:GetAbility():GetSpecialValueFor("duration")

		-- local t_bolts_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_rai_5") or 0

		--particle

		bolts = bolts

		local amt = duration/bolts

		local n = 0

		self:StartIntervalThink(amt)

		self:GetAbility():FireBolt(true)

		-- local n = 0
		-- repeat
		-- 	self:FireBolt(false)
		-- 	n = n+1
		-- until
		-- 	n > bolts
	end
end

-- function modifier_thunder_roar:OnIntervalThink()
-- 	if IsServer() then
-- 		local radius = self:GetAbility():GetSpecialValueFor("radius")
-- 		local damage = self:GetAbility():GetSpecialValueFor("damage")
-- 		local bradius = self:GetAbility():GetSpecialValueFor("bolt_radius")

-- 		local loc = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(radius/4,radius))

-- 		local t = FindEnemies(self:GetParent(),loc,bradius)

-- 		local unit = FastDummy(loc,self:GetParent():GetTeam(),1,75)

-- 		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/thunder_roar_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
-- 		ParticleManager:SetParticleControl(p, 0, unit:GetAbsOrigin()+Vector(0,0,100)) --[[Returns:void
-- 		Set the control point data for a control on a particle effect
-- 		]]
-- 		ParticleManager:SetParticleControl(p, 1, unit:GetAbsOrigin()+Vector(0,0,1200)) --[[Returns:void
-- 		Set the control point data for a control on a particle effect
-- 		]]

-- 		for k,v in pairs(t) do
-- 			DealDamage(v,self:GetParent(),damage,DAMAGE_TYPE_MAGICAL)
-- 		end
-- 	end
-- end

function modifier_thunder_roar:OnIntervalThink()
	if IsServer() then
		self:GetAbility():FireBolt(false)
	end
end

-- function modifier_thunder_roar:FireBolt(fire_at_parent_origin)
-- 	local radius = self:GetAbility():GetSpecialValueFor("radius")
-- 	local damage = self:GetAbility():GetSpecialValueFor("damage")
-- 	local bolt_radius = self:GetAbility():GetSpecialValueFor("bolt_radius")
-- 	local t_stun_bonus = self:GetParent():FindTalentValue("special_bonus_rai_5") or 0
-- 	local ministun = self:GetAbility():GetSpecialValueFor("ministun") + t_stun_bonus

-- 	if bolt_radius == 0 then bolt_radius = 225 end

-- 	local loc = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(125,radius))

-- 	if fire_at_parent_origin then
-- 		loc = self:GetParent():GetAbsOrigin()
-- 	end

-- 	-- self:GetAbility():InflictDamage(v,self:GetParent(),damage,DAMAGE_TYPE_MAGICAL)
-- 	-- v:AddNewModifier(self:GetParent(), nil, "modifier_stunned", {Duration=ministun})

-- 	self:GetParent():EmitSound("Hero_Zuus.LightningBolt.Righteous") --[[Returns:void
	
-- 	-- ]]

-- 	local t = FindEnemies(self:GetParent(),loc,bolt_radius)

-- 	for k,v in pairs(t) do
-- 		self:GetAbility():InflictDamage(v,self:GetParent(),damage,DAMAGE_TYPE_MAGICAL)
-- 	end

-- 	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/thunder_roar_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
-- 	ParticleManager:SetParticleControl(p, 0, loc+Vector(0,0,100)) --[[Returns:void
-- 	Set the control point data for a control on a particle effect
-- 	]]
-- 	ParticleManager:SetParticleControl(p, 1, loc+Vector(0,0,1200)) --[[Returns:void
-- 	Set the control point data for a control on a particle effect
-- 	]]
-- end