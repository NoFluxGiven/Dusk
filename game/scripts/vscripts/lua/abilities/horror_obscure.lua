horror_obscure = class({})

LinkLuaModifier("modifier_obscure","lua/abilities/horror_obscure",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_obscure_thinker","lua/abilities/horror_obscure",LUA_MODIFIER_MOTION_NONE)

function horror_obscure:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	local r = self:GetSpecialValueFor("radius")
	local d = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")

	local enemies = FindEnemies(caster,target,r)

	CreateModifierThinker( self:GetCaster(), self, "modifier_obscure_thinker", {radius=r}, target, self:GetCaster():GetTeamNumber(), false )

	for k,v in pairs(enemies) do
		self:InflictDamage(v,caster,d,DAMAGE_TYPE_MAGICAL)

		local t_stun = caster:FindTalentValue("special_bonus_horror_3")
		Timers:CreateTimer(0.15,function()
			v:AddNewModifier(caster, self, "modifier_obscure", {Duration=duration})
			if t_stun then
				v:AddNewModifier(caster, nil, "modifier_stunned", {Duration=t_stun})
			end
		end)
	end
end

modifier_obscure = class({})

function modifier_obscure:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
	return func
end

function modifier_obscure:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("miss_chance")
end

function modifier_obscure:CheckState()
	local state = {
		[MODIFIER_STATE_BLIND] = true
	}
	return state
end

modifier_obscure_thinker = class({})

function modifier_obscure_thinker:OnCreated(kv)
	if IsServer() then
		if kv then
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_horror/obscure.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(p, 1, Vector(kv.radius,0,0))
			ParticleManager:ReleaseParticleIndex(p)

			self:GetParent():EmitSound("Hero_Nightstalker.Void")

			UTIL_Remove(self:GetParent())
		end
	end
end