war_warbellow = class({})

LinkLuaModifier("modifier_warbellow","lua/abilities/war_warbellow",LUA_MODIFIER_MOTION_NONE)

function war_warbellow:OnSpellStart()
    if not IsServer() then return end
    
	local caster = self:GetCaster()
    local caster_pos = caster:GetAbsOrigin()

    local propagation_radius = self:GetSpecialValueFor("propagation_radius")
    local propagation_time = self:GetSpecialValueFor("propagation_time")
    local propagation_time_minimum = self:GetSpecialValueFor("propagation_time_minimum")

    local radius = self:GetSpecialValueFor("radius")
    local damage = self:GetSpecialValueFor("damage")

	local allies = FindAllies(caster, caster_pos, -1, DOTA_UNIT_TARGET_HERO)

    for k,v in pairs(allies) do
        -- local vrange = v:GetRangeToUnit( caster )

        if not v:IsRealHero() then return end

        -- time to reach unit
        -- local time = math.max( propagation_time_minimum, (vrange / propagation_radius) * propagation_time)

        -- Timers:CreateTimer( time, function()
            self:Bellow(v, radius, damage)
        -- end)
    end
end

function war_warbellow:Bellow(unit, radius, damage)
    if not IsServer() then return end

    local reflect_duration = self:GetSpecialValueFor("reflect_duration")

    local p = ParticleManager:CreateParticle("particles/units/heroes/hero_war/fight_me_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl(p, 1, Vector(radius,0,0))
    unit:EmitSound("Hero_Axe.Berserkers_Call")

    if not unit:IsRealHero() then
        damage = damage / 4
    end
    
    local enemies = FindEnemies(self:GetCaster(), unit:GetAbsOrigin(), radius)

    for k,v in pairs(enemies) do
        DealDamage(v, self:GetCaster(), damage, self:GetAbilityDamageType(), self, 0)
    end

    unit:AddNewModifier(self:GetCaster(), self, "modifier_warbellow", {Duration=reflect_duration})
end

--------------------------------------------------------------------------------------------------------------

modifier_warbellow = class({})

function modifier_warbellow:IsHidden() return false end
function modifier_warbellow:IsPurgable() return false end

function modifier_warbellow:OnCreated(kv)
    --particle
    --sound
end

function modifier_warbellow:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_warbellow:OnTakeDamage(params)
    if not IsServer() then return end
    -- return a percentage of damage taken

    -- PrintTable(params)

    if params.unit == self:GetParent() then
        if params.original_damage > 0 then

            if damage_flags ~= nil then
                if ( bit.band(params.damage_flags, DAMAGE_FLAG_REFLECTION) == DAMAGE_FLAG_REFLECTION ) then
                    return
                end
            end

            local reflect = self:GetAbility():GetSpecialValueFor("reflect")
            local reflected_damage = params.original_damage * (reflect / 100)

            DealDamage(params.attacker, self:GetCaster(), reflected_damage, params.damage_type, self:GetAbility(), DAMAGE_FLAG_REFLECTION)
        end
    end
end

function modifier_warbellow:GetEffectName()
    return "particles/units/heroes/hero_war/warbellow_reflect.vpcf"
end