<?php

use Phinx\Migration\AbstractMigration;

class AlterProductFilters extends AbstractMigration
{ 
    public function up()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}product_filters");
        if (!$table->hasColumn('cp_seo_index_result')) {
            $table
                ->addColumn('cp_seo_index_result', 'char', array('limit' => 1, 'null' => false, 'default' => 'N'))
                ->save();
        }
    }

    public function down()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}product_filters");

        if ($table->hasColumn('cp_seo_index_result')) {
            $table->removeColumn('cp_seo_index_result');
        }
    }
}
