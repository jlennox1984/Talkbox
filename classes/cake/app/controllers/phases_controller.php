<?php
class PhasesController extends AppController {

	var $name = 'Phases';
	var $path='/var/www/';	
	var $validateFile = array(
                          'size' => 204800,
	                  'type' => 'jpg,jpeg,png,gif'
          				);
		

	function generateUniqueFilename($fileName, $path=''){
   //$path = empty($path) ? WWW_ROOT.'/files/' : $path;
     $path='/var/www/';
	 $no = 1;
    $newFileName = $fileName;
    while (file_exists("$path/".$newFileName)) {
      $no++;
      $newFileName = substr_replace($fileName, "_$no.", strrpos($fileName, "."), 1);
    }
    return $newFileName;
  }
	  function handleFileUpload($fileData, $fileName)
  {
	 $path='/var/www/pics/';

    $error = false;

    //Get file type
    $typeArr = explode('/', $fileData['type']);

    //If size is provided for validation check with that size. Else compare the size with INI file
    if (($this->validateFile['size'] && $fileData['size'] > $this->validateFile['size']) || $fileData['error'] == UPLOAD_ERR_INI_SIZE)
    {
      $error = 'File is too large to upload';
    }
    elseif ($this->validateFile['type'] && (strpos($this->validateFile['type'], strtolower($typeArr[1])) === false))
    {
      //File type is not the one we are going to accept. Error!!
      $error = 'Invalid file type';
    }
    else
    {
      //Data looks OK at this stage. Let's proceed.
      if ($fileData['error'] == UPLOAD_ERR_OK)
      {
        //Oops!! File size is zero. Error!
        if ($fileData['size'] == 0)
        {
          $error = 'Zero size file found.';
        }
        else
        {
          if (is_uploaded_file($fileData['tmp_name']))
          {
            //Finally we can upload file now. Let's do it and return without errors if success in moving.
        	    
	if (!move_uploaded_file($fileData['tmp_name'], $path. '/' .$fileName))
            {
              $error = true;
            }
          }
          else
          {
            $error = true;
          }
        }
      }
    }
    return $error;
  }
 
	
function deleteMovedFile($fileName)
  {
    if (!$fileName || !is_file($fileName))
    {
      return true;
    }
    if(unlink($fileName))
    {
      return true;
    }
    return false;
  }

	function index() {
		$this->Phase->recursive = 0;
		$this->set('phases', $this->paginate());
		$this->set('boards', $this->Phase->Boards->find('all')); 
 
	}

	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid phase', true));
			$this->redirect(array('action' => 'index'));
		}
		$this->set('phase', $this->Phase->read(null, $id));
	}

	  function add(){
          if (empty($this->data))
          {
            $this->Phase->create();
          }
          else
          {
            $err = false;
            if (!empty($this->data['Phase']['filename']['tmp_name'])) {
              $fileName = $this->generateUniqueFilename($this->data['Phase']['filename']['name']);
              //echo 'The filename is:'. $fileName;
              $error = $this->handleFileUpload($this->data['Phase']['filename'], $fileName);
      }  else {
                print_r($this->data);
        }
            if (!$error)
            {
              $this->data['Phase']['filename'] = $fileName;
              if ($this->Phase->save($this->data))
              {
                $this->Session->setFlash(__('The Attachment has been saved',true));
                $this->redirect(array('action'=>'index'));
              } else {
                $err = true;
              }
            } else {
              $this->Phase->set($this->data);
            }






            if ($error || $err)
            {
              //Something failed. Remove the image uploaded if any.
        //      $this->deleteMovedFile(WWW_ROOT.IMAGES_URL.$fileName);
              $this->set('error', $error);
              $this->set('data', $this->data);
              $this->validateErrors($this->Phase);
              $this->render();
            }

          }
         $this->set('boards_list', $this->Phase->Boards->find('list', array('fields' => array('id', 'name'))));

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
	$borads_lists =array();

               // $boards= $this->Phase->query('SELECT id,name FROM boards;');
               

           //$this->set('boards_list', $boards_list);
		 $this->set('boards_list', $this->Phase->Boards->find('list' ,array('name','id')));
	


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
