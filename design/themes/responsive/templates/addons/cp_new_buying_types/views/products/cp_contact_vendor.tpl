{$id = $product_data.product_id}
{if !empty($product_data.selected_amount)}
    {$default_amount = $product_data.selected_amount}
{elseif !empty($product_data.min_qty)}
    {$default_amount = $product_data.min_qty}
{elseif !empty($product_data.qty_step)}
    {$default_amount = $product_data.qty_step}
{else}
    {$default_amount = 1}
{/if}
<form class="cp-send-inquiry" name="cp_send_inquiry_form_{$obj}" enctype="multipart/form-data" action="{""|fn_url}" method="post">
    <input type="hidden" name="product_id" value="{$id}"/>
    <input type="hidden" name="return_url" value="{$return_url}"/>
    <input type="hidden" name="amount" value="{$default_amount|default:1}"/>
    <div class="cp-send-inquiry__to">
        <div class="cp-send-inquiry__to">
            <span class="cp-send-inquiry__to-prefix">{__('cp_new_buying_types.to')}: </span>
            <a class="cp-send-inquiry__to-company" target="_blank" href="{"companies.view?company_id=`$product_data.company_id`"|fn_url}">{$product_data.company_name}</a>
        </div>
    </div>
    <div class="cp-send-inquiry__product">
        <span class="cp-send-inquiry__product-data">
            <span class="cp-send-inquiry__product-data-image">
                {include file="common/image.tpl" image_width=50 image_height=50 images=$product_data.main_pair no_ids=true}
            </span>
            <span class="cp-send-inquiry__product-data-name">{$product_data.product}</span>
        </span>
    </div>
    <div class="cp-send-inquiry__message">
        {$textarea_id = "message_`$obj`"}
        <label class="cp-send-inquiry__message-title cm-required" for="{$textarea_id}" data-ca-validator-error-message="{__('cp_new_buying_types.detailed_requirements.error_message')}">
            {__('cp_new_buying_types.detailed_requirements.title')}:
        </label>
        {$tooltip = fn_cp_get_detailed_requirements_tooltip()}
        {if $tooltip} {include file="common/tooltip.tpl" tooltip=$tooltip}{/if}
        <div class="cp-send-inquiry__message-subtext">{__('cp_new_buying_types.detailed_requirements.subtext')}</div>
        <div class="cp-send-inquiry__message-textarea">
            <textarea id="{$textarea_id}" name="message" placeholder="{__('cp_new_buying_types.detailed_requirements.placeholder')}"></textarea>
        </div>
        <div class="cp-send-inquiry__message-attachments">
            {include file="addons/cp_new_buying_types/common/fileuploader.tpl"
                var_name="attachments[]"
                label_id="cp_send_inquiry_attachments_`$obj`"
                multiupload="YesNo::YES"|enum
                upload_file_text=__('cp_new_buying_types.add_attachment')
                upload_another_file_text=__('cp_new_buying_types.add_attachment')
                max_upload_filesize=$config.tweaks.profile_field_max_upload_filesize
            }
        </div>
    </div>
    {include file="views/checkout/components/terms_and_conditions.tpl" suffix=$obj}
    <div class="ty-center">
        {include file="buttons/button.tpl"
            but_text=__("cp_new_buying_types.send_inquiry_btn_text")
            but_meta="ty-btn__primary cm-post"
            but_role="submit"
            but_name="dispatch[checkout.cp_send_inquiry]"
        }
    </div>
</form>
<script>
    (function (_, $) {
        let form = $('form[name="cp_send_inquiry_form_{$obj}"]'),
            product_form = $('form[name="product_form_{$obj}"]'),
            amount = $('[name="product_data[{$id}][amount]"]', product_form).val() || 1;

        $('[name="amount"]', form).val(amount);
    }(Tygh, Tygh.$));
</script>
