<div class="phases form">
<?php echo $this->Form->create('Phase');?>
	<fieldset>
 		<legend><?php __('Add Phase'); ?></legend>
	<?php
		echo $this->Form->input('phases');
		echo $this->Form->input('pic');
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