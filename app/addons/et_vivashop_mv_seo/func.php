<?php
use Tygh\Registry;
use Tygh\Languages\Languages;
use Tygh\Settings;
use Tygh\Enum\YesNo;
use Tygh\Bootstrap;
use Tygh\Tools\Url;
use Tygh\Enum\NotificationSeverity;

function fn_et_vivashop_mv_seo_url_post (&$url, &$area, &$original_url, &$prefix, &$company_id_in_url, &$lang_code, $locations)
{
  if (Registry::get('addons.seo.status')=="A"){
    $cache=[];

    $et_special_names=[
      'companies.products'    =>  'categories',
      'companies.newest'      =>  'newest',
      'companies.on_sale'     =>  'sale',
      'companies.bestsellers' =>  'bestsellers',
      'companies.description' =>  'about-us',
      'companies.contact'     =>  'contact',
      'companies.discussion'  =>  'reviews',
      'companies.product_view'=>  'product_page',
      'companies.page_view'   =>  'et_vendor_page'
    ];

    static $et_special_name_db=null;
    
    $seo_settings = fn_get_seo_settings(0);
    if ($seo_settings['single_url'] == 'Y') {
      $sql_lang_code=Registry::get('settings.Appearance.frontend_default_language');
    }else{
      $sql_lang_code=$lang_code;
    }

    if (is_null($et_special_name_db)) {
      $et_special_name_db = db_get_hash_single_array("SELECT dispatch, name FROM ?:et_seo_names WHERE lang_code = ?s ", array('dispatch', 'name'), $sql_lang_code);
    }

    $et_special_names=fn_array_merge($et_special_names,$et_special_name_db);

    $et_found=false;
    if (strpos($original_url,'redirect_url')===false){
      foreach ($et_special_names as $key => $value) {
        if (strpos($original_url, $key)!== false){
          $et_found = $value;
          break;
        }
      }
    }
    if ($area == 'C' && $et_found !== false) {
      $parsed_url=parse_url($url);
      parse_str($parsed_url['query'], $parsed_query);
      $et_dispatch='';
      if (isset($parsed_query['dispatch'])){
        $et_dispatch=$parsed_query['dispatch'];
      }
      unset($parsed_query['dispatch']);

      $d = SEO_DELIMITER;

      static $default_frontend_language;
      if ($default_frontend_language === null) {
          $default_frontend_language = Registry::get('settings.Appearance.frontend_default_language');
      }

      if (!isset($parsed_query['company_id'])){

        if ($et_dispatch=='companies.discussion'){
          $thread_id=$parsed_query['thread_id'];
          $data = fn_discussion_get_object(array(
            'thread_id' => $thread_id,
          ));
          $company_id=$data['object_id'];
        }else if ($et_dispatch=='companies.page_view'){
          $page_id=$parsed_query['page_id'];
          $page = fn_get_page_data($page_id);
          $company_id=$page['company_id'];
        }

      }else{
        $company_id = $parsed_query['company_id'];
        unset($parsed_query['company_id']);
      }

      if (isset($company_id)) {

        $company_name = fn_seo_get_name('m', $company_id, '', $company_id, $lang_code);

        $seo_settings = fn_get_seo_settings(0);

        if ($seo_settings['single_url'] == 'Y') {
          $lang_code=Registry::get('settings.Appearance.frontend_default_language');
        }
        $show_secondary_language_in_uri = YesNo::toBool($seo_settings['seo_language']);

        static $seo_vars;
        $seo_vars = fn_get_seo_vars();

        $name='';

        if ($et_dispatch==='companies.products' && isset($parsed_query['category_id']) && !empty($parsed_query['category_id'])) {

          $et_object_id = $parsed_query['category_id'];
          unset($parsed_query['category_id']);
          $seo_type = 'c';

        }else if ($et_dispatch==='companies.product_view' && isset($parsed_query['product_id'])) {

          $et_object_id=$parsed_query['product_id'];
          unset($parsed_query['product_id']);
          $seo_type = 'p';

        }else if ($et_dispatch==='companies.page_view' && isset($parsed_query['page_id'])) {

          $et_object_id = $parsed_query['page_id'];
          unset($parsed_query['page_id']);
          $seo_type = 'a';

        }else{
          $name = $et_found;
          $seo_type = 's';
        }

        // new
        $seo_var=$seo_vars[$seo_type];

        if (fn_check_seo_schema_option($seo_var, 'tree_options', $seo_settings)) {
          $parent_item_names = fn_seo_get_parent_items_path($seo_var, $seo_type, $et_object_id, $company_id_in_url, $lang_code);
        }else{
          $parent_item_names='';
        }

        if (empty($name)){
          $name = fn_seo_get_name($seo_type, $et_object_id, '', $company_id, $lang_code);
          $cache_id=$company_id.'_'.$et_object_id;
        }else{
          $cache_id=$company_id.'_'.$name;
        }

        $current_path = '';
        $http_path = parse_url($locations[$area]['http'], PHP_URL_PATH);
        $https_path = parse_url($locations[$area]['https'], PHP_URL_PATH);
        if (empty($parsed_url['scheme'])) {
          $current_path = (defined('HTTPS')) ? $https_path . '/' : $http_path . '/';
        }

        static $index_script;
        if ($index_script === null) {
          $index_script = Registry::get('config.customer_index');
        }
        $path = str_replace($index_script, '', $parsed_url['path'], $count);
        if ($current_path===$path){
          $current_path='';
        }

        $link_parts = array(
          'scheme' => !empty($parsed_url['scheme']) ? $parsed_url['scheme'] . '://' : '',
          'host' => !empty($parsed_url['host']) ? $parsed_url['host'] : '',
          'path' => $current_path . $path,
          'lang_code' => ($show_secondary_language_in_uri && $lang_code !== $default_frontend_language)
              ? $lang_code . '/'
              : '',
          'company_name' => $company_name.'/',
          'parent_items_names' => !empty($parent_item_names) ? join('/', $parent_item_names) . '/' : '',
          'name' => $name,
          'page' => '',
          'extension' => '',
        );

        if (fn_check_seo_schema_option($seo_var, 'html_options', $seo_settings)) {
          $link_parts['extension'] = SEO_FILENAME_EXTENSION;
        } else {
          $link_parts['name'] .= '/';
        }

        if (!empty($seo_var['pager'])) {
          $page = isset($parsed_query['page']) ? intval($parsed_query['page']) : 0;
          unset($parsed_query['page']);

          if (!empty($page) && $page != 1) {
            if (fn_check_seo_schema_option($seo_var, 'html_options', $seo_settings)) {
              $link_parts['name'] .= $d . 'page' . $d . $page;
            } else {
              $link_parts['name'] .= 'page' . $d . $page . '/';
            }
          }
        }

        // end new

        if ($show_secondary_language_in_uri) {
          if (isset($parsed_query['sl'])){
            $et_lang_code=$parsed_query['sl'];
          }else if (defined('CART_LANGUAGE')){
            $et_lang_code = CART_LANGUAGE;
          }else{
            $et_lang_code=$lang_code;
          }
          $link_parts['lang_code'] = $et_lang_code !== $default_frontend_language
              ? $et_lang_code . '/'
              : '';
        }

        if (!empty($parsed_query['sl'])) {
          $lang_code = $parsed_query['sl'];

          if ($seo_settings['single_url'] != 'Y') {
            $unset_lang_code = $parsed_query['sl'];
            unset($parsed_query['sl']);
          }

          if ($show_secondary_language_in_uri) {
            if (isset($parsed_query['sl'])){
              $et_lang_code=$parsed_query['sl'];
            }else if (defined('CART_LANGUAGE')){
              $et_lang_code = CART_LANGUAGE;
            }else{
              $et_lang_code=$lang_code;
            }

            $link_parts['lang_code'] = $et_lang_code !== $default_frontend_language
                ? $et_lang_code . '/'
                : '';
            $unset_lang_code = isset($parsed_query['sl']) ? $parsed_query['sl'] : $unset_lang_code;
            unset($parsed_query['sl']);
          }
        }


        $result = join('', $link_parts);

        $fragment = !empty($parsed_url['fragment']) ? '#' . $parsed_url['fragment'] : '';
        if (!empty($parsed_query)) {
          $cache_id = $cache_id.'_'.join('',$parsed_query);
          $result .= '?' . http_build_query($parsed_query) . $fragment;
        }

        if ($show_secondary_language_in_uri && isset($et_lang_code)) {
          $cache_id = $cache_id.'_1_'.$lang_code.'_'.$et_lang_code;
        }else if (isset($lang_code)){
          $cache_id = $cache_id.'_2_'.$lang_code;
        }

        if (!isset($cache[$cache_id])) {
          $cache[$cache_id]=$url=$result;
        }else{
          $url=$result=$cache[$cache_id];
        }

        return $result;
      }
    }else{
      $parsed_url=parse_url($url);
    }
  }
}


function fn_et_vivashop_mv_seo_get_route(array &$req, array &$result, &$area, &$is_allowed_url){
    
  if (Registry::get('addons.seo.status')=="A" && (isset($req['dispatch']) && $req['dispatch']=='_no_page')){

    $uri = fn_get_request_uri($_SERVER['REQUEST_URI']);
    $req = Bootstrap::safeInput($_GET);
    
    if (stristr($_SERVER['REQUEST_URI'], Registry::get('config.current_location'))!==false){
      $et_req=substr($_SERVER['REQUEST_URI'], strlen(Registry::get('config.current_location').'/'.$uri));
    }else{
      $et_path=(defined('HTTPS')) ? Registry::get('config.https_path') . '/' : Registry::get('config.http_path') . '/';
      $et_req=substr($_SERVER['REQUEST_URI'], strlen($et_path.$uri));
    }
    
    $et_req=str_replace('/', '', $et_req);
    $et_req=str_replace('?', '&', $et_req);

    parse_str($et_req, $et_parse);
    $req=fn_array_merge($req,$et_parse);
    $vars=$_REQUEST;
    
    if (!empty($uri)) {

      $frontend_default_language = Registry::get('settings.Appearance.frontend_default_language');
      $show_secondary_language_in_uri = YesNo::toBool(Registry::get('addons.seo.seo_language'));
      $use_single_seo_name = YesNo::toBool(Registry::get('addons.seo.single_url'));

      $requested_language = $frontend_default_language;
      $language_in_uri = fn_seo_get_language_from_uri($uri);
      $is_requested_language_in_path = false;

      if ($language_in_uri && $show_secondary_language_in_uri) {
          $requested_language = $language_in_uri;
          $is_requested_language_in_path = true;
      }
      if (isset($req['sl'])) {
          $requested_language = $req['sl'];
      }
      

      static $et_seo_companies;
      $et_seo_companies = db_get_hash_single_array("SELECT name, object_id as val FROM ?:seo_names WHERE type='m'", array('name', 'val'));
      
      $rewrite_rules=array();

      static $valid_languages;
      if ($valid_languages === null) {
          $valid_languages = array_filter(array_keys(fn_seo_get_active_languages()), static function ($lang_code) use ($frontend_default_language) {
              return $lang_code !== $frontend_default_language;
          });
      }

      $prefix = $show_secondary_language_in_uri
          ? '\/(' . implode('|', $valid_languages) . ')'
          : '()';
      
      $extension = str_replace('.', '', SEO_FILENAME_EXTENSION);

      $et_prefix='\/(' . implode('|', array_keys($et_seo_companies)) . ')';

      $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/]+)-page-([0-9]+|full_list)\.(' . $extension . ')$!'] = 'object_name=$matches[4]&page=$matches[5]&sl=$matches[1]&company_name=$matches[2]&extension=$matches[6]';
      $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/]+)\.(' . $extension . ')$!'] = 'object_name=$matches[4]&sl=$matches[1]&company_name=$matches[2]&extension=$matches[5]';

      if ($show_secondary_language_in_uri) {
        $rewrite_rules['!^' . $prefix . $et_prefix . '\/?$!'] = '$customer_index?sl=$matches[1]&company_name=$matches[2]';
      }

      $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/]+)\/page-([0-9]+|full_list)(\/)?$!'] = 'object_name=$matches[4]&page=$matches[5]&sl=$matches[1]&company_name=$matches[2]';
      $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/?]+)\/?$!'] = 'object_name=$matches[4]&sl=$matches[1]&company_name=$matches[2]';

      if ($show_secondary_language_in_uri) {
        $prefix = '()';
        $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/]+)-page-([0-9]+|full_list)\.(' . $extension . ')$!'] = 'object_name=$matches[4]&page=$matches[5]&sl=' . $frontend_default_language . '&company_name=$matches[2]&extension=$matches[6]';
        $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/]+)\.(' . $extension . ')$!'] = 'object_name=$matches[4]&sl=' . $frontend_default_language . '&company_name=$matches[2]&extension=$matches[5]';

        $rewrite_rules['!^' . $prefix . $et_prefix . '\/?$!'] = '$customer_index?sl=' . $frontend_default_language.'&company_name=$matches[2]';
        $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/]+)\/page-([0-9]+|full_list)(\/)?$!'] = 'object_name=$matches[4]&page=$matches[5]&sl=' . $frontend_default_language.'&company_name=$matches[2]';
        $rewrite_rules['!^' . $prefix . $et_prefix . '\/(.*\/)?([^\/?]+)\/?$!'] = 'object_name=$matches[4]&sl=' . $frontend_default_language.'&company_name=$matches[2]';
      }

      foreach ($rewrite_rules as $pattern => $query) {
        if (!preg_match($pattern, $uri, $matches) && !preg_match($pattern, urldecode($query), $matches)) {
          continue;

        }

        $_query = preg_replace('!^.+\\?!', '', $query);
        parse_str($_query, $objects);
        $result_values = 'matches';
        $url_query = '';

        foreach ($objects as $key => $value) {
          preg_match('!^.+\[([0-9])+\]$!', $value, $_id);
          $objects[$key] = (strpos($value, '$') === 0) ? ${$result_values}[$_id[1]] : $value;
        }

        if (!empty($objects) && !empty($objects['object_name'])) {

          if ($use_single_seo_name) {
            $objects['sl'] = $show_secondary_language_in_uri ? $objects['sl'] : '';
            $objects['sl'] = !empty($req['sl']) ? $req['sl'] : $objects['sl'];
          }

          $lang_cond = db_quote('AND lang_code = ?s', !empty($objects['sl']) ? $objects['sl'] : $frontend_default_language);
          if ($use_single_seo_name) {
            $lang_cond = db_quote('AND lang_code = ?s', $frontend_default_language);
          }

          $et_special_names=[
            'companies.products'    =>  'categories',
            'companies.newest'      =>  'newest',
            'companies.on_sale'     =>  'sale',
            'companies.bestsellers' =>  'bestsellers',
            'companies.description' =>  'about-us',
            'companies.contact'     =>  'contact',
            'companies.discussion'  =>  'reviews',
            'companies.product_view'=>  'product_page',
            'companies.page_view'   =>  'et_vendor_page'
          ];


          static $et_special_name_db=null;
          if (is_null($et_special_name_db)) {
            $et_special_name_db = db_get_hash_single_array("SELECT dispatch, name FROM ?:et_seo_names WHERE 1 ?p", array('dispatch', 'name'), $lang_cond);
          }


          $et_special_names=fn_array_merge($et_special_names,$et_special_name_db);

          $et_special_names=array_flip($et_special_names);


          if (!in_array($objects['object_name'],array_keys($et_special_names))){
            $condition=fn_get_seo_company_condition('?:seo_names.company_id');
            
            // $et_seo_companies
            $vendor_id=$et_seo_companies[$objects['company_name']];
            $condition.=db_quote(" AND et_vendor_id = ?i", $vendor_id);

            $object_type = db_get_field(
              'SELECT type FROM ?:seo_names WHERE name = ?s ?p',
              $objects['object_name'],
              $condition              
            );

            if (empty($object_type)){
              $condition=fn_get_seo_company_condition('?:seo_names.company_id');
              $object_type = db_get_field(
                'SELECT type FROM ?:seo_names WHERE name = ?s ?p',
                $objects['object_name'],
                $condition              
              );

            }

            $_seo = db_get_array(
              'SELECT * FROM ?:seo_names WHERE name = ?s ?p ?p',
              $objects['object_name'],
              $condition,
              $lang_cond
            );

            if (empty($_seo)) {
              $_seo = db_get_array(
                  'SELECT * FROM ?:seo_names WHERE name = ?s ?p',
                  $objects['object_name'],
                  $condition
              );
            }


            if (!empty($_seo)) {

              $_seo_valid = false;

              foreach ($_seo as $__seo) {
                $_objects = $objects;
                if (!$use_single_seo_name && empty($_objects['sl'])) {
                  $_objects['sl'] = $__seo['lang_code'];
                }
                if (isset($objects['company_name'])){
                  $_uri=str_replace($objects['company_name'].'/', '', $uri);
                  unset($_objects['company_name']);
                }else{
                  $_uri=$uri;
                }


                if (fn_seo_validate_object($__seo, $_uri, $_objects)) {
                  $_seo_valid = true;
                  $_seo = $__seo;
                  $objects['sl']=$_objects['sl'];

                  break;
                }
              }

              if ($_seo_valid) {
                if ($object_type=='c'){
                  $req['sl'] = $objects['sl'];
                  $req['dispatch'] = 'companies.products';
                  $req['company_id']= $et_seo_companies[$objects['company_name']];

                  $url_query = 'companies.products?category_id='.$_seo['object_id'].'&company_id='.$et_seo_companies[$objects['company_name']];

                  if (!empty($_seo['object_id'])) {
                    $req['category_id'] = $_seo['object_id'];
                  }

                  if (!empty($objects['page'])) {
                      $req['page'] = $objects['page'];
                  }
                }else if($object_type=='p'){
                  $req['sl'] = $objects['sl'];
                  $req['dispatch'] = 'companies.product_view';
                  $req['company_id']= $et_seo_companies[$objects['company_name']];

                  $url_query = 'companies.product_view?product_id='.$_seo['object_id'].'&company_id='.$et_seo_companies[$objects['company_name']];

                  if (!empty($_seo['object_id'])) {
                    $req['product_id'] = $_seo['object_id'];
                  }
                }else if($object_type=='a'){
                  $req['sl'] = $objects['sl'];
                  $req['dispatch'] = 'companies.page_view';
                  $req['company_id'] = $et_seo_companies[$objects['company_name']];
                  $req['page_id'] = $_seo['object_id'];

                  $url_query = 'companies.page_view?page_id='.$_seo['object_id'].'&company_id='.$et_seo_companies[$objects['company_name']];
                  
                }

                $is_allowed_url = true;
              }
            }
          }else{

            if (!$use_single_seo_name && empty($objects['sl'])){
              $sl = db_get_field(
                'SELECT lang_code FROM ?:seo_names WHERE name = ?s',
                $objects['company_name']
              );
              $objects['sl']=$sl;
            }


            $req['sl'] = $objects['sl'];
            $req['dispatch'] = $et_special_names[$objects['object_name']];
            $req['company_id']= $et_seo_companies[$objects['company_name']];

            $url_query = $req['dispatch'].'?company_id='.$et_seo_companies[$objects['company_name']];
            
            if($req['dispatch']=='companies.discussion'){
              $discussion=fn_get_discussion($req['company_id'], 'M', false);
              if (isset($discussion['thread_id'])){
                $thread_id=$discussion['thread_id'];

                $req['thread_id']=$thread_id;

              }
            }
            $is_allowed_url = true;
          }
        }

        $lang_code = empty($objects['sl']) ? $frontend_default_language : $objects['sl'];

        if (empty($req['sl'])) {
            unset($req['sl']);
        }

        $query_string = http_build_query($req);
        $_SERVER['REQUEST_URI'] = fn_url($url_query . '?' . $query_string, 'C', 'rel', $lang_code);
        $_SERVER['QUERY_STRING'] = $query_string;
        $_SERVER['X-SEO-REWRITE'] = true;
        break;
      }
    }
    // check redirects
    if (!empty($is_allowed_url)) {
        return;
    }

    $query_string = [];

    // Attach additinal params to URI if passed
    if (!empty($_SERVER['QUERY_STRING'])) {
        parse_str($_SERVER['QUERY_STRING'], $query_string);
    }

    // Remove pagination from URI
    

    if (
        preg_match('#(?P<pagination>-page-(?P<page>\d+))\\' . SEO_FILENAME_EXTENSION . '$#', $uri, $m)
        || preg_match('#(?P<pagination>/page-(?P<page>\d+)/?$)#', $uri, $m)
    ) {
        $query_string['page'] = $m['page'];
        $uri = str_replace($m['pagination'], '', $uri);
    }

    $et_redir_uri=explode('/', $uri);
    unset($et_redir_uri[1]);
    $et_redir_uri=implode('/', $et_redir_uri);

    $condition = fn_get_seo_company_condition('?:seo_redirects.company_id');

    $redirect_data = db_get_row('SELECT type, object_id, dest, lang_code FROM ?:seo_redirects WHERE src = ?s ?p', $et_redir_uri, $condition);

    if (!empty($redirect_data)) {
        $result = [
            INIT_STATUS_REDIRECT,
            fn_generate_seo_url_from_schema($redirect_data, true, $query_string),
            false,
            true,
        ];
    } else {
        $req = [
            'dispatch' => '_no_page'
        ];
    }

  }
  
}

function fn_et_vivashop_mv_seo_dispatch_before_display()
{
    if (AREA != 'C' || Registry::get('addons.seo.status')!="A") {
        return;
    }

    /** @var \Tygh\SmartyEngine\Core $view */
    $view = Tygh::$app['view'];
    $auth = Tygh::$app['session']['auth'];

    $seo_canonical = [];

    $schema = fn_get_schema('seo', 'canonical_urls');
    $search = array();
    $runtime = Registry::get('runtime');
    $controller = $runtime['controller'];
    $mode = $runtime['mode'];
    $lang_parameter = 'sl';
    $default_language = Registry::get('settings.Appearance.frontend_default_language');

    $et_mode=$mode;
    $et_controller=$controller;

    if ($controller==="companies"){
      switch ($mode) {
        case 'product_view':
          if (Registry::get('addons.et_vivashop_mv_functionality.et_product_link')!=="vendor"){
            $controller="products";
            $mode="view";
          }else{
            $base_url='companies.product_view?product_id='.$_REQUEST['product_id'].'&company_id='.$_REQUEST['company_id'];
            $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          }
          break;
        case 'view':
          $base_url='companies.view?&company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;
        case 'description':
          $base_url='companies.description?&company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;
        case 'page_view':
          $base_url='companies.page_view?page_id='.$_REQUEST['page_id'].'&company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;
        case 'contact':
          $base_url='companies.contact?company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;
        case 'newest':
          $base_url='companies.newest?company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;
        case 'on_sale':
          $base_url='companies.on_sale?company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;
        case 'bestsellers':
          $base_url='companies.bestsellers?company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;

        case 'discussion':
          $base_url='companies.discussion?thread_id='.$_REQUEST['thread_id'].'&company_id='.$_REQUEST['company_id'];
          $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
          break;

        default:
        break;
      }
    }

    if (isset($schema[$controller][$mode])) {
        $rule = $schema[$controller][$mode];
        $base_url = '';
        if (is_array($rule['base_url'])) {
            foreach ($rule['base_url'] as $func => $arg) {
                $base_url = call_user_func_array($func, $arg);
            }
        } else {
            $base_url = $rule['base_url'];
        }
        $is_valid = !empty($base_url);
        if (isset($rule['request_handlers'])) {
            foreach ($rule['request_handlers'] as $param => $handler) {
                if (isset($_REQUEST[$param])) {
                    if (is_array($handler)) {
                        foreach ($handler as $func => $args) {
                            $is_valid = call_user_func_array($func, $args);
                        }
                    } else {
                        $is_valid = $handler? !empty($_REQUEST[$param]): empty($_REQUEST[$param]);
                    }
                    $base_url = str_replace("[{$param}]", $_REQUEST[$param], $base_url);
                } else {
                    $is_valid = false;
                    break;
                }
            }
        }
        if ($is_valid) {
            if (isset($rule['search'])) {
                if (is_callable($rule['search'])) {
                    $search = call_user_func($rule['search']);
                } elseif (is_array($rule['search'])) {
                    $search = $rule['search'];
                } else {
                    $search = $view->getTemplateVars('search');
                }
            } else {
                $search = array();
            }

            if (!empty($_REQUEST[$lang_parameter]) && $_REQUEST[$lang_parameter] != $default_language) {
                $base_url = fn_link_attach($base_url, $lang_parameter . '=' . $_REQUEST[$lang_parameter]);
            }

            $seo_canonical = fn_seo_get_canonical_links($base_url, $search);
        }
    }

    $seo_alt_hreflangs_list = array();
    $languages = Registry::get('languages');

    if (count($languages) > 1) {
        /** @var \Tygh\Tools\Url $url */
        $url = new Url(Registry::get('config.current_url'));
        $query_params = $url->getQueryParams();

        foreach ($languages as $language) {
            $query_params[$lang_parameter] = $language['lang_code'];
            $href = $url->setQueryParams($query_params)->build();
            $href_lang = array(
                'name'      => $language['name'],
                'direction' => $language['direction'],
                'href'      => fn_url($href),
            );

            if ($language['lang_code'] == $default_language) {
                $href_lang['href'] = fn_query_remove($href_lang['href'], $lang_parameter);
                $seo_alt_hreflangs_list['x-default'] = $href_lang;
            }

            $seo_alt_hreflangs_list[$language['lang_code']] = $href_lang;
        }
    }

    $mode=$et_mode;
    $controller=$et_controller;


    if ($controller === 'companies' && $mode === 'product_view') {
        /** @var array $product */
        $product = $view->getTemplateVars('product');

        if ($product === null) {
            return;
        }

        $show_price = !empty($auth['user_id'])
            || Registry::get('settings.Checkout.allow_anonymous_shopping') !== 'hide_price_and_add_to_cart';

        $key = 'seo_schema_org_markup_items_' . $product['product_id'] . '_' . $show_price;

        $conditions = [
            'products',
            'product_features',
            'product_features_descriptions',
            'product_features_values',
            'settings_objects',
            'settings_vendor_values'
        ];

        fn_set_hook('seo_dispatch_before_display_before_cache', $product, $key, $conditions);

        $schema_org_markup_items = Registry::getOrSetCache(
            ['seo_schema_org_markup_items', $key],
            $conditions,
            ['static', 'storefront', 'lang', 'currency'],
            static function () use ($product, $show_price) {
                return fn_seo_get_schema_org_markup_items($product, $show_price);
            }
        );

        $view->assign('schema_org_markup_items', $schema_org_markup_items);

        $product['seo_snippet'] = fn_seo_get_legacy_markup_data($product, $schema_org_markup_items, $show_price);
        $view->assign('product', $product);
    }

    $view->assign('seo_canonical', $seo_canonical);
    $view->assign('seo_alt_hreflangs_list', $seo_alt_hreflangs_list);
}



function fn_et_vivashop_mv_seo_seo_update_objects_pre(&$object_data, &$object_id, $type, $lang_code, $seo_objects){
  if (isset($object_data['page_type']) && $object_data['page_type']==PAGE_TYPE_VENDOR){
    $object_data=null;
    $object_id=null;
  }
}

function fn_et_vivashop_mv_seo_update_page_post(&$page_data, &$page_id, &$lang_code){
  if (Registry::get('runtime.company_id')) {
    $page_data['company_id'] = Registry::get('runtime.company_id');
    $page_data['vendor_id'] = $page_data['company_id'];
  }
  fn_et_seo_update_object($page_data, $page_id, 'a', $lang_code);
}

function fn_et_seo_update_object($object_data, $object_id, $type, $lang_code)
{

  if (!empty($object_id) && isset($object_data['seo_name'])) {
    $_company_id = '';

    if (fn_allowed_for('ULTIMATE')) {
      if (!empty($seo_vars['not_shared']) && Registry::get('runtime.company_id')) {
        $_company_id = Registry::get('runtime.company_id');
      } elseif (!empty($object_data['company_id'])) {
        $_company_id = $object_data['company_id'];
      }
    }

    // Do nothing if SEO name was not changed
    $old_name = fn_seo_get_name($type, $object_id, '', $_company_id, $lang_code);
    if (!empty($old_name) && $object_data['seo_name'] == $old_name) {
      return true;
    }

    $_object_name = '';
    $seo_vars = fn_get_seo_vars($type);

    if (!empty($object_data['seo_name'])) {
      $_object_name = $object_data['seo_name'];
    } elseif (!empty($object_data[$seo_vars['description']])) {
      $_object_name = $object_data[$seo_vars['description']];
    }

    if (empty($_object_name)) {
      $_object_name = fn_seo_get_default_object_name($object_id, $type, $lang_code);
    }

    $lang_code = fn_get_corrected_seo_lang_code($lang_code);

    // always create redirect, execept it manually disabled
    $create_redirect = isset($object_data['seo_create_redirect']) ? !empty($object_data['seo_create_redirect']) : true;

    if (empty($old_name)) {
      $create_redirect = false;
    }

    $is_tree_object = fn_check_seo_schema_option($seo_vars, 'tree_options');

    // If this is tree object and we need to create redirect - create it for all children
    if ($create_redirect && $is_tree_object) {
      $children = fn_seo_get_object_children($type);
      if (!empty($children)) {
        $path = fn_get_seo_parent_path($object_id, $type);
        $path .= !empty($path) ? '/' . $object_id : $object_id;

        fn_iterate_through_seo_names(
          function ($seo_name) use ($_company_id, $lang_code) {
            $url = fn_generate_seo_url_from_schema(array(
              'type' => $seo_name['type'],
              'object_id' => $seo_name['object_id'],
              'lang_code' => $lang_code
            ), false);

            fn_seo_update_redirect(array(
              'src' => $url,
              'type' => $seo_name['type'],
              'object_id' => $seo_name['object_id'],
              'company_id' => $_company_id,
              'lang_code' => $lang_code
            ), 0, false);
          },
          db_quote(
            "path = ?s OR path LIKE ?l AND type IN (?a)",
            $path, $path . '/%', $children
          )
        );
      }
    }
    $vendor_id = isset($object_data['vendor_id'])
    ? $object_data['vendor_id']
    : '';

    return fn_et_create_seo_name(
      $object_id,
      $type,
      $_object_name,
      0,
      '',
      $_company_id,
      $lang_code,
      $create_redirect,
      AREA,
      ['vendor_id'=>$vendor_id],
      false,
      $object_data['seo_name']
    );
  }

  return false;
}


function fn_et_create_seo_name(
  $object_id,
  $object_type,
  $object_name,
  $index = 0,
  $dispatch = '',
  $company_id = '',
  $lang_code = CART_LANGUAGE,
  $create_redirect = false,
  $area = AREA,
  array $params = [],
  $changed = false,
  $input_object_name = ''
) {
  $cache_max_length = 200;
  static $names_cache = null;
  
  $fields=fn_get_table_fields('seo_names');

  if (!in_array('et_vendor_id',$fields)){
    db_query("ALTER TABLE `?:seo_names` ADD COLUMN `et_vendor_id` int(11) unsigned NOT NULL DEFAULT '0';");
  }

  // Whether to cache fn_get_seo_parent_path() calls.
  $use_generated_paths_cache = isset($params['use_generated_paths_cache'])
    ? $params['use_generated_paths_cache']
    : true;

  /**
   * Create SEO name (running before fn_create_seo_name() function)
   *
   * @param int    $object_id         Object ID
   * @param string $object_type       Object type
   * @param string $object_name       Object name
   * @param int    $index             Index
   * @param string $dispatch          Dispatch (for static object type)
   * @param int    $company_id        Company ID
   * @param string $lang_code         Two-letter language code (e.g. 'en', 'ru', etc.)
   * @param array  $params            Additional params passed to fn_create_seo_name() function
   * @param bool   $create_redirect   Creates 301 redirect if set to true
   * @param string $area              Current working area
   * @param bool   $changed           Object reformat indicator
   * @param string $input_object_name Entered object name
   */
  fn_set_hook(
    'create_seo_name_pre',
    $object_id,
    $object_type,
    $object_name,
    $index,
    $dispatch,
    $company_id,
    $lang_code,
    $params,
    $create_redirect,
    $area,
    $changed,
    $input_object_name
  );

  $seo_settings = fn_get_seo_settings($company_id);
  $non_latin_symbols = $seo_settings['non_latin_symbols'];

  $_object_name = fn_seo_normalize_object_name(fn_generate_name($object_name, '', 0, ($non_latin_symbols === YesNo::YES)));

  if ($_object_name !== $object_name) {
    $changed = true;
  }

  $seo_var = fn_get_seo_vars($object_type);
  if (empty($_object_name)) {
    $_object_name = fn_seo_normalize_object_name($seo_var['description'] . '-' . (empty($object_id) ? $dispatch : $object_id));
  }

  $condition = fn_get_seo_company_condition('?:seo_names.company_id', $object_type, $company_id);
  //et condition
  if (isset($params['vendor_id'])){
    $condition.=db_quote(" AND et_vendor_id = ?i", $params['vendor_id']);
  }
  //et condition

  $path_condition = '';
  if (fn_check_seo_schema_option($seo_var, 'tree_options')) {
    $path_condition = db_quote(
      " AND path = ?s",
      fn_get_seo_parent_path($object_id, $object_type, $company_id, $use_generated_paths_cache)
    );
  }

  if (is_null($names_cache)) {
    $total = db_get_field("SELECT COUNT(*) FROM ?:seo_names WHERE 1 ?p", $condition);

    if ($total < $cache_max_length) {
      $names_cache = db_get_hash_single_array("SELECT name, 1 as val FROM ?:seo_names WHERE 1 ?p", array('name', 'val'), $condition);
    } else {
      $names_cache = array();
    }
  }

  $exist = false;
  if (empty($names_cache) || !empty($names_cache[$_object_name])) {
    $exist = db_get_field(
      "SELECT name FROM ?:seo_names WHERE name = ?s ?p AND (object_id != ?i OR type != ?s OR dispatch != ?s OR lang_code != ?s) ?p",
      $_object_name, $path_condition, $object_id, $object_type, $dispatch, $lang_code, $condition
    );
  }

  if (!$exist) {

    $_data = array(
      'name' => $_object_name,
      'type' => $object_type,
      'object_id' => $object_id,
      'dispatch' => $dispatch,
      'lang_code' => $lang_code,
      'path' => fn_get_seo_parent_path($object_id, $object_type, $company_id, $use_generated_paths_cache)
    );

    if (!empty($input_object_name)) {
      if ($changed) {
        fn_set_notification(
          NotificationSeverity::WARNING,
          __('notice'),
          __('seo.error_incorrect_seo_name', [1, '[names]' => $input_object_name, '[new_names]' => $_object_name]),
          '',
          'incorrect_seo_name'
        );
      } elseif ($index > 0 && $input_object_name !== $_object_name) {
        fn_set_notification(
          NotificationSeverity::WARNING,
          __('notice'),
          __('seo.error_at_creation_seo_name', [1, '[names]' => $input_object_name, '[new_names]' => $_object_name]),
          '',
          'seo_name_already_exists'
        );
      }
    }


    if (fn_allowed_for('ULTIMATE')) {
      if (fn_get_seo_vars($object_type, 'not_shared')) {
        if (!empty($company_id)) {
          $_data['company_id'] = $company_id;
        } elseif (Registry::get('runtime.company_id')) {
          $_data['company_id'] = Registry::get('runtime.company_id');
        }

        // Do not create SEO names for root
        if (empty($_data['company_id'])) {
          return '';
        }
      }
    }

    if ($create_redirect) {
      $url = fn_generate_seo_url_from_schema(array(
        'type' => $object_type,
        'object_id' => $object_id,
        'lang_code' => $lang_code
      ), false, array(), $company_id);
    }
    
    //et data
    $_data['et_vendor_id'] = isset($params['vendor_id'])?$params['vendor_id']:0;
    //et data

    $affected_rows = db_query("INSERT INTO ?:seo_names ?e ON DUPLICATE KEY UPDATE ?u", $_data, $_data);

    // cache object name only if the names cache is not empty already
    if (!empty($names_cache) && $affected_rows) {
      $names_cache[$_object_name] = 1;
    }

    if ($affected_rows && $create_redirect) {
      fn_seo_update_redirect(array(
        'src' => $url,
        'type' => $object_type,
        'object_id' => $object_id,
        'company_id' => $company_id,
        'lang_code' => $lang_code
      ), 0, false);
    }

  } else {
    $index++;

    if ($index == 1) {
      $object_name = $object_name . SEO_DELIMITER . $lang_code;
    } else {
      $object_name = preg_replace("/-\d+$/", "", $object_name) . SEO_DELIMITER . $index;
    }
    $_object_name = fn_create_seo_name(
      $object_id,
      $object_type,
      $object_name,
      $index,
      $dispatch,
      $company_id,
      $lang_code,
      $create_redirect,
      $area,
      $params,
      $changed,
      $input_object_name
    );
  }

  /**
   * Create SEO name (running after fn_create_seo_name() function)
   *
   * @param int    $_object_name      Reformatted object name
   * @param int    $object_id         Object ID
   * @param string $object_type       Object type
   * @param string $object_name       Object name
   * @param int    $index             Index
   * @param string $dispatch          Dispatch (for static object type)
   * @param int    $company_id        Company ID
   * @param string $lang_code         Two-letter language code (e.g. 'en', 'ru', etc.)
   * @param array  $params            Additional params passed to fn_create_seo_name() function
   * @param bool   $create_redirect   Creates 301 redirect if set to true
   * @param string $area              Current working area
   * @param bool   $changed           Object reformat indicator
   * @param string $input_object_name Entered object name
   */
  fn_set_hook(
    'create_seo_name_post',
    $_object_name,
    $object_id,
    $object_type,
    $object_name,
    $index,
    $dispatch,
    $company_id,
    $lang_code,
    $params,
    $create_redirect,
    $area,
    $changed,
    $input_object_name
  );

  return $_object_name;
}

use Tygh\SeoCache;

function fn_et_vivashop_mv_seo_seo_get_name_pre($object_type, $object_id, $dispatch, $company_id, $lang_code)
{
  $fields=fn_get_table_fields('seo_names');

  if (!in_array('et_vendor_id',$fields)){
    db_query("ALTER TABLE `?:seo_names` ADD COLUMN `et_vendor_id` int(11) unsigned NOT NULL DEFAULT '0';");
  }

  $company_id_condition = '';

  if (fn_allowed_for('ULTIMATE')) {
    if ($company_id !== null) {
      $company_id_condition = fn_get_seo_company_condition("?:seo_names.company_id", $object_type, $company_id);
    } else {
      $company_id_condition = fn_get_seo_company_condition('?:seo_names.company_id', $object_type);
      if (Registry::get('runtime.company_id')) {
        $company_id = Registry::get('runtime.company_id');
      }
    }
  }

  if ($company_id == null) {
    $company_id = '';
  }

  $seo_settings = fn_get_seo_settings($company_id);
  $lang_code = fn_get_corrected_seo_lang_code($lang_code, $seo_settings);

  $_object_id = !empty($object_id) ? $object_id : $dispatch;
  $name = SeoCache::get('name', $object_type, $_object_id, $company_id, $lang_code);

  if (is_null($name)) {

    $where_params = array(
      'object_id' => $object_id,
      'type' => $object_type,
      'dispatch' => $dispatch,
      'lang_code' => $lang_code,
    );

    // $company_id_condition
    $seo_data = db_get_row("SELECT name, path FROM ?:seo_names WHERE ?w ?p", $where_params, $company_id_condition);

    if (empty($seo_data)) {
      if ($object_type == 's') {
        $alt_name = db_get_field(
          "SELECT name FROM ?:seo_names WHERE object_id = ?i AND type = ?s AND dispatch = ?s ?p",
          $object_id, $object_type, $dispatch, $company_id_condition
        );
        if (!empty($alt_name)) {
          $name = fn_et_create_seo_name($object_id, $object_type, str_replace('.', '-', $dispatch), 0, $dispatch, $company_id, $lang_code);
          fn_delete_notification('incorrect_seo_name');
        }
      } else if ($object_type == 'a') {
          $vendor_id=db_get_field(
                  "SELECT company_id FROM ?:pages WHERE page_id = ?i ",
                  $object_id);
          $object_name = fn_seo_get_default_object_name($object_id, $object_type, $lang_code);
          $name = fn_et_create_seo_name(
            $object_id, 
            $object_type, 
            $object_name, 
            0, 
            $dispatch, 
            $company_id, 
            $lang_code,
            false,
            AREA,
            ['vendor_id'=>$vendor_id]
          );
      } else {
        $object_name = fn_seo_get_default_object_name($object_id, $object_type, $lang_code);
        if (!empty($object_name)) {
          $name = fn_et_create_seo_name(
            $object_id, 
            $object_type, 
            $object_name, 
            0, 
            $dispatch, 
            $company_id, 
            $lang_code
          );
        }
      }
    }
  }
}
