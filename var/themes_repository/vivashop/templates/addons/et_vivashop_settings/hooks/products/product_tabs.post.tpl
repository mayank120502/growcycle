<script>

var et_sticky_element;
var et_sticky_element_count;

function tab_sizes(){
	et_sticky_element = [];
	et_sticky_element_count=-1;
	$('.et-sticky-tabs-wrapper a').each(function () {
		var currLink = $(this);
		var data='#et-tab-'+currLink.data('etTab');
		var tab = $('#et-tab-'+currLink.data('etTab'));
		if (tab.length>=1){
			et_sticky_element_count++;
		var el_top = tab.offset().top;
		var el_top_height=el_top + tab.outerHeight(true);
		var x=[];

		if (windowWidth>768){
			var offset=134;
		}else{
			var offset=51;
		}

		x['name']='.et-sticky-'+currLink.data('etTab'); //0 - tab name
		if (et_sticky_element_count==0){
			x['pos']=el_top; //1 - tab position 
			x['height']=el_top_height-10; //2 - tab active_period
		}else{
			x['pos']=et_sticky_element[et_sticky_element_count-1]['height'];
			x['height']=el_top_height-10;
		}
		et_sticky_element[et_sticky_element_count]=x;
		}
	});
}


var tab_off;
var sticky_product=$('#et-sticky-prod-wrapper').outerHeight(true);
var sticky_tabs=$('.et-sticky-tabs-wrapper').outerHeight(true);
var tab_scroll_offset=sticky_product;
var atc_offset=$(".et-product-atc").offset().top;
var current_image_offset;
var prev_image_offset=0;
var show_atc=true;
var pos_rechecked=false;

function et_sticky_tabs(){
	window_top = $(window).scrollTop() + 0;
	atc_offset=$(".et-product-atc").offset().top;
	{if $addons.master_products.status == "A" && !$product.company_id}
		atc_offset-=150;
	{/if}

	if (windowWidth>768){
		tab_scroll_offset=sticky_product+sticky_tabs + 0;
		var tab_scroll_pos = $(window).scrollTop()+tab_scroll_offset;
	}else{
		tab_scroll_offset=sticky_tabs;
		var tab_scroll_pos = $(window).scrollTop()+tab_scroll_offset;
	}

	{if $smarty.const.ET_DEVICE != "D"}
		var et_footer=$(".et-mobile-footer-wrapper");
		if ($(".footer-copyright").length>=1){
			var et_footer=$(".footer-copyright");
		}
	{else}
		var et_footer=$(".et-footer-wrapper");
	{/if}
	if (et_footer.length>=1){
		footer_offset=et_footer.offset().top-$(window).height()-92;
	}else{
		footer_offset=$(".tygh-footer").offset().top-$(window).height()+92;
	}
	if ( window_top > footer_offset && windowWidth<768){
		{if $smarty.const.ET_DEVICE != "D"}
			$('#et-sticky-prod-wrapper').removeClass('et-sticky-visible');
		{/if}

	}else if (window_top > atc_offset && show_atc) {
		$('#et-sticky-prod-wrapper').addClass('et-sticky-visible 1');
		var content=$('.price-wrap').html();
		$('.sticky-price').html(content);

	} else {
		$('#et-sticky-prod-wrapper').removeClass('et-sticky-visible');
	}

	{if $settings.Appearance.product_details_in_tab != "N"}
		pos_rechecked=false;
		if (!pos_rechecked){
			tab_title_height=$('.ty-tabs').height();
			tab_pos_start_top=$('.ty-tabs').offset().top;
			{if $use_vendor_url}
				tab_pos_start_top=tab_pos_start_top-0;
			{/if}
			pos_rechecked=true;
		}
	{/if}

	{if $settings.Appearance.product_details_in_tab == "N"}
		if (windowWidth>768){
			var offset=124;
		}else{
			var offset=51;
		}
		if (window_top >= tab_off) {
			if (!pos_rechecked){
				tab_off=$(".et-product-tabs").offset().top-sticky_product;
				pos_rechecked=true;
			}
			$(".et-sticky-tabs-wrapper").data("tab_scroll_offset",tab_scroll_offset)
			$('.et-sticky-tabs-wrapper').addClass('et-sticky-visible');
			sticky_product=$('#et-sticky-prod-wrapper').outerHeight(true);
		} else if  (window_top < tab_off-offset){
			$('.et-sticky-tabs-wrapper').removeClass('et-sticky-visible');
		}
	{else}
		// if (window_top > tab_pos_start_top ) {

		// 	$('.ty-tabs').css('height',tab_title_height);
		// 	$('.ty-tabs__list').addClass('et_sticky');
		// 	$('.ty-tabs__list').css('top',atc_box_sticky_offset);
		// 	$('.ty-tabs__list').css('left',tab_pos_left);
		// 	$('.ty-tabs__list').css('width',tab_start_width);
		// }else {

		// 	$('.ty-tabs__list').removeClass('et_sticky');
		// 	$('.ty-tabs__list a').removeClass('cm-external-click').removeClass('et-external-click');

		// }

	{/if}

	for (var i=0; i <= et_sticky_element_count; i++) {
		var tab=$(et_sticky_element[i]['name']);
		var el_top=et_sticky_element[i]['pos'];
		var height=et_sticky_element[i]['height'];
		
		if ( el_top <= tab_scroll_pos &&  height > tab_scroll_pos) {
			if (!tab.hasClass("active") && !tab.parent().hasClass('page-scrolling')){
		    $('.et-sticky-tabs-wrapper a.active').removeClass("active");
		    tab.addClass("active");



		    if (tab.visible(false)){
		    }else{
		    	offset_left=tab.offset().left;
		    	$('.et-sticky-tabs-wrapper').animate({
		    		scrollLeft: "+="+(offset_left-10)
		    	}, 400);
		    }
			}
	    break;
	  }
	}
}

$( window ).load(function(){
	window_top = $(window).scrollTop() + 0;

	//sticky tabs
	tab_sizes();


	tab_off=$(".et-product-tabs").offset().top-sticky_product;

  $('.et-sticky-tabs-wrapper a').click(function(){
    var self = $(this);
    var elm = $('#content_'+self.data('etTab'));
    var elm = $('#et-tab-'+self.data('etTab'));
    if (!self.parent().hasClass('page-scrolling')){
	    if (windowWidth>768){
	    	var offset=124;
	    }else{
	    	var offset=46;
	    }
	    var elm_offset = elm.offset().top-offset;
	    self.parent().addClass('page-scrolling');

	    $('.et-sticky-tabs-wrapper a.active').removeClass("active");
	    self.addClass('active');
		
	    if (!self.visible(false)){
	    	offset_left=self.offset().left;
	    	$('.et-sticky-tabs-wrapper').animate({
	    		scrollLeft: "+="+(offset_left-10)
	    	}, 400,function(){
	    		self.addClass('active');
	    	});
	    }

	    $('html, body').animate({
	      scrollTop: elm_offset
	    }, 400,function(){

	    	self.parent().removeClass('page-scrolling');
	    });
    }
    
  });

  // sticky tabs
  {if $settings.Appearance.product_details_in_tab != "N"}
    var tab_title_height=$('.ty-tabs').height();
    var tab_pos_start_top=$('.ty-tabs').offset().top;
    var tab_start_width=$('.ty-tabs').outerWidth();
    var tab_pos_left=$('.ty-tabs').offset().left;
    var tab_height=$('#tabs_content').outerHeight(true)+tab_title_height;
    var tab_end=tab_pos_start_top+tab_height;
    var sticky_product=$('#et-sticky-prod-wrapper').outerHeight(true);
  {/if}

  {if $use_vendor_url}
  	var atc_box_sticky_offset=$('.et-vendor-store-menu').outerHeight(true);
  	{if $settings.Appearance.product_details_in_tab != "N"}
  		tab_pos_start_top=tab_pos_start_top-atc_box_sticky_offset;
  	{else}
  		tab_pos_start_top=atc_box_sticky_offset;
  	{/if}
  	$('.ty-tabs__list a').click(
  		function() {
  			if ($(this).hasClass('et-external-click')){
  		    $('html, body').animate({
  		        scrollTop: tab_pos_start_top
  		    }, 250);
  		  }
  		});
  {else}
  	var atc_box_sticky_offset=0;

  {/if}

	// stick the tabs
	{if $settings.Appearance.product_details_in_tab == "N"}
		if (window_top > tab_off) {
			$(".et-sticky-tabs-wrapper").data("tab_scroll_offset",tab_scroll_offset)
			$('.et-sticky-tabs-wrapper').addClass('et-sticky-visible');
			sticky_product=$('#et-sticky-prod-wrapper').outerHeight(true);
		}
	{else}
		if (window_top > tab_pos_start_top ) {

			$('.ty-tabs').css('height',tab_title_height);
			$('.ty-tabs__list').addClass('et_sticky animate');
			$('.ty-tabs__list').css('top',atc_box_sticky_offset);
			$('.ty-tabs__list').css('left',tab_pos_left);
			$('.ty-tabs__list').css('width',tab_start_width);

			if (atc_box_sticky_offset){
				$('.ty-tabs__list a').addClass('et-external-click');
			}
		}
	{/if}

	///end onload


	var windowWidth = window.innerWidth || document.documentElement.clientWidth;
	et_sticky_tabs();


	$(window).scroll(function(){
		et_sticky_tabs();
	});
{literal}
	var x,y,top,left,down;
	$(".et-sticky-tabs-wrapper .et-sticky-content").mousedown(function(e){
		    e.preventDefault();
		    down = true;
		    x = e.pageX;
		    y = e.pageY;
		    top = $(this).scrollTop();
		    left = $(this).scrollLeft();
		});

	$("body").mousemove(function(e){
	    if(down){
	        var newX = e.pageX;
	        var newY = e.pageY;

	        $(".et-sticky-tabs-wrapper .et-sticky-content").scrollLeft(left - newX + x);    
	    }
	});

	$("body").mouseup(function(e){down = false;});
{/literal}

	$('.cm-dialog-opener').click(function(){
		$('.ui-dialog .et-pro-banner').css('opacity', 1);
	});

})

</script>
