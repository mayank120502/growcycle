<div class="well well-small help-block">
    
    <p><b>{__("cp_company_tab_please_remember")}</b></p>
    <p>{__("cp_company_profile_sections", ["[link]" => "cp_company_tab_sections.manage"|fn_url])}</p>
    {assign var="company_tab_content" value=$product.company_id|fn_cp_company_tab_content}
    <p>{__("cp_company_currently_created", ["[count]" => $company_tab_content|count])}</p>
    
</div>

