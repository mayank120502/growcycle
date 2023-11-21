{include file="addons/sd_affiliate/common/affiliate_menu.tpl"}

{capture name="tabsbox"}

{if $banner_type != 'BannerTypes::PRODUCTS'|enum}
    <div id="content_groups">
        {include file="addons/sd_affiliate/views/banners_manager/components/banners_list.tpl" prefix=groups}
    <!--content_groups--></div>

    <div id="content_categories">
        {include file="addons/sd_affiliate/views/banners_manager/components/banners_list.tpl" prefix=categories}
    <!--content_categories--></div>

    <div id="content_products">
        {include file="addons/sd_affiliate/views/banners_manager/components/banners_list.tpl" prefix=products}
    <!--content_products--></div>

    <div id="content_url">
        {include file="addons/sd_affiliate/views/banners_manager/components/banners_list.tpl" prefix=url}
    <!--content_url--></div>
{else}
    <div id="content_url">
        {include file="addons/sd_affiliate/views/banners_manager/components/banners_list.tpl" prefix=url}
    <!--content_url--></div>
{/if}

{/capture}

{include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$selected_section}

{capture name="mainbox_title"}
    {__(affiliates_partnership)} <span class="subtitle">/ {$mainbox_title}</span>
{/capture}