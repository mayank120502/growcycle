<?php

use Tygh\Addons\SchemesManager;
use Tygh\Addons\XmlScheme3;
use Tygh\Tygh;

defined('BOOTSTRAP') or die('Access denied');

$view = Tygh::$app['view'];

if ($mode === 'update') {
	$addon_scheme = SchemesManager::getScheme($_REQUEST['addon']);

	if ($addon_scheme instanceof XmlScheme3) {
    $id = $addon_scheme->getId();
    $et_addons=[
    	'et_mega_menu',
    	'et_vivashop_mv_functionality',
    	'et_category_banner',
    	'et_search',
    	'et_banners',
    	'et_extended_ratings',
    	'et_mega_menu_featured_products',
    	'et_featured_product_banner_tabs',
    	'et_quick_info',
    	'energothemes_license',
    	'et_vivashop_mv_seo',
    	'et_vivashop_settings',
    ];

    if (in_array($id, $et_addons)){
	    $req = $addon_scheme->getRequirements();
	    if (!$addon_scheme->checkRequirements($req)) {
	    	if (isset($req['core_edition'])){
	    		$et_cart_name=($req['core_edition']==='MULTIVENDOR')
	    			? 'Multi-Vendor' : 'CS-Cart';
	    	}else{
	    		$et_cart_name=PRODUCT_NAME;
	    	}
	    	$compatibility='<b>'.$et_cart_name.' '.PRODUCT_VERSION.'</b>';
	    	$view->assign([
    	    'compatibility' =>  $compatibility,
    	    'version_compare' =>  false ,
	    	]);
	    }else{
	    	$view->assign([
    	    'version_compare' =>  true ,
	    	]);
	    }
	  }
	}
}