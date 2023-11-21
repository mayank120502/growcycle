{if $addons.cp_otp_registration.use_country_prefix == "Y"}
    {style src="addons/cp_otp_registration/intlTelInput.min.css"}
{/if}
{if !$auth.user_id
    && $addons.cp_otp_registration.login_type == "otp"
    && $addons.cp_otp_registration.fast_registration == "Y"
}
<style type="text/css">
    a[href^="{"profiles.add"|fn_url}"] {
        display: none !important;
    }
</style>
{/if}

{style src="addons/cp_otp_registration/styles.less"}
