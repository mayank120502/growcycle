{foreach from = $submenu item="ssmenu" key="head"}
<div class="sidebar-row clsMenu" id="views">
  <h6>{__($head)}</h6>

      <ul class="nav nav-list saved-search">             
          {foreach from=$ssmenu item=smenu key='name'}                         
              <li {if $smenu.dispatch == "`$runtime.controller`.`$runtime.mode`"}class="active"{/if}>                   
                  <a class="cm-view-name" href="{$smenu.dispatch|fn_url}">{__($name)}</a>
              </li>
              {if $smenu.subitems && $smenu.dispatch == "`$runtime.controller`.`$runtime.mode`"}              
              	{foreach from=$smenu.subitems item=_smenu key='_name'}
                	<li class="subitem {if $_smenu.dispatch == $smarty.request.dispatch}active{/if}">                   
                      <a class="cm-view-name" href="{$_smenu.dispatch|fn_url}">{__($_name)}</a>
                  </li>
                
              	{/foreach}
               {/if}    
          {/foreach}          
      </ul>
</div>
{/foreach} 