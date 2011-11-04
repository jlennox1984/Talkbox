<?php
/* Board Test cases generated on: 2011-11-04 01:11:00 : 1320383880*/
App::import('Model', 'Board');

class BoardTestCase extends CakeTestCase {
	var $fixtures = array('app.board');

	function startTest() {
		$this->Board =& ClassRegistry::init('Board');
	}

	function endTest() {
		unset($this->Board);
		ClassRegistry::flush();
	}

}
?>