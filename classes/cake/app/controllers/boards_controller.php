<?php
  class BoardsController extends AppController {

	var $name = 'Boards';
	
	
	function index() {
                $this->Boards->recursive = 0;
                $this->set('Boards', $this->paginate());
	}
/**	function add(){
	$foldoridold= $this->boards->folders->find->first(); 	
		$fid=  $foldoridold++;
			
		}
*/	
}
?>
