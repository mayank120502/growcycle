{hook name="profiles:my_account_menu"}
    {if $auth.user_id}
        {if $user_info.firstname || $user_info.lastname}
            {assign var="login_info" value="`$user_info.firstname` `$user_info.lastname`"}
        {elseif $user_info.phone}
            {assign var="login_info" value=$user_info.phone}
        {else}
            {assign var="login_info" value=$user_info.email}
        {/if}
        <li class="ty-account-info__item ty-dropdown-box__item ty-account-info__name">{$login_info}</li>
        <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"profiles.update"|fn_url}" rel="nofollow" >{__("profile_details")}</a></li>
        {if $settings.General.enable_edp == "Y"}
        <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"orders.downloads"|fn_url}" rel="nofollow">{__("downloads")}</a></li>
        {/if}
    {elseif $user_data.firstname || $user_data.lastname}
        <li class="ty-account-info__item  ty-dropdown-box__item ty-account-info__name">{$user_data.firstname} {$user_data.lastname}</li>
    {elseif $user_info.phone}
        <li class="ty-account-info__item ty-dropdown-box__item ty-account-info__name">+{$user_info.phone}</li>
    {elseif $user_data.email}
        <li class="ty-account-info__item ty-dropdown-box__item ty-account-info__name">{$user_data.email}</li>
    {/if}
    <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"orders.search"|fn_url}" rel="nofollow">{__("orders")}</a></li>
    {if $settings.General.enable_compare_products == 'Y'}
        {assign var="compared_products" value=""|fn_get_comparison_products}
        <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"product_features.compare"|fn_url}" rel="nofollow">{__("view_comparison_list")}{if $compared_products} ({$compared_products|count}){/if}</a></li>
    {/if}
{/hook}