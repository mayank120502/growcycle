{if $content|trim}
	{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
	{if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
		<div class="{$sidebox_wrapper|default:"ty-sidebox"}{if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if} et-sidebox-general hidden-phone">
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
	{if $smarty.const.ET_DEVICE != "D" || $et_traditional_resp}

		{$obj_id="`$block.grid_id``$block.block_id`"}
		<script>
		function et_open() {
		  var wrapper='.et-right-menu';
		  $('html').toggleClass('et-noscroll');
		  if ($('body').hasClass('et-right-menu-visible')){
		    // $('body').hasClass('et-right-menu-visible')
		    setTimeout(function(){ 
		      $('body').removeClass('et-right-menu-visible'); 
		      if (isiPhone()) {
		        iNoBounce.disable();
		      }
		    },300);
		  }else{
		    $('body').addClass('et-right-menu-visible');
		    if (isiPhone()) {
		      iNoBounce.enable();
		    }
		  }

		  var content=$(this).parents(wrapper).find('.et-right-menu__content');
		  content.toggleClass('et-right-menu-showing');
		  if (content.hasClass('et-menu__showing')){
		    setTimeout(function(){ 
		      content.removeClass('et-menu__showing'); 
		    },300);
		  }else{
		    content.addClass('et-menu__showing');
		  }
		  $(this).parents(wrapper).find('.ty-menu__item').toggle();
		  $(this).parents(wrapper).find('.et-dim-content').toggleClass('visible');

		  return false;
		}

		function et_sidebox_filters(){
		  var triggers=$('#et-menu-{$obj_id} .et-right-menu__trigger, #et-menu-{$obj_id} .et-menu__close-right, #et-menu-{$obj_id} .et-dim-content');
		  var whichEvent = ('ontouch' in document.documentElement ? "touch" : "click");

		  triggers.off(whichEvent,et_open);
		  triggers.on(whichEvent, et_open);

		  var windowWidth = window.innerWidth || document.documentElement.clientWidth;

		  {if $et_traditional_resp}

			  if (windowWidth<1025){
			  	$("#sidebox_{$block.block_id}>div").appendTo("#et_mobile_sidebox_{$block.block_id}");
			  }

		    $(window).resize(function(){
		    	windowWidth = window.innerWidth || document.documentElement.clientWidth;
		    	if (windowWidth<1025){
		    		$("#sidebox_{$block.block_id}>div").appendTo("#et_mobile_sidebox_{$block.block_id}");

		    		category_content_offset=$(".et-category-content").offset().top-60;
		    		var et_footer=$(".et-mobile-footer-wrapper");
		    		if (et_footer.length>=1){
		    			footer_offset=et_footer.offset().top-$(window).height()+46;
		    		}else{
		    			footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
		    		}
		    		$(document).ready(function(){
		    			if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
		    		    $(".et-mobile-filter-button").show();
		    		  }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
		    		    $(".et-mobile-filter-button").hide();
		    		  }else{
		    		    $(".et-mobile-filter-button").show();
		    		  }
		    		})
		    		$(window).scroll(function(){
		    		  if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
		    		    $(".et-mobile-filter-button").show();
		    		  }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
		    		    $(".et-mobile-filter-button").hide();
		    		  }else{
		    		    $(".et-mobile-filter-button").show();
		    		  }
		    		});
		    	}else{

		    		$("#et_mobile_sidebox_{$block.block_id}>div").appendTo("#sidebox_{$block.block_id}");
		    	}
		    })
		  {/if}
      if (windowWidth<1025){
        category_content_offset=$(".et-category-content").offset().top-60;
        var et_footer=$(".et-mobile-footer-wrapper");
        if (et_footer.length>=1){
        	footer_offset=et_footer.offset().top-$(window).height()+46;
        }else{
        	footer_offset=$(".tygh-footer").offset().top-$(window).height()+46;
        }
        $(document).ready(function(){
        	if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
            $(".et-mobile-filter-button").show();
          }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
            $(".et-mobile-filter-button").hide();
          }else{
            $(".et-mobile-filter-button").show();
          }
        })
        $(window).scroll(function(){
          if ( $(window).scrollTop() > category_content_offset && $(window).scrollTop() <= footer_offset ){
            $(".et-mobile-filter-button").show();
          }else if ( $(window).scrollTop() <= category_content_offset || $(window).scrollTop() >= footer_offset ){
            $(".et-mobile-filter-button").hide();
          }else{
            $(".et-mobile-filter-button").show();
          }
        });
      }
		};

		(function(_, $) {
			var t=false;
			$.ceEvent('on', 'ce.commoninit', function(content) {
				if (t==false){
				  et_sidebox_filters();
				  t=true;
				}
	    });
			$.ceEvent('on', 'ce.ajaxdone', function(content) {
				var t=false;
				if (t==false){
				  et_sidebox_filters();
				  t=true;
				}
	    });
		}(Tygh, Tygh.$));

		</script>

		<div class="et-right-menu et-sidebox-filters" id="et-menu-{$obj_id}" data-et-sidebox-id="{$block.block_id}">

			<div class="et-mobile-filter-button " id="et_mobile_filters_count">
				<a href="#" class="et-right-menu__trigger hidden-desktop mobile-sticky-menu-link" >
					<i class="et-icon-mobile-filter"></i>
					{if $items}
						{$current_filters_count=0}
						{foreach from=$items item="filter" name="filters"}
							{if $filter.selected_variants}
						  	{$current_filters_count=$current_filters_count+count($filter.selected_variants)}
						  {/if}
						  {if $filter.selected_range}
						    {$et_price_filter=true}
						    {$et_price_info=$filter}
						    {$current_filters_count=$current_filters_count+1}
						  {/if}
						 {/foreach}
					{/if}
					{if $current_filters_count>0}
					<span class="et-mobile-filters-count hidden1">{$current_filters_count}</span>
					{/if}
				</a>
			<!--et_mobile_filters_count--></div>

		  <div class="et-right-menu__content {if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">

		    <div class="et-menu__controls hidden et-primary-bkg">
		      <div class="et-menu__title">
	        	{if $smarty.capture.title|trim}
	          	{$smarty.capture.title nofilter}
	          {else}
	          	{$title nofilter}
	          {/if}
		      </div>
		      <div>
		        <a href="#" class="et-menu__btn et-menu__close-right ">
		          <i class="et-icon-menu-close"></i>
		        </a>
		      </div>
		    </div>
		    
		    <div class="et-sidebox-filters-content hidden-desktop" id="et_mobile_sidebox_{$block.block_id}">{if !$et_traditional_resp}{$content nofilter}{/if}</div>
		  </div>
		  <div class="et-dim-content"></div>
		</div>
	{/if}
{/if}