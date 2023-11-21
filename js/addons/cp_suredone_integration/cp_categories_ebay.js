(function (_, $) {
    
    let keyword_category_ebay = document.getElementById("cp_keyword_to_category_ebay");

    $(_.doc).ready(function () {
        $(_.doc).on('click', '#cp_btn_search_category_ebay', function (event) {
            fn_cp_search_category_ebay();
            return false;
        });
    });
    
    function fn_cp_search_category_ebay() {
        
        let keyword = keyword_category_ebay.value;
        $.ceAjax('request', fn_url("suredone.process.add_ebay_category"), {
            data: {
                keyword,
                result_ids: 'cp_categories_ebay',
            }
        });
    }

})(Tygh, Tygh.$);
