{if !$smarty.session.auth.age && $product.need_age_verification == "Y"}
<div class="ty-age-verification ty-scroller-list__item">
{strip}
    {include file="blocks/list_templates/et_simple_list.tpl" product=$product show_name=true show_price=false show_add_to_cart=false but_role="action" hide_price=true hide_qty=true show_product_labels=false show_discount_label=false show_shipping_label=false et_show_age_verification=true}
{/strip}
</div>
{/if}