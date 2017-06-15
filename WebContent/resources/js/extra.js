(function ($) {
        $.fn.styleTable = function (options) {
            var defaults = {
                css: 'styleTable'
            };
            options = $.extend(defaults, options);

            return this.each(function () {

                input = $(this);
                input.addClass(options.css);

                input.find("tr").live('mouseover mouseout', function (event) {
                    if (event.type == 'mouseover') {
                        $(this).children("td").addClass("ui-state-hover");
                    } else {
                        $(this).children("td").removeClass("ui-state-hover");
                    }
                });

                input.find("th").addClass("ui-state-default");
                input.find("td").addClass("ui-widget-content");

                input.find("tr").each(function () {
                    $(this).children("td:not(:first)").addClass("first");
                    $(this).children("th:not(:first)").addClass("first");
                });
            });
        };
    })(jQuery);
function updateTips( tipObj,tipText ) {
	tipObj.text( tipText ).addClass( "ui-state-highlight" );
		setTimeout(function() {
			tipObj.removeClass( "ui-state-highlight", 1500 );
		}, 500 );
	}

	function checkLength( obj,tipObj, objName, min, max ) {
		if ( obj.val().length > max || obj.val().length < min ) {
			obj.addClass( "ui-state-error" );
			updateTips(tipObj, "Length of " + objName + " must be between " +
				min + " and " + max + "." );
			return false;
		} else {
			return true;
		}
	}

	function checkRegexp( obj,tipObj, regexp, n ) {
		if ( !( regexp.test( obj.val() ) ) ) {
			obj.addClass( "ui-state-error" );
			updateTips( tipObj,n );
			return false;
		} else {
			return true;
		}
	}
	
	function checkValue( obj,tipObj, objName, min, max ) {
		if ( obj.val() > max || obj.val() < min ) {
			obj.addClass( "ui-state-error" );
			updateTips(tipObj, "" + objName + " must be between " +
				min + " and " + max + "." );
			return false;
		} else {
			return true;
		}
	}