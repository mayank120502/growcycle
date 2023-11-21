<?php

use Phinx\Migration\AbstractMigration;

class AlterPageDescriptions extends AbstractMigration
{ 
    public function up()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}page_descriptions");
        if (!$table->hasColumn('cp_st_h1')) {
            $table
                ->addColumn('cp_st_h1', 'string', array('limit' => 100, 'null' => false, 'default' => ''))
                ->save();
        }
        if (!$table->hasColumn('cp_st_custom_bc')) {
            $table
                ->addColumn('cp_st_custom_bc', 'string', array('limit' => 100, 'null' => false, 'default' => ''))
                ->save();
        }
    }

    public function down()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}page_descriptions");

        if ($table->hasColumn('cp_st_h1')) {
            $table->removeColumn('cp_st_h1');
        }
        if ($table->hasColumn('cp_st_custom_bc')) {
            $table->removeColumn('cp_st_custom_bc');
        }
    }
}
