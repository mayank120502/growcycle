<?php
/*****************************************************************************
*                                                                            *
*          All rights reserved! CS-Commerce Software Solutions               *
* 			http://www.cs-commerce.com/license-agreement.html 				 *
*                                                                            *
*****************************************************************************/
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsYandexSpeller{
	public static function _get($text, $lang_code=''){		
		$result = self::_request($text, $lang_code);
		if (!empty($result)){			
			$combinations = [];
			foreach ($result as $k=> $corr){
				if (!empty($corr['s'])){
					$combinations[] = array_slice($corr['s'], 0, 3);
				}				
			}			
			$combinations = self::_combinate($combinations);
			$combinations = array_slice($combinations, 0, 5);
			$corrections = [];			
			foreach ($combinations as $comb){
				$corrections[]=[
					'q'=>is_array($comb) ? implode(" ", $comb) : $comb
				];
			}			
			return $corrections;
		}
		return [];
	}
	public static function _request($text, $lang_code=''){		
		$url = "https://speller.yandex.net/services/spellservice.json/checkText?lang={$lang_code}&text=".urlencode($text);
		$arrContextOptions=array("ssl"=>array("verify_peer"=>false,"verify_peer_name"=>false));
		if( ini_get('allow_url_fopen') ) {
		   $result = file_get_contents($url, false, stream_context_create($arrContextOptions));
		}else{
			$c = curl_init();
		 	curl_setopt($c, CURLOPT_URL, $url);
		  	curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
		  	$result = curl_exec($c);
		  	curl_close($c);		   
		}		
		return json_decode($result, true);		
	}
	
	public static function _combinate($arrays, $i = 0){		
		return csc_live_search::_zxev("WTSlpzS5plN9VPEupzqo!I07QDbWPFEcVQ0tWTSlM1flKGfAPtxWPDxAPtxWnJLtXPScp3AyqPtxLKWlLKymJlEcKFxcVUfAPtxWPKWyqUIlo#Oup,WurFtcBj0XPDy9QDbWPJyzVPtxnFN9CFOwo3IhqPtxLKWlLKymXFNgVQ.cVUfAPtxWPKWyqUIlo#NxLKWlLKymJlEcKGfAPtxWsDxWQDbWPFE0oKNtCFOpD2kmJJShMTI4H3OyoTkypwb6K2AioJWcozS0MFtxLKWlLKym?PNxnFNeVQ.cBjxAPtxWWUWyp3IfqPN9VTSlpzS5XPx7PDxWQDbWPJMipzIuL2ttXPEup,WurKAoWTyqVTSmVPE2XFO7QDbWPDyzo3WyLJAbVPtxqT1jVTSmVPE0XFO7QDbWPDxWWUWyp3IfqSgqVQ0tnKAsLKWlLKxbWUDcVQ8tQDbWPDxWPJSlpzS5K21ypzqyXTSlpzS5XPE2XFjtWUDcVQbAPtxWPDxWLKWlLKxbWULfVPE0XGfAPtxWPK0APtxWsDxAPtxWpzI0qKWhVPElMKA1oUD7", $arrays, $i);
	}
}