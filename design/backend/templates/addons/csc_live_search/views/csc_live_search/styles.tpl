{capture name="mainbox"}
      <div class="span6">
          <form action="{""|fn_url}" method="post" name="settings_form" class="form-horizontal form-edit cm-check-changes {if fn_check_form_permissions("")}cm-hide-inputs{/if}" enctype="multipart/form-data">
            <input type="hidden" name="selected_section">
            <input type="hidden" name="return_url"value="{$config.current_url}">
            <input type="hidden" name="redirect_url"value="{$config.current_url}">
        
            {if $allow_separate_storefronts && !$runtime.company_id}
               {assign var="disable_input" value=true}
               {assign var="show_update_for_all" value=true}          
            {/if}
            {if $fields}            	
                {include file="addons/`$addon_base_name`/components/options.tpl" param_name="settings" _params=$fields prefix=$lp}       
            {else}
                <p class="no-items">{__("no_data")}</p>       
            {/if}
        </form>
    </div>
    
     <div class="span6">
    	<div class="live_search_preview" id="clsPreview_tpl">
            <div class="clsActive">
                <div class="clsCss">
                    <div>
                        <ul>
                            <li class="clsGrayHeader">{__("cls.total_found")}: 18</li>
                            <li class="clsCloser"></li>
                            <li class="clsTitle">{__("cls.browse_products_by_category")} <strong>"play"</strong>:</li>
                            <li class="clsUnChecked" onClick="$(this).toggleClass('clsUnChecked clsChecked')">{__("cls.play_check1")}</li>
                            <li class="clsUnChecked" onClick="$(this).toggleClass('clsUnChecked clsChecked')">{__("cls.play_check2")}</li>
                            <li class="clsUnChecked" onClick="$(this).toggleClass('clsUnChecked clsChecked')">{__("cls.play_check3")}</li>
                            <li class="clsTitle">{__("cls.found_categories")}</li>
                            <li class="clsTree">{__("cls.play_category")}</li>
                            <li class="clsTitle">{__("cls.found_products")}</li>
                            <li pid="4">
                                <img src="https://s3.eu-central-1.amazonaws.com/cs-commerce.com/csc_live_search/psp.png">
                                <div class="clsItemData">
                                    <div class="clsProduct">{__("cls.play_product")}</div>
                                    <div class="clsFlex">
                                        <div class="clsArt">{__("cls.product_code")}psp563</div>                                        
                                        <span class="clsLabel">{__("cls.play_check1")}</span>
                                    </div>
                                    <div class="clsFlexReverse">
                                        <a type="cartAdd" state="0"></a>
                                        <a type="wishAdd" state="0"></a>
                                        <a type="compAdd" state="0"></a>
                                        <a type="viewAdd"></a>
                                        <div class="clsPrices">
                                            <div class="clsListPrice"></div>
                                            <div class="clsPrice">510$</div>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li pid="5">
                                <img src="https://s3.eu-central-1.amazonaws.com/cs-commerce.com/csc_live_search/xbox.jpg">
                                <div class="clsItemData">
                                    <div class="clsProduct">{__("cls.play_product2")}</div>
                                    <div class="clsFlex">
                                        <div class="clsArt">{__("cls.product_code")}xbx360</div>
                                        <span class="clsLabel">{__("cls.play_check1")}</span>
                                    </div>
                                    <div class="clsFlexReverse">
                                        <a type="cartAdd" state="0"></a>
                                        <a type="wishAdd" state="0"></a>
                                        <a type="compAdd" state="0"></a>
                                        <a type="viewAdd"></a>
                                        <div class="clsPrices">
                                            <div class="clsListPrice"></div>
                                            <div class="clsPrice">520$</div>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li class="clsSm">
                                <span>{__("cls.show_more")}</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>        
                    
            <div class="clsActive">
                <div class="clsCss">
                    <div>
                        <ul>
                            <li>{__("cls.nothing_found", ['[q]'=>'flayer'])}</li>
                            <li class="clsCloser"></li>
                            <li class="clsTitle light">{__("cls.porpose_correction")}</li>
                            <li class="clsChoice">player</li>
                            <li class="clsChoice">playset</li>
                            <li class="clsChoice">played</li>
                        </ul>
                    </div>
                </div>
            </div>
            
        <!--clsPreview_tpl--></div>
    
    </div>
        
    {capture name="buttons"}    	
        {dropdown content=$smarty.capture.tools_list}    
    	{if $fields}
       		{include file="buttons/save.tpl" but_name="dispatch[`$addon_base_name`.settings]" but_role="submit-link" but_target_form="settings_form"}
        {/if}      
    {/capture}
{/capture}

{capture name="sidebar"}
	{include file="addons/`$addon_base_name`/components/submenu.tpl"}
    
    {include file="addons/`$addon_base_name`/components/reviews.tpl" addon=$addon_base_name prefix=$lp}      
{/capture}


{include file="common/mainbox.tpl" title=__("`$lp`.`$runtime.mode`") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons  content_id="`$addon_base_name`_`$runtime.mode`" mainbox_content_wrapper_class="csc-settings" sidebar=$smarty.capture.sidebar select_languages=$select_languages}


