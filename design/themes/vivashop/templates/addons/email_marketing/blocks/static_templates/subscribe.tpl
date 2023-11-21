{** block-description:email_marketing.tmpl_subscription **}
{if $addons.email_marketing}
<div class="ty-footer-form-block et-newsletter">
  <form action="{""|fn_url}" method="post" name="subscribe_form" class="ty-footer-form-block__form-wrapper cm-processing-personal-data">
    <input type="hidden" name="redirect_url" value="{$config.current_url}" />

    <h3 class="ty-footer-form-block__title">{$block.name}</h3>
    <div>
      {__("et_email_marketing_description")}
    </div>
    <div class="ty-footer-form-block__form-container">
      <div class="ty-footer-form-block__form ty-control-group ty-input-append cm-block-add-subscribe">
        <label class="cm-required cm-email hidden" for="subscr_email{$block.block_id}{$block.grid_id}">{__("email")}</label>
        <input type="text" name="subscribe_email" id="subscr_email{$block.block_id}{$block.grid_id}" size="20" value="{__("enter_email")}" class="cm-hint ty-input-text" />
        {include file="buttons/go.tpl" but_name="em_subscribers.update" alt=__("go") et_icon="et-icon-mail"}
      </div>
    </div>
  </form>
</div>
{/if}    
