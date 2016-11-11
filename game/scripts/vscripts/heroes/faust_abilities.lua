function shockbolt(keys)
	local caster = keys.caster
	local target = keys.target

	local tmana = target:GetMana()
	local cint = caster:GetIntellect()

	local mult = keys.dmg

	local dmg = cint * mult

	if dmg > tmana then
		dmg = tmana
	end

	target:ReduceMana(dmg)
	DealDamage(target,caster,dmg,DAMAGE_TYPE_MAGICAL)
end

function CheckWis(keys)
	local caster = keys.caster
	local target = keys.target or keys.unit

	local iu = keys.iu
	local ih = keys.ih

	local grant = iu

	if target:IsRealHero() then
		grant = ih
	end

	if target:IsControllableByAnyPlayer() and not target:IsRealHero() then
		grant = 0.1
	end

	local int = caster:GetBaseIntellect()
	caster:SetBaseIntellect(int+grant) --[[Returns:void
	No Description Set
	]]
	caster:CalculateStatBonus()
end