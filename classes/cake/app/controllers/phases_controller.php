<?php
class PhasesController extends AppController {

	var $name = 'Phases';
	
	function index() {
		$this->Phase->recursive = 0;
		$this->set('phases', $this->paginate());
	}

	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid phase', true));
			$this->redirect(array('action' => 'index'));
		}
		$this->set('phase', $this->Phase->read(null, $id));
	}

	function add() {
		if (!empty($this->data)) {
			$this->Phase->create();
			if ($this->Phase->save($this->data)) {
				$this->Session->setFlash(__('The phase has been saved', true));
				$this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The phase could not be saved. Please, try again.', true));
		
			}
		$this->autorender=false;
			}
	}

	function edit($id = null) {
		if (!$id && empty($this->data)) {
			$this->Session->setFlash(__('Invalid phase', true));
			$this->redirect(array('action' => 'index'));
		}
		if (!empty($this->data)) {
			if ($this->Phase->save($this->data)) {
				$this->Session->setFlash(__('The phase has been saved', true));
				$this->redirect(array('action' => 'index'));
			} else {
				$this->Session->setFlash(__('The phase could not be saved. Please, try again.', true));
			}
		}
		if (empty($this->data)) {
			$this->data = $this->Phase->read(null, $id);
		}
	}

	function delete($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid id for phase', true));
			$this->redirect(array('action'=>'index'));
		}
		if ($this->Phase->delete($id)) {
			$this->Session->setFlash(__('Phase deleted', true));
			$this->redirect(array('action'=>'index'));
		}
		$this->Session->setFlash(__('Phase was not deleted', true));
		$this->redirect(array('action' => 'index'));
	}
}
?>
