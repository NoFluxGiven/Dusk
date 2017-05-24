rai_amplify = class({})

LinkLuaModifier("modifier_amplify","lua/abilities/rai_amplify",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_amplify_slow","lua/abilities/rai_amplify",LUA_MODIFIER_MOTION_NONE)

function rai_amplify:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_amplify", {Duration=self:GetSpecialValueFor("duration")}) --[[Returns:void
	No Description Set
	]]

	-- Particle effects
end

modifier_amplify = class({})

function modifier_amplify:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.25)

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/rai_amplify2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControl(p, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"),0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		self:AddParticle( p, false, false, 10, false, false )

		self:GetParent():EmitSound("Hero_Disruptor.KineticField.Pinfold")
	end
end

function modifier_amplify:OnIntervalThink()
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local damage = self:GetAbility():GetSpecialValueFor("damage")

		local t = FindEnemies(self:GetParent(),self:GetParent():GetAbsOrigin(),radius)

		for k,v in pairs(t) do
			DealDamage(v,self:GetParent(),damage*0.25,DAMAGE_TYPE_MAGICAL)
			-- Particle effects
		end
	end
end

function modifier_amplify:OnDestroy()
	if IsServer() then
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local edamage = self:GetAbility():GetSpecialValueFor("end_damage")
		local bonus = 0
		local etargets = self:GetAbility():GetSpecialValueFor("targets")

		if self:GetAbility():GetCaster():GetHasTalent("special_bonus_rai_amplify") then bonus = 80 end

		edamage = edamage+bonus

		local t = FindEnemies(self:GetParent(),self:GetParent():GetAbsOrigin(),radius)

		local tsize = #t

		if etargets > tsize then etargets = tsize end

		print(tsize)

		local tfin = {}

		for i=1,etargets do
			local tsize = #t
			local r = RandomInt(1,tsize)
			table.insert(tfin,t[r])
			table.remove(t,r)
		end

		print("Targets: "..#tfin.."/"..tsize.."(Max "..etargets.." Targets)")

		local a = self:GetAbility()
		local d = self:GetAbility():GetSpecialValueFor("slow_duration")
		local c = self:GetParent()

		for k,v in pairs(tfin) do
			local r = RandomFloat(0.0, 0.1) --[[Returns:float
			Get a random ''float'' within a range
			]]
			local t = 0.1*(k-1) + r
			Timers:CreateTimer(t,function()
				DealDamage(v,c,edamage,DAMAGE_TYPE_MAGICAL)
				v:AddNewModifier(c, a, "modifier_amplify_slow", {Duration=d}) --[[Returns:void
				No Description Set
				]]
				v:EmitSound("Hero_Zuus.Righteous.Layer")
				v:EmitSound("Hero_Zuus.ArcLightning.Cast")
				local p = ParticleManager:CreateParticle("particles/units/heroes/hero_rai/amplify_end.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, c)
				ParticleManager:SetParticleControlEnt(p,0,c,PATTACH_POINT_FOLLOW,"attach_hitloc",c:GetCenter(),true)
				ParticleManager:SetParticleControlEnt(p,1,v,PATTACH_POINT_FOLLOW,"attach_hitloc",v:GetCenter(),true)
			end)
			-- ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,100)) --[[Returns:void
			-- Set the control point data for a control on a particle effect
			-- ]]
			-- ParticleManager:SetParticleControl(p, 1, v:GetAbsOrigin()+Vector(0,0,100)) --[[Returns:void
			-- Set the control point data for a control on a particle effect
			-- ]]
		end
	end
end

modifier_amplify_slow = class({})

function modifier_amplify_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_amplify_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_amplify_slow:GetEffectName()
	return "particles/units/heroes/hero_rai/amplify_slow.vpcf"
end