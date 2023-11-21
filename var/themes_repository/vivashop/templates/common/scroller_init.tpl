<script>
(function(_, $) {
  // var elm;

  {if $scroll_list_id}
    {$et_slider_id=$scroll_list_id}
  {elseif $item.tab_id}
    {$et_slider_id="scroll_list_`$block.block_id`_`$item.tab_id`"}
  {else}
    {$et_slider_id="scroll_list_`$block.block_id`"}
  {/if}

  function et_init_{$et_slider_id}(){
    var elm=$('#{$et_slider_id}');

    var item = {$block.properties.item_quantity|default:5},
      // default setting of carousel
      itemsDesktop = 4,
      itemsDesktopSmall = 3;
      itemsTablet = 2;
      itemsCustom=false;
      {if $et_mobile_items}
        var itemsCustom = [
          [0, 1],
          [340, {$et_mobile_items}],
          [768, 4],
          [1000, item-2],
          [1200, item-1],
          [1430, item-1],
          [1650, item]
        ];
      {else}
        if (item > 5) {
          var itemsCustom = [
            [0, 1],
            [340, 2],
            [768, 2],
            [1000, item-3],
            [1200, item-2],
            [1430, item-1],
            [1650, item]
          ];
        }else if (item > 3) {
          itemsCustom=false;
          itemsDesktop = item;
          itemsDesktopSmall = item - 1;
          itemsTablet = item - 2;
        } else if (item == 1) {
          itemsDesktop = itemsDesktopSmall = itemsTablet = 1;
        } else {
          itemsDesktop = item;
          itemsDesktopSmall = itemsTablet = item - 1;
        }
      {/if}
    

    var desktop = [1199, itemsDesktop],
      desktopSmall = [979, itemsDesktopSmall],
      tablet = [768, itemsTablet];
    var mobile = [479, 1];

    {if $block.properties.outside_navigation == "Y" || $et_outside_nav}
    function outsideNav () {
      hide=false;
      {if $custom_nav_id}
          nav_id="#{$custom_nav_id}";
      {else}
          nav_id="#owl_outside_nav_{$block.block_id}";
      {/if}
      if(this.options.items >= this.itemsAmount){
        $(nav_id).addClass('et-disabled');
        hide=true;
      } else {
        $(nav_id).addClass('et-enabled');
        $(nav_id).show();
      }
      {if $et_no_rewind}
        if (!hide){
          if (this.currentItem == 0){

            $(".owl-prev",nav_id).addClass('et-disabled');
            $(".owl-next",nav_id).removeClass('et-disabled');
          }else if (this.currentItem == this.maximumItem){
            $(".owl-prev",nav_id).removeClass('et-disabled');
            $(".owl-next",nav_id).addClass('et-disabled');
          }else{
            $(".owl-prev",nav_id).removeClass('et-disabled');
            $(".owl-next",nav_id).removeClass('et-disabled');
          }
        }
      {/if}
      etScrollerFunc();
    }
    {/if}

    function etScrollerFunc(){
      {if $block.properties.not_scroll_automatically != "Y" }
        $(this).trigger('owl.stop');
        elm.addClass('stopped');
        elm.data("delay",{$block.properties.pause_delay * 1000|default:0});
        if (elm.visible(true)){
          elm.removeClass('stopped');
          $(this).trigger('owl.play',{$block.properties.pause_delay * 1000|default:0});
        }
      {/if}

      $(".active .etLazy",elm).each(function(){
        var img=$(this);
          img.one('load', function() { 
              img.removeAttr("data-src");
              img.removeClass("etLazy");
              img.addClass("et_js");
              
              img.removeAttr("style");
              return;
          }).attr('src', img.data("src"))
          .each(function() {
            //Cache fix for browsers that don't trigger .load()
            if(this.complete) $(this).trigger('load');
          });
      })
    }

    if (elm.length) {
      elm.owlCarousel({
        direction: '{$language_direction}',
        items: item,
        {if $et_companies_scroller}
            items: 6,
            scrollPerPage: true,
            autoPlay: false,
        {else}
          items: item,
          itemsDesktop: desktop,
          itemsDesktopSmall: desktopSmall,
          itemsTablet: tablet,
          itemsMobile: mobile,
          itemsCustom : itemsCustom,
          {if $block.properties.not_scroll_automatically == "Y" }
            autoPlay: false,
          {else}
            autoPlay: '{$block.properties.pause_delay * 1000|default:0}',
          {/if}
        {/if}
        {if $block.properties.scroll_per_page == "Y"}
          scrollPerPage: true,
        {/if}
        {if $et_no_rewind}
          rewindNav: false,
        {/if}
        addClassActive: true,
        lazyLoad : true,
        slideSpeed: {$block.properties.speed|default:400},
        rewindSpeed: {$block.properties.speed|default:400},
        stopOnHover: false,
        pagination: false,
        lazyEffect: false,

        {if $block.properties.outside_navigation == "Y" || $et_companies_scroller}

            afterInit: outsideNav,
            afterUpdate : outsideNav,
            afterMove : outsideNav
          });
          $('{$prev_selector}').click(function(){
            elm.trigger('owl.prev');
          });
          $('{$next_selector}').click(function(){
            elm.trigger('owl.next');
          });

        {else}
          navigation: true,
          navigationText: ['', ''],
        });
        {/if}

    }
  }

  $.ceEvent('on', 'ce.commoninit', function(context) {
    {if $scroll_list_id}
      var elm=context.find('#{$scroll_list_id}');
    {elseif $item.tab_id}
      var elm=context.find('#scroll_list_{$block.block_id}_{$item.tab_id}');
    {else}
      var elm=context.find('#scroll_list_{$block.block_id}');
    {/if}

    if (elm.visible(true)){
      et_init_{$et_slider_id}();
    }else{
      elm.addClass('et_not_loaded_scroller_init');
    }
  });

  $(document).ready(function(){
    var not_loaded=$("#{$et_slider_id}.et_not_loaded_scroller_init");
    $(window).scroll(function(){
      if (not_loaded.length>0 && $("#{$et_slider_id}.et_not_loaded_scroller_init").visible(true)){
        et_init_{$et_slider_id}();
        $("#{$et_slider_id}").removeClass('et_not_loaded_scroller_init');
        not_loaded=[];
      }
    })
  })
}(Tygh, Tygh.$));
</script>