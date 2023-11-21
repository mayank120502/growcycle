<?php
/*****************************************************************************
*                                                        © 2013 Cart-Power   *
*           __   ______           __        ____                             *
*          / /  / ____/___ ______/ /_      / __ \____ _      _____  _____    *
*      __ / /  / /   / __ `/ ___/ __/_____/ /_/ / __ \ | /| / / _ \/ ___/    *
*     / // /  / /___/ /_/ / /  / /_/_____/ ____/ /_/ / |/ |/ /  __/ /        *
*    /_//_/   \____/\__,_/_/   \__/     /_/    \____/|__/|__/\___/_/         *
*                                                                            *
*                                                                            *
* -------------------------------------------------------------------------- *
* This is commercial software, only users who have purchased a valid license *
* and  accept to the terms of the License Agreement can install and use this *
* program.                                                                   *
* -------------------------------------------------------------------------- *
* website: https://store.cart-power.com                                      *
* email:   sales@cart-power.com                                              *
******************************************************************************/

namespace Tygh\Addons\CpSmsServices;

use Tygh\Registry;
use Tygh\Http;

class Beeline extends ASmsService
{
    private $api_url = 'https://beeline.amega-inform.ru/sms_send/';
    private $api_port = '443';
    private $login = '';
    private $psw = '';
    private $sender = '';

    public function __construct($params = [])
    {
        $this->login = Registry::get('addons.cp_sms_services.service_beeline_login');
        $this->psw = Registry::get('addons.cp_sms_services.service_beeline_psw');
        $this->sender = Registry::get('addons.cp_sms_services.service_beeline_from');
    }

    public function send($phones, $message)
    {
        if (empty($this->login) || empty($this->psw)) {
            return;
        }
        $hostname = 'beeline.amega-inform.ru';
        $nn = "\r\n";
        
        $request = [
            'user'      => $this->login,
            'pass'      => $this->psw,
            'action'    => 'post_sms',
            'sender'    => $this->sender,
            'target'    => $phones,
            'message'   => $message,
            //'smstype'   => 'SENDSMS',
            'show_description'  => true
        ];
        $PostData = http_build_query($request);
        $len = strlen($PostData);
        
        $fsock_proxy = false;
        $proxy_auth = false;
        
        $send = "POST " . $this->api_url ." HTTP/1.0" . $nn . 
            "Host: " . $hostname . ":" . $this->api_port . $nn . 
            "Content-Type: application/x-www-form-urlencoded" . $nn . 
            "Content-Length: $len" . $nn . 
            "User-Agent: AISMS PHP class" . $nn . $nn . $PostData
        ;
        flush();
        $fp = @fsockopen('ssl://'. $hostname, $this->api_port, $errno, $errstr, 30);
        
        if( $fp !== false ) {
            fputs($fp, $send);
            $header = '';
            
            do { 
                $header.= fgets($fp, 4096);
            } while (strpos($header,"\r\n\r\n") === false);
            if(get_magic_quotes_runtime()) {
                $header = $this->cp_decode_header(stripslashes($header));
            } else {
                $header = $this->cp_decode_header($header);
            }
            $body='';
            while (!feof($fp)) {	
                $body .=fread($fp,8192);
                if (get_magic_quotes_runtime()) {
                    $body = $this->cp_decode_body($header, stripslashes($body));
                } else {
                    $body = $this->cp_decode_body($header, $body);
                }
            }
            fclose($fp);
            $parsed_body = $this->cp_xml_sms_parser($body);
            
            if (function_exists('fn_cp_am_log_event')) {
                fn_cp_am_log_event('cp_sms_services', 'api_request', [
                    'request'   => $request,
                    'response'  => $parsed_body
                ]);
            }
            if (empty($parsed_body['output']['errors'])) {
                return true;
            }
        }
        
        return false;
    }
    public function cp_xml_sms_parser ($body) {
        $xml   = simplexml_load_string($body);
        $array = json_decode(json_encode((array) $xml), true);
        $array = [$xml->getName() => $array];
        
        return $array;
    }
    public function cp_decode_header ($str) {
        $part = preg_split ( "/\r?\n/", $str, -1, PREG_SPLIT_NO_EMPTY);
        $out = array ();
        for ($h=0;$h<sizeof($part);$h++) {
        if ($h!=0) {
            $pos = strpos($part[$h],':');
            $k = strtolower ( str_replace (' ', '', substr ($part[$h], 0, $pos )));
            $v = trim(substr($part[$h], ($pos + 1)));
        } else {
            $k = 'status';
            $v = explode (' ',$part[$h]);
            $v = $v[1];
        }
        if ($k=='set-cookie') {
            $out['cookies'][] = $v;
        } else
            if ($k=='content-type') {
                if (($cs = strpos($v,';')) !== false) {
                    $out[$k] = substr($v, 0, $cs);
                } else {
                    $out[$k] = $v;
                }
            } else {
                $out[$k] = $v;
            }
        }
        return $out;
    }
    
    public function cp_decode_body($info,$str,$eol="\r\n" ) {
        $tmp=$str;
        $add=strlen($eol);
        if (isset($info['transfer-encoding']) && $info['transfer-encoding']=='chunked') {
            $str='';
            do {
                $tmp=ltrim($tmp);
                $pos=strpos($tmp, $eol);
                $len=hexdec(substr($tmp,0,$pos));
                if (isset($info['content-encoding'])) {
                    $str.=gzinflate(substr($tmp,($pos+$add+10),$len));
                } else {
                    $str.=substr($tmp,($pos+$add),$len);
                }
                $tmp = substr($tmp,($len+$pos+$add));
                $check = trim($tmp);
            } while(!empty($check));
        } elseif (isset($info['content-encoding'])) {
            $str=gzinflate(substr($tmp,10));
        }
        return $str;
    }
}