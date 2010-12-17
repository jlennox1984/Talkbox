<?php
/* Phase Fixture generated on: 2010-12-14 07:12:45 : 1292329485 */
class PhaseFixture extends CakeTestFixture {
	var $name = 'Phase';

	var $fields = array(
		'phases' => array('type' => 'string', 'null' => true),
		'pic' => array('type' => 'string', 'null' => true),
		'id' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'length' => 11, 'key' => 'primary'),
		'indexes' => array(),
		'tableParameters' => array()
	);

	var $records = array(
		array(
			'phases' => 'Lorem ipsum dolor sit amet',
			'pic' => 'Lorem ipsum dolor sit amet',
			'id' => 1
		),
	);
}
?>