<?php

if (empty($schema['callable_handlers']['et_device'])) {
	$schema['callable_handlers']['et_device'] = ['et_get_device'];
}

return $schema;