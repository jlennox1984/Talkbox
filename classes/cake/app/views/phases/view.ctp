<div class="phases view">
<h2><?php  __('Phase');?></h2>
	<dl><?php $i = 0; $class = ' class="altrow"';?>
		<dt<?php if ($i % 2 == 0) echo $class;?>><?php __('Phases'); ?></dt>
		<dd<?php if ($i++ % 2 == 0) echo $class;?>>
			<?php echo $phase['Phase']['phases']; ?>
			&nbsp;
		</dd>
		<dt<?php if ($i % 2 == 0) echo $class;?>><?php __('Pic'); ?></dt>
		<dd<?php if ($i++ % 2 == 0) echo $class;?>>
			<?php echo $phase['Phase']['pic']; ?>
			&nbsp;
		</dd>
		  <dt<?php if ($i % 2 == 0) echo $class;?>><?php __('Paraphase'); ?></dt>
                <dd<?php if ($i++ % 2 == 0) echo $class;?>>
                        <?php echo $phase['Phase']['paraphase']; ?>
                        &nbsp;
                </dd>
	
		
		<dt<?php if ($i % 2 == 0) echo $class;?>><?php __('Id'); ?></dt>
		<dd<?php if ($i++ % 2 == 0) echo $class;?>>
			<?php echo $phase['Phase']['id']; ?>
			&nbsp;
		</dd>
	</dl>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>
		<li><?php echo $this->Html->link(__('Edit Phase', true), array('action' => 'edit', $phase['Phase']['id'])); ?> </li>
		<li><?php echo $this->Html->link(__('Delete Phase', true), array('action' => 'delete', $phase['Phase']['id']), null, sprintf(__('Are you sure you want to delete # %s?', true), $phase['Phase']['id'])); ?> </li>
		<li><?php echo $this->Html->link(__('List Phases', true), array('action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('New Phase', true), array('action' => 'add')); ?> </li>
	</ul>
</div>
