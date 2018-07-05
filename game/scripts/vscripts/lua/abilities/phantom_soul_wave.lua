phantom_soul_wave = class({})

LinkLuaModifier("modifier_soul_wave","lua/abilities/phantom_soul_wave",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_soul_wave_count","lua/abilities/phantom_soul_wave",LUA_MODIFIER_MOTION_NONE)

function phantom_soul_wave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local enemies = FindEnemies(caster,caster:GetAbsOrigin(),radius)

		local delay = self:GetSpecialValueFor("delay")

		local t_slow_duration_bonus = self:GetCaster():FetchTalent("special_bonus_phantom_2") or 0
		local slow_duration = self:GetSpecialValueFor("slow_duration") + t_slow_duration_bonus

		local mult = self:GetSpecialValueFor("mult")

		local damage = self:GetSpecialValueFor("damage")

		caster:EmitSound("Phantom.SoulWave")

		CreateParticleHitloc(caster, "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_explode.vpcf")

		for k,v in pairs(enemies) do
			local dmg = self:InflictDamage(v,caster,damage,DAMAGE_TYPE_MAGICAL)
			if not v:IsHero() then dmg = dmg * 0.25 end
			v:AddNewModifier(caster, self, "modifier_soul_wave", {Duration=slow_duration})
			caster:AddNewModifier(caster, self, "modifier_soul_wave_count", {Duration=delay*2,stacks=dmg})
		end

		Timers:CreateTimer(delay,function()
			CreateParticleHitloc(caster, "particles/units/heroes/hero_phantom/soul_wave_return.vpcf")
			local heal = caster:FindModifierByName("modifier_soul_wave_count"):GetStackCount() * (mult/100)
			caster:Heal(heal, caster)
		end)
	end
end

modifier_soul_wave = class({})

function modifier_soul_wave:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_soul_wave:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end

modifier_soul_wave_count = class({})

function modifier_soul_wave_count:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stacks)
	end
end

function modifier_soul_wave_count:OnRefresh(kv)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+kv.stacks)
	end
end

function modifier_soul_wave_count:IsHidden()
	return true
end