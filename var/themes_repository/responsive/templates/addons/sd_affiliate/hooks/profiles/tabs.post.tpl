{if !empty($general_affiliate_parameter) && $auth['user_type'] == "AffiliateUserTypes::PARTNER"|enum}
    <div id="content_affiliates">
        <div class="ty-control-group">
            <form name="custom_affiliate_parameter_form" action="{""|fn_url}" method="post">
                <label for="custom_affiliate_parameter" class="ty-control-group__title cm-trim">{__("addons.sd_affiliate.custom_affiliate_parameter_for_affiliate")}{include file="common/tooltip.tpl" tooltip=__("addons.sd_affiliate.custom_affiliate_parameter_for_affiliate_tooltip")}</label>
                <input type="text" id="custom_affiliate_parameter" name="custom_affiliate_parameter" size="32" maxlength="128" value="{$custom_affiliate_parameter}" class="ty-input-text" />
                <a class="ty-btn__secondary ty-btn" id="check_custom_affiliate_parameter">{__("addons.sd_affiliate.check_custom_affiliate_parameter_for_affiliate")}</a>
                <div class="buttons-container">
                    {include file="buttons/save.tpl" but_name="dispatch[profiles.save_custom_affiliate_parameter]" but_meta="ty-btn__secondary" but_id="save_custom_affiliate_parameter"}
                    {include file="buttons/delete.tpl" but_href="profiles.delete_custom_affiliate_parameter"}
                </div>
            </form>
        </div>
    <!--content_affiliates--></div>
{/if}

<script type="text/javascript">
;(function(_, $) {
   $.ceEvent('on', 'ce.commoninit', function(event) {
       $("#check_custom_affiliate_parameter").unbind("click").on("click", function () {
           $.ceAjax('request', fn_url("profiles.check_custom_affiliate_parameter"), {
               data: {
                   affiliate_parameter: $("#custom_affiliate_parameter").val(),
               }
           });
       });
   });
}(Tygh, Tygh.$));
</script>
