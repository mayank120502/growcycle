<?php

use Phinx\Migration\AbstractMigration;

class AlterPages extends AbstractMigration
{ 
    public function up()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}pages");
        if (!$table->hasColumn('cp_seo_use_addon')) {
            $table
                ->addColumn('cp_seo_use_addon', 'char', array('limit' => 1, 'null' => false, 'default' => 'Y'))
                ->save();
        }
        if (!$table->hasColumn('cp_seo_no_index')) {
            $table
                ->addColumn('cp_seo_no_index', 'char', array('limit' => 1, 'null' => false, 'default' => 'D'))
                ->save();
        }
    }

    public function down()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}pages");

        if ($table->hasColumn('cp_seo_use_addon')) {
            $table->removeColumn('cp_seo_use_addon');
        }
        if ($table->hasColumn('cp_seo_no_index')) {
            $table->removeColumn('cp_seo_no_index');
        }
    }
}
