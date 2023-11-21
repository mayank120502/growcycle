{capture name="mainbox"}

    <div class="center control-group ">
        {__("cp_hawthorne_explain")}
    </div>

    <div class="center control-group ">
        {__("cp_hawthorne_currently_imported", ["[total]" => $hawthorne.total])}
    </div>

    <div class="center control-group ">
        <form action="{""|fn_url}" method="post" id="hawthorne_import" name="hawthorne_import">
            <input type="hidden" name="mode" value="import">
            {include file="buttons/button.tpl" 
                but_role="submit-link" 
                but_meta="cm-post cm-ajax cm-comet" 
                but_text=__('cp_hawthorne_make_import') 
                but_name="dispatch[hawthorne.import]"
            }
        </form>
    </div>
    {if $hawthorne.total}
        <div class="center control-group ">
            {__("cp_hawthorne_currently_processed", ["[processed]" => $hawthorne.processed])}
        </div>

        <div class="center control-group ">
            <form action="{""|fn_url}" method="post" id="hawthorne_form" name="hawthorne_form">
                <input type="hidden" name="mode" value="process">
                {include file="buttons/button.tpl" 
                    but_role="submit-link" 
                    but_meta="cm-post cm-ajax cm-comet"
                    but_text=__('cp_hawthorne_process_import') 
                    but_name="dispatch[hawthorne.process]"
                }
            </form>
        </div>
    {/if}

    <div class="center control-group ">
        {__("cp_hawthorne_also_you_can")}
    </div>
    <div class="center control-group ">

        {include file="buttons/button.tpl" 
            but_role="action" 
            but_href="hawthorne.update_by_cron" 
            but_text=__('cp_hawthorne_update_prices_and_amount') 
        }
    </div>

{/capture}

{include file="common/mainbox.tpl" title=__("cp_hawthorne_import") content=$smarty.capture.mainbox}
