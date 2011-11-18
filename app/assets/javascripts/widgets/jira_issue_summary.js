function addJiraIssueSummaryToPage(jira, targetElement) {
	
    // default value for targetElement is $('#main-content')
	targetElement = typeof(targetElement) != 'undefined' ? targetElement : $('#main-content');
	
	// set up elements to insert into page
	var divBoxID = jira.html_id + "-box";
	var divTitleID = jira.html_id + "-title";
    var divStatusTitleID = jira.html_id + "-status-title";
	var divStatusGraphID = jira.html_id + "-status-graph";
    var divTypeTitleID = jira.html_id + "-type-title";
    var divTypeGraphID = jira.html_id + "-type-graph";
	
	// insert elements into page
	var jiraDiv = 	"<div id='" + divBoxID + "' class='flot-box " + jira.html_class + "'>" +
						"<div id='" + divTitleID + "' class='flot-title " + jira.html_class + "'>Loading graphs...</div>" + 
						"<div id='" + divStatusTitleID + "' class='flot-subtitle " + jira.html_class + "'></div>" +
                        "<div id='" + divStatusGraphID + "' class='flot-graph " + jira.html_class + "'></div>" + 
						"<div id='" + divTypeTitleID + "' class='flot-subtitle " + jira.html_class + "'></div>" +
						"<div id='" + divTypeGraphID + "' class='flot-graph " + jira.html_class + "'></div>" + 
					"</div>";
	targetElement.append(jiraDiv);
}
function setUpJiraGraph(jira) {
	// set up elements to insert into page
	var divBoxID = jira.html_id + "-box";
	var divTitleID = jira.html_id + "-title";
    var divStatusTitleID = jira.html_id + "-status-title";
	var divStatusGraphID = jira.html_id + "-status-graph";
    var divTypeTitleID = jira.html_id + "-type-title";
    var divTypeGraphID = jira.html_id + "-type-graph";
	
	// for later reference
	var divBox = $('#' + divBoxID);
	var divTitle = $('#' + divTitleID);
    var divStatusTitle = $('#' + divStatusTitleID);
	var divStatusGraph = $('#' + divStatusGraphID);
    var divTypeTitle = $('#' + divTypeTitleID);
    var divTypeGraph = $('#' + divTypeGraphID);
	
	// set up widget title and linkify
	divTitle.text(jira.name + " (" + jira.true_version + ")");
	divTitle.html("<a href='/jira_issue_summaries/" + jira.id + "'>" + divTitle.text() + "</a>");
	
    // set up graph titles
    divStatusTitle.text('Issue Statuses');
    divTypeTitle.text('Issue Types');
    
    // render graphs
	plotJiraGraphs(jira);
}

function flotifyStackedBar(barItems) {
	var flot_data = new Array();
	
	$.each(barItems, function(key, value) {
		flot_series = new Object();
		
		flot_series.label = key;
		flot_series.data = new Array();
		flot_series.data.push([value, 1]);
		
		flot_data.push(flot_series);
	});
	
    return flot_data;
}

function formatLegendLabel(label, series) {
    label = label.split("_").map(function (word) {
        return word.charAt(0).toUpperCase() + word.slice(1);
    }).join(" ");
    return label + ": <strong>" + series.data[0][0] + "</strong>";
}

function plotJiraGraphs(jira) {
	var options = { 
		series: { stack: 0,
				  bars: {	show: true, 
							horizontal: true,  
							lineWidth: 0, 
							fill: 1, 
                            fillColor: { colors: [{ brightness: 0.6, opacity: 0.9 }, { brightness: 0.9, opacity: 1.0 } ] } },
				},
		colors: ["red", "yellow", "green"],
		grid:	{ show: true, 
                  autoHighlight: false, 
                  color: "#ffffff", 
                  borderWidth: 0,
                  minBorderMargin: 0 },
		legend: { show: true, 
                  labelFormatter: formatLegendLabel, 
                  noColumns: 3, 
                  position: "se", 
                  backgroundColor: "transparent",
                  margin: [0, -30] },
        xaxis:  { show: false },
        yaxis:  { show: false },
	}
	
    var issueCountData = flotifyStackedBar(jira.issue_counts);
    var statusPlot = $.plot($('#' + jira.html_id + '-status-graph'), issueCountData, options);
	
    var issueTypeData = flotifyStackedBar(jira.issue_types);
    var typePlot = $.plot($('#' + jira.html_id + '-type-graph'), issueTypeData, $.extend({}, options, { colors: ["red", "green", "yellow"] } ));
}