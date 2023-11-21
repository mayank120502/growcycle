<h4 class="subheader hand" data-toggle="collapse" data-target="#ebay_category_setting">
    eBay categories
<span class="icon-caret-down"></span></h4>
<fieldset>
    <div id="ebay_category_setting" class="in collapse">
        <div class="control-group">
            <label class="control-label">{__("cp_suredone_integration.cp_use_for_upload_products_suredone")}</label>
            <div class="controls">
                <input type="hidden"
                    name="category_data[cp_use_for_upload_products_suredone]"
                    value="N"
                />
                <input type="checkbox"
                    name="category_data[cp_use_for_upload_products_suredone]"
                    value="{"YesNo::YES"|enum}"
                    id="cp_use_for_upload_products_suredone"
                    class="cm-switch-availability"
                    {if $category_data.cp_use_for_upload_products_suredone === "YesNo::YES"|enum}
                        checked="checked"
                    {/if}
                />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="cp_keyword_to_category_ebay">{__("cp_suredone_integration.cp_keyword_to_search_ebay_categories")}:</label>
            <div class="controls">
                <input type="text" name="category_data[cp_keyword_to_search_ebay_categories]" id="cp_keyword_to_category_ebay" value="{$category_data.cp_keyword_to_search_ebay_categories}" />
                <a class="btn btn-primary" id="cp_btn_search_category_ebay">Search</a>
            </div>
        </div> 
        <div id="cp_categories_ebay">
        {if $cp_ebay_categories}
            <div class="controls">
                <select name="category_data[cp_ebay_suredone_category]" id="input_cat_{$cp_ebay_category.id}" class="user-success">
                    {foreach $cp_ebay_categories as $cp_ebay_category}
                        <option value="{$cp_ebay_category.id}">{$cp_ebay_category.name}</option>
                    {/foreach}
                </select>
            </div>
        {/if}
        <!--cp_categories_ebay--></div>
    </div>
</fieldset>

{script src="js/addons/cp_suredone_integration/cp_categories_ebay.js"}
