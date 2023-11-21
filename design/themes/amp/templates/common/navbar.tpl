<!-- Start Navbar -->
<header class="amp-headerbar fixed flex justify-start items-center top-0 left-0 right-0 pl2 pr4 pt1 md-pt0">
    <div role="button" aria-label="open sidebar" on="tap:header-sidebar.toggle" tabindex="0" class="amp-navbar-trigger pr2 absolute top-0 pr0 mr2 mt2">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewbox="0 0 24 24" class="block">
                <path fill="none" d="M0 0h24v24H0z"></path>
                <path fill="currentColor" d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"></path>
          </svg>
    </div>

    {$amp_logo = $logos.theme}
    <a href="{""|fn_url|remote_amp_prefix}" title="{$amp_logo.image.alt}" class="text-decoration-none inline-block mx-auto amp-headerbar-home-link mb1 md-mb0">
        {include file="common/image.tpl"
            noloading=true
            layout="fill"
            image=$amp_logo.image
            width=$amp_logo.image.image_x
            height=$amp_logo.image.image_y
            class="contain p1 md-p2"
            sizes="(max-width:52rem) 12rem, 15rem"
        }
    </a>

    <div class="amp-headerbar-fixed center m0 p0 flex justify-center nowrap absolute top-0 right-0 pt2 pr3">
        <div class="mr2"></div>
        <a href="{"products.search?search_performed=Y&subcats=Y"|fn_url|remote_amp_prefix}" class="text-decoration-none mr2 amp-headerbar-fixed-link">
            <div class="amp-headerbar-icon-wrapper relative">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewbox="0 0 12 12" overflow="visible">
                    <circle fill="none" stroke="#000" stroke-width="1.68" stroke-miterlimit="10" cx="4.67" cy="4.67" r="3.83"></circle>
                    <path fill="none" stroke="#000" stroke-width="1.78" stroke-linecap="round" stroke-miterlimit="10" d="M7.258 7.77l2.485 2.485"></path>
                </svg>
            </div>
        </a>
    </div>
</header>
<!-- End Navbar -->