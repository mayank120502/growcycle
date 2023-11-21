<?php

use Phinx\Migration\AbstractMigration;

class CreateCpSeoIndexRules extends AbstractMigration
{     
    public function up()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table(
            "{$pr}cp_seo_index_rules",
            array('id' => false, 'primary_key' => 'rule_id', 'engine' => 'MyISAM')
        );

        if ($table->exists()) {
            return;
        }

        $table
            ->addColumn('rule_id', 'integer', array('signed' => false, 'null' => false, 'identity' => true))
            ->addColumn('dispatch', 'string', array('limit' => 255, 'null' => false, 'default' => ''))
            ->addColumn('rule', 'char', array('limit' => 1, 'null' => false, 'default' => 'Y'))
            ->addColumn('company_id', 'integer', array('signed' => false, 'null' => false, 'default' => 0))
            ->create();
    }

    public function down()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}cp_seo_index_rules");

        if ($table->exists()) {
            $table->drop();
        }
    }
}
