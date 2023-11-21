{if !$smarty.request.extra}
<script type="text/javascript">
(function(_, $) {

    _.tr('text_items_added', '{__("text_items_added")|escape:"javascript"}');
    var display_type = '{$smarty.request.display|escape:javascript nofilter}';

    $.ceEvent('on', 'ce.formpost_add_plans', function(frm, elm) {
        var plans = {};

        if ($('input.cm-item:checked', frm).length > 0) {
            $('input.cm-item:checked', frm).each( function() {
                var id = $(this).val();
                var item = $(this).parent().siblings();
                plans[id] = item.find('.plan-name').text();
            });

            {literal}
            $.cePicker('add_js_item', frm.data('caResultId'), plans, 'p', {
                '{plan_id}': '%id',
                '{plan}': '%item'
            });
            {/literal}

            if (display_type != 'radio') {
                $.ceNotification('show', {
                    type: 'N', 
                    title: _.tr('notice'), 
                    message: _.tr('text_items_added'), 
                    message_state: 'I'
                });
            }
        }

        return false;        
    });
}(Tygh, Tygh.$));
</script>
{/if}
{include file="addons/sd_affiliate/views/affiliate_plans/components/plans_search_form.tpl" dispatch="affiliate_plans.picker" extra="<input type=\"hidden\" name=\"result_ids\" value=\"pagination_`$smarty.request.data_id`\">" put_request_vars=true form_meta="cm-ajax" in_popup=true}

<form action="{$smarty.request.extra|fn_url}" method="post" name="add_plans" data-ca-result-id="{$smarty.request.data_id}" enctype="multipart/form-data">
<input type="hidden" name="display_type" value="{$smarty.request.display}">

{$but_text = __("addons.sd_affiliate.add_plans")}
{$but_close_text = __("addons.sd_affiliate.add_plans_and_close")}

{if $smarty.request.display == "radio"}
    {$show_radio = true}
    {$hide_options = true}
    {$but_text = ""}
    {$but_close_text = __("choose")}
{/if}

{include file="common/pagination.tpl" save_current_page=true div_id="pagination_`$smarty.request.data_id`"}

{if $plans}
<table width="100%" class="table table-middle">
<thead>
<tr>
    <th width="1%" class="center">
        {include file="common/check_items.tpl"}</th>
    <th width="20%">{__("id")}</th>
    <th>{__("name")}</th>
</tr>
</thead>
{foreach from=$plans key=plan_id item=plan}
<tr>
    <td class="left">
        <input type="checkbox" name="add_plans[]" value="{$plan_id}" class="cm-item" />
    </td>
    <td>{$plan_id}</td>
    <td><span class="plan-name">{$plan}</span></td>
</tr>
{/foreach}
</table>
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl" div_id="pagination_`$smarty.request.data_id`"}
{if $plans}
<div class="buttons-container">
    {include file="buttons/add_close.tpl" but_text=$but_text but_close_text=$but_close_text is_js=$smarty.request.extra|fn_is_empty}
</div>
{/if}

</form>
