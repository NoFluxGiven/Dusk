faust_netherglyph = class({})

LinkLuaModifier("modifier_netherglyph","lua/abilities/faust_netherglyph",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_netherglyph_buff","lua/abilities/faust_netherglyph",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_netherglyph_remove","lua/abilities/faust_netherglyph",LUA_MODIFIER_MOTION_NONE)

function faust_netherglyph:OnUpgrade()
	local caster = self:GetCaster()

	local ab1 = caster:FindAbilityByName("faust_planecracker")
	--local ab2 = caster:FindAbilityByName("faust_photonic_barrier")

	ab1:SetLevel(self:GetLevel())
	ab1:SetActivated(false)
end

function faust_netherglyph:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	local radius = self:GetSpecialValueFor("radius")
	local cooldown_reduction = self:GetSpecialValueFor("cooldown_reduction")
	local spell_amp = self:GetSpecialValueFor("spell_amp")

	local thinker = CreateModifierThinker( caster, self, "modifier_netherglyph",
	{Duration=duration+0.25}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)

end

modifier_netherglyph = class({})

function modifier_netherglyph:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)

		local radius = self:GetAbility():GetSpecialValueFor("radius")

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faust/netherglyph.vpcf", PATTACH_WORLDORIGIN, nil)

		ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 1, Vector(radius,0,0))
	end
end

function modifier_netherglyph:OnIntervalThink()
	if IsServer() then

		local caster = self:GetAbility():GetCaster()

		local radius = self:GetAbility():GetSpecialValueFor("radius")
		local timeout = self:GetAbility():GetSpecialValueFor("timeout")

		local is_within = self:GetParent():GetRangeToUnit(caster) <= radius and caster:IsAlive()

		local ab1 = caster:FindAbilityByName("faust_planecracker")

		if is_within then
			
			--local ab2 = caster:FindAbilityByName("faust_photonic_barrier")
			caster:AddNewModifier(caster, self:GetAbility(), "modifier_netherglyph_buff", {})
			caster:RemoveModifierByName("modifier_netherglyph_remove")
			ab1:SetActivated(true)
			-- ab2:SetActivated(true)
		else
			caster:RemoveModifierByName("modifier_netherglyph_buff")
			ab1:SetActivated(false)
			-- ab2:SetActivated(false)

			if not caster:HasModifier("modifier_netherglyph_remove") and caster:IsAlive() then
				local mod = caster:AddNewModifier(caster, self:GetAbility(), "modifier_netherglyph_remove", {Duration=timeout})
				mod.netherglyph_thinker = self
			end
		end

	end
end

function modifier_netherglyph:OnDestroy()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local ab1 = caster:FindAbilityByName("faust_planecracker")

		ParticleManager:DestroyParticle(self.particle,false)
		
		caster:RemoveModifierByName("modifier_netherglyph_buff")
		if caster:HasModifier("modifier_netherglyph_remove") then
			caster:RemoveModifierByName("modifier_netherglyph_remove")
		end
		ab1:SetActivated(false)
		-- ab2:SetActivated(false)
	end
end

modifier_netherglyph_buff = class({})

function modifier_netherglyph_buff:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
	return func
end

function modifier_netherglyph_buff:GetModifierPercentageCooldownStacking()
	return self:GetAbility():GetSpecialValueFor("cooldown_reduction")
end

function modifier_netherglyph_buff:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_netherglyph_buff:GetModifierIncomingDamage_Percentage()
	return -self:GetAbility():GetSpecialValueFor("incoming_damage_reduction")
end

function modifier_netherglyph_buff:GetModifierConstantManaRegen()
	return -self:GetAbility():GetSpecialValueFor("mana_regen")
end



function modifier_netherglyph_buff:GetEffectName()
	return "particles/units/heroes/hero_faust/forbidden_knowledge_deprecated_on_attack_buff.vpcf"
end

modifier_netherglyph_remove = class({})

function modifier_netherglyph_remove:OnDestroy()
	if IsServer() then
		if not self:WasPurged() then
			self.netherglyph_thinker:Destroy()
		end
	end
end

function modifier_netherglyph_remove:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_netherglyph_remove:IsDebuff()
	return true
end

function modifier_netherglyph_remove:IsPurgable()
	return false
end