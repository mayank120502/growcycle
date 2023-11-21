{** block-description:et_banners **}

<div class="et-banner-block-wrapper">
  {foreach from=$items item="banner" key="key"}{strip}
    <div class="et-banner-block-image">
      {if $banner.url != ""}<a href="{$banner.url|fn_url}" class="" {if $banner.target == "B"}target="_blank"{/if}>{/if}
            <div style="max-height: {$banner.main_pair.icon.image_y}px; overflow: hidden;" class="et-main-banner-img">
              {include file="common/image.tpl" images=$banner.main_pair et_lazy_mobile=true}
            </div>
          {if $banner.url != ""}</a>{/if}
    </div>
  {/strip}{/foreach}
</div>