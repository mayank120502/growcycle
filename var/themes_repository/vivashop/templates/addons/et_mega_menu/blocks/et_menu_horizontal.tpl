{$item1_url=true}
{$name="item"}
{$item_id="param_id"} 
{$childs="subitems"}

<div class="et-main-menu">
	{if $items}
	  <ul class="ty-menu__items cm-responsive-menu">
	    {foreach from=$items item="item1" name="item1"}
	      {assign var="item1_url" value=$item1|fn_form_dropdown_object_link:$block.type}
	      {assign var="unique_elm_id" value=$item1_url|md5}
	      {assign var="unique_elm_id" value="topmenu_`$block.block_id`_`$unique_elm_id`"}
	      {$et_menu=$item1.et_menu}
	                          
	      <li class="ty-menu__item{if !$item1.$childs} ty-menu__item-nodrop{else} cm-menu-item-responsive{/if}{if $item1.active || $item1|fn_check_is_active_menu_item:$block.type} ty-menu__item-active{/if}{if $item1.class} {$item1.class}{/if} {if $smarty.foreach.item1.first}et-menu-first-item{/if} et-main-menu-lev-1">
	        {if $item1.$childs}
	          <a class="ty-menu__item-toggle visible-phone visible-tablet cm-responsive-menu-toggle">
	              <i class="ty-menu__icon-open et-icon-circle-plus"></i>
	              <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
	          </a>
	        {/if}

	        {* ICON *}
	        {capture name="et_icon" assign="et_icon"}{strip}
	          {if $et_menu.icon.enabled == "Y" && $et_menu.icon.value}
	            <i class="{$et_menu.icon.value} et_menu_icon et_menu_icon_{$block.block_id}_{$et_menu.et_menu_id}"></i>
	          {/if}
	        {/strip}{/capture}

	        {* LABEL *}
	        {capture name="et_title_label" assign="et_title_label"}{strip}
	          {if isset($et_menu.text) && $et_menu.text.enabled == "Y" && $et_menu.text.value}
	            <span class="et_menu_label et_menu_text_{$et_menu.et_menu_id}" {if $et_menu.text.color_type|default:"S"=="C"} style="color: {$et_menu.text.color};
	              background: {$et_menu.text.bkg};"{/if}>{$et_menu.text.value}</span>
	          {/if}
	        {/strip}{/capture}

	        {if isset($et_menu)}
	          <a {if $item1_url} href="{$item1_url}"{/if} class="ty-menu__item-link clearfix et_menu_color_{$et_menu.et_menu_id} {if $et_icon|trim}et_menu_with_icon{/if} {if $et_menu.color.enabled|default:"N" == "Y" && $et_menu.color.color_type|default:"S"=="S"}et_use_style_color{/if}" {if $item1.new_window}target="_blank"{/if}>{strip}
	            {if $et_icon|trim}{$et_icon nofilter}{/if}
	            <span class="et_menu_title">{$item1.$name}</span>
	            {if $et_title_label|trim}{$et_title_label nofilter}{/if}
	          {/strip}</a>
	          <style>
	            {if $et_menu.color.color_type|default:"S"=="C"}
	            	{if $et_menu.color.enabled == "Y"}
		    	        .et-main-menu>.ty-menu__items>.ty-menu__item .ty-menu__item-link.et_menu_color_{$et_menu.et_menu_id}{
		    	          background: {$item1.et_menu.color.bkg};
		    	        }
		    	        .et-main-menu>.ty-menu__items>.ty-menu__item .ty-menu__item-link.et_menu_color_{$et_menu.et_menu_id} .et_menu_title,
		    	        .et-main-menu>.ty-menu__items>.ty-menu__item .ty-menu__item-link.et_menu_color_{$et_menu.et_menu_id} .et_menu_icon{
		    	        	color: {$item1.et_menu.color.color};
		    	        }
		    	      {else}
			    	      .et-main-menu>.ty-menu__items>.ty-menu__item .ty-menu__item-link.et_menu_color_{$et_menu.et_menu_id}{
			    	        background: inherit;
			    	      }
			    	      .et-main-menu>.ty-menu__items>.ty-menu__item .ty-menu__item-link.et_menu_color_{$et_menu.et_menu_id} .et_menu_title,
			    	      .et-main-menu>.ty-menu__items>.ty-menu__item .ty-menu__item-link.et_menu_color_{$et_menu.et_menu_id} .et_menu_icon{
			    	      	color: inherit;
			    	      }
		    	      {/if}
	            {/if}
	            
	            {if $et_menu.icon.enabled == "Y" && $et_menu.icon.color_type|default:"S"=="C"}
	    	        .et-main-menu>.ty-menu__items>.ty-menu__item .ty-menu__item-link.et_menu_color_{$et_menu.et_menu_id} .et_menu_icon_{$block.block_id}_{$et_menu.et_menu_id}{
	    	          color: {$item1.et_menu.icon.color};
	    	        }
	    	     	{/if}
	          </style>
	        {else}
	          <a {if $item1_url} href="{$item1_url}"{/if} class="ty-menu__item-link" {if $item1.new_window}target="_blank"{/if}><span class="et_menu_title">{$item1.$name}</span></a>
	        {/if}

	        {if $item1.$childs}
	          {if !$item1.$childs|fn_check_second_level_child_array:$childs}
	          {* Only two levels. Vertical output *}
	            <div class="ty-menu__submenu">
	    	        <ul class="ty-menu__submenu-items ty-menu__submenu-items-simple cm-responsive-menu-submenu">
	                {hook name="blocks:topmenu_dropdown_2levels_elements"}
	    	            {foreach from=$item1.$childs item="item2" name="item2"}
	                    {assign var="item_url2" value=$item2|fn_form_dropdown_object_link:$block.type}
	                    <li class="ty-menu__submenu-item{if $item2.active || $item2|fn_check_is_active_menu_item:$block.type} ty-menu__submenu-item-active{/if}{if $item2.class} {$item2.class}{/if}">
	                        <a class="ty-menu__submenu-link" {if $item_url2} href="{$item_url2}"{/if} {if $item2.new_window}target="_blank"{/if}>{$item2.$name}</a>
	                    </li>
	    	            {/foreach}
	    	            {if $item1.show_more && $item1_url}
	                    <li class="ty-menu__submenu-item ty-menu__submenu-alt-link">
	                      <a href="{$item1_url}" class="ty-menu__submenu-alt-link">{__("text_topmenu_view_more")}</a>
	    	              </li>
	                  {/if}
	                {/hook}
	    	        </ul>
	            </div>
	          {else}
	    	      <div class="ty-menu__submenu" id="{$unique_elm_id}">
	              {hook name="blocks:topmenu_dropdown_3levels_cols"}
	                <ul class="ty-menu__submenu-items cm-responsive-menu-submenu">
	                  {foreach from=$item1.$childs item="item2" name="item2"}
	                    <li class="ty-top-mine__submenu-col">
	                      {assign var="item2_url" value=$item2|fn_form_dropdown_object_link:$block.type}

	                      <div class="ty-menu__submenu-item-header{if $item2.active || $item2|fn_check_is_active_menu_item:$block.type} ty-menu__submenu-item-header-active{/if}{if $item2.class} {$item2.class}{/if}">
	                        <a{if $item2_url} href="{$item2_url}"{/if} class="ty-menu__submenu-link" {if $item2.new_window}target="_blank"{/if}>{$item2.$name}</a>
	                      </div>

	                      {if $item2.$childs}
	                        <a class="ty-menu__item-toggle visible-phone cm-responsive-menu-toggle">
	                          <i class="ty-menu__icon-open et-icon-circle-plus"></i>
	                          <i class="ty-menu__icon-hide et-icon-circle-minus"></i>
	                        </a>
	                      {/if}
	    	                <div class="ty-menu__submenu">
	                        <ul class="ty-menu__submenu-list cm-responsive-menu-submenu">
	                          {if $item2.$childs}
	    	                      {hook name="blocks:topmenu_dropdown_3levels_col_elements"}
	    	                        {foreach from=$item2.$childs item="item3" name="item3"}
	    	                          {assign var="item3_url" value=$item3|fn_form_dropdown_object_link:$block.type}
	    	                          
	    	                          <li class="ty-menu__submenu-item{if $item3.active || $item3|fn_check_is_active_menu_item:$block.type} ty-menu__submenu-item-active{/if}{if $item3.class} {$item3.class}{/if}">
	    	                            <a{if $item3_url} href="{$item3_url}"{/if} class="ty-menu__submenu-link" {if $item3.new_window}target="_blank"{/if}>{$item3.$name}</a>
	    	                          </li>
	    	                      	{/foreach}
	    	                      	{if $item2.show_more && $item2_url}
	    	                          <li class="ty-menu__submenu-item ty-menu__submenu-alt-link">
	    	                            <a href="{$item2_url}" class="ty-menu__submenu-link" {if $item2.new_window}target="_blank"{/if}>{__("text_topmenu_view_more")}</a>
	    	                          </li>
	    	                        {/if}
	    	                      {/hook}
	                      		{/if}
	                        </ul>
	    	                </div>
	                    </li>
	                  {/foreach}
	                  {if $item1.show_more && $item1_url}
	                    <li class="ty-menu__submenu-dropdown-bottom">
	                      <a href="{$item1_url}" {if $item1.new_window}target="_blank"{/if}>{__("text_topmenu_more", ["[item]" => $item1.$name])}</a>
	                    </li>
	                  {/if}
	                </ul>
	           		{/hook}
	            </div>
	          {/if}
	        {/if}
	      </li>
	    {/foreach}
	    </ul>
	{/if}
</div>