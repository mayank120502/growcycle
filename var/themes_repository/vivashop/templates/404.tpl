<!DOCTYPE html">
<html dir="{$language_direction}">
<head>
    <title>{__("page_not_found")}</title>
    {literal}<style>
    .ty-exception {
        font: normal 13px Arial, Tahoma, Helvetica, sans-serif;
        position: absolute;
        top: 10%;
        left: 50%;
        margin: 0 0 0 -480px;
        width: 960px;
    }
    .ty-exception p {
        margin: 0;
        padding: 0px 0px 30px 0px;
        color: #808080;
        font-size: 110%;
    }
    .ty-exception-code {
        float: left;
        display: inline-block;
        margin-right: 30px;
        padding: 50px 30px 40px;
        -webkit-border-radius: 9px;
        -moz-border-radius: 9px;
        border-radius: 9px;
        background-color: #f9f9f9;
        background-image:-moz-radial-gradient(50% 50%,circle closest-side,rgb(255,255,255) 0%,rgb(246,246,246) 100%); 
        background-image:-webkit-gradient(radial,50% 50%,0,50% 50%,94,color-stop(0, rgb(255,255,255)),color-stop(1, rgb(246,246,246)));
        background-image:-webkit-radial-gradient(50% 50%,circle closest-side, rgb(255,255,255) 0%,rgb(246,246,246) 100%);
        background-image:-ms-radial-gradient(50% 50%,circle closest-side, rgb(255,255,255) 0%,rgb(246,246,246) 100%);
        background-image:radial-gradient(50% 50%,circle closest-side, rgb(255,255,255) 0%,rgb(246,246,246) 100%);
        -webkit-box-shadow:inset 0px 1px 10px 0px rgba(0,0,0,0.05);
        -moz-box-shadow:inset 0px 1px 10px 0px rgba(0,0,0,0.05);
        box-shadow:inset 0px 1px 10px 0px rgba(0,0,0,0.05);
        color: #bfbfbf;
        font: normal bold 86px Arial, sans-serif;
        line-height: 70px;
        -ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Style=2)";
        filter:progid:DXImageTransform.Microsoft.Alpha(Style=2);
    }
    .ty-exception-code em {
        display: block;
        text-align: center;
        font: normal normal 26px Arial, sans-serif;
    }
    .ty-exception h1 {
        margin: 0;
        padding: 0px 0px 25px 0px;
        font: normal bold 25px Arial, sans-serif;
    }
  </style>{/literal}
</head>
<body>
    <div class="ty-exception">
        <span class="ty-exception-code"> {$exception_status} <em>{__("exception_error")}</em> </span>
    <h1>{__("exception_title")}</h1>
    <p>
        {if $smarty.const.HTTPS === true}
            {assign var="return_url" value=$config.https_location|fn_url}
        {else}
            {assign var="return_url" value=$config.http_location|fn_url}
        {/if}
        
        {if $exception_status == "403"}
            {__("access_denied_text")}
        {elseif $exception_status == "404"}
            {__("page_not_found_text")}
        {/if}
    </p>
    <p>{__("exception_error_code")}
        {if $exception_status == "403"}
            {__("access_denied")}
        {elseif $exception_status == "404"}
            {__("page_not_found")}
        {/if}
    </p>
    </div>
</body>
</html>