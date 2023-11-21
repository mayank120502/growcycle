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

namespace Tygh\Tests\Unit\Addons\CpSeoOptimization;

class CheckSiteUrlTest extends \PHPUnit_Framework_TestCase {

    protected function setUp() {
        require_once '../../../../func.php';
    }

    /**
     * @dataProvider urlsProvider
     */
    public function testUrl($site_url, $check_url, $result) {
        $check = fn_cp_seo_check_site_url($site_url, $check_url);
        $this->assertSame($result, $check);
    }

    public function urlsProvider() {
        $test_domains = [
            'site.com',
            'site.com/dev1/test',
            'siTe.nl.coM',
            'обычный-сайт.рф'
        ];
        $check_urls = [
            [true, 'http://[url]'],
            [true, 'https://[url]/'],
            [true, '//[url]'],
            [true, 'index.html'],
            [true, 'HTTPS://[url]/slashes//'],
            [true, 'https://[url]/category/fsfsd'],
            [true, 'http://[url]?query=1'],
            [false, 'https://test.[url]/test/'],
            [false, 'https://[url].test/'],
            [false, 'http://other_[url]/product'],
            [false, 'http://fdsfdsf'],
            [false, 'http://test.com/product'],
            [false, '//other_test.com/product']
        ];
        $test_cases = [];
        foreach ($test_domains as $test_domain) {
            foreach ($check_urls as $check_data) {
                list($result, $check_url) = $check_data;
                $check_url = str_replace('[url]', $test_domain, $check_url);
                $test_cases[] = [$test_domain, $check_url, $result];
            }
        }
        return $test_cases;
    }
    
}
 