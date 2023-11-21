var windowWidth = window.innerWidth || document.documentElement.clientWidth;

(function(_, $) {
  function et_hover(){
    if (typeof($(".et-additional-categ a"))!= 'undefined'){
      $(".et-additional-categ a").hover(function(e){
          $(this).addClass('et-hover');
        }, function(e){
          $(this).removeClass('et-hover');
      });
    }
  }
  $(document).ready(function(){
    et_hover();
  })
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
    et_hover();
  })

  $(document).ready(function(){
    if (typeof($(".et-additional-categ"))!= 'undefined'){
      $(".et-additional-categ").each(function(){
        var self_wrap=$(this);

        if (self_wrap.data("rendered") != true){
          
          $("li a",self_wrap).click(function(){
            var self=$(this).parent();
            var self_id=self.attr('id');
            var content_id='#content_'+self_id;
            var content=$(content_id);

            self.siblings().removeClass("active");
            content.siblings(".et-tab").addClass('hidden');
            content.removeClass("hidden");
            self.addClass("active");

            $(content_id+" .etLazy").each(function(){
              var img=$(this);
              if (img.visible(true) && img.is(":visible")){
                img.one('load', function() {
                    img.removeAttr("data-src");
                    img.removeClass("etLazy");
                    return;
                }).attr('src', img.data("src"))
                .each(function() {
                  //Cache fix for browsers that don't trigger .load()
                  if(this.complete) $(this).trigger('load');
                });
              }
            })
            $(content_id+" .ty-banner__image-item .lazy").each(function(){
              $(this).removeClass("lazy");
            })
            
            
          })
          self_wrap.data("rendered",true);
        }
      })
    }
  })
}(Tygh, Tygh.$));

(function(_, $) {
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
    $(".et-additional-categ").each(function(){
      var self_wrap=$(this);
      $("li a",self_wrap).click(function(){
        var self=$(this).parent();
        var self_id=self.attr('id');
        var content_id='#content_'+self_id;
        var content=$(content_id);

        self.siblings().removeClass("active");
        content.siblings(".et-tab").addClass('hidden');
        content.removeClass("hidden");
        self.addClass("active");

        $(content_id+" .etLazy").each(function(){
          var img=$(this);
          if (img.visible(true) && img.is(":visible")){
            img.one('load', function() {
                img.removeAttr("data-src");
                img.removeClass("etLazy");
                return;
            }).attr('src', img.data("src"))
            .each(function() {
              //Cache fix for browsers that don't trigger .load()
              if(this.complete) $(this).trigger('load');
            });
          }
        })
        $(content_id+" .ty-banner__image-item .lazy").each(function(){
          $(this).removeClass("lazy");
        })
        
        
      })
    })
  })
}(Tygh, Tygh.$));


(function(_, $) {
  function et_hover(){
    if (typeof($(".et-subcategs .ty-subcategories__item"))!= 'undefined'){
      $(".et-subcategs .ty-subcategories__item a").hover(function(e){
          $(this).addClass('et-hover');
        }, function(e){
          $(this).removeClass('et-hover');
      });
    }
  }
  $(document).ready(function(){
    et_hover();
  })
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
    et_hover();
  })
}(Tygh, Tygh.$));

(function(_, $) {
  function et_hover(){
    if (typeof($(".et-sticky-tabs-wrapper .et-sticky-tab"))!= 'undefined'){
      $(".et-sticky-tabs-wrapper .et-sticky-tab").hover(function(e){
          $(this).addClass('et-hover');
        }, function(e){
          $(this).removeClass('et-hover');
      });
    }
  }
  $(document).ready(function(){
    et_hover();
  })
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
    et_hover();
  })
}(Tygh, Tygh.$));

function isTouchDevice() {
  var touch_start = (typeof (window.ontouchstart) != 'undefined') ? true : false;
  var isTouch =  ((('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch) || touch_start || (navigator.userAgent.toLowerCase().indexOf("touch") !== -1)) && (!(navigator.userAgent.toLowerCase().indexOf("wow64;") > -1) && !(navigator.userAgent.toLowerCase().indexOf("win64;") > -1))  || $('html').hasClass('touch')|| $('html').hasClass('touchevents');
  return isTouch;
}

(function(global){var startY=0;var enabled=false;var supportsPassiveOption=false;try{var opts=Object.defineProperty({},'passive',{get:function(){supportsPassiveOption=true;}});window.addEventListener('test',null,opts);}catch(e){}var handleTouchmove=function(evt){var el=evt.target;var zoom=window.innerWidth/window.document.documentElement.clientWidth;if(evt.touches.length>1||zoom!==1){return;}while(el!==document.body&&el!==document){var style=window.getComputedStyle(el);if(!style){break;}if(el.nodeName==='INPUT'&&el.getAttribute('type')==='range'){return;}var overflowY=style.getPropertyValue('overflow-y');var height=parseInt(style.getPropertyValue('height'),10);var isScrollable=overflowY==='auto'||overflowY==='scroll';var canScroll=el.scrollHeight>el.offsetHeight;if(isScrollable&&canScroll){var curY=evt.touches?evt.touches[0].screenY:evt.screenY;var isAtTop=(startY<=curY&&el.scrollTop===0);var isAtBottom=(startY>=curY&&el.scrollHeight-el.scrollTop===height);if(isAtTop||isAtBottom){evt.preventDefault();}return;}el=el.parentNode;}evt.preventDefault();};var handleTouchstart=function(evt){startY=evt.touches?evt.touches[0].screenY:evt.screenY;};var enable=function(){window.addEventListener('touchstart',handleTouchstart,supportsPassiveOption?{passive:false}:false);window.addEventListener('touchmove',handleTouchmove,supportsPassiveOption?{passive:false}:false);enabled=true;};var disable=function(){window.removeEventListener('touchstart',handleTouchstart,false);window.removeEventListener('touchmove',handleTouchmove,false);enabled=false;};var isEnabled=function(){return enabled;};var testDiv=document.createElement('div');document.documentElement.appendChild(testDiv);testDiv.style.WebkitOverflowScrolling='touch';var scrollSupport='getComputedStyle'in window&&window.getComputedStyle(testDiv)['-webkit-overflow-scrolling']==='touch';document.documentElement.removeChild(testDiv);if(scrollSupport){enable();}var iNoBounce={enable:enable,disable:disable,isEnabled:isEnabled};if(typeof module!=='undefined'&&module.exports){module.exports=iNoBounce;}if(typeof global.define==='function'){(function(define){define('iNoBounce',[],function(){return iNoBounce;});}(global.define));}else{global.iNoBounce=iNoBounce;}}(this));
function isiPhone() {
    return (
        (navigator.userAgent.toLowerCase().indexOf("ipad") > -1) ||
        (navigator.userAgent.toLowerCase().indexOf("iphone") > -1) ||
        (navigator.userAgent.toLowerCase().indexOf("ipod") > -1)
    );
}

/*iphone scroll fix*/
(function(_, $) {
  $(document).ready(function(){
    if (isiPhone()) {
      iNoBounce.disable();
    }
    scrollbarWidth = window.innerWidth - document.documentElement.clientWidth;

    if (scrollbarWidth==15){
      $("body").addClass("mac-sbw");
    }
  });
  $.ceEvent('on', 'ce.ajaxdone', function(content) {
    if (isiPhone()) {
      iNoBounce.disable();
    }
  });
  $.ceEvent('on', 'ce.commoninit', function(content) {
    if (isiPhone()) {
      iNoBounce.disable();
    }
  });
})(Tygh,Tygh.$);

var grid_shadow;
var grid_shadow_dim;

var menu_active;
/*!
 * hoverIntent v1.8.0 // 2014.06.29 // jQuery v1.9.1+
 * http://cherne.net/brian/resources/jquery.hoverIntent.html
 *
 * You may use hoverIntent under the terms of the MIT license. Basically that
 * means you are free to use hoverIntent as long as this header is left intact.
 * Copyright 2007, 2014 Brian Cherne
 */
(function($){$.fn.hoverIntent=function(handlerIn,handlerOut,selector){var cfg={interval:100,sensitivity:6,timeout:0};if(typeof handlerIn==="object"){cfg=$.extend(cfg,handlerIn)}else{if($.isFunction(handlerOut)){cfg=$.extend(cfg,{over:handlerIn,out:handlerOut,selector:selector})}else{cfg=$.extend(cfg,{over:handlerIn,out:handlerIn,selector:handlerOut})}}var cX,cY,pX,pY;var track=function(ev){cX=ev.pageX;cY=ev.pageY};var compare=function(ev,ob){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t);if(Math.sqrt((pX-cX)*(pX-cX)+(pY-cY)*(pY-cY))<cfg.sensitivity){$(ob).off("mousemove.hoverIntent",track);ob.hoverIntent_s=true;return cfg.over.apply(ob,[ev])}else{pX=cX;pY=cY;ob.hoverIntent_t=setTimeout(function(){compare(ev,ob)},cfg.interval)}};var delay=function(ev,ob){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t);ob.hoverIntent_s=false;return cfg.out.apply(ob,[ev])};var handleHover=function(e){var ev=$.extend({},e);var ob=this;if(ob.hoverIntent_t){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t)}if(e.type==="mouseenter"){pX=ev.pageX;pY=ev.pageY;$(ob).on("mousemove.hoverIntent",track);if(!ob.hoverIntent_s){ob.hoverIntent_t=setTimeout(function(){compare(ev,ob)},cfg.interval)}}else{$(ob).off("mousemove.hoverIntent",track);if(ob.hoverIntent_s){ob.hoverIntent_t=setTimeout(function(){delay(ev,ob)},cfg.timeout)}}};return this.on({"mouseenter.hoverIntent":handleHover,"mouseleave.hoverIntent":handleHover},cfg.selector)}})(jQuery);


(function(_,$){
  // vertical product mouse drag
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
    var x,y,top,left,down,p_active,is_dragging;
    $(".et_menu_product-vertical .et-link-thumb").mousedown(function(e){
        e.preventDefault();
        down = true;
        x = e.pageX;
        y = e.pageY;
        top = $(this).scrollTop();
        left = $(this).scrollLeft();
        p_active=$(this);
    });

    $("body").mousemove(function(e){
        if(down){
            var newX = e.pageX;
            var newY = e.pageY;
            if (newY!=y){
              is_dragging=true;
            }

            p_active.scrollTop(top - newY + y);
        }
    });

    $(".et_menu_product-vertical .et-link-thumb a").click(function(e){
      if (is_dragging){
        is_dragging=false;
        return false;
      }
    })

    $("body").mouseup(function(e){
      down = false;
    });
    
  });


  $(document).ready(function(){


    function main_hoverIn(){
      var et_self=$(this);

/*      var bottom = self[0].getBoundingClientRect().bottom;
      console.log(bottom);
      $('.ty-menu__items,.et-menu-2-wrapper',self).css({
        "max-height": "calc(100vh - "+bottom+"px)"
      });*/

      if (isTouchDevice()){
        var touch_et_self=et_self;
        var et_self=et_self.parent();
      }

      et_self.addClass("drophover");

      $(".et-menu-icon.et_lazy_menu",et_self).each(function(){
        var img=$(this);
        img.one('load', function() { 
            if (img.data("srcset")){
              img.attr("srcset",img.data("srcset"));
              img.removeAttr("data-srcset");
            }
            img.removeAttr("data-src");
            img.removeClass("et_lazy_menu");
            return;
        }).attr('src', img.data("src"))
        .each(function() {
          //Cache fix for browsers that don't trigger .load()
          if(this.complete) $(this).trigger('load');
        });
      })

      if (!et_self.hasClass("no-dim")){
        $("body").addClass("shadow shadow-dim");
      }
      if (isTouchDevice()){
        touch_et_self.unbind("click").click(main_hoverOut);
      }
    }
    function main_hoverOut(){
      var et_self=$(this);
      if (isTouchDevice()){
        var touch_et_self=et_self;
        var et_self=et_self.parent();
      }

      et_self.removeClass("drophover");
      $("body").removeClass("shadow shadow-dim");
      if (isTouchDevice()){
        touch_et_self.unbind("click").click(main_hoverIn);
      }
    }

    if (!isTouchDevice()){
      $('.et-category-menu').hoverIntent({
        over: main_hoverIn,
        out: main_hoverOut,
        timeout: 40
      });
    }else{
      $('.et-category-menu:not(.drophover) .ty-dropdown-box__title').on('click',main_hoverIn);
    }

    function sub_hoverIn(e){
      var et_self=e;
      if (!et_self.hasClass('drophover')){
        et_self.addClass("drophover");

        if (!et_self.hasClass('bottom') && !et_self.data("align")){
          $.ceEvent('on', 'ce.ajaxdone', function(context) {
            expandH=$(".et-menu-2-wrapper",et_self).outerHeight();
            et_selfH=et_self.outerHeight();
            var prevAllH=0;
            if (!et_self.data("align")){
              et_self.prevAll().each(function(){
                  var h=$(this).outerHeight();
                  prevAllH+=$(this).outerHeight();
              });
              align=(prevAllH+et_selfH)-expandH;
            }else{
              align=et_self.data("align");
            }
            et_self.prevAll().each(function(){
                var h=$(this).outerHeight();
                prevAllH+=$(this).outerHeight();
            });
            et_self.data("align",align);

            if (align>=0){
              et_self.addClass('bottom');
            }else{
              et_self.removeClass('bottom');
            };
          });

          expandH=$(".et-menu-2-wrapper",et_self).outerHeight();
          et_selfH=et_self.outerHeight();
          var prevAllH=0;
          if (!et_self.data("align")){
            et_self.prevAll().each(function(){
                var h=$(this).outerHeight();
                prevAllH+=$(this).outerHeight();
            });
            align=(prevAllH+et_selfH)-expandH;
          }else{
            align=et_self.data("align");
          }
          et_self.data("align",align);

          if (align>=0){
            et_self.addClass('bottom')
          }else{
            et_self.removeClass('bottom');
          };

        }

        $(".et_lazy_menu",et_self).each(function(){
          var img=$(this);
          img.one('load', function() { 
              if (img.data("srcset")){
                img.attr("srcset",img.data("srcset"));
                img.removeAttr("data-srcset");
              }
              img.removeAttr("data-src");
              img.removeClass("et_lazy_menu");
              return;
          }).attr('src', img.data("src"))
          .each(function() {
            //Cache fix for browsers that don't trigger .load()
            if(this.complete) $(this).trigger('load');
          });
        })
        
        menu_products=$(".et-menu-products-container",et_self);
        if (menu_products.length){
          if ( !(menu_products.data('loaded'))){
            $.ceAjax(
              'request', 
              fn_url('et_menu_products.et_load&category_id='+menu_products.data('etCategoryId')), {
              hidden: true,
              caching: false,
              force_exec: true,
              result_ids: menu_products.attr('id'),
              method: 'post',
              data: {
                container_id: menu_products.attr('id'),
              },
              callback: function(data) {
                if (data.html !== undefined) {
                  menu_products.data('loaded',true);
                  $(".et_menu_product-vertical .ty-thumbnail-list").each(function(){
                    if ($(this).data('allLazyLoaded')!=true){

                      $(this).on('scroll', function(e) {
                        if ($(".etLazy",this).length){
                          $(".et-menu-product-wrapper").each(function(){
                            et_self=$(this);
                            if (et_self.visible(true)){
                              et_self.addClass('active');
                            }else{
                              et_self.removeClass('active');
                            }
                          })
                          $(".active .etLazy",this).each(function(){
                            img=$(this);
                            if (img.visible(true)){
                              img.one('load', function() {

                                  img.removeAttr("data-src");
                                  img.removeClass("etLazy");
                                  img.addClass("et_js");
                                  
                                  img.removeAttr("style");
                                  return;
                              }).attr('src', img.data("src"))
                              .each(function() {
                                //Cache fix for browsers that don't trigger .load()
                                if(this.complete) $(this).trigger('load');
                              });
                            }
                          });
                        }else{
                          $(".et-menu-product-wrapper",this).removeClass('active');
                          $(this).data('allLazyLoaded',true);
                        }
                      })
                    }
                  });
                }
              }
            });
          }
        }
        et_self.data('is_active',true);
      }
    }

    function sub_hoverOut(e){
      var et_self=e;
      et_self.removeClass("drophover");
      et_self.data('is_active',false);
    }
    
    if (!isTouchDevice()){
      $('.et-category-menu .ty-menu__items').menuAim({
           // Function to call when a row is purposefully activated. Use this
           // to show a submenu's content for the activated row.
           activate: function(e) {
              sub_hoverIn($(e));
           },

           // Function to call when a row is deactivated.
           deactivate: function(e) {
            $(e).removeClass("drophover");
           },
           exitMenu: function(e) {
            return true;
           },
           submenuSelector: "*",
           submenuDirection: "right",
       });
    }else{
      if (windowWidth>1024){
        $('.et-category-menu .ty-menu__item-link').click(function (e){
            item=$(this).parents('.menu-level-1');
            if (!item.hasClass('drophover')){
              e.preventDefault();
            }
            $('.et-category-menu .ty-menu__items .drophover').removeClass('drophover');
            sub_hoverIn(item);
        });
      }
      $(window).resize(function(){
        windowWidth = window.innerWidth || document.documentElement.clientWidth;
        if (windowWidth>1024){
          $('.et-category-menu .ty-menu__item-link').click(function (e){
              item=$(this).parents('.menu-level-1');
              if (!item.hasClass('drophover')){
                e.preventDefault();
              }
              $('.et-category-menu .ty-menu__items .drophover').removeClass('drophover');
              sub_hoverIn(item);
          });
        }else{
          $('.et-category-menu .ty-menu__item-link').unbind( "click" ).click(function (e){return true});

        }
      });
    }

    function vendor_main_hoverIn(){
      et_self=$(this);
      et_self.addClass("drophover");
    }

    function vendor_main_hoverOut(){
      et_self=$(this);
      et_self.removeClass("drophover");
    }

    if (!isTouchDevice()){
      $('.et-vendor-menu-pages').hover(vendor_main_hoverIn,vendor_main_hoverOut);
      $('.et-vendor-menu-level-1__ul, .et-vendor-menu-level-2__ul').menuAim({
           // Function to call when a row is purposefully activated. Use this
           // to show a submenu's content for the activated row.
           activate: function(e) {
            $(e).addClass("drophover");
           },

           // Function to call when a row is deactivated.
           deactivate: function(e) {
            $(e).removeClass("drophover");
           },
           exitMenu: function(e) {
            return true;
           },
           submenuSelector: "*",
           // submenuDirection: "down",
       });
    }else{
      $(window).resize(function(){
        windowWidth = window.innerWidth || document.documentElement.clientWidth;
        if (windowWidth>1024){
          $('.et-vendor-menu-pages .et-vendor-menu-top-link').unbind( "click" ).click(function (e){
              item=$(this).parent();
              e.preventDefault();
              if (!item.hasClass('drophover')){
                $('.et-vendor-menu-pages.drophover').removeClass('drophover');
                item.addClass('drophover');
              }else{
                $('.et-vendor-menu-pages.drophover').removeClass('drophover');
              }
          });

          $('.et-vendor-menu-pages .ty-top-mine__submenu-col>a').unbind( "click" ).click(function (e){
              item=$(this).parent();
              item_ul_class='.'+item.parent().attr('class').replace(/ /gi, '.');
              console.log('item_ul_class='+item_ul_class);
              if (!item.hasClass('drophover')){
                e.preventDefault();
                $('.et-vendor-menu-pages '+item_ul_class+'>.ty-top-mine__submenu-col.drophover').removeClass('drophover');
                item.addClass('drophover');
              }else{
              }
          });

        }else{
          $('.et-vendor-menu-pages .et-vendor-menu-top-link, .et-vendor-menu-pages .ty-top-mine__submenu-col>a').unbind( "click" ).click(function (e){return true});
        }
      });
      $('.et-category-menu:not(.drophover) .ty-dropdown-box__title').on('click',main_hoverIn);
    }
  });
})(Tygh,Tygh.$);


// <!-- element visibility for animation trigger -->
(function($){

  /**
   * Copyright 2012, Digital Fusion
   * Licensed under the MIT license.
   * http://teamdf.com/jquery-plugins/license/
   *
   * @author Sam Sehnert
   * @desc A small plugin that checks whether elements are within
   *       the user visible viewport of a web browser.
   *       only accounts for vertical position, not horizontal.
   */
  var $w = $(window);
  $.fn.visible = function(partial,hidden,direction){

    if (this.length < 1)
      return;

    var $t        = this.length > 1 ? this.eq(0) : this,
      t         = $t.get(0),
      vpWidth   = $w.width(),
      vpHeight  = $w.height(),
      direction = (direction) ? direction : 'both',
      clientSize = hidden === true ? t.offsetWidth * t.offsetHeight : true;

    if (typeof t.getBoundingClientRect === 'function'){

      // Use this native browser method, if available.
      var rec = t.getBoundingClientRect(),
        tViz = rec.top    >= 0 && rec.top    <  vpHeight,
        bViz = rec.bottom >  0 && rec.bottom <= vpHeight,
        lViz = rec.left   >= 0 && rec.left   <  vpWidth,
        rViz = rec.right  >  0 && rec.right  <= vpWidth,
        vVisible   = partial ? tViz || bViz : tViz && bViz,
        hVisible   = partial ? lViz || lViz : lViz && rViz;

      if(direction === 'both')
        return clientSize && vVisible && hVisible;
      else if(direction === 'vertical')
        return clientSize && vVisible;
      else if(direction === 'horizontal')
        return clientSize && hVisible;
    } else {

      var viewTop         = $w.scrollTop(),
        viewBottom      = viewTop + vpHeight,
        viewLeft        = $w.scrollLeft(),
        viewRight       = viewLeft + vpWidth,
        offset          = $t.offset(),
        _top            = offset.top,
        _bottom         = _top + $t.height(),
        _left           = offset.left,
        _right          = _left + $t.width(),
        compareTop      = partial === true ? _bottom : _top,
        compareBottom   = partial === true ? _top : _bottom,
        compareLeft     = partial === true ? _right : _left,
        compareRight    = partial === true ? _left : _right;

      if(direction === 'both')
        return !!clientSize && ((compareBottom <= viewBottom) && (compareTop >= viewTop)) && ((compareRight <= viewRight) && (compareLeft >= viewLeft));
      else if(direction === 'vertical')
        return !!clientSize && ((compareBottom <= viewBottom) && (compareTop >= viewTop));
      else if(direction === 'horizontal')
        return !!clientSize && ((compareRight <= viewRight) && (compareLeft >= viewLeft));
    }
  };

})(jQuery);

// <!-- scroll to top button -->

(function(_, $) {
  $.ceEvent('on', 'ce.commoninit', function(context) {

    if (!isTouchDevice()) {
      $(window).scroll(function(){
        if ($(this).scrollTop() > 100) {
          $('#scroll-up').stop().fadeIn(30);
        } else {
          $('#scroll-up').stop().fadeOut(30);

        }
      });
    }
    $('#scroll-up').click(function(){
      $('html,body').stop().animate({scrollTop:'0px'},'1000');
      return false;
    });
  });
}(Tygh, Tygh.$));


//rating graph animation
(function(_, $) {
  $.ceEvent('on', 'ce.commoninit', function(context) {

    $(".et-rating-graph__trigger").one('mouseenter',function(){
     var self=$(this);
     var bar=$(".et-rating-graph__bar",self);
     bar.each(function(){
       var width=$(this).data("etWidth");
       $(this).css("width",0);
       $(this).animate({
         width: width+"%"
       },500,"swing");
     });
    });
  });

  $("#discussion.ty-tabs__item").one('click',function(){
    var self=$("#content_discussion");
    var bar=$(".et-rating-graph__bar",self);
    bar.each(function(){
      var parent=$(this).parents(".et-rating-graph__ul li");
      var width=$(this).data("etWidth");
      var count=$(this).data("etCount");
      $(this).css("width",0);
      $(this).animate({
        width: width+"%"
      },{
        duration: 500,
        easing: "swing",
        start: function(){
          var $this = $(".et-rating-graph__count .et-rating-graph__text",parent),
              countTo = count;
          $this.html('0');
          $({ countNum: $this.text()}).animate({
            countNum: countTo
          },

          {

            duration: 500,
            easing:'linear',
            step: function() {
              $this.text(Math.floor(this.countNum));
            },
            complete: function() {
              $this.text(Math.floor(this.countNum));
            }

          });
        }

      });


    });
  });

  $('.et-rating-graph__product-tabs .et-filter-options a').on('click',function(){
    $('.et-rating-graph__product-tabs .et-filter-options a.active').removeClass("active");
    $(this).addClass("active");
  });
}(Tygh, Tygh.$));


(function(_, $) {
  _.$ = $;
  if ($('.et-sticky-header').length){
    et_offset=$('.et-sticky-header').height();
    _.et_offset=et_offset;
  }
}(Tygh, jQuery));

(function(_, $) {

  _.$ = $;
  $.extend({
    scrollToElm: function(elm, container, offset)
    {
      if (offset === undefined){
        offset = 0;
      }
      elm_name=elm;
      container = container || undefined;

      if (typeof(elm) === 'string') {
        if (elm.length && elm.charAt(0) !== '.' && elm.charAt(0) !== '#') {
          elm = '#' + elm;
        }
        elm = $(elm, container);
      }

      if (!(elm instanceof $) || !elm.size()) {
        if (container instanceof $ && container.length) {
            elm = container;
        } else {
            return;
        }
      }

      var delay = 500;
      var obj;
      var windowWidth = window.innerWidth || document.documentElement.clientWidth;

      if (offset!=0){
        offset=offset;
      }else if (typeof(_.et_offset) != "undefined" && _.et_offset !== null){
        offset = _.et_offset+10;
        if (elm_name=="et_prod_title" && $('.et-sticky-header').length){
          offset=offset-12;
        }
        if (windowWidth<769){
          if ($('.et-mobile-header').length>=1){
            offset=$('.et-mobile-header').height()+10;
            if (elm.hasClass("cm-failed-field") && elm.siblings('.cm-failed-label').outerHeight()>0){
              offset+=elm.siblings('.cm-failed-label').outerHeight();
            }
          }
        }
      }

      if (_.area == 'A') {
          offset = 120; // offset fixed panel
      }
      if (typeof(elm.data("etOffset")) != "undefined"){
          offset=elm.data("etOffset");
      }

      if (elm.is(':hidden')) {
          elm = elm.parent();
      }

      var elm_offset = elm.offset().top;

      _.scrolling = true;
      if (!$.ceDialog('inside_dialog', {jelm: elm})) {
          obj = $($.browser.opera ? 'html' : 'html,body');
          elm_offset -= offset;
      } else {

          obj = $.ceDialog('get_last').find('.object-container');
          elm = $.ceDialog('get_last').find(elm);

          if(obj.length && elm.length) {
              elm_offset = elm.offset().top;

              if(elm_offset < 0) {
                  elm_offset = obj.scrollTop() - Math.abs(elm_offset) - obj.offset().top - offset;
              } else {
                  elm_offset = obj.scrollTop() + Math.abs(elm_offset) - obj.offset().top  - offset;
              }
          }
      }


      if ("-ms-user-select" in document.documentElement.style && navigator.userAgent.match(/IEMobile\/10\.0/)) {
          setTimeout(function() {
              $('html, body').scrollTop(elm_offset);
          }, 300);
          _.scrolling = false;
      } else {
          $(obj).animate({scrollTop: elm_offset}, delay, function() {
              _.scrolling = false;
          });
      }




      $.ceEvent('trigger', 'ce.scrolltoelm', [elm]);
    }
  });
}(Tygh, jQuery));


function grid_hover(){
  $(".et-grid-item-wrapper").mouseenter(function(e){
    var self=$(this);
    current_height=Math.round(self.innerHeight());
    self.innerHeight(current_height);
    self.addClass('et-hover');
    self.children(".et-grid-item").addClass('et-grid-item-absolute');
  }).mouseleave(function(e){
    var self=$(this);
    self.innerHeight("auto");
    self.removeClass('et-hover');
    self.children(".et-grid-item").removeClass('et-grid-item-absolute');
  });

}

$(document).ready(function() {
  grid_hover();
});

(function(_, $) {
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
    grid_hover();
  });
}(Tygh, Tygh.$));


function et_on_load(){
  if ($('.et-sticky-header').length){
    et_sticky_header();
  }

  hashname = window.location.hash.replace('#', '');
  elem = $('#' + hashname);
  if(hashname.length > 1) {
    var et_offset=0;
    var window_top = $(window).scrollTop() + 0;

    if ($('.et-vendor-store-menu').length){
      et_offset=$('.et-vendor-store-menu.et_sticky').height();
    }else if($('.et-sticky-header').length){
      et_offset=$('.et-sticky-header').height();
    }
    $('.et_tab_offset').css({
      top: "-"+et_offset+'px'
    });

    t=elem.offset().top;
    $('body, html').animate({
      scrollTop: t
    },{
      duration:500,
      start:function(){
        $('.et-vendor-store-menu.et_sticky').addClass('animate');
      }
    });
  }else{
    $('.et-vendor-store-menu').addClass('animate');
  }


  
}


$(window).load(function(){
  et_on_load();
});


var last_scroll_position=0;
function et_sticky_header(){
  sticky_header=$('.et-sticky-header');
  scroll_direction=$(window).scrollTop()-last_scroll_position;
  last_scroll_position=$(window).scrollTop();
  windowWidth = window.innerWidth || document.documentElement.clientWidth;

  if (windowWidth<=1024 && sticky_header.hasClass("et-sticky-visible")){
    sticky_header.removeClass('et-sticky-visible');
  }
  if (windowWidth>1024){
    if ($(window).scrollTop() >= show_sticky_top_menu && !(sticky_header.hasClass("et-sticky-visible"))){
      sticky_header.addClass('et-sticky-visible');

      /*css animation*/
      sticky_header.addClass('et-animating');
      setTimeout(function(){
        $('.et-sticky-header').removeClass('et-animating');
      },500);
      /*end css animation*/

    }else if (($(window).scrollTop() < show_sticky_top_menu) && sticky_header.hasClass("et-sticky-visible")){
      sticky_header.removeClass('et-sticky-visible');
      

      sticky_header.addClass('et-animating');
      setTimeout(function(){
        $('.et-sticky-header').removeClass('et-animating');
      },500);
      if (!isTouchDevice()) {
        $(".et-sticky-header .cm-combination.open").click();
      }else{
        $(".et-sticky-header .cart-content-grid .cm-combination.open, .et-sticky-header .drophover .cm-combination.open").click();
      }
    }
  }
}

function et_mobile_sticky_header(start){
  sticky_header=$('.et-mobile-header.et-sticky');
  if ( $(window).scrollTop() >= start ){
    if (!(sticky_header.hasClass("et-active"))){
      sticky_header.addClass('et-active');
      h=sticky_header.outerHeight()+0;
      $("body").css({
        "padding-top": h + "px",
      });
    }
  }else{
    sticky_header.removeClass('et-active');
    $("body").css({
      "padding-top": "0px",
    });
  }
  
}

var show_sticky_top_menu;
$(document).ready(function() {
  var windowWidth = window.innerWidth || document.documentElement.clientWidth;

  if (windowWidth<480 && ($(".mobile-sticky").length>=1 && $(".mobile-sticky").outerHeight()>0)){
    h=$(".mobile-sticky").outerHeight();
    $(".tygh-footer").css({
      "padding-bottom": h + "px",
    });
  }

  hashname = window.location.hash.replace('#', '');
  elem = $('#' + hashname);
  if(hashname.length > 1) {
    var et_offset=0;
    if ($('.et-vendor-store-menu-wrapper').length){
      et_offset=$('.et-vendor-store-menu-wrapper').height();
    }
  };

  // sticky top bar
  if ($('.top-menu-grid').length==1){
    show_sticky_top_menu=$('.top-menu-grid').offset().top+$('.top-menu-grid').height();
  }else{
    show_sticky_top_menu=200;
  }

  $(window).resize(function(){
    if ($('.top-menu-grid').length==1){
      show_sticky_top_menu=$('.top-menu-grid').offset().top+$('.top-menu-grid').height();
    }else{
      show_sticky_top_menu=200;
    }
  });
  // show_sticky_top_menu=500;
  if ($('.et-sticky-header').length){
    $(window).scroll(function(){
      et_sticky_header();
    });
  }

  if ($('.et-mobile-header.et-sticky').length>=1 && $('#products_view').length<1 && $('#companies_product_view').length<1){
    sticky_mobile_header=$('.et-mobile-header.et-sticky');
    start=0;
    $(window).resize(function(){
      windowWidth = window.innerWidth || document.documentElement.clientWidth;
      if (windowWidth<=1024){
        $(window).scroll(function(){
          if (start==0){
            start=sticky_mobile_header.offset().top;
          }
            et_mobile_sticky_header(start);
        });
      }
    })
    if (windowWidth<=1024){
      $(window).scroll(function(){
        if (start==0){
          start=sticky_mobile_header.offset().top;
        }
          et_mobile_sticky_header(start);
      });
    }
  }


  product_page=$('#et-product-page');
  if(typeof(product_page) != "undefined" && product_page.length==1){
    product_page_scripts();
  }



});
//start stop carousels

$(document).ready(function() {
  $(window).scroll(function(){
    stopped=$('.owl-carousel.stopped');
    if (stopped.length!==undefined && stopped.length>=1){
      $(stopped).each(function(){
        self=$(this);
        if (self.visible(true)){
          delay=self.data("delay");
          self.removeClass('stopped');
          self.trigger('owl.play',delay);
        }
      })
    }
  });
})

var lazy_images;
(function() {
  if (typeof($(".et-subcategs"))!==undefined && $(".et-subcategs").length){

    $(".et-subcategs").on('scroll', function(e) {
      $(".et-subcategs .ty-subcategories__item").each(function(){
        self=$(this);
        if (self.visible(true)){
          self.addClass('active');
        }else{
          self.removeClass('active');
        }
      })

      $(".et-subcategs .active .etLazy").each(function(){
        img=$(this);
        if (img.visible(true)){
          img.one('load', function() {

              img.removeAttr("data-src");
              img.removeClass("etLazy");
              img.addClass("et_js");
              
              img.removeAttr("style");
              return;
          }).attr('src', img.data("src"))
          .each(function() {
            //Cache fix for browsers that don't trigger .load()
            if(this.complete) $(this).trigger('load');
          });
        }
      });
    });
  }

  if (typeof($(".et-side-featured-items"))!==undefined && $(".et-side-featured-items").length){
    $(".et-side-featured-items .et-link-thumb__wrapper").each(function(){
      if ($(this).data('allLazyLoaded')!=true){
        $(this).on('scroll', function(e) {
          if ($(".etLazy",this).length){
            $(".et-link-thumb__inner-wrapper",this).each(function(){
              self=$(this);
              if (self.visible(true)){
                self.addClass('active');
              }else{
                self.removeClass('active');
              }
            })

            $(".active .etLazy",this).each(function(){
              img=$(this);
              if (img.visible(true)){
                img.one('load', function() {
                    img.removeAttr("data-src");
                    img.removeClass("etLazy");
                    img.addClass("et_js");
                    
                    img.removeAttr("style");
                    return;
                }).attr('src', img.data("src"))
                .each(function() {
                  //Cache fix for browsers that don't trigger .load()
                  if(this.complete) $(this).trigger('load');
                });
              }
            });
          }else{
            $(".et-link-thumb__inner-wrapper",this).removeClass('active');
            $(this).data('allLazyLoaded',true);
          }
        });
      }
    });
  }

  if (typeof($(".et-featured-vendor-sidebar"))!==undefined && $(".et-featured-vendor-sidebar").length){
    $(".et-featured-vendor-sidebar").each(function(){
      if ($(this).data('allLazyLoaded')!=true){
        $(this).on('scroll', function(e) {
          if ($(".etLazy",this).length){
            $(".et-vendor-box__wrapper",this).each(function(){
              self=$(this);
              if (self.visible(true)){
                self.addClass('active');
              }else{
                self.removeClass('active');
              }
            })

            $(".active .etLazy",this).each(function(){
              img=$(this);
              if (img.visible(true)){
                img.one('load', function() {
                    img.removeAttr("data-src");
                    img.removeClass("etLazy");
                    img.addClass("et_js");
                    
                    img.removeAttr("style");
                    return;
                }).attr('src', img.data("src"))
                .each(function() {
                  //Cache fix for browsers that don't trigger .load()
                  if(this.complete) $(this).trigger('load');
                });
              }
            });
          }else{
            $(".et-vendor-box__wrapper",this).removeClass('active');
            $(this).data('allLazyLoaded',true);
          }
        });
      }
    })
  }
}(Tygh, Tygh.$));

function throttle (callback, limit) {
    var wait = false;                  // Initially, we're not waiting
    return function () {               // We return a throttled function
        if (!wait) {                   // If we're not waiting
            callback.call();           // Execute users function
            wait = true;               // Prevent future invocations
            setTimeout(function () {   // After a period of time
                wait = false;          // And allow future invocations
            }, limit);
        }
    }
}

$(document).ready(function() {
  lazy_images=$('.lazy,.etLazy,.etLazyBanner');
  et_scroll_lazy_images(lazy_images);
  $(window).scroll(function(){
    et_scroll_lazy_images(lazy_images);
  });
});

(function(_, $) {
  $.ceEvent('on', 'ce.ajaxdone', function(context) {
    lazy_images=$('.lazy,.etLazy,.etLazyBanner');
    et_scroll_lazy_images(lazy_images);
    if (typeof($(".et-gift-certificate-picker"))!==undefined && $(".et-gift-certificate-picker").length){
      gcp_to = setInterval(function(){
        et_scroll_lazy_images(lazy_images);
        $(".et-gift-certificate-picker .object-container").off('scroll');
        $(".et-gift-certificate-picker .object-container").scroll(function(){
          et_scroll_lazy_images(lazy_images);
        });
        clearInterval(gcp_to);
      },500);
    }
  });
}(Tygh, Tygh.$));

function et_scroll_lazy_images(lazy_images){
  $(lazy_images).each(function(){
    et_self=$(this);
    if (et_self.visible(true) && et_self.is(":visible")){
      if (et_self.hasClass("lazy")){

        et_self.removeClass("lazy");

      }else if (et_self.hasClass("etLazy")) {
        var img=$(this);
        img.one('load', function() { 
            if (img.data("srcset")){
              img.attr("srcset",img.data("srcset"));
              img.removeAttr("data-srcset");
            }
            img.removeAttr("data-src");
            img.removeClass("etLazy");
            img.addClass("et_js");
            
            img.removeAttr("style");
            return;
        }).attr('src', img.data("src"))
        .each(function() {
          //Cache fix for browsers that don't trigger .load()
          if(this.complete) $(this).trigger('load');
        });
        
      }else if (et_self.hasClass("etLazyBanner")) {
        var img=$(this);
        img.one('load', function() { 
            if (img.data("srcset")){
              img.attr("srcset",img.data("srcset"));
              img.removeAttr("data-srcset");
            }
            img.removeAttr("data-src");
            img.removeClass("etLazyBanner");
            img.removeClass(img.data("etLazyId"));
            return;
        }).attr('src', img.data("src"))
        .each(function() {
          //Cache fix for browsers that don't trigger .load()
          if(this.complete) $(this).trigger('load');
        });
      }
    }
  })
}


function product_page_scripts(){
  container=$(".et-product-image-wrapper");
  container_width=$(".et-product-image-wrapper").width();
  if (windowWidth>480){
    container.css({
      "width": container_width + "px",
    })
  }

  wrapper=$(".ty-product-block__wrapper");
  wrapper_outer_height=wrapper.height();
  wrapper_bottom=wrapper.offset().top+wrapper_outer_height;

  images=$(".ty-product-block__img");
  images_initial_top=images.offset().top;
  images_height=images.outerHeight();
  images_stop = wrapper_bottom - images_height;
  images_parent=$(".et-left-wrapper");
  images_parent=$(".et-left-wrapper");
  descr_height=0;

  vendor=$(".et-product-right-inner");
  if (vendor.length==1){
    vendor_initial_top=vendor.offset().top;
    vendor_height=vendor.outerHeight();
    vendor_stop = wrapper_bottom - vendor_height;
    vendor_parent=$(".et-left-wrapper");
    vendor_parent_height=vendor_parent.height();
  }

  if (windowWidth>480){

    if ($(".et-product-page-big").length>=1){
      descr=$(".et-pp-info>form");
      descr_wrapper=$(".et-pp-info");
      descr_height=descr.outerHeight();
     
    }else{
      descr=$(".et-pp-info-inner-wrapper");
      descr_initial_top=descr.offset().top;
      descr_height=descr.outerHeight();
      if (images_height>descr_height){
        descr_stop = wrapper_bottom - images_height;
      }else{
        descr_stop = wrapper_bottom - descr_height;
      }
      descr_parent=$(".et-left-wrapper");
    }

  }


  $(window).scroll(function(){
    wrapper_outer_height=wrapper.height();
    if (typeof(wrapper)!==undefined && wrapper.length){
    wrapper_bottom=wrapper.offset().top+wrapper_outer_height;
    
    images_stop = wrapper_bottom - images_height;
    images_parent_height=images_parent.height();

    if (images_height>descr_height && windowWidth>480){
      descr_stop = wrapper_bottom - images_height;
    }else{
      descr_stop = wrapper_bottom - descr_height;
    }
      if (typeof(descr)!==undefined && descr.length){
    descr_parent_height=descr_parent.height();
    
    if (vendor.length==1){
      vendor_height=vendor.outerHeight();
      vendor_stop = wrapper_bottom - vendor_height+10;

      vendor_parent_height=vendor_parent.height();
    }
      }
    }

  });

}
$(document).ready(function(){
  if (typeof($) != "function"){var $=Tygh.$;}
  realign_pp();

});


function realign_pp(){
  if (typeof($(".ty-product-block__wrapper"))!==undefined && $(".ty-product-block__wrapper").length){
    container=$(".et-product-image-wrapper");
    container_width=$(".et-product-image-wrapper").width();
    if (windowWidth>480){
      container.css({
        "width": container_width + "px",
      })
    }
    wrapper=$(".ty-product-block__wrapper");


    wrapper_outer_height=wrapper.height();
    wrapper_bottom=wrapper.offset().top+wrapper_outer_height;

    images=$(".ty-product-block__img");
    images_initial_top=images.offset().top;
    images_height=images.outerHeight();
    images_stop = wrapper_bottom - images_height;
    images_parent=$(".et-left-wrapper");
    images_parent=$(".et-left-wrapper");

    vendor=$(".et-product-right-inner");
    if (vendor.length==1){
      vendor_initial_top=vendor.offset().top;
      vendor_height=vendor.outerHeight();
      vendor_stop = wrapper_bottom - vendor_height;
      vendor_parent=$(".et-left-wrapper");
      vendor_parent_height=vendor_parent.height();
    }

    descr=$(".et-pp-info-inner-wrapper");
    if (typeof(descr)!==undefined && descr.length){
    descr_initial_top=descr.offset().top;
    descr_height=descr.outerHeight();
    if (images_height>descr_height && windowWidth>480){
      descr_stop = wrapper_bottom - images_height;
    }else{
      descr_stop = wrapper_bottom - descr_height;
    }
    descr_parent=$(".et-left-wrapper");
    

    wrapper_outer_height=wrapper.height();
    wrapper_bottom=wrapper.offset().top+wrapper_outer_height;
    
    images_stop = wrapper_bottom - images_height;
    images_parent_height=images_parent.height();

    if (windowWidth>480){
      if (images_height>descr_height){
        descr_stop = wrapper_bottom - images_height;
      }else{
        descr_stop = wrapper_bottom - descr_height;
      }
      descr_parent_height=descr_parent.height();
      
      if (vendor.length==1){
        vendor_height=vendor.outerHeight();
        vendor_stop = wrapper_bottom - vendor_height+10;

        vendor_parent_height=vendor_parent.height();
      }
      }
    }
  }

  var sticky_header_height = 0;
  var first_offset=0;
  var timeout;
  var timeout2;
  var timeout3;
  var timeout4;
  var t_runing;

  function sticky_elem(elem,top,stop,is_first,elm_parent,elm_parent_height,debug){
    if (is_first === undefined){
      is_first=false;
    }
    if (debug === undefined){
      debug=false;
    }
    window_top = $(window).scrollTop();
    if ($('.et-sticky-header').length==1 && $('.et-sticky-header').visible()){
      sticky_header = $('.et-sticky-header');
    }else{
      sticky_header = $('.et-vendor-store-menu');
    }
    spacing=10;
    spacing=0;
    if (debug){

    }

    if(sticky_header.length==1){
      sticky_header_height = sticky_header.height()+spacing;
      sticky_top = sticky_header.position().top;

      if (window_top>show_sticky_top_menu){
        window_top=window_top+sticky_header_height;
      }

    }else{
      sticky_header_height = spacing;
    }
    if (window_top>=stop && !elem.hasClass("et-sticky-pp-bottom")){
      w=elem.parent().width();
      elem.css({
        "width": w + "px"
      });
      elem.addClass('et-sticky-pp et-sticky-pp-bottom zxc');
      t=elem.position().top;
      elem.css({
        'top': t+'px'
      });
    }
    
    if (window_top >= top && window_top<stop) {
      if (!elem.hasClass("et-sticky-pp")){
        w=elem.parent().width();
        elem.css({
          "width": w + "px"
        });
        elm_parent.css({
          "height": elm_parent_height + "px"
        });

        elem.addClass('et-sticky-pp');
        elem.addClass('no-trans');

        if(
            sticky_header.hasClass("et-sticky-visible") && 
            !sticky_header.hasClass("et-animating")
          ){
          elem.css({
            top: sticky_header_height+'px'
          });
        }else{
          elem.css({
            top: spacing+'px'
          });
        }
        setTimeout(function(){
          elem.removeClass('no-trans');
        },0);
        if (window_top>show_sticky_top_menu){
          setTimeout(function(){
            elem.css({
              top: sticky_header_height+'px'
            });
          },0);
        }
      }else if (window_top>=stop && !elem.hasClass("et-sticky-pp-bottom")){
        elem.addClass('et-sticky-pp et-sticky-pp-bottom');
        t=elem.position().top;
        elem.css({
          'top': t+'px'
        });

      }else if (window_top<stop && elem.hasClass("et-sticky-pp-bottom")){
        elem.removeClass('et-sticky-pp-bottom');
        elem.css({
          top: sticky_header_height+'px'
        });

      }else if (!elem.hasClass("et-sticky-pp-bottom")){
        if (
          sticky_header.hasClass("et-sticky-visible") && 
          !sticky_header.hasClass("et-animating")
          ){
          elem.addClass('no-trans');
        
          elem.css({
            top: sticky_header_height+'px'
          });
          elem.removeClass('no-trans');
        }
      }

    }else if (elem.hasClass("et-sticky-pp")){
        elem.removeClass("et-sticky-pp et-sticky-pp-bottom");
        elem.css({
          'top': 'auto'
        });
    }
  }
}

// lazy load
function startLoadImg(img){
  if (typeof($) != "function"){var $=Tygh.$;}
  $(img).one('load', function() {
      $(img).fadeIn(); 
      img.removeAttr("data-src");
      $(img).removeAttr("style");

      img.removeClass("et_lazy_mobile");
  }).attr('src', img.data("src")).each(function() {
    //Cache fix for browsers that don't trigger .load()
    if(this.complete) {
      $(this).trigger('load');
    }
  });
}

var lazy_img=null;
$(function(){
  if (typeof($) != "function"){var $=Tygh.$;}
  lazy_img=$('.et_lazy_mobile');
});

$(document).ready(function(){
  if (typeof($) != "function"){var $=Tygh.$;}
  if (lazy_img!=null){
  lazy_img.each(function(i, el) {
    var el = $(el);
      startLoadImg($(this));
  });
  }
});



function et_adjust_spacing(element,prop,data,ratio){
  orig_value=element.data(data);

  if (orig_value){
    current_value=orig_value;
  }else{
    current_value=element.css(prop);
  }
  if (parseFloat(current_value)>0){
    new_value=parseFloat(current_value)*ratio;
    if (new_value>0){
      element.css(prop, new_value+"px");
      element.data(data, current_value);
    }
  }
}


function banner_original_styles(e){
  recall=$('.et-extended-banner',e).data('etOrigStyle');

  if (recall==true){

    var text_wrapper=$(".banner-text-wrapper",e);
    text_wrapper_os=text_wrapper.data('etOrigStyle');
    text_wrapper.attr('style',text_wrapper_os);

    var inner_wrapper=$(".banner-text-inner-wrapper",e);
    inner_wrapper_os=inner_wrapper.data('etOrigStyle');
    inner_wrapper.attr('style',inner_wrapper_os);

    var image_wrapper=$(".et-additional-image",e);
    image_wrapper_os=image_wrapper.data('etOrigStyle');
    image_wrapper.attr('style',image_wrapper_os);

    var title=$(".et-title",e);
    title_os=title.data('etOrigStyle');
    title.attr('style',title_os);

    var description=$(".et-description",e);
    description_os=description.data('etOrigStyle');
    description.attr('style',description_os);

    var button=$(".ty-btn",e);
    button_os=button.data('etOrigStyle');
    button.attr('style',button_os);

    $(".ty-pict",e).removeAttr('style');
    $(".et-img-bkg_wrapper",e).removeAttr('style');

  }else{

    var text_wrapper=$(".banner-text-wrapper",e);
    text_wrapper_os=text_wrapper.attr('style');
    text_wrapper.data('etOrigStyle',text_wrapper_os);

    var inner_wrapper=$(".banner-text-inner-wrapper",e);
    inner_wrapper_os=inner_wrapper.attr('style');
    inner_wrapper.data('etOrigStyle',inner_wrapper_os);

    var image_wrapper=$(".et-additional-image",e);
    image_wrapper_os=image_wrapper.attr('style');
    image_wrapper.data('etOrigStyle',image_wrapper_os);

    var title=$(".et-title",e);
    title_os=title.attr('style');
    title.data('etOrigStyle',title_os);

    var description=$(".et-description",e);
    description_os=description.attr('style');
    description.data('etOrigStyle',description_os);

    var button=$(".ty-btn",e);
    button_os=button.attr('style');
    button.data('etOrigStyle',button_os);


    $('.et-extended-banner',e).data('etOrigStyle',true);
  }
}

// et - banner resize
function banner_resize(){
  var windowWidth = window.innerWidth || document.documentElement.clientWidth;
  var body_width=$('body').width();

  $(".et-pro-banner").each(function(){
    var container_width=$(this).width();
    if (container_width!=0){
      prev_width_data=$(this).data("prevWidth");
      current_width=Math.floor($(this).width());

      original_width=$(".et-banner-container",this).data('etWidth');
      
      
      if (original_width!=current_width){
      }else{
        banner_original_styles(this);
        $(this).data("prevWidth",current_width);
      }
      if (typeof(prev_width_data) == "undefined" || prev_width_data!=current_width){
        $(this).data("prevWidth",current_width);
      
        
        if ($(this).hasClass('et-pro-banner-full') || body_width==container_width){
          var original_width=-1;
          var resize=true;
          var resize_bkg=true;
        }else{
          var original_width=$(this).data('container_width');
         
          if (typeof(original_width) != "undefined" && original_width !== null && container_width<original_width){
            var resize=true;
            var resize_bkg=true;
          }else{
            $(this).data('container_width',container_width);
            var resize=false;
          }
        }

        var text_position_T;
        $('.ty-banner__image-item',this).each(function(){
          if ($(".et-banner-container",this).hasClass('et-banner-phone') || $(".et-banner-container",this).hasClass('et-banner-tablet')){
            return true;
          }
          if (resize_bkg){
            if (original_width==-1){
              original_width=$(".et-banner-container",this).data('etWidth');
            }
              var bkg=$(".et-img-bkg_wrapper",this);
              var bkg_h=bkg.data('etHeight');
              var bkg_w=bkg.data('etWidth');
              var ratio=container_width/original_width;
              var new_bkg_h=bkg_h*ratio;
              bkg.css("height", new_bkg_h+"px");
          }
          
          if (resize){
            var sizeT=$(".et-title",this).data('etFs');
            var sizeD=$(".et-description",this).data('etFs');
            var sizeB=$(".et-btn .ty-btn",this).data('etFs');
            var img=$(".et-additional-image-wrapper",this).data('etSize');

            var text_outer_wrapper_H=$(".banner-text-outer-wrapper",this).height();
            var text_outer_wrapper_W=$(".banner-text-outer-wrapper",this).width();
            var ratio=container_width/original_width;
            var new_sizeT=sizeT*ratio;
            var new_sizeD=sizeD*ratio;
            var new_sizeB=sizeB*ratio;
            var text_wrapper=$(".banner-text-wrapper",this);

            et_adjust_spacing(text_wrapper,"margin-top","orig_margin_top",ratio);
            et_adjust_spacing(text_wrapper,"margin-right","orig_margin_right",ratio);
            et_adjust_spacing(text_wrapper,"margin-bottom","orig_margin_bottom",ratio);
            et_adjust_spacing(text_wrapper,"margin-left","orig_margin_left",ratio);
            if (text_wrapper.data('etWidth')){
              et_adjust_spacing(text_wrapper,"width","etWidth",ratio);
            }

            var inner_wrapper=$(".banner-text-inner-wrapper",this);
            et_adjust_spacing(inner_wrapper,"padding-top","orig_padding_top",ratio);
            et_adjust_spacing(inner_wrapper,"padding-right","orig_padding_right",ratio);
            et_adjust_spacing(inner_wrapper,"padding-bottom","orig_padding_bottom",ratio);
            et_adjust_spacing(inner_wrapper,"padding-left","orig_padding_left",ratio);

            var image_wrapper=$(".et-additional-image",this);
            et_adjust_spacing(image_wrapper,"margin-top","orig_margin_top",ratio);
            et_adjust_spacing(image_wrapper,"margin-right","orig_margin_right",ratio);
            et_adjust_spacing(image_wrapper,"margin-bottom","orig_margin_bottom",ratio);
            et_adjust_spacing(image_wrapper,"margin-left","orig_margin_left",ratio);

            var title=$(".et-title",this);
            et_adjust_spacing(title,"padding-top","orig_padding_top",ratio);
            et_adjust_spacing(title,"padding-right","orig_padding_right",ratio);
            et_adjust_spacing(title,"padding-bottom","orig_padding_bottom",ratio);
            et_adjust_spacing(title,"padding-left","orig_padding_left",ratio);

            var description=$(".et-description",this);
            et_adjust_spacing(description,"padding-top","orig_padding_top",ratio);
            et_adjust_spacing(description,"padding-right","orig_padding_right",ratio);
            et_adjust_spacing(description,"padding-bottom","orig_padding_bottom",ratio);
            et_adjust_spacing(description,"padding-left","orig_padding_left",ratio);

            var button=$(".ty-btn",this);
            et_adjust_spacing(button,"margin-top","orig_margin_top",ratio);
            et_adjust_spacing(button,"margin-right","orig_margin_right",ratio);
            et_adjust_spacing(button,"margin-bottom","orig_margin_bottom",ratio);
            et_adjust_spacing(button,"margin-left","orig_margin_left",ratio);

            et_adjust_spacing(button,"padding-top","orig_padding_top",ratio);
            et_adjust_spacing(button,"padding-right","orig_padding_right",ratio);
            et_adjust_spacing(button,"padding-bottom","orig_padding_bottom",ratio);
            et_adjust_spacing(button,"padding-left","orig_padding_left",ratio);

            if (new_sizeT>10){
              $(".et-title",this).css("font-size", new_sizeT+"px");
            }
            if (new_sizeD>10){
              $(".et-description",this).css("font-size", new_sizeD+"px");
            }
            if (new_sizeB>10){
              $(".et-btn .ty-btn",this).css("font-size", new_sizeB+"px");
            }
            if (typeof(img) != "undefined" && img !== null){
              var new_img=img*ratio;
              $(".ty-pict",this).css("width", new_img+"px");
            }
          }

       });
      }

      $(this).css('opacity', 1);
    }else{
    }
    
  })
}
(function(_, $) {
  $(document).ready(function(){
    $( window ).resize(function() {
      banner_resize();
    });
  });
}(Tygh, Tygh.$));


(function(_,$) {

    $.fn.menuAim = function(opts) {
        // Initialize menu-aim for all elements in jQuery collection
        this.each(function() {
            init.call(this, opts);
        });

        return this;
    };

    function init(opts) {
        var $menu = $(this),
            activeRow = null,
            mouseLocs = [],
            lastDelayLoc = null,
            timeoutId = null,
            options = $.extend({
                rowSelector: "> li",
                submenuSelector: "*",
                submenuDirection: "right",
                tolerance: 75,  // bigger = more forgivey when entering submenu
                enter: $.noop,
                exit: $.noop,
                activate: $.noop,
                deactivate: $.noop,
                exitMenu: $.noop
            }, opts);

        var MOUSE_LOCS_TRACKED = 3,  // number of past mouse locations to track
            DELAY = 300;  // ms delay when user appears to be entering submenu

        /**
         * Keep track of the last few locations of the mouse.
         */
        var mousemoveDocument = function(e) {
                mouseLocs.push({x: e.pageX, y: e.pageY});

                if (mouseLocs.length > MOUSE_LOCS_TRACKED) {
                    mouseLocs.shift();
                }
            };

        /**
         * Cancel possible row activations when leaving the menu entirely
         */
        var mouseleaveMenu = function() {
                if (timeoutId) {
                    clearTimeout(timeoutId);
                }

                // If exitMenu is supplied and returns true, deactivate the
                // currently active row on menu exit.
                if (options.exitMenu(this)) {
                    if (activeRow) {
                        options.deactivate(activeRow);
                    }

                    activeRow = null;
                }
            };

        /**
         * Trigger a possible row activation whenever entering a new row.
         */
        var mouseenterRow = function() {
                if (timeoutId) {
                    // Cancel any previous activation delays
                    clearTimeout(timeoutId);
                }

                options.enter(this);
                possiblyActivate(this);
            },
            mouseleaveRow = function() {
                options.exit(this);
            };

        /*
         * Immediately activate a row if the user clicks on it.
         */
        var clickRow = function() {
                activate(this);
            };

        /**
         * Activate a menu row.
         */
        var activate = function(row) {
                if (row == activeRow) {
                    return;
                }

                if (activeRow) {
                    options.deactivate(activeRow);
                }

                options.activate(row);
                activeRow = row;
            };

        /**
         * Possibly activate a menu row. If mouse movement indicates that we
         * shouldn't activate yet because user may be trying to enter
         * a submenu's content, then delay and check again later.
         */
        var possiblyActivate = function(row) {
                var delay = activationDelay();

                if (delay) {
                    timeoutId = setTimeout(function() {
                        possiblyActivate(row);
                    }, delay);
                } else {
                    activate(row);
                }
            };

        /**
         * Return the amount of time that should be used as a delay before the
         * currently hovered row is activated.
         *
         * Returns 0 if the activation should happen immediately. Otherwise,
         * returns the number of milliseconds that should be delayed before
         * checking again to see if the row should be activated.
         */
        var activationDelay = function() {
                if (!activeRow || !$(activeRow).is(options.submenuSelector)) {
                    // If there is no other submenu row already active, then
                    // go ahead and activate immediately.
                    return 0;
                }

                var offset = $menu.offset(),
                    upperLeft = {
                        x: offset.left,
                        y: offset.top - options.tolerance
                    },
                    upperRight = {
                        x: offset.left + $menu.outerWidth(),
                        y: upperLeft.y
                    },
                    lowerLeft = {
                        x: offset.left,
                        y: offset.top + $menu.outerHeight() + options.tolerance
                    },
                    lowerRight = {
                        x: offset.left + $menu.outerWidth(),
                        y: lowerLeft.y
                    },
                    loc = mouseLocs[mouseLocs.length - 1],
                    prevLoc = mouseLocs[0];

                if (!loc) {
                    return 0;
                }

                if (!prevLoc) {
                    prevLoc = loc;
                }

                if (prevLoc.x < offset.left || prevLoc.x > lowerRight.x ||
                    prevLoc.y < offset.top || prevLoc.y > lowerRight.y) {
                    // If the previous mouse location was outside of the entire
                    // menu's bounds, immediately activate.
                    return 0;
                }

                if (lastDelayLoc &&
                        loc.x == lastDelayLoc.x && loc.y == lastDelayLoc.y) {
                    // If the mouse hasn't moved since the last time we checked
                    // for activation status, immediately activate.
                    return 0;
                }

                // Detect if the user is moving towards the currently activated
                // submenu.
                //
                // If the mouse is heading relatively clearly towards
                // the submenu's content, we should wait and give the user more
                // time before activating a new row. If the mouse is heading
                // elsewhere, we can immediately activate a new row.
                //
                // We detect this by calculating the slope formed between the
                // current mouse location and the upper/lower right points of
                // the menu. We do the same for the previous mouse location.
                // If the current mouse location's slopes are
                // increasing/decreasing appropriately compared to the
                // previous's, we know the user is moving toward the submenu.
                //
                // Note that since the y-axis increases as the cursor moves
                // down the screen, we are looking for the slope between the
                // cursor and the upper right corner to decrease over time, not
                // increase (somewhat counterintuitively).
                function slope(a, b) {
                    return (b.y - a.y) / (b.x - a.x);
                };

                var decreasingCorner = upperRight,
                    increasingCorner = lowerRight;

                // Our expectations for decreasing or increasing slope values
                // depends on which direction the submenu opens relative to the
                // main menu. By default, if the menu opens on the right, we
                // expect the slope between the cursor and the upper right
                // corner to decrease over time, as explained above. If the
                // submenu opens in a different direction, we change our slope
                // expectations.
                if (options.submenuDirection == "left") {
                    decreasingCorner = lowerLeft;
                    increasingCorner = upperLeft;
                } else if (options.submenuDirection == "below") {
                    decreasingCorner = lowerRight;
                    increasingCorner = lowerLeft;
                } else if (options.submenuDirection == "above") {
                    decreasingCorner = upperLeft;
                    increasingCorner = upperRight;
                }

                var decreasingSlope = slope(loc, decreasingCorner),
                    increasingSlope = slope(loc, increasingCorner),
                    prevDecreasingSlope = slope(prevLoc, decreasingCorner),
                    prevIncreasingSlope = slope(prevLoc, increasingCorner);

                if (decreasingSlope < prevDecreasingSlope &&
                        increasingSlope > prevIncreasingSlope) {
                    // Mouse is moving from previous location towards the
                    // currently activated submenu. Delay before activating a
                    // new menu row, because user may be moving into submenu.
                    lastDelayLoc = loc;
                    return DELAY;
                }

                lastDelayLoc = null;
                return 0;
            };

        /**
         * Hook up initial menu events
         */
        $menu
            .mouseleave(mouseleaveMenu)
            .find(options.rowSelector)
                .mouseenter(mouseenterRow)
                .mouseleave(mouseleaveRow)
                .click(clickRow);

        $(document).mousemove(mousemoveDocument);

    };
}(Tygh, Tygh.$));

function et_resize(old_size){
  var new_size = window.innerWidth || document.documentElement.clientWidth;
  if (
    (old_size<=480 && new_size>480)
    || (old_size<=768 && new_size>768)
    || (old_size<=1024 && new_size>1024)
    || (old_size>1024 && new_size<=1024)
    ){
    // location.reload();
  }
}

(function(_,$){
  var old_size;
  $(document).ready(function(){
    var windowWidth = window.innerWidth || document.documentElement.clientWidth;

    $(window).resize(function(){
      old_size=windowWidth;
      et_resize(old_size);
    });

  })
})(Tygh,Tygh.$);


  var menu_items,menu_total_width,items_widths,current_page=1,total_pages=1,et_show_more,menu,max_width;

  function toggle_menu_items(){
    if (et_show_more!==undefined){
      et_show_more.html("<i class='et-icon-main-menu-more'></i>");
    }
    arr=[];
    widths=$.extend(true,[],items_widths);
    page=1;
    if(current_page===total_pages){
      arr=$(menu_items.get().reverse());
      page=1;
      widths.reverse();
      if (et_show_more!==undefined){
        et_show_more.addClass('last-page');
      }
    }else{
      arr=menu_items;
      page=current_page;
      if (et_show_more!==undefined){
        et_show_more.removeClass('last-page');
      }
    }

    var sum=0;
    arr.each(function(i){
      var self=$(this);
      sum+=widths[i];

      if(page>1 && sum>max_width){
        sum=widths[i];
        page-=1;

        self.removeClass('et_hide');
        self.show();
      }else if(page>1||sum>max_width){

        self.addClass('et_hide');
        self.hide();
      }else{

        self.removeClass('et_hide');
        self.show();
      }
    });
  }

  function et_menu_resize(et_menu){

    if (et_menu.hasClass("et-main-menu")){
      wrapper=$('.et-main-menu-wrapper');
      menu_wrapper=$('.et-main-menu',wrapper);
      menu=$('.ty-menu__items',menu_wrapper);
      menu_items=$(".et-main-menu-lev-1",menu);
      menu_wrapper_width=menu_wrapper.width();
      wrapper_width=wrapper.width();
    }else if (et_menu.hasClass("et-vendor-store-menu-inner")){
      wrapper=$(".et-vendor-store-menu .et-vendor-menu");
      menu_wrapper=wrapper.parent();
      menu=wrapper;
      menu_items=$('.et-vendor-menu-item',menu_wrapper);
      menu_wrapper_width=wrapper.width();
      wrapper_width=et_menu.width();
    }


    if ($('.et-category-menu',wrapper)!==undefined && et_menu.hasClass("et-main-menu")){
      max_width=wrapper_width-$('.et-category-menu',wrapper).width();
    }else if (et_menu.hasClass("et-vendor-store-menu-inner")){
      if ($('.et-vendor-store-menu').hasClass('et-sticky-visible')){
        max_width=wrapper_width;
      }else{
        max_width=wrapper_width-190;
      }

    }else{
      max_width=wrapper_width;
    }
    if ($('.et-category-menu',wrapper)!==undefined || et_menu.hasClass("et-vendor-menu")){
      menu_total_width=0;
      items_widths=[];
      menu_items.each(function(i){
        var item=$(this);
        items_widths[i]=item.outerWidth(true);

        if (!(item.data('etWidth'))){
          item.data('etWidth',items_widths[i]);
        }else{
          if (item.data('etWidth')<items_widths[i]){
            item.data('etWidth',items_widths[i]);
          }else{
            items_widths[i]=item.data('etWidth');
          }
        }
        menu_total_width+=items_widths[i];
      })
      total_pages=Math.ceil(menu_total_width/max_width);
      if (total_pages>1){
        if (typeof($('.et-menu-show-more'))=="undefined" || $('.et-menu-show-more').length<1){
          menu_wrapper.append("<div class='et-menu-show-more'></div>");
        }
        et_show_more=$('.et-menu-show-more');
        et_show_more.show();
        max_width-=33;
        total_pages=Math.ceil(menu_total_width/(max_width-56));
      }else if (et_show_more!==undefined){
        et_show_more.hide();
      }

    }

    if (windowWidth>768 && max_width>0){
      toggle_menu_items();

      if (et_show_more!==undefined){
        et_show_more.unbind( "click" );
        et_show_more.click(function(){
          if(current_page===total_pages){
            current_page=1;
          }else{
            current_page+=1;
          }
          toggle_menu_items();
        });
      }
    }
    wrapper.addClass('rendered');
    menu_wrapper.removeClass('overflow-hidden');
    et_menu.removeClass('overflow-hidden');
  }

(function(_,$){
  $(document).ready(function(){
    et_menu=false;
    if ($(".et-vendor-store-menu .et-vendor-menu")!==undefined && $(".et-vendor-store-menu .et-vendor-menu").length>0){
      et_menu=$(".et-vendor-store-menu-inner");
    }else if ($(".et-main-menu")!==undefined && $('.et-main-menu').length>0){
      et_menu=$(".et-main-menu");
    }
    if (et_menu){
      et_menu.addClass('overflow-hidden');
    }
    $(window).resize(function(){
      if (et_menu){
        et_menu.addClass('overflow-hidden');
        setTimeout(et_menu_resize(et_menu),2500);
      }
    });
  })

})(Tygh,Tygh.$);

function et_close_sidemenu(){
  if ($('body').hasClass('et-left-menu-visible') || $('body').hasClass('et-right-menu-visible')){

    $('html').removeClass('et-noscroll');
    $('body').removeClass('noscroll-fixed');

      $('body').removeClass('et-left-menu-visible et-right-menu-visible'); 
      if (isiPhone()) {
        iNoBounce.disable();
      }
    menu=$('.et-menu__showing');
    menu.removeClass('et-menu__showing et-left-menu-showing et-right-menu-showing');
    menu.hide();
    setTimeout(function(){
      menu.show();
    },300);
    $('.et-dim-content.visible').removeClass('visible');
  }

}
$(window).resize(function(){
  windowWidth = window.innerWidth || document.documentElement.clientWidth;
  if (windowWidth>1024){
    et_close_sidemenu();
  }
});
