// General scripts applied to all widgets when rendered on a dashboard
$(document).ready(function() {
    var refreshInterval = 120 * 1000; // 2 minutes
    
    // display widget overlay on hover
    $('.widget-view').livequery(function() { 
        $(this).mouseenter(function() {
            if($(this).children('.widget-loading-overlay').length == 0) { // display overlay only if not loading
                $(this).children('.widget-control-overlay').fadeIn(300);
            }
        }).mouseleave(function() { 
            $(this).children('.widget-control-overlay').hide();
        });
    }, function() {
        $(this).unbind('mouseover').unbind('mouseout');
    });
    
    // refresh button click handler
    $('.widget-refresh').livequery(function() {
        if(!$(this).closest('.widget-view').attr('class').match(/\bganglia-graph/)) {
            $(this).click(function(event) {
                refreshWidget($(event.target).closest('.widget-view').attr('id'));
            });
        }
    }, function () {
        $(this).unbind('click');
    });
    
    // initial loading of widgets
    $('.widget-view').each(function() {
        if($(this).attr('class').match(/spacer\b/)) { // spacers aren't very dynamic. Just drop them in.
            refreshWidget($(this).attr('id'));
        } else {
            delayedWidgetLoad($(this).attr('id'));
            
            if(!$(this).attr('class').match(/\bganglia-graph/)) { // add autorefresh for non-ganglia widgets
                $(this).addClass('autorefresh');
            }
        }
    });
    
    // set up automatic refresh intervals
    $('.widget-view.autorefresh').livequery(function() {
        var interval = refreshInterval;
        
        if($(this).attr('class').match(/\bjira/)) { // JIRA widgets refresh less often
            interval *= 2.5;
        }
        
        // additional reload staggering
        interval += (parseInt(splitWidgetID($(this).attr('id'))["widget"]) * 250);
        
        $(this).everyTime(interval, function() {
            delayedWidgetLoad($(this).attr('id'));
        });
    }, function() { // cancel autorefresh
        $(this).stopTime();
    });
});

function refreshWidget(widgetID) {
    // gather information on widget
    var widgetDiv = $('#' + widgetID);
    var widgetInfo = splitWidgetID(widgetID);
    
    // pull new widget
    $.ajax({
        url: '/widgets/' + widgetInfo["widget"] + '/embed', 
        data: { 'targetElement': widgetID },
        success: function(data) {
            // temporarily keep div at same height 
            var height = widgetDiv.height();
            widgetDiv.css('height', height);
            
            // clear out widget div
            widgetDiv.empty();
            
            // replace widget contents and remove forced height
            widgetDiv.html(data);
            widgetDiv.removeAttr('style');
        },
        error: function() {
            // remove loading indicator and leave widget alone
            $('#' + widgetID + ' .widget-loading-overlay').hide();
            $('#' + widgetID + ' .widget-loading-overlay').remove();
        },
        dataType: 'html'
    });

    if(!widgetDiv.attr('class').match(/spacer\b/)) { // show loading overlay if not a spacer
        widgetDiv.append("<div class='widget-loading-overlay'></div>");
        $('#' + widgetID + ' .widget-control-overlay').hide(); // also hide refresh button during this time
    }
}

// Takes a dashboard widget ID (dashboard-A-column-B-row-C-widget-D) and splits it into a hash with 4 keys (dashboard, column, row, widget).
function splitWidgetID(id) {
    var widgetID = id.split('-');
    var widget = new Object();
    for(var i = 0; i < widgetID.length - 1; i += 2) {
        widget[widgetID[i]] = widgetID[i+1];
    }
    
    return widget;
}

// Loads a widget after a short delay depending on the widget's ID number.
function delayedWidgetLoad(id) {
    var widgetInfo = splitWidgetID(id);
    var delay = (parseInt(widgetInfo["widget"]) * 10) + 250;
    setTimeout("refreshWidget('" + id + "')", delay);
}
