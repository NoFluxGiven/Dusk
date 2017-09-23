baal_st_anchor = class({})

LinkLuaModifier("modifier_st_anchor","lua/abilities/baal_st_anchor",LUA_MODIFIER_MOTION_NONE)

function baal_st_anchor:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	local t_radius_bonus = self:GetCaster():FetchTalent("special_bonus_baal_2") or 0
	local radius = self:GetSpecialValueFor("radius") + t_radius_bonus

	if target:TriggerSpellAbsorb(self) then return end
	target:TriggerSpellReflect(self)

	local bonus = 0

	if caster:GetHasTalent("special_bonus_baal_st_anchor") then
		bonus = 8
	end

	duration = duration + bonus

	local unit = FastDummy(target:GetAbsOrigin(),caster:GetTeam(),duration+0.8,0)

	target.st_anchor_unit = unit

	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_st_anchor.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit) --[[Returns:int
	Creates a new particle effect
	]]
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
	Set the control point data for a control on a particle effect
	]]

	Timers:CreateTimer(duration,function()
		ParticleManager:DestroyParticle(p,false)
	end)

	target:EmitSound("Hero_Visage.GraveChill.Cast")
	target:AddNewModifier(caster, self, "modifier_st_anchor", {Duration = duration}) --[[Returns:void
	No Description Set
	]]
end

modifier_st_anchor = class({})

function modifier_st_anchor:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_st_anchor:OnIntervalThink()
	local caster = self:GetCaster()
	local target = self:GetParent()

	local t_radius_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_baal_2") or 0
	local radius = self:GetAbility():GetSpecialValueFor("radius") + t_radius_bonus
	
	local stun = self:GetAbility():GetSpecialValueFor("stun")
	local damage = self:GetAbility():GetAbilityDamage() or self:GetAbility():GetSpecialValueFor("damage")

	if not IsValidEntity(target.st_anchor_unit) then return end

	if not target.st_anchor_unit then return end

	if target:IsMagicImmune() then return end

	if target:GetRangeToUnit(target.st_anchor_unit) > radius then
		DealDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)
		target:AddNewModifier(caster, nil, "modifier_stunned", {Duration=stun}) --[[Returns:void
		No Description Set
		]]
		target:EmitSound("Baal.VectorPlate")
		ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_st_anchor_target_start.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
		Timers:CreateTimer(0.03,function()
			FindClearSpaceForUnit(target, target.st_anchor_unit:GetAbsOrigin(), true) --[[Returns:void
			Place a unit somewhere not already occupied.
			]]
			ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_st_anchor_target.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
			target.st_anchor_unit:Destroy()
		end)
		--target:RemoveModifierByName("modifier_st_anchor")
	end
end