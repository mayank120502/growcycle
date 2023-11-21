{$expanded=false}
{if $et_vs.data.side_categ}
	{if $et_vs.data.side_categ=="expanded"}
		{$expanded=true}
	{/if}
{elseif $addons.et_vivashop_mv_functionality.et_vendor_categories=="expanded"}
	{$expanded=true}
{/if}

{function name="subcategs" data=$data limit=$limit et_hide=$et_hide}
	{assign var=first value = $data|@key}
	<ul class="{if $et_hide}hidden{/if} et-sidebox-categ-lev-{$data.$first.level}" id="sidemenu_{$data.$first.parent_id}">
		{foreach from=$data item=item name=item}
			{assign var="categ_path" value="/"|explode:$category_data.id_path}
			{assign var="item_path" value="/"|explode:$item.id_path}
			{assign var="level" value=$item.level}
			{if $categ_path.$level == $item_path.$level}
				{assign var="current" value=true}
			{else}
				{assign var="current" value=false}
			{/if}
			<li>
				<a href="{"companies.products?category_id=`$item.category_id`&company_id=$company_id"|fn_url}" class="item1 {if $current}active{/if}">
					<span clas="et-sidebox-subcateg-title-wrapper"><span class="et-sidebox-subcateg-title">{$item.category}</span>
					{if $item.product_count && !$categ.hide_product_count}
						<span class="et-count">({$item.product_count})</span>
					{/if}
					</span>
					{if $item.subcategories && $item.level<=$limit}
						{if $smarty.const.ET_DEVICE == "D"}
							<span class="et_subcateg_toggle {if $current || $expanded}open{/if}" onclick="$(this).toggleClass('open');$('#sidemenu_{$item.category_id}').slideToggle(100); event.preventDefault(); event.stopPropagation(); return false;">
								<span class="open-symbol {if $current || $expanded}hidden{/if}"><i class="et-icon-plus"></i></span>
								<span class="close-symbol {if !$current}hidden{/if}"><i class="et-icon-minus"></i></span>
							</span>
						{else}
							<span class="et_subcateg_toggle {if $current || $expanded}open{/if}" onclick="$(this).toggleClass('open');$(this).parent().toggleClass('active');$('#sidemenu_{$item.category_id}').toggle(); event.preventDefault(); event.stopPropagation(); return false;">
								<span class="open-symbol {if $current || $expanded}hidden{/if}"><i class="et-icon-circle-plus"></i></span>
								<span class="close-symbol {if !$current}hidden{/if}"><i class="et-icon-circle-minus"></i></span>
							</span>
						{/if}
					</a>

					{if $current || $expanded}
						{subcategs data=$item.subcategories limit=$limit vendor_categs=$vendor_categs}
					{else}
						{subcategs data=$item.subcategories limit=$limit vendor_categs=$vendor_categs et_hide=true}
					{/if}
				{else}
					</a>
				{/if}
			</li>
		{/foreach}
	</ul>
{/function}

{if !$company_id}
	{if $smarty.request.company_id}
		{$company_id=$smarty.request.company_id}
	{/if}

{else}
	{$categ=fn_et_get_categories($category_data.category_id,$company_id)}

	{if !$categ}
		{$categ=fn_et_get_categories($category_data.parent_id,$company_id)}
	{/if}
{/if}


{if $categ}

	<div class="clearfix et-sidebox-categ">
		<div class="clearfix et-side-subcateg" id="et_side_subcateg_{$block.block_id}">
			{foreach from=$categ item=item name=item}
				{assign var="categ_path" value="/"|explode:$category_data.id_path}
				{assign var="item_path" value="/"|explode:$item.id_path}
				{assign var="level" value=$item.level}

				{if $categ_path.$level == $item_path.$level}
					{assign var="current" value=true}
				{else}
					{assign var="current" value=false}
				{/if}
				<div class="item1-wrapper">
					<a href="{"companies.products?category_id=`$item.category_id`&company_id=$company_id"|fn_url}" class="item1 {if $current}active{/if} ">
						<span class="et-sidebox-subcateg-title-wrapper"><span class="et-sidebox-subcateg-title">{$item.category}</span>
						{if !$categ.hide_product_count}
							<span class="et-count">({$item.product_count})</span>
						{/if}
						</span>

						{if $item.subcategories}
							{if $smarty.const.ET_DEVICE == "D"}
								<span class="et_subcateg_toggle {if $current || $expanded}open{/if}" onclick="$(this).toggleClass('open');$('#sidemenu_{$item.category_id}').slideToggle(100); event.preventDefault(); event.stopPropagation(); return false;">
									<span class="open-symbol {if $current || $expanded}hidden{/if}"><i class="et-icon-plus"></i></span>
									<span class="close-symbol {if !$current}hidden{/if}"><i class="et-icon-minus"></i></span>
								</span>
							{else}
								<span class="et_subcateg_toggle {if $current || $expanded}open{/if}" onclick="$(this).toggleClass('open');$(this).parent().toggleClass('active');$('#sidemenu_{$item.category_id}').toggle(); event.preventDefault(); event.stopPropagation(); return false;">
									<span class="open-symbol {if $current || $expanded}hidden{/if}"><i class="et-icon-circle-plus"></i></span>
									<span class="close-symbol {if !$current}hidden{/if}"><i class="et-icon-circle-minus"></i></span>
							{/if}
						{/if}
					</a>
					{if $item.subcategories}
						{if $current || $expanded}
							{subcategs data=$item.subcategories limit=10}
						{else}
							{subcategs data=$item.subcategories limit=10 et_hide=true}
						{/if}
					{/if}
				</div>
			{/foreach}

		<!--et_side_subcateg_{$block.block_id}--></div>
	</div>
{/if}