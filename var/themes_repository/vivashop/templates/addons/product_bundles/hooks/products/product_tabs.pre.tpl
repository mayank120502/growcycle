{*
    Import
    ---
    $product
*}

{script src="js/tygh/exceptions.js"}

{component
    name="product_bundles.product_bundles"
    product_id=$product.product_id
    show_on_products_page=true
}{/component}

{$et_has_bundles=count($bundles)  scope="parent"}