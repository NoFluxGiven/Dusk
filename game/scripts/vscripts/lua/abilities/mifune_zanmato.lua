mifune_zanmato = class({})

LinkLuaModifier("modifier_zanmato_target","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zanmato_main_target","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zanmato_target_hero","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zanmato_caster","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zanmato_dummy","lua/abilities/mifune_zanmato",LUA_MODIFIER_MOTION_NONE)

function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function mifune_zanmato:OnSpellStart()
	if IsServer() then
		-- Cannot cast multiple stacks
		if self:GetCaster().zanmato_active ~= nil and self:GetCaster().zanmato_action == true then
			self:RefundManaCost()
			self:EndCooldown()
			return nil
		end

		-- Inheritted variables
		local caster = self:GetCaster()
		local main_target = self:GetCursorTarget()
		local targetPoint = main_target:GetAbsOrigin() - Vector(0,0,175)
		local ability = self
		local radius = ability:GetSpecialValueFor( "radius" )
		local attack_interval = ability:GetSpecialValueFor( "attack_interval" )
		local modifierTargetName = "modifier_zanmato_target"
		local modifierTargetMainName = "modifier_zanmato_main_target"
		local modifierHeroName = "modifier_zanmato_target_hero"
		local casterModifierName = "modifier_zanmato_caster"
		local dummyModifierName = "modifier_zanmato_dummy"
		local particleSlashName = "particles/units/heroes/hero_mifune/bushido_counter_attack.vpcf"
		local particleTrailName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
		local particleCastName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
		local slashSound = "Hero_EmberSpirit.SleightOfFist.Damage"
		
		-- Targeting variables
		local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
		local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
		local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS
		local unitOrder = FIND_ANY_ORDER
		
		-- Necessary varaibles
		local counter = 0
		caster.zanmato_active = true
		local dummy = CreateUnitByName( caster:GetName(), caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber() )
		dummy:AddNewModifier( caster, self, dummyModifierName, {} )

		caster:AddNewModifier( caster, self, casterModifierName, {})
		
		-- Casting particles
		local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( castFxIndex, 0, targetPoint )
		ParticleManager:SetParticleControl( castFxIndex, 1, Vector( radius, 0, 0 ) )

		local castFxIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_mifune/mifune_blossoms.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( castFxIndex2, 0, caster:GetAbsOrigin()+Vector(0,0,300))
		ParticleManager:SetParticleControl( castFxIndex2, 1, caster:GetAbsOrigin())
		
		Timers:CreateTimer( 0.1, function()
				ParticleManager:DestroyParticle( castFxIndex, false )
				ParticleManager:ReleaseParticleIndex( castFxIndex )
			end
		)
		
		-- Start function
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(), targetPoint, caster, radius, targetTeam,
			targetType, targetFlag, unitOrder, false
		)

		-- units = TableConcat(units, units)

		for _, target in pairs( units ) do
			counter = counter + 1
			Timers:CreateTimer( counter * attack_interval, function()
					-- Only jump to it if it's alive
					if target:IsAlive() then
						target:AddNewModifier( caster, self, modifierTargetName, {} )
						local trailFxIndex = ParticleManager:CreateParticle( particleTrailName, PATTACH_CUSTOMORIGIN, target )
						ParticleManager:SetParticleControl( trailFxIndex, 0, target:GetAbsOrigin() - Vector(0,0,175) )
						ParticleManager:SetParticleControl( trailFxIndex, 1, caster:GetAbsOrigin() - Vector(0,0,175) )
						
						Timers:CreateTimer( 0.1, function()
								ParticleManager:DestroyParticle( trailFxIndex, false )
								ParticleManager:ReleaseParticleIndex( trailFxIndex )
								return nil
							end
						)
						
						-- Move hero there
						FindClearSpaceForUnit( caster, target:GetAbsOrigin(), false )
						
						if target:IsHero() then
							caster:AddNewModifier(caster, self, modifierHeroName, {}) --[[Returns:void
							No Description Set
							]]
						end
						
						caster:PerformAttack( target,
							true,
							true,
							true,
							false,
							false,
							false,
							true
							)
						-- bool bUseCastAttackOrb,
						-- bool bProcessProcs,
						-- bool bSkipCooldown,
						-- bool bIgnoreInvis,
						-- bool bUseProjectile,
						-- bool bFakeAttack,
						-- bool bNeverMiss
						
						-- Slash particles
						local slashFxIndex = ParticleManager:CreateParticle( particleSlashName, PATTACH_ABSORIGIN_FOLLOW, target )
						StartSoundEvent( slashSound, caster )
						
						Timers:CreateTimer( 0.1, function()
								ParticleManager:DestroyParticle( slashFxIndex, false )
								ParticleManager:ReleaseParticleIndex( slashFxIndex )
								StopSoundEvent( slashSound, caster )
								return nil
							end
						)
						
						-- Clean up modifier
						caster:RemoveModifierByName( modifierHeroName )
					end
					return nil
				end
			)
		end

		local stuntime = counter*attack_interval+0.6

		if stuntime < 1 then stuntime = 1 end

		main_target:AddNewModifier( caster, self, modifierTargetMainName, {Duration = stuntime} )
		
		-- Return caster to origin position
		Timers:CreateTimer( ( counter + 1 ) * attack_interval, function()
				FindClearSpaceForUnit( caster, dummy:GetAbsOrigin(), false )
				dummy:RemoveSelf()
				for _,target in pairs(units) do
					target:RemoveModifierByName(modifierTargetName)
					if target ~= main_target then
					local info = 
					  {
					  Target = main_target,
					  Source = target,
					  Ability = self,  
					  EffectName = "particles/units/heroes/hero_mifune/mifune_orb.vpcf",
					  vSpawnOrigin = target:GetAbsOrigin(),
					  fDistance = distance,
					  fStartRadius = 20,
					  fEndRadius = 20,
					  bHasFrontalCone = false,
					  bReplaceExisting = false,
					  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					  iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  bDeleteOnHit = true,
					  iMoveSpeed = 950,
					  bProvidesVision = true,
					  iVisionRadius = 275,
					  iVisionTeamNumber = caster:GetTeamNumber(),
					  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
					  }
			  
			  		local projectile = ProjectileManager:CreateTrackingProjectile(info)
				end
				end
				caster:RemoveModifierByName( casterModifierName )
				caster.zanmato_active = false
				ParticleManager:DestroyParticle( castFxIndex2, false )
				return nil
			end
		)
	end
end

function mifune_zanmato:OnProjectileHit(t,l)
	if t then
		local c = self:GetCaster()
		local damage = self:GetSpecialValueFor("orb_damage")
		self:InflictDamage(t,c,damage,DAMAGE_TYPE_MAGICAL)
		--Particle
		ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ROOTBONE_FOLLOW, t)
		t:EmitSound("Hero_Jakiro.LiquidFire")
	end
end

modifier_zanmato_main_target = class({})

function modifier_zanmato_main_target:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end

modifier_zanmato_target = class({})

function modifier_zanmato_target:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf"
end

function modifier_zanmato_target:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_zanmato_target:IsHidden()
	return true
end

modifier_zanmato_caster = class({})

function modifier_zanmato_caster:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ROOTED] = true
	}
	return state
end

function modifier_zanmato_caster:IsHidden()
	return true
end

modifier_zanmato_target_hero = class({})

function modifier_zanmato_target_hero:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return func
end

function modifier_zanmato_target_hero:IsHidden()
	return true
end

function modifier_zanmato_target_hero:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_hero_damage")
end

modifier_zanmato_dummy = class({})

function modifier_zanmato_dummy:OnCreated()
	ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_zanmato_dummy:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	}
	return state
end