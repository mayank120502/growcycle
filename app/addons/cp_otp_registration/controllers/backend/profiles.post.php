<?php

use Tygh\Registry;
use Tygh\Tools\Url;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    return;
}

if ($mode == 'update' || $mode == 'add') {
    $profile_fields = Tygh::$app['view']->getTemplateVars('profile_fields');
    if (!empty($profile_fields)) {
        foreach ($profile_fields as $section => $fields) {
            foreach ($fields as $field_id => $field) {
                if (in_array($field['field_name'], array('phone', 'b_phone', 's_phone'))) {
                    unset($profile_fields[$section][$field_id]);
                }
            }
        }
        Tygh::$app['view']->assign('profile_fields', $profile_fields);
    }
}
