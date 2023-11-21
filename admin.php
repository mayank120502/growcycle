<?php
/***************************************************************************
*                                                                          *
*   (c) 2004 Vladimir V. Kalynyak, Alexey V. Vinokurov, Ilya M. Shalnev    *
*                                                                          *
* This  is  commercial  software,  only  users  who have purchased a valid *
* license  and  accept  to the terms of the  License Agreement can install *
* and use this program.                                                    *
*                                                                          *
****************************************************************************
* PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
* "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
file name => 69i57j35i39j0i433i512j0i433i457i512j46i175i199i402j0i402j0i131i433i512j0i433i512j0i512l2.2856j0
****************************************************************************/

$php_value = phpversion();
if (version_compare($php_value, '7.1.0') == -1) {
// if (version_compare($php_value, '5.6.0') == -1) {
    echo 'Currently installed PHP version (' . $php_value . ') is not supported. Minimal required PHP version is  5.6.0.';
    die();
}

define('AREA', 'A');
define('ACCOUNT_TYPE', 'admin');

try {
    require(dirname(__FILE__) . '/init.php');

    fn_dispatch();
} catch (Exception $e) {
    \Tygh\Tools\ErrorHandler::handleException($e);
} catch (Throwable $e) {
    \Tygh\Tools\ErrorHandler::handleException($e);
}