<div class="boards form">
<?php echo $this->Form->create('Board');?>
	<fieldset>
 		<legend><?php __('Add Board'); ?></legend>
	<?php
		echo $this->Form->input('name');
		echo $this->Form->input('fid');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('List Boards', true), array('action' => 'index'));?></li>
	</ul>
</div>