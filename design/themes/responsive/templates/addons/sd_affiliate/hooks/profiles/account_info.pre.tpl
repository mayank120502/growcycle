{if !$user_data|fn_check_user_type_admin_area}
    {assign var="u_type" value=$smarty.request.user_type|default:$user_data.user_type}
    {if $runtime.controller != 'checkout'}
        <div class="ty-control-group">
            <label for="user_type" class="ty-control-group__title">{__("account_type")}</label>
            <select id="user_type" name="user_data[user_type]" onchange="Tygh.$.redirect('{"`$runtime.controller`.`$runtime.mode`?user_type="|fn_url}' + this.value);">
                <option value={'AffiliateUserTypes::CUSTOMER'|enum} {if $u_type == 'AffiliateUserTypes::CUSTOMER'|enum}selected="selected"{/if}>{__("customer")}</option>
                {if $addons.sd_affiliate.allow_all_customers_be_affiliates == "Y" || $u_type == 'AffiliateUserTypes::PARTNER'|enum}
                    <option value={'AffiliateUserTypes::PARTNER'|enum} {if $u_type == 'AffiliateUserTypes::PARTNER'|enum}selected="selected"{/if}>{__("affiliate")}</option>
                {/if}
            </select>
        </div>
        {if $u_type == 'AffiliateUserTypes::PARTNER'|enum && $user_data.user_type == 'AffiliateUserTypes::PARTNER'|enum}
            <p>{__('addons.sd_affiliate.note_awaiting_commissions_will_be_lost')}</p>
        {/if}
    {/if}

    {if $u_type == 'AffiliateUserTypes::PARTNER'|enum && $u_type != $user_data.user_type}
        {if $runtime.mode == "add"}{assign var="_but" value=__("register")}{else}{assign var="_but" value=__("save")}{/if}
        <p id="id_affiliate_agree_notification">{__("affiliate_agree_to_terms_conditions", ["[button_name]" => $_but])}</p>
    {/if}
{/if}
