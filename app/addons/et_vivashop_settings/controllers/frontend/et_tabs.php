<?php

use Tygh\BlockManager\RenderManager;
use Tygh\BlockManager\Block;
use Tygh\BlockManager\SchemesManager;

if ($mode == "et_load"){
	$params = $_REQUEST;
	if (!empty($params['block_id'])) {
		$block_id = $params['block_id'];
		$snapping_id = !empty($params['snapping_id']) ? $params['snapping_id'] : 0;

		if (!empty($params['dispatch'])) {
			$dispatch = $params['dispatch'];
		} else {
			$dispatch = !empty($_REQUEST['dispatch']) ? $_REQUEST['dispatch'] : 'index.index';
		}

		$area = !empty($params['area']) ? $params['area'] : AREA;
		if (!empty($params['dynamic_object'])) {
			$dynamic_object = $params['dynamic_object'];
		} elseif (!empty($_REQUEST['dynamic_object']) && $area != 'C') {
			$dynamic_object = $_REQUEST['dynamic_object'];
		} else {
			$dynamic_object_scheme = SchemesManager::getDynamicObject($dispatch, $area);
			if (!empty($dynamic_object_scheme) && !empty($_REQUEST[$dynamic_object_scheme['key']])) {
				$dynamic_object['object_type'] = $dynamic_object_scheme['object_type'];
				$dynamic_object['object_id'] = $_REQUEST[$dynamic_object_scheme['key']];
			} else {
				$dynamic_object = array();
			}
		}
		$sl=$params['sl'];
		$block = Block::instance()->getById($block_id, $snapping_id, $dynamic_object, $sl);

		$block['order'] = !empty($params['order']) ? $params['order'] : 0;
		$block['wrapper'] = 'addons/et_vivashop_settings/components/et_ajax_tab.tpl';
		$block['grid_id'] = $params['grid_id'];


		if (defined('AJAX_REQUEST')) {
			Tygh::$app['ajax']->assignHtml($_REQUEST['result_ids'], RenderManager::renderBlock($block));
			$tab_title="<a><span>".$block['name']."</span></a>";
			Tygh::$app['ajax']->assignHtml("tab_title_".$params['grid_id'].'_'.$block['block_id'],$tab_title);
		}

	}
	exit;
}