<?php
use Tygh\CscLiveSearch;
if (!defined('BOOTSTRAP')) { die('Access denied'); }
class ClsSearchProducts{
	public static function _get_products($params, $items_per_page){
		$company_id = fn_cls_get_current_company_id($params);
		$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);					
		list($params['sort_by'], $params['sort_order']) = explode('|', $ls_settings['sort_by']);		
		$config = fn_get_config_data();			
				
		if (!empty($params['q'])){
			list($params['rid'], $params['qid']) = self::_save_search_statistic($params, $company_id, $ls_settings);			
			$sortings = self::_get_sortings($params);
			$sorting = $sortings[$params['sort_by']] . ' ' . $params['sort_order'];	
			//$sorting .= ', products.product_id ASC'; //
		}
		if (!empty($params['pids'])){
			$sorting = db_quote(' FIELD(products.product_id, ?a)', $params['pids']);	
		}
		if (!empty($sorting)){
			$sorting = 'ORDER BY '.$sorting;	
		}
		$join = $condition = '';
		if ($ls_settings['clss_status'] && $ls_settings['speedup_level']=='hard'){					
			list($_join, $_condition) = ClsSearchSpeedup::_get_search_conditions($params['q'], $ls_settings['speedup_cluster_size'], $ls_settings);
			$join .= $_join;
			$condition .= $_condition;			
		}
		
		$fields = self::_get_fields($ls_settings, $params);
		$join .= self::_get_joins($params, $ls_settings, $company_id);
		$condition .= self::_get_conditions($params, $ls_settings);
							
		$limit = " LIMIT ".(($params['page'] - 1) * $items_per_page) .", ".$items_per_page;		
		if (!empty($params['group_by']) && $params['group_by']=="categories"){		
			$products_categories = db_get_hash_array("SELECT ?:categories.category_id, ?:categories.id_path, cd.category, '' as cl, COUNT(DISTINCT(products.product_id)) as total FROM ?:products as products $join 
			WHERE 1 			
			$condition 
			GROUP BY ?:categories.category_id
			ORDER BY total DESC", 'category_id');	
						
			$selected_cids = explode(',', $params['current_cid']);	
			$count = 0;	
			$_products_categories = [];		
			foreach ($products_categories as $cid=>$data){
				$count ++;
				$suffix='';
				$root = explode('/', $data['id_path']);
				$root = reset($root);
				$root_name=self::_get_ccategory_name($root, $params['lang_code']);								
				if (count($products_categories) > 10 && $count > 6){
					$suffix=' clsHidden';	
				}
				$_products_categories[$root]['subcats'][$count]=$data;
				if (in_array($cid, $selected_cids)){
					$_products_categories[$root]['subcats'][$count]['cl'] = 'clsChecked'.$suffix;	
				}else{
					$_products_categories[$root]['subcats'][$count]['cl'] = 'clsUnChecked'.$suffix;	
				}
				$_products_categories[$root]['root']['cid'] = $root;
				$_products_categories[$root]['root']['name'] = $root_name;
			}
			$_products_categories = array_values($_products_categories);
				
			//fn_print_r($_products_categories);		
								
			return [$_products_categories, $params];
		}
		fn_cls_hook_function('hooks_get_products', $ls_settings, $company_id, $params, $fields, $join, $condition, $sorting, $limit);		
		$products=[];
		$params['total_items']=0;
		if ($items_per_page > 0){
			$products = db_get_hash_array("SELECT " . implode(',', $fields) . " FROM ?:products as products $join 
				WHERE 1 $condition 
				GROUP BY products.product_id
				$sorting $limit", 'product_id');
			if ($products){
				$params['total_items'] = db_get_field("SELECT COUNT(DISTINCT(products.product_id)) FROM ?:products as products $join WHERE 1 $condition");					
			}
			self::_save_requests_found_products($params, $ls_settings);
			
			
		}
		if ($params['total_items'] > $params['page'] * $items_per_page){
			$params['next_page'] = $params['page'] + 1;		
		}else{
			$params['next_page'] = 0;	
		}			
		if ($products){
			$pids = array_keys($products);		
			$images = db_get_hash_array("SELECT * FROM  ?:images_links 
			LEFT JOIN ?:images ON ?:images.image_id = ?:images_links.detailed_id WHERE object_id IN (".implode(',', $pids).") AND object_type='product' AND type='M'", 'object_id');
			
			$mc_join= fn_cls_get_usergroups_conditions($params, '?:categories');			
			if (PRODUCT_EDITION=="ULTIMATE"){
				$mc_join .=" AND ?:categories.company_id = $company_id";
			}	 		
			$main_categories = db_get_hash_array("SELECT category, ?:categories.category_id, product_id FROM ?:category_descriptions 
			INNER JOIN ?:categories ON ?:categories.category_id = ?:category_descriptions.category_id $mc_join			
			INNER JOIN ?:products_categories ON ?:products_categories.category_id=?:categories.category_id
			WHERE 
					?:category_descriptions.lang_code=?s
				AND ?:categories.status IN (?a)
				AND ?:products_categories.product_id IN (?a)
				ORDER BY ?:products_categories.link_type DESC
				
			", 'product_id', $params['lang_code'], ['A', 'H'], $pids);
						
			/*$prices = db_get_hash_single_array("SELECT product_id, price FROM ?:product_prices 
			 WHERE product_id IN (?a) AND lower_limit='1' AND usergroup_id='0'", ['product_id', 'price'], $pids);
			 */
			 			
			foreach ($images as $pid=>$image){
				$folder = floor($image['image_id']/1000);
				$img = 'images/detailed/' . $folder . "/" .  $image['image_path'];                
				$products[$pid]['img']=self::_get_thumbnail($img, $folder, $pid, 150, 150);
                if ($config['http_path']){
                    $products[$pid]['img'] = $config['http_path'].$products[$pid]['img'];
                }                
			}					
			foreach($products as &$p){
				//assign categories
				if (!empty($main_categories[$p['product_id']])){
					$p['category'] = $main_categories[$p['product_id']]['category'];
					$p['category_id'] = $main_categories[$p['product_id']]['category_id'];		
				}
				
									
				$delete_list_price=false;
				if ($p['list_price'] <= $p['price']){
					$delete_list_price=true;
				}							
				self::_format_prices($p, $params['currency']);
				if ($delete_list_price){
					$p['list_price']='';	
				}							
				$p['labelBg'] = CscLiveSearch::_get_bg_color($p['category_id'], $ls_settings);
				if (empty($p['img'])){
					$p['img'] = self::_get_thumbnail('', '', $p['product_id'], 150, 150);	
				}
			}	
		}
		
		return array(array_values($products), $params);
	}
		
	public static function _get_price_field($table_name = 'shared_prices'){
		return 'IF('
			. "{$table_name}.product_id IS NOT NULL, "
			. 'MIN(IF ('
				. "{$table_name}.percentage_discount = 0, "
				. "{$table_name}.price, "
				. "{$table_name}.price - ({$table_name}.price * {$table_name}.percentage_discount) / 100)"
			. '), '
			. 'MIN(IF ('
				. 'prices.percentage_discount = 0, '
				. 'prices.price, '
				. 'prices.price - (prices.price * prices.percentage_discount) / 100)'
			. ')'
		. ')';
	}	
	
	public static function _get_fields($ls_settings, $params){		
		$fields = array(
			'products.product_id',
			'products.product_code',
			'products.list_price',			
			'products.amount',
			'descr1.product'							
		);
		if (PRODUCT_EDITION=="ULTIMATE"){
			$fields[] = self::_get_price_field() .' as price';	
		}else{
			$fields[]='prices.price as price';	
		}
		
		$table_schema = db_get_hash_array("SHOW COLUMNS FROM ?:products", "Field");
		if (!empty($table_schema['currency'])){
			$fields[] = 'products.currency';
		}
		
		fn_cls_hook_function('hooks_get_fields', $ls_settings, $params, $fields);
				
		return $fields;					
	}
	
	public static function _get_joins($params, $ls_settings, $company_id, $join=''){
		$join = csc_live_search::_zxev("WUOupzSgpm0xLKW,JmSqBjbWPFEfp19mMKE0nJ5,pm0xLKW,JmWqBjbWPFEwo21jLJ55K2yxCFEupzqo!107PtxWWTcinJ49WTSlM1f0KGfXPDycM#NbVJIgpUE5XPEfp19mMKE0nJ5,p1f,p2IupzAbK2W5K2MyLKE1pzImW10cXKfXPDxtVPNtWTkmK3AyqUEcozqmJlqmMJSlL2usL,ysMzIuqUIlMK!,KFN9VTSlpzS5K2McoUEyp#txoUAsp2I0qTyhM3AoW3AyLKWwnS9#rI9zMJS0qKWyplqqXGfXPDy9PtxWnJLtX.SFEH.9CFWOV#NzW#NxoUAsp2I0qTyhM3AoW2Afp3AsLJEgnJ5sp3EuqUImW10crjbWPFNtVPNxoUAsp2I0qTyhM3AoW2Afp3Asp3EuqUImW109qUW1MGfXPDy9PtxWPtxWnJLtXUA0p,Oipltxnz9co#jtWlOjpz9xqJA0p19wLKEyM29lnJImVPpcCG09MzSfp2HcrjbWPFNtVPNxnz9co#NhCFVtFH5BEIVtFx9WG#N/B,Olo2E1L3EmK2AuqTI,o3WcMK!tLK!tpUWiMUIwqUAsL2S0MJqipzyyplOCG#Ojpz9xqJA0p19wLKEyM29lnJIm?,Olo2E1L3EsnJD9pUWiMUIwqU!hpUWiMUIwqS9cMPV7PtxWsDbWPJyzVPumqUWjo3!bWTcinJ4fVPptCmcwLKEyM29lnJImVPpcCG09MzSfp2HcrjbWPDxxnz9co#NhCFVtFH5BEIVtFx9WG#N/BzAuqTI,o3WcMK!XPDxWPH9BVQ86L2S0MJqipzyypl5wLKEyM29lrI9cMPN9VUOlo2E1L3EmK2AuqTI,o3WcMK!hL2S0MJqip,ysnJDtPtxWPDyOGxDtCmcwLKEyM29lnJIm?,A0LKE1plOWG#NbW0.,?PN,FPpcPDxWPtxWPFV7PtxWPFEdo2yhVP49VTMhK2Afp19,MKEsqKAypzqlo3Ijp19wo25xnKEco25mXPEjLKWuoK!fVPp/BzAuqTI,o3WcMK!,XGfXPDxWPtxWPJyzVPuDHx9.IHAHK0I.FIEWG049CFWIGSEWGHSHEFVcrjbWPDxWWTcinJ4t?w0#V.SBEPN/BzAuqTI,o3WcMK!hL29gpTShrI9cMPN9VPEwo21jLJ55K2yxVwfXPDxWsDbWPK0XPDycM#NbHSWCESIQIS9SE.yHFH9BCG0#GII!I.yJEH5.G1V#XKfXPDxWnJLtXUA0p,Oipltxnz9co#jtWlOwo21jLJ5cMK!tWlx9CG1zLJkmMFy7PDbWPDxWWTcinJ4t?w1xLy9kqJ90MFt#V.kSEyDtFx9WG#N/BzAioKOuozyyplOuplOwo21jLJ5cMK!tG04tL29gpTShnJIm?zAioKOuo,ysnJDtCFOjpz9xqJA0pl5wo21jLJ55K2yxV#x7PtxWPK0XPDy9PtxWnJLtXUA0p,Oipltxnz9co#jtWlOwp3AcVPpcCG09MzSfp2HtW#LtWTkmK3AyqUEcozqmJlqwoUAmK3A0LKE1plqqXKfXPDxtVPNtWTcinJ4t?w1xLy9kqJ90MFt#V.yBGxIFV.cCFH4tCmcwp2Asp2IupzAbK3AjMJIxqKOsnJ5xMKttLK!tL3AmnFOCG#Ojpz9xqJA0pl5jpz9xqJA0K2yxCJAmp2xhpUWiMUIwqS9cMPOOGxDtL3AmnF5fLJ5,K2AiMTH9C3!#?PNxpTSlLJ1mJlqfLJ5,K2AiMTH,KFx7PtxWsDbWPDbWPJyzVPumqUWjo3!bWTcinJ4fVPptMTImL3VkVPpcCG09MzSfp2HcrjxWPDxXPDxWWTcinJ4t?w0#VNbWPHkSEyDtFx9WG#N/B,Olo2E1L3EsMTImL3WcpUEco25mVTSmVTEyp2Al!FOCG#NtMTImL3Vk?,Olo2E1L3EsnJD9pUWiMUIwqU!hpUWiMUIwqS9cMPOOGxDtMTImL3Vk?zkuozqsL29xMG0,WUOupzSgp1gfLJ5,K2AiMTIqWlV7PtxWsDbWPJyzVPumqUWjo3!bWTcinJ4fVPptpUWcL2ImVPpcCG09MzSfp2HcrjxWPtxWPFEdo2yhVP49V#NXPDxtVPNtG.ITIPOXG0yBVQ86pUWiMUIwqS9jpzywMK!tLK!tpUWcL2ImV.9BVUOlnJAypl5jpz9xqJA0K2yxVQ0tpUWiMUIwqU!hpUWiMUIwqS9cMPOOGxDtpUWcL2Im?zkiq2IlK2kcoJy0VQ0t!FOOGxDtpUWcL2Im?,ImMKW,pz91pS9cMQ0,!Pp#BjbWPFNtVPOcM#NbHSWCESIQIS9SE.yHFH9BCG0#IHkHFH1OI.H#VPLzV.SFEH.9CFWQGS!#XKfXVPNtVNxWPFEdo2yhVP49VTE#K3S1o3EyXPVtG.ITIPOXG0yBVQ86qJk0K3Olo2E1L3EspUWcL2ImVTSmVUAbLKWyMS9jpzywMK!tG04tp2uupzIxK3OlnJAypl5jpz9xqJA0K2yxVQ0tpUWiMUIwqU!hpUWiMUIwqS9cMPOOGxDtp2uupzIxK3OlnJAypl5fo3qypy9fnJ1cqPN9VQ.tDH5.VUAbLKWyMS9jpzywMK!hqKAypzqlo3IjK2yxCFpjWlOOGxDtp2uupzIxK3OlnJAypl5wo21jLJ55K2yxVQ0tC2x#?PNxL29gpTShrI9cMPx7PDbtVPNtPDy9PtxWsDbWPDbWPJyzVPumqUWjo3!bWTcinJ4fVPptL2DtWlx9CG1zLJkmMFy7PDxXPDxWWTcinJ4t?w0#V.kSEyDtFx9WG#N/BzAuqTI,o3W5K2Eyp2AlnKO0nJ9hplOuplOwMPNXPDxWPH9BVTAx?zAuqTI,o3W5K2yxVQ0tCmcwLKEyM29lnJIm?zAuqTI,o3W5K2yxV.SBEPOwMP5fLJ5,K2AiMTH9WlEjLKWuoKAooTShM19wo2EyKFp#BjbWPK0WPtxWPtxWnJLtXPEfp19mMKE0nJ5,p1f,p2IupzAbK29hK3Owo2EyW109CFWMV#NzW#O2MKWmnJ9hK2AioKOupzHbHSWCESIQIS9JEIWGFH9B?PN,AP4k!#4kWljtWmj,XFy7PtxWPFEdo2yhVP49VTE#K3S1o3EyXPVtG.ITIPOXG0yBVQ86pUWiMUIwqS9ipUEco25mK2yhqzIhqT9lrFOuplOjpz9xqJA0K29jqTyio,AsnJ52MJ50o3W5VPOCG#Ojpz9xqJA0pl5jpz9xqJA0K2yxCKOlo2E1L3Eso3O0nJ9hp19co,Myo,Eip,xhpUWiMUIwqS9cMPVcBjxWPDxXPDy9PDxWPDxWPtxWnJLtXPtxpTSlLJ1mJlqmo3W0K2W5W109CFWwoUAspzIfK3OipPVtsUjtWUOupzSgp1f,p29lqS9#rFqqCG0#L2kmK3WyoPVcVPLzVPSyoKO0rFtxpTSlLJ1mJlqkW10cVPLzVPSyoKO0rFtxpTSlLJ1mJlqknJD,KFxcrjxWPDxWPDxWPtxWPFEdo2yhVP49VTE#K3S1o3EyXPVtG.ITIPOXG0yBVQ86L3AwK2kcqzIsp2IupzAbK3OipUIfLKWcqUxtLK!toUAjV.9BVTkmpP5jpz9xqJA0K2yxCKOlo2E1L3Em?,Olo2E1L3EsnJDtDH5.VUScMQ0/nFVfVPEjLKWuoKAoW3ScMPqqXGfWPDxWPDbWPK0WPDbWPJyzVPtbWUOupzSgp1f,p29lqS9#rFqqCG0#pT9jqJkupzy0rFVcVPLzVPSyoKO0rFtxpTSlLJ1mJlqkW10cVPLzV.SFEH.9CFWQGS!#XKfWPDxWPDxWPDbWPDxxnz9co#NhCFOxLy9kqJ90MFt#V.kSEyDtFx9WG#N/B,Olo2E1L3EspT9jqJkupzy0rFOuplOjo3O1oTSlnKE5V.9BVUOipUIfLKWcqUxhpUWiMUIwqS9cMQ1jpz9xqJA0pl5jpz9xqJA0K2yxV#jtWUOupzSgp1f,pJyxW10cBjxWPDxWPtxWsDbWPDbWPDbWPJyzVPtxoUAsp2I0qTyhM3AoW3AyLKWwnS9ioy9ipUEco25mW109CFWMV#NzW#NuMJ1jqUxbWUOupzSgp1f,pFqqXFNzW#NuWTkmK3AyqUEcozqmJlqwoUAmK3A0LKE1plqqXKfXPDxWWTcinJ4t?w0tV#O!EHMHV.cCFH4tCmcjpz9xqJA0K29jqTyio,!tLK!tpS9ipUEco25mV.9BVUOso3O0nJ9hpl5jpz9xqJA0K2yxVQ4t!POOGxDtpUWiMUIwqU!hpUWiMUIwqS9cMQ1jK29jqTyio,!hpUWiMUIwqS9cMPV7PtxWPFEdo2yhVP49VPVtG.ITIPOXG0yBVQ86pUWiMUIwqS9,oT9#LJkso3O0nJ9hK2kcozgmVTSmVTqso3O0nJ9hplOCG#Ojpz9xqJA0pl5jpz9xqJA0K2yxCJqso3O0nJ9hpl5jpz9xqJA0K2yxVwfWPDbWPK0XPDycM#NbWTkmK3AyqUEcozqmJlqmMJSlL2uso25sMzIuqUIlMK!,KG09Vyx#VPLzVPSyoKO0rFtxpTSlLJ1mJlqkW10cVPLzVP.xoUAsp2I0qTyhM3AoW2Afp3Asp3EuqUImW10crjbWPFNtVPNxM,ElK2AhMQ0,WmfXPDxtVPNtnJLtXPSyoKO0rFtxoUAsp2I0qTyhM3AoW3AyLKWwnS9#rI9zMJS0qKWyplqqXFy7PtxWVPNtVPNtWTM0py9wozDtCJE#K3S1o3EyXPVtDH5.VUOzK3MuoUIypl5zMJS0qKWyK2yxV.yBVPt/LFx#?PNxoUAsp2I0qTyhM3AoW3AyLKWwnS9#rI9zMJS0qKWyplqqXGfXPDxtVPNtsDbWPDxxnz9co#NhCFOxLy9kqJ90MFt#V.kSEyDtFx9WG#N/B,Olo2E1L3EsMzIuqUIlMKAsqzSfqJImVTSmVUOzK3MuoUIyplNtG04tpUWiMUIwqU!hpUWiMUIwqS9cMQ1jMy92LJk1MK!hpUWiMUIwqS9cMPNxM,ElK2AhMPOOGxDtpTMsqzSfqJIm?zkuozqsL29xMG0,rlEjLKWuoKAoW2kuozqsL29xMFqqsFp#XGfXPDxWWTcinJ4t?w0tMTWspKIiqTHbV#O!EHMHV.cCFH4tCmcjpz9xqJA0K2MyLKE1pzIsqzSlnJShqS9xMKAwpzyjqTyio,!tLK!tpTMsqzSlnJShqU!tV.9BVUOzK3Mupzyuo,Em?,Mupzyuo,EsnJD9pTMsqzSfqJIm?,Mupzyuo,EsnJD#XGfXPDy9PtxWPtxWnJLtXPEfp19mMKE0nJ5,p1f,p2IupzAbK29hK3EuM3!,KG09Vyx#VPLzVPSyoKO0rFtxpTSlLJ1mJlqkW10cVPLzVP.xoUAsp2I0qTyhM3AoW2Afp3Asp3EuqUImW10crjbWPDxxnz9co#NhCFOxLy9kqJ90MFt#V.kSEyDtFx9WG#N/B,EuM19fnJ5eplOuplO0M2jtV.9BVUOlo2E1L3Em?,Olo2E1L3EsnJD9qTqf?z9#nzIwqS9cMPOOGxDtqTqf?z9#nzIwqS90rKOyCG9mV#jtW1N,XGfXPDxWWTcinJ4t?w0tMTWspKIiqTHbV#O!EHMHV.cCFH4tCmc0LJqmVTSmVUE,VPOCG#O0M2jhqTS,K2yxCKE,?,EuM19cMPOOGxDtqTphp3EuqUImCG9mV#jtW0.,XGfWPtxWsDbWPFEuMTEio,!tCFOpMz5sL2kmK2qyqS9uL3EcqzIsLJExo25mXPx7PtxWWUAyqUEcozqmVQ0tKTMhK2Afp19,MKEsp3EipzIsp2I0qTyhM3!bXGfWPDbWPDxWPDxXPDxiXx1OH1ESH#ODHx9.IHAHHlbiPtxWnJLtX.SFEH.9CFWQGS!#VPLzVTyhK2SlpzS5XPqgLKA0MKWspUWiMUIwqU!,?PNxLJExo25mXFy7PtxWPJyzVPuyoKO0rFtxpTSlLJ1mJlqlqJ50nJ1yK2AioKOuo,ysnJD,KFxcrjxWPDxXPDxWPFEdo2yhVP49VTE#K3S1o3EyXNbWPDxWPFptG.ITIPOXG0yBVQ86oJSmqTIlK3Olo2E1L3EmK3A0o3WyM,Wio,Eso2MzMKWmK2AiqJ50V.SGVT1up3Eypy9jpz9xqJA0p19mqT9lMJMlo250K29zMzIlp19wo3IhqPN,PtxWPDxW?#N,V.9BVT1up3Eypy9jpz9xqJA0p19mqT9lMJMlo250K29zMzIlp19wo3IhqP5jpz9xqJA0K2yxVQ0tpUWiMUIwqU!hpUWiMUIwqS9cMPpXPDxWPFx7PDxWPDbWPDxWPtxWPK0XPDy9PtxW?lcKDIWSF.9IH0IGX#8WPtxWnJLtXUA0p,Oipltxnz9co#jtWlO3LKWynT91p2ImK2Eyp3EcozS0nJ9hK3Olo2E1L3EmK2Sgo3IhqPpcCG09MzSfp2HcrjxXVPNtVNxWnJLtXTyhK2SlpzS5XPq3LKWynT91p2ImWljtWTSxMT9hplxtW#LtXPSyoKO0rFtxpTSlLJ1mJlq3LKWynT91p2ImK2Eyp3EcozS0nJ9hK2yxW10cVPLzVPtbWUAyqUEcozqmJlqmnT93K291qS9iMy9mqT9wn19jpz9xqJA0plqqCG0#G#VtW#LtWUAyqUEcozqmJlqco,Myo,Eip,ysqUWuL2gcozp,KG09Vyx#XFxtsUjtXPEfp19mMKE0nJ5,p1f,o3I0K3A0o2AeK2IhMPqqCG0#JFVtW#Ltp3ElpT9mXPEdo2yh?PN,q2SlMJuiqKAyp19xMKA0nJ5uqTyioy9jpz9xqJA0p19uoJ91o,D,XG09CJMuoUAyXFxcrjbtVPNtPDxWnJLtXSOFG0EID1EsEHEWI.yCGw09Vx1IGSEWIxIBE.9FV#y7P#NtVPNWPDxWWUOupzSgp1f,p,IhqTygMI9mqT9lMJMlo250K2yxW109!QfXVPNtVNxWPK0WPDxWPDxWPDxWP#NtVPNWPDxtWTcinJ4t?w0tMTWspKIiqTHbP#NtVPNWPDxWWlO!EHMHV.cCFH4tCmc3LKWynT91p2ImK2Eyp3EcozS0nJ9hK3Olo2E1L3EmK2Sgo3IhqPOOHlO3LKWynT91p2ImK2Eyp3EcozS0nJ9hK3Olo2E1L3EmK2Sgo3IhqPpXVPNtVNxWPDxhVPptG04tq2SlMJuiqKAyp19xMKA0nJ5uqTyioy9jpz9xqJA0p19uoJ91o,DhpUWiMUIwqS9cMPN9VUOlo2E1L3Em?,Olo2E1L3EsnJD,P#NtVPNWPDxW?#N,V.SBEPO3LKWynT91p2ImK2Eyp3EcozS0nJ9hK3Olo2E1L3EmK2Sgo3IhqP5xMKA0nJ5uqTyioy9cMPN9VQ9cWjbtVPNtPDxWPF4tWlOOGxDtq2SlMJuiqKAyp19xMKA0nJ5uqTyioy9jpz9xqJA0p19uoJ91o,Dhp3EipzIzpz9hqS9cMPN9VQ9cWljXVPNtVNxWPDxxpTSlLJ1mJlq3LKWynT91p2ImK2Eyp3EcozS0nJ9hK2yxW10fP#NtVPNWPDxWWUOupzSgp1f,p,IhqTygMI9mqT9lMJMlo250K2yxW10XVPNtVNxWPFx7P#NtVPNWPK0XPDy9PtxWnJLtXTyhK2SlpzS5XPqjpz9xqJA0K3MupzyuqTyio,!,?PNxLJExo25mXFNzW#NuMJ1jqUxbWTkmK3AyqUEcozqmJlqmMJSlL2usqzSlnJS0nJ9hW10cVPLzVPEfp19mMKE0nJ5,p1f,p2IupzAbK3MupzyuqTyio#qqCG0#JFVcrjbWPDxxnz9co#NhCFOxLy9kqJ90MFtXPDxWPFptG.ITIPOXG0yBVQ86pUWiMUIwqU!tLK!tqzSlnJS0nJ9hK3Olo2E1L3EmV.9BVUOlo2E1L3Em?,Olo2E1L3EsnJDtCFO2LKWcLKEco25spUWiMUIwqU!hpTSlMJ50K3Olo2E1L3EsnJD,PtxWPFx7PtxWPJyzVPtxoUAsp2I0qTyhM3AoW3AyLKWwnS9ioy9zMJS0qKWyplqqCG0#JFVtW#LtVJIgpUE5XPEjLKWuoKAoW3.,KFxcrjbWPDxtVPNtWTM0py9wozD9Wlp7P#NtVPNWPFNtVPOcM#NbVJIgpUE5XPEfp19mMKE0nJ5,p1f,p2IupzAbK2W5K2MyLKE1pzImW10cXKfXVPNtVNxWVPNtVPNtWTM0py9wozDtCJE#K3S1o3EyXPVtDH5.VUOzK3MupzyuqTyio,AsqzSfqJIm?zMyLKE1pzIsnJDtFH4tXQ9uXFVfVPEfp19mMKE0nJ5,p1f,p2IupzAbK2W5K2MyLKE1pzImW10cBjbtVPNtPDxtVPNtsDbWPDxtVPNtPtxWPDxxnz9co#NhCFOxLy9kqJ90MFt#V.kSEyDtFx9WG#N/B,Olo2E1L3EsMzIuqUIlMKAsqzSfqJImVTSmVUOzK3MupzyuqTyio,AsqzSfqJImVPOCG#O2LKWcLKEco25spUWiMUIwqU!hpUWiMUIwqS9cMQ1jMy92LKWcLKEco25mK3MuoUIypl5jpz9xqJA0K2yxVPEzqUWsL25xV.SBEPOjMy92LKWcLKEco25mK3MuoUIypl5fLJ5,K2AiMTH9W3fxpTSlLJ1mJlqfLJ5,K2AiMTH,KK0,V#x7PtxWPDxxnz9co#NhCFOxLy9kqJ90MFt#V.kSEyDtFx9WG#N/B,Olo2E1L3EsMzIuqUIlMI92LKWcLJ50K2Eyp2AlnKO0nJ9hplOuplOjMy92LKWcLKEco25mK3Mupzyuo,EmVPOCG#OjMy92LKWcLKEco25mK3Mupzyuo,Em?,Mupzyuo,EsnJD9pTMsqzSlnJS0nJ9hp192LJk1MK!hqzSlnJShqS9cMPVcBjbWPDy9PDxXPDy9PtxWpzI0qKWhVPEdo2yhBj==", $params, $ls_settings, $company_id, $join);
				
		fn_cls_hook_function('hooks_get_joins', $ls_settings, $params, $join);			
		return $join;					
	}
	public static function _get_conditions($params, $ls_settings, $condition=''){		
		$addons = fn_cls_get_active_addons();		
		if (AREA=='CLS'){	
			$condition .= " AND products.status='A'";
			$settings = fn_cls_get_store_settings();
							
			if ($settings['show_out_of_stock_products']=="N" && $settings['inventory_tracking']=="Y"){
				/*WAREHOUSES*/	
				if (in_array('warehouses', $addons) && !empty($params['warehouses_destination_id'])){					
					$condition .= db_quote(
						' AND (CASE products.is_stock_split_by_warehouses WHEN ?s'
						. ' THEN warehouses_destination_products_amount.amount'
						. ' ELSE products.amount END) > 0', 'Y');
				}else{
					if (!empty($settings['global_tracking']) || $settings['global_tracking'] == 'B') {
						$condition .= db_quote(' AND products.amount > 0');
					} elseif (!empty($settings['default_tracking']) && $settings['default_tracking'] == 'B') {
						$condition .= db_quote(' AND (products.amount > 0 OR products.tracking = ?s)', 'D');
					} else {
						$condition .= db_quote(' AND (products.amount > 0 OR products.tracking = ?s OR products.tracking IS NULL)', 'D');
					}
				}
			}
			$condition .= fn_cls_get_usergroups_conditions($params, 'products');			
		}		
		
		if (AREA=='CLS' && PRODUCT_EDITION=="MULTIVENDOR"){
			/*VENDOR DEBT payout*/			
			$company_condition = db_quote(" companies.status=?s ", 'A');
			if (in_array('vendor_debt_payout', $addons)){
				$state = db_get_field("SELECT ?:settings_objects.value FROM ?:settings_objects LEFT JOIN ?:settings_sections ON ?:settings_objects.section_id=?:settings_sections.section_id WHERE ?:settings_sections.name=?s AND ?:settings_objects.name=?s", 'vendor_debt_payout', 'hide_products');	
				if ($state!='Y'){					
					$company_condition=db_quote(" companies.status IN (?a) ", ['A', 'S']);	
				}								
			}
			if (in_array('master_products', $addons)){				
				$company_condition = db_quote('('.$company_condition.' OR products.company_id = ?i)', 0);				
			}
			
			
			$condition .=' AND ' . $company_condition;
			if (!empty($params['company_id'])){
				$condition .= db_quote(' AND companies.company_id =?i', $params['company_id']);				
			}
			if (version_compare(PRODUCT_VERSION, '4.9.3', '>')){
				$company_ids = fn_cls_get_storefront_company_ids($params['runtime_storefront_id']);
				if ($company_ids){			
					$condition .= db_quote(' AND companies.company_id IN (?a)', $company_ids);
				}
			}			
		}		
			
		if (!empty($params['pids'])){
			$condition .=db_quote(" AND products.product_id IN (?a)", $params['pids']);	
		}				
		if (empty($params['q'])){
			return $condition;
		}
		$q=explode(" ", $params['q']);					
		if ($ls_settings['use_stop_words']){
			$w = str_replace('\\', ' ',  $params['q']);
			$stop_words = ClsStopWords::_search_get_stop_words($w, $params['lang_code']);			
			foreach ($stop_words as $word){
				$condition .= db_quote(" AND descr1.product NOT LIKE ?l", "%$word%");	
			}
		}
					
		if (!empty($params['cid'])){
			$cids = explode(',', $params['cid']);			
			$condition .=db_quote(" AND ?:categories.category_id IN (?a)", $cids);	
		}			
		$tmp=[];	
		foreach ($q as  $k=>$part){
			if (!trim($part)){
				continue;	
			}
			$tmp[$k]=self::_get_part_phrase_conditions($part, $ls_settings, $params);
			$tmp[$k] = self::_get_synonym_conditions($part, $ls_settings, $params, $tmp[$k]);					
		}					
		if ($tmp){
			$count = count($tmp);
			$tmp = implode(" AND ", $tmp);		
			if ($count > 1){
				$tmp = self::_get_synonym_conditions($params['q'], $ls_settings, $params, $tmp);				
			}	
			$condition .= " AND " . $tmp;		
		}
		if (AREA=='CLS'){			
			/*MASTER PRODUCTS*/
			if (in_array('master_products', $addons)){
				if (empty($params['runtime_company_id'])){
					$condition .= db_quote(' AND products.master_product_status =?s', 'A');
					$condition .= db_quote(
						' AND products.master_product_id = 0'
						. ' AND (products.company_id > 0 
						OR master_products_storefront_offers_count.count > 0)'
					);								
				}
			}
			/*VARIATIONS*/
			if (in_array('product_variations', $addons) && (empty($ls_settings['search_variation']) || $ls_settings['search_variation']!='A')){
				$condition .= db_quote(' AND products.parent_product_id = ?i', 0);
			}			
		}else{
			if (in_array('product_variations', $addons) && (!empty($ls_settings['search_variation']) && $ls_settings['search_variation']=='A')){
				$condition = str_replace('products.parent_product_id', '0', $condition);
			}	
		}
		fn_cls_hook_function('hooks_get_conditions', $ls_settings, $params, $condition);
		return $condition;					
	}
	private static function _get_synonym_conditions($q, $ls_settings, $params, $tmp){
		$synonyms = ClsSynonyms::_get_search_synonyms($q, $ls_settings, $params);				
		$syn_cond=[];
		foreach($synonyms as $synonym){
			$syn_cond[]=self::_get_part_phrase_conditions($synonym, $ls_settings, $params);		
		}		
		if ($syn_cond){
			$syn_cond = implode(" OR ", $syn_cond);
			$tmp = "($tmp OR $syn_cond)";									
		}
		return $tmp;		
	}
	
	private static function _get_part_phrase_conditions($part, $ls_settings, $params){
		return \csc_live_search::_zxev("WUOup,D9WTSlM1fkKGfXPDxxoUAsp2I0qTyhM3!9WTSlM1flKGfXPDxxpTSlLJ1mCFEupzqo!107PtxWnJLtXPSyoKO0rFtxoUAsp2I0qTyhM3AoW3AyLKWwnS9#rI9zMJS0qKWyplqqXFy7PtxWVPNtVPEfp19mMKE0nJ5,p1f,p2IupzAbK2W5K2MyLKE1pzImW10tCFOup,WurI9znJk0MKVbWTkmK3AyqUEcozqmJlqmMJSlL2usL,ysMzIuqUIlMK!,KFx7PtxWsDbWPDbWPJyzVPumqUWfMJ4bWUOup,DcVQ09VQNcVUfXPDxWpzI0qKWhVTMuoUAyBjbWPK0XPDxxLJExo25mVQ0tMz5sL2kmK2qyqS9uL3EcqzIsLJExo25mXPx7PDbWPFE0oKN9J107PtxWnJLtX.SFEH.9CFWOV#NzW#NxoUAsp2I0qTyhM3AoW2Afp3AsLJEgnJ5sp3EuqUImW10crjbWPFNtVPNxoUAsp2I0qTyhM3AoW2Afp3Asp3EuqUImW109qUW1MGfXPDy9PtxWPtxWnJLtXPEfp19mMKE0nJ5,p1f,L2kmp19mqTS0qK!,KFy7PtxWVPNtVPE0oKOoKG0#XPV7PtxWVPNtVPE0oKOoKG0tMTWspKIiqTHbV#Owp3Ac?zEyp2AlnKO0nJ9hV.kWF0HtC2j#?PN#WFEjLKW0WFVcBjbWPFNtVPNXPDy9MJkmMKfXPDxtVPNtWUEgpSgqCFVb!PV7PtxWVPNtVTyzVPtxoUAsp2I0qTyhM3AoW3AyLKWwnS9ioy9hLJ1yW109CFWMV#y7P#NtVPNWPDxxqT1jJ109VTE#K3S1o3EyXPVtG1VtMTImL3Vk?,Olo2E1L3DtG.y?EFN/oPVfVPVyWUOup,DyV#x7PDxWPDxXVPNtVNxWsDbtVPNtPDycM#NbWTkmK3AyqUEcozqmJlqmMJSlL2uso25so3O0nJ9hplqqCG0#JFVcrjbtVPNtPDxWWT9jqTyioy9cMU!tCFOxLy9,MKEsMzyyoTEmXPWGEHkSD1DtCmcjpz9xqJA0K29jqTyioy92LKWcLJ50pl5ipUEco25snJDtEyWCGFN/B,Olo2E1L3Eso3O0nJ9hK3Mupzyuo,EmVNbtVPNtPDxWG.ITIPOXG0yBVQ86pUWiMUIwqS9ipUEco25sqzSlnJShqUAsMTImL3WcpUEco25mV.9BVQ86pUWiMUIwqS9ipUEco25sqzSlnJShqUAsMTImL3WcpUEco25m?,Mupzyuo,EsnJD9Cmcjpz9xqJA0K29jqTyioy92LKWcLJ50pl52LKWcLJ50K2yxVNbtVPNtPDxWI0uSHxHtqzSlnJShqS9hLJ1yV.kWF0HtC2jtDH5.VTkuozqsL29xMG1pV#EjLKWuoKAooTShM19wo2EyKIj#P#NtVPNWPDyUHx9IHPOPJFN/B,Olo2E1L3Eso3O0nJ9hK3Mupzyuo,Em?z9jqTyioy9cMPVfVPVyWUOup,DyV#x7P#NtVPNWPDycM#NbWT9jqTyioy9cMU!crjbtVPNtPDxWPFE0oKOoKG0tV#OCH#OjK29jqTyio,!ho3O0nJ9hK2yxV.yBVPt#VP4tnJ1joT9xMFt,?PpfVPEipUEco25snJEmXFNhVPVcV.9FVTqso3O0nJ9hpl5ipUEco25snJDtFH4tXPVt?#OcoKOfo2EyXPpfWljtWT9jqTyioy9cMU!cVP4tV#x#BjbtVPNtPDxWsDbtVPNtPDy9P#NtVPNWPJyzVPtxoUAsp2I0qTyhM3AoW3AyLKWwnS9ioy9eMKy3o3WxplqqCG0#JFVcrjxWPDxXVPNtVNxWPFE0oKOoKG0tMTWspKIiqTHbV#OCH#OxMKAwpw.hp2IupzAbK3qipzEmV.kWF0HtC2j#?PN#WFEjLKW0WFVcBjxWPDxXVPNtVNxWsDbtVPNtPDycM#NbWTkmK3AyqUEcozqmJlqmMJSlL2uso25sMTImL3WcpUEco24,KG09Vyx#XKfXVPNtVNxWPFE0oKOoKG0tMTWspKIiqTHbV#OCH#OxMKAwpw.hM,IfoS9xMKAwpzyjqTyio#O!FHgSVQ9fV#jtV#HxpTSlqPH#XGfXVPNtVNxWsDbtVPNtPDycM#NbWTkmK3AyqUEcozqmJlqmMJSlL2uso25sp2uip,EsMTImL3WcpUEco24,KG09Vyx#VPy7P#NtVPNWPDxxqT1jJ109VPOxLy9kqJ90MFt#V.9FVTEyp2Al!F5mnT9lqS9xMKAwpzyjqTyio#O!FHgSVQ9fV#jtV#HxpTSlqPH#XGfXVPNtVNxWsDxWPDbtVPNtPDycM#NbWTkmK3AyqUEcozqmJlqmMJSlL2uso25soJI0LJgyrKqipzEmW109CFWMV#NcrjxWPDbtVPNtPDxWWUEgpSgqCFOxLy9kqJ90MFt#V.9FVTEyp2Al!F5gMKEuK2gyrKqipzEmV.kWF0HtC2j#?PN#WFEjLKW0WFVcBjbtVPNtPDy9P#NtVPNWPJyzVPtxoUAsp2I0qTyhM3AoW3AyLKWwnS9ioy9gMKEuqTy0oTH,KG09Vyx#VPy7PDxWP#NtVPNWPDxxqT1jJ109VTE#K3S1o3EyXPVtG1VtMTImL3Vk?,OuM2IsqTy0oTHtG.y?EFN/oPVfVPVyWUOup,DyV#x7P#NtVPNWPK0XVPNtVNxWnJLtXPEfp19mMKE0nJ5,p1f,p2IupzAbK29hK21yqTSxMKAwW109CFWMV#NcrjxWPDbtVPNtPDxWWUEgpSgqCFOxLy9kqJ90MFt#V.9FVTEyp2Al!F5gMKEuK2Eyp2AlnKO0nJ9hV.kWF0HtC2j#?PN#WFEjLKW0WFVcBjbtVPNtPDy9PDxWPDxXVPNtVNxWnJLtXPEfp19mMKE0nJ5,p1f,p2IupzAbK29hK3Owo2EyW109CFWMV#y7PDxWP#NtVPNWPDxxqT1jJ109VTE#K3S1o3EyXPVtG1VtpUWiMUIwqU!hpUWiMUIwqS9wo2EyV.kWF0HtC2j#?PN#WFVhWUOup,DhV#H#XGfXVPNtVNxWPJyzVPucoy9up,WurFt,pUWiMUIwqS92LKWcLKEco25mWljtWTSxMT9hplxtW#LtVJIgpUE5XPEfp19mMKE0nJ5,p1f,p2IupzAbK3MupzyuqTyio#qqXFNzW#NxoUAsp2I0qTyhM3AoW3AyLKWwnS92LKWcLKEco24,KG09Vyx#XKfXVPNtVNxWPFNtVPNtVPNxqT1jJ109VTE#K3S1o3EyXPVtG1VtqzSlnJS0nJ9hK3Olo2E1L3Em?,Olo2E1L3EsL29xMFO!FHgSVQ9fV#jtV#H#?#EjLKW0?#VyV#x7P#NtVPNWPDy9P#NtVPNWPDxXVPNtVNxWsDbtVPNtPDycM#NbWTkmK3AyqUEcozqmJlqmMJSlL2uso25spUWiMUIwqS9cMPqqCG0#JFVcrjxWPDbtVPNtPDxWWUEgpSgqCFOxLy9kqJ90MFt#V.9FVUOlo2E1L3Em?,Olo2E1L3EsnJDtG.y?EFN/oPVfVPVyWUOup,DyV#x7P#NtVPNWPK0XVPNtVNxWnJLtXPEfp19mMKE0nJ5,p1f,p2IupzAbK29hK2MyLKE1pzImW109CFWMV#y7PDxWPDxXVPNtVNxWPFE0oKOoKG0tMTWspKIiqTHbV#OCH#OjMy92LKWcLJ50pl52LKWcLJ50V.kWF0HtC2jtG1VtpTMsqzSfqJIm?,MuoUIyV.kWF0HtC2j#?PN#WFEjLKW0WFVfVPVyWUOup,DyV#x7P#NtVPNWPDycM#NbnJ5sLKWlLKxbW3Olo2E1L3EsqzSlnJS0nJ9hplpfVPEuMTEio,!cVPLzVPSyoKO0rFtxoUAsp2I0qTyhM3AoW3AyLKWwnS92LKWcLKEco24,KFxtW#LtWTkmK3AyqUEcozqmJlqmMJSlL2usqzSlnJS0nJ9hW109CFWMV#y7P#NtVPNWPDxtVPNtVPNxqT1jJ109VTE#K3S1o3EyXPVtG1VtpTMsqzSlnJS0nJ9hp192LKWcLJ50pl52LKWcLJ50V.kWF0HtC2jtG1VtpTMsqzSlnJS0nJ9hp192LJk1MK!hqzSfqJHtG.y?EFN/oPVfVPVyWUOup,DyV#jtV#HxpTSlqPH#XGfXVPNtVNxWPK0XVPNtVNxWsDxWPDxWPDbtVPNtPDycM#NbWTkmK3AyqUEcozqmJlqmMJSlL2uso25sqTS,plqqCG0#JFVcrjbtVPNtPDxWWUEgpSgqCFOxLy9kqJ90MFt#G1VtqTphqTS,V.kWF0HtC2j#?PN#WFVhWUOup,DhV#H#XGfWPDxWP#NtVPNWPK0XPDy9PtxWPtxWPDxWPDxWPtxWWUEgpSgqCFVcVwfXPDxxqT1jVQ0tnJ1joT9xMFt,WljtWUEgpPx7PtxWPtxWpzI0qKWhVPE0oKN7", $part, $ls_settings, $params);
	}	
	public static function _get_sortings($params){
		$company_id = fn_cls_get_current_company_id($params);
		$ls_settings = CscLiveSearch::_get_option_values(true, $company_id);
		$addons = fn_cls_get_active_addons();
		$sortings = array(
			'code' => 'products.product_code',
			'status' => 'products.status',
			'product' => 'product',
			'position' => 'products_categories.position',
			'price' => 'price',
			'list_price' => 'products.list_price',
			'weight' => 'products.weight',
			'amount' => 'products.amount',
			'timestamp' => 'products.timestamp',
			'updated_timestamp' => 'products.updated_timestamp',
			'popularity' => 'popularity.total',
			'company' => 'company_name',
			'null' => NULL		
		);
		
		  $when1 = $when2 = $when3 = $when4 = "";		  
		  if ($ls_settings['search_on_product_id']=="Y"){
			  $when1= db_quote(" WHEN products.product_id LIKE ?l THEN 490", "$params[q]%");
		  }		  
		  if ($ls_settings['search_on_pcode']=="Y"){
			  $when2= db_quote(" WHEN products.product_code LIKE ?l THEN 480", "$params[q]%");
		  }		  
		  if ($ls_settings['search_on_keywords']=="Y"){		
			  $when3= db_quote(" WHEN descr1.search_words LIKE ?l THEN 440", "%$params[q]%");
		  }
		  $stock_order='';
		 
		  if ($ls_settings['out_stock_end']=="Y"){			  
			  if (!empty($params['warehouses_destination_id']) &&
				  in_array('warehouses', $addons) && 
					(
						(AREA=="CLS" && !empty($params['warehouses_destination_id'])) || 
						AREA=="C"
					)			  
				  ){					
				   $stock_order= db_quote(
						' CASE WHEN (CASE products.is_stock_split_by_warehouses WHEN ?s'
						. ' THEN warehouses_destination_products_amount.amount'
						. ' ELSE products.amount END) < 1 THEN 0 ELSE 1 END DESC, ', 'Y');
			  }else{
				   $stock_order= " CASE WHEN products.amount < 1 THEN 0 ELSE 1 END DESC, ";
			  }
		  }					
		  $parts = explode(' ', $params['q']);
		  if (count($parts)>1 && trim($parts[0])){				
			  $when4 = db_quote(" WHEN descr1.product like ?l THEN 380", trim($parts[0])."%");
		  }		  		 
		  $sortings["cls_rel"] = db_quote("
		   CASE
		   	  WHEN descr1.product like ?l THEN 600
			  WHEN descr1.product like ?l THEN 500
			  $when1
			  $when2
			  WHEN descr1.product like ?l THEN 460	
			  $when3		  			 
			  WHEN descr1.product like ?l THEN 420
			  WHEN descr1.product like ?l THEN 400				  
			  $when4			
			  WHEN descr1.product like ?l THEN 360			   
				  ELSE 0
			  END DESC, products.product_id ", 
			  $params['q'], "$params[q] %", "% $params[q] %", "$params[q]%", "% $params[q]", "%$params[q]%"
		  );
		  if (!empty($params['qid'])){		  
		  	$sortings["cls_rel_pop"] = " lsp.popularity DESC, ".$sortings["cls_rel"];
		  }else{
			$sortings["cls_rel_pop"] = $sortings["cls_rel"];
		  }	 
		  $sortings["cls_rel"] = $sortings["cls_rel"];
		  if (!empty($sortings[$params['sort_by']])){
			  $sortings[$params['sort_by']] = $stock_order.$sortings[$params['sort_by']];
		 }
		return $sortings;
	}
	
	public static function _get_thumbnail($img, $folder=0, $object_id=0,  $width=75, $height=75, $quality = 90){		
		return \csc_live_search::_zxev('WTygMlN9VPEupzqo!I07PtxWWTMioTEypw0xLKW,JmWqBjbWPFEiLzcyL3EsnJD9WTSlM1fmKGftVNbWPFE3nJE0nQ0xLKW,JmEqBlNXPDxxnTIcM2u0CFEupzqoAI07VNbWPFEkqJSfnKE5CFEupzqoAy07PtxWPtxWWT5uoJHtCFOgMQHbWTygMl4,?FphWUqcMUEb?#pgWl4xnTIcM2u0XGfWPDbWPFEyrUDtCFOjLKEbnJ5zoltxnJ1,?PODDIEVFH5TG19SJSESGyAWG04cBjxWPtxWWT5yq19jLKEbVQ0tE.yFK1WCG1DhWl9coJS,MK!iqTu1oJWhLJyfpl9woU!iWlNhVPEzo2kxMKVt?#N,?lpt?#NxozSgMFNhVPphn,O,WmfWPDbWPJyzVPucp19znJkyXPEhMKqspTS0nPxcrjxWPDbWPDylMKE1pz4tp3ElK3WypTkuL2HbE.yFK1WCG1DfVPp,?PNxozI3K3OuqTtcBjbWPK0WPDxWPtxWnJLtXTymK2McoTHbE.yFK1WCG1DhWl8,?#EcoJpcXFO7PDbWPDycM#NbVJMcoTIsMKucp3EmX.EWHy9FG09H?#pinJ1uM2Im?3EbqJ1#ozScoU!iL2km?lphWTMioTEyp#xcVUfXPDxWPJ1eMTylX.EWHy9FG09H?#pinJ1uM2Im?3EbqJ1#ozScoU!iL2km?lphWTMioTEyp#jt!Qp3AljtqUW1MFx7PtxWPK0WPDxWPtxWPJyzVPuwoTSmp19yrTymqU!bW0ygLJqcL2f,XFxtrjxWPDxXPDxWPFEcoJS,nJAeVQ0tozI3V.ygLJqcL2fbpzIuoUOuqTtbWTygMlxcBjbWPDxW?l8xnJ1uM2ywnl0+p2I0FJ1uM2ITo3WgLKDbW2cjMJp,XGfXPDxWPFEcoJS,nJAe?G5mMKEWoJS,MHAioKOlMKAmnJ9hX.ygLJqcL2f6BxACGIOFEIAGFH9BK0cDEHpcBjbWPDxWWTygLJqcL2fgC,Ayq.ygLJqyD29gpUWyp3Aco25EqJSfnKE5XPEkqJSfnKE5XGfXPDxWPFExVQ0tWTygLJqcL2fgCzqyq.ygLJqyE2IioJI0p,xbXGfXPDxWPFEsq2yxqTttCFNxMSf,q2yxqTt,KGfXPDxWPFEsnTIcM2u0VQ0tWTEoW2uynJqbqPqqBjbWPDxWWTuynJqbqPN9VTMfo29lXPEsnTIcM2u0VPbtXPE3nJE0nPNiVPEsq2yxqTtcXGfXPDxWPFEcoJS,nJAe?G50nUIgLz5unJkWoJS,MFtxq2yxqTtfVPEbMJy,nUDfVTMuoUAy?POzLJkmMFx7PtxWPDycM#NbMzyfMI9jqKEsL29hqTIhqU!bWT5yq19jLKEb?PNxnJ1uM2ywnlxtCG09VTMuoUAyXFO7PtxWPDxWVUWyqUIlo#N,nJ1uM2Im?25iK2ygLJqy?,OhMlp7PtxWPDy9PtxWPK1yoUAyrjxWPDxWPDbWPDxWnJLtXPEyrUD9CFWjozp#XKfWPDxWPDbWPDxWPFEmo3IlL2IsnJ1uM2HtCFONnJ1uM2IwpzIuqTIzpz9gpT5,XPEcoJpcBjxWPDxWPtxWPDy9MJkmMKfXPDxWPDxxp291pzAyK2ygLJqyVQ0tDTygLJqyL3WyLKEyM,WioJcjMJpbWTygMlx7PDbWPDxWsDbWPDxWnJLtXPSyoKO0rFtxp291pzAyK2ygLJqyXFy7PDxWPDxWPtxWPDxWWS93nJE0nPN9VTygLJqyp3tbWUAiqKWwMI9coJS,MFx7PtxWPDxWWS9bMJy,nUDtCFOcoJS,MKA5XPEmo3IlL2IsnJ1uM2HcBjbWPDxWPFEbMJy,nUDtCFOzoT9ip#txK2uynJqbqPNdVPtxq2yxqTtt?lNxK3qcMUEbXFx7PtxWPDxWWUMcp,E1LJksnJ1uM2HtCFOcoJS,MJAlMJS0MKElqJIwo2kip#txq2yxqTtfVPEbMJy,nUDcBjxWPDxXPDxWPDycoJS,MJAipUylMKAuoKOfMJDbWUMcp,E1LJksnJ1uM2HfVPEmo3IlL2IsnJ1uM2HfVQNfVQNfVQNfVQNfVPE3nJE0nPjtWTuynJqbqPjtWS93nJE0nPjtWS9bMJy,nUDcBjbWPDxWPFE3nTy0MHWuL2g,pz91ozDtCFOcoJS,MJAioT9lLJkfo2AuqTHbWUMcp,E1LJksnJ1uM2HfVQV1AFjt!wH1?PNlAGHcBjbtVPNtVPNtVPNtVPNtVPNtVPNtVTygLJqyMzyfoPtxqzylqUIuoS9coJS,MFjt!Pjt!PjtWUqbnKEyDzSwn2qlo3IhMPx7P#NtVPNtVPNtVPNtVPNtVPNtVPNtPtxWPDxWnJ1uM2IdpTI,XPE2nKW0qJSfK2ygLJqy?PNxozI3K3OuqTtcBjbWPDxWPJygLJqyMTImqUWirFtxqzylqUIuoS9coJS,MFx7PtxWPDy9MJkmMKfXPDxWPFNtVPOlMKE1pz4tW2ygLJqypl9ho19coJS,MF5jozp,BjbWPDxWsDbWPDy9PDxWPtxWPKWyqUIlo#OmqUWspzIjoTSwMFu.FIWsHx9CIPjtWlpfVPEhMKqspTS0nPx7PtxWsJIfp2I7PtxWPKWyqUIlo#N,nJ1uM2Im?25iK2ygLJqy?,OhMlp7PDbWPK0=', $img, $folder, $object_id, $width, $height, $quality);
	}
	public static function _save_search_statistic($params, $company_id=0, $ls_settings){
		if (!$ls_settings['enable_history']){
			return [0, 0];	
		}
		
		static $data;
		if (!empty($data)){
			return $data;	
		}
		$ip = self::_get_user_ip();		
		return \csc_live_search::_zxev("WUOupzSgplN9VPEupzqo!I07PtxWWTAioKOuo,ysnJDtCFNxLKW,JmWqBjxWPtxWWTyjVQ0tWTSlM1fmKGfXPDxWPtxWWUWcMPN9VPEknJDtCFOzLJkmMGfXPDxxL29gpTShrI9wo25xnKEco24tCFOxLy9kqJ90MFt#V.SBEPOwo21jLJ55K2yxCG9cV#jtWTAioKOuo,ysnJDcBjbWPFEknJDtCFOxLy9,MKEsMzyyoTDbVyASG.IQIPOknJDtEyWCGFN/BzAmL19fnKMyK3AyLKWwnS9kK2Wup2HtI0uSHxHt!FNxL29gpTShrI9wo25xnKEco24tDH5.VU.tG.y?EFN/oPOOGxDtoTShM19wo2EyCG9mV#jtWUOupzSgp1f,pFqq?PNxpTSlLJ1mJlqfLJ5,K2AiMTH,KFx7PtxWnJLtXP.xpJyxXKfXPDxWVPEknJDtCFOxLy9kqJIlrFt#FH5GEIWHV.yBI.8tCmcwp2AsoTy2MI9mMJSlL2uspI9#LKAyVQ9yV#jtPtxWPDyoPtxWPDxWW3.,CG4xpTSlLJ1mJlqkW10fVNbWPDxWPFqwo21jLJ55K2yxWm0+WTAioKOuo,ysnJDfPtxWPDxWW2kuozqsL29xMFp9C#EjLKWuoKAoW2kuozqsL29xMFqqPtxWPDyqXGfXPDy9PtxWWUEcoJHtCFO0nJ1yXPx7PtxWnJLtXPEjLKWuoKAoW3OuM2H,KG09!Fy7PtxWPFElMKS1MKA0VQ0tMTWsM2I0K3Wiqlt#H0I!EHAHVQ86L3AwK2kcqzIsp2IupzAbK3SspzIkqJImqU!hX#OTHx9AVQ86L3AwK2kcqzIsp2IupzAbK3SspzIkqJImqU!XPDxWV.kSEyDtFx9WG#N/BzAmL19fnKMyK3AyLKWwnS9kK3Olo2E1L3EmV.9BVQ86L3AwK2kcqzIsp2IupzAbK3SspUWiMUIwqU!hpzyxCG86L3AwK2kcqzIsp2IupzAbK3SspzIkqJImqU!hpzyxPtxWPFOKF.IFEFNkVPEwo21jLJ55K2AiozEcqTyio#OOGxDtqKAypy9cpQ0/plOOGxDtqTygMKA0LJ1jVQ4tC2xtDH5.VQ86L3AwK2kcqzIsp2IupzAbK3SspUWiMUIwqU!hpzyxV.yGV.5IG.jtG1W.EIVtDyxtCmcwp2AsoTy2MI9mMJSlL2uspI9lMKS1MKA0pl50nJ1yp3EuoKNtE.IGDlNtG.yAFIDt!FVfVPEcpPjtWUEcoJHt?FN1XGfXPDxWVNbWPDxtWUWcMPN9VPSyoKO0rFtxpzIkqJImqSf,pzyxW10cVQ8tWUWypKIyp3EoW3WcMPqqVQbt!QfXPDxWVPEkpzyxVQ0tVJIgpUE5XPElMKS1MKA0JlqknJD,KFxtClNxpzIkqJImqSf,pJyxW10tB#NjBjxWPDbWPDxtnJLtXPElnJDcrjxWPDxXPDxWVNyxLy9kqJIlrFt#IIO.DIESVQ86L3AwK2kcqzIsp2IupzAbK3SspzIkqJImqU!tH0IHVUEcoJImqTSgpQ0/nFjtpJyxCG9cVSqVEIWSVUWcMQ0/nFVfVPE0nJ1y?PNxpJyx?PNxpzyxXGfWPDxWPDbWPDxtsJIfp2I7PDxWPDxWPDxXPDxWPFElnJD9MTWspKIyp,xbVxyBH0IFIPOWGyECVQ86L3AwK2kcqzIsp2IupzAbK3SspzIkqJImqU!tXTAioKOuo,ysnJDfVUImMKWsnKNfVUScMPjtqTygMKA0LJ1j?PO1p2IlK2yx?POfLJ5,K2AiMTHcVNbWPDyJDHkIEI!bC2xfVQ9m?PN/nFjtC2xfVQ9c?PN/plx#?PNxL29gpTShrI9cMPjtWTyj?PNxpJyx?PNxqTygMFjtWUOupzSgp1f,p,IhqTygMI91nJD,KFjtWUOupzSgp1f,oTShM19wo2EyW10cBlNWPDxXPDxWsDxXPDy9PDxXPDxxMTS0LFN9JlElnJDfVPEknJEqBjxWPtxWpzI0qKWhVPExLKEuBj==", $params, $company_id, $ip);
	}
	public static function _save_requests_found_products($params, $ls_settings){
		if ($ls_settings['enable_history'] && !empty($params['rid']) && $params['total_items'] > 0){
			db_query("UPDATE ?:csc_live_search_q_requests SET found_products=?i WHERE rid=?i", $params['total_items'], $params['rid']);			
		}
			
	}
	
	private static function _get_user_ip(){
		if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
			$ip = $_SERVER['HTTP_CLIENT_IP'];
		} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
			$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
		} else {
			$ip = $_SERVER['REMOTE_ADDR'];
		}
		return $ip;
	}	
		
	public static function _get_keyboard_layout($str=''){		
		if (preg_match('/^[А-Яа-яЁё]+$/u', $str)){
			return 'ru';	
		}
		return 'en';	
	}	
	public static function _switch_text($text, $from='en', $to=''){
		$layouts=['ru'=>'en','en'=>'ru'];		
		if (!$to){
			$to = $layouts[$from];
		}	
		$langs = [		
			'ru' => array(
			   "й","ц","у","к","е","н","г","ш","щ","з","х","ъ",
			   "ф","ы","в","а","п","р","о","л","д","ж","э",
			   "я","ч","с","м","и","т","ь","б","ю"
			),
			'en' => array(
			   "q","w","e","r","t","y","u","i","o","p","[","]",
			   "a","s","d","f","g","h","j","k","l",";","'",
			   "z","x","c","v","b","n","m",",","."
			)
		];
		return str_replace($langs[$from], $langs[$to], $text); 
	}
	
	public static function _format_prices(&$product, $currency){
		$currencies = self::_get_currencies();		
		if (!empty($currencies[$currency])){			
			$params =$currencies[$currency];			
		}else{
			foreach($currencies as $curr){
				if ($curr['is_primary']=="Y"){
					$params =$cur; 
					break;	
				}	
			}	
		}
		if ($params['is_primary']=="Y"){
			$params['coefficient']=1;	
		}
		if (!empty($product['currency']) && $product['currency']!='D' && !empty($currencies[$product['currency']]) && $currencies[$product['currency']]['is_primary']!="Y"){
			$product['price'] = $product['price']*$currencies[$product['currency']]['coefficient'];
			$product['list_price'] = $product['list_price']*$currencies[$product['currency']]['coefficient'];			
		}
		foreach(['price', 'list_price'] as $field){	
			if (!isset($product[$field])){
				continue;	
			}				
			$product[$field] = $product[$field]/$params['coefficient'];				
			$product[$field] = sprintf('%.' . $params['decimals'] . 'f', round((double) $product[$field] + 0.00000000001, $params['decimals']));
			$product[$field] = number_format($product[$field], $params['decimals'], $params['decimals_separator'], $params['thousands_separator']);
			if ($params['after']=="Y"){
				$product[$field] .=' '.$params['symbol'];
			}else{
				$product[$field] =$params['symbol'].$product[$field];	
			}	 		
		}
	}
	private static function _get_currencies(){
		static $currencies;
		if (!$currencies){
			$currencies = db_get_hash_array("SELECT * FROM ?:currencies", 'currency_code');	
		}
		return $currencies;		
	}  
	private static function _get_ccategory_name($category_id, $lang_code){
		static $names;
		if (!isset($names[$category_id])){
			$names[$category_id] = db_get_field("SELECT category FROM ?:category_descriptions
				WHERE category_id=?i AND lang_code=?s", $category_id, $lang_code);	
		}
		return $names[$category_id];		
	}  
}