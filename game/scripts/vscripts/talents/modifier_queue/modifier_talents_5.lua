require('talents/modifier_overhead')

if not IsServer() then
    desiredModifierName = CustomNetTables:GetTableValue("talent_manager", "last_learned_talent_5")["v"]
    modifierTable = CustomNetTables:GetTableValue("talent_manager", "server_to_lua_talent_properties_" ..  desiredModifierName)
end

_G[desiredModifierName] = GenericModifier(
    {
        IsDebuff = false,
        IsPermanent = true,
        IsPurgable = false,
        DestroyOnExpire = false,
        IsHidden = true,
    },
    {
    },
    modifierTable
)