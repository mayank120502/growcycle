<div title="{__("cp_seo_add_rule")}" id="cp_add_rule">
    <form action="{""|fn_url}" method="post" name="add_rule_form" class="form-horizontal ">
        <input type="hidden" class="cm-no-hide-input" name="rule_id" value="0" />

        <div id="add_attribute">
            <div class="control-group">
                <label for="elm_cp_rule_dispatch" class="control-label cm-required">{__("dispatch")}:</label>
                <div class="controls">
                    <input type="text" name="rule[dispatch]" id="elm_cp_rule_dispatch" value="" class="input-long" />
                </div>
            </div>
            
            {if "ULTIMATE"|fn_allowed_for}
                {include file="views/companies/components/company_field.tpl"
                    name="rule[company_id]"
                    id="elm_attr_data_0"
                }
            {/if}
            <div class="control-group">
                <label for="elm_cp_seo_rule" class="control-label">{__("cp_seo_indexing_management")}:</label>
                <div class="controls">
                    <select name="rule[rule]" id="elm_cp_seo_rule">
                        <option value="F">{__("cp_seo_indexing_management_f")}</option>
                        <option value="Y">{__("cp_seo_indexing_management_y")}</option>
                        <option value="I">{__("cp_seo_indexing_management_i")}</option>
                    </select>
                </div>
            </div>
            <div class="buttons-container">
                <div class="controls">
                    {include file="buttons/button.tpl" but_text=__("create") but_role="submit" but_name="dispatch[cp_seo_optimization.update_rule]" but_target_form="add_rule_form"}
                </div>
            </div>
        </div>
    </form>
<!--cp_add_rule--></div>