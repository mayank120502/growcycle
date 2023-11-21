(function(_, $) {
    $(document).ready(function() {
        $(_.doc).on('click', '.js-show-login-pass-sign', function (e) {
            let $defaultLogin = $('.js-login-pass, .js-show-social-login-sign'),
                $socialLogin  = $('.js-social-login, .js-show-login-pass-sign');

            switchBlock($socialLogin, $defaultLogin);
        });
        $(_.doc).on('click', '.js-show-social-login-sign', function (e) {
            let $defaultLogin = $('.js-login-pass, .js-show-social-login-sign'),
                $socialLogin  = $('.js-social-login, .js-show-login-pass-sign');

            switchBlock($defaultLogin, $socialLogin);
        });
        $(_.doc).on('click', '.js-show-login-pass-reg', function (e) {
            let $defaultRegistration = $('.js-login-pass-reg, .js-show-social-login-reg'),
                $socialRegistration  = $('.js-social-login-reg, .js-show-login-pass-reg');

            switchBlock($socialRegistration, $defaultRegistration);
        });
        $(_.doc).on('click', '.js-show-social-login-reg', function (e) {
            let $defaultRegistration = $('.js-login-pass-reg, .js-show-social-login-reg'),
                $socialRegistration  = $('.js-social-login-reg, .js-show-login-pass-reg');

            switchBlock($defaultRegistration, $socialRegistration);
        });
    });

    function switchBlock(elem_hide, elem_show) {
        elem_hide.hide();
        elem_show.show();
        $.ceDialog('get_last').ceDialog('reload');
    }
}(Tygh, Tygh.$));
