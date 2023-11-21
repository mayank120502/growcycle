{if $object_id}
    {$obj_id = "`$type`_`$object_id`"}

    {include file="common/subheader.tpl" title=__("cp_seo_optimization_title") target="#cp_seo_settings_{$obj_id}"}

    <div class="collapse in" id="cp_seo_settings_{$obj_id}">
        <div class="control-group">
            <label class="control-label" for="elm_cp_seo_noindex_{$obj_id}">{__("cp_seo_indexing_management")}{include file="common/tooltip.tpl" tooltip=__("cp_seo_indexing_management_descr") params="ty-subheader__tooltip"}:</label>
            <div class="controls">
                <select name="{$inp_name}[cp_seo_no_index]" id="elm_cp_seo_noindex_{$obj_id}">
                    <option value="D" {if $obj_data.cp_seo_no_index == "D"}selected="selectd"{/if}>{__("cp_seo_indexing_management_d")}</option>
                    <option value="N" {if $obj_data.cp_seo_no_index == "N"}selected="selectd"{/if}>{__("cp_seo_indexing_management_n")}</option>
                    <option value="F" {if $obj_data.cp_seo_no_index == "F"}selected="selectd"{/if}>{__("cp_seo_indexing_management_f")}</option>
                    <option value="Y" {if $obj_data.cp_seo_no_index == "Y"}selected="selectd"{/if}>{__("cp_seo_indexing_management_y")}</option>
                    <option value="I" {if $obj_data.cp_seo_no_index == "I"}selected="selectd"{/if}>{__("cp_seo_indexing_management_i")}</option>
                </select>
            </div>
        </div>
        
        <div class="control-group">
            <label class="control-label" for="elm_cp_seo_noindex_{$obj_id}">{__("cp_seo_apply_addon")}{include file="common/tooltip.tpl" tooltip=__("cp_seo_apply_addon_descr") params="ty-subheader__tooltip"}:</label>
            <div class="controls">
                <input type="hidden" name="{$inp_name}[cp_seo_use_addon]" value="N" />
                <input type="checkbox" name="{$inp_name}[cp_seo_use_addon]" value="Y" {if $obj_data.cp_seo_use_addon == "Y"}checked="checked"{/if} />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="sw_cp_seo_use{$obj_id}">{__("cp_seo_optimization_use")}:</label>
            <div class="controls">
                <input type="hidden" name="cp_seo_use" value="N" />
                <input type="checkbox" class="cm-combination" name="cp_seo_use" id="sw_cp_seo_use{$obj_id}" value="Y" {if $cp_seo_data}checked="checked"{/if} />
            </div>
        </div>

        <div id="cp_seo_use{$obj_id}" class="{if !$cp_seo_data}hidden{/if}">
            <input type="hidden" name="cp_seo_data[type]" value="{$type}" />
            <input type="hidden" name="cp_seo_data[object_id]" value="{$object_id}" />
            <div id="cp_seo_settings_{$obj_id}">
                {include file="addons/cp_seo_optimization/components/object_canonical.tpl" object=$cp_seo_data.extra.canonical}
            </div>
        </div>
    </div>
{/if}