<?php
 use Tygh\Registry; defined('BOOTSTRAP') or die('Access denied'); if ($_SERVER['REQUEST_METHOD'] == 'POST') { if (AREA != 'C') { return [CONTROLLER_STATUS_OK]; } if ($mode == 'login') { $login_controller = explode('.', $_REQUEST['return_url']); $is_checkout = array_pop($login_controller) == 'checkout'; if ($is_checkout) { Tygh::$app['session']['sd_ga_checkout']['step_one'] = 'login'; } } return [CONTROLLER_STATUS_OK]; } 