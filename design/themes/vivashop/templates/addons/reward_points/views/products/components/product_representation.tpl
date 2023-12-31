{if $et_category_list}
	{$product.points_info.price=fn_get_price_in_points($product.product_id,$auth)}
{/if}
{if $product.points_info.price}
  <div class="ty-reward-group">
  	{strip}
      <span class="ty-control-group__label product-list-field">{__("price_in_points")}:</span>
      <span class="ty-control-group__item" id="price_in_points_{$obj_prefix}{$obj_id}"><bdi>{__("points_lowercase", [$product.points_info.price])}</bdi></span>
    {/strip}
  </div>
{/if}
{if !$et_category_list}
<div class="ty-reward-group product-list-field{if !$product.points_info.reward.amount} hidden{/if}">
	{strip}
  <span class="ty-control-group__label">{__("reward_points")}:</span>
  <span class="ty-control-group__item" id="reward_points_{$obj_prefix}{$obj_id}"><bdi>{__("points_lowercase", [$product.points_info.reward.amount])}</bdi></span>
  {/strip}
</div>
{/if}