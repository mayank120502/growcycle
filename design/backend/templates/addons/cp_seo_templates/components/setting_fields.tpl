
{$obj_id = "`$object_type`_`$object_id`"}
{if !$no_header}
    {include file="common/subheader.tpl" title=__("cp_seo_subheader") target="#acc_custom_h1_`$obj_id`"}
{/if}
<div class="{$no_hide_input_if_shared_product}" id="acc_custom_h1_{$obj_id}">
    <div class="control-group">
        <label for="cp_custom_h1_{$obj_id}" class="control-label">{__("cp_seo_custom_h1")}</label>
        <div class="controls">
            <input class="input-large" type="text" name="{$input_name}[cp_st_h1]" id="cp_custom_h1_{$obj_id}" size="55" value="{$data.cp_st_h1}" />
        </div>
    </div>
    {if !$skip_cp_breadcrumb}
        <div class="control-group">
            <label for="cp_custom_breadcrumb_{$obj_id}" class="control-label">{__("cp_seo_custom_breadcrumb")}</label>
            <div class="controls">
                <input class="input-large" type="text" name="{$input_name}[cp_st_custom_bc]" id="cp_custom_breadcrumb_{$obj_id}" size="55" value="{$data.cp_st_custom_bc}" />
            </div>
        </div>
    {/if}
</div>
