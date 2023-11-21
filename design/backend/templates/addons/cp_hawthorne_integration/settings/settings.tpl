{$cron_pass = $addons.cp_hawthorne_integration.cron_password}
{$root_directory = $config.dir.root}

<div class="control-group setting-wide">
    <label class="control-label">
        {__("cp_hawthorne_update_prices_and_amount")}
    </label>
    <div class="controls">
        <p>
            <a class="btn btn-primary" href="{fn_url("hawthorne.update_by_cron&cron_pass={$cron_pass}")}" target="_blank">
                {__("cp_hawthorne_try_manually")}
            </a>
        </p><br />
    
        {include file="common/widget_copy.tpl"
            widget_copy_title=__("tip")
            widget_copy_text=__("cp_hawthorne_use_cron")
            widget_copy_code_text = fn_get_console_command("php {$root_directory}", $config.customer_index, [
                "dispatch" => "hawthorne.update_by_cron",
                "cron_pass" => $cron_pass
            ])
        }
        {include file="common/widget_copy.tpl"
            widget_copy_code_text = "curl "|cat:fn_url("hawthorne.update_by_cron&cron_pass=`$cron_pass`", 'C')
        }
    </div>
</div>
