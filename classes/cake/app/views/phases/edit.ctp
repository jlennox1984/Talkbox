<div class="phases form">
<?php echo $this->Form->create('Phase');?>
	<fieldset>
 		<legend><?php __('Edit Phase'); ?></legend>
	<?php
		echo $this->Form->input('phases');
		 echo $this->Form->input('paraphase');
//		echo $this->Form->input('pic');
		echo "Picture:" .$this->Form->file('filename');
		echo $this->Form->input('id');
		 echo "Boards:" , $this->Form->select('boards.id' ,$boards_list);
?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('Delete', true), array('action' => 'delete', $this->Form->value('Phase.id')), null, sprintf(__('Are you sure you want to delete # %s?', true), $this->Form->value('Phase.id'))); ?></li>
		<li><?php echo $this->Html->link(__('List Phases', true), array('action' => 'index'));?></li>
	</ul>
</div>
