shade_stalk = class({})

-- Link("modifier_stalk")
-- Link("modifier_stalk_passive")

LinkLuaModifier("modifier_stalk","lua/abilities/shade_stalk",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stalk_target","lua/abilities/shade_stalk",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stalk_poison","lua/abilities/shade_stalk",LUA_MODIFIER_MOTION_NONE)

function shade_stalk:OnSpellStart()
	local c = self:GetCaster()
	local t = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	local tbonus_duration = self:GetCaster():FetchTalent("special_bonus_shade_1")

	if tbonus_duration then
		duration = duration+tbonus_duration
	end

	t:EmitSound("Hero_Dark_Seer.Ion_Shield_Start")

	c:AddNewModifier(c, self, "modifier_invisible", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
	c:AddNewModifier(c, self, "modifier_stalk", {Duration=duration})
	t:AddNewModifier(c, self, "modifier_stalk_target", {Duration=duration})
end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_stalk = class({})

function modifier_stalk:OnCreated()
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local unit = FastDummy(caster:GetAbsOrigin(),caster:GetTeam(),1,0)

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_shade/stalk.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit) --[[Returns:int
		Creates a new particle effect
		]]

		ParticleManager:SetParticleControlEnt(p,0,caster,PATTACH_POINT_FOLLOW,"attach_hitloc",caster:GetCenter(),true)
	end
end

function modifier_stalk:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_stalk:GetModifierMoveSpeedBonus_Percentage()
	local bonus = self:GetAbility():GetSpecialValueFor("movespeed_bonus")

	return bonus
end

function modifier_stalk:OnAttackLanded(params)
	if IsServer() then
		local attacker = params.attacker
		local target = params.target
		local damage = self:GetAbility():GetSpecialValueFor("proc_damage") --[[Returns:table
		No Description Set
		]]
		local poison_duration = self:GetAbility():GetSpecialValueFor("poison_duration")

		local tbonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_shade_6")
		if tbonus then
			damage = damage+tbonus
		end

		if attacker == self:GetParent() then
			if target:HasModifier("modifier_stalk_target") then
				self:GetAbility():InflictDamage(target,attacker,damage,self:GetAbility():GetAbilityDamageType())
				--attacker:Heal(damage, attacker)
				--self:GetAbility():EndCooldown()
				CreateParticleHitloc(target,"particles/units/heroes/hero_shade/stalk_attack.vpcf")
				target:EmitSound("Hero_BountyHunter.Jinada")
				target:AddNewModifier(attacker, self:GetAbility(), "modifier_stalk_poison", {Duration=poison_duration})
				local mod = target:FindModifierByNameAndCaster("modifier_stalk_target",attacker)
				if mod then
					mod:Destroy()
				end
				self:Destroy()
			end
		end
	end
end

function modifier_stalk:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
	return state
end

modifier_stalk_target = class({})

function modifier_stalk_target:OnCreated()
	if IsServer() then
		local p = CreateParticleHitloc(self:GetParent(),"particles/units/heroes/hero_shade/stalk_unit.vpcf")
		self:AddParticle(p,false,false,10,false,false)
	end
end

function modifier_stalk_target:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_stalk_target:GetModifierMoveSpeedBonus_Percentage()
	local slow = self:GetAbility():GetSpecialValueFor("slow")
	return -slow
end

function modifier_stalk_target:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
	return state
end

---------------

modifier_stalk_poison = class({})

function modifier_stalk_poison:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return func
end

function modifier_stalk_poison:OnCreated()
	self:StartIntervalThink(0.5)
	self:GetParent():EmitSound("Hero_Viper.PoisonAttack")
	self.start_time = GameRules:GetGameTime()
end

function modifier_stalk_poison:OnIntervalThink()
	if IsServer() then
		local agh_interval = 14
		local dot = self:GetAbility():GetSpecialValueFor("poison_damage_over_time")
		local dmg = dot / 2
		local tbonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_shade_2")
		if tbonus then dmg = dmg + tbonus end
		local dtype = self:GetAbility():GetAbilityDamageType()
		self:GetAbility():InflictDamage(self:GetParent(),self:GetCaster(),dmg,dtype,DOTA_DAMAGE_FLAG_BYPASSES_BLOCK)
	end
end

function modifier_stalk_poison:GetModifierMoveSpeedBonus_Percentage()
	local agh_interval = 8
	local slow = self:GetAbility():GetSpecialValueFor("poison_slow")
	return -slow
end

function modifier_stalk_poison:GetModifierAttackSpeedBonus_Constant()
	local agh_interval = 8
	local slow = self:GetAbility():GetSpecialValueFor("poison_slow")
	return -slow
end

function modifier_stalk_poison:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end