<?php
/* Boards Test cases generated on: 2011-11-04 01:11:11 : 1320383891*/
App::import('Controller', 'Boards');

class TestBoardsController extends BoardsController {
	var $autoRender = false;

	function redirect($url, $status = null, $exit = true) {
		$this->redirectUrl = $url;
	}
}

class BoardsControllerTestCase extends CakeTestCase {
	var $fixtures = array('app.board');

	function startTest() {
		$this->Boards =& new TestBoardsController();
		$this->Boards->constructClasses();
	}

	function endTest() {
		unset($this->Boards);
		ClassRegistry::flush();
	}

}
?>