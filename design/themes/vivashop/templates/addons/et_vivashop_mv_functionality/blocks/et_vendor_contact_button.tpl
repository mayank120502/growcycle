{if "MULTIVENDOR"|fn_allowed_for}
    {if $auth.user_id}
        {include file="buttons/button.tpl" 
        	but_text=$but_text|default:__("vendor_communication.contact_vendor") 
            but_title=__("vendor_communication.contact_vendor") 
        	but_target_id="new_thread_dialog_`$company_id`"
        	but_rel="nofollow" 
        	but_role="et_icon_text"
        	et_icon="ty-icon-chat"
        	but_extra_class="ty-vendor-communication__post-write cm-dialog-opener cm-dialog-auto-size et_contact_vendor_btn"}
    {else}
        {assign var="return_current_url" value=$config.current_url|escape:url}
		{$but_href="auth.login_form?return_url=`$return_current_url`"|fn_url}

		{if $settings.Security.secure_storefront != "partial"}
			{$but_target_id="new_thread_login_form"}
			{$but_extra_class="cm-dialog-opener cm-dialog-auto-size ty-vendor-communication__post-write"}
		{else}
			{$but_target_id=""}
			{$but_extra_class="ty-vendor-communication__post-write"}
		{/if}

        {include file="buttons/button.tpl"
        	but_title=__("vendor_communication.contact_vendor")
        	but_href=$but_href
        	but_text=$but_text|default:__("vendor_communication.contact_vendor") 
        	but_target_id=$but_target_id
        	but_rel="nofollow" 
        	but_role="et_icon_text"
        	et_icon="ty-icon-chat"
        	but_extra_class="`$but_extra_class` et_contact_vendor_btn"}

        {if $show_form && $settings.Security.secure_storefront != "partial"}
            {include file="addons/vendor_communication/views/vendor_communication/components/login_form.tpl"}
        {/if}
    {/if}
    {include
        file="addons/vendor_communication/views/vendor_communication/components/new_thread_form.tpl"
        object_type=$smarty.const.VC_OBJECT_TYPE_COMPANY
        object_id=$company_id
        company_id=$company_id
        vendor_name=$company_id|fn_get_company_name
    }
{/if}
