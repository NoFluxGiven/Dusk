bloodwarrior_soul_claw = class({})

LinkLuaModifier("modifier_soul_claw","lua/abilities/bloodwarrior_soul_claw",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_claw_proc","lua/abilities/bloodwarrior_soul_claw",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_claw_no_healing","lua/abilities/bloodwarrior_soul_claw",LUA_MODIFIER_MOTION_NONE)

function bloodwarrior_soul_claw:GetIntrinsicModifierName()
	return "modifier_soul_claw"
end

modifier_soul_claw = class({})

function modifier_soul_claw:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START
	}
	return funcs
end

function modifier_soul_claw:IsHidden()
	return true
end

if IsServer() then
	function modifier_soul_claw:OnAttackStart(params)
		if params.attacker ~= self:GetParent() then
			return
		end

		self:GetParent():RemoveModifierByName("modifier_soul_claw_proc")

		if params.target:IsBuilding() then return end

		if not self:GetAbility():IsCooldownReady() then return end

		local target_chance = self:GetAbility():GetSpecialValueFor("chance")

		local b = 5 -- base chance
		local c = 9 -- increase per non-proc attack

		if not self.chance then
			self.chance = b
		end

		print("CHANCE: "..self.chance)

		local r = RandomInt(1,100)

		if r > self.chance then self.chance = self.chance + c return end

		self.chance = nil

		ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/soul_claw_start_up.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

		self:GetParent():EmitSound("Bloodwarrior.SoulClaw.StartUp")

		self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_soul_claw_proc", {})
	end
end

modifier_soul_claw_proc = class({})

function modifier_soul_claw_proc:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

if IsServer() then
	function modifier_soul_claw_proc:OnAttackLanded(params)
		local parent = self:GetParent()
		local attacker = params.attacker
		local target = params.target

		if parent ~= attacker then return end

		local t_pct_bonus = self:GetAbility():GetCaster():FindTalentValue("special_bonus_bloodwarrior_2") or 0
		t_pct_bonus = t_pct_bonus/100

		local pct = self:GetAbility():GetSpecialValueFor("hp_percent")/100 + t_pct_bonus
		local hp = parent:GetHealth()

		local damage = hp * pct

		local duration = self:GetAbility():GetSpecialValueFor("duration")
		local ministun_duration = self:GetAbility():GetSpecialValueFor("ministun_duration")

		local internal_cooldown = self:GetAbility():GetSpecialValueFor("internal_cooldown")

		target:AddNewModifier(parent, self:GetAbility(), "modifier_soul_claw_no_healing", {Duration=duration})
		target:AddNewModifier(parent, self:GetAbility(), "modifier_stunned", {Duration=ministun_duration})

		self:GetAbility():InflictDamage(target,parent,damage,DAMAGE_TYPE_MAGICAL)

		self:GetAbility():StartCooldown(internal_cooldown)

		ParticleManager:CreateParticle("particles/units/heroes/hero_bloodwarrior/soul_claw.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		parent:EmitSound("Bloodwarrior.SoulClaw")

		self:Destroy()
	end
end

function modifier_soul_claw_proc:IsHidden()
	return true
end

modifier_soul_claw_no_healing = class({})

function modifier_soul_claw_no_healing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
	return funcs
end

function modifier_soul_claw_no_healing:GetDisableHealing()
	return 1
end