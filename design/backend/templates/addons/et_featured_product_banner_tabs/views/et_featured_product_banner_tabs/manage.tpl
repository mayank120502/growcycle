{** et_featured_product_banner_tabs section **}
{capture name="mainbox"}
{include file="common/pagination.tpl"}

<form action="{""|fn_url}" method="post" name="et_featured_product_banner_tabs_form" id="et_featured_product_banner_tabs_form" class="{if $hide_inputs}cm-hide-inputs{/if}">

  <div class="items-container{if ""|fn_check_form_permissions} cm-hide-inputs{/if}" id="update_et_featured_product_banner_tabs_list">
    {if $blocks}
      <div class="items-container "id="manage_block">
        <table class="table table-middle">
          <tbody>
            {foreach from=$blocks item=block}
              {$_href_update="et_featured_product_banner_tabs.update?block_id=`$block.block_id`"}
              {$_href_delete="et_featured_product_banner_tabs.delete?block_id=`$block.block_id`"}
              {include
                file="common/object_group.tpl"
                id=$block.block_id
                text=$block.title
                href=$_href_update
                href_delete=$_href_delete
                delete_target_id="pagination_contents"
                header_text="{__("_editing_block")}: `$block.title`"
                table="block"
                object_id_name="block_id"
                draggable=false
                update_controller='et_featured_product_banner_tabs'
                status=$block.status
                additional_class=$additional_class
                non_editable=$dynamic_object
                no_table=true
                no_popup=true
                can_change_status=true
              }
             {/foreach}
          </tbody>
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
            <li>{btn type="delete_selected" dispatch="dispatch[et_featured_product_banner_tabs.m_delete]" form="banners_form"}</li>
        {/if}
    {/capture}
    {dropdown content=$smarty.capture.tools_list}
{/capture}

{capture name="adv_buttons"}
    {include file="common/tools.tpl" tool_href="et_featured_product_banner_tabs.add" prefix="top" hide_tools="true" title=__("add") icon="icon-plus"}
{/capture}

</form>

{/capture}

{include file="common/mainbox.tpl" title=__("et_featured_product_banner_tabs.manage") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons adv_buttons=$smarty.capture.adv_buttons select_languages=true}