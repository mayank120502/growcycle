{$company = $product.company_id|fn_get_company_data}
{if $company.cp_verified_supplier == "YesNo::YES"|enum}
    <div class="cp-verified-supplier-wrap">
        <div class="cp-verified-supplier-img">
            {include file="common/image.tpl" images=["image_path" => "`$images_dir`/addons/cp_verified_supplier/verified.png"]}
        </div>
        <div class="cp-verified-supplier-item">
            <p>{__("cp_verified_supplier.supplier_location")}:</p>
            <p>{$company.city}, {$company.state}</p>
        </div>
        <div class="cp-verified-supplier-item">
            <p>{__("cp_verified_supplier.member_since")}:</p>
            <p>{$company.timestamp|date_format:"%Y"}</p>
        </div>
        {if $addons.discussion.status == "ObjectStatuses::ACTIVE"|enum}
            <div class="cp-verified-supplier-item">
                <p>{__("vendor_rating.absolute_vendor_rating")}:</p>
                {$vendor_review = $product.company_id|fn_get_discussion:'M':true}
                {if in_array($addons.discussion.company_discussion_type, ['B', 'R'])}
                    {if $vendor_review.average_rating}
                        {$average_rating = $vendor_review.average_rating}
                    {elseif $vendor_review.discussion.average_rating}
                        {$average_rating = $vendor_review.discussion.average_rating}
                    {/if}
                    {if $average_rating >= 0}
                        {if $average_rating>0}
                            {$_et_no_rating=false}
                        {else}
                            {$_et_no_rating=true}
                        {/if}
                        <div class="et-rating-graph__trigger">
                            {include file="addons/discussion/views/discussion/components/stars.tpl"
                                stars=$average_rating|fn_get_discussion_rating
                                link="companies.discussion&thread_id={$vendor_review.thread_id}"
                                et_on_vs="false"
                                et_no_rating=$_et_no_rating
                            }
                            <div class="et-rating-graph_wrapper">
                                <a href="{" companies.discussion?thread_id=`$vendor_review.thread_id`"|fn_url}">
                                <span class="et-rating-graph_average">{$vendor_review.average_rating}</span></a>
                            </div>
                        </div>
                    {/if}
                {/if}
            </div>
        {/if}
        <div class="cp-verified-supplier-item">
            <div class="ty-account-info__buttons buttons-container">
                <a href="{"companies.description?company_id=`$product.company_id`"|fn_url}" class="ty-btn ty-btn__secondary" rel="nofollow">{__("cp_verified_supplier.company_profile")}</a>
            </div>
            <div class="ty-account-info__buttons buttons-container">
                <a href="{"companies.view?company_id=`$product.company_id`"|fn_url}" class="ty-btn ty-btn__primary" rel="nofollow">{__("cp_verified_supplier.visit_store")}</a>
            </div>
        </div>
    </div>
{/if}