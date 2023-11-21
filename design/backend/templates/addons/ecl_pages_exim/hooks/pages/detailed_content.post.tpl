{include file="common/subheader.tpl" title=__("ecl_pages_exim") target="#page_code_settings"}
<div id="page_code_settings" class="in collapse">
    <div class="control-group">
        <label for="elm_page_code" class="control-label cm-required">{__("ecl_pages_exim.code")}:</label>
        <div class="controls">
            <input type="text" name="page_data[page_code]" id="elm_page_code" maxlength="{($addons.ecl_pages_exim.ecl_page_code_prefix|strlen + $addons.ecl_pages_exim.ecl_max_page_code_length)|default:20}" size="55" value="{$page_data.page_code}" class="input-large" />
        </div>
    </div>
</div>