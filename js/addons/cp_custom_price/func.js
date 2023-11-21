(function (_, $) {
    $.ceEvent('on', 'ce.commoninit', function (context) {
        $('#product_cp_custom_price', context).change(function () {
            let product_id = $('.cp-custom-price').data("productId");
            let cp_custom_price = 'N';
            if (this.checked) {
                cp_custom_price = 'Y';
            }
            $.ceAjax('request', fn_url('products.update'), {
                result_ids: 'cp_custom_price_block',
                method: 'get',
                full_render: true,
                data: {
                    product_id: product_id,
                    cp_custom_price: cp_custom_price,
                }
            });
        });
    });
})(Tygh, Tygh.$);