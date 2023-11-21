{** vendor_store_blocks section **}

{assign var="r_url" value=$config.current_url|escape:url}
{capture name="mainbox"}

{include file="common/pagination.tpl"}

<form action="{""|fn_url}" method="post" name="vendor_store_blocks_form" id="vendor_store_blocks_form" class="{if $hide_inputs}cm-hide-inputs{/if}">
<div class="items-container{if ""|fn_check_form_permissions} cm-hide-inputs{/if}" id="update_vendor_store_blocks_list">
{if $vsb}
  <div class="items-container {if !$dynamic_object}cm-sortable{/if}" data-ca-sortable-table="et_mv_vsb" data-ca-sortable-id-name="vsb_id"  id="manage_vsb">
    <table class="table table-middle">
    <tbody>
      {foreach from=$vsb item=item}
      
      {capture name = "tool_items"}{strip}
        {include file="views/companies/components/company_name.tpl" object=$item}
      {/strip}{/capture}
      {$_href_update="vendor_store_blocks.update?vsb_id=`$item.vsb_id`"}
      {$_href_delete="vendor_store_blocks.delete?vsb_id=`$item.vsb_id`&return_url=`$r_url`"}
      {$additional_class="cm-sortable-row cm-sortable-id-`$item.vsb_id`"}
      {include
        file="common/object_group.tpl"
        id=$item.vsb_id
        text=$item.data.title
        href=$_href_update
        href_delete=$_href_delete
        delete_target_id="pagination_contents"
        header_text="{__("_editing_vsb")}: `$item.data.title`"
        table="et_mv_vsb"
        object_id_name="vsb_id"
        draggable=true
        update_controller='vendor_store_blocks'
        status=$item.status
        additional_class=$additional_class
        non_editable=$dynamic_object
        no_table=true
        no_popup=true
        can_change_status=true
        href_desc=$smarty.capture.tool_items
      }
      {/foreach}

    </tbody>
    </table>
  </div>
{else}
  <p class="no-items">{__("no_data")}</p>
{/if}
<!--update_vendor_store_blocks_list--></div>

{include file="common/pagination.tpl"}

{capture name="adv_buttons"}
    {include file="common/tools.tpl" tool_href="vendor_store_blocks.add?default_block=1" prefix="top" hide_tools="true" title=__("add") icon="icon-plus"}
{/capture}

</form>
{/capture}

{include file="common/mainbox.tpl" title=__("et_vendor_panel_menu.default_vendor_store") content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons select_languages=true}