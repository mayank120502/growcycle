(function (_, $) {
  $.ceEvent('on', 'ce.commoninit', function (context) {
	$('.cls-synonyms:not(.tag_form)').tag({
		width: "400",
		height: "",
		key: ['enter'],
		clickRemove: true
	});
	  });
})(Tygh, Tygh.$);

$(document).on('change', '.clsInput', function() {
	$('#ajax_loading_box').show();
	var url = window.location.href + '&full_render=1';			
	$( ".clsInput" ).each(function( index, el ) {
		if (!$(el).is(':disabled')) {
			if ($(el).is(":text") || $(el).is("select")){				
				url += "&" + $(el).attr('id') + "=" + $(this).val().replace('#', '');
			}else if($(this).is(":checkbox")){
				if ($(this).is(":checked")){
					url += "&" + $(el).attr('id') + "=" + $(this).val().replace('#', '');	
				}else{
					url += "&" + $(el).attr('id') + "=N";		
				}
			}
		}
	});			
	$.ajax({
		url: url,
	})
	.done(function(data) {
		var parser = new DOMParser();
		var htmlDoc = parser.parseFromString(data, "text/html");
		var headContent = htmlDoc.head.innerHTML;
		headContent = $.parseHTML(headContent);
		contain = 'var/cache/misc/assets/design/backend/css/standalone';			
		$.each( headContent, function( i, el ) {					
			if (el.nodeName=="LINK" && $(el)[0].href.indexOf(contain) >= 0){					
				$($('head link[href*="'+contain+'"]')[0]).attr('href', $(el)[0].href);											
			}							  
		});
		$('#content_csc_live_search_styles input.cmcs-colorpicker:enabled').ceColorpicker();			
		setTimeout(function(){				
			$('#ajax_loading_box').hide();
		}, 50);
	});
});
