<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($mode == 'export_range') {
        if (!empty($_REQUEST['page_ids'])) {
            if (empty($_SESSION['export_ranges'])) {
                $_SESSION['export_ranges'] = array();
            }

            if (empty($_SESSION['export_ranges']['pages'])) {
                $_SESSION['export_ranges']['pages'] = array('pattern_id' => 'pages');
            }

            $_ids = $_REQUEST['page_ids'];
            if (!empty($action) && $action == 'subpages') {
                foreach ($_ids as $cid) {
                    $from_id_path = db_get_field("SELECT id_path FROM ?:pages WHERE page_id = ?i", $cid);
                    $subpages= db_get_fields("SELECT page_id FROM ?:pages WHERE id_path LIKE ?l", "$from_id_path/%");
                    if (!empty($subpages)) {
                        $_ids = array_merge($_ids, $subpages);
                    }
                }
            }
            $_ids = array_unique($_ids);

            $_SESSION['export_ranges']['pages']['data'] = array('page_id' => $_ids);

            unset($_REQUEST['redirect_url']);

            return array(CONTROLLER_STATUS_REDIRECT, 'exim.export?section=pages&pattern_id=' . $_SESSION['export_ranges']['pages']['pattern_id']);
        }
    }
    return;
}