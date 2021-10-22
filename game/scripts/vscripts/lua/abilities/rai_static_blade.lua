rai_static_blade = class({})

LinkLuaModifier("modifier_static_blade","lua/abilities/rai_static_blade",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_static_blade_silence","lua/abilities/rai_static_blade",LUA_MODIFIER_MOTION_NONE)

function rai_static_blade:GetIntrinsicModifierName()
	return "modifier_static_blade"
end

function rai_static_blade:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function rai_static_blade:Proc(target)
	if target:IsBuilding() then return end
	if target:IsMagicImmune() then return end
	if not self:IsCooldownReady() then return end

	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage")

	target:AddSRModifier( self:GetCaster(), self, "modifier_static_blade_silence", duration, {} )

	self:InflictDamage(target,self:GetCaster(),damage,DAMAGE_TYPE_MAGICAL)

	self:UseResources(false, false, true)

	ParticleManager:CreateParticle("particles/units/heroes/hero_rai/static_blade_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	target:EmitSound("Rai.StaticBlade")
end

---------------------------------------------

modifier_static_blade = class({})

function modifier_static_blade:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
	return funcs
end

function modifier_static_blade:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		if self:GetParent():IsIllusion() then return end

		if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("proc_chance"), self) then

			self:GetAbility():Proc(params.target)

		end
	end
end

--------------------------------------------------------------------------------------------------------------

modifier_static_blade_silence = class({})

function modifier_static_blade_silence:IsHidden() return false end
function modifier_static_blade_silence:IsPurgable() return true end

function modifier_static_blade_silence:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_static_blade_silence:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_static_blade_silence:GetEffectName()
	return "particles/units/heroes/hero_rai/static_blade_silence.vpcf"
end

function modifier_static_blade_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_static_blade_silence:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true
	}
end