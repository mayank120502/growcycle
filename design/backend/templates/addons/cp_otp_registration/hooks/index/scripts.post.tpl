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

{script src="js/addons/cp_otp_registration/func.js"}