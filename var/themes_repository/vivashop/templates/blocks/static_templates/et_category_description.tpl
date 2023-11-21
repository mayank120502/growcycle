{hook name="categories:view_description"}
{if $category_data.description || $runtime.customization_mode.live_editor}
  <div class="et-category-description-wrapper">
  	<div class="ty-wysiwyg-content ty-mb-s et-category-description-text" {live_edit name="category:description:{$category_data.category_id}"}>{$category_data.description nofilter}</div>
  </div>

	<script>
		//<![CDATA[
		(function() {
			var descr_wrapper=$('.et-category-description-wrapper');
			var descr=$(".et-category-description-text");
			var descr_h=$(".et-category-description-text").outerHeight(true);
			if (descr_h>50){
				descr.addClass('descr_cutoff');
				descr_wrapper.append('<a class="cutoff_text"><i class="ty-icon-down-open"></i></a><span class="fog"></span>');
				$(".cutoff_text").click(function(){
					descr=$(".et-category-description-text");
					$(".ty-icon-down-open",this).toggleClass("ty-icon-up-open");
					$(".fog").toggle();
					descr.toggleClass('show_more');
				})
			}
		})();
		//]]>
	</script>
{/if}
{/hook}
