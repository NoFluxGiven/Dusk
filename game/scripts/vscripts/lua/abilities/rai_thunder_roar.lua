rai_thunder_roar = class({})

LinkLuaModifier("modifier_thunder_roar","lua/abilities/rai_thunder_roar",LUA_MODIFIER_MOTION_NONE)

function rai_thunder_roar:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_thunder_roar", {Duration=self:GetSpecialValueFor("duration")}) --[[Returns:void
	No Description Set
	]]
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_thunder_roar_inc", {Duration=self:GetSpecialValueFor("duration")})

	-- Particle effects
end

modifier_thunder_roar = class({})

function modifier_thunder_roar:OnCreated()
	if IsServer() then
		local bolts = self:GetAbility():GetSpecialValueFor("bolts")
		local duration = self:GetAbility():GetSpecialValueFor("duration")

		-- local t_bolts_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_rai_5") or 0

		bolts = bolts

		local amt = duration/bolts

		local n = 0

		self:StartIntervalThink(amt)
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
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local bolt_radius = self:GetAbility():GetSpecialValueFor("bolt_radius")
		local t_stun_bonus = self:GetParent():FetchTalent("special_bonus_rai_5") or 0
		local ministun = self:GetAbility():GetSpecialValueFor("ministun") + t_stun_bonus

		if bolt_radius == 0 then bolt_radius = 225 end

		local loc = self:GetParent():GetAbsOrigin()

		local t = FindEnemiesRandom(self:GetParent(),loc,radius)

		ToolsPrint(#t)

		for k,vv in pairs(t) do
			if vv then
				ToolsPrint(k..": "..vv:GetName())
			else
				ToolsPrint(k..": NIL")
			end
		end

		local v = t[1]

		if not v then return end

		local vloc = v:GetAbsOrigin()

		self:GetAbility():InflictDamage(v,self:GetParent(),damage,DAMAGE_TYPE_MAGICAL)
		v:AddNewModifier(self:GetParent(), nil, "modifier_stunned", {Duration=ministun})

		v:EmitSound("Hero_Zuus.LightningBolt.Righteous") --[[Returns:void
		 
		]]

		local t2 = FindEnemies(self:GetParent(),vloc,bolt_radius)

		for k,vvv in pairs(t2) do
			if vvv ~= v then
				self:GetAbility():InflictDamage(vvv,self:GetParent(),damage*0.5,DAMAGE_TYPE_MAGICAL)
			end
		end

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/thunder_roar_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
		ParticleManager:SetParticleControl(p, 0, v:GetAbsOrigin()+Vector(0,0,100)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
		ParticleManager:SetParticleControl(p, 1, v:GetAbsOrigin()+Vector(0,0,1200)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]
	end
end