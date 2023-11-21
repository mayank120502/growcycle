<?php
use Tygh\Registry;
use Tygh\Settings;
use Tygh\Languages\Languages;

function fn_et_extended_banners_pro_install(){

  $fields = fn_get_table_fields('banner_descriptions');
  if (!in_array('company_id', $fields)) {
      db_query("ALTER TABLE `?:banner_descriptions` ADD COLUMN `et_text` text default '', ADD COLUMN `et_settings` text default '';");
  }

}
function fn_et_extended_banners_pro_uninstall(){
  db_query("ALTER TABLE `?:banner_descriptions` DROP `et_text`, DROP `et_settings`;");
}

function fn_et_banners_save_pre(&$data){

	$data['banner_data']['et_text']=isset($data['banner_data']['et_text']) ? serialize($data['banner_data']['et_text']) : '';

	$data['banner_data']['et_settings']=isset($data['banner_data']['et_settings']) ? serialize($data['banner_data']['et_settings']) : '';

	if (!empty($data['banner_id'])) {
		$banner_image_id = fn_get_banner_image_id($data['banner_id']);
		$banner_image_exist = !empty($banner_image_id);
		$banner_is_multilang = Registry::get('addons.banners.banner_multilang') == 'Y';
		$image_is_update = fn_banners_need_image_update();

		if ($banner_is_multilang) {
	    if ($banner_image_exist && $image_is_update) {
	    	$data['banner_data']['old_banner_image_id']=fn_get_banner_image_id($data['banner_id']);
			}
		}
	}
}

function fn_et_banners_save_post($data,$banner_id,$lang_code=DESCR_SL){
	if (!empty($banner_id)) {
		$banner_image_id = fn_get_banner_image_id($banner_id, $lang_code);

		if (empty($banner_image_id)){
			$banner_image_id = db_get_next_auto_increment_id('banner_images');
	    $data_banner_image = array(
	        'banner_image_id' => $banner_image_id,
	        'banner_id'       => $banner_id,
	        'lang_code'       => $lang_code
	    );

	    db_query("INSERT INTO ?:banner_images ?e", $data_banner_image);
		}

		$old_banner_image_id=0;
		if (!empty($data['banner_data']['old_banner_image_id'])) {
	    $old_banner_image_id=$data['banner_data']['old_banner_image_id'];
	  }

	  $desktop_extra_image_pair_data = fn_et_banners_et_banners_need_image_update("desktop_extra",$banner_image_id,$lang_code, $old_banner_image_id);
	  $phone_extra_image_pair_data = fn_et_banners_et_banners_need_image_update("phone_extra",$banner_image_id,$lang_code, $old_banner_image_id);
	  $tablet_extra_image_pair_data = fn_et_banners_et_banners_need_image_update("tablet_extra",$banner_image_id,$lang_code, $old_banner_image_id);

		$phone_image_pair_data = fn_et_banners_et_banners_need_image_update("phone",$banner_image_id,$lang_code, $old_banner_image_id);
		$tablet_image_is_update = fn_et_banners_et_banners_need_image_update("tablet",$banner_image_id,$lang_code, $old_banner_image_id);

		if (isset($data['banner_data']['update_all_langs']) && $data['banner_data']['update_all_langs']=="Y"){
			$desktop_image_img_id=fn_get_image_pairs($banner_id, 'promo', 'M', true, false, $lang_code);

			$lang_codes = Languages::getAll();
			unset($lang_codes[$lang_code]);
			
			foreach ($lang_codes as $new_lang_code => $v) {

				$old_img_id=db_get_field("SELECT banner_image_id FROM ?:banner_images WHERE banner_id = ?i AND lang_code = ?s", $banner_id, $new_lang_code);

				fn_et_replace_image($banner_id,$banner_image_id,'promo',$new_lang_code,$lang_code,$old_img_id);
				fn_et_replace_image($banner_id,$banner_image_id,'et_promo_desktop_extra',$new_lang_code,$lang_code,$old_img_id);

				fn_et_replace_image($banner_id,$banner_image_id,'et_promo_phone_extra',$new_lang_code,$lang_code,$old_img_id);
				fn_et_replace_image($banner_id,$banner_image_id,'et_promo_phone',$new_lang_code,$lang_code,$old_img_id);

				fn_et_replace_image($banner_id,$banner_image_id,'et_promo_tablet_extra',$new_lang_code,$lang_code,$old_img_id);
				fn_et_replace_image($banner_id,$banner_image_id,'et_promo_tablet',$new_lang_code,$lang_code,$old_img_id);


				/* UPDATE settings on all languages */
				db_query("UPDATE ?:banner_descriptions SET ?u WHERE banner_id = ?i AND lang_code = ?s", $data['banner_data'], $banner_id, $new_lang_code);
			}
		}

	}else{
		// NEW banner

		$auto_increment = db_get_next_auto_increment_id('banners');
		$banner_id = $auto_increment-1;
		$banner_image_id=fn_get_banner_image_id($banner_id, $lang_code);

		if (empty($banner_image_id)){
			$banner_image_id = db_get_next_auto_increment_id('banner_images');
	    $data_banner_image = array(
	        'banner_image_id' => $banner_image_id,
	        'banner_id'       => $banner_id,
	        'lang_code'       => $lang_code
	    );

	    db_query("INSERT INTO ?:banner_images ?e", $data_banner_image);
		}


		$desktop_extra_image_pair_data = fn_et_banners_et_banners_need_image_update("desktop_extra",$banner_image_id);
		$phone_extra_image_pair_data = fn_et_banners_et_banners_need_image_update("phone_extra",$banner_image_id);
		$tablet_extra_image_pair_data = fn_et_banners_et_banners_need_image_update("tablet_extra",$banner_image_id);

		$phone_image_pair_data = fn_et_banners_et_banners_need_image_update("phone",$banner_image_id);
		$tablet_image_pair_data = fn_et_banners_et_banners_need_image_update("tablet",$banner_image_id);

		$lang_codes = Languages::getAll();
		unset($lang_codes[$lang_code]);

		foreach ($lang_codes as $lang_code=>$v) {
		  $banner_image_id=fn_get_banner_image_id($banner_id, $lang_code);

	  	if (empty($banner_image_id)){
	  		$banner_image_id = db_get_next_auto_increment_id('banner_images');
	      $data_banner_image = array(
	          'banner_image_id' => $banner_image_id,
	          'banner_id'       => $banner_id,
	          'lang_code'       => $lang_code
	      );

	      db_query("INSERT INTO ?:banner_images ?e", $data_banner_image);
	  	}

  	  if (!empty($desktop_extra_image_pair_data)) {
      	$desktop_extra_image_pair_data = reset($desktop_extra_image_pair_data);
    	  fn_add_image_link($banner_image_id,$desktop_extra_image_pair_data);
    	}

  	  if (!empty($phone_extra_image_pair_data)) {
      	$phone_extra_image_pair_data = reset($phone_extra_image_pair_data);
    	  fn_add_image_link($banner_image_id,$phone_extra_image_pair_data);
    	}

  	  if (!empty($tablet_extra_image_pair_data)) {
      	$tablet_extra_image_pair_data = reset($tablet_extra_image_pair_data);
    	  fn_add_image_link($banner_image_id,$tablet_extra_image_pair_data);
    	}

			if (!empty($phone_image_pair_data)) {
		  	$phone_image_pair_data = reset($phone_image_pair_data);
			  fn_add_image_link($banner_image_id,$phone_image_pair_data);
			}

		  if (!empty($tablet_image_pair_data)) {
		  	$tablet_image_pair_data = reset($tablet_image_pair_data);
			  fn_add_image_link($banner_image_id,$tablet_image_pair_data);
			}
		}
	}
}

function fn_et_replace_image($banner_id,$banner_image_id,$object_type,$lang_code,$from_lang_code=DESCR_SL,$old_img_id){


	if ($old_img_id){
		$old_image_pairs=fn_get_image_pairs($old_img_id, $object_type, 'M', true, false, $lang_code);

		if (!empty($old_image_pairs)){
		  fn_delete_image_pairs($old_img_id, $object_type);
		}else{
			db_query("DELETE FROM ?:banner_images WHERE banner_image_id = ?i", $old_img_id);
		}
	}

	$image_pairs=fn_get_image_pairs($banner_image_id, $object_type, 'M', true, false, $from_lang_code);

	if (!empty($image_pairs)){
		$pair_data = array($image_pairs['pair_id']);
		if ($object_type=='promo'){
			$pair_id = reset($pair_data);
			$_banner_image_id = db_query("INSERT INTO ?:banner_images (banner_id, lang_code) VALUE(?i, ?s)", $banner_id, $lang_code);
			fn_add_image_link($_banner_image_id, $pair_id);
		}else{
			$pair_data = reset($pair_data);
			$_banner_img_id=db_get_field("SELECT banner_image_id FROM ?:banner_images WHERE banner_id = ?i AND lang_code = ?s", $banner_id, $lang_code);
			fn_add_image_link($_banner_img_id, $pair_data);
		}
	}

}

function fn_et_banners_get_banner_data($banner_id, $lang_code, &$fields, $joins, $condition){
	$fields[]='?:banner_descriptions.et_text';
	$fields[]='?:banner_descriptions.et_settings';
	$fields[]='?:banners.company_id';
}

function fn_et_banners_get_banner_data_post($banner_id, $lang_code, &$banner){
	$banner['et_text']=isset($banner['et_text']) ? unserialize($banner['et_text']) : '';

	$banner['et_settings']=isset($banner['et_settings']) ? unserialize($banner['et_settings']) : array('desktop'=>'','tablet'=>'','phone'=>'');

	if (!empty($banner['et_settings']['desktop'])){
		$banner['et_settings']['desktop']['additional']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_desktop_extra', 'M', true, false, $lang_code);
	}

	if (!empty($banner['et_settings']['phone'])){
		$banner['et_settings']['phone']['additional']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_phone_extra', 'M', true, false, $lang_code);
		$banner['et_settings']['phone']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_phone', 'M', true, false, $lang_code);
	}
	if (!empty($banner['et_settings']['tablet'])){
		$banner['et_settings']['tablet']['additional']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_tablet_extra', 'M', true, false, $lang_code);
		$banner['et_settings']['tablet']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_tablet', 'M', true, false, $lang_code);
	}
}

function fn_et_banners_et_banners_need_image_update($name,$banner_image_id,$lang_code = DESCR_SL,$old_banner_image_id=0)
{
	$field_name="file_et_banners_".$name."_image_icon";
	$image_name="et_banners_".$name;
	$image_object_type="et_promo_".$name;

	if (!empty($old_banner_image_id)){
		$image_pairs=fn_get_image_pairs($old_banner_image_id, $image_object_type, 'M', true, false, $lang_code);

		if (!empty($image_pairs)){
			$pair_data=array($image_pairs['pair_id']);
			$pair_data = reset($pair_data);
			fn_add_image_link($banner_image_id,$pair_data);
			fn_delete_image_pairs($old_banner_image_id, $image_object_type);
		}
	}

  if (!empty($_REQUEST[$field_name]) && is_array($_REQUEST[$field_name])) {
      $image_banner = reset($_REQUEST[$field_name]);

      if ($image_banner == $image_name) {
      	fn_attach_image_pairs($image_name, $image_object_type, $banner_image_id, $lang_code);
        return false;
      }
  }

  fn_delete_image_pairs($banner_image_id, $image_object_type);
  $pair_data=fn_attach_image_pairs($image_name, $image_object_type, $banner_image_id, $lang_code);
  return $pair_data;
}

function fn_et_banners_get_banners($params, $condition, $sorting, $limit, $lang_code, &$fields){
	$fields[]='?:banner_descriptions.et_text';
	$fields[]='?:banner_descriptions.et_settings';
}

function fn_et_banners_get_banners_post(&$banners, $params){
	foreach ($banners as $key => $banner) {
		$banners[$key]['et_text']=isset($banner['et_text']) ? unserialize($banner['et_text']) : '';
		$banners[$key]['et_settings']=isset($banner['et_settings']) ? unserialize($banner['et_settings']) : '';

		if (isset($banners[$key]['et_settings']) && !empty($banners[$key]['et_settings'])){
			static $cache = array();
			$cache_id=$banner['banner_id'];

			if (!isset($cache[$cache_id])) {

				$banners[$key]['et_settings']['desktop']['additional']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_desktop_extra', 'M', true, false);
				$banners[$key]['et_settings']['phone']['additional']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_phone_extra', 'M', true, false);
				$banners[$key]['et_settings']['tablet']['additional']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_tablet_extra', 'M', true, false);


				$banners[$key]['et_settings']['phone']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_phone', 'M', true, false);
				$banners[$key]['et_settings']['tablet']['main_pair']=fn_get_image_pairs($banner['banner_image_id'], 'et_promo_tablet', 'M', true, false);

				$cache[$cache_id]=$banners[$key];
			}else{
				$banners[$key]=$cache[$cache_id];
			}
		}
	}
}

function fn_et_banners_delete_banners($banner_id){
	$lang_codes = Languages::getAll();

	foreach ($lang_codes as $lang_code=>$v) {
	  $banner_image_id=fn_get_banner_image_id($banner_id, $lang_code);
	  fn_delete_image_pairs($banner_image_id, 'et_promo_desktop_extra');
	  fn_delete_image_pairs($banner_image_id, 'et_promo_phone_extra');
	  fn_delete_image_pairs($banner_image_id, 'et_promo_tablet_extra');

	  fn_delete_image_pairs($banner_image_id, 'et_promo_phone');
	  fn_delete_image_pairs($banner_image_id, 'et_promo_tablet');
	}
}


function fn_et_banners_clone($banners, $lang_code)
{
    foreach ($banners as $id => $banner) {
        if (
        	empty($banner['et_settings']['desktop']['additional']['main_pair']['pair_id']) &&
        	empty($banner['et_settings']['phone']['additional']['main_pair']['pair_id']) &&
        	empty($banner['et_settings']['phone']['main_pair']['pair_id']) &&
        	empty($banner['et_settings']['tablet']['additional']['main_pair']['pair_id']) &&
        	empty($banner['et_settings']['tablet']['main_pair']['pair_id'])
        ) {
            continue;
        }

        $banner_image_id = db_get_field("SELECT banner_image_id FROM ?:banner_images WHERE banner_id=?i AND lang_code=?s", $id, $lang_code);

        if (!empty($banner['et_settings']['desktop']['additional']['main_pair']['pair_id'])) {
        	fn_add_image_link($banner_image_id, $banner['et_settings']['desktop']['additional']['main_pair']['pair_id']);
        }

        if (!empty($banner['et_settings']['phone']['additional']['main_pair']['pair_id'])){
        	fn_add_image_link($banner_image_id, $banner['et_settings']['phone']['additional']['main_pair']['pair_id']);
        }
        if (!empty($banner['et_settings']['phone']['main_pair']['pair_id'])){
        	fn_add_image_link($banner_image_id, $banner['et_settings']['phone']['main_pair']['pair_id']);
        }

        if (!empty($banner['et_settings']['tablet']['additional']['main_pair']['pair_id'])){
        	fn_add_image_link($banner_image_id, $banner['et_settings']['tablet']['additional']['main_pair']['pair_id']);
        }
        if (!empty($banner['et_settings']['tablet']['main_pair']['pair_id'])){
        	fn_add_image_link($banner_image_id, $banner['et_settings']['tablet']['main_pair']['pair_id']);
        }

    }
}

function fn_et_banners_update_language_post($language_data, $lang_id, $action)
{
  if ($action == 'add') {
      list($banners) = fn_get_banners(array(), DEFAULT_LANGUAGE);
      fn_et_banners_clone($banners, $language_data['lang_code']);
  }
}