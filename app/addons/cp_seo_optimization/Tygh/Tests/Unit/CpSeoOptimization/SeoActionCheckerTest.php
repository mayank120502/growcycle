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

use Tygh\Addons\CpSeoOptimization\SeoSettings;
use Tygh\Addons\CpSeoOptimization\SeoActionChecker;

class CheckLocationActionsTest extends \PHPUnit_Framework_TestCase {

    protected function setUp() {
        require_once '../../../Addons/CpSeoOptimization/SeoActionChecker.php';
        require_once '../../../Addons/CpSeoOptimization/SeoSettings.php';
        
        SeoSettings::instance()->set('addon', $this->getTestAddonSettings());
        SeoSettings::instance()->set('seo_settings', $this->getTestSeoSettings());
        SeoSettings::instance()->set('seo_check', $this->getTestSeoCheck());
    }

    /**
     * @dataProvider noindexParamsProvider
     */
    public function testNoindexParams($params, $result_actions)
    {
        $checker = new SeoActionChecker();
        $checker->setCheckedActions([]);
        $checker->checkNoindexParams($params);

        $this->assertEquals($result_actions, $checker->getCheckedActions());
    }

    /**
     * @dataProvider actionsProvider
     */
    public function testLocationActions($params, $actions, $result_actions)
    {
        $checker = new SeoActionChecker();
        $checker->setCheckedActions([]);
        $checker->checkLocationActions($params, $actions);

        $this->assertEquals($result_actions, $checker->getCheckedActions());
    }

    public function testCheckCompatibility()
    {
        $checker = new SeoActionChecker();
        
        $checker->setCheckedActions([]);
        $checker->checkNoindexParams(['sort_by' => 'sort']);
        
        SeoActionChecker::ignoreAction('lastmod');

        $checker->checkLocationActions(['dispatch' => 'categories.view'], []);

        $this->assertEquals(['noindex', 'hide_descr'], $checker->getCheckedActions());
    }

    public function noindexParamsProvider()
    {
        return [
            [['dispatch' => 'products.view', 'sort_by' => 'sort'], ['noindex']],
            [['dispatch' => 'products.view', 'test_param' => 'param'], []],
            [['dispatch' => 'products.view', 'section' => ''], ['noindex']]
        ];
    }

    public function actionsProvider()
    {
        $test_cases = [
            [
                ['dispatch' => 'index.index'],
                [],
                ['lastmod']
            ],
            [
                ['dispatch' => 'products.view'],
                ['noindex', 'canonical'],
                ['noindex', 'canonical']
            ],
            [
                ['dispatch' => 'categories.view'],
                [],
                ['hide_descr', 'noindex', 'lastmod']
            ],
            [
                ['dispatch' => 'categories.view'],
                ['noindex'],
                ['noindex']
            ],
            [
                ['dispatch' => 'pages.view'],
                ['noindex'],
                []
            ],
            [
                ['dispatch' => 'product_features.view'],
                [],
                ['hide_descr']
            ]
        ];
        
        return $test_cases;
    }
    

    private function getTestAddonSettings()
    {
        return [
            'noindex_hidden' => [
                'P' => 'Y',
                'C' => 'Y',
                'A' => 'Y'
            ],
            'noindex_product' => [
                'without_price' => 'Y',
                'without_stock' => 'Y'
            ],
            'hide_description' => [
                'C' => 'Y',
                'E' => 'Y'
            ],
            'use_lastmod' => [
                'H' => 'Y',
                'P' => 'Y',
                'C' => 'Y',
                'E' => 'N'
            ]
        ];
    }

    private function getTestSeoSettings()
    {
        $func_true = function ($params) {
            return true;
        };
        $func_false = function ($params) {
            return false;
        };
        return [
            'noindex_params' => 'sort_by, section',
            'noindex_hidden' => [
                'action' => 'noindex',
                'items' => [
                    'P' => [
                        'check_function' => $func_false
                    ],
                    'C' => [
                        'check_function' => $func_true
                    ],
                    'A' => [
                        'check_function' => $func_false
                    ]
                ]
            ],
            'noindex_product' => [
                'action' => 'noindex',
                'items' => [
                    'without_price' => [
                        'check_function' => $func_false
                    ],
                    'without_stock' => [
                        'check_function' => $func_true
                    ]
                ]
            ],
            'hide_description' => [
                'action' => 'hide_descr',
                'check_function' => $func_true,
                'items' => [
                    'C' => [
                        'process_function' => $func_true,
                    ],
                    'E' => [
                        'process_function' => $func_true
                    ]
                ]
            ],
            'use_lastmod' => [
                'action' => 'lastmod',
                'items' => [
                    'H' => [
                        'check_function' => $func_true
                    ],
                    'P' => [
                        'check_function' => $func_false
                    ],
                    'C' => [
                        'check_function' => $func_true
                    ],
                    'E' => [
                        'check_function' => $func_true
                    ]
                ]
            ],
            'canonical' => [
                'action' => 'canonical',
                'skip_setting_check' => true,
                'items' => [
                    'P' => [
                        'check_function' => $func_true
                    ]
                ]
            ]
        ];
    }

    private function getTestSeoCheck()
    {
        return [
            'index' => [
                'index' => [
                    'use_lastmod' => 'H'
                ]
            ],
            'products' => [
                'view' => [
                    'noindex_hidden' => 'P',
                    'noindex_product' => ['without_price', 'without_stock'],
                    'use_lastmod' => 'P',
                    'canonical' => 'P'
                ]
            ],
            'categories' => [
                'view' => [
                    'hide_description' => 'C',
                    'noindex_hidden' => 'C',
                    'noindex_without_products' => 'C',
                    'use_lastmod' => 'C'
                ]
            ],
            'pages' => [
                'view' => [
                    'noindex_hidden' => 'A',
                    'use_lastmod' => 'A'
                ]
            ],
            'product_features' => [
                'view' => [
                    'hide_description' => 'E',
                    'noindex_without_products' => 'E',
                    'use_lastmod' => 'E'
                ]
            ]
        ];
    }
}
 