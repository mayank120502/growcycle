{if $id}
    <div id="content_cp_open_graph" class="hidden">
        {include file="addons/cp_open_graph/views/components/meta_data_fields.tpl"
            og_type=$page_data.cp_og_data_type
            input_prefix="page_data"
        }
    </div>
{/if}