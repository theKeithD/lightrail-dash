function addJiraCountdownToPage(jira, targetElement) {
	// convert a selector string to a proper jQuery object
/*	if(typeof(targetElement) == 'string') {
		targetElement = $(targetElement);
	}*/
	// default value for targetElement is #main-content
	targetElement = typeof(targetElement) != 'undefined' ? targetElement : $('#main-content');
	
	// set up elements to insert into page
	var divBoxID = jira.html_id + "-box";
	var divDaysID = jira.html_id + "-days";
	var divDescriptionID = jira.html_id + "-description";
	
	// insert elements into page
	var jiraDiv = 	"<div id='" + divBoxID + "' class='countdown-box " + jira.html_class + "'>" +
						"<div id='" + divDaysID + "' class='countdown-days " + jira.html_class + "'></div>" + 
						"<div id='" + divDescriptionID + "' class='countdown-description " + jira.html_class + "'>days remaining</div>" + 
					"</div>";
	targetElement.append(jiraDiv);
}
function setUpJiraCountdown(jira) {
	// set up elements to insert into page
	var divBoxID = jira.html_id + "-box";
	var divDaysID = jira.html_id + "-days";
	var divDescriptionID = jira.html_id + "-description";
	
	// for later reference
	var divBox = $('#' + divBoxID);
	var divDays = $('#' + divDaysID);
	var divDescription = $('#' + divDescriptionID);
	
	// set up day count and linkify
	divDays.text(parseInt(jira.days_remaining) + 1); // add on a day to count the deadline day in the countdown
	divDays.html("<a href='/jira_countdowns/" + jira.id + "'>" + divDays.text() + "</a>");
	
	// set up description for countdown
	var dateRegex = /^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\+(\d{2}):(\d{2})$/;
	var matches = dateRegex.exec(jira.next_release.release_date);
	var releaseDate = new Date(matches[1], matches[2]-1, matches[3], matches[4], matches[5], matches[6]);
    
    var dayLabel = "days";
    if(parseInt(divDays.text()) == 1) {
        dayLabel = "day"
    }
	descriptionHTML = "<span class='description-remaining'>" + dayLabel + " remaining</span> <span class='description-until'>until <span>" + jira.next_release.name + "</span> for <span>" + jira.project + "</span></span> <span class='description-date'>on <span>" + releaseDate.toDateString() + "</span></span>";
	divDescription.html(descriptionHTML);
}