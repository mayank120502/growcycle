<?php
 defined('BOOTSTRAP') or die('Access denied'); $schema['conditions']['affiliate_link'] = [ 'operators' => ['in', 'nin'], 'type' => 'picker', 'picker_props' => [ 'picker' => 'addons/sd_affiliate/pickers/affiliate_plans/picker.tpl', 'params' => [ 'multiple' => true, 'use_keys' => 'N', 'view_mode' => 'table', ], ], 'field_function' => ['fn_promotion_affiliate_link', '#id', '@cart_products'], 'zones' => ['cart', 'catalog'] ]; return $schema;