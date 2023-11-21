{$admin_ind = $config.admin_index}
{$cron_pass = $addons.cp_suredone_integration.cron_password}
{$root_directory = $config.dir.root}

<div class="cp_suredone_integration_settings">
    <div class="control-group setting-wide">
        <label class="control-label">
            {__("cp_suredone_integration.added_order_checker")}
        </label>
        <div class="controls">
            <p>
                <a class="btn btn-primary cm-ajax" href="{fn_url("suredone.process.add_orders?cron_pass={$cron_pass}")}" class="cm-ajax cm-post" data-ca-target-id="rating">
                    {__("cp_suredone_integration.try_manually")}
                </a>
            </p><br />
        
            {include file="common/widget_copy.tpl"
                widget_copy_title=__("tip")
                widget_copy_text=__("cp_suredone_integration.cron_added_orders_checker")
                widget_copy_code_text = fn_get_console_command("php /path/to/cart/", $config.admin_index, [
                    "dispatch" => "suredone.process.add_orders",
                    "cron_pass" => $cron_pass
                ])
            }
            {include file="common/widget_copy.tpl"
                widget_copy_code_text = "curl "|cat:fn_url("suredone.process.add_orders?cron_pass=`$cron_pass`")
            }
        </div>
    </div>
    <div class="control-group setting-wide">
        <label class="control-label">
            {__("cp_suredone_integration.updated_order_checker")}
        </label>
        <div class="controls">
            <p>
                <a class="btn btn-primary cm-ajax" href="{fn_url("suredone.process.update_orders?cron_pass={$cron_pass}")}" class="cm-ajax cm-post" data-ca-target-id="rating">
                    {__("cp_suredone_integration.try_manually")}
                </a>
            </p><br />

            {include file="common/widget_copy.tpl"
                widget_copy_title=__("tip")
                widget_copy_text=__("cp_suredone_integration.cron_updated_orders_checker")
                widget_copy_code_text = fn_get_console_command("php /path/to/cart/", $config.admin_index, [
                    "dispatch" => "suredone.process.update_orders",
                    "cron_pass" => $cron_pass
                ])
            }
            {include file="common/widget_copy.tpl"
                widget_copy_code_text = "curl "|cat:fn_url("suredone.process.update_orders?cron_pass=`$cron_pass`")
            }
        </div>
    </div>
    <div class="control-group setting-wide">
        <label class="control-label">
            {__("cp_suredone_integration.added_new_products_checker")}
        </label>
        <div class="controls">
            <p>
                <a class="btn btn-primary cm-ajax" href="{fn_url("suredone.process.add_new_products?cron_pass={$cron_pass}")}" class="cm-ajax cm-post" data-ca-target-id="rating">
                    {__("cp_suredone_integration.try_manually")}
                </a>
            </p><br />

            {include file="common/widget_copy.tpl"
                widget_copy_title=__("tip")
                widget_copy_text=__("cp_suredone_integration.cron_added_new_products_checker")
                widget_copy_code_text = fn_get_console_command("php /path/to/cart/", $config.admin_index, [
                    "dispatch" => "suredone.process.add_new_products",
                    "cron_pass" => $cron_pass
                ])
            }
            {include file="common/widget_copy.tpl"
                widget_copy_code_text = "curl "|cat:fn_url("suredone.process.add_new_products?cron_pass=`$cron_pass`")
            }
        </div>
    </div>
    <div class="control-group setting-wide">
        <label class="control-label">
            {__("cp_suredone_integration.updated_amount_products_checker")}
        </label>
        <div class="controls">
            <p>
                <a class="btn btn-primary cm-ajax" href="{fn_url("suredone.process.get_amount_products?cron_pass={$cron_pass}")}" class="cm-ajax cm-post" data-ca-target-id="rating">
                    {__("cp_suredone_integration.try_manually")}
                </a>
            </p><br />

            {include file="common/widget_copy.tpl"
                widget_copy_title=__("tip")
                widget_copy_text=__("cp_suredone_integration.cron_updated_amount_products_checker")
                widget_copy_code_text = fn_get_console_command("php /path/to/cart/", $config.admin_index, [
                    "dispatch" => "suredone.process.get_amount_products",
                    "cron_pass" => $cron_pass
                ])
            }
            {include file="common/widget_copy.tpl"
                widget_copy_code_text = "curl "|cat:fn_url("suredone.process.get_amount_products?cron_pass=`$cron_pass`")
            }
        </div>
    </div>
</div>
