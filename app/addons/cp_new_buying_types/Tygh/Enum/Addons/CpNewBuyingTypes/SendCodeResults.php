<?php

namespace Tygh\Enum\Addons\CpNewBuyingTypes;

/**
 * SendCodeResults contains possible values for sending code results
 *
 * @package Tygh\Enum
 */
class SendCodeResults
{
    const SUCCESS = 1;
    const INCORRECT_PHONE_FORMAT = 2;
    const USER_MUST_BE_LOGGED = 3;
    const SEND_FAILED = 4;
}