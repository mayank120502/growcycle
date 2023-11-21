{if !$smarty.request.extra}
<script type="text/javascript">
(function(_, $) {
  _.tr('text_items_added', '{__("text_items_added")|escape:"javascript"}');

  $.ceEvent('on', 'ce.formpost_et_block_form', function(frm, elm) {
    var et_block = {};

    if ($('input.cm-item:checked', frm).length > 0) {
      $('input.cm-item:checked', frm).each( function() {
        var id = $(this).val();
        et_block[id] = $('#et_block_' + id).text().trim();
      });

      {literal}
        $.cePicker('add_js_item', frm.data('caResultId'), et_block, 'b', {
          '{et_block_id}': '%id',
          '{et_block}': '%item'
        });
      {/literal}

    }

    return false;
  });

}(Tygh, Tygh.$));
</script>
{/if}

<form action="{$smarty.request.extra|fn_url}" data-ca-result-id="{$smarty.request.data_id}" method="post" name="et_block_form">

  {if $blocks}
    <table width="100%" class="table table-middle">
      <thead>
        <tr>
          <th>
          </th>
          <th width="84%">
            {__("blocks")}
          </th>
          <th class="right">
            Tabs
          </th>
        </tr>
      </thead>
      {foreach from=$blocks item=item}
        <tr>
          <td>
            <input type="radio" 
              name="{$smarty.request.checkbox_name|default:"et_block_ids"}[]" 
              id="{$smarty.request.checkbox_name|default:"et_block_ids"}{$item.block_id}" 
              value="{$item.block_id}" 
              class="cm-item" {if $item.block_id==$et_selected_id}checked{/if}/>
          </td>

          <td id="et_block_{$item.block_id}" width="100%">
            <label class="inline-label" for="{$smarty.request.checkbox_name|default:"et_block_ids"}{$item.block_id}">{$item.title}</label>
          </td>
          <td class="right">
            {$item.tab_count}
          </td>
        </tr>
      {/foreach}
    </table>
  {else}
    <p class="no-items">{__("no_data")}</p>
  {/if}

  {if $blocks}
    <div class="buttons-container">
      {include file="buttons/add_close.tpl" but_close_text=__("choose") is_js=$smarty.request.extra|fn_is_empty}
    </div>
  {/if}

</form>
