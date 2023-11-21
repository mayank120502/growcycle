{if (fn_allowed_for('ULTIMATE') && $runtime.company_id) || $runtime.simple_ultimate || fn_allowed_for('MULTIVENDOR')}

<div class="hidden" id="content_et_category_banner">
  {include file="common/subheader.tpl" title="{__("et_category_banner")}" target="#et_category_banner_setting"}

  <div id="et_category_banner_setting" class="in collapse">
    <input type="hidden" name="category_data[et_category_banner][item_ids]" value="{$et_category_banner.item_ids}">

    {* Banner Picker *}
    {include 
      file="addons/banners/pickers/banners/picker.tpl" 
      input_name="category_data[et_category_banner][item_ids]"
      type="links" 
      item_ids=$et_category_banner.item_ids
      placement=""
      display="radio"
      positions=true}
  </div>
</div>
{/if}