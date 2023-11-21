{strip}
{if $but_role == "action"}
	{assign var="suffix" value="-action"}
	{assign var="file_prefix" value="action_"}
{elseif $but_role == "act"}
	{assign var="suffix" value="-act"}
	{assign var="file_prefix" value="action_"}
{elseif $but_role == "disabled_big"}
	{assign var="suffix" value="-disabled-big"}
{elseif $but_role == "big"}
	{assign var="suffix" value="-big"}
{elseif $but_role == "delete"}
	{assign var="suffix" value="-delete"}
{elseif $but_role == "tool"}
	{assign var="suffix" value="-tool"}
{else}
	{assign var="suffix" value=""}
{/if}

{if $but_name && $but_role != "text" && $but_role != "act" && $but_role != "delete" && $but_role != "et_icon" && $but_role != "et_icon_text" && $but_role != "et_icon_text_button" && $but_role != "et_icon_popup" && $but_role != "et_btn_popup" && $but_role != "et_icon_text_no_btn" && $but_role != "et_review_thumbs"}{* SUBMIT BUTTON *}
	<button {if $but_id}id="{$but_id}"{/if} class="{$but_meta} ty-btn" type="submit" name="{$but_name}" {if $but_onclick}onclick="{$but_onclick nofilter}"{/if}{if $but_title} title="{$but_title}"{/if}>{$but_text}</button>

{elseif $but_role == "text" || $but_role == "act" || $but_role == "edit"}{* TEXT STYLE *}
	<a {$but_extra} class="ty-btn {if $but_meta}{$but_meta} {/if}{if $but_name}cm-submit {/if}text-button{$suffix} {if $but_scroll}cm-scroll {/if}"{if $but_id} id="{$but_id}"{/if}{if $but_name} data-ca-dispatch="{$but_name}"{/if}{if $but_href} href="{$but_href|fn_url}"{/if}{if $but_scroll} data-ca-scroll="{$but_scroll}"{/if}{if $but_onclick} onclick="{$but_onclick nofilter} return false;"{/if}{if $but_target} target="{$but_target}"{/if}{if $but_rel} rel="{$but_rel}"{/if}{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if}{if $but_title} title="{$but_title}"{/if}>{include_ext file="common/icon.tpl" class=$but_icon}{$but_text}</a>

{elseif $but_role == "delete"}

	<a {$but_extra} {if $but_id}id="{$but_id}"{/if}{if $but_name} data-ca-dispatch="{$but_name}"{/if} {if $but_href}href="{$but_href|fn_url}"{/if}{if $but_onclick} onclick="{$but_onclick nofilter} return false;"{/if}{if $but_meta} class="{$but_meta}"{/if}{if $but_target} target="{$but_target}"{/if}{if $but_rel} rel="{$but_rel}"{/if}{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if}{if $but_title} title="{$but_title}"{/if}><i title="{__("remove")}" class="ty-icon-cancel-circle"></i></a>

{elseif $but_role == "icon"}{* LINK WITH ICON *}
	<a {$but_extra} {if $but_id}id="{$but_id}"{/if}{if $but_href} href="{$but_href|fn_url}"{/if} {if $but_onclick}onclick="{$but_onclick nofilter};{if !$allow_href} return false;{/if}"{/if} {if $but_target}target="{$but_target}"{/if} {if $but_rel} rel="{$but_rel}"{/if}{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if} class="ty-btn {if $but_meta}{$but_meta}{/if}"{if $but_title} title="{$but_title}"{/if}>{$but_text}</a>
{elseif $but_role == "et_icon"}{* ET ICON STYLE *}
	{if $smarty.const.ET_DEVICE=="D"}
		{$class="et-button $but_extra_class"}
	{else}
		{$class="et-button $but_extra_class"}
	{/if}
	{if $but_meta}
		{$class="$class $but_meta"}
	{/if}
	{if $but_name}
		{$class="$class cm-submit"}
	{/if}
	<a {$but_extra} 
		class="{$class}"
		{if $but_id} id="{$but_id}"{/if}
		{if $but_name} data-ca-dispatch="{$but_name}"{/if}
		{if $but_href} href="{$but_href|fn_url}"{/if}
		{if $but_onclick} onclick="{$but_onclick} return false;"{/if}
		{if $but_target} target="{$but_target}"{/if}
		{if $but_rel} rel="{$but_rel}"{/if}
		{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}
		{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}
		{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if} title="{$but_text}">
			<i class="{$et_icon}"></i>
	</a>
{elseif $but_role == "et_icon_text"}{* ET ICON STYLE *}
	<a {$but_extra} class="ty-btn {if $but_meta}{$but_meta} {/if}{if $but_name}cm-submit {/if}text-button{$suffix} et-btn-icon-text {$but_extra_class}"
	{if $but_id} id="{$but_id}"{/if}
	{if $but_name} data-ca-dispatch="{$but_name}"{/if}
	{if $but_href} href="{$but_href|fn_url}"{/if}
	{if $but_onclick} onclick="{$but_onclick} return false;"{/if}
	{if $but_target} target="{$but_target}"{/if}
	{if $but_rel} rel="{$but_rel}"{/if}
	{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}
	{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}
	{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if}
	{if $but_title} title="{$but_title}"{/if}>
		{$but_prefix nofilter}<i class="{$et_icon}"></i><span>{$but_text}</span>
	</a>
{elseif $but_role == "et_icon_text_button"}{* ET ICON STYLE *}
	<a {$but_extra} class="ty-btn {if $but_meta}{$but_meta} {/if}{if $but_name}cm-submit {/if}text-button{$suffix} et-btn-icon-text {$but_extra_class}"
	{if $but_id} id="{$but_id}"{/if}
	{if $but_name} data-ca-dispatch="{$but_name}"{/if}
	{if $but_href} href="{$but_href|fn_url}"{/if}
	{if $but_onclick} onclick="{$but_onclick} return false;"{/if}
	{if $but_target} target="{$but_target}"{/if}
	{if $but_rel} rel="{$but_rel}"{/if}
	{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}
	{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}
	{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if}
	{if $but_title} title="{$but_title}"{/if}
	type="submit">
		{$but_prefix nofilter}<i class="{$et_icon}"></i><span>{$but_text}</span>
	</a>
{elseif $but_role == "et_icon_text_no_btn"}{* ET ICON STYLE *}
	<a {$but_extra} class="{if $but_meta}{$but_meta} {/if}{if $but_name}cm-submit {/if}text-button{$suffix} et-btn-icon-text {$but_extra_class}"
	{if $but_id} id="{$but_id}"{/if}
	{if $but_name} data-ca-dispatch="{$but_name}"{/if}
	{if $but_href} href="{$but_href|fn_url}"{/if}
	{if $but_onclick} onclick="{$but_onclick} return false;"{/if}
	{if $but_target} target="{$but_target}"{/if}
	{if $but_rel} rel="{$but_rel}"{/if}
	{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}
	{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}
	{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if}>
		<i class="{$et_icon}"></i><span>{$but_text}</span>
	</a>
{elseif $but_role == "et_icon_popup"}
	<a id="opener_{$but_id}" class="cm-dialog-opener cm-dialog-auto-size cm-tooltip et-button {$but_extra_class}" 
		{if $but_href} href="{$but_href|fn_url}"{/if} data-ca-target-id="content_{$but_id}" rel="nofollow" data-ca-dialog-title="{$but_text}" title="{$but_text}">
			<i class="{$et_icon}"></i>
	</a>
	{if $et_btn_content}
		<div class="hidden{if $wysiwyg} ty-wysiwyg-content{/if}" id="content_{$id}" title="{$text}">
			{$et_btn_content nofilter}
		</div>
	{/if}
{elseif $but_role == "et_btn_popup"}
	<a id="opener_{$but_id}" 
		class="cm-dialog-opener cm-dialog-auto-size cm-tooltip et-button {$but_extra_class}" 
		{if $but_href}href="{$but_href|fn_url}"{/if} 
		data-ca-target-id="content_{$but_id}" 
		rel="nofollow" >
			<i class="{$et_icon}"></i>{if $but_text}{$but_text}{/if}
	</a>
	{if $et_btn_content||$text}
		<div class="hidden{if $wysiwyg} ty-wysiwyg-content{/if}" id="content_{$id}" title="{$text}">
			{$et_btn_content nofilter}
		</div>
	{/if}
{elseif $but_role == "et_review_thumbs"}
	<a {if $but_href}href="{$but_href|fn_url}"{/if}{if $but_onclick} onclick="{$but_onclick nofilter} return false;"{/if} {if $but_target}target="{$but_target}"{/if} class="ty-btn {if $but_meta}{$but_meta} {/if}" {if $but_rel} rel="{$but_rel}"{/if}{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if}{if $but_title} title="{$but_title}"{/if}>{if $but_icon}<i class="{$but_icon}"></i>{/if}<span class="et-review-thumb-text">({$but_text})</span></a>	
{else}{* BUTTON STYLE *}
	<a {if $but_href}href="{$but_href|fn_url}"{/if}{if $but_onclick} onclick="{$but_onclick nofilter} return false;"{/if} {if $but_target}target="{$but_target}"{/if} class="ty-btn {if $but_meta}{$but_meta} {/if}" {if $but_rel} rel="{$but_rel}"{/if}{if $but_external_click_id} data-ca-external-click-id="{$but_external_click_id}"{/if}{if $but_target_form} data-ca-target-form="{$but_target_form}"{/if}{if $but_target_id} data-ca-target-id="{$but_target_id}"{/if}{if $but_title} title="{$but_title}"{/if}>{include_ext file="common/icon.tpl" class=$but_icon}{$but_text}</a>
{/if}
{/strip}
