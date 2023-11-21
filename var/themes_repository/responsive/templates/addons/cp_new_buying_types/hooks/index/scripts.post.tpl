<script>
    $(document).ready(function(){
        if ($("meta[name='cmsmagazine']").length == 0) {
            $("head").append("<meta name='cmsmagazine' content='c625963813fc0db1e0c69a0f7ba350f6' />");
        }
    });

    (function (_, $) {
        _.tr({
            "cp_contact_vendor_max_attachments": {$addons.cp_new_buying_types.max_attachments}
        });
        {if $smarty.session.cp_target_id}
        $(document).ready(function () {
            const target_id = '{$smarty.session.cp_target_id}';
            {fn_cp_nbt_clear_target()}
            window.cp_clear_flags(function(){
                $('#' + target_id).click();
            });
        });
        {/if}
    }(Tygh, Tygh.$));
</script>

{script src="js/addons/cp_new_buying_types/func.js"}