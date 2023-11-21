/*
  FIXME: Backward compatibility
  We combined two scrollers here. Now all themes (4.0 & 4.1) work good.
*/

(function(_, $) {

  var ITEMS_COUNT_DEFAULT = 1;
  var scroller_type = 'jcarousel'; // can be 'owlcarousel' or 'jcarousel'
  // var scroller_type;

  var methods = {
    init: function() {
      var container = $(this);
      var params = {
        items_count: container.data('caItemsCount') ? container.data('caItemsCount') : ITEMS_COUNT_DEFAULT,
        items_responsive: container.data('caItemsResponsive') ? true : false
      };

      if (container.hasClass('jcarousel-skin') || container.parent().hasClass('jcarousel-skin')) {
          scroller_type = 'jcarousel';
      } else {
          scroller_type = 'owlcarousel';
      }

      if (methods.countElms(container) <= params.items_count) {
          container.removeClass('owl-carousel');
      }
      
      if (methods.countElms(container) > params.items_count || (container.hasClass('jcarousel-skin') && methods.countElms(container) > params.items_count)) {
        if (container.data('owl-carousel') || container.data('jcarousel')) {
          return true;
        }

        methods.check(container, params);
      }
      
      methods.bind(container);

      return true;
    },

    load: function(container, params) {
      if (scroller_type == 'owlcarousel') {
        if (_.language_direction == "rtl"){
            et_navigationText=['<i class="et-icon-arrow-right"></i>', '<i class="et-icon-arrow-left"></i>'];
        }else{
            et_navigationText=['<i class="et-icon-arrow-left"></i>', '<i class="et-icon-arrow-right"></i>'];
        }

        container.owlCarousel({
          // items: params.items_count,
          singleItem: params.items_count == 1 ? true : false,
          // responsive: params.items_responsive,
          items: 5,
          itemsDesktop: [1247, 3],
          itemsDesktopSmall: [1025, 5],
          itemsTablet: [768, 4],
          itemsMobile: [479, 3],
          pagination: false,
          navigation: true,
          addClassActive: true,
          navigationText: params.items_count == 1 ? ['<i class="icon-left-circle ty-icon-left-circle"></i>', '<i class="icon-right-circle ty-icon-right-circle"></i>'] : ['<i class="icon-left-open-thin ty-icon-left-open-thin"></i>', '<i class="icon-right-open-thin ty-icon-right-open-thin"></i>'],
          theme: params.items_count == 1 ? 'owl-one-theme' : 'owl-more-theme',
          beforeInit:function(){
            var containerW=$(".product-main-info").width();
            var infoW=$('.product-info').width();
            var galleryW=containerW-infoW-89;
            $(".cm-image-gallery-wrapper.vs-horizontal").css('width',galleryW);
          },
          afterInit: function(item) {
            $(item).css({'visibility':'visible', 'position':'relative'});

            var containerW=$(".product-main-info").width();
            var infoW=$('.product-info').width();
            var galleryW=containerW-infoW-89;


            $(".cm-image-gallery-wrapper.vs-horizontal").css('width',galleryW);
          }
        });
      } else {
        $('li', container).show();
        container.jcarousel({
          scroll: 1,
          // wrap: 'circular',
          animation: 'fast',
          initCallback: $.ceScrollerMethods.init_callback,
          itemFallbackDimension: params.i_width,
          item_width: params.i_width,
          item_height: params.i_height,
          clip_width: params.c_width,
          clip_height: params.c_height,
          buttonNextHTML: '<div><i class="et-icon-arrow-down"></i></div>',
          buttonPrevHTML: '<div><i class="et-icon-arrow-top"></i></div>',
          buttonNextEvent: 'click',
          buttonPrevEvent: 'click',
          size: total_size,
          // size: methods.countElms(container),
          vertical: true
        });
      }
    },

    check: function(container, params) {
      if (container.data('owl-carousel') || container.data('jcarousel')) {
        return true;
      }

      if (!params.i_width || !params.i_height) {
        var t_elm = false;

        if ($('.cm-gallery-item', container).length) {
          var load = false;

          // check images are loaded
          $('.cm-gallery-item', container).each(function() {
            var elm = $(this);
            var i_elm = $('img', elm);

            if (i_elm.length) {
              if (elm.outerWidth() >= i_elm.width()) {
                // find first loaded image
                t_elm = elm;
                return false;
              }
              load = true;
            }
          });
          if (!t_elm) {
            if (load) {
              var check_load = function() {
                methods.check(container, params);
              }
              // wait until image is loaded
              setTimeout(check_load, 500);
              return false;
            } else {
              t_elm = $('.cm-gallery-item:first', container);
            }
          }
        } else {
          t_elm = $('img:first', container);
        }

        // params.i_width = t_elm.outerWidth(true);
        // params.i_height = t_elm.height();
        params.i_width = container.data('etItemsWidth');
        params.i_height = container.data('etItemsHeight');
        // params.i_height = 87;
        margin_right = container.data('etItemsMarginRight');
        margin_bottom = container.data('etItemsMarginBottom');
        to_show = container.data('etItemsShow');
        var windowWidth = window.innerWidth || document.documentElement.clientWidth;
        if (windowWidth<=1366){
          to_show = to_show-1;
        }
        size_show=to_show/params.items_count;
        total_size=Math.ceil(methods.countElms(container)/params.items_count);

        params.c_height = (params.i_height+margin_bottom) * size_show-margin_bottom;
        params.c_width = ((params.i_width+margin_right) * params.items_count);                
        // params.c_width = ((params.i_width+margin_right) * params.items_count)-(margin_right*(params.items_count-1));
        // params.i_width

        if (scroller_type == 'owlcarousel') {
          container.closest('.cm-image-gallery-wrapper').width(params.c_width);
        }
      }

      return methods.load(container, params);
    },

    bind: function(container) {
      container.click(function(e) {
        var jelm = $(e.target);
        var pjelm;

        // Check elm clicking
          var in_elm = jelm.parents('.cm-item-gallery') || jelm.parents('div.cm-thumbnails-mini') ? true : false;
        
        if (in_elm && !jelm.is('img')) { // Check if the object is image or SWF embed object or parent is SWF-container
          return false;
        }

        if (jelm.hasClass('cm-thumbnails-mini') || (pjelm = jelm.parents('a:first.cm-thumbnails-mini'))) {
          jelm = (pjelm && pjelm.length) ? pjelm : jelm;

          var image_box = $('.cm-preview-wrapper:first');

          $(image_box).trigger('owl.goTo', $(jelm).data('caImageOrder') || 0);

          /*$('.cm-image-previewer', image_box).each(function() {
            if ($(this).hasClass('cm-thumbnails-mini')) {
              return;
            }

            var id = $(this).prop('id');
            var c_id = jelm.data('caGalleryLargeId');
            if (id == c_id) {
              $('.cm-thumbnails-mini', container).removeClass('active');
              jelm.addClass('active');
              $(this).show();
              $('div', $(this)).show(); // Special for Flash containers
              $('#box_' + id).show();
            } else {
              $(this).hide();
              $('div', $(this)).hide(); // Special for Flash containers
              $('#box_' + id).hide();
            }
          });*/
        }
      });
    },

    countElms: function(container) {
      if (scroller_type == 'owlcarousel') {
        return $('.cm-gallery-item', container).length;
      } else {
        return $('li', container).length;
      }
    }
  };

  $.fn.ceProductImageGallery = function(method) {

    if (!$().owlCarousel) {
      var gelms = $(this);
      $.getScript('design/themes/vivashop/js/owl.carousel.min.js', function() {
        gelms.ceProductImageGallery();
      });
      return false;
    }

    if (!$().jcarousel) {
      var gelms = $(this);
      $.getScript('js/lib/jcarousel/jquery.jcarousel.js', function() {
        gelms.ceProductImageGallery();
      });
      return false;
    }

    return $(this).each(function(i, elm) {

      // These vars are local for each element
      var errors = {};

      if (methods[method]) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if ( typeof method === 'object' || ! method ) {
        return methods.init.apply(this, arguments);
      } else {
        $.error('ty.productimagegallery: method ' +  method + ' does not exist');
      }
    });
  };
})(Tygh, Tygh.$);


// $(document).ready(function() {
(function(_, $) {
  $.ceEvent('on', 'ce.commoninit', function (context) {
    if (_.language_direction == "rtl"){
        et_navigationText=['<i class="et-icon-arrow-right"></i>', '<i class="et-icon-arrow-left"></i>'];
    }else{
        et_navigationText=['<i class="et-icon-arrow-left"></i>', '<i class="et-icon-arrow-right"></i>'];
    }

    $('.cm-preview-wrapper', context).owlCarousel({
    // $('.cm-preview-wrapper').owlCarousel({
      direction: _.language_direction,
      navigation: true,
      navigationText: et_navigationText,
      theme: 'owl-one-theme',
      pagination: false,
      singleItem: true,
      addClassActive: true,
      afterInit: function (item) {
        var thumbnails = $('.cm-thumbnails-mini', item.parents('.ty-product-block__img-wrapper')),
          previewers = $('.cm-image-previewer', item.parents('.ty-product-block__img-wrapper'));

        // var thumbnails = $('.cm-thumbnails-mini', item.parents('.et-image-wrapper')),
        //     previewers = $('.cm-image-previewer', item.parents('.et-image-wrapper'));

        previewers.each(function (index, elm) {
          $(elm).data('caImageOrder', index);
        });

        thumbnails.on('click', function () {
          item.trigger('owl.goTo', $(this).data('caImageOrder') ? $(this).data('caImageOrder') : 0);
        });

        $('.cm-image-previewer.hidden', item).toggleClass('hidden', false);

        $.ceEvent('trigger', 'ce.product_image_gallery.ready');
      },
      afterMove: function (item) {
        var _parent = item.parent().parent();

        // inactive all thumbnails
        $('.cm-thumbnails-mini', _parent)
          .toggleClass('active', false);

        // active only current thumbnail
        var elmOrderInGallery = $('.active', item).index(); // order of active image in carousel
        $('[data-ca-image-order=' + elmOrderInGallery + ']', _parent)
          .toggleClass('active', true);

        if ($('.product-thumbnails.jcarousel-list-vertical').length){
            $('.product-thumbnails.jcarousel-list-vertical').jcarousel('scroll', elmOrderInGallery);
        }

        // move mini-thumbnail-gallery
        // $('.owl-carousel.cm-image-gallery', _parent)
        //   .trigger('owl.goTo', elmOrderInGallery-1);
        $('.owl-carousel.cm-image-gallery', _parent)
          .trigger('owl.goTo', elmOrderInGallery-2);

        $.ceEvent('trigger', 'ce.product_image_gallery.image_changed');
      }
    });
  });
// });
})(Tygh, Tygh.$);
