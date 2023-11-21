{** block-description:carousel **}
{if $items}
	{$et_traditional_resp=$addons.et_vivashop_settings.et_viva_responsive=="traditional"}
	<div class="et-homepage-banners et-pro-banner {if $et_main_slider}et-pro-banner-full{else}et-pro-banner-fixed{/if}">

		<div id="banner_slider_{$block.snapping_id}_{$et_id}" class="banners {if count($items)>1}owl-carousel{/if}">
		{foreach from=$items item="banner" key="key"}
			{$banner_id=$banner.banner_id}
			{if $banner.type == "E"}

				{if $smarty.const.HTTPS}
				  {$et_img_path="https_image_path"}
				{else}
				  {$et_img_path="http_image_path"}
				{/if}

				{if $et_traditional_resp}
					{$devices=['M','T','D']}
				{else}
					{$devices=[$smarty.const.ET_DEVICE]}
				{/if}

				<div class="et-extended-banner">

					{foreach from=$devices item="current_device"}

						{if $current_device == "M" && $banner.et_settings.phone.enabled=="Y"}
						  {* MOBILE *}
						  {$et_device="phone"}
						  {$image=$banner.et_settings.phone.main_pair.icon.$et_img_path}
						  {$height=$banner.et_settings.phone.main_pair.icon.image_y}
						  {$banner_text_wrapper_style=""}
						  {$background_style="background-color: `$banner.et_settings.$et_device.bkg`;"}

						  {if $height}
						  	{$background_style="background: url(`$image`) center center/cover no-repeat  `$banner.et_settings.phone.bkg`; height: `$height`px;"}
						  	{$banner_text_wrapper_style="height: `$height`px;"}
						  	{$background_div_info="data-et-height=`$banner.et_settings.phone.main_pair.icon.image_y` data-et-width=`$banner.et_settings.phone.main_pair.icon.image_x`"}
						  {/if}
						  {if $banner.et_settings.$et_device.additional.main_pair.icon.image_x && $banner.et_settings.$et_device.image_pos=="H"}
						  	{$additional_image_wrapper_style="max-width: `$banner.et_settings.$et_device.additional.main_pair.icon.image_x`px;"}
						  {/if}

						  {$et_banner_link="et_banner_link_`$banner_id`"}
					    {capture name="et_banner_link_`$banner_id`"}
					  	  {if $banner.et_settings.$et_device.url != ""}
					  	  	<a class="et-banner__link" href="{$banner.et_settings.$et_device.url|fn_url}" {if $banner.et_settings.$et_device.target == "B"}target="_blank"{/if}></a>
					  	  {/if}
					    {/capture}
						{elseif $current_device == "T" && $banner.et_settings.tablet.enabled=="Y"}
						  {* TABLET *}
						  {$et_device="tablet"}
						  {$image=$banner.et_settings.tablet.main_pair.icon.$et_img_path}
						  {$height=$banner.et_settings.tablet.main_pair.icon.image_y}
						  {$banner_text_wrapper_style=""}
						  {$background_style="background-color: `$banner.et_settings.$et_device.bkg`;"}

						  {if $height}
						  	{$background_style="background: url(`$image`) center center/cover no-repeat `$banner.et_settings.tablet.bkg`; height: `$height`px;"}
						  	{$banner_text_wrapper_style="height: `$height`px;"}
						  	{$background_div_info="data-et-height=`$banner.et_settings.tablet.main_pair.icon.image_y` data-et-width=`$banner.et_settings.tablet.main_pair.icon.image_x`"}
						  {/if}

						  {$additional_image_wrapper_style=""}
						  {if $banner.et_settings.$et_device.additional.main_pair.icon.image_x && $banner.et_settings.$et_device.image_pos=="H"}
						  	{$additional_image_wrapper_style="max-width: `$banner.et_settings.$et_device.additional.main_pair.icon.image_x`px;"}
						  {/if}

						  {$et_banner_link="et_banner_link_`$banner_id`"}
					    {capture name="et_banner_link_`$banner_id`"}
					  	  {if $banner.et_settings.$et_device.url != ""}
					  	  	<a class="et-banner__link" href="{$banner.et_settings.$et_device.url|fn_url}" {if $banner.et_settings.$et_device.target == "B"}target="_blank"{/if}></a>
					  	  {/if}
					    {/capture}

						{else}
						  {* DESKTOP *}
						  {$et_device="desktop"}
						  {$image=$banner.main_pair.icon.$et_img_path}
						  {$height=$banner.main_pair.icon.image_y}
						  {$banner_text_wrapper_style="height: 100%;"}
						  {$background_style="background-color: `$banner.et_settings.$et_device.bkg`;"}
						  {$additional_image_wrapper_style=""}
						  
						  {if $height}
						  	{$background_style="background: url(`$image`) center center / auto no-repeat `$banner.et_settings.$et_device.bkg`; height: `$height`px;"}

						  	{$banner_text_wrapper_style="height: 100%;"}
						  	{$background_div_info="data-et-height=`$banner.main_pair.icon.image_y` data-et-width=`$banner.main_pair.icon.image_x`"}
						  {/if}
						  {if $banner.et_settings.$et_device.additional.main_pair.icon.image_x && $banner.et_settings.$et_device.image_pos=="H"}
						  	{$additional_image_wrapper_style="max-width: `$banner.et_settings.$et_device.additional.main_pair.icon.image_x`px;"}
						  {/if}

						  {$et_banner_link="et_banner_link_`$banner_id`"}
						  {capture name="et_banner_link_`$banner_id`"}
							  {if $banner.url != ""}
							  	<a class="et-banner__link" href="{$banner.url|fn_url}" {if $banner.target == "B"}target="_blank"{/if}></a>
							  {/if}
						  {/capture}
						{/if}

						{* Button border *}
						{$et_btn_border_style=""}
						{$et_btn_hover_border_style=""}
						{if $banner.et_settings.$et_device.btn_border_enable=="Y"}
						  {$w="border-width:`$banner.et_settings.$et_device.btn_border_size`px;"}
						  
						  {if $banner.et_settings.$et_device.btn_border_style=="D"}
						    {$s="border-style: dashed;"}
						  {elseif $banner.et_settings.$et_device.btn_border_style=="T"}
						    {$s="border-style: dotted;"}
						  {else}
						    {$s="border-style: solid;"}
						  {/if}

						  {$color = implode(",",sscanf($banner.et_settings.$et_device.btn_border_color, "#%02x%02x%02x"))}
						  {$opacity=$banner.et_settings.$et_device.btn_border_opacity/100}
						  {$c="border-color:rgba(`$color`,`$opacity`);"}

						  {$et_btn_border_style="`$w` `$s` `$c`"}

						  {$color = implode(",",sscanf($banner.et_settings.$et_device.btn_hover_border_color, "#%02x%02x%02x"))}
						  {$opacity=$banner.et_settings.$et_device.btn_hover_border_opacity/100}
						  
						  {$et_btn_hover_border_style="border-color:rgba(`$color`,`$opacity`);"}

						{/if}

						{* Button background*}
						{$et_btn_background_style="background: transparent;"}
						{if $banner.et_settings.$et_device.btn_bkg_enabled=="Y"}
						  {$color = implode(",",sscanf($banner.et_settings.$et_device.btn_bkg_color, "#%02x%02x%02x"))}
						  {$opacity=$banner.et_settings.$et_device.btn_bkg_opacity/100}

						  {$et_btn_background_style="background: rgba(`$color`,`$opacity`);"}
						{/if}

						{$et_btn_hover_background_style="background: transparent;"}
						{if $banner.et_settings.$et_device.btn_hover_bkg_enabled=="Y"}
						  {$color = implode(",",sscanf($banner.et_settings.$et_device.btn_bkg_color_hover, "#%02x%02x%02x"))}
						  {$opacity=$banner.et_settings.$et_device.btn_bkg_opacity_hover/100}

						  {$et_btn_hover_background_style="background: rgba(`$color`,`$opacity`);"}
						{/if}

						{* Warpper background*}
						{$wrapper_bkg=""}
						{$inner_wrapper_style=""}
						{if $banner.et_settings.$et_device.wrapper_bkg_enabled=="Y"}
			        {$bkg_color = implode(",",sscanf($banner.et_settings.$et_device.wrapper_bkg_color, "#%02x%02x%02x"))}
			        {$opacity=$banner.et_settings.$et_device.wrapper_bkg_opacity/100}

			        {$wrapper_bkg="background: rgba(`$bkg_color`,`$opacity`);"}
			        {$inner_wrapper_style="padding: `$banner.et_settings.$et_device.wrapper_padding`;"}
			      {/if}

		  		  {* Title Animation *}
		        {if $banner.et_settings.$et_device.title_anim!="A"}
		          {$title_anim="text-anim-`$banner.et_settings.$et_device.title_anim`"}
		        {else}
		          {if $banner.et_settings.$et_device.horiz=="L"||$banner.et_settings.$et_device.horiz=="R"}
		            {$title_anim="text-anim-`$banner.et_settings.$et_device.horiz`"}
		          {elseif $banner.et_settings.$et_device.horiz=="C"}
		            {$title_anim="text-anim-T"}
		          {else}
		            {$title_anim="text-anim-`$banner.et_settings.$et_device.vert`"}
		          {/if}
		        {/if}
		  		  {* Text Animation *}
		        {if $banner.et_settings.$et_device.descr_anim!="A"}
		          {$descr_anim="text-anim-`$banner.et_settings.$et_device.descr_anim`"}
		        {else}
		          {if $banner.et_settings.$et_device.horiz=="L"||$banner.et_settings.$et_device.horiz=="R"}
		            {$descr_anim="text-anim-`$banner.et_settings.$et_device.horiz`"}
		          {elseif $banner.et_settings.$et_device.horiz=="C"}
		            {$descr_anim="text-anim-T"}
		          {else}
		            {$descr_anim="text-anim-`$banner.et_settings.$et_device.vert`"}
		          {/if}
		        {/if}
		  		  {* Text Animation *}
		        {if $banner.et_settings.$et_device.btn_anim!="A"}
		          {$btn_anim="text-anim-`$banner.et_settings.$et_device.btn_anim`"}
		        {else}
		          {if $banner.et_settings.$et_device.horiz=="L"||$banner.et_settings.$et_device.horiz=="R"}
		            {$btn_anim="text-anim-`$banner.et_settings.$et_device.horiz`"}
		          {elseif $banner.et_settings.$et_device.horiz=="C"}
		            {$btn_anim="text-anim-T"}
		          {else}
		            {$btn_anim="text-anim-`$banner.et_settings.$et_device.vert`"}
		          {/if}
		        {/if}
		        {* Additional image animation *}
		        {if $banner.et_settings.$et_device.image_anim!="A"}
		          {$image_anim="text-anim-`$banner.et_settings.$et_device.image_anim`"}
		        {else}
		          {if $banner.et_settings.$et_device.image_horiz=="L"||$banner.et_settings.$et_device.image_horiz=="R"}
		            {$image_anim="text-anim-`$banner.et_settings.$et_device.image_horiz`"}
		          {elseif $banner.et_settings.$et_device.image_horiz=="C"}
		            {$image_anim="text-anim-T"}
		          {else}
		            {$image_anim="text-anim-`$banner.et_settings.$et_device.image_vert`"}
		          {/if}
		        {/if}

						{$wrapper_style=" border-radius: `$banner.et_settings.$et_device.wrapper_round`; `$wrapper_bkg` margin: `$banner.et_settings.$et_device.wrapper_margin`; width: `$banner.et_settings.$et_device.wrapper_width`;"}
						

						{$btn_url=""}
						{if $banner.et_text.$et_device.btn_url!=""}
						  {$btn_url=$banner.et_text.$et_device.btn_url|fn_url}
						{elseif $banner.url != ""}
						  {$btn_url=$banner.url|fn_url}
						{/if}

						{$additional="et_additonal_`$banner_id`"}
		        {capture name="et_additonal_`$banner_id`"}
			        {if $banner.et_settings.$et_device.additional.main_pair}
		        		<div class="et-additional-image vert-{$banner.et_settings.$et_device.image_vert} horiz-{$banner.et_settings.$et_device.image_horiz} {if $banner.et_text.$et_device.title|trim || $banner.et_text.$et_device.text|trim || $banner.et_text.$et_device.btn_text|trim} et-abs{/if}" style="{$additional_image_wrapper_style} {if $banner.et_settings.$et_device.image_pos!="V" && $banner.et_settings.$et_device.image_pos!="I"}margin: {$banner.et_settings.$et_device.image_margin};{/if}">
		        	  	<div class="et-additional-image-wrapper {$image_anim}" data-et-size="{$banner.et_settings.$et_device.additional.main_pair.icon.image_x}" {if $banner.et_settings.$et_device.image_pos=="V" || $banner.et_settings.$et_device.image_pos=="I"}style="margin: {$banner.et_settings.$et_device.image_margin}"{/if}>
			        	  	{if $banner.et_text.$et_device.image_url !=""}<a href="{$banner.et_text.$et_device.image_url|fn_url}" class="ty-inline-block">{/if}
			        	  		{include file="common/image.tpl" images=$banner.et_settings.$et_device.additional.main_pair class="" et_lazy_banner=true et_ratio_style=false}
			        	  	{if $banner.et_text.$et_device.image_url !=""}</a>{/if}
			        		</div>
			        	</div>
			       	{/if}
		        {/capture}

						{$text_container="text_container_`$banner_id`"}
						{capture name="text_container_`$banner_id`"}
							{if $banner.et_settings.$et_device.image_pos=="I" && $banner.et_settings.$et_device.image_pos4=="T"}
								{$smarty.capture.$additional nofilter}
							{/if}

							{if $banner.et_text.$et_device.title|trim}
								<div style="margin: {$banner.et_settings.$et_device.title_padding};" class="align-{$banner.et_settings.$et_device.title_align}">
									{if $banner.et_settings.$et_device.title_bkg_enabled=="Y"}
										{$color = implode(",",sscanf($banner.et_settings.$et_device.title_bkg_color, "#%02x%02x%02x"))}
										{$opacity=$banner.et_settings.$et_device.title_bkg_opacity/100}

										{$et_title_background_style="background: rgba(`$color`,`$opacity`);"}
										<div style="{$et_title_background_style} border-radius: {$banner.et_settings.$et_device.title_bkg_round}; padding: 10px; display: inline-block;">
									{/if}
		            	<div class="et-title {$title_anim} font-weight-{$banner.et_settings.$et_device.title_weight} font-style-{$banner.et_settings.$et_device.title_style} {if $banner.et_settings.$et_device.title_shadow=="Y"}et-text-shadow{/if}" style="font-size:{$banner.et_settings.$et_device.title_size}px; color:{$banner.et_settings.$et_device.title_color}; {if $banner.et_settings.$et_device.title_bkg_enabled=="Y"} padding:{$banner.et_settings.$et_device.title_inner_padding};{/if} line-height: {$banner.et_settings.$et_device.title_lh};" data-et-fs="{$banner.et_settings.$et_device.title_size}">{nl2br($banner.et_text.$et_device.title) nofilter}</div>
									{if $banner.et_settings.$et_device.title_bkg_enabled=="Y"}
										</div>
									{/if}
								</div>
		          {/if}

							{if $banner.et_settings.$et_device.image_pos=="I" && $banner.et_settings.$et_device.image_pos4=="D"}
								{$smarty.capture.$additional nofilter}
							{/if}
		          {if $banner.et_text.$et_device.text|trim}
		          	<div style=" margin: {$banner.et_settings.$et_device.text_padding};" class="align-{$banner.et_settings.$et_device.descr_align}">
				          {if $banner.et_settings.$et_device.descr_bkg_enabled=="Y"}
				          	{$color = implode(",",sscanf($banner.et_settings.$et_device.descr_bkg_color, "#%02x%02x%02x"))}
				          	{$opacity=$banner.et_settings.$et_device.descr_bkg_opacity/100}

				          	{$et_descr_background_style="background: rgba(`$color`,`$opacity`);"}
				          	<div style="{$et_descr_background_style} border-radius: {$banner.et_settings.$et_device.descr_bkg_round}; padding: 10px; display: inline-block;">
				          {/if}
		           	 <div class="et-description {$descr_anim} font-weight-{$banner.et_settings.$et_device.text_weight} font-style-{$banner.et_settings.$et_device.text_style} {if $banner.et_settings.$et_device.text_shadow=="Y"}et-text-shadow{/if} " style="font-size:{$banner.et_settings.$et_device.text_size}px; color:{$banner.et_settings.$et_device.text_color}; {if $banner.et_settings.$et_device.descr_bkg_enabled=="Y"}padding:{$banner.et_settings.$et_device.text_inner_padding};{/if} line-height: {$banner.et_settings.$et_device.text_lh}" data-et-fs="{$banner.et_settings.$et_device.text_size}">{nl2br($banner.et_text.$et_device.text) nofilter}</div>
			            {if $banner.et_settings.$et_device.descr_bkg_enabled=="Y"}
			            	</div>
			            {/if}
		            </div>
		          {/if}

							{if $banner.et_settings.$et_device.image_pos=="I" && $banner.et_settings.$et_device.image_pos4=="B"}
		          	{$smarty.capture.$additional nofilter}
		          {/if}
		          {if $banner.et_text.$et_device.btn_text}
		            <div class="et-btn {$btn_anim} align-{$banner.et_settings.$et_device.btn_horiz}" style="">
		              <a href="{$btn_url}" class="ty-btn font-weight-{$banner.et_settings.$et_device.btn_weight} font-style-{$banner.et_settings.$et_device.btn_style} {if $banner.et_settings.$et_device.btn_shadow=="Y"}et-btn-shadow{/if}" style="padding:{$banner.et_settings.$et_device.btn_padding};font-size:{$banner.et_settings.$et_device.btn_size}px; margin: {$banner.et_settings.$et_device.btn_margin};" data-et-fs="{$banner.et_settings.$et_device.btn_size}">{$banner.et_text.$et_device.btn_text}</a>
		            </div>
		          {/if}
		          {if $banner.et_settings.$et_device.image_pos=="I" && $banner.et_settings.$et_device.image_pos4=="E"}
		          	{$smarty.capture.$additional nofilter}
		          {/if}
						{/capture}


						<div class="ty-banner__image-item {if $et_traditional_resp}hidden{/if} et-banner-wrapper-{$et_device} et-banner-show-{$current_device}" id="banner_{$block.block_id}_{$key}_{$et_id}_{$et_device}">
						  <style>
						  	{if $et_traditional_resp}
						    	{if $current_device=="D"}
						    		@media screen and (min-width: 1025px){
						    	{elseif $current_device=="T"}
						    		@media screen and (min-width: 481px) and (max-width: 1024px){
						    	{elseif $current_device=="M"}
						    		@media screen and (max-width: 480px){
						    	{/if}
						    {else}
						    	@media screen and (min-width: 1px){
						    {/if}
						    #banner_{$block.block_id}_{$key}_{$et_id}_{$et_device} .et-btn a{
						      color:{$banner.et_settings.$et_device.btn_text_color}; 
						      transition: all .5s ease;
						      border-radius: {$banner.et_settings.$et_device.btn_round};
						      {$et_btn_background_style}
		          		{$et_btn_border_style}
						    }
						    #banner_{$block.block_id}_{$key}_{$et_id}_{$et_device} .et-btn a:hover{
						      color:{$banner.et_settings.$et_device.btn_text_color_hover}; 
						      {$et_btn_hover_background_style}
		          		{$et_btn_hover_border_style}
						    }

						    #banner_{$block.block_id}_{$key}_{$et_id}_{$et_device} .et-banner-container{
							    	{$background_style}
							    }
						    }

						  </style>

				      <div style="{* {$background_style} *}" class="lazy et-banner-container et-banner-{$et_device} ty-position-relative et-color-bkg_wrapper {if $banner.main_pair}et-img-bkg_wrapper {if $banner.main_pair.icon.image_y>460}et-img-bkg_resize{/if}{/if} {if $banner.et_settings.$et_device.image_pos=="V"} et-flex-horiz{/if}" {$background_div_info}>

				      	{if $smarty.capture.$et_banner_link|trim}
				      		{$smarty.capture.$et_banner_link nofilter}
				      	{/if}

				      	{if ($banner.et_settings.$et_device.image_pos=="H" && $banner.et_settings.$et_device.image_pos2 == "L") || ($banner.et_settings.$et_device.image_pos=="V" && $banner.et_settings.$et_device.image_pos3 == "A")}
				        	{$smarty.capture.$additional nofilter}
				        {/if}

								{if $smarty.capture.$text_container|trim}
					        <div class="banner-text-outer-wrapper vert-{$banner.et_settings.$et_device.vert} horiz-{$banner.et_settings.$et_device.horiz} {if $banner.et_settings.$et_device.image_pos=="A"}et-abs{/if} {if $banner.et_settings.$et_device.image_pos=="V" && $banner.et_settings.$et_device.image_pos3 == "B"}et-flex-zero{/if}" style="{$banner_text_wrapper_style}">
					          <div class="banner-text-wrapper {$anim} {if !$wrapper_bkg}et-no-bkg{/if}" style="{$wrapper_style}" {if $banner.et_settings.$et_device.wrapper_width}data-et-width="{$banner.et_settings.$et_device.wrapper_width}"{/if}>
					            <div class="banner-text-inner-wrapper" style="{$inner_wrapper_style}">
					              {$smarty.capture.$text_container nofilter}
			                </div>
				            </div>
				          </div>
									{/if}

				        	{if ($banner.et_settings.$et_device.image_pos=="H" && $banner.et_settings.$et_device.image_pos2 == "R") || ($banner.et_settings.$et_device.image_pos=="V" && $banner.et_settings.$et_device.image_pos3 == "B")}
				          	{$smarty.capture.$additional nofilter}
				          {/if}

				        </div>
						</div>
					{/foreach}
				</div>

			{elseif $banner.type == "G" && $banner.main_pair.image_id}
				{if $banner.url != ""}<a class="banner__link" href="{$banner.url|fn_url}" {if $banner.target == "B"}target="_blank"{/if}>{/if}
			    <div style="max-height: {$banner.main_pair.icon.image_y}px; overflow: hidden;" class="et-main-banner-img">
			    		{$et_lazy=false}
			    		{if count($items)==1}
			    			{$et_lazy=true}
			    		{/if}
			        {include file="common/image.tpl" images=$banner.main_pair et_lazy_owl=true et_ratio_style=false et_lazy=$et_lazy}
			    </div>
				{if $banner.url != ""}</a>{/if}
			{else $banner.type == "T"}
				<div class="ty-wysiwyg-content">
					{$banner.description nofilter}
				</div>
			{/if}
		{/foreach}
		</div>
	</div>
{/if}

{if count($items)>1}
<script>
(function(_, $) {
	{$et_slider_id="banner_slider_`$block.snapping_id`_`$et_id`"}

	$.ceEvent('on', 'ce.commoninit', function(context) {
		var slider = $('#{$et_slider_id}');
		if (slider.visible(true)){
		  et_init_{$et_slider_id}();
		}else{
		  slider.addClass('et_not_loaded_banner');
		}
	});
	function et_init_{$et_slider_id}(){

		var slider = $('#{$et_slider_id}');
		var delay = '{$block.properties.delay * 1000|default:false}';

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
		    slider.addClass('stopped');
		    slider.data("delay",delay);
		    
		    if (slider.visible(true)){
		    	$(".active .et-img-bkg_wrapper.lazy").removeClass("lazy");
		    	
		    	images=$(".active img.etLazyBanner",slider);
	        images.each(function(){
	            var img=$(this);
	            img.one('load', function() { 
	                img.removeAttr("data-src");
	                img.removeClass("etLazyBanner");
	                img.removeClass(img.data("etLazyId"));
	                if (delay){
	                	slider.removeClass('stopped');
	                  elem.trigger('owl.play',delay);
	                }
	                return;
	            }).attr('src', img.data("src"))
	            .each(function() {
	              //Cache fix for browsers that don't trigger .load()
	              if(this.complete) $(this).trigger('load');
	            });
	        });
	        slider.removeClass('stopped');
	        elem.trigger('owl.play',delay);
		    }
			}
		}
	}
	// });

	$(document).ready(function(){
	  if ($("#{$et_slider_id}.et_not_loaded_banner").length>0){
	    $(window).scroll(function(){
	      if ($("#{$et_slider_id}.et_not_loaded_banner").visible(true)){
	        et_init_{$et_slider_id}();
	        $("#{$et_slider_id}").removeClass('et_not_loaded_banner');
	      }
	    })
	  }
	})
}(Tygh, Tygh.$));
</script>
{/if}