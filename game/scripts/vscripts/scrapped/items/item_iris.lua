function CopyBuffs(keys)
	local caster = keys.caster
	local target = keys.target

	local buff_stun = "modifier_iris_stunned"
	local buff_silenced = "modifier_iris_silence"
	local buff_disarmed = "modifier_iris_disarm"
	local buff_rooted = "modifier_iris_rooted"
	local buff_blind = "modifier_iris_blind"
	local buff_muted = "modifier_iris_muted"

	if caster:IsOutOfGame() or caster:IsInvulnerable() then return end

	if caster:IsStunned() then
		keys.ability:ApplyDataDrivenModifier(caster, target, buff_stun, {Duration=0.2}) --[[Returns:void
		No Description Set
		]]
	end
	if caster:IsSilenced() then
		keys.ability:ApplyDataDrivenModifier(caster, target, buff_silenced, {Duration=0.2}) --[[Returns:void
		No Description Set
		]]
	end
	if caster:IsDisarmed() then
		keys.ability:ApplyDataDrivenModifier(caster, target, buff_disarmed, {Duration=0.2}) --[[Returns:void
		No Description Set
		]]
	end
	if caster:IsRooted() then
		keys.ability:ApplyDataDrivenModifier(caster, target, buff_rooted, {Duration=0.2}) --[[Returns:void
		No Description Set
		]]
	end
	if caster:IsBlind() then
		keys.ability:ApplyDataDrivenModifier(caster, target, buff_blind, {Duration=0.2}) --[[Returns:void
		No Description Set
		]]
	end
	if caster:IsMuted() then
		keys.ability:ApplyDataDrivenModifier(caster, target, buff_muted, {Duration=0.2}) --[[Returns:void
		No Description Set
		]]
	end
end