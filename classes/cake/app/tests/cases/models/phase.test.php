<?php
/* Phase Test cases generated on: 2010-12-14 07:12:51 : 1292329491*/
App::import('Model', 'Phase');

class PhaseTestCase extends CakeTestCase {
	var $fixtures = array('app.phase');

	function startTest() {
		$this->Phase =& ClassRegistry::init('Phase');
	}

	function endTest() {
		unset($this->Phase);
		ClassRegistry::flush();
	}

}
?>