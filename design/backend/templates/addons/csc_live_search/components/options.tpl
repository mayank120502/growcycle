{foreach from=$_params item="tab" key="tab_name"}
    <div id="content_{$tab_name}">  
      
        {foreach from=$tab item="field" key="field_name"}
           {if $field.type == 'input'}
                <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                    <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}                  
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">
                        <input type="{if $field.min || $field.max}number{else}text{/if}" {if $field.min} min="{$field.min}"{/if} {if $field.max} max="{$field.max}"{/if} name="{$param_name}[{$field_name}]" id="elm_{$field_name}" size="55"
                               {if $field.class}class="{$field.class}"{/if}
                               {if $field.placeholder}placeholder="{$field.placeholder}"{/if}
                               value="{if isset($options.$field_name)}{$options.$field_name}{/if}"
                               {if $field.readonly} readonly{/if}
                               {if $disable_input} disabled{/if}
                               
                        />                     
                        {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}
                        
                    </div>
                     {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}
                </div>
    
            {elseif $field.type == 'checkbox'}
                <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                    <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">
                        <input type="hidden" name="{$param_name}[{$field_name}]" value="N" {if $disable_input}disabled="disabled"{/if}>
                        <input type="checkbox" name="{$param_name}[{$field_name}]" id="elm_{$field_name}"
                        	{if $field.class}class="{$field.class}"{/if}
                            {if (isset($options.$field_name) && $options.$field_name == 'Y') } checked{/if} value="Y"
                                {if $field.readonly} readonly{/if}
                                 {if $disable_input} disabled{/if}
                                />
                         {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}                        
                    </div>
                     {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}
                </div>
            {elseif $field.type == 'color'}            
                <div class="control-group cmcs-colorpicker-wrapper {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                    <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">
                             
                       <input type="text" name="{$param_name}[{$field_name}]" id="elm_{$field_name}" size="55"
                               class="cmcs-colorpicker {if $field.class}{$field.class}{/if}"
                               {if $field.placeholder}placeholder="{$field.placeholder}"{/if}
                               value="{if isset($options.$field_name)}{$options.$field_name}{/if}"
                               {if $field.readonly} readonly{/if}
                               {if $disable_input} disabled style="background:{$options.$field_name}"{/if}                             
                        />
                         {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}                        
                    </div>
                     {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}
                </div>
            {elseif $field.type == 'selectbox'}
                <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                    <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">                    	
                        <select name="{$param_name}[{$field_name}]" id="elm_{$field_name}" {if $field.readonly} readonly{/if}
                         {if $field.class}class="{$field.class}"{/if}
                         {if $disable_input} disabled{/if}
                         >
                            {foreach from=$field.variants item="option_name" key="option_code"}
                                <option value="{$option_code}"
                                    {if isset($options.$field_name) && $options.$field_name == $option_code} selected="selected"{/if}>{$option_name}</option>
                            {/foreach}
                        </select>
                        {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}
                    </div>
                    {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}                        
                </div>
            {elseif $field.type == 'multiple'}
                <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                    <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">
                  
                        <select multiple name="{$param_name}[{$field_name}][]" id="elm_{$field_name}" {if $field.readonly} readonly{/if}
                         {if $field.class}class="{$field.class}"{/if}  {if $disable_input} disabled{/if}>
                            {foreach from=$field.variants item="option_name" key="option_code"}
                                <option value="{$option_code}"
                                    {if (isset($options.$field_name) && $option_code|in_array:$options.$field_name)} selected="selected"{/if}>{$option_name}</option>
                            {/foreach}
                        </select>
                        {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}
                    </div>
                    {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}                        
                </div>
            {elseif $field.type == 'select2'}
                <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                    <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">
                    	{if $field.mode == 'multiple'} 
                    		<input type="hidden" name="{$param_name}[{$field_name}][]" value="">
                        {/if}                 
                        <select {if $field.mode == 'multiple'} multiple{/if} 
                        name="{$param_name}[{$field_name}]{if $field.mode == 'multiple'}[]{/if}" 
                        id="elm_{$field_name}"
                        {if $field.dispatch}data-ca-object-picker-ajax-url="{$field.dispatch|fn_url}"{/if} 
                        {if $field.readonly} readonly{/if}
                        class="cm-object-picker object-picker__select object-picker__select--feature-variants {if $field.class}{$field.class}{/if}"
                        {if $disable_input} disabled{/if}>
                        	{if $field.dispatch}
                            	{foreach from=$options.$field_name item="option_code"}
                                	{if $option_code}                                   
                                    <option value="{$option_code}" selected="selected">{if $field.variant_name_function}{call_user_func($field.variant_name_function, $option_code)}{/if}</option> 
                                    {/if}                               
                                {/foreach}   
                            {else}
                            	{foreach from=$field.variants item="option_name" key="option_code"}
                                    {if !$field.dispatch || ((isset($options.$field_name) && $option_code|in_array:$options.$field_name))}
                                    <option value="{$option_code}"
                                        {if (isset($options.$field_name) && $option_code|in_array:$options.$field_name)} selected="selected"{/if}>{$option_name}</option>
                                       {/if}
                                {/foreach}                            
                            {/if}
                           
                        </select>
                        {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}
                    </div>
                    {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}                        
                </div>    
             
            {elseif $field.type == 'double_selectboxes'}
            	<div class="{if $field.show_when}{$prefix}ShowWhen{/if}">
				{assign var="prepared_fields" value=$field.fields_func|call_user_func:$options.$field_name}
                {include file="common/double_selectboxes.tpl"
                    title=__("`$prefix`.{$field_name}")
                    first_name="`$param_name`[`$field_name`]"
                    first_data=$prepared_fields
                    second_name="all_`$field_name`"
                    second_data=$field.values|array_diff_key:$prepared_fields
                }
                </div>    
            {elseif $field.type == 'template'}
                {include file=$field.template name_data="{$param_name}[{$field.name_data}]" data=$options[$field.name_data] params=$field.params}
            {elseif $field.type == 'title'}
                <h4 class="subheader {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">{__("`$prefix`.title_`$field_name`")}{if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}</h4>
                {if $field.description}<p style="clear:both" class="{if $field.show_when}{$prefix}ShowWhen{/if}"><i>{$field.description nofilter}</i></p>{/if}
            {elseif $field.type == 'func_info'}      	
                  <div class="control-group {if $field.group} grouped hidden {$field.group}{/if}" id="container_elm_{$field_name}">
                      {$options.$field_name nofilter}  
                  </div>
             {elseif $field.type == 'link'}      	
                  <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                      <label for="elm_{$field_name}" class="control-label"></label>
                      <div class="controls">
                          <a href="{$field.url|fn_url}" class="{$field.class}">{$field.name}</a>
                      </div>
                  </div>
             {elseif $field.type == 'picker'}      	
                  <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                      <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">                   	
                      {if $show_update_for_all} 
                          <p>{__('text_select_vendor')}</p>
                      {else}                   	                
                        {include_ext file="pickers/{$field.objects}/picker.tpl" company_ids='' data_id="objects_`$field_name`" input_name="`$param_name`[`$field_name`]" item_ids=$options.$field_name extra_url=$field.extra_url owner_company_id='0' but_meta="btn"}
                      {/if}                    
                      </div>
                  </div>
            {elseif $field.type == 'order_status'} 
                  {$order_status_descr = $smarty.const.STATUSES_ORDER|fn_get_simple_statuses:true:true}
                  {$order_statuses = $smarty.const.STATUSES_ORDER|fn_get_statuses:$statuses:true:true} 
                          
                  <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                      <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if} {if $field.label_class}{$field.label_class}{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">
                      {if $show_update_for_all} 
                          <p>{__('text_select_vendor')}</p>
                      {else}                   	                
                         {include file="common/select_popup.tpl"
                               suffix="o"                             
                               id=$field_name
                               status=$options.$field_name
                               items_status=$order_status_descr
                               update_controller="cuo"                           
                               status_target_id="container_elm_`$field_name`"                            
                               statuses=$order_statuses
                               btn_meta="btn btn-info o-status-`$options.$field_name` btn-small"|lower                            
                          }
                      {/if}
                      </div>
                  <!--container_elm_{$field_name}--></div>
                    
            {elseif $field.type == 'textarea'}
                <div class="control-group {if $field.group} grouped hidden {$field.group}{/if} {if $field.show_when}{$prefix}ShowWhen{/if}" id="container_elm_{$field_name}">
                    <label for="elm_{$field_name}" class="control-label{if $field.required} cm-required{/if}">{__("`$prefix`.{$field_name}")}
                        {if $field.tooltip}{include file="common/tooltip.tpl" tooltip=__("`$prefix`.`$field_name`_tooltip")}{/if}:
                    </label>
                    <div class="controls">
                        <textarea {if $field.readonly} readonly{/if} name="{$param_name}[{$field_name}]" id="elm_{$field_name}" {if $field.class}class="{$field.class}"{/if}
                         {if $disable_input} disabled{/if}
                        >{if isset($options.$field_name)}{$options.$field_name}{/if}</textarea>
                       {include file="buttons/update_for_all.tpl" display=$show_update_for_all object_id=$field_name name="update_all_vendors[`$field_name`]" hide_element="elm_`$field_name`"}                          
                    </div>
                     {if $field.description}<p style="clear:both"><i>{$field.description nofilter}</i></p>{/if}
                </div>       
            {/if}
           {if $field.show_when && is_array($field.show_when)}
              {foreach from=$field.show_when item=depend_fields key=root_field}
                  <script>				
                      (function(_, $){
                          $.ceEvent('on', 'ce.commoninit', function(context) {		
                              fn_{$prefix}_check_{$field_name}();
                          });
                      })(Tygh, Tygh.$);                    
                      $(document).on('change', '#elm_{$root_field}', function(){
                          fn_{$prefix}_check_{$field_name}();
                      });	
                      function fn_{$prefix}_check_{$field_name}(){						
                          vals = {$depend_fields|json_encode nofilter};								
                          {if $tab.$root_field.type=="checkbox"}							
                              if ($.inArray($('#elm_{$root_field}:checked').val(), vals) >= 0){
								 if (!$('#container_elm_{$field_name}').is(":visible")){
									$('#container_elm_{$field_name}').show();	
								    $('#container_elm_{$field_name}').find('input').attr('disabled', false); 
								 }                                 
                              }else{
                                 $('#container_elm_{$field_name}').hide();
								 $('#container_elm_{$field_name}').find('input').attr('disabled', true);		
                              }							
                          {else}											
                              vals = {$depend_fields|json_encode nofilter}; 						
                              if ($.inArray($('#elm_{$root_field}').val(), vals) >= 0){
								  if (!$('#container_elm_{$field_name}').is(":visible")){ 
									 $('#container_elm_{$field_name}').show();
									 $('#container_elm_{$field_name}').find('input').attr('disabled', false);
								  }
                              }else{
                                 $('#container_elm_{$field_name}').hide();
								 $('#container_elm_{$field_name}').find('input').attr('disabled', true);		
                              }						
                          {/if}
                      }
                  </script>
              {/foreach}
           {/if}
           {if $field.hide_when}
              {foreach from=$field.hide_when item=depend_fields key=root_field}
                  <script>				
                      (function(_, $){
                          $.ceEvent('on', 'ce.commoninit', function(context) {		
                              fn_{$prefix}_check_hide_{$field_name}();
                          });
                      })(Tygh, Tygh.$);                    
                      $(document).on('change', '#elm_{$root_field}', function(){
                          fn_{$prefix}_check_hide_{$field_name}();
                      });	
                      function fn_{$prefix}_check_hide_{$field_name}(){						
                          vals = {$depend_fields|json_encode nofilter};								
                          {if $tab.$root_field.type=="checkbox"}
						  							
                              if ($.inArray($('#elm_{$root_field}:checked').val(), vals) >= 0 || $.inArray(typeof $('#elm_{$root_field}:checked').val(), vals) >= 0){
                                 $('#container_elm_{$field_name}').hide();	
                              }else{
                                 $('#container_elm_{$field_name}').show();		
                              }							
                          {else}											
                              vals = {$depend_fields|json_encode nofilter}; 						
                              if ($.inArray($('#elm_{$root_field}').val(), vals) >= 0){
                                 $('#container_elm_{$field_name}').hide();	
                              }else{
                                 $('#container_elm_{$field_name}').show();		
                              }						
                          {/if}
                      }
                  </script>
              {/foreach}
           {/if}
           
           
        {/foreach}
    </div>
{/foreach}
  
<script>
	(function(_, $){
		$.ceEvent('on', 'ce.commoninit', function(context) {		
			$(context).find('input.cmcs-colorpicker:enabled').ceColorpicker();
		});
	})(Tygh, Tygh.$);
	
	$(document).on('click', '.cmcs-colorpicker-wrapper .cm-update-for-all-icon:not(.visible)', function(){
		try {			
			setTimeout(function(elm){
				$(elm).closest('.cmcs-colorpicker-wrapper').find('input.cmcs-colorpicker:enabled').ceColorpicker();			
			}, 100, $(this));
			
		}catch(err){
		}		
	});
	$(document).on('click', '.cmcs-colorpicker-wrapper .cm-update-for-all-icon.visible', function(){
		try {			
			$(this).closest('.cmcs-colorpicker-wrapper').find('input.cmcs-colorpicker').ceColorpicker('destroy').attr('disabled', true);
		}catch(err){
		}		
	});
	$(document).on('click', '.cm-update-for-all-icon', function(){		
		if ($(this).data('caHideId')) {
			setTimeout(function(jelm){
				var parent_elm = $('#container_' + jelm.data('caHideId'));
			    parent_elm.find('select').prop('disabled', !jelm.hasClass('visible'));			
			}, 100, $(this));
			   
		  }
	});
	
	
</script>