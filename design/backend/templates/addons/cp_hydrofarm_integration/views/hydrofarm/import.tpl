{capture name="mainbox"}

    <div class="center control-group ">
        {__("cp_hydrofarm_explain")}
    </div>

    <div class="center control-group ">
        {__("cp_hydrofarm_currently_imported", ["[total]" => $hydrofarm.total])}
    </div>

    <div class="center control-group ">
        <form action="{""|fn_url}" method="post" id="hydrofarm_import" name="hydrofarm_import">
            <input type="hidden" name="mode" value="import">
            {include file="buttons/button.tpl" 
                but_role="submit-link" 
                but_meta="cm-post cm-ajax cm-comet" 
                but_text=__('cp_hydrofarm_make_import') 
                but_name="dispatch[hydrofarm.import]"
            }
        </form>
    </div>
    {if $hydrofarm.total}
        <div class="center control-group ">
            {__("cp_hydrofarm_currently_processed", ["[processed]" => $hydrofarm.processed])}
        </div>

        <div class="center control-group ">
            <form action="{""|fn_url}" method="post" id="hydrofarm_form" name="hydrofarm_form">
                <input type="hidden" name="mode" value="process">
                {include file="buttons/button.tpl" 
                    but_role="submit-link" 
                    but_meta="cm-post cm-ajax cm-comet"
                    but_text=__('cp_hydrofarm_process_import') 
                    but_name="dispatch[hydrofarm.process]"
                }
            </form>
        </div>
    {/if}

    <div class="center control-group ">
        {__("cp_hydrofarm_also_you_can")}
    </div>
    <div class="center control-group ">

        {include file="buttons/button.tpl" 
            but_role="action" 
            but_href="hydrofarm.update_by_cron" 
            but_text=__('cp_hydrofarm_update_prices_and_amount') 
        }
    </div>

{/capture}

{include file="common/mainbox.tpl" title=__("cp_hydrofarm_import") content=$smarty.capture.mainbox}
