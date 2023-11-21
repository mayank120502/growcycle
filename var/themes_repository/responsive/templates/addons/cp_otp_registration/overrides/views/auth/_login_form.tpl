{assign var="id" value=$id|default:"main_login"}
{if $smarty.request.custom_id}
    {$id = $smarty.request.custom_id}
{/if}

{capture name="login"}
    {$login_type = $addons.cp_otp_registration.login_type|default:"password"}
    {$auth_field = $smarty.request.auth_field|default:$addons.cp_otp_registration.default_auth_method|default:"phone"}
    {$no_email = false}
    {if $addons.cp_otp_registration.exclude_email == "Y"}
        {$no_email = true}
    {/if}

    <form name="{$id}_form" action="{""|fn_url}" method="post" class="cm-ajax cm-ajax-full-render">
        <input type="hidden" name="return_url" value="{$smarty.request.return_url|default:$config.current_url}" />
        <input type="hidden" name="redirect_url" value="{$config.current_url}" />
        <input type="hidden" name="custom_id" value="{$id}" />
        {include file="addons/cp_otp_registration/components/auth_form.tpl" otp_type="login" obj_id=$id}
    </form>
    <script type="text/javascript">
        (function(_, $) {
            $.ceEvent('on', 'ce.formpost_{$id}_form', function(form, clicked_elm) {
                if (clicked_elm.attr('name') == 'dispatch[profiles.cp_check_otp]') {
                    var action = clicked_elm.data('caOtpAction') || '';
                    form.find('input[name="otp_action"]').val(action);
                }
            });
        } (Tygh, Tygh.$));
    </script>
{/capture}

{if $style == "popup"}
    {$smarty.capture.login nofilter}
{else}
    <div class="ty-login">
        {$smarty.capture.login nofilter}
    </div>

    {capture name="mainbox_title"}{__("sign_in")}{/capture}
{/if}
