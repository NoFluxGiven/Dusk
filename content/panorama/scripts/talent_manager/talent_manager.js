
var levels = [10,15,20,25];
var isTalentTooltipVisible = false;
var wasTitleChanged = false;
var LastSelectedUnit = null;
var Sanitized = false;
var rows = {};
var lvl = 0;

function LocalizeText(text)
{
	if ($.Localize("talent_" + text) !== "talent_" + text) {
		return $.Localize("talent_" + text);
	}else if($.Localize("DOTA_Tooltip_ability_" + text) !== "DOTA_Tooltip_ability_" + text){
		return $.Localize("DOTA_Tooltip_ability_" + text);
	}else{
		return $.Localize(text);
	}
}


function SetText(arrOfRows)
{
	
	 var x = $.GetContextPanel().GetParent().GetParent().GetParent();
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('StatBranchDrawer')
	x = x.FindChildTraverse('statbranchdialog')
	x = x.FindChildTraverse('DOTAStatBranch')
	x = x.FindChildTraverse('StatBranchColumn')
	
	for(var i in arrOfRows) 
	{
		var row = arrOfRows[i];
		var index = parseInt(i)+1;
		var rowPanel = x.FindChildTraverse('UpgradeOption' + index); 
		
		var left = rowPanel.FindChildTraverse('CleanUpgrade' + (index * 2));
		var right = rowPanel.FindChildTraverse('CleanUpgrade' + (index * 2 - 1));
		
		left.FindChildTraverse("TextLabel").text = LocalizeText(row[0]);
		right.FindChildTraverse("TextLabel").text = LocalizeText(row[1]);
	}
	
}

function SetLevels(lvlArr)
{ 
	levels = lvlArr;
	 var x = $.GetContextPanel().GetParent().GetParent().GetParent()
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('StatBranchDrawer')
	x = x.FindChildTraverse('DOTAStatBranch').FindChildTraverse('LevelColumn')

	for(var i in lvlArr)
	{
			if(lvlArr[lvlArr.length - i - 1] < 10)
			lvlArr[lvlArr.length - i - 1] = 10;
		x.Children()[i].Children()[0].text = lvlArr[lvlArr.length - i - 1];
		//rows[i-(-1)].level = lvlArr[lvlArr.length - i - 1]; 
	}
	levels = lvlArr;
	

}

function CleanBranch(branchTier)
{
	var x = $.GetContextPanel().GetParent().GetParent().GetParent();
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('StatBranchDrawer')
	x = x.FindChildTraverse('DOTAStatBranch')
	x = x.FindChildTraverse('StatBranchColumn')
	x = x.FindChildTraverse('UpgradeOption' + branchTier);
	rows[branchTier] = x;
	
	if(x.FindChildTraverse('CleanUpgrade'+(branchTier*2)))
	{  
	//	x.FindChildTraverse('CleanUpgrade'+(branchTier*2)).DeleteAsync(0);
	//	x.FindChildTraverse('CleanUpgrade'+(branchTier*2-1)).DeleteAsync(0);
	return;  
	}
	x.selected = "none";
	
	//What is branch cleaning?
	//You have to override the upgrade button and hide the old one because the game scripts try to set its enabled and disabled status

	//Hide the old ones
	var left = x.FindChildTraverse('Upgrade' + (branchTier * 2));
	var right = x.FindChildTraverse('Upgrade' + (branchTier * 2 - 1));
	
	left.enabled = false;
	right.enabled = true;
	
	left.style.visibility = 'collapse;';
	right.style.visibility = 'collapse;';
	
	//Button - BranchChoice (left/right)Branch
	//    Label class="StatBonusLabel
	//create new ones
	var left_new = $.CreatePanel('Button', x, 'CleanUpgrade'+ (branchTier * 2));
	var right_new = $.CreatePanel('Button', x, 'CleanUpgrade'+ (branchTier * 2-1));
	
	left_new.hittest = true;
	right_new.hittest = true;
	
	left_new.enabled = false;
	right_new.enabled = false;
	
	left_new.SetHasClass('BranchChoice', true);
	right_new.SetHasClass('BranchChoice', true);
	left_new.SetHasClass('LeftBranch', true);
	right_new.SetHasClass('RightBranch', true);
	
	var left_label_new = $.CreatePanel('Label', left_new, 'TextLabel');
	var right_label_new = $.CreatePanel('Label', right_new, 'TextLabel');
	
	left_label_new.SetHasClass('StatBonusLabel', true);
	right_label_new.SetHasClass('StatBonusLabel', true);
	
	x.left = left_new;
	x.right = right_new;
	x.left_dirty = left;
	x.right_dirty = right;
	
	left_new.label = left_label_new;
	right_new.label = right_label_new;
	
	//left_label_new.text = "HEllo World";
	//right_label_new.text = "HEllo World";
	
	function OnLabelHover(label)
	{
		if(label.GetParent().GetParent().BHasClass("BranchActiveExt"))
		{
			label.style.textShadow = "0px 0px 3px 3.7 #EC780E24";
			label.style.color = "#E7D291";
		}
	}
	
	function OnLabelDehover(label)
	{
		label.style.textShadow = null;
		label.style.color = null;
	}
	
	function OnLabelClicked(isLeft)
	{
		ChooseBranch(branchTier, isLeft);
	}
	
	left_new.SetPanelEvent('onmouseover', function(){OnLabelHover(left_label_new)});
	left_new.SetPanelEvent('onmouseout', function(){OnLabelDehover(left_label_new)});
	left_new.SetPanelEvent('onactivate', function(){OnLabelClicked(true)});
	right_new.SetPanelEvent('onmouseover', function(){OnLabelHover(right_label_new)});
	right_new.SetPanelEvent('onmouseout', function(){OnLabelDehover(right_label_new)});
	right_new.SetPanelEvent('onactivate', function(){OnLabelClicked(false)});
}

function ChooseBranch(branchTier,isLeft)
{
	var x = rows[branchTier];
	
	SetBranchActive(branchTier,false);
	x.selected = isLeft ? "left" : "right";
	if(isLeft)
	{
		x.FindChildTraverse("CleanUpgrade" + (branchTier*2)).SetHasClass("BranchChosen", true);
	}else{
		x.FindChildTraverse("CleanUpgrade" + (branchTier*2-1)).SetHasClass("BranchChosen", true);
	}
	
	//Light up the pip
	var x = $.GetContextPanel().GetParent().GetParent().GetParent()
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('lower_hud')
	x = x.FindChildTraverse('center_with_stats')
	x = x.FindChildTraverse('center_block') 
	x = x.FindChildTraverse('StatRow' + (5 + branchTier * 5))
	function f()
	{
		x.SetHasClass(isLeft ? "LeftBranchSelected" : "RightBranchSelected", true);
	}
	f();
	
	if(CanSkillAnyTalent())
	{
		lvl = Entities.GetLevel(Players.GetLocalPlayerPortraitUnit());
		for(var i in rows)
		{
			var row = rows[i];
			if(levels[i-1] <= lvl)
			{
				if(row.selected == "none")
				{
					SetBranchActive(i, true);
					break;
					//highlight this one
				}else{
					//highlight the selected label (again)
				}
			}else{
				break;
			}
		}
	}else{
		//$.Msg("Can't Skill Any Talent");
		$.DispatchEvent("DOTAHUDToggleStatBranchVisibility");
	}
	
	
    GameEvents.SendCustomGameEventToServer("talent_manager_choose_talent", { "unit": Players.GetLocalPlayerPortraitUnit(), row: branchTier, index: isLeft ? "left" : "right"});
}

function SetBranchActive(branchTier, active)
{
	var x = $.GetContextPanel().GetParent().GetParent().GetParent();
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('StatBranchDrawer')
	x = x.FindChildTraverse('DOTAStatBranch')
	x = x.FindChildTraverse('StatBranchColumn')
	x = x.FindChildTraverse('UpgradeOption' + branchTier);
	x.SetHasClass('BranchActiveExt', active);
	
	var left = x.FindChildTraverse('CleanUpgrade' + (branchTier * 2)); 
	var right = x.FindChildTraverse('CleanUpgrade' + (branchTier * 2 - 1));
	
	if(active){
		var style = x.style;
		
		style.backgroundImage = "url('s2r://panorama/images/hud/reborn/statbranch_select_bg_psd.vtex');";
		style.backgroundSize = " 98% 88%;";
		style.backgroundPosition = "center;";
		style.backgroundRepeat = "no-repeat;";
		
		
		//style.animationName = "TalentSelect;";
		
		//left.Children()[0].style.color = "#e1e1e1;"
		//left.Children()[0].style.textShadow = "1px 1px 2px 3.0 #0000000077";
		///right.Children()[0].style.color = "#e1e1e1;"
		//right.Children()[0].style.textShadow = "1px 1px 2px 3.0 #0000000077";
	}else{
		var style = x.style;
		style.backgroundImage = "none";
	}
		
	left.enabled = active;
	right.enabled = active;
	//x.style.backgroundColor = "red";
	//x.DeleteAsync(0); 
}

function SetAddTalentButtonVisible(visible)
{
	var x = $.GetContextPanel().GetParent().GetParent().GetParent()
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('lower_hud')
	x = x.FindChildTraverse('center_with_stats')
	x = x.FindChildTraverse('center_block') 
	x = x.FindChildTraverse('level_stats_frame') 
	x.style.visibility = visible ? "visible;" : "collapse;";
}

function OnHeroLevelChanged(newLevel)
{
	lvl = newLevel;
}

function PlayRoarSound()
{
	
}

function CanSkillAnyTalent()
{
    if(Entities.GetAbilityPoints(Players.GetLocalPlayerPortraitUnit()) < 1 || !Entities.IsControllableByPlayer(Players.GetLocalPlayerPortraitUnit(), Game.GetLocalPlayerID()) )
	{
		return false;
	}else{
		var lvl = Entities.GetLevel(Players.GetLocalPlayerPortraitUnit());
		for(var i in rows)
		{
			var row = rows[i];
			if(levels[i-1] <= lvl)
			{
				if(row.selected == "none")
				{
					return true;
				}
			}else{
				return false;
			}
		}
	}
}

function SetTalentTooltipVisible(visible)
{
	if(!Entities.IsControllableByPlayer(Players.GetLocalPlayerPortraitUnit(), Game.GetLocalPlayerID())) return;
	$.DispatchEvent("DOTAHUDToggleStatBranchVisibility");
	if(Sanitized) return;
	var x = $.GetContextPanel().GetParent().GetParent().GetParent()
	x = x.FindChildTraverse('StatBranchDrawer')
	x = x.FindChildTraverse('statbranchdialog')
	visible = x.BHasClass("ShowStatBranch");
	//if(x.BHasClass("ShowStatBranch")){
	//	$.Msg("Invis- Don't calculate")
//		return;
	//}
	
	//$.DispatchEvent("DOTAHUDToggleStatBranchVisibility");
	x = x.FindChildTraverse('DOTAStatBranch');
	isTalentTooltipVisible = visible;
	
	//Set the current branch visible
	lvl = Entities.GetLevel(Players.GetLocalPlayerPortraitUnit());
	if(visible)
	{
		for(var i in rows)
		{
			var row = rows[i];
			if(levels[i-1] <= lvl)
			{
				if(row.selected == "none")
				{
					SetBranchActive(i, true);
					break;
					//highlight this one
				}else{
					//highlight the selected label (again)
				}
			}else{
				break;
			}
		}
	}else{
		for(var i in rows)
		{
			var row = rows[i];
			SetBranchActive(i, false);
		}
	}
	
}   

/*
	Sanitizaion basically temporarily removes all of this code
	to use the default talent handling code
	
	Useful for keeping compatibility with default heroes
	or for units/whatever doens't have talents (units, buildings, etc)
*/
function SetSanitized(bool)
{
	if(Sanitized !== bool)
	{
		if(bool)
		{
			//set to default mode
			
			//hide the cleaned buttons, show the dirty buttons
			for(var i in rows)
			{
				var row = rows[i];
				var childs = row.Children();
				for(var x in childs)
				{
					var child = childs[x];
					
					if(child.id.indexOf("Clean") >= 0)
					{
						child.style.visibility = "collapse";
					}else{
						child.style.visibility = null;
					}
				}
			}
			//reset the level tree
			SetLevels([10,15,20,25])
			
			//null the opacity on the rows
			// { done in the periodic }
			
			//reset the visible status on the talent button
		
		}else{  
		
			//reapply all the event listeners
			
			//hide the diry buttons, show the clean buttons
			for(var i in rows)
			{
				var row = rows[i];
				var childs = row.Children();
				for(var x in childs)
				{
					var child = childs[x];
					
					if(child.id.indexOf("Clean") >= 0)
					{
						child.style.visibility = null;
					}else{
						child.style.visibility = "collapse";
					}
				}
			}
			
		
		} 
	}
	Sanitized = bool
}
 
 function FindValue(obj)
 {
	 if(obj.v) return obj.v;
	 for(var i in obj)
	 {
		 if(i.indexOf("MODIFIER") >= 0)
		 {
			 return obj[i];
		 }
	 }
	 return undefined;
 }
 
function ChangeToSelected()
{
	SetSanitized(false);
	LastSelectedUnit = Players.GetLocalPlayerPortraitUnit();
	var table = CustomNetTables.GetTableValue("talent_manager", "unit_talent_data_" + LastSelectedUnit); 
	
	//Update levels
	SetLevels(table.levels.split(" "));
	
	for(var i in table.data)
	{
		var row = table.data[i];
		
		//set the left/right text
		
		var panel_row = rows[i];
	
		var left = panel_row.left;
		var right = panel_row.right; 
		
		//set the selected status
		var lefttext = LocalizeText(row["left"].name);
		var righttext = LocalizeText(row["right"].name);
		
		var leftval = row["left"];
		leftval = FindValue(leftval);
		lefttext = lefttext.replace("{}", leftval);
		left.label.text = lefttext;
		
		
		var rightval = row["right"];
		rightval = FindValue(rightval);
		righttext = righttext.replace("{}", rightval);
		right.label.text = righttext;
		
		
		panel_row.selected = row.selected || "none";
		panel_row.SetHasClass("LeftBranchSelected", row.selected == "left");
		panel_row.SetHasClass("RightBranchSelected", row.selected == "right");
		panel_row.FindChildTraverse("CleanUpgrade" + (i*2)).SetHasClass("BranchChosen", row.selected == "left");
		panel_row.FindChildTraverse("CleanUpgrade" + (i*2-1)).SetHasClass("BranchChosen",  row.selected == "right");
	
		//set the pip
	}
}


function InitCustomClickHandlers()
{
	CleanBranch(1);
	CleanBranch(2);
	CleanBranch(3);
	CleanBranch(4);
	SetLevels([8,16,24,32]);
	
	function TalentTreeShow()
	{
		
	}
	//Setup the click handler for the stat thing
	var x = $.GetContextPanel().GetParent().GetParent().GetParent()
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('lower_hud')
	x = x.FindChildTraverse('center_with_stats')
	x = x.FindChildTraverse('center_block') 
	
	x.FindChildTraverse('StatBranch').SetPanelEvent('onactivate', function(){});
	
	x = x.FindChildTraverse('level_stats_frame').FindChildTraverse("LevelUpTab");
	
	x.SetPanelEvent("onactivate", function()
	{
		SetTalentTooltipVisible(!isTalentTooltipVisible);
	});
	
	//Make an object of all the current labels
	
	SetTalentTooltipVisible(false );   
    SetAddTalentButtonVisible(true); 

	//Menu handler
	function TalentTreeTitlePeriodic()
	{
		
		SetAddTalentButtonVisible(CanSkillAnyTalent());
		
		//Update the pips 
		var x = $.GetContextPanel().GetParent().GetParent().GetParent()
		x = x.FindChildTraverse('HUDElements')
		x = x.FindChildTraverse('lower_hud')
		x = x.FindChildTraverse('center_with_stats')
		x = x.FindChildTraverse('center_block') 
		for(var i in rows)
		{
			if(Sanitized)
			{
				var row = rows[i];
				x.FindChildTraverse("StatRow" + (5 - (-i) * 5)).Children()[0].style.opacity = null;
				x.FindChildTraverse("StatRow" + (5 - (-i) * 5)).Children()[1].style.opacity = null;
			}else{
				
				var row = rows[i];
				var isLeft = row.selected == "left";
				var isRight = row.selected == "right";
				x.FindChildTraverse("StatRow" + (5 - (-i) * 5)).Children()[0].style.opacity = isLeft ? 1 : 0;//SetHasClass("LeftBranchSelected", isLeft);
				x.FindChildTraverse("StatRow" + (5 - (-i) * 5)).Children()[1].style.opacity = isRight ? 1 : 0;//SetHasClass("RightBranchSelected", isRight);
			}
		}
		
		//Update the selected
		var name = Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit());
		var table = CustomNetTables.GetTableValue("talent_manager", "unit_talent_data_" + Players.GetLocalPlayerPortraitUnit())
		if(LastSelectedUnit !== Players.GetLocalPlayerPortraitUnit() && table)
		{
			ChangeToSelected();
		}
		SetSanitized(table == undefined);
		$.Schedule(0.03, TalentTreeTitlePeriodic);
	}
	TalentTreeTitlePeriodic();
	
	/*
	 var x = $.GetContextPanel().GetParent().GetParent().GetParent();
	x = x.FindChildTraverse('HUDElements')
	x = x.FindChildTraverse('StatBranchDrawer')
	x = x.FindChildTraverse('statbranchdialog')
	x = x.FindChildTraverse('DOTAStatBranch')
	x = x.FindChildTraverse('StatBranchColumn')
	
	var new_ = $.CreatePanel('Panel', x, 'UpgradeOption5');
	x.MoveChildBefore(new_, x.Children()[0]);
	
	new_.SetHasClass('BranchPair', true);
	new_.SetHasClass('LeftRightFlow', true); 
	
	var new2 = $.CreatePanel('Panel', x, 'GASDFD');
	new2.style.width = "200px";
	new2.style.height = "200px";
	new2.style.backgroundColor = "red";*/
	
	
	//SetBranchActive(1, true);

	//Todo: Have to go through the entire talent tree and set thosemouse events too
	
	
	
}
InitCustomClickHandlers();


/* Events */
function OnTalentLabelClicked(panel)
{
	
}