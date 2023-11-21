<?php
use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

if (Registry::get('addons.product_reviews.status') == 'A'){
    include_once(Registry::get('config.dir.addons') . 'et_vivashop_settings/lib/product_reviews.php');
}
