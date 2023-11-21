{*
    $show_rating
    $product
*}

{if $show_rating}
    {if isset($product.average_rating)}
    	{$average_rating=$product.average_rating}
    {else}
    	{$average_rating=0}
    {/if}

    {include file="addons/product_reviews/views/product_reviews/components/product_reviews_stars.tpl"
        rating=$average_rating
        link=true
        product=$product
        et_on_vs=true 
        et_no_rating=$_et_no_rating
    }

{/if}