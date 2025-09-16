if CustomBarriers == nil then CustomBarriers = {} end

-- Created by Cykada (@oniisama on discord)
-- Version 1.1.0 (lib)
-- check https://moddota.com/abilities/lua-modifiers/5 for a guide

function CustomBarriers:__GetBarrierOptions()
    
    --? All damage barriers will not block physical or magical (doesn't effect HP Removal)
    self.ALL_BARRIER_ONLY_BLOCKS_PURE = false

    --? All damage barrier will also block hp removal flagged damage
    self.ALL_BARRIER_BLOCK_HP_REMOVAL = false

    --? Whether barriers will have a blocked damage overhead alert
    self.SHOW_BARRIER_BLOCK_OVERHEAD_ALERT = true

end

--=======================================================================================

function CustomBarriers:TurnModifierIntoBarrier( mod )

    -- inject the barriers into the declared functions
    if mod.DeclareFunctions ~= nil and mod:DeclareFunctions() ~= nil then 
        mod.__OldDeclareFunctions = mod.DeclareFunctions 
    else mod.__OldDeclareFunctions = function(self) return {} end end
    
    mod.DeclareFunctions = function(self)
        local declared_funcs = self:__OldDeclareFunctions()
        table.insert( declared_funcs, MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT )
        table.insert( declared_funcs, MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT )
        table.insert( declared_funcs, MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT )
        return declared_funcs
    end
    mod.GetModifierIncomingPhysicalDamageConstant = self.GetModifierIncomingPhysicalDamageConstant
    mod.GetModifierIncomingSpellDamageConstant = self.GetModifierIncomingSpellDamageConstant
    mod.GetModifierIncomingDamageConstant = self.GetModifierIncomingDamageConstant

    mod.HandleCustomTransmitterData = function(self, data) for k,v in pairs(data) do self[k] = v end end

    -- add the setup to OnCreated()
    if mod.OnCreated ~= nil then 
        mod.__OldOnCreated = mod.OnCreated else mod.__OldOnCreated = function() end
    end
    mod.OnCreated = function(self, kv)
        self:__OldOnCreated(kv)
        if IsServer() then CustomBarriers:__SetupBarrierModifier(self) end
    end
    
    -- append a client update to OnRefresh()
    if mod.OnRefresh ~= nil then 
        mod.__OldOnRefresh = mod.OnRefresh else mod.__OldOnRefresh = function(self) return end 
    end
    mod.OnRefresh = function(self, kv)
        self:__OldOnRefresh(kv)
        self:OnCreated(kv)
        if IsServer() then self:__BarrierUpdate() end
    end

    -- check if they have made a damage filter
    if mod.OnBarrierDamagedFilter == nil then mod.OnBarrierDamagedFilter = function(self) return true end end

    -- new functions that can just be copied over, respect tweaks
    local general_funcs = {
        "__IsBarrier",
        "IsBarrierFor",
        "SetBarrierType",
        --"GetBarrierType",
        "SetBarrierMaxHealth",
        --"GetBarrierMaxHealth",
        "SetBarrierHealth",
        "GetBarrierHealth",
        "SetBarrierInitialHealth",
        "GetBarrierInitialHealth",
        "IsPersistent",
        "ShowOnZeroHP",
        "__BarrierUpdate",
        "__DoBarrierBlock",
        "__GetBarrierOptions",
    }
    for _,func in ipairs(general_funcs) do if mod[func] == nil then mod[func] = self[func] end end
end

function CustomBarriers:__SetupBarrierModifier(mod)

    -- Missing data error handler
    local error_msg = "CustomBarriers Error: Undeclared barrier initialisation properties!"
    local missing_props = {}
    if mod.GetBarrierType == nil and mod.__barrier_type == nil then table.insert(missing_props, "- Type") end
    if mod.GetBarrierMaxHealth == nil and mod.__max_barrier_health == nil then table.insert(missing_props, "- Max Health") end
    if #missing_props > 0 then
        print("Missing Properties;")
        for _,s in ipairs(missing_props) do print(s) end
        return
    end

    -- setup the internal properties
    if mod.GetBarrierType ~= nil then mod.__barrier_type = mod:GetBarrierType() end
    mod.GetBarrierType = function(self) return self.__barrier_type end

    if mod.GetBarrierMaxHealth ~= nil then mod.__max_barrier_health = mod:GetBarrierMaxHealth() end
    mod.GetBarrierMaxHealth = function (self) return self.__max_barrier_health end

    if mod.GetBarrierInitialHealth ~= nil then mod.__initial_barrier_health = mod:GetBarrierInitialHealth() end
    mod.GetBarrierInitialHealth = function (self) return self.__initial_barrier_health end

    mod.__current_barrier_health = mod.__initial_barrier_health

    -- add the internal properties to the transmitter
    if mod.__OldAddCustomTransmitterData == nil then 
        if mod.AddCustomTransmitterData ~= nil and mod:AddCustomTransmitterData() ~= nil then 
            mod.__OldAddCustomTransmitterData = mod.AddCustomTransmitterData 
        else mod.__OldAddCustomTransmitterData = function(self) return {} end end
        mod.AddCustomTransmitterData = function(self)
            local transmit_data = self:__OldAddCustomTransmitterData()
            transmit_data.__barrier_type = mod.__barrier_type
            transmit_data.__max_barrier_health = mod.__max_barrier_health
            transmit_data.__current_barrier_health = mod.__current_barrier_health
            transmit_data.__initial_barrier_health = mod.__initial_barrier_health
            return transmit_data
        end
    end

    -- add the options
    mod:__GetBarrierOptions()

    -- send the new data to the client
    mod:SetHasCustomTransmitterData(true)
end

-- generic handler for when the barrier values are changed
function CustomBarriers:__BarrierUpdate()
    if self.__current_barrier_health == nil then self.__current_barrier_health = 1 end

    if not self:IsPersistent() then 
        if self.__current_barrier_health <= 0 then return self:Destroy() end
    else self.__current_barrier_health = math.max(0, self.__current_barrier_health) end

    if self.__max_barrier_health ~= nil then
        self.__current_barrier_health = math.min( self.__current_barrier_health, self.__max_barrier_health )
    end 

    self:SendBuffRefreshToClients() 
end

-- set / get barrier type
function CustomBarriers:GetBarrierType() return DAMAGE_TYPE_ALL end
function CustomBarriers:SetBarrierType(dmg_type) 
    self.__barrier_type = dmg_type
    self:__BarrierUpdate()
end

-- destroy on 0 hp, show on 0 hp
function CustomBarriers:IsPersistent() return false end
function CustomBarriers:ShowOnZeroHP() return false end

function CustomBarriers:__IsBarrier()
    if not self:ShowOnZeroHP() and self.__current_barrier_health <= 0 then return false else return true end
end

-- compare the damage type to what the respective barrier blocks
function CustomBarriers:IsBarrierFor(dmg_type)
    if self:IsPersistent() then
        if self.__current_barrier_health <= 0 and not self:ShowOnZeroHP() then
            return false
        end
    end

    local b = self.__barrier_type
    if b == dmg_type then return true end
    if IsClient() then return false end

    if b == DAMAGE_TYPE_PURE or b == DAMAGE_TYPE_ALL then
        local not_pure = (dmg_type == DAMAGE_TYPE_PHYSICAL or dmg_type == DAMAGE_TYPE_MAGICAL)
        if self.ALL_BARRIER_ONLY_BLOCKS_PURE and not_pure then return false end
        return true
    end
        
    return false
end

-- set / get barrier max health
function CustomBarriers:SetBarrierMaxHealth(amount) 
    self.__max_barrier_health = math.ceil(amount)
    self:__BarrierUpdate()
end
function CustomBarriers:GetBarrierMaxHealth() return self.__max_barrier_health end

-- set / get barrier health
function CustomBarriers:GetBarrierHealth() return self.__current_barrier_health end
function CustomBarriers:SetBarrierHealth(amount) 
    self.__current_barrier_health = math.ceil(amount)
    self:__BarrierUpdate()
end
function CustomBarriers:GetBarrierInitialHealth() return self.__initial_barrier_health or self.__max_barrier_health end
function CustomBarriers:SetBarrierInitialHealth(amount) self.__initial_barrier_health = amount end

-- functions for handling the damage block
function CustomBarriers:GetModifierIncomingPhysicalDamageConstant(keys) return self:__DoBarrierBlock(1, keys) end
function CustomBarriers:GetModifierIncomingSpellDamageConstant(keys) return self:__DoBarrierBlock(2, keys) end
function CustomBarriers:GetModifierIncomingDamageConstant(keys) return self:__DoBarrierBlock(4, keys) end

function CustomBarriers:__DoBarrierBlock(d, keys)
    if IsClient() then

        -- check and report hp on client
        if not self:IsBarrierFor(d) then return end
        if keys.report_max then return self.__max_barrier_health else return self.__current_barrier_health end 
    else

        -- check damage on server
        if keys.attacker == self:GetParent() then return 0 end
        if not self:IsBarrierFor(keys.damage_type) then return 0 end

        -- check if we want to block hp loss
        if not self.ALL_BARRIER_BLOCK_HP_REMOVAL then 
            if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
                return 0
            end
        end

        -- call the filter
        if not self:OnBarrierDamagedFilter(keys) then return keys.damage end
    end

    -- Don't block more than the barrier hp
    local blocked_amount = math.min(keys.damage, self.__current_barrier_health)
    self.__current_barrier_health = self.__current_barrier_health - blocked_amount
    self:__BarrierUpdate()

    -- block visual
    if self.SHOW_BARRIER_BLOCK_OVERHEAD_ALERT and blocked_amount > 0 then
        SendOverheadEventMessage(
            self:GetParent():GetPlayerOwner(), 
            OVERHEAD_ALERT_BLOCK, 
            self:GetParent(), 
            blocked_amount, 
            keys.attacker:GetPlayerOwner()
        )
    end

    return -blocked_amount
end

-- damage filter
function CustomBarriers:OnBarrierDamagedFilter(keys) return true end

-- yeah I'm cheating, shut up
function CDOTA_Buff:IsBarrier() if self.__IsBarrier ~= nil then return self:__IsBarrier() else return false end end