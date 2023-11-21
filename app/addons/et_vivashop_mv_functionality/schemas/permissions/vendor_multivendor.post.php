<?php

$schema['controllers']['vendor_store_blocks']['permissions']=true;
$schema['controllers']['tools']['modes']['update_position']['param_permissions']['table']['et_mv_vsb']=true;

$schema['controllers']['vendor_banners']['permissions']=true;
$schema['controllers']['tools']['modes']['update_status']['param_permissions']['table']['vendor_banners'] = true;
$schema['controllers']['tools']['modes']['update_status']['param_permissions']['table']['banners'] = true;

$schema['controllers']['banners']['permissions']=true;


$schema['controllers']['banners']['modes']['update']['permissions']=
array(
  'GET' => true,
  'POST' => true
);

$schema['controllers']['banners']['modes']['manage']['permissions']=false;
return $schema;