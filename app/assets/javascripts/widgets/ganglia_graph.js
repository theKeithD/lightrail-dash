var shortMonthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

function addGraphToPage(graph, targetElement) {
	// default value for targetElement is #main-content
	targetElement = typeof(targetElement) != 'undefined' ? targetElement : $('#main-content');
	
	// set up elements to insert into page
	var divBoxID = graph.html_id + "-box";
	var divTitleID = graph.html_id + "-title";
	var divGraphID = graph.html_id + "-graph";
	var divOrigLegendID = graph.html_id + "-orig-legend";
	var divLegendID = graph.html_id + "-legend";
	
	// insert elements into page
	var graphDiv = 	"<div id='" + divBoxID + "' class='flot-box " + graph.html_class + "'>" +
						"<div id='" + divTitleID + "' class='flot-title " + graph.html_class + "'>Loading graph...</div>" + 
						"<div id='" + divGraphID + "' class='flot-graph " + graph.html_class + "'></div>" + 
						"<div id='" + divOrigLegendID + "' class='flot-orig-legend " + graph.html_class + "'></div>" + 
						"<div id='" + divLegendID + "' class='flot-legend " + graph.html_class + "'></div>" + 
					"</div>";
	targetElement.append(graphDiv);
}
function setUpGraph(graph) {
	// set up elements to insert into page
	var divBoxID = graph.html_id + "-box";
	var divTitleID = graph.html_id + "-title";
	var divGraphID = graph.html_id + "-graph";
	var divOrigLegendID = graph.html_id + "-orig-legend";
	var divLegendID = graph.html_id + "-legend";
	
	// for later reference
	var divBox = $('#' + divBoxID);
	var divTitle = $('#' + divTitleID);
	var divGraph = $('#' + divGraphID);
	var divOrigLegend = $('#' + divOrigLegendID);
	var divLegend = $('#' + divLegendID);
	
    $.ajax({
        url: '/ganglia_graphs/' + graph.id + '/data.json', 
        dataType: 'json',
        success: function(data) {
            graph.obj = new Object;
            graph.obj.series = [];
            
            $.each(data.graph_data, function(i, host) { // iterate through hosts in JSON
                var thisSeries = new Object;
                
                if(graph.kind == "report") {
                    thisSeries['label'] = host.metric_name;
                } else {
                    thisSeries['label'] = host.host_name;
                }
                
                
                if(i == 0 && graph.name == undefined) { // pull title info from first item, since it shouldn't change in later hosts
                    graph.name = "[" + host.cluster_name + "] " + host.metric_name;
                }
                
                var metrics = [];
                
                // iterate through metrics in host
                if(graph.kind == "time" || graph.kind == "report") {
                    $.each(host.metrics, function(i, metric) {
                        if(i+1 < host.metrics.length) { // ignore last data point, since it's 0 in Ganglia most of the time
                            var offset = new Date().getTimezoneOffset()*-60;
                            metrics.push([(metric.timestamp + offset) * 1000, metric.value]);
                        }
                    });
                } else {
                    $.each(host.metrics, function(i, metric) {
                        metrics.push([metric.x, metric.value]);
                    });
                }
                
                thisSeries['data'] = metrics;
                
                thisSeries['enabled'] = !(graph.kind == "report" && thisSeries['label'] == "cpu_idle"); // ignore cpu_idle report metric by default, enable all others by default
                
                thisSeries['highlighted'] = false;
                thisSeries['color'] = i;
                thisSeries['origColor'] = i;
                
                graph.obj.series.push(thisSeries);
            });
            
            // set up graph title and linkify
            divTitle.text(graph.name);
            if(graph.description != undefined) {
                divTitle.append(document.createTextNode(" (" + graph.description + ")"));
            }
            divTitle.html("<a href='/ganglia_graphs/" + graph.id + "'>" + divTitle.text() + "</a>");
            
            // initial draw to set up legends
            plotEnabledSeries(graph);
            // clone the original legend, hide the original/auto-updating one
            divLegend.html((divOrigLegend.html()));
            divLegend.css('width', divLegend.width());
            divOrigLegend.hide();
            
            // tooltips and hovering
            function showGraphTooltip(x, y, contents) {
                $("<div id='tooltip' class='flot-tooltip'>" + contents + "</div>").css({top: y - 41, left: x + 4, position: 'fixed'})
                .appendTo('#' + divBoxID).fadeIn(200);
            }
            var previousPoint = null;
            divGraph.bind('plothover', function(event, pos, item) {
                $("#x").text(pos.x.toFixed(2));
                $("#y").text(pos.y.toFixed(2));
                
                if (item) {
                    if (previousPoint != item.dataIndex) {
                        previousPoint = item.dataIndex;
                        
                        $('#tooltip').remove();
                        var x = item.datapoint[0].toFixed(2),
                            y = item.datapoint[1].toFixed(2);
                        
                        var xDate = new Date(x * 1);
                        xDate = shortMonthNames[xDate.getUTCMonth()] + " " + 
                                padZero(xDate.getUTCDate(), 2) + " " + 
                                padZero(xDate.getUTCFullYear(), 2) + " " + 
                                padZero(xDate.getUTCHours(), 2) + ":" + 
                                padZero(xDate.getUTCMinutes(), 2) + "";
                        
                        showGraphTooltip(item.pageX, item.pageY,
                                    "<span class='flot-tooltip-date'>" + xDate + "</span><br /><span class='flot-tooltip-info'>" + item.series.label + ": " + y + "</span>");
                    }
                }
                else {
                    $('#tooltip').fadeOut(200, function() {
                        $('#tooltip').remove();
                        previousPoint = null;
                    });
                }
            });
            divGraph.bind('plotclick', function(event, pos, item) {
                if(item) {
                    // this space
                } else {
                    // available for lease
                }
            });
            
            // clickable legends which can hide/display individual series
            divLegend.delegate('.legendLabel', 'click', function() {
                toggleSeries(graph, $(this));
            });
            divLegend.delegate('.legendColorBox', 'click', function() {
                toggleSeries(graph, $(this).next('.legendLabel'));
            });
            
            // hover over legends to highlight them on graph
            $('#' + divLegendID + ' .legendLabel').livequery(function() {
                $(this).hover(function() {
                    highlightSeries(graph, $(this), true);
                }, function () {
                    highlightSeries(graph, $(this), false);
                });
            }, function() {
                $(this).unbind('mouseover').unbind('mouseout');
            });
            $('#' + divLegendID + ' .legendColorBox').livequery(function() {
                $(this).hover(function() {
                    highlightSeries(graph, $(this).next('.legendLabel'), true);
                }, function() {
                    highlightSeries(graph, $(this).next('.legendLabel'), false);
                });
            }, function() {
                $(this).unbind('mouseover').unbind('mouseout');
            });
            
            // special refresh behavior for GangliaGraphs
            if(divBox.siblings('.widget-control-overlay').length == 1) {
                divBox.siblings('.widget-control-overlay').children('.widget-refresh').click(function(event) {
                    updateGraph(graph);
                });
                
                divBox.everyTime(60 * 1000, function() {
                    updateGraph(graph);
                });
            }
        }
    });
}

function updateGraph(graph) {
	var divBoxID = graph.html_id + "-box";
	var divBox = $('#' + divBoxID);
    
    $.ajax({
        url: '/ganglia_graphs/' + graph.id + '/data.json', 
        dataType: 'json',
        success: function(data) {
            graph.obj = new Object;
            graph.obj.series = [];
            
            $.each(data.graph_data, function(i, host) { // iterate through hosts in JSON
                var thisSeries = new Object;
                
                if(graph.kind == "report") {
                    thisSeries['label'] = host.metric_name;
                } else {
                    thisSeries['label'] = host.host_name;
                }
                
                var metrics = [];
                
                // iterate through metrics in host
                if(graph.kind == "time" || graph.kind == "report") {
                    $.each(host.metrics, function(i, metric) {
                        if(i+1 < host.metrics.length) { // ignore last data point, since it's 0 in Ganglia most of the time
                            var offset = new Date().getTimezoneOffset()*-60;
                            metrics.push([(metric.timestamp + offset) * 1000, metric.value]);
                        }
                    });
                } else {
                    $.each(host.metrics, function(i, metric) {
                        metrics.push([metric.x, metric.value]);
                    });
                }
                
                thisSeries['data'] = metrics;
                
                thisSeries['enabled'] = !(graph.kind == "report" && thisSeries['label'] == "cpu_idle"); // ignore cpu_idle report metric by default, enable all others by default
                
                thisSeries['highlighted'] = false;
                thisSeries['color'] = i;
                thisSeries['origColor'] = i;
                
                graph.obj.series.push(thisSeries);
            });
            
            $('#' + divBoxID + ' .widget-loading-overlay').hide();
            $('#' + divBoxID + ' .widget-loading-overlay').remove();
            
            plotEnabledSeries(graph);
        },
        error: function() {
            // remove loading indicator and leave graph alone
            $('#' + divBoxID + ' .widget-loading-overlay').hide();
            $('#' + divBoxID + ' .widget-loading-overlay').remove();
        },

    });
    
    // temporary loading indicator
    divBox.append("<div class='widget-loading-overlay'></div>");
}

function toggleSeries(graph, legendElem) {
	$.each(graph.obj.series, function(i, thisSeries) {
		if(thisSeries.label == legendElem.text()) {
			thisSeries.enabled = !thisSeries.enabled;
			if(legendElem.hasClass('disabled')) {
				legendElem.removeClass('disabled');
				legendElem.prev('.legendColorBox').children('div').children('div').removeClass('disabled');
			} else {
				legendElem.addClass('disabled');
				legendElem.prev('.legendColorBox').children('div').children('div').addClass('disabled');
			}
			return false;
		}
	});
		
	plotEnabledSeries(graph);
}

function highlightSeries(graph, legendElem, enabling) {
	$.each(graph.obj.series, function(i, thisSeries) {
		if(thisSeries.label == legendElem.text()) {
			if(enabling) {
				thisSeries.highlighted = true;
				thisSeries.color = "#ffffff";
				legendElem.addClass('highlighted');
				legendElem.prev('.legendColorBox').children('div').addClass('highlighted');
			} else {
				thisSeries.highlighted = false;
				thisSeries.color = thisSeries.origColor;
				legendElem.removeClass('highlighted');
				legendElem.prev('.legendColorBox').children('div').removeClass('highlighted');
			}
			
			return false;
		}
	});
	
	plotEnabledSeries(graph);
}

function plotEnabledSeries(graph) {
	var enabledSeries = [];
	var highlightedSeries;
	
	$.each(graph.obj.series, function(i, thisSeries) {
		if(thisSeries.enabled) {
			if(thisSeries.highlighted) { // save the highlighted one for last
				highlightedSeries = thisSeries;
			} else {
				enabledSeries.push(thisSeries);
			}
		}
	});
	if(highlightedSeries) {
		enabledSeries.push(highlightedSeries);
	}
	
    var options = 
      { lines: { steps: false,
				 fill: true,
				 fillColor: { colors: [{ brightness: 0.3, opacity: 0.1 }, { brightness: 0.5, opacity: 1.0 } ] } },
	    grid:  { backgroundColor: { colors: ["#3F3F3F", "#222"] }, 
				 color: '#f0f0f0', 
				 hoverable: true,
				 clickable: true },
		xaxis: { show: true,
				 mode: "time",
				 monthNames: shortMonthNames, 
				 timeformat: "%b %d %y %H:%M",
				 minTickSize: [60, "minute"] },
		yaxis: { show: true },
		legend:{ noColumns: 3,
				 container: $('#' + graph.html_id + '-orig-legend')} };
    
	$.plot($('#' + graph.html_id + '-graph'), enabledSeries, options);
}

function padZero(value, width) {
    width -= value.toString().length;
    if ( width > 0 )
    {
        return new Array( width + (/\./.test( value ) ? 2 : 1) ).join( '0' ) + value;
    }
    return value;
}
