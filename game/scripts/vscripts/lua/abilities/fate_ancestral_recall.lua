fate_ancestral_recall = class({})

LinkLuaModifier("modifier_ancestral_recall_display","lua/abilities/fate_ancestral_recall",LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ancestral_recall_agi","lua/abilities/fate_ancestral_recall",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_recall_str","lua/abilities/fate_ancestral_recall",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancestral_recall_int","lua/abilities/fate_ancestral_recall",LUA_MODIFIER_MOTION_NONE)

function fate_ancestral_recall:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		caster.p = ParticleManager:CreateParticle("particles/units/heroes/hero_fate/ancestral_recall.vpcf", PATTACH_POINT_FOLLOW, caster)

		ParticleManager:SetParticleControlEnt(caster.p,0,caster,PATTACH_POINT_FOLLOW,"attach_attack1",caster:GetCenter(),true)
	end
end

function fate_ancestral_recall:OnChannelFinish(interrupt)
	if IsServer() then
		local caster = self:GetCaster()
		ParticleManager:DestroyParticle(caster.p,false)
		if not interrupt then
			local target = self:GetCursorTarget()

			local levels = self:GetSpecialValueFor("level_bonus")

			local duration = self:GetSpecialValueFor("duration")

			local agi_gain = target:GetAgilityGain()
			local str_gain = target:GetStrengthGain()
			local int_gain = target:GetIntellectGain()

			local agi_total = math.ceil(agi_gain * levels)
			local str_total = math.ceil(str_gain * levels)
			local int_total = math.ceil(int_gain * levels)

			target:Purge(true,true,false,true,false)

			local t_percent_bonus = self:GetCaster():FindTalentValue("special_bonus_fate_4") or 0

			local mhp = target:GetMaxHealth()
			local percent = ( self:GetSpecialValueFor("heal_percent") + t_percent_bonus )/100

			local mmp = target:GetMaxMana()
			local mpercent = ( self:GetSpecialValueFor("mana_restore_percent") + t_percent_bonus )/100

			local heal = mhp * percent
			local mana = mmp * mpercent

			target:Heal(heal, caster)
			target:GiveMana(mana)

			--Sound
			CreateParticleHitloc(target,"particles/units/heroes/hero_fate/ancestral_recall_hit.vpcf")

			target:AddNewModifier(caster, self, "modifier_ancestral_recall_display", {Duration=duration})
			target:AddNewModifier(caster, self, "modifier_ancestral_recall_agi", {Duration=duration,stack=agi_total})
			target:AddNewModifier(caster, self, "modifier_ancestral_recall_str", {Duration=duration,stack=str_total})
			target:AddNewModifier(caster, self, "modifier_ancestral_recall_int", {Duration=duration,stack=int_total})
		end
	end
end

modifier_ancestral_recall_display = class({})

function modifier_ancestral_recall_display:OnCreated()
	if IsServer() then
		Timers:CreateTimer(0.03,function() self:GetParent():CalculateStatBonus() end)
	end
end

modifier_ancestral_recall_agi = class({})

function modifier_ancestral_recall_agi:IsHidden()
	return true
end

function modifier_ancestral_recall_agi:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_ancestral_recall_agi:OnRefresh(kv)
	if IsServer() then
		if kv.stack > self:GetStackCount() then
			self:SetStackCount(kv.stack)
		end
	end
end

function modifier_ancestral_recall_agi:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return func
end

function modifier_ancestral_recall_agi:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

function modifier_ancestral_recall_agi:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("damage_bonus")
end

modifier_ancestral_recall_str = class({})

function modifier_ancestral_recall_str:IsHidden()
	return true
end

function modifier_ancestral_recall_str:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_ancestral_recall_str:OnRefresh(kv)
	if IsServer() then
		if kv.stack > self:GetStackCount() then
			self:SetStackCount(kv.stack)
		end
	end
end

function modifier_ancestral_recall_str:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return func
end

function modifier_ancestral_recall_str:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

modifier_ancestral_recall_int = class({})

function modifier_ancestral_recall_int:IsHidden()
	return true
end

function modifier_ancestral_recall_int:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(kv.stack)
	end
end

function modifier_ancestral_recall_int:OnRefresh(kv)
	if IsServer() then
		if kv.stack > self:GetStackCount() then
			self:SetStackCount(kv.stack)
		end
	end
end

function modifier_ancestral_recall_int:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return func
end

function modifier_ancestral_recall_int:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end