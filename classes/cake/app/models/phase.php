<?php
class Phase extends AppModel {
	var $name = 'Phase';
/**	var $hasMany =array(
		'boards' => array(
		'className' => 'board',
		'foreignKey' => 'id'));
//	  var $actsAs = array(
 //       'MeioUpload' => array('filename')
//);
*/
	var $belongsTo = array('Boards');
}
?>
