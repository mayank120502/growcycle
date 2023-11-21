<!-- This pattern was overridden by sd_affiliate add-on -->
{if $user.user_type == 'C' || $user.user_type == 'P'}
    <li><a href="{"reward_points.userlog?user_id=`$user.user_id`"|fn_url}">{__("points")} ({if $user.points}{$user.points|@unserialize}{else}0{/if})</a></li>
{/if}