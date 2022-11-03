reus_ancient_arena = class({})

LinkLuaModifier("modifier_ancient_arena","lua/abilities/reus_ancient_arena",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancient_arena_sticky","lua/abilities/reus_ancient_arena",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ancient_arena_caster","lua/abilities/reus_ancient_arena",LUA_MODIFIER_MOTION_NONE)

function reus_ancient_arena:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_ElderTitan.EchoStomp.Channel")

	return true
end

function reus_ancient_arena:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_ElderTitan.EchoStomp.Channel")
end

function reus_ancient_arena:OnSpellStart()
	local caster = self:GetCaster()
	local pos = caster:GetAbsOrigin()

	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	caster:EmitSound("Hero_ElderTitan.EchoStomp")

	CreateModifierThinker( caster, self, "modifier_ancient_arena",
		{Duration=duration+0.25},
		pos, caster:GetTeamNumber(), false )

end

modifier_ancient_arena_caster = class({})

function modifier_ancient_arena_caster:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
	return func
end

function modifier_ancient_arena_caster:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

modifier_ancient_arena_sticky = class({})

-- function modifier_ancient_arena_sticky:GetAttributes()
-- 	return MODIFIER_ATTRIBUTE_PERMANENT
-- end

modifier_ancient_arena = class({})

function modifier_ancient_arena:OnCreated(kv)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local pos = self:GetParent():GetAbsOrigin()
		local duration = self:GetDuration()-0.05
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		self.particle = CreateParticleWorld(self:GetParent():GetAbsOrigin(), "particles/units/heroes/hero_reus/reus_rockfall.vpcf",{
			[2] = Vector(radius,0,0)
		})
		-- ParticleManager:SetParticleControl(self.particle, 2, Vector(radius,0,0)) --[[Returns:void
		-- Set the control point data for a control on a particle effect
		-- ]]

		ScreenShake(caster:GetAbsOrigin(), 250, 5, 1, 1000*1.5, 0, true)

		Timers:CreateTimer(duration,function()
			ParticleManager:DestroyParticle(self.particle,false)
		end)

		Timers:CreateTimer(0.6,function()
			caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact")
			caster:EmitSound("Hero_EarthSpirit.StoneRemnant.Impact")

			ScreenShake(caster:GetAbsOrigin(), 1000, 5, 1, 1000*1.5, 0, true)

			caster:AddNewModifier(caster, self:GetAbility(), "modifier_ancient_arena_caster", {Duration=duration})

			local entities = FindEntities(caster,pos,radius)

			for k,v in pairs(entities) do
				print(v:GetName())
				v:AddNewModifier(caster, self:GetAbility(), "modifier_ancient_arena_sticky", {Duration=duration})
			end

			self:StartIntervalThink(0.03)
		end)
	end
end

function modifier_ancient_arena:OnIntervalThink()
	if IsServer() then
		local entities = FindEntities(self:GetAbility():GetCaster(),Vector(0,0,0),FIND_UNITS_EVERYWHERE)
		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local buffer = 100
		local range_to_ignore = radius + 2000

		local duration = self:GetRemainingTime()

		for k,v in pairs(entities) do

			if v:IsAlive() then
				if ( v:GetRangeToUnit(self:GetParent()) < ( radius ) ) then
					if ( v:GetCreationTime() >= GameRules:GetGameTime() - 0.3 ) then
						-- If the unit we're checking was created in the last 0.3s, then
						-- Apply sticky since they were spawned inside the arena

						v:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_ancient_arena_sticky", {Duration=duration})
					end

					if ( not v:HasModifier("modifier_ancient_arena_sticky") ) then
						local vpos = v:GetAbsOrigin()
						local ppos = self:GetParent():GetAbsOrigin()
						local dir = ( vpos - ppos ):Normalized()
						local rdir = ( ppos - vpos ):Normalized()

						FindClearSpaceForUnit(v,
							(dir*(radius+buffer))+self:GetParent():GetAbsOrigin(),
							true)
					end
				else
					if ( v:HasModifier("modifier_ancient_arena_sticky") ) then
						local vpos = v:GetAbsOrigin()
						local ppos = self:GetParent():GetAbsOrigin()
						local dir = ( vpos - ppos ):Normalized()
						local rdir = ( ppos - vpos ):Normalized()

						FindClearSpaceForUnit(v,
							(dir*(radius-buffer))+self:GetParent():GetAbsOrigin(),
							true)
					end
				end
			end
		end
	end
end