<?php
/***************************************************************************
Artur 2023
****************************************************************************/

use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');
 
function fn_my_changes_url_post( $_url, $area, $url, $protocol, $company_id_in_url, $lang_code, $locations, $storefront_id)
{

	if($_SERVER['HTTP_X_FORWARDED_FOR'] == '45.159.74.119' ||  $_SERVER['HTTP_X_FORWARDED_FOR'] == '91.103.251.13' ) {

//$aa = fn_get_seo_parent_path($object_id = 358624, $object_type = 'P', $company_id = 0, $use_caching = true);

//fn_print_r($aa);

//fn_print_die( fn_url('growers/hydroponics/grow-trays-and-stands/active-aqua-rubber-grommet-1-2-pack-of-25-en'));
// fn_print_die(fn_seo_check_redirect_url( '/growers/hydroponics/grow-trays-and-stands/active-aqua-rubber-grommet-1-2-pack-of-25-en/' ,$company_id = 64, $use_caching = true));



//$q = db_get_array("SELECT * FROM ?:seo_names ");
// $q = db_get_array("SELECT * FROM ?:seo_redirects ");
//	 fn_print_r($_url, $area, $url, $protocol, $company_id_in_url, $lang_code, $locations, $storefront_id); 
//fn_print_die($q);


	}

}
