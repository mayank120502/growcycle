<?php
use Tygh\Registry;
use Tygh\Addons\ProductReviews\ServiceProvider as ProductReviewsProvider;
use Tygh\Enum\ObjectStatuses;
use Tygh\Enum\YesNo;
use Tygh\Providers\StorefrontProvider;

if ($mode === 'view' || $mode === 'quick_view') {
    /** @var array $product */
    $product = Tygh::$app['view']->getTemplateVars('product');

    $params = $_REQUEST;
    unset($params['company_id']);
    $params['product_id'] = (int) $product['product_id'];
    $params['status'] = ObjectStatuses::ACTIVE;

    if (empty($params['items_per_page'])) {
        $params['items_per_page'] = (int) Registry::get('addons.product_reviews.reviews_per_page');
    } else {
        $params['items_per_page'] = (int) $_REQUEST['items_per_page'];
    }

    $params['storefront_id'] = fn_product_reviews_get_storefront_id_by_setting();

    $product_reviews_repository = ProductReviewsProvider::getProductReviewRepository();
    $service = ProductReviewsProvider::getService();

    list($product_reviews, $search) = $product_reviews_repository->find($params);
    $product['product_reviews'] = $product_reviews;
    $first_review = reset($product_reviews);
    $product['product_reviews_rating_stats'] = $service->getProductRatingStats(
        $first_review ? $first_review['product']['product_id'] : 0,
        $params['storefront_id']
    );

    $search['filtering'] = [
        'items' => [],
    ];

    foreach ($search['available_filters'] as $filter_name) {
        $search['filtering']['items'][$filter_name] = [
            'param'    => $filter_name,
            'name'     => __('reviews.filtering.' . $filter_name),
            'selected' => !empty($search[$filter_name]),
        ];
    }

    Tygh::$app['view']->assign([
        'product'                        => $product,
        'product_reviews_search'         => $search,
        'product_reviews_sorting'        => $product_reviews_repository->getSorting(),
        'product_reviews_sorting_orders' => ['asc', 'desc'],
        'product_reviews_avail_sorting'  => $product_reviews_repository->getAvailableSorts()
    ]);
}
