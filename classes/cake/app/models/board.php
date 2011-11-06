<?php
class Board extends AppModel {
	var $name = 'Board';
	var $hasMany = array(
	'folders' => array(
	'className' => 'folders',
	'conditions' => array('boards.fid=folders.id'),
	'order' => 'boards.id'));

}
?>
