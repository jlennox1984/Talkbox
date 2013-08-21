<?php
class DATABASE_CONFIG {

	var $default = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'talkbox',
		'password' => 'talkbox',
		'database' => 'talkbox',
		'schema' => 'public',
	);
	var $test = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'login' => 'postgres',
		'password' => 'postgres',
		'database' => 'talkbox',
		'schema' => 'public',
	);
	var $speachbox = array(
		'driver' => 'postgres',
		'persistent' => false,
		'host' => 'localhost',
		'port' => 5432,
		'login' => 'postgres',
		'password' =>'talkbox',
		'schema' => 'public',
	);
}
?>
