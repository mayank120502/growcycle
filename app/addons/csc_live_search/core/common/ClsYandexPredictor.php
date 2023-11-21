<?php

/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsYandexPredictor{
	public static function _get($text, $lang_code='', $company_id){
		$available_langs=["af","ar","az","ba","be","bg","bs","ca","cs","cy","da","de","el","en","es","et","eu","fi","fr","ga","gl","he","hr","ht","hu","hy","id","is","it","ka","kk","ky","la","lb","lt","lv","mg","mhr","mk","mn","mrj","ms","mt","nl","no","pl","pt","ro","ru","sk","sl","sq","sr","sv","sw","tg","tl","tr","tt","udm","uk","uz","vi"];
		$available_langs = json_decode($available_langs, true);	
		
		if (in_array($lang_code, $available_langs) && !empty($ls_settings['prediction_key'])){			
			$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);
			$arrContextOptions=array("ssl"=>array("verify_peer"=>false,"verify_peer_name"=>false));
			$result = @file_get_contents("https://predictor.yandex.net/api/v1/predict.json/complete?q=".urlencode($text)."&lang={$lang_code}&key=".$ls_settings['prediction_key'], false, stream_context_create($arrContextOptions));								
			$result = json_decode($result, true);		
			if (!empty($result['text'])){
				$corrections = [];
				foreach ($result['text'] as $corr){
					$corrections[]=[
						'q'=>$corr
					];	
				}
				return $corrections;
			}	
		}
		return [];
	}
}