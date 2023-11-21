{if $content|trim}
{$obj_id="`$block.grid_id``$block.block_id`"}
<script>
(function(_, $) {

  var triggers=$('#et-menu-{$obj_id} .et-left-menu__trigger, #et-menu-{$obj_id} .et-menu__close-left, #et-menu-{$obj_id} .et-dim-content');
  var whichEvent = ('ontouch' in document.documentElement ? "touch" : "click");

  if(_.isTouch && window.navigator.msPointerEnabled) {
      whichEvent = 'click';
  }

  triggers.on(whichEvent, function(e) {
    var wrapper='.et-left-menu';

    $('body').toggleClass('noscroll-fixed');
    if ($('body').hasClass('et-left-menu-visible')){
      $('body').hasClass('et-left-menu-visible')
      setTimeout(function(){ 
        $('body').removeClass('et-left-menu-visible bottom-menu-opened');
        if (isiPhone()) {
          iNoBounce.disable();
        } 
      },300);
    }else{
      $('body').addClass('et-left-menu-visible bottom-menu-opened');
      if (isiPhone()) {
        iNoBounce.enable();
      }
    }

    var content=$(this).parents(wrapper).find('.et-left-menu__content');
    content.toggleClass('et-left-menu-showing');
    if (content.hasClass('et-menu__showing')){
        setTimeout(function(){ 
          content.removeClass('et-menu__showing'); 
        },300);
      }else{
        content.addClass('et-menu__showing');
      }
    

    $(this).parents(wrapper).find('.ty-menu__item').toggle();
    $(this).parents(wrapper).find('.et-dim-content').toggleClass('visible');

    return false;
  });
}(Tygh, Tygh.$));

</script>

<div class="et-left-menu mobile-sticky-menu-item " id="et-menu-{$obj_id}">
  <a href="#" class="et-left-menu__trigger hidden-desktop mobile-sticky-menu-link" >
    <i class="et-icon-my-account"></i>
  </a>

  <div class="et-left-menu__content {if isset($hide_wrapper)} cm-hidden-wrapper{/if}{if $hide_wrapper} hidden{/if}{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">

    <div class="et-menu__controls et-primary-bkg">
      <div class="et-menu__title">
        {__("my_account")}
      </div>
      <div class="">
        <a href="#" class="et-menu__btn et-menu__close-left">
          <i class="et-icon-menu-close"></i>
        </a>
      </div>
    </div>

    <div class="et-my-account-content ty-sidebox__body visible-phone visible-tablet" id="1sidebox_{$block.block_id}">{$content|default:"&nbsp;" nofilter}</div>
  </div>
  <div class="et-dim-content"></div>
</div>
{/if}