{** block-description:carousel **}

{if $items}
	<div id="banner_slider_{$block.snapping_id}" class="zbanners owl-carousel ty-scroller"
	    data-ca-scroller-item="1"
	    data-ca-scroller-item-desktop="1"
	    data-ca-scroller-item-desktop-small="1"
	    data-ca-scroller-item-tablet="1"
	    data-ca-scroller-item-mobile="1"
	>
		{foreach from=$items item="banner" key="key"}
			<div class="ty-banner__image-item ty-scroller__item">
				{if $banner.type == "G" && $banner.main_pair.image_id}
					{if $banner.url != ""}<a class="banner__link" href="{$banner.url|fn_url}" {if $banner.target == "B"}target="_blank"{/if}>{/if}
				    <div style="max-height: {$banner.main_pair.icon.image_y}px; overflow: hidden;" class="et-main-banner-img">
				        {include 
                    file="common/image.tpl" 
                    images=$banner.main_pair 
                    et_lazy_owl=true et_lazy_mobile=true
                    class="ty-banner__image"
                    image_width=$block.content.width
                    image_height=$block.content.height
                }
				    </div>
					{if $banner.url != ""}</a>{/if}
				{else}
					<div class="ty-wysiwyg-content">
						{$banner.description nofilter}
					</div>
				{/if}
			</div>
		{/foreach}
	</div>
{/if}

<script>
(function(_, $) {
	$.ceEvent('on', 'ce.commoninit', function(context) {
		var slider = context.find('#banner_slider_{$block.snapping_id}');
		var delay = autoPlay: {($block.properties.delay > 0) ? $block.properties.delay * 1000 : "false"},

		if (slider.length) {
			if (_.language_direction == "rtl"){
			    et_navigationText=['<i class="et-icon-arrow-right"></i>', '<i class="et-icon-arrow-left"></i>'];
			}else{
			    et_navigationText=['<i class="et-icon-arrow-left"></i>', '<i class="et-icon-arrow-right"></i>'];
			}
			slider.owlCarousel({
				direction: '{$language_direction}',
				items: 1,
				singleItem : true,
				slideSpeed: {$block.properties.speed|default:400},
				autoPlay: delay,
				stopOnHover: true,
				transitionStyle: "fade",
				lazyLoad : true,
				lazyEffect: false,
				addClassActive: true,
				afterInit: et_check_loaded,
				afterMove: et_check_loaded,
				{if $block.properties.navigation == "N"}
					pagination: false
				{/if}
				{if $block.properties.navigation == "D"}
					pagination: true
				{/if}
				{if $block.properties.navigation == "P"}
					pagination: true,
					paginationNumbers: true
				{/if}
				{if $block.properties.navigation == "A"}
					pagination: false,
					navigation: true,
					navigationText: et_navigationText
				{/if}
			});
			function et_check_loaded(elem){
			    
			    elem.trigger('owl.stop');
			    images=$(".active img.lazyOwl",slider);
			    if (slider.visible(true)){
			        images.each(function(){
			            var img=$(this);
			            img.one('load', function() { 
			                img.removeAttr("data-src");
			                img.removeAttr("style");
			                img.removeClass("et_lazy_mobile");
			                if (delay){
			                    elem.trigger('owl.play',delay);
			                }
			                return;
			            }).attr('src', img.data("src"))
			            .each(function() {
			              //Cache fix for browsers that don't trigger .load()
			              if(this.complete) $(this).trigger('load');
			            });
			        });
			    }
			}
		}
	});
}(Tygh, Tygh.$));
</script>