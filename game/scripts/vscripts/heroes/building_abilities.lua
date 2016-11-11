function SetHealth(keys)
	local caster = keys.target
	local hp = keys.hp

	print(caster:GetName())

	if caster:HasModifier("modifier_invulnerable") then
		caster:RemoveModifierByName("modifier_invulnerable")
		Timers:CreateTimer(0.03,function() caster:AddNewModifier(caster, nil, "modifier_invulnerable", {}) end)
	end

	local ch = caster:GetMaxHealth()

	local fh = ch+hp

	print(fh.." HP")

	caster:SetMaxHealth(fh)
	caster:SetHealth(fh)
end