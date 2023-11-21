{$login_type = $addons.cp_otp_registration.login_type|default:"password"}

<div class="ty-control-group">
    <label for="email" class="ty-control-group__title cm-email cm-required cm-trim {if $email_required}cm-required{/if}">{__("email")}</label>
    <input type="text" id="email" x-autocompletetype="email" name="user_data[email]" size="32" maxlength="128" value="{$user_data.email}" class="ty-input-text cm-focus" />
</div>

{include file="addons/cp_otp_registration/components/phone.tpl" obj_id=$obj_id}

{if $login_type != "otp"}
    <div class="ty-control-group">
        <label for="password1" class="ty-control-group__title cm-required cm-password">{__("password")}</label>
        <input type="password" id="password1" name="user_data[password1]" size="32" maxlength="32" value="{if $runtime.mode == "update"}            {/if}" class="ty-input-text cm-autocomplete-off" />
    </div>

    <div class="ty-control-group">
        <label for="password2" class="ty-control-group__title cm-required cm-password">{__("confirm_password")}</label>
        <input type="password" id="password2" name="user_data[password2]" size="32" maxlength="32" value="{if $runtime.mode == "update"}            {/if}" class="ty-input-text cm-autocomplete-off" />
    </div>
{/if}

{$email_required = false}
{if $addons.step_by_step_checkout.status == "A"
    && $runtime.controller == "checkout" && $runtime.mode == "checkout"
}
    {$email_required = true}
{/if}
{if $addons.cp_otp_registration.required_email == "Y"}
    {$email_required = true}
{/if}

