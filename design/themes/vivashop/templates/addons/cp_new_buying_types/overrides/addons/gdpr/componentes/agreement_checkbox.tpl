{if $type && $app["addons.gdpr.service"]->isNeeded($type)}
    {$show_agreement = true scope="parent"}
    {if !$tooltip_only}
        {$input_id = $input_id|default:"gdpr_agreements_{$type}{if $suffix}_{$suffix}{/if}"}
        {$gdpr_target_elem = "{$input_id}_label"}

        <div class="ty-gdpr-agreement">
            <input
                    type="checkbox"
                    id="{$input_id}"
                    name="{$input_name|default:"gdpr_agreements[{$type}]"}"
                    value="{$input_value|default:"Y"}"
                    class="cm-agreement checkbox{if $meta} {$meta}{/if}"
                    {if $onclick}onclick="{$onclick nofilter}"{/if}
                    {if $checked}checked="checked"{/if}
                    data-ca-error-message-target-node="#{$input_id}_error_wrapper"
                />
               
            <label
                for="{$input_id}"
                id="{$input_id}_label"
                class="{if $agreement_required}cm-gdpr-check-agreement {/if}checkbox ty-gdpr-agreement--label"
            >
                {$app["addons.gdpr.service"]->getShortAgreement($type) nofilter}
                {if $_REQUEST.dispatch != "cp_nbt_login.continue"}
                    {include_ext file="common/icon.tpl"
                        class="ty-icon-help-circle ty-gdpr-agreement--icon"
                    }
                {/if}
            </label>
            {if $_REQUEST.dispatch == "cp_nbt_login.continue"}
                {include_ext file="common/icon.tpl"
                    class="ty-icon-help-circle ty-gdpr-agreement--icon js-gdpr-tooltip"
                }
            {/if}
            <div id="{$input_id}_error_wrapper"></div>
        </div>

        <script>
            (function(_, $) {
                $.ceFormValidator('registerValidator', {
                    class_name: 'cm-gdpr-check-agreement',
                    message: '{__('gdpr.agreement_required_error')|escape:javascript}',
                    func: function(id) {
                        return $('#' + id).prop('checked');
                    }
                });

                $.ceEvent('on', 'ce.commoninit', function(context) {
                    $(context).find('#{$input_id}').on('change', function (e) {
                        var $item = $(e.target);
                        $.ceEvent('trigger', 'ce.gdpr_agreement_accepted', [$item, context]);
                    });
                });
            }(Tygh, Tygh.$));
        </script>

        {if $_REQUEST.dispatch == "cp_nbt_login.continue"}
            <script>
                (function(_, $) {
                    $(_.doc).on('click', '.js-gdpr-tooltip', function(e) {
                        const targeteElem = '#gdpr_tooltip_' + '{$gdpr_target_elem}';
                        $(targeteElem).toggleClass('cm-gdpr-tooltip_hidden');
                    });
                }(Tygh, Tygh.$));
            </script>
        {/if}
    {/if}

    {include file="addons/gdpr/componentes/gdpr_tooltip.tpl" type=$type target_elem_id=$gdpr_target_elem dispatch=$_REQUEST.dispatch}
{/if}
