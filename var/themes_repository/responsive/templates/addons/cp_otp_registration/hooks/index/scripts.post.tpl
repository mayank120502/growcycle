{if $addons.cp_otp_registration.use_country_prefix == "Y"}
    {script src="js/addons/cp_otp_registration/intlTelInput-jquery.min.js"}
    {$cp_countries_list = ""|fn_cp_otp_get_avail_countries}
    <script type="text/javascript">
        (function (_, $) {
            $.extend(_, {
                cp_otp_registration: {
                    'default_country': '{$addons.cp_otp_registration.default_country}',
                    {if $cp_countries_list}'countries_list': {$cp_countries_list|json_encode nofilter}{/if}
                }
            });
        }(Tygh, Tygh.$));
    </script>
{/if}

{if $runtime.controller == "checkout" && $runtime.mode == "checkout"}
    {$c_url = $config.current_url|escape:url}
    <script type="text/javascript">
        (function (_, $) {
            $.ceEvent('on', 'ce.commoninit', function(context) {
                {if $addons.cp_otp_registration.required_email != "Y"}
                    $('label[for="litecheckout_email"]').removeClass('cm-required');
                {/if}
            });
            
            $.ceEvent('on', 'ce.ajaxdone', function(context, inline_scripts, params, data) { 
                var title = '{__("cp_otp_already_exists_title")}';
                var block_id = 'litecheckout_login_block';
                if (!$('#' + block_id).length || !data.cp_show_login
                    || typeof data.notifications == 'undefined' // definition of lite checkout submit
                ) {
                    return false;
                }
                var target_url = fn_url('auth.login_form?is_popup=1&return_url={$c_url}');
                if (typeof data.phone != 'undefined') {
                    target_url += '&auth_field=phone&phone=' + data.phone;
                } else if (typeof data.email != 'undefined') {
                    target_url += '&auth_field=email&email=' + data.email;
                }
                
                $('#' + block_id).empty();
                $('#' + block_id).ceDialog('destroy');
                $('#' + block_id).ceDialog('open', {
                    href: target_url,
                    width: 'auto',
                    height: 'auto',
                    dialogClass: 'dialog-auto-sized',
                    title: title
                });
                
                $('.cm-dialog-opener').each(function() {
                    if ($(this).data('caTargetId') == block_id) {
                        $(this).prop('title', title);
                    }
                });
            });
        }(Tygh, Tygh.$));
    </script>
{/if}

{script src="js/addons/cp_otp_registration/func.js"}
