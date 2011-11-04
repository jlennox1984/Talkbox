<?php
/* Board Fixture generated on: 2011-11-04 01:11:00 : 1320383880 */
class BoardFixture extends CakeTestFixture {
	var $name = 'Board';

	var $fields = array(
		'id' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'length' => 11, 'key' => 'primary'),
		'name' => array('type' => 'text', 'null' => false, 'default' => NULL, 'length' => 1073741824),
		'fid' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'created' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'modified' => array('type' => 'integer', 'null' => false, 'default' => NULL),
		'indexes' => array('PRIMARY' => array('unique' => true, 'column' => 'id')),
		'tableParameters' => array()
	);

	var $records = array(
		array(
			'id' => 1,
			'name' => 'Lorem ipsum dolor sit amet, aliquet feugiat. Convallis morbi fringilla gravida, phasellus feugiat dapibus velit nunc, pulvinar eget sollicitudin venenatis cum nullam, vivamus ut a sed, mollitia lectus. Nulla vestibulum massa neque ut et, id hendrerit sit, feugiat in taciti enim proin nibh, tempor dignissim, rhoncus duis vestibulum nunc mattis convallis.',
			'fid' => 1,
			'created' => 1,
			'modified' => 1
		),
	);
}
?>