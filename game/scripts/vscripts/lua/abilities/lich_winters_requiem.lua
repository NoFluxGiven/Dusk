lich_winters_requiem = class({})

LinkLuaModifier("modifier_winters_requiem","lua/abilities/lich_winters_requiem",LUA_MODIFIER_MOTION_NONE)

function lich_winters_requiem:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")

		local t_damage_bonus = self:GetCaster():FetchTalent("special_bonus_lich_4") or 0
		local damage = self:GetSpecialValueFor("damage") + t_damage_bonus

		local n = self:GetSpecialValueFor("targets")
		local buffer_radius = self:GetSpecialValueFor("buffer")
		local delay = self:GetSpecialValueFor("delay")

		local slow_duration = self:GetSpecialValueFor("slow_duration")

		local enemies = FindEnemies(caster,caster:GetAbsOrigin(),radius,nil,DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE)

		shuffleTable(enemies)

		local targets = {}

		caster:EmitSound("Hero_KeeperOfTheLight.ManaLeak.Target")

		for k,v in pairs(enemies) do

			if k <= n then
				CreateParticleHitloc(v, "particles/units/heroes/hero_lich/winters_requiem_target.vpcf")
				table.insert(targets, v)
			else
				break
			end

		end

		for k,v in pairs(targets) do

			Timers:CreateTimer(delay+k*0.15,function()
				if ( caster:GetRangeToUnit(v) < (radius + buffer_radius) )then
					v:EmitSound("Ability.FrostNova")
					CreateParticleHitloc(v, "particles/units/heroes/hero_lich/winters_requiem.vpcf")
					local damage_radius = self:GetSpecialValueFor("damage_radius")
					local found = FindEnemies(caster,v:GetAbsOrigin(),damage_radius)

					-- DebugDrawCircle(v:GetAbsOrigin()+Vector(0,0,15), Vector(255,0,0), 5, damage_radius, false, 1)

					for kk,vv in pairs(found) do
						self:InflictDamage(vv,caster,damage,DAMAGE_TYPE_MAGICAL)
						v:AddNewModifier(caster, self, "modifier_winters_requiem", {Duration=slow_duration})
					end
				end
			end)

		end
	end
end

modifier_winters_requiem = class({})

function modifier_winters_requiem:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_winters_requiem:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return func
end

function modifier_winters_requiem:GetModifierMoveSpeedBonus_Percentage()
	local t_slow_bonus = self:GetAbility():GetCaster():FetchTalent("special_bonus_lich_2") or 0
	return -(self:GetAbility():GetSpecialValueFor("slow") + t_slow_bonus)
end