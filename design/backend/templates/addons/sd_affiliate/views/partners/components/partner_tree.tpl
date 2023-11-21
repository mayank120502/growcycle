<div class="multi-level">
    {foreach from=$partners item=user name="tree_root"}
        <table class="table table-tree table-middle partners-tree-table-width">
            {if $header}
                {assign var="header" value=""}
                <thead>
                    <tr>
                        <th>
                            <span alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" id="on_cat" class="hand cm-combinations"> <span class="exicon-expand"></span> </span><span alt="{__("expand_collapse_list")}" title="{__("expand_collapse_list")}" id="off_cat" class="hand cm-combinations hidden" > <span class="exicon-collapse"></span> </span>&nbsp;{__("affiliate")}
                        </th>
                    </tr>
                </thead>
            {/if}
            <tr>
                {math equation="x*14" x=$level assign="shift"}
                <td class="partners-tree-table-width">
                    <div style="padding-left: {$shift}px;">
                        {if $user.partners}
                            <span alt="{__("expand_sublist_of_items")}" title="{__("expand_sublist_of_items")}" id="on_user_{$user.user_id}" class="hand cm-combination"{if !$show_all} onclick="if (!Tygh.$('#user_{$user.user_id}').children().get(0)) Tygh.$.ceAjax('request', '{"profiles.update?user_id=`$user.user_id`&user_type=`$user.user_type`"|fn_url}', {$ldelim}result_ids: 'user_{$user.user_id}'{$rdelim})"{/if} ><span class="exicon-expand"></span> </span><span alt="{__("collapse_sublist_of_items")}" title="{__("collapse_sublist_of_items")}" id="off_user_{$user.user_id}" class="hand cm-combination hidden"> <span class="exicon-collapse"></span> </span>
                        {/if}
                        <a href="{"profiles.update?user_id=`$user.user_id`&user_type=`$user.user_type`"|fn_url}"{if !$user.partners} class="partners-tree-table-profile"{/if} >{$user.affiliate}</a>
                    </div>
                </td>
            </tr>
        </table>
        {if $user.partners}
            <div id="user_{$user.user_id}" class="hidden">
                {include file="addons/sd_affiliate/views/partners/components/partner_tree.tpl" partners=$user.partners level=$level+1}
            </div>
        {/if}
    {foreachelse}
        <p class="no-items">{__("no_items")}</p>
    {/foreach}
</div>