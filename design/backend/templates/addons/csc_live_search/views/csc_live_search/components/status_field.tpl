<ul class="unstyled">
    <li>
        <div class="list-description">
            {$field_name nofilter} {if $field_name_ttl} <i class="cm-tooltip icon-question-sign" title="{$field_name_ttl}"></i>{/if}
        </div>
        <div class="switch switch-mini cm-switch-change-{$input_name|md5} list-btns" id="{$input_name|md5} ">
            <input type="checkbox" name="{$input_name}" value="1" {if $value}checked="checked"{/if}/>
        </div>
    </li>
</ul>

<script type="text/javascript">
    (function (_, $) {
        $(_.doc).on('switch-change', '.cm-switch-change-{$input_name|md5}', function (e, data) {
            var value = data.value;
            $.ceAjax('request', fn_url("csc_live_search.{$mode}"), {
                method: 'post',
                data: {
                    name: data.el.prop('name'),
                    value: value ? 1 : 0
                }
            });
        });

        $.ceEvent('on', 'ce.ajaxdone', function(){
            if ($('.switch .switch-mini').length == 0) {
                $('.switch')['bootstrapSwitch']();
            }
        });
    }(Tygh, Tygh.$));
</script>
<hr>