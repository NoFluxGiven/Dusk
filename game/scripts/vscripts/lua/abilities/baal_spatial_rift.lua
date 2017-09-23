baal_spatial_rift = class({})

LinkLuaModifier("modifier_spatial_rift_slow","lua/abilities/baal_spatial_rift",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spatial_rift_display","lua/abilities/baal_spatial_rift",LUA_MODIFIER_MOTION_NONE)

function baal_spatial_rift:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	caster.spatial_rift_unit = FastDummy(point+Vector(0,0,150),caster:GetTeam(),duration+0.80,radius)

	caster.spatial_rift_start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_spatial_rift_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.spatial_rift_unit)
end

function baal_spatial_rift:OnUpgrade()
	local ab = self:GetCaster():FindAbilityByName("baal_port_out")
	ab:SetLevel(1)
end

function baal_spatial_rift:OnChannelFinish(interrupted)
	if not interrupted then
		local caster = self:GetCaster()
		local point = self:GetCursorPosition()
		local radius = self:GetSpecialValueFor("radius")
		local duration = self:GetSpecialValueFor("duration")

		local t_slow_duration_bonus = self:GetCaster():FetchTalent("special_bonus_baal_3") or 0
		local slow_duration = self:GetSpecialValueFor("slow_duration") + t_slow_duration_bonus
		
		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_baal_1") or 0
		local damage = self:GetSpecialValueFor("damage") + t_damage_bonus

		local ability = caster:FindAbilityByName("baal_port_out")

		local bonus = 0

		if caster:GetHasTalent("special_bonus_baal_spatial_rift") then
			bonus = 100
		end

		damage = damage+bonus

		ability:SetHidden(false)
		self:SetHidden(true)

		if caster.spatial_rift_unit == nil then self:EndCooldown() self:RefundManaCost() return end

		ParticleManager:DestroyParticle(caster.spatial_rift_start_particle,false)

		caster.spatial_rift_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_baal/baal_spatial_rift.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.spatial_rift_unit)

		caster.spatial_rift_unit:EmitSound("Hero_ChaosKnight.RealityRift.Target")

		caster:AddNewModifier(caster, self, "modifier_spatial_rift_display", {Duration=duration}) --[[Returns:void
		No Description Set
		]]

		Timers:CreateTimer(duration+0.1,function()
			self:EndRift()
		end)

		local found = FindUnitsInRadius( caster:GetTeamNumber(),
	                              point,
	                              nil,
	                                radius,
	                                DOTA_UNIT_TARGET_TEAM_ENEMY,
	                                DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
	                                DOTA_UNIT_TARGET_FLAG_NONE,
	                                FIND_CLOSEST,
	                                false)

		for k,v in pairs(found) do
			v:AddNewModifier(caster, self, "modifier_spatial_rift_slow", {Duration=slow_duration}) --[[Returns:void
			No Description Set
			]]
			DealDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
		end
	else
		self:EndRift()
	end
end

function baal_spatial_rift:EndRift()
	local caster = self:GetCaster()
	local ability = caster:FindAbilityByName("baal_port_out")

	self:SetHidden(false)
	ability:SetHidden(true)

	if caster.spatial_rift_particle then ParticleManager:DestroyParticle(caster.spatial_rift_particle,true) end
	if caster.spatial_rift_start_particle then ParticleManager:DestroyParticle(caster.spatial_rift_start_particle,true) end
	if caster.spatial_rift_unit then caster.spatial_rift_unit:ForceKill(false) end
	caster.spatial_rift_unit = nil
end

modifier_spatial_rift_slow = class({})

function modifier_spatial_rift_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_spatial_rift_slow:GetModifierMoveSpeedBonus_Percentage()
	local pct = self:GetRemainingTime()/self:GetDuration()
	ToolsPrint(pct..", "..self:GetDuration()..", "..self:GetRemainingTime())
	return self:GetAbility():GetSpecialValueFor("slow")*pct --[[Returns:table
	No Description Set
	]]
end

modifier_spatial_rift_display = class({})

function modifier_spatial_rift_display:DestroyOnExpire()
	return true
end