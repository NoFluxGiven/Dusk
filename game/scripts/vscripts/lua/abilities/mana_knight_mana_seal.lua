mana_knight_mana_seal = class({})

LinkLuaModifier("modifier_mana_seal_aoe","lua/abilities/mana_knight_mana_seal",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mana_seal_cooldown","lua/abilities/mana_knight_mana_seal",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mana_seal_slow","lua/abilities/mana_knight_mana_seal",LUA_MODIFIER_MOTION_NONE)

function mana_knight_mana_seal:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker( caster, self, "modifier_mana_seal_aoe", {Duration=duration+0.25}, target, caster:GetTeamNumber(), false )
end

modifier_mana_seal_aoe = class({})

function modifier_mana_seal_aoe:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink(0.25)
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		self:GetParent():EmitSound("Hero_Dazzle.Weave")

		local t_silence = self:GetAbility():GetCaster():FetchTalent("special_bonus_mana_knight_1")

		if t_silence then
			local enemies = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),self.radius)

			for k,v in pairs(enemies) do
				v:AddNewModifier(self:GetAbility():GetCaster(), nil, "modifier_silence", {Duration=t_silence})
			end
		end

		local t_drain_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_mana_knight_3") or 0

		self.mana_drain = ( self:GetAbility():GetSpecialValueFor("mana_removal") + t_drain_bonus ) / 100
		self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.cooldown = self:GetAbility():GetSpecialValueFor("cooldown")

		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_mana_knight/mana_seal.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(p, 1, Vector(self.radius,0,0))

		self:AddParticle( p, false, false, 10, false, false )
	end
end

function modifier_mana_seal_aoe:OnIntervalThink()
	if IsServer() then
		
		local enemies = FindEnemies(self:GetAbility():GetCaster(),self:GetParent():GetAbsOrigin(),self.radius)
		
		for k,v in pairs(enemies) do
			local mana = v:GetMaxMana()
			local interval = 0.25

			if mana <= 0 then return end

			v:ReduceMana( (mana*self.mana_drain) * interval )
			local diff = v:GetManaPercent()
			local p = ParticleManager:CreateParticle("particles/units/heroes/hero_mana_knight/mana_seal_drain.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
			ParticleManager:SetParticleControl(p, 1, Vector(diff,0,0))

			if ( v:GetMana() <= 1 ) then
				if ( not v:HasModifier("modifier_mana_seal_cooldown") ) then
					self:GetAbility():InflictDamage(v,self:GetAbility():GetCaster(),self.damage,DAMAGE_TYPE_MAGICAL)
					ParticleManager:CreateParticle("particles/econ/items/silencer/silencer_ti6/silencer_last_word_dmg_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
					v:EmitSound("Hero_Silencer.LastWord.Damage")
					v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_mana_seal_cooldown", {Duration=self.cooldown})
					v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_mana_seal_slow", {Duration=self.slow_duration})
					v:AddNewModifier(self:GetAbility():GetCaster(), nil, "modifier_stunned", {Duration=0.75})
				end
			end
		end

	end
end

modifier_mana_seal_cooldown = class({})

function modifier_mana_seal_cooldown:IsHidden()
	return true
end

modifier_mana_seal_slow = class({})

function modifier_mana_seal_slow:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_mana_seal_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetAbility():GetSpecialValueFor("slow")
end