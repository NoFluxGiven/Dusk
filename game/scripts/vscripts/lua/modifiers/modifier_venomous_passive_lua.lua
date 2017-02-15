modifier_venomous_passive_lua = class({})

function modifier_venomous_passive_lua:DeclareFunctions()
	local func = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return func
end

function modifier_venomous_passive_lua:OnAttackLanded( params )
	local att = params.attacker
	local dmg = params.attack_damage
	local unit = params.unit or params.target
	local dur = GetModifierSV(self,"duration")

	if att ~= self:GetParent() then return end

	if att:GetTeam() == unit:GetTeam() or CheckClass(unit,"npc_dota_building") then
		return
	end

	unit:AddNewModifier(att, self:GetAbility(), "modifier_venomous_lua", {Duration = dur}) --[[Returns:void
	No Description Set
	]]
end