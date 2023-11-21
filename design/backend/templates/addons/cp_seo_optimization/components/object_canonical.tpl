{$obj_id = $obj_id|default:"`$type`_`$object_id`"}
{$objects = ""|fn_cp_seo_get_objects}

{$cur_object_id = $object_id}
{$cur_type = $type}
{$prefix="cp_seo_data[extra][canonical]"}

{$type = $object.type|default:$type}
{$object_id = $object.object_id|default:$object_id}

<div class="control-group">
    <label class="control-label" for="elm_cp_seo_canonical_type_{$obj_id}">{__("cp_seo_canonical_type")}:</label>
    <div class="controls">
        <select name="{$prefix}[type]" class="cp-seo-change-type"
            data-ca-url="{"cp_seo_optimization.change_type&obj_id=`$obj_id`&type=`$cur_type`&object_id=`$cur_object_id`"|fn_url}"
            data-ca-target-id="elm_cp_seo_settings_condition_{$obj_id}"`>
            {foreach from=$objects item="val" key="key"}
                <option {if $key == $type}selected="selected"{/if} value="{$key}">{__($val.title)}</option>
            {/foreach}
        </select>
    </div>
</div>

{$condition = $objects.$type|default:[]}
{$value = $object_id|default:$condition.default_value}
{$input_value = "object_id"}
{if $type == "S"}
    {$value = $object.src}
    {$input_value = "src"}
{elseif $type == "P"}
    {$product = $value|fn_get_product_name}
{/if}
{if $condition}
<div id="elm_cp_seo_settings_condition_{$obj_id}">
    <div class="control-group">
        <label class="control-label" for="elm_condition_{$obj_id}">{__("cp_seo_canonical_object")} ({__($condition.title)})</label>
        <div class="controls">
            {if $condition.type == "input"}
                <input type="text" name="{$prefix}[{$input_value}]" value="{$value}" class="input-large"/>
            {elseif $condition.type == "select"}
                <select name="{$prefix}[{$input_value}]">
                    {foreach from=$condition.variants key="var_key" item="var_value"}
                        <option value="{$var_key}" {if $var_key == $value}selected="selected"{/if}>{$var_value}</option>
                    {/foreach}
                </select>
            {elseif $condition.type == "picker"}
                <input type="hidden" name="{$prefix}[{$input_value}]" value="{$value}" />
                {assign var="params" value=$condition.picker_props.params}
                {include_ext file=$condition.picker_props.picker company_ids=$picker_selected_companies data_id="objects_`$obj_id`" input_name="`$prefix`[`$input_value`]" item_ids=$value params_array=$params owner_company_id=$company_id but_meta="btn"}
            {/if}
            {if $condition.tooltip}
                <p class="muted description">{__($condition.tooltip)}</p>
            {/if}
        </div>
    </div>
<!--elm_cp_seo_settings_condition_{$obj_id}--></div>
{/if}

<script type="text/javascript">
    (function(_, $) {
        $(_.doc).on('change', '.cp-seo-change-type', function (e) {
            var url = $(this).data('caUrl');
            if (typeof url != 'undefined') {
                $.ceAjax('request', url, {
                    method: 'get',
                    caching: false,
                    hidden: false,
                    result_ids: $(this).data('caTargetId'),
                    data: {
                        changed_type: $(this).val()
                    }
                });
            }
        });
    }(Tygh, Tygh.$));
</script>