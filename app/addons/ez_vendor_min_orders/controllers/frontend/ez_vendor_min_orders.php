<?php
/*****************************
* Copyright 2021 1st Source IT, LLC
* All rights reserved.
* Permission granted for use as
* long as this copyright notice, associated text and
* links remain in tact.
* Licensed for a single domain and a single instance of EZ-cart.
* Additional licenses can be purchased for additonal sites.
*
* http://www.ez-ms.com
* http://www.ez-om.com
* http://www.1sit.com*
*
* End copyright notification
*/

/* Every addon must have this to bootstrap the ez_common addon
 */
if( !defined('BOOTSTRAP') ) die('Access denied');

use Tygh\Registry;

if( file_exists($f=ez_fix_path(Registry::get('config.dir.addons')."ez_common/lib/upgrade.php")) ) {
	require_once($f);
} else {	// Need to force update of the tools
	require_once(ez_fix_path(Registry::get('config.dir.addons')."$controller/lib/upgrade/upgrade.php"));		// copy of common version of tools - used to bootstrap the ez_common addon
}


switch($mode) {
	case 'version':
		$ez_common = 'ez_common';
		addon_init($ez_common);
		$ez_version = addon_current_version($ez_common);
		if( empty($ez_version) )
			$ez_version = "not installed or missconfigured";
		addon_init($controller);
		$version = addon_current_version($controller);
		$msg = PRODUCT_NAME.": ".PRODUCT_VERSION." ".PRODUCT_EDITION."<br/>EZ Common: $ez_version<br/>$controller: $version";
		fn_set_notification('N', "$controller.$mode", $msg, true);
		fn_redirect(Registry::get('config.customer_index'));
		break;
}
return array(CONTROLLER_STATUS_NO_PAGE);
?>