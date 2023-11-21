<!-- This pattern was overridden by sd_affiliate add-on -->
{if $user_data.user_type == 'C' || $user_data.user_type == 'P'}
    <li><a class="tool-link" href="{"reward_points.userlog?user_id=`$id`"|fn_url}">{__("view_user_points")}</a></li>
{/if}