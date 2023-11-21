<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }
function db_get_fields($query){
	$args = func_get_args();
    $query = Connection::db_process($query, array_slice($args, 1));
	
	$data = db_get_array($query);
	$_data=array();
	foreach ($data as $k=>$row){
		$_data[] = reset($row);
	}	
	return $_data;	
}
function db_get_field($query){
	$args = func_get_args();
    $query = Connection::db_process($query, array_slice($args, 1));
		
	$data = db_get_array($query);
	$data = reset($data);
	if ($data){
		return reset($data);
	}else{
		return false;	
	}
}

function db_query($query){	
	$args = func_get_args();	
    $query = Connection::db_process($query, array_slice($args, 1));
	$mysqli = db_connect();
	$result = $mysqli->query($query);
	$id = $mysqli->insert_id;
	
	return !empty($id) ? $id : false ;	
}

function db_get_array($query){
	$args = func_get_args();
    $query = Connection::db_process($query, array_slice($args, 1));
	
	$mysqli = db_connect();	
	$result = $mysqli->query($query); 		 
	if (!$result) {
	  printf("Query failed: %s\n", $mysqli->error);
	  echo '<p><b>'.$query.'</b></p>';
	  echo '<p style="white-space: pre;">';
	  debug_print_backtrace();
	  echo '</p>';
	  exit;
	}
	$rows=[];   
	while($row = $result->fetch_assoc()) {		
	  $rows[]=$row;
	}		
	return $rows;	
}
function db_get_row($query){
	$args = func_get_args();	
    $query = Connection::db_process($query, array_slice($args, 1));		
	$data = db_get_array($query);
	if (!empty($data)){		
		return reset($data);
	}else{
		return [];
	}
}

function db_get_hash_array($query){
	$args = func_get_args();
    $query = Connection::db_process($query, array_slice($args, 2));		
	$data = db_get_array($query);
	$_data=array();	
	foreach ($data as $k=>$row){		
		$_data[$row[$args[1]]] = $row;	
	}
	return $_data;	
}

function db_get_hash_single_array($query, $params){	
	@list($key, $value) = $params;
    $args = array_slice(func_get_args(), 2);   
		 	
	$query = Connection::db_process($query, $args);
	$_result = db_get_array($query);	
    $result=[];   
	foreach ($_result as $arr){
		$result[$arr[$key]] = $arr[$value];
	}	 
	return !empty($result) ? $result : array();
}

function db_quote($query){
	$args = func_get_args();
    $pattern = array_shift($args);
	$query = Connection::db_process($pattern, $args);
	return $query;
}

function db_connect(){
	static $mysqli;
	if (!$mysqli){
		$config = fn_get_config_data();	
		$mysqli = new mysqli($config['db_host'], $config['db_user'], $config['db_password'], $config['db_name']);
		if (mysqli_connect_errno()) {
		  printf("Connect failed: %s\n", mysqli_connect_error());
		  exit;
		}
		if (!$mysqli->set_charset("utf8")) {			
			printf("Set utf8 Error: %s\n", $mysqli->error);
			exit();
		}	
		$mysqli->query(
		 "SET NAMES 'utf8', sql_mode = '', SESSION group_concat_max_len = 3000"
		);		
	}
	return $mysqli;
}

function db_set_prefix(&$query){
	$config = fn_get_config_data();
	$query= str_replace('?:', $config['table_prefix'], $query);	
}

class Connection
{
	protected $table_fields_cache = array();	
	public static function db_process($pattern, $data = array()){		
	  $config = fn_get_config_data();
	  db_set_prefix($pattern);
	  $mysqli = db_connect();
	
	  if (!empty($data) && preg_match_all("/\?(i|s|l|d|a|n|u|e|m|p|w|f)+/", $pattern, $m)) {
		  $_offset = 0;
		  foreach ($m[0] as $k => $ph) {			  
			  if ($ph == '?u' || $ph == '?e') {
				  $table_pattern = '\?\:';
				  
				  if (preg_match("/^(UPDATE|INSERT INTO|REPLACE INTO|DELETE FROM) " . $table_pattern . "(\w+) /", $pattern, $m)) {
					  $data[$k] = self::checkTableFields($data[$k], $m[2]);
					  if (empty($data[$k])) {
						  return false;
					  }
				  }
			  }
	
			  switch ($ph) {
				  // integer
				  case '?i':
					  $pattern = self::strReplace($ph, intval($data[$k]), $pattern, $_offset); // Trick to convert int's and longint's
					  break;
	
				  // string
				  case '?s':
					  $pattern = self::strReplace($ph, "'" . $mysqli->real_escape_string($data[$k]) . "'", $pattern, $_offset);
					  break;
	
				  // string for LIKE operator
				  case '?l':
					  $pattern = self::strReplace($ph, "'" . $mysqli->real_escape_string(str_replace("\\", "\\\\", $data[$k])) . "'", $pattern, $_offset);	  
					  break;				  
				  // float
				  case '?d':
					  if ($data[$k] == INF) {
						  $data[$k] = PHP_INT_MAX;
					  }
					  $pattern = self::strReplace($ph, sprintf('%01.2f', $data[$k]), $pattern, $_offset);
					  break;
	
				  // array of string
				  // @FIXME: add trim
				  case '?a':
					  $data[$k] = is_array($data[$k]) ? $data[$k] : array($data[$k]);
					  if (!empty($data[$k])) {
						  $pattern = self::strReplace($ph, implode(', ', self::filterData($data[$k], true, true)), $pattern, $_offset);
					  } else {					  
						  $pattern = self::strReplace($ph, 'NULL', $pattern, $_offset);
					  }
					  break;
	
				  // array of integer
				  // FIXME: add trim
				  case '?n':
					  $data[$k] = is_array($data[$k]) ? $data[$k] : array($data[$k]);
					  $pattern = self::strReplace($ph, !empty($data[$k]) ? implode(', ', array_map(array('self', 'intVal'), $data[$k])) : "''", $pattern, $_offset);
					  break;
	
				  // update
				  case '?u':
					  $clue = ($ph == '?u') ? ', ' : ' AND ';
					  $q = implode($clue, self::filterData($data[$k], false));
					  $pattern = self::strReplace($ph, $q, $pattern, $_offset);
	
					  break;
				  // insert
				  case '?e':
					  $filtered = self::filterData($data[$k], true);
					  $pattern = self::strReplace($ph,
						  "(" . implode(', ', array_keys($filtered)) . ") VALUES (" . implode(', ', array_values($filtered)) . ")", $pattern,
						  $_offset);
					  break;
	
				  // insert multi
				  case '?m':
					  $values = array();
					  foreach ($data[$k] as $value) {
						  $filtered = self::filterData($value, true);
						  $values[] = "(" . implode(', ', array_values($filtered)) . ")";
					  }
					  $pattern = self::strReplace($ph, "(" . implode(', ', array_keys($filtered)) . ") VALUES " . implode(', ', $values), $pattern, $_offset);
					  break;
	
				  // field/table/database name
				  case '?f':
					  $pattern = self::strReplace($ph, $data[$k], $pattern, $_offset);
					  break;
	
				  // prepared statement
				  case '?p':
					  $pattern = self::strReplace($ph, $data[$k], $pattern, $_offset);
					  break;
			  }
		  }
	  }
	  return $pattern;
	}
	
	public static function checkTableFields($data, $table_name){
        $fields = self::getTableFields($table_name);
        if (is_array($fields)) {
            foreach ($data as $k => $v) {
                if (!in_array((string) $k, $fields, true)) {
                    unset($data[$k]);
                }
            }
            if (func_num_args() > 3) {
                for ($i = 3; $i < func_num_args(); $i++) {
                    unset($data[func_get_arg($i)]);
                }
            }
            return $data;
        }
        return false;
    }
	public static function getTableFields($table_name, $exclude = array(), $wrap = false)
    {
        if (!isset($this->table_fields_cache[$table_name])) {
            $this->table_fields_cache[$table_name] = self::getColumn("SHOW COLUMNS FROM ?:$table_name");
        }
        $fields = $this->table_fields_cache[$table_name];
        if (!$fields) {
            return false;
        }
        if ($exclude) {
            $fields = array_diff($fields, $exclude);
        }
        if ($wrap) {
            foreach ($fields as &$v) {
                $v = "`$v`";
            }
        }
        return $fields;
    }
	
	public static function getColumn($query){
        $result = array();
		$mysqli = db_connect();
        if ($_result = call_user_func_array(db_query, func_get_args())) {
            while ($arr = $mysqli->fetchRow($_result, 'indexed')) {
                $result[] = $arr[0];
            }
            $mysqli->freeResult($_result);
        }
        return $result;
    }
	protected static function filterData($data, $key_value, $force_quote = false)
    {
        $filtered = array();
        foreach ($data as $field => $value) {
            $value = self::prepareValue($value, $force_quote);

            if ($key_value == true) {
                $filtered['`' . self::field($field) . '`'] = $value;
            } else {
                $filtered[] = '`' . self::field($field) . '` = ' . $value;
            }

        }
        return $filtered;
    }
	
	protected static function prepareValue($value, $force_quote = false)
    {
		$mysqli = db_connect();
        if ($force_quote) {
            $value = "'" . $mysqli->real_escape_string($value) . "'";
        } elseif (is_int($value) || is_float($value)) {
            //ok
        } elseif (is_numeric($value) && $value === strval($value + 0)) {
            $value += 0;
        } elseif (is_null($value)) {
            $value = 'NULL';
        } else {
            $value = "'" . $mysqli->real_escape_string($value) . "'";
        }

        return $value;
    }
	protected static function field($field){
        if (preg_match("/([\w]+)/", $field, $m) && $m[0] == $field) {
            return $field;
        }
        return '';
    }
	
	protected static function strReplace($needle, $replacement, $subject, &$offset)
    {
        $pos = strpos($subject, $needle, $offset);
        $offset = $pos + strlen($replacement);
        $return = substr($subject, 0, $pos) . $replacement . substr($subject, $pos + 2);
        return $return;
    }
}