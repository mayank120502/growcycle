{styles use_scheme=true reflect_less=$reflect_less}
{hook name="index:styles"}

    {style src="styles.less"}
    {style src="tygh/supports.css"}
    {style src="tygh/responsive.less"}
    {style src="lib/select2/select2.min.css"}

    {if $language_direction == 'rtl'}
        {style src="tygh/rtl.less"}
    {/if}

    {style src="et.less"}
    
    {if $addons.et_vivashop_settings.et_viva_responsive=="traditional"}
        {style src="et-traditional-responsive.less"}
    {/if}
    
    {* Translation and on-site template editing mods *}
    {if $runtime.customization_mode.live_editor || $runtime.customization_mode.design}
        {style src="tygh/design_mode.css"}
    {/if}

    {* Translation mode *}
    {if $runtime.customization_mode.live_editor}
        {style src="tygh/wysiwyg.less"}
    {/if}
    

    {* Theme editor mode *}
    {if $runtime.customization_mode.theme_editor}
        {style src="tygh/theme_editor.css"}
    {/if}

    {* Block manager mode *}
    {if $runtime.customization_mode.block_manager}
        {style src="tygh/components/block_manager.less"}
    {/if}
{/hook}
{/styles}
