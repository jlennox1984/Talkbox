<?php
class BoardsController extends AppController {

	var $name = 'Boards';
	var $scaffold;

	function add(){
	$foldoridold= $this->boards->folders->find->first() with order: id=>DESC; 	
		$fid=  $foldoridold++;
			
		}
	
}
?>
