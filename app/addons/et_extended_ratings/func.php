<?php
use Tygh\Registry;
use Tygh\Settings;

//add rating counts
function fn_et_extended_ratings_get_discussion_post($object_id, $object_type, $get_posts, $params, &$discussion){
  if (AREA=='C' && (is_array($discussion) && $discussion['type']!="C")){
    $count=array(
      '5'=>0,
      '4'=>0,
      '3'=>0,
      '2'=>0,
      '1'=>0,
    );
    $thread_id=$discussion['thread_id'];
    $condition = db_quote(" AND ?:discussion_rating.thread_id = ?i AND ?:discussion_posts.status = 'A'", $thread_id);

    $et_posts = db_get_array(
        "SELECT ?:discussion_rating.* FROM ?:discussion_rating LEFT JOIN ?:discussion_posts ON ?:discussion_posts.post_id = ?:discussion_rating.post_id WHERE 1 ?p ORDER BY ?:discussion_rating.rating_value DESC", $condition
    );
    
    if (!empty($et_posts)){
      foreach ($et_posts as $k => $post) {
        if (isset($post['rating_value']) && !empty($post['rating_value'])) {
          $val=$post['rating_value'];
          $count[$val]++;
        }
      }
    }
    if (!empty($discussion)){
      $discussion['et_count']=$count;
      $discussion['et_count_total']=count($et_posts);
    }
  }
}

function fn_et_extended_ratings_get_discussion_posts(&$params, $items_per_page, $fields, $join, &$condition, $order_by, &$limit){
  if (!empty($params['rating_value'])) {
    $condition .= db_quote(" AND ?:discussion_rating.rating_value = ?i ", $params['rating_value']);
  }
  if (!empty($params['items_per_page']) && (isset($params['template']) && $params['template']!="addons/discussion/blocks/testimonials.tpl")) {
    $params['total_items'] = db_get_field("SELECT COUNT(*) FROM ?:discussion_posts $join WHERE $condition");
    $limit = db_paginate($params['page'], $params['items_per_page'], $params['total_items']);
  }
}