{capture name="buttons"}
    <div class="ty-float-right">
        {include file="buttons/button.tpl" but_meta="ty-btn__primary" but_href="product_features.compare" but_text=__("view_comparison_list")}
    </div>
{/capture}
{include file="views/products/components/notification.tpl" product_buttons=$smarty.capture.buttons}
