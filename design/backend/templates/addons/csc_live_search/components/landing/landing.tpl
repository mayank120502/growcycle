<!DOCTYPE html>
<html lang="en-US" class="no-js">
<head> 
	<!-- Document Settings -->
	<meta charset="UTF-8" />
	<!-- Page Meta -->
	<title>{__("`$prefix`.landing_title")}</title>	
    <link href="{$images_dir}/favicon.ico" rel="shortcut icon" type="image/x-icon" >
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!-- Styles -->
	<link href="//fonts.googleapis.com/css?family=Open+Sans:400,400italic,700,700italic%7CRoboto+Slab:400,700" rel="stylesheet" type="text/css" />
    <link href="https://s3.eu-central-1.amazonaws.com/cs-commerce.com/csc_search_speedup/styles.css" rel="stylesheet" type="text/css" />
	<!-- Scripts -->
    {literal}
		<script data-no-defer>(function(html){html.className = html.className.replace(/\bno-js\b/,'js')})(document.documentElement);</script>
    {/literal}
        <script data-no-defer>			
			var cron_url = "{"`$prefix`.run"|fn_url}"; 
			var lang_start = "{__("start")}"; 
			var lang_pause = "{__("`$prefix`.pause")}"; 
			var lang_continue = "{__("continue")}";					            
        </script>    
   
    <script data-no-defer type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
     <script data-no-defer type="text/javascript" src="https://s3.eu-central-1.amazonaws.com/cs-commerce.com/csc_image_optimization/scripts.js"></script>
  
</head>
<body>

	<div class="wrap">
		<main id="main" class="site-main">

			<!-- Front -->
			<div id="front" class="site-front">
				<div class="inner">

					<!-- Header -->
					<header class="site-header">						
					</header>

					<section class="content">
						<h2 class="section-title">{__("`$prefix`.landing_title")}</h2>
                        
                        <h3>{__("settings")}</h3>
                        <div id="settings">
                            <div class="social-links">                            	
                              <div>
                              	{__("cls.search_on_name")}:
                              	<b>{if $options.search_on_name=="Y"}{__("yes")}{else}{__("no")}{/if}</b>
                              </div>
                              <div>
                              	{__("cls.search_on_pcode")}:
                              	<b>{if $options.search_on_pcode=="Y"}{__("yes")}{else}{__("no")}{/if}</b>
                              </div>
                              <div>
                              	{__("cls.search_on_keywords")}:
                              	<b>{if $options.search_on_keywords=="Y"}{__("yes")}{else}{__("no")}{/if}</b>
                              </div>
                              <div>
                              	{__("cls.search_on_features")}:
                              	<b>{if $options.search_on_features=="Y"}{__("yes")}{else}{__("no")}{/if}</b>
                              </div> 
                              <div>
                              	{__("cls.search_on_options")}:
                              	<b>{if $options.search_on_options=="Y"}{__("yes")}{else}{__("no")}{/if}</b>
                              </div>
                              <div>
                              	{__("`$prefix`.cluster_size")}:
                              	<b>{$options.speedup_cluster_size}</b>
                              </div>                   
                            </div>
                        </div>
                                    
                        <input type="hidden" id="objects_count" value="{$objects_count}">

						<!-- Countdown timer -->
						<div class="countdown-timer">
							<p class="subtitle">{__("`$prefix`.duration_process")}:</p>
							<div id="timer"></div>
						</div>
                        
                        <div class="progress">
                            <progress max="100" value="0"></progress>
                            <div class="progress-value"></div>
                            <div class="progress-bg"><div class="progress-bar"></div></div>
                        </div>
                        
                      
						<div class="newsletter">
							<p class="subtitle">{__("`$prefix`.click_btn_below")}</p>
							<div id="newsletter-form-wrap" class="newsletter-form-wrap">								
									<p class="form-submit">
										<input type="submit" name="newsletter_submit" id="newsletter-submit" onClick="fn_trigger_pause()" value="{__("start")}" />
									</p>
								
								<div id="newsletter-response"></div>
							</div>
						</div>
                        <div class="back_to_admin">                           
                           <div class="btn_bck_info">({__("`$prefix`.process_will_be_stopped")})</div>
                        </div>
						
					</section>                    
                   
				</div><!-- .inner -->
			</div><!-- .site-front -->
			<!-- Modal (About Us) -->
			<div id="modal" class="site-modal">
				<div class="modal-scrollable">
					<div class="inner">

						<!-- Modal toggle -->
						<div class="modal-toggle">
							<button id="modal-close"><span class="screen-reader-text">{__("close")}</span><span aria-hidden="true" class="icon-plus"></span></button>
						</div>

						<section class="content">
							<h2 class="section-title">{__("`$prefix`.finished_success")}</h2>
						</section>

					</div><!-- .inner -->
				</div><!-- .modal-scrollable -->
			</div><!-- .site-modal -->			

		</main><!-- .site-main -->
	</div><!-- .wrap -->
	<!-- Background overlay -->
	<div class="overlay"></div>

	<!-- Loading... -->
	<div id="preload">
		<div id="preload-content">
			<div class="preload-spinner">
				<span class="bounce1"></span>
				<span class="bounce2"></span>
				<span class="bounce3"></span>
			</div>
			<div class="preload-text">{__('loading')}...</div>
		</div>
	</div> 
<script data-no-defer>
	var working=true;
	var paused=true;
	(function($) {
		$(document).ready(function() {
			// Background images
			images_bgs = [];
			var i;
			for (i = 1; i <= 24; i++) {
			  images_bgs[i-1]='https://s3.eu-central-1.amazonaws.com/cs-commerce.com/csc_search_speedup/images/background-' + i + '.jpg';
			}
			images_bgs = fn_csc_shuffle(images_bgs);
			
			$.backstretch(images_bgs, {
				fade: 3000,
				duration: 15000
			});
		});					
	})(jQuery);
	function fn_csc_shuffle(array) {
	  var currentIndex = array.length, temporaryValue, randomIndex;	
	  while (0 !== currentIndex) {
		randomIndex = Math.floor(Math.random() * currentIndex);
		currentIndex -= 1;	
		temporaryValue = array[currentIndex];
		array[currentIndex] = array[randomIndex];
		array[randomIndex] = temporaryValue;
	  }	
	  return array;
	}
	
	function fn_csc_run_work(){
		$.ajax({
			url: cron_url + "&from_landing=Y",
			dataType: 'json',
			success: function( data ) {
			    objects_count = parseInt($('#objects_count').val());
				
				if (data['rest_objects']){
					rest_objects = parseInt(data['rest_objects']);
					progress = Math.round(((objects_count - rest_objects)/objects_count) * 100);						
					$('.progress progress').val(progress);	
				}
							
				if (data.do_more=="Y" || !data || data.error){
					if (!paused){
						fn_csc_run_work();
					}
				}else{							
					$('#timer').countdown('pause');					
					paused=true;
					setTimeout(function(){
						$('#newsletter-submit').val(lang_start);
						$('body').addClass('modal--opened');
						saved = parseFloat($('#total_saved').data('initValue')) + parseFloat($('#total_saved b').html());
						saved = Math.round(saved * 100) / 100;
						size = 	parseFloat($('#total_size').data('initValue')) + parseFloat($('#total_size b').html());	
						size = Math.round(size * 100) / 100;				
						 $('#g_total_size b').html(size);
						 $('#g_total_saved b').html(saved);
						 $('#g_total_images b').html(parseInt($('#total_images').data('initValue')) + parseInt($('#total_images b').html()));
						 $('#g_persent b').html(parseInt((saved*100)/size));						
						$('#statistic2').html($('#statistics').html());
					}, 800);
				}
			},
			error: function( data ) {
			 	setTimeout(function(){
					fn_csc_run_work();
				}, 30000);
			}
		  });
	}
		
	function fn_trigger_pause(){			
		if (paused){				
			$('#timer').countdown('resume');
			paused=false;
			fn_csc_run_work();
			$('#newsletter-submit').val(lang_pause);	
		}else{
			$('#timer').countdown('pause');
			$('#newsletter-submit').val(lang_continue);	
			paused=true;		
		}
	}
</script>   
   
</body>
</html>