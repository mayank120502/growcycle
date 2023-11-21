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

// This schema allows to prepare $product_data for fn_update_product

$schema = [
    'Name' => 'product',
    'Description' => 'full_description',
    'SoldInQuantitiesOf' => 'qty_step',
    'EachPrice' => 'price',
    'CategoryName' => 'add_new_category',
    'Id' => 'product_code',
    'StockTotal' => 'amount',
    'Looks' => 'popularity',
    'ImageMedium' => 'image_file',
    'WeightUom' => 'weight_unit_code',
    'EachWeight' => 'weight',
];

return $schema;
