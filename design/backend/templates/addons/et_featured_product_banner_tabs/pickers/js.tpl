{if $et_block_id}
  {$title=fn_et_get_featured_product_banner_tabs_title($et_block_id)|default:"`$ldelim`item`$rdelim`"}
{else}
  {$title=$default_name}
{/if}

<span {if !$clone}id="{$holder}_{$et_block_id}" {/if}class="cm-js-item no-margin">
  <input type="text" 
  	class="cm-picker-value-description {$extra_class}" 
  	value="{$title}" 
  	{if $display_input_id}id="{$display_input_id}"{/if} 
  	size="10" 
  	name="et_block_name" 
  	readonly="readonly" 
  	{$extra}/>
</span>
