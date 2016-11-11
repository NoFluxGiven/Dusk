"use strict";

var thisPlayerWantsTooltips = true;

(function () {
	$.Msg( "Changing Hero icon" );
	var pid = Players.GetLocalPlayer()
	var selHero = Players.GetPlayerSelectedHero( pid );
	
	var heroIDTable = CustomNetTables.GetTableValue("hero_ids",selHero);
	
	var heroID = heroIDTable.value;
	
	$.Msg( "Selected hero is " + selHero + " with ID "+ heroID );
	
	$( "#helperButtonImage" ).heroid = heroID;
	$( "#helperPullout" ).ToggleClass("hidePullout");
	helperSetUpValues()
	
	GameEvents.Subscribe( "event_skillbuild_levelled_ability", receiveSkillbuildLevelUp );
})();

function helperButtonPressed( msg ) {
	$.Msg( "Helper button script.");
	$( "#helperPullout" ).ToggleClass("hidePullout");
}

function helperSetUpValues() {
	var pid = Players.GetLocalPlayer()
	var selHero = Players.GetPlayerSelectedHero( pid );
	
	var heroLearnTable = CustomNetTables.GetTableValue("learn_heroes",selHero);
	
	if (heroLearnTable.hero_name == "None") { $( "#helperButton" ).ToggleClass("hidePullout"); return; }
	
	var offlaneRating = heroLearnTable.lanes.offlane.rating;
	var safelaneRating = heroLearnTable.lanes.safelane.rating;
	var midlaneRating = heroLearnTable.lanes.midlane.rating;
	var jungleRating = heroLearnTable.lanes.jungle.rating;
	
	var pip = "★";
	var emptypip = "<font color='#747474'>☆</font>";
	
	var offlaneString = "";
	var n = 0;
	while (n < 5) {
		if (n < offlaneRating) {
			offlaneString += pip;
		}else{
			offlaneString += emptypip;
		}
		n++;
	}
	
	var safelaneString = "";
	var n = 0;
	while (n < 5) {
		if (n < safelaneRating) {
			safelaneString += pip;
		}else{
			safelaneString += emptypip;
		}
		n++;
	}
	
	var midlaneString = "";
	var n = 0;
	while (n < 5) {
		if (n < midlaneRating) {
			midlaneString += pip;
		}else{
			midlaneString += emptypip;
		}
		n++;
	}
	
	var jungleString = "";
	var n = 0;
	while (n < 5) {
		if (n < jungleRating) {
			jungleString += pip;
		}else{
			jungleString += emptypip;
		}
		n++;
	}
	
	//$( "#helperHeroName" ).text = heroLearnTable.hero_name;
	$( "#helperHeroOverview" ).text = heroLearnTable.lanes.general.overview;
	$( "#helperHeroOfflane" ).text = heroLearnTable.lanes.offlane.overview;
	$( "#helperHeroSafelane" ).text = heroLearnTable.lanes.safelane.overview;
	$( "#helperHeroMidlane" ).text = heroLearnTable.lanes.midlane.overview;
	$( "#helperHeroJungle" ).text = heroLearnTable.lanes.jungle.overview;
	
	$( "#helperHeroMidlaneRating" ).text = midlaneString;
	$( "#helperHeroSafelaneRating" ).text = safelaneString;
	$( "#helperHeroOfflaneRating" ).text = offlaneString;
	$( "#helperHeroJungleRating" ).text = jungleString;
}

function toggleTooltips() {
	$.Msg( "Toggling tooltips." );
	thisPlayerWantsTooltips = !thisPlayerWantsTooltips;
}

function receiveSkillbuildLevelUp( data ) {
	var pid = Players.GetLocalPlayer();
	var selHero = Players.GetPlayerSelectedHero( pid );
	
	if (!thisPlayerWantsTooltips) {
		return 0;
	}
	
	var heroSkillbuildTable = CustomNetTables.GetTableValue("skillbuild_heroes",selHero);
	
	var ability = data.ability;
	var level = data.level;
	
	$.Msg("Ability: "+ability);
	$.Msg("Level: "+level);
	
	if (heroSkillbuildTable["skillnotes"][ability] == undefined) {
		$.Msg("No ability definition of that name in the skills.kv file. Exiting.");
		return;
	}
	
	if (heroSkillbuildTable["skillnotes"][ability][level] == undefined) {
		$.Msg("No notes definition of that ability at that level in the skills.kv file. Exiting.");
	}
	
	var tooltipText = heroSkillbuildTable["skillnotes"][ability][level];

	var duration = 5;
	
	showTooltip( tooltipText, 5 );
}

function showTooltip( textdata, duration ) {
	$.Msg( "Showing tooltip: '"+textdata+"'");
}