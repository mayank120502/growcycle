<div id="login_methods">
    {if $addons.sd_fast_auth.display_mode_reg == "top_form_reg"
        || $runtime.mode == "update"
    }
        {include
            file="addons/sd_fast_auth/views/profiles/components/login_pass.tpl"
            btn=false
            show_social=true
            login_position=top
        }
    {elseif $addons.sd_fast_auth.display_mode_reg == "bottom_form_reg"}
        {include
            file="addons/sd_fast_auth/views/profiles/components/login_pass.tpl"
            btn=false
            show_social=true
            login_position=bottom
        }
    {elseif $addons.sd_fast_auth.display_mode_reg == "link_reg"}
        {include
            file="addons/sd_fast_auth/views/profiles/components/social_login.tpl"
            hidden=true
        }
        {include
            file="addons/sd_fast_auth/views/profiles/components/login_pass.tpl"
            hidden=true
        }
    {elseif $addons.sd_fast_auth.display_mode_reg == "btn_reg"}
        {include
            file="addons/sd_fast_auth/views/profiles/components/social_login.tpl"
            btn=true
            hidden=true
        }
        {include
            file="addons/sd_fast_auth/views/profiles/components/login_pass.tpl"
            btn=true
            hidden=true
        }
    {/if}
</div>
