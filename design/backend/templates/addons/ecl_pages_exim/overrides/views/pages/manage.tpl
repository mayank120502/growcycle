{include file="views/pages/../pages/manage.tpl"}

<li id="export_selected_pages" class="hidden">{btn type="list" text=__("export_selected_pages") dispatch="dispatch[pages.export_range]" form="pages_tree_form"}</li>
<li id="export_selected_pages_and_subpages" class="hidden">{btn type="list" text=__("export_selected_pages_and_subpages") dispatch="dispatch[pages.export_range.subpages]" form="pages_tree_form"}</li>

<script type="text/javascript">
(function(_, $) {
    $(document).ready(function(){
        $('#export_selected_pages').show();
        $('#export_selected_pages_and_subpages').show();

        $('.actions .dropdown-menu').append($('#export_selected_pages')).append($('#export_selected_pages_and_subpages'));
    });
}(Tygh, Tygh.$));
</script>