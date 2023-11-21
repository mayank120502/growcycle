<?php
 function smarty_modifier_remote_amp_prefix($url) { return str_replace(AMP_PREFIX, '/', $url); } 