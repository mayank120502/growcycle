<?php

use Phinx\Migration\AbstractMigration;
use Phinx\Db\Adapter\MysqlAdapter;

class CreateCpJsonLdCompanyDescriptions extends AbstractMigration
{
    public function up()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table(
            "{$pr}cp_json_ld_company_descriptions",
            array('id' => false, 'primary_key'  => array('company_id', 'lang_code'), 'engine' => 'MyISAM')
        );

        if ($table->exists()) {
            return;
        }

        $table
            ->addColumn('company_id', 'integer', array('signed' => false, 'null' => false, 'identity' => false, 'limit' => MysqlAdapter::INT_MEDIUM))
            ->addColumn('cp_description', 'text', array('limit' => MysqlAdapter::TEXT_MEDIUM))
            ->addColumn('cp_socials', 'text', array('limit' => MysqlAdapter::TEXT_MEDIUM))
            ->addColumn('lang_code', 'char', array('limit' => 2, 'null' => false))
            ->create();
    }

    public function down()
    {
        $options = $this->adapter->getOptions();
        $pr = $options['prefix'];

        $table = $this->table("{$pr}cp_json_ld_company_descriptions");

        if ($table->exists()) {
            $table->drop();
        }
    }
}
