{$communication_type = "Addons\\VendorCommunication\\CommunicationTypes::VENDOR_TO_CUSTOMER"|enum}
{$allow_new_thread = fn_vendor_communication_is_communication_type_active($communication_type)}

{if $allow_new_thread}
    {if "MULTIVENDOR"|fn_allowed_for}
        {if $auth.user_id}
            <a title="{__("vendor_communication.contact_vendor")}" class="ty-vendor-communication__post-write cm-dialog-opener cm-dialog-auto-size" data-ca-target-id="new_thread_dialog_{$object_id}" rel="nofollow">{strip}
                <i class="ty-icon-chat"></i>
                <span>
                    {if $et_vendor_header_contact}
                        {__("vendor_communication.contact_vendor")}
                    {else}
                        <span>{__("et_ask_a_question")}</span>
                    {/if}
                </span>
            {/strip}</a>
        {else}
            {assign var="return_current_url" value=$config.current_url|escape:url}

            <a title="{__("vendor_communication.contact_vendor")}" {if $settings.Security.secure_storefront != "partial"} data-ca-target-id="new_thread_login_form" class="cm-dialog-opener cm-dialog-auto-size ty-vendor-communication__post-write"{else}class="ty-vendor-communication__post-write"{/if} rel="nofollow">
                <i class="ty-icon-chat"></i>
                {if $et_vendor_header_contact}
                    <span>{__("vendor_communication.contact_vendor")}</span>
                {else}
                    <span>{__("et_ask_a_question")}</span>
                {/if}
            </a>

            {if $show_form && $settings.Security.secure_storefront != "partial"}
                {include file="addons/vendor_communication/views/vendor_communication/components/login_form.tpl"}
            {/if}
        {/if}
    {/if}
{/if}