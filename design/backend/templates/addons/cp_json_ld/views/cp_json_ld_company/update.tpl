{capture name="mainbox"}

<form action="{""|fn_url}" enctype="multipart/form-data" method="post" name="cp_json_ld_form" class="form-horizontal form-edit" >

<fieldset>
    <div class="control-group">
        <label class="control-label" for="elm_company_description">{__("cp_json_ld.company_description")}:</label>
        <div class="controls">
        <textarea id="elm_company_description" name="company_data[cp_description]" cols="55" rows="8" class="input-large">{$company_data.cp_description}</textarea>
        </div>
    </div>

    <div class="control-group">
        <label class="control-label" for="elm_company_socials">{__("cp_json_ld.social")}:</label>
        <div class="controls">
            <textarea id="elm_company_socials" name="company_data[cp_socials]" cols="55" rows="8" class="input-large">{$company_data.cp_socials}</textarea>
        </div>
    </div>
</fieldset>

{capture name="buttons"}

{include file="buttons/save_cancel.tpl" but_name="dispatch[cp_json_ld_company.update]" hide_first_button=false hide_second_button=true but_target_form="cp_json_ld_form" save=true}

{/capture}

</form>
{/capture}

{include file="common/mainbox.tpl" 
    title=__("cp_json_ld.company_multilang_settings") 
    content=$smarty.capture.mainbox 
    select_languages=true 
    buttons=$smarty.capture.buttons}
