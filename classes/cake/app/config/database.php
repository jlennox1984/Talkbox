<?php
class DATABASE_CONFIG {

	var $default = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'jeff',
		'password' => '1771',
		'database' => 'speachbox',
		'schema' => 'public',
	);
	var $test = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'jeff',
		'password' => 'talkbox',
		'database' => '1771',
		'schema' => 'public',
	);
	var $speachbox = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'port' => 5432,
		'login' => 'jeff',
		'password' => '1771',
		'database' => 'speachbox',
		'schema' => 'public',
	);
}
?>
