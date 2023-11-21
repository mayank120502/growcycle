<?php


if (fn_allowed_for('ULTIMATE')){
	$schema['wrappers'][__('et_mobile_menu_wrapper')] = 'blocks/grid_wrappers/et_marketplace_menu.tpl';
}else{
	$schema['wrappers'][__('et_marketplace_menu')] = 'blocks/grid_wrappers/et_marketplace_menu.tpl';
}
$schema['wrappers'][__('et_multi_scroller')] = 'blocks/grid_wrappers/et_multi_scroller.tpl';


return $schema;