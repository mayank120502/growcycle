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

use Tygh\Enum\Addons\CpNewBuyingTypes\ProductBuyingTypes;
use Tygh\Enum\{SiteArea, UserTypes, YesNo};
use Tygh\{Bootstrap, Registry};

defined('BOOTSTRAP') || die('Access denied');

if (is_file(__DIR__ . '/service_func.php')) {
    require_once __DIR__ . '/service_func.php';
}

if (is_file(__DIR__ . '/hooks.php')) {
    require_once __DIR__ . '/hooks.php';
}

function fn_cp_get_all_product_buying_types(): array
{
    return ProductBuyingTypes::getAll();
}

function fn_cp_get_additional_product_buying_types($but_text = false): array
{
    return ProductBuyingTypes::getAdditional($but_text);
}

function fn_cp_get_product_buying_types_field_init(
    $area = AREA,
    $as = true,
    $product_table = '?:products',
    $companies_table = 'companies'
): string
{
    if ($area !== SiteArea::STOREFRONT) {
        return "$product_table.cp_buying_types";
    }

    return db_quote(
        "IF("
        . "$product_table.cp_buying_types != ?s,"
        . "$product_table.cp_buying_types,"
        . "IF("
        . "$product_table.company_id != 0,"
        . "$companies_table.cp_buying_types,"
        . "?s"
        . ")"
        . ")" . ($as ? " as cp_buying_types" : ''),
        ProductBuyingTypes::VENDOR_DEFAULT, ProductBuyingTypes::CONTACT_VENDOR
    );
}

function fn_cp_check_can_update_buying_types(): bool
{
    /** @var array $auth */
    $auth = Tygh::$app['session']['auth'];

    return $auth['user_type'] === UserTypes::ADMIN;
}

function fn_cp_update_buying_types_data(&$data, $company_update = false)
{
    if (isset($data['cp_buying_types'])) {
        if (fn_cp_check_can_update_buying_types()) {
            $default_type =
                $company_update
                    ? ProductBuyingTypes::BUY
                    : ProductBuyingTypes::VENDOR_DEFAULT;

            $data['cp_buying_types'] =
                empty($data['cp_buying_types'])
                    ? $default_type
                    : implode(',', $data['cp_buying_types']);
        } else {
            unset($data['cp_buying_types']);
        }
    }
}

function fn_cp_check_product_by_buying_type(int $product_id, string $type): bool
{
    $product_buying_types = explode(',', db_get_field(
        "SELECT ?p 
            FROM ?:products
            LEFT JOIN ?:companies as companies on ?:products.company_id = companies.company_id
            WHERE ?:products.product_id = ?i
        ", fn_cp_get_product_buying_types_field_init(), $product_id
    ));

    return in_array($type, $product_buying_types, true);
}

function fn_cp_get_buying_type_payment_id($type)
{
    return Registry::get("addons.cp_new_buying_types.payment_for_$type");
}

function fn_cp_get_buying_type_shipping_id($type)
{
    return Registry::get("addons.cp_new_buying_types.shipping_for_$type");
}


function fn_cp_get_buying_type_order_status($type)
{
    return Registry::get("addons.cp_new_buying_types.order_status_for_$type");
}

function fn_cp_check_is_start_order(): bool
{
    return (
            empty($_REQUEST['dispatch'])
            || !in_array($_REQUEST['dispatch'], ['checkout.customer_info'], true)
        ) && !empty($_REQUEST['start_order']);
}

function fn_cp_check_is_contact_vendor(): bool
{
    return !empty($_REQUEST['dispatch']) && $_REQUEST['dispatch'] === 'checkout.cp_send_inquiry';
}

function fn_cp_return_original_checkout_cart()
{
    if ($_REQUEST['dispatch'] === 'checkout.update_steps') {
        return;
    }

    /** @var array $original_cart */
    $original_cart = Tygh::$app['session']['cp_original_cart'];

    if (!empty($original_cart)) {
        /** @var array $cart */
        $cart = &Tygh::$app['session']['cart'];

        $cart = $original_cart;
        unset(Tygh::$app['session']['cp_original_cart']);

        /** @var array $auth */
        $auth = &Tygh::$app['session']['auth'];

        fn_calculate_cart_content($cart, $auth, 'E');
        fn_save_cart_content($cart, $auth['user_id']);
    }
}

function fn_cp_get_detailed_requirements_tooltip(): string
{
    $supported_formats = implode(
        ', ',
        explode(
            ',',
            Registry::get('addons.cp_new_buying_types.attachment_supported_formats')
        )
    );

    if (!$supported_formats) {
        return '';
    }

    $upload_max_filesize = Bootstrap::getIniParam('upload_max_filesize', true);
    $post_max_size = Bootstrap::getIniParam('post_max_size', true);
    $max_file_size =
        fn_return_bytes($upload_max_filesize) < fn_return_bytes($post_max_size)
            ? $upload_max_filesize
            : $post_max_size;

    return __('cp_new_buying_types.detailed_requirements.tooltip', [
        '[max_attachments]' => Registry::get('addons.cp_new_buying_types.max_attachments'),
        '[max_file_size]' => $max_file_size,
        '[supported_formats]' => $supported_formats
    ]);
}

function fn_cp_nbt_is_email_in_db($email)
{
    $email = trim($email);
    if (fn_cp_nbt_is_email_valid($email) === false) {
        return false;
    }

    return db_get_field("SELECT count(*) as count FROM ?:users WHERE `email`=?s", $email);
}

function fn_cp_nbt_is_email_valid($email)
{
    return fn_validate_email($email);
}

function fn_cp_nbt_make_phone_confirmed($user_id, $phone)
{
    db_query("UPDATE ?:users SET `cp_phone_verified`=?s, `phone`=?s WHERE `user_id`=?i",
        YesNo::YES, $phone, $user_id);
}

function fn_cp_nbt_get_phone($user_id)
{
    static $cache;
    if (array_key_exists($user_id, $cache)) {
        return $cache[$user_id];
    }

    $cache[$user_id] = db_get_row("SELECT `phone`,`cp_phone_verified` FROM ?:users WHERE `user_id`=?i", $user_id);

    return $cache[$user_id];
}


function fn_cp_nbt_is_phone_confirmed($user_id)
{
    if (empty($user_id)) {
        return 'N';
    }
    $record = fn_cp_nbt_get_phone($user_id);

    return $record['cp_phone_verified'];
}

/**
 * Delay in seconds when the new code can be acquired
 *
 * @param int $user_id
 *
 * @return float|int
 */
function fn_cp_nbt_get_resend_code_time($user_id)
{
    if (fn_cp_nbt_is_code_sent($user_id)) {
        $cp_otp = Tygh::$app['session']['cp_otp']['confirm_vendor'];
        $result = 60 * Registry::get('addons.cp_otp_registration.code_valid_time') -
            (time() - $cp_otp['time']) - CP_NBT_TIMESHIFT;

        return $result;
    }

    return -1;
}

/**
 * Whether the code was sent to the customer, if the delay time is out, it will return false
 *
 * @param int $user_id
 *
 * @return bool
 */
function fn_cp_nbt_is_code_sent($user_id)
{
    if (empty($user_id)) {
        return false;
    }

    $type = 'confirm_vendor';
    if (empty(Tygh::$app['session']['cp_otp'][$type])) {
        return false;
    }

    $cp_otp = Tygh::$app['session']['cp_otp'][$type];

    if ($user_id != $cp_otp['user_id']) {
        return false;
    }

    $delay_seconds = Registry::get('addons.cp_otp_registration.code_valid_time') * 60 - CP_NBT_TIMESHIFT;
    if (
        (time() - $cp_otp['time']) > $delay_seconds) {
        return false;
    }

    return true;
}

/**
 * Since the ajax request is asynchronous it can last longer than loading the page so
 * the session won't be changed
 *
 * @return void
 */
function fn_cp_nbt_clear_target()
{
    unset(Tygh::$app['session']['cp_target_id']);
}