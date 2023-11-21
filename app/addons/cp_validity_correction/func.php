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

/* HOOKS */

/**
 * Executes when generating a sitemap entry links after a set of links is generated.
 * Allows you to modify the generated set of links
 *
 * @param string                $type          Entry type
 * @param int|string            $id            Entry unique identifier
 * @param string[]              $languages     List of languages to generate the sitemap for
 * @param array                 $extra         Additional link parameters
 * @param int                   $storefront_id Storefront idenfitier to generate the sitemap for
 * @param array<string, string> $links         Entry links
 */
function fn_cp_validity_correction_google_sitemap_generate_link_post($type, $id, $languages, $extra, $storefront_id, &$links)
{
    if (!empty($links)) {
        $links['main_link'] = fn_query_remove($links['main_link'], 'vendor_id');
    }
}

/* HOOKS END */