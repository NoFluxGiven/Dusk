lupin_last_surprise = class({})

LinkLuaModifier("modifier_last_surprise","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_surprise_damage","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_surprise_damage_reduction","lua/abilities/lupin_last_surprise",LUA_MODIFIER_MOTION_NONE)

-- Copies a portion of damage from nearby enemies,
-- then after a short delay slashes a set distance in the direction
-- targeted, attacking each unit hit, then does the same in the opposite direction, returning to the
-- starting position.
-- Does not proc attack effects or orbs.

function lupin_last_surprise:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		local cloc = caster:GetAbsOrigin()
		local cfac = caster:GetForwardVector()
		local t_range_bonus = self:GetCaster():FetchTalent("special_bonus_lupin_5") or 0
		local range = self:GetSpecialValueFor("range") + t_range_bonus

		local start_loc = cloc
		local end_loc = cloc + (cfac * range)

		local end_cfac = (start_loc - end_loc):Normalized()

		local delay = self:GetSpecialValueFor("delay") * 0.5

		local radius = self:GetSpecialValueFor("radius")
		local duration = self:GetSpecialValueFor("duration")

		local mult = self:GetSpecialValueFor("damage_steal")/100

		-- local found = FindEnemies(caster,cloc,radius)

		local cmod = "modifier_last_surprise_damage"

		local ab = "lupin_beneath_the_mask"

		ab = caster:FindAbilityByName(ab)

		-- ab:EndCooldown()

		-- for k,v in pairs(found) do
		-- 	local stack = 0

		-- 	local ad = v:GetAttackDamage() * mult

		-- 	stack = ad

		-- 	caster:AddNewModifier(caster, self, cmod, {Duration=delay*2.5,stack=stack})

		-- 	local p = ParticleManager:CreateParticle("particles/units/heroes/hero_lupin/last_surprise_absorb.vpcf",PATTACH_POINT_FOLLOW,v)
		-- 	ParticleManager:SetParticleControl(p, 0, v:GetCenter())
		-- 	ParticleManager:SetParticleControl(p, 1, caster:GetCenter())

		-- end

		local n = 0

		local r = 1
		
		caster:AddNewModifier(caster, self, "modifier_last_surprise", {Duration=delay*r+0.3})

		AddFOWViewer( caster:GetTeamNumber(), caster:GetAbsOrigin(), range, 1.2, false )

		for i=1,r,2 do

			Timers:CreateTimer(delay*i,function()
				caster:Interrupt()
				local fen = FindUnitsInLine(caster:GetTeamNumber(),
					start_loc,
					end_loc,
					caster,
					175,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
					0)
				for k,v in pairs(fen) do
					if not v:IsHero() then
						caster:AddNewModifier(caster, self, "modifier_last_surprise_damage_reduction", {Duration=0.1})
					end
					
					caster:PerformAttack( v,
						true,
						true,
						true,
						true,
						false,
						false,
						true )
					CreateParticleHitloc(v,"particles/units/heroes/hero_lupin/last_surprise_unit.vpcf")
					n = n+1
				end
				local p = ParticleManager:CreateParticle("particles/units/heroes/hero_lupin/last_surprise_slash.vpcf",PATTACH_POINT_FOLLOW,caster)
				ParticleManager:SetParticleControl(p, 0, start_loc+Vector(0,0,150))
				ParticleManager:SetParticleControl(p, 1, end_loc+Vector(0,0,150))
				FindClearSpaceForUnit(caster, end_loc, true)
				caster:EmitSound("Hero_Riki.Backstab")
				caster:SetForwardVector(cfac)
			end)

			-- Timers:CreateTimer(delay*(i+1),function()
			-- 	caster:Interrupt()
			-- 	local fen = FindUnitsInLine(caster:GetTeamNumber(),
			-- 		start_loc,
			-- 		end_loc,
			-- 		caster,
			-- 		50,
			-- 		DOTA_UNIT_TARGET_TEAM_ENEMY,
			-- 		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			-- 		0)
			-- 	for k,v in pairs(fen) do
			-- 		if not v:IsHero() then
			-- 			caster:AddNewModifier(caster, self, "modifier_last_surprise_damage_reduction", {Duration=0.1})
			-- 		end

			-- 		caster:PerformAttack( v,
			-- 			true,
			-- 			true,
			-- 			true,
			-- 			true,
			-- 			false,
			-- 			false,
			-- 			true )
			-- 		CreateParticleHitloc(v,"particles/units/heroes/hero_lupin/last_surprise_unit.vpcf")
			-- 		n = n+1
			-- 	end
			-- 	local p2 = ParticleManager:CreateParticle("particles/units/heroes/hero_lupin/last_surprise_slash.vpcf",PATTACH_POINT_FOLLOW,caster)
			-- 	ParticleManager:SetParticleControl(p2, 0, end_loc+Vector(0,0,150))
			-- 	ParticleManager:SetParticleControl(p2, 1, start_loc+Vector(0,0,150))
			-- 	FindClearSpaceForUnit(caster, start_loc, true)
			-- 	caster:EmitSound("Hero_Riki.Backstab")
			-- 	caster:SetForwardVector(end_cfac)
			-- 	caster:Interrupt()

				-- if n > 0 then
				-- 	ab:StartCooldown(-1)
				-- end
			-- end)
		end
	end
end

modifier_last_surprise = class({})

function modifier_last_surprise:GetEffectName()
	return "particles/units/heroes/hero_lupin/ephemera_unit.vpcf"
end

function modifier_last_surprise:IsPurgable()
	return false
end

function modifier_last_surprise:IsDebuff()
	return false
end

function modifier_last_surprise:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

modifier_last_surprise_damage = class({})

if IsServer() then

	function modifier_last_surprise_damage:OnCreated(kv)
		if kv then
			self:SetStackCount(kv.stack)
		end
	end

	function modifier_last_surprise_damage:OnRefresh(kv)
		if kv then
			self:SetStackCount(self:GetStackCount()+kv.stack)
		end
	end

end

function modifier_last_surprise_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_last_surprise_damage:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

modifier_last_surprise_damage_reduction = class({})

function modifier_last_surprise_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_last_surprise_damage_reduction:IsHidden()
	return true
end

function modifier_last_surprise_damage:GetModifierDamageOutgoing_Percentage()
	return -(100-self:GetAbility():GetSpecialValueFor("creep_damage"))
end