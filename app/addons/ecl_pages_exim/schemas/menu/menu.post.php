<?php
/*****************************************************************************
*                                                                            *
*                   All rights reserved! eCom Labs LLC                       *
* http://www.ecom-labs.com/about-us/ecom-labs-modules-license-agreement.html *
*                                                                            *
*****************************************************************************/

use \Tygh\Registry;

$schema['top']['administration']['items']['import_data']['subitems']['pages'] = array(
    'href' => 'exim.import?section=pages',
    'position' => 700,
);
$schema['top']['administration']['items']['export_data']['subitems']['pages'] = array(
    'href' => 'exim.export?section=pages',
    'position' => 700,
);

return $schema;