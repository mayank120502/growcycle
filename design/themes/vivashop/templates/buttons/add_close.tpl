{if $is_js == true}
	{include file="buttons/button.tpl" but_name="submit" but_text=$but_close_text but_onclick=$but_close_onclick but_role="button_main" but_meta="ty-btn__tertiary cm-process-items cm-dialog-closer"}
	{if $but_text}
		{include file="buttons/button.tpl" but_name="submit" but_text=$but_text but_onclick=$but_onclick but_role="submit" but_meta="ty-btn__primary cm-process-items"}
	{/if}
{else}
	{include file="buttons/button.tpl" but_name="submit" but_text=$but_close_text but_role="button_main" but_meta="cm-process-items"}
{/if}
<span class="ty-close-text"><a class="cm-dialog-closer ty-btn ty-float-right">{__("cancel")}</a></span>