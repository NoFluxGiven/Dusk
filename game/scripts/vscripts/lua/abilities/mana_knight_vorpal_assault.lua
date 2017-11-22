mana_knight_vorpal_assault = class({})

LinkLuaModifier("modifier_vorpal_assault_silence","lua/abilities/mana_knight_vorpal_assault",LUA_MODIFIER_MOTION_NONE)

function mana_knight_vorpal_assault:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	local n = self:GetSpecialValueFor("bolts")
	local damage = self:GetSpecialValueFor("damage")
	local mana_damage = self:GetSpecialValueFor("mana_burn")

	local dummy = CreateModifierThinker( caster, self, "modifier_true_sight", {Duration=n*0.1 + 0.1}, Vector(0,0,0), caster:GetTeamNumber(), false )

	target:EmitSound("ManaKnight.VorpalAssault")

	if n > 0 then
		for i=0,n do
			Timers:CreateTimer(0.15*i,function()
				ParticleManager:CreateParticle("particles/units/heroes/hero_mana_knight/vorpal_assault_unit_buffs_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
				local p = ParticleManager:CreateParticle("particles/units/heroes/hero_mana_knight/vorpal_assault_beam.vpcf", PATTACH_POINT_FOLLOW, dummy)
				ParticleManager:SetParticleControlEnt(p,0,caster,PATTACH_POINT_FOLLOW,"attach_attack1",caster:GetCenter(),true)
				ParticleManager:SetParticleControlEnt(p,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetCenter(),true)
				target:EmitSound("ManaKnight.VorpalAssault.Hit")
				self:InflictDamage(target,caster,damage,DAMAGE_TYPE_MAGICAL)
				target:ReduceMana(mana_damage)
				target:AddNewModifier(caster, self, "modifier_vorpal_assault_silence", {Duration=0.75})
			end)
		end
	end
end

modifier_vorpal_assault_silence = class({})

function modifier_vorpal_assault_silence:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true
	}
	return state
end

function modifier_vorpal_assault_silence:OnRefresh(kv)
	if IsServer() then
		local time = self:GetRemainingTime()
		local duration = kv.Duration or kv.duration

		print(time+duration)

		self:SetDuration(time+duration,true)
	end
end

function modifier_vorpal_assault_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

function modifier_vorpal_assault_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_vorpal_assault_silence:IsPurgable()
	return true
end