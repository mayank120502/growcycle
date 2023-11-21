(function (_, $) {
    $.fn_cp_save_start_order_product_cart = function (product_id, button) {
        let targetForm = button.data('caTargetForm'),
            form       = targetForm ? $('form[name="' + targetForm + '"]') : button.closest('form'),
            data       = {
                product_id: product_id
            };

        $('[name^="product_data[' + product_id + ']"]', form).each(function () {
            data[this.name] = $(this).val();
        });

        $.ceAjax('request', fn_url('checkout.cp_save_start_order'), {
            method: 'POST',
            data  : data
        });
    };

    $.ceEvent('on', 'ce.commoninit', function (context) {
        $('[id^="cp_send_inquiry_attachments_"]', context).change(function() {
            let form = $(this).closest('form'),
                button = $('.ty-fileuploader__file-local > a.hidden', form).last(),
                count_attachments = $('[id^="file_"][name="file_attachments[]"]:not([value=""])', form).length,
                hidden = count_attachments >= _.tr('cp_contact_vendor_max_attachments');

            button.toggleClass('cp-hidden', hidden);
        });

        $('#cp-continue').on('click', function(event){
            // event.preventDefault();
            // console.log('i run');
            // return;//
            const captcha = $('.captcha');
            if (captcha.length && captcha.is(":hidden")) {
                console.log('i run captcha');
                if (!$('form').ceFormValidator('checkFields', true, false, true)) {
                    _.showRecaptcha();
                }
            }
        });
    });

    $.ceEvent('on', 'ce.dialogshow', function (dialog) {
        const email_input = $('#cp_nbt_login_email');
        if (email_input.length) {
            email_input.on('keypress',function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    $('#cp-nbt-continue').click();
                    return false;
                }
            });
        }
        const phone_input = $('#phone');
        if (phone_input.length) {
            phone_input.on('keypress',function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    $('#cp-get-code').click();
                    return false;
                }
            });
        }
    });

    $.ceEvent('on', 'ce.dialogclose', function (dialog) {
        const dl = $(dialog);
        if (dl.attr('id') === 'cp_nbt_login_popup') {
            cp_clear_flags(function(){
                dl.attr('class', 'hidden');
                dl.text('');
            });
        }
    });

    window.cp_clear_flags = function(callback) {
        $.ceAjax('request', fn_url('cp_nbt_login.clear_flag'), {
            method: 'post',
            hidden: true,
            callback: callback
        });
    }
    _.hideRecaptcha = function(){
        const captcha = $('.captcha');
        if (captcha.length) {
            captcha.hide();
        }
    }
    _.showRecaptcha = function(){
        const captcha = $('.captcha');
        if (captcha.length && captcha.is(":hidden")) {
            captcha.show();
        }
    }
}(Tygh, Tygh.$));
