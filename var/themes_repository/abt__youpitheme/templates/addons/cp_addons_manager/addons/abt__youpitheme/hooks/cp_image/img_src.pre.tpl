{$lazy_load = ($settings.abt__yt.general.use_lazy_load_for_images == "Y") && $lazy_load|default:true scope=parent}
{if $lazy_load && $smarty.const.ABT__YP_LAZY_IMAGE}src="{$smarty.const.ABT__YP_LAZY_IMAGE}" {/if}
