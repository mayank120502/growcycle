{$et_menu_image_style=""}
{$et_menu_image_pad=""}
{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}

{if  $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
	{if $et_menu.size.width}
		{$et_menu_image_style="width:`$et_menu.size.width`px;"}
	{/if}

	{if $et_menu.size.height}
		{$et_menu_image_style="`$et_menu_image_style` min-height:`$et_menu.size.height`px;"}
	{/if}

	{if $et_menu.banner.enabled == "Y"}
		{if $et_menu.banner.push_menu == "Y"}
			{$et_menu_image_pad_value=$et_menu.banner.img.icon.image_x+$et_menu.banner.offset_right}
			{if $language_direction == 'rtl'}
				{$et_menu_image_pad="padding-left:`$et_menu_image_pad_value`px;"}
			{else}
				{$et_menu_image_pad="padding-right:`$et_menu_image_pad_value`px;"}
			{/if}
		{else}
			{$et_menu_image_pad=""}
		{/if}

		{if !empty($et_menu_image_pad)}
			{$et_menu_image_style="`$et_menu_image_style`"}
		{/if}
	{/if}
{/if}


<div class="ty-menu__submenu-items cm-responsive-menu-submenu et-menu-{$level}-wrapper {if !$data}et-menu-empty{/if}" style="{$et_menu_image_style}">
	{hook name="et_menu:product"}
		<ul class="et-menu-{$level}" style="{$et_menu_image_pad}">
	    {foreach from=$data item="item1"}
				{$item_url=$item1|fn_form_dropdown_object_link:"categories"}
	    	{$et_menu_this=$item1.et_menu}

				{$cat_thumbnail_size=45}

				{* LABEL *}
				{capture name="et_title_label" assign="et_title_label"}
				  {if isset($et_menu_this.text) && $et_menu_this.text.enabled == "Y" && $et_menu_this.text.label}
				    <span class="et_menu_label et_menu_text_{$et_menu_this.et_menu_id}"  style="color: {$et_menu_this.text.color};
				      background: {$et_menu_this.text.bkg};">{$et_menu_this.text.label}</span>
				  {/if}
				{/capture}

				<li class="ty-top-mine__submenu-col">
					{* Desktop code *}
					{if $smarty.const.ET_DEVICE == "D" || $et_traditional_resp}
						<div class="hidden-phone hidden-tablet">
							{if $et_menu.thumbnails.enabled=="Y"}
								<a {if $item_url}href="{$item_url}"{/if} class="et-sub-categ-img-link" style="min-width: {$cat_thumbnail_size}px;">
							    {include file="common/image.tpl" images=$et_menu_this.category_img.detailed image_width=$cat_thumbnail_size image_height=$cat_thumbnail_size et_lazy_menu=true}
								</a>
							{/if}
							<div class="et-menu-lev-2-inline-wrapper">
								<div class="ty-menu__submenu-item-header {if $item1.$childs}et-has-child{/if} clearfix">
								 	<a{if $item_url} href="{$item_url}"{/if} class="ty-menu__submenu-link">{$item1.category}{$et_title_label nofilter}
								 	</a>
								</div>
								{if $item1.$childs}
								  	{et_dropdown data=$item1.$childs childs=$childs level=3 show_more=$item1.show_more show_more_link=$item_url link_name=$link_name separator="/"}
								{/if}
							</div>
						</div>
					{/if}

					{if $smarty.const.ET_DEVICE != "D" || $et_traditional_resp}
						<div class="hidden-desktop">
							{* Mobile code *}
							{$cat_thumbnail_size=28}

							{if $item1.$childs}
							  <div class="ty-menu__item-toggle hidden-desktop cm-responsive-menu-toggle">
							    <i class="ty-menu__icon-open et-icon-circle-plus"></i>
							    <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
							  </div>
							{/if}

							<div class="ty-menu__submenu-item-header clearfix">
								<a{if $item_url} href="{$item_url}"{/if} class="et-categ-link et-sub-categ-img-link {if $et_menu.thumbnails.enabled!="Y"|| !$et_menu_this.category_img.detailed}et-no-icon{/if} {if $item1.$childs}et-has-sub{/if}" style="min-width: {$cat_thumbnail_size}px;">
									{if $et_menu.thumbnails.enabled=="Y"}
							    	{include file="common/image.tpl" images=$et_menu_this.category_img.detailed image_width=$cat_thumbnail_size image_height=$cat_thumbnail_size et_lazy_menu=true}
						    	{/if}
							    <span><span class="et-menu-link">{$item1.category}</span>{$et_title_label nofilter}</span>
								</a>
							</div>

							{if $item1.$childs}
								<div class="ty-menu__submenu level-3">
								  <ul class="ty-menu__submenu-items cm-responsive-menu-submenu">
								    {foreach from=$item1.$childs item="item2"}
								      {$item_url=$item2|fn_form_dropdown_object_link:"categories"}
								      {$et_menu2=$item2.et_menu}
								      {$cat_thumbnail_size=28}

								      {* LABEL *}
								      {capture name="et_title_label" assign="et_title_label"}{strip}
								        {if isset($et_menu2.text) && $et_menu2.text.enabled == "Y" && $et_menu2.text.label}
								          &nbsp;<span class="et_menu_label et_menu_text_{$et_menu2.et_menu_id}"  style="color: {$et_menu2.text.color};
								            background: {$et_menu2.text.bkg};">{$et_menu2.text.label}</span>
								        {/if}
								      {/strip}{/capture}
								      <li class="ty-top-mine__submenu-col">
								      	<div class="ty-menu__submenu-item-header">
									        <a{if $item_url} href="{$item_url}"{/if} class="et-categ-link et-sub-categ-img-link {if $et_menu.thumbnails.enabled!="Y" || !$et_menu2.category_img.detailed}et-no-icon{/if}" style="min-width: {$cat_thumbnail_size}px;">
										        {if $et_menu.thumbnails.enabled=="Y" && $et_menu2.category_img.detailed}
										           {include file="common/image.tpl" images=$et_menu2.category_img.detailed image_width=$cat_thumbnail_size image_height=$cat_thumbnail_size et_lazy_menu=true}
										        {/if}
									           <span><span class="et-menu-link">{$item2.category}</span>{$et_title_label nofilter}</span>
									        </a>
									      </div>
								      </li>
								    {/foreach}
								  </ul>
								 </div>
							{/if}
						</div>
					{/if}


				</li>
	    {/foreach}

			{if $et_menu.banner.enabled == "Y"  && ($smarty.const.ET_DEVICE == "D" || $et_traditional_resp)}
				<li class="et_menu_image et_menu_image-{$item1.parent_id}">
					
					{$offset_right=$et_menu.banner.offset_right|default:0}
					{$offset_bottom=$et_menu.banner.offset_bottom|default:0}

					{if $language_direction == 'rtl'}
						{$et_offset="left:`$offset_right`px; bottom:`$offset_bottom`px;"}
					{else}
						{$et_offset="right:`$offset_right`px; bottom:`$offset_bottom`px;"}
					{/if}

					<div style="position: absolute;{$et_offset}" class="et_menu_image_container">
						{if $et_menu.banner.url}
							{$banner_url = $et_menu.banner.url|trim}
							<a href="{$banner_url}">
						{/if}
						{include file="common/image.tpl" images=$et_menu.banner.img et_lazy_menu=true}
						{if $et_menu.banner.url}
							</a>
						{/if}
					</div>
				</li>
			{/if}
		</ul>
	{/hook}
</div>