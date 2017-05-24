vassal_self_destruct = class({})

LinkLuaModifier("modifier_self_destruct","lua/abilities/vassal_self_destruct",LUA_MODIFIER_MOTION_NONE)

function vassal_self_destruct:OnSpellStart()
	local caster = self:GetCaster()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_self_destruct", {}) --[[Returns:void
	No Description Set
	]]
	caster:EmitSound("Hero_Tinker.MechaBoots.Loop")
	caster:EmitSound("Hero_Oracle.FalsePromise.Target")

	Timers:CreateTimer(1.4,function()
		caster:StopSound("Hero_Tinker.MechaBoots.Loop")
	end)
end

function vassal_self_destruct:OnChannelFinish( interrupt )

	local int = interrupt

	local caster = self:GetCaster()

	if int then self:GetCaster():RemoveModifierByName("modifier_self_destruct") return end

	local cdmg = self:GetSpecialValueFor("centre_damage")
	local odmg = self:GetSpecialValueFor("outer_damage")

	local crad = self:GetSpecialValueFor("centre_radius")
	local orad = self:GetSpecialValueFor("outer_radius")

	local enemy_found = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),
                  self:GetCaster():GetCenter(),
                  nil,
                    crad,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                    DOTA_UNIT_TARGET_FLAG_NONE,
                    FIND_CLOSEST,
                    false)

	for k,v in pairs(enemy_found) do
		DealDamage(v,caster,cdmg,DAMAGE_TYPE_MAGICAL)
	end

	enemy_found = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),
                  self:GetCaster():GetCenter(),
                  nil,
                    orad,
                    DOTA_UNIT_TARGET_TEAM_ENEMY,
                    DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP,
                    DOTA_UNIT_TARGET_FLAG_NONE,
                    FIND_CLOSEST,
                    false)

	for k,v in pairs(enemy_found) do
		DealDamage(v,caster,odmg,DAMAGE_TYPE_MAGICAL)
	end

	ParticleManager:CreateParticle("particles/units/heroes/hero_tek/self_destruct_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster()) --[[Returns:int
	Creates a new particle effect
	]]

	ScreenShake(caster:GetCenter(), 1200, 170, 2, 1000, 0, true) --[[Returns:void
	Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
	]]

	self:GetCaster():RemoveModifierByName("modifier_self_destruct")

	self:GetCaster():Kill(self, self:GetCaster())

end

-- Modifiers

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_self_destruct = class({})

function modifier_self_destruct:GetEffectName()
	return "particles/units/heroes/hero_summoner/self_destruct_charge.vpcf"
end