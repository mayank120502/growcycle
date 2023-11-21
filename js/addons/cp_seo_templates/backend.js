(function(_, $) {
    $(document).ready(function () {
        $('.cm-cp-sidebar-variables').on('click', '.nav-opener', function(e) {
            var list = $(this).parent().find('ul.nav:first');
            list.toggleClass('hidden');

            if ($(this).hasClass('icon-minus')) { //close child lists
                list.find('ul').addClass('hidden');
                list.find('.icon-minus').toggleClass('icon-plus icon-minus');
            }

            $(this).toggleClass('icon-plus icon-minus');
        });
    });
}(Tygh, Tygh.$));

function fn_cp_condition_add(id, skip_select, field_name)
{
    var $ = Tygh.$,
        new_group = false,
        new_id = $('#container_' + id).cloneNode(0, true, true).str_replace('container_', ''),
        $new_container = $('#container_' + new_id),
        $input = null;

    skip_select = skip_select || false;

    // Iterate through all previous elements
    $new_container.prevAll('[id^="container_"]').each(function() {
        var $this = $(this);
        $input = $('input[name^="' + field_name + '"]:first', $this).clone();
        if ($input.length == 0) {
            $input = $('input[data-ca-input-name^="' + field_name + '"]:first', $this).clone();
        }

        if ($input.length == 0) {

        } else {
            if ($input.val() != 'undefined' && $input.val() != '') {
                $input.val('');
            }

            return false;
        }
    });

    // We added new group, so we need to get input from parent element or this is the new condition
    if ($input === null || !$input.get(0)) {
        $input = $('input[name^="' + field_name + '"]:first', $new_container.parents('li:first')).clone(); // for group

        $('.no-node.no-items', $new_container.parents('ul:first')).hide(); // hide conainer with "no items" text

        // new condition
        if (!$input.get(0)) {
            var n = field_name + '[conditions][0][condition]';
            $input = $('<input type="hidden" name="'+ n +'" value="" />');
        } else {
            new_group = true;
        }
    }

    var _name = $input.prop('name').length > 0 ? $input.prop('name') : $input.data('caInputName');
    var val = parseInt(_name.match(/(.*)\[(\d+)\]/)[2]);
    var name = new_group ? _name : _name.replace(/(.*)\[(\d+)\]/, '$1[' + (val + 1) +']');

    $input.attr('name', name);
    $new_container.append($input);
    name = name.replace(/\[(\w+)\]$/, '');

    if (new_group) {
        name += '[conditions][1]';
    }

    $new_container.prev().removeClass('cm-last-item'); // remove tree node closure from previous element
    $new_container.addClass('cm-last-item').show(); // add tree node closure to new element
    // Update selector with name with new index
    if (skip_select == false) {
        $('#container_' + new_id + ' select').prop('id', new_id).prop('name', name);

    // Or just return id and name (for group)
    } else {
        $new_container.empty(); // clear node contents
        return {
            new_id: new_id,
            name: name
        };
    }
}