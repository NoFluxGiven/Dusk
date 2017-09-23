
--LinkLuaModifier("modifier_name","lua/abilities/ability_name",LUA_MODIFIER_MOTION_NONE)

-- Credits To DoctorGester
modifierFunctions = {
    MODIFIER_EVENT_ON_ABILITY_END_CHANNEL = "OnAbilityEndChannel",
    MODIFIER_EVENT_ON_ABILITY_EXECUTED = "OnAbilityExecuted",
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = "OnAbilityFullyCast",
    MODIFIER_EVENT_ON_ABILITY_START = "OnAbilityStart",
    MODIFIER_EVENT_ON_ATTACK = "OnAttack",
    MODIFIER_EVENT_ON_ATTACKED = "OnAttacked",
    MODIFIER_EVENT_ON_ATTACK_ALLIED = "OnAttackAllied",
    MODIFIER_EVENT_ON_ATTACK_FAIL = "OnAttackFail",
    MODIFIER_EVENT_ON_ATTACK_FINISHED = "OnAttackFinished",
    MODIFIER_EVENT_ON_ATTACK_LANDED = "OnAttackLanded",
    MODIFIER_EVENT_ON_ATTACK_RECORD = "OnAttackRecord",
    MODIFIER_EVENT_ON_ATTACK_START = "OnAttackStart",
    MODIFIER_EVENT_ON_BREAK_INVISIBILITY = "OnBreakInvisibility",
    MODIFIER_EVENT_ON_BUILDING_KILLED = "OnBuildingKilled",
    MODIFIER_EVENT_ON_DEATH = "OnDeath",
    MODIFIER_EVENT_ON_DOMINATED = "OnDominated",
    MODIFIER_EVENT_ON_HEALTH_GAINED = "OnHealthGained",
    MODIFIER_EVENT_ON_HEAL_RECEIVED = "OnHealReceived",
    MODIFIER_EVENT_ON_HERO_KILLED = "OnHeroKilled",
    MODIFIER_EVENT_ON_MANA_GAINED = "OnManaGained",
    MODIFIER_EVENT_ON_MODEL_CHANGED = "OnModelChanged",
    MODIFIER_EVENT_ON_ORB_EFFECT = "",
    MODIFIER_EVENT_ON_ORDER = "OnOrder",
    MODIFIER_EVENT_ON_PROCESS_UPGRADE = "",
    MODIFIER_EVENT_ON_PROJECTILE_DODGE = "OnProjectileDodge",
    MODIFIER_EVENT_ON_REFRESH = "",
    MODIFIER_EVENT_ON_RESPAWN = "OnRespawn",
    MODIFIER_EVENT_ON_SET_LOCATION = "OnSetLocation",
    MODIFIER_EVENT_ON_SPELL_TARGET_READY = "OnSpellTargetReady",
    MODIFIER_EVENT_ON_SPENT_MANA = "OnSpentMana",
    MODIFIER_EVENT_ON_STATE_CHANGED = "OnStateChanged",
    MODIFIER_EVENT_ON_TAKEDAMAGE = "OnTakeDamage",
    MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT = "OnTakeDamageKillCredit",
    MODIFIER_EVENT_ON_TELEPORTED = "OnTeleported",
    MODIFIER_EVENT_ON_TELEPORTING = "OnTeleporting",
    MODIFIER_EVENT_ON_UNIT_MOVED = "OnUnitMoved",
    MODIFIER_FUNCTION_INVALID = "",
    MODIFIER_FUNCTION_LAST = "",
    MODIFIER_PROPERTY_ABILITY_LAYOUT = "GetModifierAbilityLayout",
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL = "GetAbsoluteNoDamageMagical",
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL = "GetAbsoluteNoDamagePhysical",
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE = "GetAbsoluteNoDamagePure",
    MODIFIER_PROPERTY_ABSORB_SPELL = "GetAbsorbSpell",
    MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK = "GetAlwaysAllowAttack",
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = "GetModifierAttackSpeedBonus_Constant",
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT_POWER_TREADS = "GetModifierAttackSpeedBonus_Constant_PowerTreads",
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT_SECONDARY = "GetModifierAttackSpeedBonus_Constant_Secondary",
    MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT = "GetModifierAttackPointConstant",
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS = "GetModifierAttackRangeBonus",
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE = "GetModifierAttackRangeBonusUnique",
    MODIFIER_PROPERTY_AVOID_DAMAGE = "GetModifierAvoidDamage",
    MODIFIER_PROPERTY_AVOID_SPELL = "GetModifierAvoidSpell",
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE = "GetModifierBaseAttack_BonusDamage",
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE = "GetModifierBaseDamageOutgoing_Percentage",
    MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE_UNIQUE = "GetModifierBaseDamageOutgoing_PercentageUnique",
    MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = "GetModifierBaseAttackTimeConstant",
    MODIFIER_PROPERTY_BASE_MANA_REGEN = "GetModifierBaseRegen",
    MODIFIER_PROPERTY_BONUS_DAY_VISION = "GetBonusDayVision",
    MODIFIER_PROPERTY_BONUS_NIGHT_VISION = "GetBonusNightVision",
    MODIFIER_PROPERTY_BONUS_NIGHT_VISION_UNIQUE = "GetBonusNightVisionUnique",
    MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE = "GetBonusVisionPercentage",
    MODIFIER_PROPERTY_BOUNTY_CREEP_MULTIPLIER = "GetModifierBountyCreepMultiplier",
    MODIFIER_PROPERTY_BOUNTY_OTHER_MULTIPLIER = "GetModifierBountyOtherMultiplier",
    MODIFIER_PROPERTY_CASTTIME_PERCENTAGE = "GetModifierPercentageCasttime",
    MODIFIER_PROPERTY_CAST_RANGE_BONUS = "GetModifierCastRangeBonus",
    MODIFIER_PROPERTY_CHANGE_ABILITY_VALUE = "GetModifierChangeAbilityValue",
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE = "GetModifierPercentageCooldown",
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING = "GetModifierPercentageCooldownStacking",
    MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT = "GetModifierCooldownReduction_Constant",
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE = "GetModifierDamageOutgoing_Percentage",
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION = "GetModifierDamageOutgoing_Percentage_Illusion",
    MODIFIER_PROPERTY_DEATHGOLDCOST = "GetModifierConstantDeathGoldCost",
    MODIFIER_PROPERTY_DISABLE_AUTOATTACK = "GetDisableAutoAttack",
    MODIFIER_PROPERTY_DISABLE_HEALING = "GetDisableHealing",
    MODIFIER_PROPERTY_DISABLE_TURNING = "GetModifierDisableTurning",
    MODIFIER_PROPERTY_EVASION_CONSTANT = "GetModifierEvasion_Constant",
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS = "GetModifierExtraHealthBonus",
    MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE = "GetModifierExtraHealthPercentage",
    MODIFIER_PROPERTY_EXTRA_MANA_BONUS = "GetModifierExtraManaBonus",
    MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS = "GetModifierExtraStrengthBonus",
    MODIFIER_PROPERTY_FIXED_DAY_VISION = "GetFixedDayVision",
    MODIFIER_PROPERTY_FIXED_NIGHT_VISION = "GetFixedNightVision",
    MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP = "GetForceDrawOnMinimap",
    MODIFIER_PROPERTY_HEALTH_BONUS = "GetModifierHealthBonus",
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = "GetModifierConstantHealthRegen",
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = "GetModifierHealthRegenPercentage",
    MODIFIER_PROPERTY_IGNORE_CAST_ANGLE = "GetModifierIgnoreCastAngle",
    MODIFIER_PROPERTY_IGNORE_COOLDOWN = "GetModifierIgnoreCooldown",
    MODIFIER_PROPERTY_ILLUSION_LABEL = "GetModifierIllusionLabel",
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = "GetModifierIncomingDamage_Percentage",
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT = "GetModifierIncomingPhysicalDamageConstant",
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = "GetModifierIncomingPhysicalDamage_Percentage",
    MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT = "GetModifierIncomingSpellDamageConstant",
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL = "GetModifierInvisibilityLevel",
    MODIFIER_PROPERTY_IS_ILLUSION = "GetIsIllusion",
    MODIFIER_PROPERTY_IS_SCEPTER = "GetModifierScepter",
    MODIFIER_PROPERTY_LIFETIME_FRACTION = "GetUnitLifetimeFraction",
    MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK = "GetModifierMagical_ConstantBlock",
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS = "GetModifierMagicalResistanceBonus",
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE = "GetModifierMagicalResistanceDecrepifyUnique",
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_ITEM_UNIQUE = "GetModifierMagicalResistanceItemUnique",
    MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE = "GetModifierMagicDamageOutgoing_Percentage",
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE = "GetModifierPercentageManacost",
    MODIFIER_PROPERTY_MANA_BONUS = "GetModifierManaBonus",
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = "GetModifierConstantManaRegen",
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE = "GetModifierConstantManaRegenUnique",
    MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE = "GetModifierPercentageManaRegen",
    MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE = "GetModifierTotalPercentageManaRegen",
    MODIFIER_PROPERTY_MAX_ATTACK_RANGE = "GetModifierMaxAttackRange",
    MODIFIER_PROPERTY_MIN_HEALTH = "GetMinHealth",
    MODIFIER_PROPERTY_MISS_PERCENTAGE = "GetModifierMiss_Percentage",
    MODIFIER_PROPERTY_MODEL_CHANGE = "GetModifierModelChange",
    MODIFIER_PROPERTY_MODEL_SCALE = "GetModifierModelScale",
    MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE = "GetModifierMoveSpeed_Absolute",
    MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN = "GetModifierMoveSpeed_AbsoluteMin",
    MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE = "GetModifierMoveSpeedOverride",
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = "GetModifierMoveSpeedBonus_Constant",
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = "GetModifierMoveSpeedBonus_Percentage",
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE = "GetModifierMoveSpeedBonus_Percentage_Unique",
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE_2 = "GetModifierMoveSpeedBonus_Percentage_Unique_2",
    MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE = "GetModifierMoveSpeedBonus_Special_Boots",
    MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE_2 = "GetModifierMoveSpeedBonus_Special_Boots_2",
    MODIFIER_PROPERTY_MOVESPEED_LIMIT = "GetModifierMoveSpeed_Limit",
    MODIFIER_PROPERTY_MOVESPEED_MAX = "GetModifierMoveSpeed_Max",
    MODIFIER_PROPERTY_NEGATIVE_EVASION_CONSTANT = "GetModifierNegativeEvasion_Constant",
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION = "GetOverrideAnimation",
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE = "GetOverrideAnimationRate",
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT = "GetOverrideAnimationWeight",
    MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL = "GetOverrideAttackMagical",
    MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY = "GetModifierPersistentInvisibility",
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = "GetModifierPhysicalArmorBonus",
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_ILLUSIONS = "GetModifierPhysicalArmorBonusIllusions",
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE = "GetModifierPhysicalArmorBonusUnique",
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE = "GetModifierPhysicalArmorBonusUniqueActive",
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK = "GetModifierPhysical_ConstantBlock",
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL = "GetModifierPhysical_ConstantBlockSpecial",
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE = "GetModifierPreAttack_BonusDamage",
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT = "GetModifierPreAttack_BonusDamagePostCrit",
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE = "GetModifierPreAttack_CriticalStrike",
    MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE = "GetModifierPreAttack_Target_CriticalStrike",
    MODIFIER_PROPERTY_PRESERVE_PARTICLES_ON_MODEL_CHANGE = "PreserveParticlesOnModelChanged",
    MODIFIER_PROPERTY_PRE_ATTACK = "GetModifierPreAttack",
    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL = "GetModifierProcAttack_BonusDamage_Magical",
    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL = "GetModifierProcAttack_BonusDamage_Physical",
    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE = "GetModifierProcAttack_BonusDamage_Pure",
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK = "GetModifierProcAttack_Feedback",
    MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS = "GetModifierProjectileSpeedBonus",
    MODIFIER_PROPERTY_PROVIDES_FOW_POSITION = "GetModifierProvidesFOWVision",
    MODIFIER_PROPERTY_REFLECT_SPELL = "GetReflectSpell",
    MODIFIER_PROPERTY_REINCARNATION = "ReincarnateTime",
    MODIFIER_PROPERTY_RESPAWNTIME = "GetModifierConstantRespawnTime",
    MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE = "GetModifierPercentageRespawnTime",
    MODIFIER_PROPERTY_RESPAWNTIME_STACKING = "GetModifierStackingRespawnTime",
    MODIFIER_PROPERTY_SPELLS_REQUIRE_HP = "GetModifierSpellsRequireHP",
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE = "GetModifierSpellAmplify_Percentage",
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS = "GetModifierBonusStats_Agility",
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = "GetModifierBonusStats_Intellect",
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = "GetModifierBonusStats_Strength",
    MODIFIER_PROPERTY_SUPER_ILLUSION = "GetModifierSuperIllusion",
    MODIFIER_PROPERTY_SUPER_ILLUSION_WITH_ULTIMATE = "GetModifierSuperIllusionWithUltimate",
    MODIFIER_PROPERTY_TEMPEST_DOUBLE = "GetModifierTempestDouble",
    MODIFIER_PROPERTY_TOOLTIP = "OnTooltip",
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE = "GetModifierTotalDamageOutgoing_Percentage",
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK = "GetModifierTotal_ConstantBlock",
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR = "GetModifierPhysical_ConstantBlockUnavoidablePreArmor",
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = "GetActivityTranslationModifiers",
    MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND = "GetAttackSound",
    MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE = "GetModifierTurnRate_Percentage",
    MODIFIER_PROPERTY_UNIT_STATS_NEEDS_REFRESH = "GetModifierUnitStatsNeedsRefresh",
    MODIFIER_PROPERTY_EXP_RATE_BOOST = "Unknown",
    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING ="Unknown",
    MODIFIER_PROPERTY_FIXED_ATTACK_RATE= "Unknown",
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE= "Unknown",
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION = "Unknown",
    MODIFIER_PROPERTY_INCOMING_DAMAGE_ILLUSION= "Unknown"

}
function GenericModifier(definition, states, properties)
    local modifier = class({})

    for property, value in pairs(definition) do
        modifier[property] = function(self)
            if type(value) == "function" then
                return value(self)
            end

            return value
        end
    end

    modifier.CheckState = function()
        local finalState = {}

        for _, state in ipairs(states) do
            finalState[state] = true
        end

        return finalState
    end

    modifier.DeclareFunctions = function()
        local funcs = {}

        for property, _ in pairs(properties) do
            table.insert(funcs, _G[property])
        end

        return funcs
    end

    for property, value in pairs(properties) do
        if modifierFunctions[property] then
            modifier[modifierFunctions[property]] = function(self)
                if type(value) == "function" then
                    return value(self)
                end

                return value
            end
        end
    end

    return modifier
end
