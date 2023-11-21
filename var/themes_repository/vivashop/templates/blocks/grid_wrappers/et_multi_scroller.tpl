<div class="et-multi-scroller-wrapper">
	<div class="et-title-wrapper">
		<ul class="clearfix et-multi-scroller-ul">
			{$et_grid_id=$grid.grid_id}
			{$first_active=false}

			{foreach from=$navigation.et_content.$et_grid_id item=item key=key name="tab"}
				{$et_ms_id="`$et_grid_id`_`$key`"}
				{$et_block_id=$key}

				{if !$navigation.et_content.has_content.$et_block_id}
					{continue}
				{/if}
				
				<li class="item-{$et_ms_id} {if !$first_active}active{/if}" data-et-tab="tab-{$et_ms_id}" id="tab_title_{$et_ms_id}">
					{if $smarty.foreach.tab.first}
						<a>
							<span>{$item}</span>
						</a>
					{else}
						<a class="tab-{$et_ms_id} cm-ajax cm-ajax-full-render" href="{"et_tabs.et_load?block_id=`$et_block_id`&grid_id=`$et_grid_id`&sl=`$smarty.const.CART_LANGUAGE`"|fn_url}" data-ca-target-id="content_tab_{$et_ms_id}">
							<span>{$item}</span>
						</a>
					{/if}
				</li>
				{$first_active=true}
			{/foreach}
		</ul>
	</div>
	{$content nofilter}
	
</div>

<script>
//<![CDATA[
(function() {
	function et_hover(){
	  $(".et-multi-scroller-ul a").hover(function(e){
	    	$(this).addClass('et-hover');
	    }, function(e){
	    	$(this).removeClass('et-hover');
	  });
	}

  $(".et-multi-scroller-wrapper").each(function(){
    var self_wrap=$(this);

    if (self_wrap.data("rendered") != true){

    
      $("li",self_wrap).click(function(){
        var self=$(this);
        var className=self.data("etTab");

        self.siblings().removeClass("active");

        var scroller=$(".et-multi-scroller.active .et-scroller",self_wrap);

        $(".et-multi-scroller.active",self_wrap).removeClass("active");
        $(".content-"+className,self_wrap).addClass("active");
        self.addClass("active");
      })
      self_wrap.data("rendered",true);
    }
  })
  $(document).ready(function(){
  	et_hover();
  })
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
  	et_hover();
  })
})();
//]]>
</script>