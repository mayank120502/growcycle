<script type="text/javascript">
    (function(_, $) {
        var fast_reg_selector = 'select[id*="cp_otp_registration_login_type"]';
        var excl_email_selector = 'input[id*="cp_otp_registration_exclude_email"]';
        var uniform_input = 'input[id*="addon_option_cp_otp_registration_fast_registration"]';
        
        $.ceEvent('on', 'ce.commoninit', function(context) {
            context.find(uniform_input).each(function (index, item) {
                $(item).change();
            });
            context.find(fast_reg_selector).each(function (index, item) {
                fn_cp_otp_check_fast_reg_setting($(item));
            });
            context.find(excl_email_selector).each(function (index, item) {
                fn_cp_otp_check_excl_email_setting($(item));
            });
        });

        $(_.doc).on('change', fast_reg_selector, function (e) {
            fn_cp_otp_check_fast_reg_setting($(this));
        });

        $(_.doc).on('click', excl_email_selector, function (e) {
            fn_cp_otp_check_excl_email_setting($(this));
        });
        $(_.doc).on('change', uniform_input, function (e) {
            var is_checked = $(this).prop('checked');
            if (is_checked) {
                $('div[id^="container_addon_option_cp_otp_registration_required_email_"]').hide();
            } else {
                $('div[id^="container_addon_option_cp_otp_registration_required_email_"]').show();
            }
        });

        function fn_cp_otp_check_excl_email_setting(elm) {
            var disable = elm.prop('checked');
            var select_elm = $('select[id*="cp_otp_registration_default_auth_method"]');
            if (select_elm.length) {
                select_elm.children('option').each(function() {
                    if ($(this).val() == 'email') {
                        $(this).prop('disabled', disable);
                        if ($(this).prop('selected') && disable) {
                            select_elm.children('option:first').prop('selected', true);
                        }
                    }
                });
            }
        }

        function fn_cp_otp_check_fast_reg_setting(elm) {
            var child = $('div.control-group[id*="cp_otp_registration_fast_registration"]');
            if (elm.val() == 'otp') {
                child.show();
            } else {
                child.hide();
            }
        }
    })(Tygh, Tygh.$);
</script>
