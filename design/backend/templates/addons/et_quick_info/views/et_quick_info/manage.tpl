{** et_quick_info section **}
{capture name="mainbox"}
{include file="common/pagination.tpl"}

{assign var="c_url" value=$config.current_url|fn_query_remove:"sort_by":"sort_order"}

<form action="{""|fn_url}" method="post" name="et_quick_info_form" id="et_quick_info_form" class="{if $hide_inputs}cm-hide-inputs{/if}">

  <div class="items-container{if ""|fn_check_form_permissions} cm-hide-inputs{/if}" id="update_et_quick_info_list">
    {if $blocks}
      <div class="table-responsive-wrapper">
        <table width="100%" class="table table-middle table--relative table-responsive">
          <thead>
            <tr>
              <th width="6%" class="nowrap">
                {__("position_short")}
              </th>
              <th width="28%">
                {__("name")}
              </th>
              <th width="50%">
                <span class="row-status object-group-details"></span>
              </th>
              <th width="10%" class="nowrap">&nbsp;</th>
              <th width="10%" class="right">
                {__("status")}
              </th>
            </tr>
          </thead>

          {foreach from=$blocks item=block}
            {$_href_update="et_quick_info.update?block_id=`$block.block_id`"}
            {$_href_delete="et_quick_info.delete?block_id=`$block.block_id`"}

            <tr class="cm-row-status-{$block.status|lower}" data-ct-company-id="{$block.block_id}">
              <td class="left" data-th="{__("position_short")}">
                  <input type="text" name="block_data[{$block.block_id}][position]" value="{$block.position}" size="3" class="input-micro input-hidden" />
              </td>

              <td class="row-status" data-th="{__("name")}">
                  <a href="{$_href_update|fn_url}" title="{$block.data.title}" class="row-status cm-external-click" >
                      {$block.data.title}
                  </a>
              </td>

              <td></td>

              <td class="right nowrap" data-th="{__("tools")}">
                {capture name="tools_items"}
                  <li>{btn type="list" text=$link_text|default:__("edit") href=$_href_update}</li>
                  <li>{btn type="text" text=__("delete") href=$_href_delete class="cm-confirm cm-tooltip cm-ajax cm-ajax-force cm-ajax-full-render `$class`" data=["data-ca-target-id" => "pagination_contents", "data-ca-params" => $delete_data] method="POST"}</li>
                {/capture}
                <div class="hidden-tools">
                    {dropdown content=$smarty.capture.tools_items}
                </div>
              </td>

              <td class="right nowrap" data-th="{__("status")}">
                {include file="common/select_popup.tpl" id=$block.block_id status=$block.status hidden=true update_controller="et_quick_info"}
             </td>
            </tr>
          {/foreach}
        </table>

      </div>
    {else}
      <p class="no-items">{__("no_data")}</p>
    {/if}
  </div>
{include file="common/pagination.tpl"}

{capture name="buttons"}
    {capture name="tools_list"}
        {if $blocks}
            <li>{btn type="delete_selected" dispatch="dispatch[et_quick_info.m_delete]" form="banners_form"}</li>
        {/if}
    {/capture}
    {dropdown content=$smarty.capture.tools_list}

    {include file="buttons/save.tpl" but_name="dispatch[et_quick_info.m_update]" but_role="action" but_target_form="et_quick_info_form" but_meta="cm-submit"}
{/capture}

{capture name="adv_buttons"}
    {include file="common/tools.tpl" tool_href="et_quick_info.add" prefix="top" hide_tools="true" title=__("add") icon="icon-plus"}
{/capture}

</form>

{/capture}

{include file="common/mainbox.tpl" title=__("et_quick_info.manage") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons select_languages=true}