<div class="cp_json_ld__recomendations">
    {__("cp_json_ld.recomendation_txt")}
</div>

<script type="text/javascript">
(function(_, $) {
    $(document).ready(function() {
        var displayOn = $('#addon_option_cp_json_ld_company_markup_display_on').val();
        var $pageSelectorContainer = $('#container_addon_option_cp_json_ld_company_markup_page');

        if (displayOn == 'page') {
            $pageSelectorContainer.removeClass('hidden');
        } else {
            $pageSelectorContainer.addClass('hidden');
        }
    });

    $(_.doc).on('change', '#addon_option_cp_json_ld_company_markup_display_on', function() {
        var displayOn = $(this).val();
        var $pageSelectorContainer = $('#container_addon_option_cp_json_ld_company_markup_page');

        if (displayOn == 'page') {
            $pageSelectorContainer.removeClass('hidden');
        } else {
            $pageSelectorContainer.addClass('hidden');
        }
    });
})(Tygh, Tygh.$);
</script>