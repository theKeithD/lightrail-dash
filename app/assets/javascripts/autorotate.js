// TODO: Clean up, refactor out duplicated code
var origContent = "";
var autoCycle = true;
var cycleTimer = "";
var cycleDelay = 10000;
var nextPage = 1;

function cyclePages(goToNext) {
	if(typeof goToNext == "undefined") {
		goToNext = true;
	}
	
	$('#dashboard-' + nextPage).slideUp();
	
	if(goToNext) { // going forward
		if($('.curPage').next().length == 0) { // at end, wrap around
			nextPage = 1;
		} else {
			nextPage++;
		}
	} else { // going backward
		if($('.curPage').prev().length == 0) { // at start, wrap around
			nextPage = $('#nav').children('a').length;
		} else {
			nextPage--;
		}
	}
	
	$('#nav').children().removeClass('curPage');
	$('#nav a:eq(' + (nextPage-1) + ')').addClass('curPage');
	
	$('#dashboard-' + nextPage).slideDown();
}

function bindShortcutKeys() {
	$(document).jkey('alt+spacebar', toggleCycle);
	$(document).jkey('right', cyclePages);
	$(document).jkey('left', function() {
		cyclePages(false);
	});
}

function toggleCycle() {
	$('#cycle-button').toggleClass('enabled');
	autoCycle = !autoCycle;
	
	if(autoCycle == true) {
		cycleTimer = setInterval(cyclePages, cycleDelay);
	} else {
		clearInterval(cycleTimer);
	}
}

$(document).ready(function($) {
	// ready the first page
	$('#nav').children().first().addClass('curPage');
	$('#dashboard-1').show();
	
	$('#nav a').click(function(e) {
		// only add additional functionality if the user is not holding down a modifier key (i.e. to open in a new tab)
		if(!(e.ctrlKey || e.shiftKey || e.altKey || e.metaKey)) {
			// Reset timer on click if currently cycling
			if(autoCycle == true) {
				clearInterval(cycleTimer);
				cycleTimer = setInterval(cyclePages, cycleDelay);
			}
			
			// mark as current, unless it's already current
			if(!$(this).hasClass('curPage')) {
				$('#nav').children().removeClass('curPage');
				$(this).addClass('curPage');
				
				$('#dashboard-' + nextPage).slideUp();

				nextPage = $('#nav a').index($(this)) + 1;
				
				$('#dashboard-' + nextPage).slideDown();
			}
			
			// disable normal anchor click behavior
			return false;
		}
	});
	
	// Automatic cycling logic
	if(autoCycle) {
		$('#cycle-button').addClass('enabled');
		cycleTimer = setInterval(cyclePages, cycleDelay);
	}
	// Automatic cycle toggle button
	$('#cycle-button').click(toggleCycle);
	// Tooltip for automatic cycle button
	$('#cycle-button.enabled').livequery(function() {
		$('#cycle-button').attr('title', 'Automatic cycling: ON (click or press ctrl+space to disable)');
	}, function() {
		$('#cycle-button').attr('title', 'Automatic cycling: OFF (click or press ctrl+space to enable)');
	});
	
	// Keyboard shortcuts
	bindShortcutKeys();
});