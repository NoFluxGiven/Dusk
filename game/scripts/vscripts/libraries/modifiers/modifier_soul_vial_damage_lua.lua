modifier_soul_vial_damage_lua = class({})

function modifier_soul_vial_damage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

function modifier_soul_vial_damage_lua:GetModifierPreAttack_BonusDamage(params)
	local charges = 0

	local amount = 0

	local damage_per_charge = 2

	for i=0, 5, 1 do
        local current_item = self:GetCaster():GetItemInSlot(i)
    	if current_item ~= nil and current_item:GetName() == "item_soul_vial" then
			amount = current_item:GetCurrentCharges()
       	end
    end

    if amount > 0 then
    	charges = amount*damage_per_charge
    end

    return charges
end