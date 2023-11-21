{$colors="main_bkg_color icons text"}
{$et_settings=explode(" ",$colors)}

{foreach from=$et_settings item=item key=key name=name}
  <div class="control-group">
    {$label_name="et_vivashop_settings.`$item`"}
    <label class="control-label cm-color" for="elm_{$item}">{__($label_name)}:</label>
    <div class="controls">
      <div class="te-colors clearfix">
      {$cp_value = ($et_block_settings.fib.fib_colors.$item)|default:"#ffffff"}
        <div class="colorpicker">
          <div class="input-prepend">
            <input type="text"  maxlength="7"  name="et_block_settings[fib][fib_colors][{$item}]" id="elm_{$item}" value="{$cp_value}" data-ca-view="input" class="cm-colorpicker ">
          </div>
        </div>
      </div>
    </div>
  </div>    
{/foreach}

<style>
.sp-container{
  top: 30px !important;
}
</style>