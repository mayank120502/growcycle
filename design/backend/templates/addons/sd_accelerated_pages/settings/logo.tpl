<div
    id="sd_amp_logo_uploader"
    class="in collapse{if $is_root} disable-overlay-wrap{/if}">

    {if $is_root}
        <div class="disable-overlay" id="sd_amp_logo_disable_overlay"></div>
    {/if}

    <div class="control-group">
        <div class="controls">
            {include
                file="views/companies/components/logos_list.tpl"
                logos=$logos company_id=$company_id
            }

            {if $is_root}
                <div class="right update-for-all">
                    {include
                        file="buttons/update_for_all.tpl"
                        display=true
                        object_id="settings"
                        name="settings[sd_amp_logo_update_all_vendors]"
                        hide_element="sd_amp_logo_uploader"
                    }
                </div>
            {/if}
        </div>
    </div>
</div>

<script type="text/javascript">
    (function(_, $) {
        $(document).ready(function() {
            $('.cm-update-for-all-icon[data-ca-hide-id=sd_amp_logo_uploader]').on('click', function() {
                $('#sd_amp_logo_uploader').toggleClass('disable-overlay-wrap');
                $('#sd_amp_logo_disable_overlay').toggleClass('disable-overlay');
            });
        });
    }(Tygh, Tygh.$));
</script>
