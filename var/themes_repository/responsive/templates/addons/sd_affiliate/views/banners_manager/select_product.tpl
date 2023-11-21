{include file="addons/sd_affiliate/common/affiliate_menu.tpl"}

<div class="affiliate-block last">
    <h4 class="affiliate-title">
        {$banner.title nofilter}
            {if $banner.width && $banner.height}
                <span>({$banner.width} &times; {$banner.height})</span>
            {/if}
    </h4>

    <div class="affiliate-content">
        <div id="affiliate_banner_container_{$banner_id}"></div>
        <div class="affiliate-text">{$banner.example nofilter}</div>
    </div>

    <div>
        <a class="link-dashed affiliate-tab-link" data-tab-content-id="banner_code_{$banner_id}">
            {__("affiliate_banner_code")}
            <span class="caret-info hidden"><span class="caret-outer"></span><span class="caret-inner"></span></span>
        </a>
    </div>

    <div class="affiliate-wrap">
        <div class="info-block hidden" id="banner_code_{$banner_id}">
            <textarea class="affiliate-banner-code" cols="50" rows="4" onclick="this.select();"><div id="affiliate_banner_container_{$banner_id}"></div><pre>{$banner.code}</pre></textarea>
        </div>
    </div>
</div>

{include file="addons/sd_affiliate/views/banners_manager/components/linked_products.tpl"}

{capture name="mainbox_title"}
    {__(affiliates_partnership)} <span class="subtitle">/ {__("select_products")}</span>
{/capture}

<script type="text/javascript">
    (function(_, $) {
        $(document).ready(function() {
            var elm = $('.affiliate-wrap .info-block');
            var link = $('.affiliate-tab-link');
            link.on('click', function() {
                _this = $(this);
                if (_this.hasClass('on')) {
                    _this.removeClass('on');
                } else {
                    _this.addClass('on');
                }
                _this.siblings('.affiliate-tab-link').removeClass('on');
                elm.filter('#' + _this.data('tab-content-id')).toggle().siblings(':visible').hide();
                return false;
            });
        });
    })(Tygh, Tygh.$);
</script>

<!--Disable the button 'Delete selected' when no checkbox is selected-->
<script type="text/javascript">
    (function(_, $) {
        $(document).ready(function() {
            var button = $("button[name='dispatch[banners_manager.do_delete_linked]']").attr('disabled', true);
            var checkboxes = $(":checkbox[name='delete[]']").add($(":checkbox[name='check_all']"));
            checkboxes.on('change', function () {
                if ( $(":checkbox[name='delete[]']:checked").length == 0 ) {
                    button.attr('disabled', true).removeClass('ty-btn__secondary');
                } else {
                    button.attr('disabled', false).addClass('ty-btn__secondary');
                }
            });
        });
    }(Tygh, Tygh.$));
</script>
