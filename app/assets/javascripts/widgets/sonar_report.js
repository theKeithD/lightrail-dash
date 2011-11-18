$.ajaxSetup({
	crossDomain:true,
	dataType: "jsonp"
});


var availableMetricsURI = "";
var availableMetrics = new Object;
var baseURI = "";
var resourceURI = "";

function createReportFromModel(model, targetElement) {
	targetElement = typeof(targetElement) != 'undefined' ? targetElement : $('#main-content');
	
	baseURI = model.sonar_server;
	resourceURI = baseURI + "api/resources?format=json&resource=" + model.package_name + "&metrics=" + model.metrics_to_track;
	availableMetricsURI = model.sonar_server + "api/metrics?format=json";
	
	$.ajax(availableMetricsURI, {
		success: function(data) {
			$.each(data, function(i, metric) {
				availableMetrics[metric.key] = metric;
			});
		}
	});
	
	addReportToPage(targetElement);
}

function addReportToPage(targetElement) {
	$.ajax(resourceURI, {
		success: function(data) {
			$.each(data, function(i, project) {
				// set up div
				var sonarDiv = "<div id='sonar-" + project.id + "' class='sonar'></div>";
				targetElement.append(sonarDiv);
				sonarDiv = $('#sonar-' + project.id);
				
				sonarDiv.append("<div class='sonar-header'><div class='project-title'><a href='"  + baseURI + "project/index/" + project.id + "'>" + project.name + "</a></div><div class='project-version'>version <span class='project-version-number'>" + project.version + "</span></div></div>");
				
				var metricsDiv = "<div id='sonar-metrics-" + project.id + "' class='sonar-metrics'></div>";
				sonarDiv.append(metricsDiv);
				var metricsDiv = $('#sonar-metrics-' + project.id);
				$.each(project.msr, function(i, metric) {
					metricsDiv.append("<div id='sonar-metric-" + project.id + "-" + metric.key + "' class='sonar-metric sonar-" + metric.key + "'><span class='metric-name'>" + availableMetrics[metric.key].description + "</span>: <span class='metric-value'>" + metric.frmt_val + "</span></div>");
				});
			});
		}
	});
}
