phantom_nightmare = class({})

LinkLuaModifier("modifier_nightmare","lua/abilities/phantom_nightmare",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nightmare_cleave","lua/abilities/phantom_nightmare",LUA_MODIFIER_MOTION_NONE)

function phantom_nightmare:GetIntrinsicModifierName()
	return "modifier_nightmare"
end

modifier_nightmare = class({
	IsHidden = function(self) return true end,
	AllowIllusionDuplicate = function(self) return false end
})

function modifier_nightmare:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_nightmare:OnAttackLanded(params)
	if IsServer() then
		local attacker = params.attacker
		local target = params.target or params.unit

		local radius = self:GetAbility():GetSpecialValueFor("radius")

		if attacker:IsIllusion() then return end

		if attacker == self:GetParent() then
			local enemies = FindEnemies(attacker, target:GetAbsOrigin(), radius)
			local original_damage = params.original_damage

			local t_pct_bonus = self:GetCaster():FetchTalent("special_bonus_phantom_1") or 0
			local pct = ( self:GetAbility():GetSpecialValueFor("cleave") + t_pct_bonus ) / 100
			
			local pct_bonus = self:GetAbility():GetSpecialValueFor("damage_per_stack")/100
			local duration = self:GetAbility():GetSpecialValueFor("duration")

			attacker:EmitSound("Phantom.NightmareHit")

			for k,v in pairs(enemies) do
				local mod = v:AddNewModifier(attacker, self:GetAbility(), "modifier_nightmare_cleave", {Duration=duration})

				local damage = (pct + pct_bonus * mod:GetStackCount()) * original_damage

				self:GetAbility():InflictDamage(v,attacker,damage,DAMAGE_TYPE_PHYSICAL)

				CreateParticleHitloc(v,"particles/units/heroes/hero_phantom/phantom_cleave.vpcf")
			end
		end
	end
end

modifier_nightmare_cleave = class({})

function modifier_nightmare_cleave:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_nightmare_cleave:OnRefresh(kv)
	if IsServer() then
		local max = self:GetAbility():GetSpecialValueFor("max_stacks")
		if self:GetStackCount() < max then
			self:SetStackCount(self:GetStackCount()+1)
		end
	end
end