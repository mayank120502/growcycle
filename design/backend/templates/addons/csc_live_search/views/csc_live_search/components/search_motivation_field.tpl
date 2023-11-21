<div class="control-group cls-search-motivation" id="container_elm_{$field_name}">
  <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if}">{__("`$prefix`.{$field_name}")}
      {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
  </label>
  <div class="controls">  
  	<div class="cls-synonyms input-large" data-ca-keys="enter" data-ca-name="{$param_name}[{$field_name}]" >
        {foreach from=$options.$field_name item=phrase}			
           <div class="tag">{$phrase}</div>
        {/foreach}
        <input type="hidden" value="array(){json_encode($options.$field_name)}" class="tags_array" name="{$param_name}[{$field_name}]" />
    </div>
       {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}                        
  </div>
   {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}
</div>