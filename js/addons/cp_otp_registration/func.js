(function(_, $) {
    $.ceEvent('on', 'ce.commoninit', function(context) {
        $('.cp-otp-timer').each(function () {
            if ($(this).data('caTimerActive') == true) {
                return;
            }
            $(this).data('caTimerActive', true);
            var start_time = $(this).html().split(':');
            var seconds = 0;
            if (typeof start_time[0] != 'undefined') {
                seconds += Number(start_time[0]) * 60;
            }
            if (typeof start_time[1] != 'undefined') {
                seconds += Number(start_time[1]);
            }
            var timer = $(this);
            var parent = $(this).closest('.cp-otp-timer-wrap');
            
            var countdown = setInterval(function() {
                var current = cpConvertSecondsToTime(seconds);
                timer.html(current);
                if (seconds <= 0) {
                    clearInterval(countdown);

                    cpShowNewCodeBtn(parent);
                    cpClearCodeFields($(this));
                }
                seconds--;
            }, 1000);
        });

        if (typeof _.cp_otp_registration != 'undefined') {
            var countries = (typeof _.cp_otp_registration.countries_list != 'undefined') ? _.cp_otp_registration.countries_list : [];
            var defaultCountry = (typeof _.cp_otp_registration.default_country != 'undefined') ? _.cp_otp_registration.default_country : '';
            setTimeout(function() {
                $('.cp-phone').intlTelInput({
                    nationalMode: false,
                    autoHideDialCode: false,
                    onlyCountries: countries,
                    initialCountry: defaultCountry,
                    //separateDialCode: true,
                });
            }, 200);
        }
    });

    $.ceEvent('on', 'ce.ajaxdone', function(context, scripts, params, data) {
        if (typeof data.cp_otp_fail != "undefined"
            && typeof params.form != "undefined"
        ) {
            if (data.cp_otp_fail == 'time' || data.cp_otp_fail == 'attempts') {
                cpShowNewCodeBtn(params.form.find('.cp-otp-timer-wrap'));
            }
            cpClearCodeFields(params.form);
            params.form.find('[type="submit"]').data('clicked', false); // fix for form btn
        }
        setTimeout(function(){
            $('.cp-phone').trigger('click');
        }, 200);
    });


    // change popup link
    $(_.doc).on('blur keydown', '.cp-phone', function(e) {
        var phone = $(this).val().replace(/[^0-9]/gim, '');
        var verificationBlock = $(this).data('caVerification');
        if (typeof verificationBlock != 'undefined' && $('#' + verificationBlock).length) {
            var link = $('#' + verificationBlock).find('.cp-verification-link');
            if (typeof link == 'undefined') {
                return;
            }
            var verPhone = $('#' + verificationBlock).find('.cp-phone-confirmed');
            if (verPhone.data('caPhone') != phone && link.is(':hidden')) {
                verPhone.hide();
                link.show();
                $('#cp_otp_verified').val('N');
            } else if (phone != '' && verPhone.data('caPhone') == phone && link.not(':hidden')) {
                verPhone.show();
                link.hide();
                $('#cp_otp_verified').val('Y');
            }
            if (phone != '') {
                var linkParams = link.attr('href').split('&');
                var newLink = '';
                $.each(linkParams, function(index, value) {
                    if (value.indexOf('phone=') != 0) {
                        newLink += (index != 0) ? '&' : '';
                        newLink += value;
                    }
                });
                newLink =  $.attachToUrl(newLink, 'phone=' + phone);
                link.attr('href', newLink);
            }
        }
    });

    $(_.doc).on('click', '.cp-get-auth-field', function(e) {
        var url = $(this).attr('href');
        if (typeof url != 'undefined') {
            var data = {
                result_ids: $(this).data('caTargetId')
            }
            if ($(this).data('caInputPhone')) {
                data.phone = $('#' + $(this).data('caInputPhone')).val();
            } else if ($(this).data('caInputEmail')) {
                data.email = $('#' + $(this).data('caInputEmail')).val();
            }
            $.ceAjax('request', url, {
                method: 'post',
                caching: false,
                hidden: false,
                data: data
            });
        }
    });

    $(_.doc).on('input', '.cp-otp-code-item', function(e) {
        var value = $(this).val();
        if ($.isNumeric(value)) {
            $(this).next('.cp-otp-code-item').focus();
        } else {
            $(this).val('');
        }

        var target_id = $(this).data('caTargetId');
        var code_len = cpCollectOtpCode(target_id);
        
        if ($('#' + target_id).data('caCount') && $('#' + target_id).data('caCount') == code_len && $('#cp_otp_code_last_num').val() == true) {
            const btn = $('#cp-verify-phone-vendor');
            //var btn = $(this).closest('form').find('button[type="submit"]');
            if (btn.length) {
                btn.click();
            }
        }
    });
    $(_.doc).on('keydown', '.cp-otp-code-item', function(e) {
        var value = $(this).val();
        if (value == '' && e.keyCode == 8) {
            $(this).prev('.cp-otp-code-item').focus();
        }
        cpCollectOtpCode($(this).data('caTargetId'));
    });

    $.ceEvent('on', 'ce.formajaxpost_phone_verification_form', function(data, params, response_text) {
        if (typeof data.cp_otp_fail == 'undefined' || data.cp_otp_fail == '') {
            var container = params.form.closest('div.ui-dialog-content');
            if (container.length) {
                container.ceDialog('close');
                container.find('.object-container').remove();
                $.popupStack.remove(container.prop('id'));
            }
        }
    });

    $.ceEvent('on', 'ce.dialogshow', function ($context) {
        if ($('.cp-auth-field-wrap', $context).length && $('.cm-focus', $context).length) {
            $('.cm-focus:visible', $context).focus().click();
            
            //if ($('.iti__flag-container', $context).length && $context.parent('.ui-dialog').length) {
                $context.parent('.ui-dialog').addClass('cp-otp-show-overflow');
            //}
        }
    });
})(Tygh, Tygh.$);

function cpCollectOtpCode(target_id) {
    if (typeof target_id == 'undefined' || target_id == '') {
        return false;
    }
    var code = '';
    $('.cp-otp-code-item').each(function () {
        code += $(this).val();
    });
    $('#' + target_id).val(code);
    return code.length;
}

function cpConvertSecondsToTime(num) {
    var mins = Math.floor(num / 60);
    var secs = num % 60;
    var timerOutput = (mins < 10 ? "0" : "") + mins + ":" + (secs < 10 ? "0" : "") + secs;
    return timerOutput;
}

function cpValidatePhone(evt, area) {
    var theEvent = evt || window.event;
    var key = theEvent.keyCode || theEvent.which;
    key = String.fromCharCode( key );
    if (area == 'C') {
        var regex = /[-\[\]\(\)0-9]/;
    } else {
        var regex = /[+-\[\]\(\)0-9]/;
    }
    if( !regex.test(key) ) {
        theEvent.returnValue = false;
        if(theEvent.preventDefault) theEvent.preventDefault();
    }
}

function cpChangePhone(val, key) {

    var cpReference = "+", prevVal = '';

    if (val != undefined) {
        var ind = val.indexOf(cpReference);

        if (ind !== 0) {
            key.prop("value", prevVal || cpReference);
        }
    }
}

function cpInput() {
    if ($(this).hasClass('cm-focus')) {
        $(this).get(0).selectionStart = $(this).val().length;
    }

    $(this).on("input", function () {
        var val = $(this).prop("value");
        cpChangePhone(val, $(this));
    });
}

function cpShowNewCodeBtn(parent) {
    var timerInfo = parent.find('.cp-otp-timer-info');
    var newCodeBtn = parent.find('.cp-new-code-btn');
    if (timerInfo.length && newCodeBtn.length) {
        timerInfo.hide();
        newCodeBtn.show();
    }
}

function cpClearCodeFields(parent) {
    var code_items = parent.find('.cp-otp-code-item');
    if (code_items.length) {
        code_items.val('');
        code_items.first().focus();
    }
}
