<!DOCTYPE html>
<html ⚡="" amp lang="{$smarty.const.CART_LANGUAGE}" dir="{$language_direction}">
    <head>
        <title>[title]</title>
        {if $seo_canonical}
            <link rel="canonical" href="{$seo_canonical.current|remote_amp_prefix}">
        {/if}
        {include file="common/meta.tpl"}


        {literal}
            <style amp-boilerplate>
                body{-webkit-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-moz-animation:-amp-start 8s steps(1,end) 0s 1 normal both;-ms-animation:-amp-start 8s steps(1,end) 0s 1 normal both;animation:-amp-start 8s steps(1,end) 0s 1 normal both}@-webkit-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-moz-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-ms-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@-o-keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}@keyframes -amp-start{from{visibility:hidden}to{visibility:visible}}
            </style>
            <noscript><style amp-boilerplate>body{-webkit-animation:none;-moz-animation:none;-ms-animation:none;animation:none}</style></noscript>
        {/literal}

        <style amp-custom="">
            .bigEntrance{
                animation-name: bigEntrance;
                -webkit-animation-name: bigEntrance;
                animation-duration: 1.6s;
                -webkit-animation-duration: 1.6s;
                animation-timing-function: ease-out;
                -webkit-animation-timing-function: ease-out;
                visibility: visible;
            }

            @keyframes bigEntrance {
                0% {
                    transform: scale(0.3) rotate(6deg) translateX(-30%) translateY(30%);
                    opacity: 0.2;
                }
                30% {
                    transform: scale(1.03) rotate(-2deg) translateX(2%) translateY(-2%);
                    opacity: 1;
                }
                45% {
                    transform: scale(0.98) rotate(1deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }
                60% {
                    transform: scale(1.01) rotate(-1deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }   
                75% {
                    transform: scale(0.99) rotate(1deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }
                90% {
                    transform: scale(1.01) rotate(0deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }   
                100% {
                    transform: scale(1) rotate(0deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }       
            }

            @-webkit-keyframes bigEntrance {
                0% {
                    -webkit-transform: scale(0.3) rotate(6deg) translateX(-30%) translateY(30%);
                    opacity: 0.2;
                }
                30% {
                    -webkit-transform: scale(1.03) rotate(-2deg) translateX(2%) translateY(-2%);
                    opacity: 1;
                }
                45% {
                    -webkit-transform: scale(0.98) rotate(1deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }
                60% {
                    -webkit-transform: scale(1.01) rotate(-1deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }   
                75% {
                    -webkit-transform: scale(0.99) rotate(1deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }
                90% {
                    -webkit-transform: scale(1.01) rotate(0deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }   
                100% {
                    -webkit-transform: scale(1) rotate(0deg) translateX(0%) translateY(0%);
                    opacity: 1;
                }               
            }

            .container {
                margin-top: 100px;
                font-family: Tahoma;
            }

            .banner {
                background-color: #fe5652;
                border-radius: 24px;
                color: #ffffff;
                font-weight: normal; 
                font-size: 68px;
                padding: 10px;
                text-align: center;
                margin-left: auto;
                margin-right: auto;

                display: inline-block;
                zoom: 1;
            }

            .banner-inner {
                border-radius: 20px;
                border: 4px solid #ffffff;
                padding: 30px;
                text-transform: uppercase;
                letter-spacing: 2px;
            }

            .container {
                text-align:center;
            }

            .message {
                margin-top: 20px;
                font-size: 20px;
                text-align: center;
            }
        </style>
        <script async src="https://cdn.ampproject.org/v0.js"></script>
    </head>
    <body>
        <div class="container">
            <div class="bigEntrance banner">
                <div class="banner-inner">
                    [banner]
                </div>
            </div>
        </div>
        <div class="message">
            [message]
        </div>
    </body>      
</html>