<?php
/* Phases Test cases generated on: 2010-12-14 07:12:45 : 1292329785*/
App::import('Controller', 'Phases');

class TestPhasesController extends PhasesController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class PhasesControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.phase');

	function startTest() {
		$this->Phases =& new TestPhasesController();
		$this->Phases->constructClasses();
	}

	function endTest() {
		unset($this->Phases);
		ClassRegistry::flush();
	}

	function testIndex() {

	}

	function testView() {

	}

	function testAdd() {

	}

	function testEdit() {

	}

	function testDelete() {

	}

}
?>