<?php
class DATABASE_CONFIG {

	var $default = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'root',
		'password' => 'talkbox',
		'database' => 'speachbox',
		'schema' => 'public',
	);
	var $test = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'root',
		'password' => 'talkbox',
		'database' => 'speachbox',
		'schema' => 'public',
	);
	var $speachbox = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'port' => 5432,
		'login' => 'root',
		'password' => 'talkbox',
		'database' => 'speachbox',
		'schema' => 'public',
	);
}
?>