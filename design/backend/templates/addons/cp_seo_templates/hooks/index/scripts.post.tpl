<script language="javascript">
    (function (_, $) {
        $(_.doc).on('click', '.cp-seo__filter-click', function () {
            var self = $(this);
            var active_input = self.data('caTargetTemplate') ? $('#' + self.data('caTargetTemplate')) : $('.cm-emltpl-set-active.cm-active');

            if (active_input.length) {
            if (active_input.hasClass('cm-wysiwyg')) {
                // if wysiwyg cannot be focused (e.g. on the non-active tab) snippet will be paste inside the last clicked element
                if (active_input.parent().is(':visible')) {
                    active_input.ceEditor('insert', '|' + self.data('caTemplateValue'));
                }

                return;
            } else {
                active_input.ceInsertAtCaret('|' + self.data('caTemplateValue'));
            }
            }
        });
    })(Tygh, Tygh.$);
</script>
