{if $addons.master_products.status == "A" && !$product.company_id}

{elseif ($product.company_id>0)}

{if $product.et_quick_info}
	{foreach from=$product.et_quick_info item=item key=key name=name}
		{if $item.v_data.text|trim}
			{$icon_settings=$item.settings.icon}
			<div class="et_quick_info_box">
				<style>{strip}
					{if $item.settings.color_type|default:"S" == "C"}
						#et_quick_info_title_{$item.block_id}{
							background: {$item.settings.bkg_color};
						}
						#et_quick_info_title_{$item.block_id}:hover{
							background: {$item.settings.bkg_color_hover};
						}

						#et_quick_info_title_{$item.block_id} .et_quick_info_title_text,
						#et_quick_info_title_{$item.block_id} .et_quick_info_toggle{
							color: {$item.settings.color};
						}


						#et_quick_info_title_{$item.block_id}:hover .et_quick_info_title_text,
						#et_quick_info_title_{$item.block_id}:hover .et_quick_info_toggle{
							color: {$item.settings.color_hover};
						}
					{/if}

					{if $icon_settings.enabled == "Y" && $icon_settings.color_type|default:"S" == "C"}
						#et_quick_info_title_{$item.block_id} .et_quick_info_title_icon{
							color: {$icon_settings.color}
						}
						#et_quick_info_title_{$item.block_id}:hover .et_quick_info_title_icon{
							color: {$icon_settings.color_hover};
						}
					{/if}
				{/strip}</style>

				{if $item.settings.type=="P"}
					<a id="et_quick_info_title_{$item.block_id}" class="cm-dialog-opener et_quick_info_title_wrapper" data-ca-target-id="content_et_quick_info_{$item.block_id}" rel="nofollow">

						{if $icon_settings.enabled == "Y"}
							<i class="et_quick_info_title_icon {$icon_settings.value}"></i>
						{/if}
						<span class="et_quick_info_title_text">{$item.data.title}</span>
						<span class="et_quick_info_toggle popup">
							<i class="ty-icon-popup"></i>
						</span>
					</a>

					<div id="content_et_quick_info_{$item.block_id}" class="hidden" title="{$item.data.title}" data-ca-keep-in-place="true">
					  {$item.v_data.text nofilter}
					</div>
				{else}
					<div id="et_quick_info_title_{$item.block_id}" class="et_quick_info_title_wrapper" onclick="pp_info_click(this,{$item.block_id});">
						{if $icon_settings.enabled == "Y"}
							<i class="et_quick_info_title_icon {$icon_settings.value}"></i>
						{/if}
						<span class="et_quick_info_title_text">{$item.data.title}</span>
						<span class="et_quick_info_toggle {if $item.settings.expanded.enabled =="Y"}open{/if}">
							<span class="open-symbol "><i class="et-icon-circle-plus"></i></span>
							<span class="close-symbol hidden"><i class="et-icon-circle-minus"></i></span>
						</span>
					</div>

					<div id="et_quick_info_{$item.block_id}" class="et_quick_info_text {if $item.settings.expanded.enabled =="Y"}et-show{/if}">
						<div class="ty-wysiwyg-content">
							{$item.v_data.text nofilter}
						</div>
					</div>
				{/if}
			</div>
		{/if}
	{/foreach}
{/if}
<script>
	function pp_info_click(e,id){
		self=$(this);
		$('.et_quick_info_toggle',e).toggleClass('open'); 

		var tab_height=$('#et_quick_info_'+id).data("tab_height");

		$('#et_quick_info_'+id).slideToggle(0, function(){

			if (tab_height === undefined){
		  	var windowWidth = window.innerWidth || document.documentElement.clientWidth;
				if (windowWidth>480){
		
					left=$(".et-pp-info-inner-wrapper").height();
					right=$(".et-product-right-inner").height();
				}
			}
		});
	}
	</script>
{/if}