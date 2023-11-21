{capture name="mainbox"}

{$has_permission = fn_check_permissions("seo_rules", "delete", "admin", "POST")}

<form action="{""|fn_url}" method="post" name="seo_form" class="form-horizontal form-edit">

{include file="common/pagination.tpl" save_current_page=true save_current_url=true}
{if $seo_data}
<input type="hidden" name="page" value="{$smarty.request.page}" />
<div class="table-responsive-wrapper longtap-selection">
  <table width="100%" class="table table-middle table--relative table-responsive">
  <thead 
    data-ca-bulkedit-default-object="true"
    data-ca-bulkedit-component="defaultObject"
  >
  <tr>
    <th width="30%">{__("dispatch_value")}</th>
    <th width="50%">{__("seo_name")}</th>
    <th width="8%">&nbsp;</th>
  </tr>
  </thead>
  {foreach from=$seo_data item="var" key="key"}
  <tr class="cm-longtap-target">
    <td width="30%" data-th="{__("dispatch_value")}">
      <input type="hidden" name="seo_data[{$key}][rule_params]" value="{$var.dispatch}" />
      <span>{$var.dispatch}</span></td>
    <td width="50%" data-th="{__("seo_name")}">
      <input type="text" name="seo_data[{$key}][name]" value="{$var.name}" class="input-hidden input-large" /></td>
    <td width="8%" class="nowrap" data-th="{__("tools")}">
      <div class="hidden-tools">
        {capture name="tools_list"}
          {assign var="_dispatch" value="`$var.dispatch`"|escape:url}
        {/capture}
        {dropdown content=$smarty.capture.tools_list}
      </div>
    </td>
  </tr>
  {/foreach}
  </table>
</div>
{else}
  <p class="no-items">{__("no_data")}</p>
{/if}

{include file="common/pagination.tpl"}
</form>
{/capture}

{capture name="buttons"}
  {if $seo_data}
    {include file="buttons/save.tpl" but_name="dispatch[et_seo_rules.m_update]" but_role="action" but_target_form="seo_form" but_meta="cm-submit"}
  {/if}
{/capture}


{include file="common/mainbox.tpl" title=__("et_seo_rules") content=$smarty.capture.mainbox title_extra=$smarty.capture.title_extra buttons=$smarty.capture.buttons  adv_buttons=$smarty.capture.adv_buttons select_languages=true}