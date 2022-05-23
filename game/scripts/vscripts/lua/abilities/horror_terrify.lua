horror_terrify = class({})

LinkLuaModifier("modifier_terrify","lua/abilities/horror_terrify",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrify_run","lua/abilities/horror_terrify",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrify_command","lua/abilities/horror_terrify",LUA_MODIFIER_MOTION_NONE)

function horror_terrify:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	local duration = self:GetSpecialValueFor("duration")

	if target:TriggerSpellAbsorb(self) then return end

	target:EmitSound("Hero_Nightstalker.Trickling_Fear") 

	target:AddNewModifier(caster, self, "modifier_terrify", {Duration=duration}) --[[Returns:void
	No Description Set
	]]
end

modifier_terrify = class({})

function modifier_terrify:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_terrify:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_terrify:GetEffectName()
	return "particles/econ/items/nightstalker/nightstalker_black_nihility/nightstalker_black_nihility_void_swarm.vpcf"
end

function modifier_terrify:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_terrify:OnIntervalThink(kv)
	if IsServer() then
		local run = self:GetAbility():GetCaster()
		local p = self:GetParent()
		local range = self:GetAbility():GetSpecialValueFor("range")

		local t_damage_bonus = self:GetCaster():FindTalentValue("special_bonus_horror_1") or 0
		local damage = self:GetAbility():GetSpecialValueFor("damage") + t_damage_bonus

		local duration = self:GetAbility():GetSpecialValueFor("debuff_duration")

		if p:GetRangeToUnit(run) <= range then
			if not p:HasModifier("modifier_terrify_run") then
				--Particle
				self:GetParent():EmitSound("Hero_Nightstalker.Void.Nihility")
				self:GetAbility():InflictDamage(p,run,damage,DAMAGE_TYPE_MAGICAL)
				p:Interrupt()
				p:AddNewModifier(run, self:GetAbility(), "modifier_terrify_run", {Duration=duration})
				self:Destroy()
			end
		end

	end
end

function modifier_terrify:IsPurgable()
	return true
end

modifier_terrify_run = class({})

function modifier_terrify_run:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_terrify_run:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow_active")
end

function modifier_terrify_run:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.1)
		self.terrify_run_away_from = self:GetAbility():GetCaster()

		self.terrify_dir = (self:GetParent():GetAbsOrigin() - self.terrify_run_away_from:GetAbsOrigin()):Normalized()
	end
end

function modifier_terrify_run:OnIntervalThink()
	if IsServer() then
		local run = self:GetAbility():GetCaster()
		local p = self:GetParent()

		local dir = self.terrify_dir

		if p:HasModifier("modifier_terrify_command") then
			p:RemoveModifierByName("modifier_terrify_command")
		end

		local newOrder = {
                UnitIndex = p:entindex(),
                OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
                -- TargetIndex = entToAttack:entindex(), --Optional.  Only used when targeting units
                --AbilityIndex = 0, --Optional.  Only used when casting abilities
                Position = p:GetAbsOrigin()+dir*150, --Optional.  Only used when targeting the ground
        }
 
		ExecuteOrderFromTable(newOrder)

		p:AddNewModifier(run, self:GetAbility(), "modifier_terrify_command", {Duration=self:GetRemainingTime()})
	end
end

function modifier_terrify_run:IsPurgable()
	return true
end

modifier_terrify_command = class({})

function modifier_terrify_command:IsHidden()
	return true
end

function modifier_terrify_command:CheckState()
	return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true }
end

function modifier_terrify_command:IsPurgable()
	return true
end