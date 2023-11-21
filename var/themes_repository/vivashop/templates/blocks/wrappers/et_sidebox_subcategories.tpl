{if $content|trim && !$et_is_vendor_search}
	{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
	{if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
		<div class="{$sidebox_wrapper|default:"ty-sidebox"}{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if} et-sidebox-general visible-desktop">
			<h2 class="ty-sidebox__title cm-combination {if $header_class} {$header_class}{/if} hidden-phone" id="sw_sidebox_{$block.block_id}">
				{hook name="wrapper:sidebox_general_title"}
				{if $smarty.capture.title|trim}
				<span class="hidden-phone">
					{$smarty.capture.title nofilter}
				</span>
				{else}
					<span class="ty-sidebox__title-wrapper">{$title nofilter}</span>
				{/if}
					{if $smarty.capture.title|trim}
						<span class="visible-phone">

							{$smarty.capture.title nofilter}
						</span>
					{else}
						<span class="ty-sidebox__title-wrapper visible-phone">{$title nofilter}</span>
					{/if}
					<span class="ty-sidebox__title-toggle visible-phone">
						<i class="ty-sidebox__icon-open ty-icon-down-open"></i>
						<i class="ty-sidebox__icon-hide ty-icon-up-open"></i>
					</span>
				{/hook}
			</h2>

			<div class="ty-sidebox__body" id="sidebox_{$block.block_id}">{$content|default:"&nbsp;" nofilter}</div>
		</div>
	{/if}

	{$obj_id="`$block.grid_id``$block.block_id`"}
	<script>
	(function(_, $) {

	  var triggers=$('#et-menu-{$obj_id} .et-left-menu__trigger, #et-menu-{$obj_id} .et-menu__close-left, #et-menu-{$obj_id} .et-dim-content');
	  var whichEvent = ('ontouch' in document.documentElement ? "touch" : "click");

	  if(_.isTouch && window.navigator.msPointerEnabled) {
	      whichEvent = 'click';
	  }

	  triggers.on(whichEvent, function(e) {
	    var wrapper='.et-left-menu';

	    $('html').toggleClass('et-noscroll');

	    $('body').toggleClass('et-left-menu-visible');
	    if ($('body').hasClass('et-left-menu-visible')){
	    	if (isiPhone()) {
	    	  iNoBounce.enable();
	    	}
	    }else{
	    	if (isiPhone()) {
	    	  iNoBounce.disable();
	    	}
	    }
	    $(this).toggleClass('et-opened');
	    $(this).parents(wrapper).find('.et-left-menu__content').toggleClass('et-left-menu-showing et-menu__showing');
	    $(this).parents(wrapper).find('.ty-menu__item').toggle();
	    $(this).parents(wrapper).find('.et-dim-content').toggleClass('visible');

	    return false;
	  });

	  var windowWidth = window.innerWidth || document.documentElement.clientWidth;

	  {if $et_traditional_resp}
	    $(window).resize(function(){
	    	windowWidth = window.innerWidth || document.documentElement.clientWidth;
	    	if (windowWidth<1025){
	    		$("#sidebox_{$block.block_id}>div").appendTo("#et_mobile_sidebox_{$block.block_id}");

		  		var et_footer=$(".et-mobile-footer-wrapper");
		  		if (et_footer.length>=1){
		  			footer_offset=et_footer.offset().top-$(window).height()+46;
		  		}else{
		  			footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
		  		}
		  		category_content_offset=$(".et-category-content").offset().top-60;
			  	if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
			  		$(".et-mobile-categories-button").show();
				  }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
				  	$(".et-mobile-categories-button").hide();
				  }else{
				  	$(".et-mobile-categories-button").show();
				  }

  			  $(window).scroll(function(){
  				  var et_footer=$(".et-mobile-footer-wrapper");
  				  if (et_footer.length>=1){
  				  	footer_offset=et_footer.offset().top-$(window).height()+46;
  				  }else{
  				  	footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
  				  }

  				  category_content_offset=$(".et-category-content").offset().top-60;
  			  	if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
  			  		$(".et-mobile-categories-button").show();
  				  }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
  				  	$(".et-mobile-categories-button").hide();
  				  }else{
  				  	$(".et-mobile-categories-button").show();
  				  }
  				});
	    	}else{

	    		$("#et_mobile_sidebox_{$block.block_id}>div").appendTo("#sidebox_{$block.block_id}");
	    	}
	    });
	  {/if}

	  if (windowWidth<1025){

	  	$(document).ready(function(){
	  		var et_footer=$(".et-mobile-footer-wrapper");
	  		if (et_footer.length>=1){
	  			footer_offset=et_footer.offset().top-$(window).height()+46;
	  		}else{
	  			footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
	  		}
	  		category_content_offset=$(".et-category-content").offset().top-60;
		  	if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
		  		$(".et-mobile-categories-button").show();
			  }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
			  	$(".et-mobile-categories-button").hide();
			  }else{
			  	$(".et-mobile-categories-button").show();
			  }
	  	})
		  $(window).scroll(function(){
			  var et_footer=$(".et-mobile-footer-wrapper");
			  if (et_footer.length>=1){
			  	footer_offset=et_footer.offset().top-$(window).height()+46;
			  }else{
			  	footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
			  }

			  category_content_offset=$(".et-category-content").offset().top-60;
		  	if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
		  		$(".et-mobile-categories-button").show();
			  }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
			  	$(".et-mobile-categories-button").hide();
			  }else{
			  	$(".et-mobile-categories-button").show();
			  }
			});
		}
	}(Tygh, Tygh.$));

	</script>

	<div class="et-left-menu et-sidebar-subcategories" id="et-menu-{$obj_id}">

	  <div class="et-mobile-categories-button">
	  	<a href="#" class="et-left-menu__trigger hidden-desktop mobile-sticky-menu-link" >
	  		<i class="et-icon-mobile-categories"></i>
	  	</a>
	  </div>

	  <div class="et-left-menu__content {if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">

	    <div class="et-menu__controls et-primary-bkg">
	      <div class="et-menu__title">
	      	{if $smarty.capture.title|trim}
	        	{$smarty.capture.title nofilter}
	        {else}
	        	{$title nofilter}
	        {/if}
	      </div>
	      <div class="">
	        <a href="#" class="et-menu__btn et-menu__close-left">
	          <i class="et-icon-menu-close"></i>
	        </a>
	      </div>
	    </div>

	    <div class="ty-sidebox__body hidden-desktop" id="et_mobile_sidebox_{$block.block_id}">{if !$et_traditional_resp}{$content nofilter}{/if}</div>
	  </div>
	  <div class="et-dim-content"></div>
	</div>
{/if}