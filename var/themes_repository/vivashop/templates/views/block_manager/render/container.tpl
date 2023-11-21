{if call_user_func(base64_decode("ZnVuY3Rpb25fZXhpc3Rz"),base64_decode("Zm5fZW5lcmdvdGhlbWVzX2xpY2Vuc2VfY2hlY2tfdmFsaWQ="))}
{hook name="block_manager:frontend_container"}
    {if $runtime.customization_mode.block_manager && $location_data.is_frontend_editing_allowed}
        {include file="backend:views/block_manager/frontend_render/container.tpl"}
    {else}
        <div class="{if $layout_data.layout_width != "fixed"}container-fluid {else}container{/if} {$container.user_class}">
            {$content nofilter}
        </div>
    {/if}
{/hook}
{/if}