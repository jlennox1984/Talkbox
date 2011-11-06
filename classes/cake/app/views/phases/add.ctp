<div class="phases form">
<?php echo $this->Form->create('Phase', array('type'=>'file'))?>
	<fieldset>
 		<legend><?php __('Add Phase'); ?></legend>
	<?php
		echo $this->Form->input('phases');
		 echo $this->Form->input('paraphase');
		echo "picure:", $this->Form->file('filename');
		echo "Boards:" , $this->Form->select('boards_id' ,$boards_list);	
	?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('List Phases', true), array('action' => 'index'));?></li>
	</ul>
</div>
