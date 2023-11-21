<div id="login_methods">
    {if $addons.sd_fast_auth.display_mode == "link"}
        {include
            file="addons/sd_fast_auth/views/auth/components/social_login.tpl"
            hidden=true
        }
        {include
            file="addons/sd_fast_auth/views/auth/components/login_pass.tpl"
            hidden=true
        }
    {elseif $addons.sd_fast_auth.display_mode == "btn"}
        {include
            file="addons/sd_fast_auth/views/auth/components/social_login.tpl"
            btn=true
            hidden=true
        }
        {include
            file="addons/sd_fast_auth/views/auth/components/login_pass.tpl"
            btn=true
            hidden=true
        }
    {elseif $addons.sd_fast_auth.display_mode == "top_form"}
        {include
            file="addons/sd_fast_auth/views/auth/components/login_pass.tpl"
            btn=false
            show_social=true
            login_position=top
        }
    {elseif $addons.sd_fast_auth.display_mode == "bottom_form"}
        {include
            file="addons/sd_fast_auth/views/auth/components/login_pass.tpl"
            btn=false
            show_social=true
            login_position=bottom
        }
    {/if}
</div>
