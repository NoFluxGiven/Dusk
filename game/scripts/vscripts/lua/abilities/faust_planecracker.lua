faust_planecracker = class({})

LinkLuaModifier("modifier_planecracker_thinker","lua/abilities/faust_planecracker",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_planecracker_aura","lua/abilities/faust_planecracker",LUA_MODIFIER_MOTION_NONE)

function faust_planecracker:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local delay = self:GetSpecialValueFor("delay")

	CreateModifierThinker( caster, self, "modifier_planecracker_thinker", {Duration=duration+0.1+delay}, target, caster:GetTeamNumber(), false )

	ScreenShake(target, 1200, 170, 0.25, 1200, 0, true)

end

modifier_planecracker_thinker = class({})

if IsServer() then

	function modifier_planecracker_thinker:OnCreated()
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_faust/planecracker_crack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent()) --[[Returns:int
		Creates a new particle effect
		]]
		local radius = self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
		No Description Set
		]]
		ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0)) --[[Returns:void
		Set the control point data for a control on a particle effect
		]]

		self:AddParticle( p, false, false, 10, false, false )

		self:GetParent():EmitSound("Faust.Planecracker")
	end

	function modifier_planecracker_thinker:IsAura()
		return true
	end

	function modifier_planecracker_thinker:GetAttributes()
		return MODIFIER_ATTRIBUTE_MULTIPLE
	end

	function modifier_planecracker_thinker:GetAuraRadius()
		return self:GetAbility():GetSpecialValueFor("radius") --[[Returns:table
		No Description Set
		]]
	end

	function modifier_planecracker_thinker:GetAuraDuration()
		return 0.1
	end

	function modifier_planecracker_thinker:GetAuraSearchFlags()
		return 0
	end

	function modifier_planecracker_thinker:GetAuraSearchTeam()
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	end

	function modifier_planecracker_thinker:GetAuraSearchType()
		return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING
	end

	function modifier_planecracker_thinker:GetModifierAura()
		return "modifier_planecracker_aura"
	end
end

modifier_planecracker_aura = class({})

function modifier_planecracker_aura:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_planecracker_aura:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

if IsServer() then

	function modifier_planecracker_aura:OnCreated()
		self.interval = 0.25

		local delay = self:GetAbility():GetSpecialValueFor("delay")



		Timers:CreateTimer(delay,function()
			self:StartIntervalThink(self.interval)
			ScreenShake(self:GetParent():GetAbsOrigin(), 400, 170, 4, 1200, 0, true)
		end)
	end

	function modifier_planecracker_aura:OnIntervalThink()
		local damage = self:GetAbility():GetSpecialValueFor("damage") * self.interval --[[Returns:table
		No Description Set
		]]

		if self:GetParent():IsBuilding() then
			damage = damage * 0.40
		end

		self:GetAbility():InflictDamage(self:GetParent(),self:GetAbility():GetCaster(),damage,DAMAGE_TYPE_MAGICAL)
	end

end