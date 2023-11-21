{if $runtime.controller == 'profiles'}
  {if $runtime.mode == 'add'}
  <div class="ty-account-benefits">
    {$block.content.et_register_text nofilter}
  </div>

  {elseif $runtime.mode == 'update'}
    <div class="ty-account-detail">
      {$block.content.et_profile_text nofilter}
    </div>
  {/if}
{/if}