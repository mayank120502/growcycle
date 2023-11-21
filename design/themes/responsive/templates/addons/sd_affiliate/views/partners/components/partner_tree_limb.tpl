{counter name="tree" print=false assign="tree"}

{if $user.partners}
    {$shift = $level * 16}
{else}
    {$shift = $level * 16}
{/if}

<div class="tree-limb" style="padding-left: {$shift}px;">
    {if $user.partners}<i id="on_partners_{$tree}" class="icon-right-dir dir-list cm-combination" title="{__("expand_collapse_list")}"></i><i id="off_partners_{$tree}" class="icon-down-dir dir-list hidden cm-combination" title="{__("expand_collapse_list")}"></i>{/if}
    <i class="ty-icon-user"></i>
    {if $user.firstname == "" && $user.lastname == ""}
        <strong>{__('affiliate')}_{$user.user_id}</strong>
    {else}
        {$user.firstname} {$user.lastname}
    {/if}
    {if $level} - {$level} {__("level")}{/if}
</div>

{if $user.partners}
    <div id="partners_{$tree}">
        {foreach from=$user.partners item=sub_user name=$for_name}
            {include file="addons/sd_affiliate/views/partners/components/partner_tree_limb.tpl" user=$sub_user level=$level+1 last=$smarty.foreach.$for_name.last}
        {/foreach}
    </div>
{/if}