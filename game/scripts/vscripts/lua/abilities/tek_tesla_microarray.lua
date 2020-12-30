tek_tesla_microarray = class({})

LinkLuaModifier("modifier_tesla","lua/abilities/tek_tesla_microarray",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tesla_debuff","lua/abilities/tek_tesla_microarray",LUA_MODIFIER_MOTION_NONE)

function tek_tesla_microarray:OnSpellStart()
	local caster = self:GetCaster()
	local charget = self:GetSpecialValueFor("chargetime")

	caster:EmitSound("Hero_Invoker.EMP.Charge")

	caster:AddNewModifier(caster, self, "modifier_tesla", {Duration=charget}) --[[Returns:void
	No Description Set
	]]
end

modifier_tesla = class({})

function modifier_tesla:GetEffectName()
	return "particles/units/heroes/hero_tek/ftl_microarray_zaps.vpcf"
end

function modifier_tesla:OnCreated()
	if IsServer() then
		self:GetParent():Hold()
	end
end

function modifier_tesla:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local damage = self:GetAbility():GetSpecialValueFor("damage")

		local stun = self:GetAbility():GetSpecialValueFor("stun")
		local mana_drain = self:GetAbility():GetSpecialValueFor("mana_drain")

		local enemy = FindEnemies(caster, caster:GetAbsOrigin(), radius)

		caster:EmitSound("Hero_Invoker.EMP.Discharge")

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_tek/ftl_microarray_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))

		caster:AddNewModifier(caster, nil, "modifier_stunned", {Duration=0.25})

		for k,v in pairs(enemy) do
			local vdamage = damage
			--if v:IsStunned() then vdamage = vdamage * 2 end

			local mana_drain_amount = v:GetMana() * (mana_drain/100)

			self:GetAbility():InflictDamage(v,caster,vdamage,DAMAGE_TYPE_MAGICAL)
			v:AddNewModifier(caster, self:GetAbility(), "modifier_tesla_debuff", {Duration=stun})
			v:ReduceMana(mana_drain_amount)
			v:EmitSound("Hero_Invoker.SunStrike.Ignite.Apex")
			caster:GiveMana(mana_drain_amount)
		end
	end
end

function modifier_tesla:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
	
	return state
end

modifier_tesla_debuff = class({})

function modifier_tesla_debuff:GetEffectName()
	return "particles/units/heroes/hero_tek/ftl_microarray_unit_stunned.vpcf"
end

function modifier_tesla_debuff:OnCreated()
	if IsServer() then
		local p = self:GetParent()
		self:StartIntervalThink(0.05)
		self.tesla_pfvi = Vector(0.2,0,0)
		self.tesla_fvec = p:GetForwardVector()
	end
end

function modifier_tesla_debuff:OnIntervalThink()
	if IsServer() then
		local p = self:GetParent()

		self.tesla_pfvi = -self.tesla_pfvi

		p:SetForwardVector(self.tesla_fvec+self.tesla_pfvi)
	end
end

function modifier_tesla_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end