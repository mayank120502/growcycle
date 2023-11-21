{** vendor_store_blocks section **}

{assign var="r_url" value=$config.current_url|escape:url}
{capture name="mainbox"}

{include file="common/pagination.tpl"}

{if fn_check_view_permissions("companies.get_companies_list", "GET")}

{assign var="company_name" value=$runtime.et_company_name|truncate:43:"...":true}
{$runtime_et_company_id=$runtime.et_company_id}

{if $runtime.company_id==0}
  <div class="navbar navbar-inverse1">
  <div class="navbar-inner"><ul class="nav">
    {$et_dispatch=$smarty.request.dispatch}
    {include
        file="addons/et_vivashop_mv_functionality/components/et_ajax_select_object.tpl"
        data_url="companies.et_get_companies_list?show_all=Y&et_dispatch=`$et_dispatch`"
        text=$company_name
        dropdown_icon=false
        id="et_top_company_id_new"
        type="list"
        extra_content=$smarty.capture.extra_content
    }
   
  </ul></div></div>
{/if}
{/if}

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
    {include file="common/tools.tpl" tool_href="vendor_store_blocks.add" prefix="top" hide_tools="true" title=__("add") icon="icon-plus"}
{/capture}

</form>
{/capture}

{include file="common/mainbox.tpl" title=__("et_vendor_panel_menu.my_home_blocks") content=$smarty.capture.mainbox adv_buttons=$smarty.capture.adv_buttons select_languages=true}