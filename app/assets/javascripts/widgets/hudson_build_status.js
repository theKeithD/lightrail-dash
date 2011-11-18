function addHudsonBuildStatusToPage(hudson, targetElement) {
    // default value for targetElement is #main-content
    targetElement = typeof(targetElement) != 'undefined' ? targetElement : $('#main-content');
    
    // set up element to insert into page
    var divStatusesID = hudson.html_id + "-statuses";
    
    // insert element into page
    var hudsonDiv =     "<div id='" + divStatusesID + "' class='hudson-statuses " + hudson.html_class + "'></div>";
    targetElement.append(hudsonDiv);
}
function setUpHudsonBuildStatus(hudson, apiData) {
    // set up element to insert into page
    var divStatusesID = hudson.html_id + "-statuses";
    var divStatuses = $('#' + divStatusesID);

    if(hudson.show_overall_status) { // show only one large status container that summarizes the build data
        divStatuses.append(createHudsonSummary(hudson, apiData));
    } else { // add divs to statuses container for each job in apiData
        $.each(apiData, function(i, job) {
            divStatuses.append(createIndividualHudsonStatus(job));
        });
    }
}

function createHudsonSummary(hudson, apiData) {
    var resultClass = "";
    var resultDescription = "";
    
    var buildStatuses = { "success": new Array(), "failed": new Array(), "aborted": new Array(), "pending": new Array(), "in-progress": new Array() };
    var totalBuilds = apiData.length;
    
    $.each(apiData, function(i, job) {
        if(job.color.match(/anim$/)) {
            buildStatuses["in-progress"].push(job);
        } else {
            if(job.color.match(/^blue/)) {
                buildStatuses["success"].push(job);
            } else if(job.color.match(/^red/)) {
                buildStatuses["failed"].push(job);
            } else if(job.color.match(/^aborted/)) {
                buildStatuses["aborted"].push(job);
            } else if(job.color.match(/^grey/)) {
                buildStatuses["pending"].push(job);
            }
        }
    });
    
    // first pass, ordered for text output
    if(buildStatuses["success"].length > 0) {
        resultDescription += "<div class='description-detail'>" + 
            "<div class='detail-header'>" + buildStatuses["success"].length + "/" + totalBuilds + " builds successful</div>" + 
        "</div>";
    }
    if(buildStatuses["in-progress"].length > 0) {
        resultDescription += "<div class='description-detail'>" + 
            "<div class='detail-header'>" + buildStatuses["in-progress"].length + "/" + totalBuilds + " builds in progress</div>" + 
            listJobDetailItems(buildStatuses["in-progress"]) + 
        "</div>";
    }
    if(buildStatuses["failed"].length > 0) {
        resultDescription += "<div class='description-detail'>" + 
            "<div class='detail-header'>" + buildStatuses["failed"].length + "/" + totalBuilds + " builds failed</div>" + 
            listJobDetailItems(buildStatuses["failed"]) + 
        "</div>";
    }
    if(buildStatuses["pending"].length > 0) {
        resultDescription += "<div class='description-detail'>" + 
            "<div class='detail-header'>" + buildStatuses["pending"].length + "/" + totalBuilds + " builds pending</div>" + 
        "</div>";
    }
    if(buildStatuses["aborted"].length > 0) {
        resultDescription += "<div class='description-detail'>" + 
            "<div class='detail-header'>" + buildStatuses["aborted"].length + "/" + totalBuilds + " builds aborted</div>" + 
        "</div>";
    }
    
    // second pass, ordered for color precedence
    if(buildStatuses["aborted"].length > 0) {
        resultClass = "aborted";
    }
    if(buildStatuses["pending"].length > 0) {
        resultClass = "pending";
    }
    if(buildStatuses["success"].length > 0) {
        resultClass = "success";
    }
    if(buildStatuses["in-progress"].length > 0) {
        resultClass = "in-progress";
    }
    if(buildStatuses["failed"].length > 0) {
        resultClass = "failed";
    }
    
    var resultDiv = "<div id='" + hudson.html_id + "-summary' class='hudson-status result-" + resultClass + " hudson-summary'>" +
                        "<div class='result-gem'>" +
                          "<div class='result-name'>" + hudson.name + "</div>"  +
                          "<div class='result-description'>" + resultDescription + "</div>" +
                        "</div>" +
                    "</div>";
    return resultDiv;
}

function createIndividualHudsonStatus(job) {
    var resultClass = "";
    var resultDescription = "";
    
    if(job.color.match(/^blue/)) {
        resultClass = "success";
        resultDescription = "Success";
    } else if(job.color.match(/^red/)) {
        resultClass = "failed";
        resultDescription = "Failed";
    } else if(job.color.match(/^aborted/)) {
        resultClass = "aborted";
        resultDescription = "Aborted";
    } else if(job.color.match(/^grey/)) {
        resultClass = "pending";
        resultDescription = "Pending";
    }
    
    // in-progress jobs get their own type that overrides all
    if(job.color.match(/anim$/)) {
        resultClass = "in-progress";
        resultDescription = "In Progress";
    }
    
    var resultDiv = "<div id='hudson-" + job.name.replace(/_/g, "-") + "' class='hudson-status result-" + resultClass + "'>" +
        "<a class='result-gem' href='" + job.url + "'>" +
            "<div class='result-name'>" + job.name.replace(/[-]/g, " ") + "</div>"  +
            "<div class='result-description'>" + resultDescription + "</div>" +
        "</a>" +
    "</div>";
    return resultDiv;
}

function listJobDetailItems(jobs) {
    var jobDivs = "";
    
    $.each(jobs, function(i, job) {
        jobDivs += "<a class='detail-item' href='" + job.url + "'>" + job.name.replace(/[-]/g, " ") + "</a>";
    });
    
    return jobDivs;
}