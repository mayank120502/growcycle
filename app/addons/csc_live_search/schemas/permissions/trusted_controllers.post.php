<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }
$schema['csc_live_search']['allow']['cron'] =  true;
$schema['csc_live_search']['allow']['clean_requests'] =  true;
return $schema;
