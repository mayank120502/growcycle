<?php
/*****************************************************************************
*                                                        © 2013 Cart-Power   *
*           __   ______           __        ____                             *
*          / /  / ____/___ ______/ /_      / __ \____ _      _____  _____    *
*      __ / /  / /   / __ `/ ___/ __/_____/ /_/ / __ \ | /| / / _ \/ ___/    *
*     / // /  / /___/ /_/ / /  / /_/_____/ ____/ /_/ / |/ |/ /  __/ /        *
*    /_//_/   \____/\__,_/_/   \__/     /_/    \____/|__/|__/\___/_/         *
*                                                                            *
*                                                                            *
* -------------------------------------------------------------------------- *
* This is commercial software, only users who have purchased a valid license *
* and  accept to the terms of the License Agreement can install and use this *
* program.                                                                   *
* -------------------------------------------------------------------------- *
* website: https://store.cart-power.com                                      *
* email:   sales@cart-power.com                                              *
******************************************************************************/

use Tygh\Enum\ObjectStatuses;
use Tygh\Enum\SiteArea;
use Tygh\Enum\YesNo;
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

/**
 * Get the content of "Company profile" tab (all it's parts)
 *
 * @param integer  $company_id    The id of vendor's company
 * 
 * @return array
 */
function fn_cp_company_tab_content($company_id, $lang_code = DESCR_SL)
{
    $return = [];
    $sections_inside = fn_get_cp_company_tab_sections_data();
    $sections_content = db_get_hash_array('
        SELECT * FROM ?:cp_company_tab_content 
        WHERE company_id = ?i AND lang_code = ?s', 
        'section_id', $company_id, $lang_code
    );
    foreach ($sections_inside as $section) {
        $id = $section['section_id'];
        $sections_content[$id]['section_description'] = $section['description'];
        $sections_content[$id]['status'] = $section['status'];
        if (AREA != SiteArea::STOREFRONT || !empty($sections_content[$id]['tab_content'])) {
            $return[$id] = $sections_content[$id];
        }
    }
    return $return;
}

/**
 * Update the content of "Company profile" tab (all it's parts)
 *
 * @param array  $params    Parameters of content
 * 
 * @return void
 */
function fn_cp_company_tab_content_update($params)
{
    if (!empty($params)) {
        $runtime_company_id = fn_get_runtime_company_id();
        foreach ($params as $section_id => $section) {
            db_replace_into('cp_company_tab_content', [
                'company_id' => $runtime_company_id,
                'section_id' => $section_id,
                'section_description' => $section['section_description'],
                'tab_content' => $section['tab_content'],
                'lang_code' => DESCR_SL
            ]);
        }
    }
}

/**
 * Get the list of sections inside the "Company profile" tab with their names in the current language
 *
 * @param  string  $lang_code    Language code for section names
 * 
 * @return array
 */
function fn_get_cp_company_tab_sections_data($lang_code = DESCR_SL) {
    $condition = AREA == SiteArea::STOREFRONT ? db_quote(' AND ts.status = ?s', ObjectStatuses::ACTIVE) : '';
    return db_get_array('SELECT ts.section_id, ts.position, ts.status, tsd.description FROM ?:cp_company_tab_sections as ts
        LEFT JOIN ?:cp_company_tab_section_descriptions as tsd
        ON ts.section_id = tsd.section_id
        WHERE tsd.lang_code = ?s' . $condition . '
        ORDER BY position',
        DESCR_SL
    );
}

/**
 * Add new sections inside the "Company profile"
 *
 * @param  array  $new_section_data    Data of sections for adding
 * 
 * @return void
 */
function fn_add_cp_company_tab_sections_data($new_section_data) {
    if (is_array($new_section_data)) {
        $languages = array_keys(fn_get_languages());
        foreach ($new_section_data as $section) {
            $section_id = db_query('INSERT INTO ?:cp_company_tab_sections ?e', $section);
            foreach ($languages as $lang_code) {
                $section_description = [
                    'section_id' => $section_id,
                    'description' => $section['description'],
                    'lang_code' => $lang_code,
                ];
                db_query('INSERT INTO ?:cp_company_tab_section_descriptions ?e', $section_description);
            }
        }
    }
}

/**
 * Delete sections inside the "Company profile"
 *
 * @param  array  $section_ids    Ids of sections to delete
 * 
 * @return void
 */
function fn_delete_cp_company_tab_sections_data($section_ids) {
    if (is_array($section_ids)) {
        db_query('DELETE FROM ?:cp_company_tab_sections WHERE section_id IN (?n)', $section_ids);
        db_query('DELETE FROM ?:cp_company_tab_section_descriptions WHERE section_id IN (?n)', $section_ids);
    }
}

/**
 * Update sections inside the "Company profile"
 *
 * @param  array  $section_ids    Ids of sections to delete
 * 
 * @return void
 */
function fn_update_cp_company_tab_sections_data($section_data) {
    if (is_array($section_data)) {
        foreach ($section_data as $section_id => $section) {
            db_replace_into('cp_company_tab_sections', [
                'section_id' => $section_id,
                'position' => $section['position']
            ]);
            db_replace_into('cp_company_tab_section_descriptions', [
                'section_id' => $section_id,
                'description' => $section['description'],
                'lang_code' => DESCR_SL
            ]);
        }
    }
}

/**
 * Prepare statuses for "cp_company_tab"
 *
 * @param string $type     Object type
 * @param array  $statuses Array of statuses by type
 *
 * @return void
 */
function fn_cp_company_tab_get_predefined_statuses($type, &$statuses)
{
    if ($type == 'cp_company_tab') {
        $statuses['cp_company_tab'] = array(
            'A' => __('active'),
            'D' => __('disabled')
        );
    }
}

/**
 * Unset "Company profile" tab if it is empty or disabled
 *
 * @param array $tabs Array of product tabs data
 * @param string $lang_code 2 letter language code
 *
 * @return void
 */
function fn_cp_company_tab_get_product_tabs_post(&$tabs, $lang_code)
{
    if (!empty($tabs)) {
        $enable_company_tab = Registry::get('addons.cp_company_tab.enable_company_tab');
        $runtime = Registry::get('runtime');
        foreach ($tabs as $tabs_key => $tab) {
            if (isset($tab['addon']) && $tab['addon'] == FIND_TAB_BY_ADDON) {
                if ($enable_company_tab != YesNo::YES) {
                    unset($tabs[$tabs_key]);
                } else {
                    $company_id = isset($runtime['vendor_id']) ? $runtime['vendor_id'] : $runtime['company_id'];
                    $tab_content = fn_cp_company_tab_content($company_id);
                    if ($company_id && empty($tab_content)) {
                        unset($tabs[$tabs_key]);
                    }
                }
            }
        }
    }
}