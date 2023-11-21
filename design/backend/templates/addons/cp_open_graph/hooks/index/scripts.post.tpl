<script type="text/javascript">
(function(_, $) {
    $(document).on('change', '.cp-og-type-change input', function() {
        var chosen_type = $(this).val();

        if (chosen_type == 'M') {
            $('#cp_og_data_auto').addClass('hidden');
            $("#cp_og_data_manual input, #cp_og_data_manual textarea").prop("disabled", false);
            $('#cp_og_data_manual').removeClass('hidden');
        } else {
            $('#cp_og_data_auto').removeClass('hidden');
            $("#cp_og_data_manual input, #cp_og_data_manual textarea").prop("disabled", true);
            $('#cp_og_data_manual').addClass('hidden');
        }
    });
}(Tygh, Tygh.$));
</script>