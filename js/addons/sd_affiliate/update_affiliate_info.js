(function(_, $) {
    $(document).ready(function(){
        var aff_status = $('#elm_affiliate_status'),
            aff_plan = $('#elm_affiliate_plan'),
            decline_reason = $('#reason_to_decline'),
            aff_coupon_code = $('#elm_affiliate_coupon_code');
        aff_status.on('change', function(){
            if (aff_status.val() == 'N' || aff_status.val() == 'D') {
                aff_plan.attr("disabled", "true");
                aff_coupon_code.attr("disabled", "true");
                $("#elm_affiliate_plan :selected").removeAttr("selected");
                $("#elm_affiliate_coupon_code :selected").removeAttr("selected");
                $('#affiliate_plan_0').attr("selected", "selected");
                if (aff_status.val() == 'D') {
                    decline_reason.removeClass("hidden");
                } else {
                    decline_reason.addClass("hidden");
                }
            } else {
                aff_plan.removeAttr("disabled");
                aff_coupon_code.removeAttr("disabled");
                decline_reason.addClass("hidden");
            }
        });
    });
}(Tygh, Tygh.$));