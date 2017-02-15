modifier_divine_armour_lua = class({})

function modifier_divine_armour_lua:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return func
end

function modifier_divine_armour_lua:IsHidden()
	if not self.warning then
		return true
	else
		return false
	end
end

function modifier_divine_armour_lua:OnTakeDamage( keys )
	local dmg = keys.damage
	local unit = keys.unit

	--PrintTable(keys)

	if unit ~= self:GetParent() then return end
	if self:GetParent():IsIllusion() then return end

	if self:GetParent():PassivesDisabled() then return end

	if not self:GetAbility():IsCooldownReady() then return end

	local threshold = self:GetAbility():GetSpecialValueFor("threshold")
	local deal_dmg = self:GetAbility():GetSpecialValueFor("damage_heal")/100
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	local block_duration = self:GetAbility():GetSpecialValueFor("damage_block_duration")
	local caster = self:GetParent()

	local close = threshold - (threshold / 3)

	if self.arm_dmg_taken then
		self.arm_dmg_taken = self.arm_dmg_taken + dmg
	else
		self.arm_dmg_taken = dmg
	end

	if self.arm_dmg_taken >= close and not self.warning then
		self.warning = true
		caster:EmitSound("Hero_Oracle.FalsePromise.Healed")
		ParticleManager:CreateParticle("particles/units/heroes/hero_paragon/divine_armour_warning.vpcf", PATTACH_ROOTBONE_FOLLOW, caster) --[[Returns:int
		Creates a new particle effect
		]]
	end

	if self.arm_dmg_taken >= threshold then

		--local mult = self.arm_dmg_taken/threshold
		local mult = 1

		self.arm_dmg_taken = 0
		self.warning = false

		local mdmg = mult*deal_dmg

		caster:EmitSound("Hero_SkywrathMage.ArcaneBolt.Impact")
		local cooldown = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())

		self:GetAbility():StartCooldown(cooldown)

		local enemy_found = FindUnitsInRadius( caster:GetTeamNumber(),
                  caster:GetCenter(),
                  nil,
                    radius,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                    DOTA_UNIT_TARGET_FLAG_NONE,
                    FIND_CLOSEST,
                    false)

		for k,v in pairs(enemy_found) do
			if not v:IsMagicImmune() then
				local fdmg = v:GetMaxHealth() * mdmg
				DealDamage(v,caster,fdmg,DAMAGE_TYPE_PURE)
			end
		end

		--caster:Heal(caster:GetMaxHealth() * deal_dmg, caster)
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_divine_armour_block_lua", {Duration=block_duration}) --[[Returns:void
		No Description Set
		]]

	end
end