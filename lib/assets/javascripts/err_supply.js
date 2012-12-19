//= require jquery.qtip

/*
	ErrSupply jQuery Adapter
	Copyright (c) 2011  Coroutine LLC
	Licensed under the MIT license
*/
ErrSupply = {
    arrow_color: "#c00",
    background_color: "#c00",
    border_color: "#c00",
    text_color: "#c00"
};

jQuery(function($) {
	$("form").live("err_supply:loaded", function(event, errors) {
		
		// define how errors are applied to dom elements
		var applyFn	 = function(error_hash) {
			var unmatched = {};
			var errors    = error_hash || {};
			var error;
			var content;
			var $field;
			var position;
			
			for (var id in errors) {
				error = errors[id];
				if (error && error.messages && error.messages.length) {
					
					content = "<div class='err_supply'><ul>";
					for (var i = 0, n = error.messages.length; i < n; i++) {
						content += "<li>" + error.label + " " + error.messages[i] + "</li>";
					};
					content += "</ul></div>";
				
					$field = $("#" + id);
					if ($field.offset()) {
					
						// determine position
						if (($field.offset().left + $field.outerWidth() + 300) < $(window).width()) {
							position = {
								field: "rightMiddle",
								tooltip: "leftMiddle"
							};
						}
						else {
							position = {
								field: "leftMiddle",
								tooltip: "rightMiddle"
							};
						};
					
						// add class 
						$field.addClass("error");
					
						// add qtip
						$field.qtip({
							content: content,
							show: {
								delay: 0,
								when: {
									event: "focus"
								}
							},
							hide: {
								when: {
									event: "blur"
								}
							},
							position: {
								corner: {
									target: position.field,
									tooltip: position.tooltip
								}
							},
							style: {
								border: {
									radius: 4,
									color: ErrSupply.border_color
								},
								background: ErrSupply.background_color,
								color: ErrSupply.text_color,
								width: 280,
								tip: {
									corner: position.tooltip,
									color: ErrSupply.arrow_color,
									size: {
										x: 10,
										y: 12
									}
								}
							}
						});
					}
					else {
						unmatched[id] = error;
					};
				};
			};
			
			return unmatched;			
		};
		
		// get reference to form firing event
		var $form = $(this);
		
		// find all contained elements with a style of error and remove the class.
		// this is typically more important for ajax submissions. html submissions
		// tend not to have this problem.
		$form.find(".error").removeClass("error");
		
		// hide all fields that have been explicitly destroyed. when an html submission
		// has errors, the _destroy value renders as true rather than 1, which may or may not
		// causes destroyed sets to be visible after the reload.  here, we scan for both 
		// values and hide any containing div.fields elements.
		$form.find("input:hidden[id$=_destroy]").filter("[value=true], [value=1]").closest(".fields").hide();
		
		// apply errors to dom elements
		var unmatched_errors = applyFn(errors) || {};
		
		// publish unmatched errors, in case view cares about that
		$form.trigger("err_supply:unmatched", unmatched_errors);
		
		// move focus to first field with error (or first field)
		var $focus_field = ($form.find(".error").size() > 0) ?
													$form.find(".error").filter(":first") :
													$form.find(":not(.filter) :input:visible:enabled:first");
		$focus_field.focus()
		
		// cancel event
		return false;
	});
});