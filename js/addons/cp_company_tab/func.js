$.ceEvent('on', 'ce.commoninit', function (context) {
    var active_section = context.find('.ty-cpt-td-active');
    if (active_section.length > 0) {

        var active_section_id = active_section.attr('id').replace('cpt_title_','');
        var other_titles_elems = context.find("[id^='cpt_title_']");

        if (other_titles_elems.length) {
            other_titles_elems.on('click', function () {

                var $ = Tygh.$,
                    elm_obj = $(this),
                    clicked_title = elm_obj.attr('id'),
                    clicked_title_id = clicked_title.replace('cpt_title_','');

                if (active_section_id != clicked_title_id) {
                    context.find("#cpt_title_" + clicked_title_id).removeClass("ty-cpt-td");
                    context.find("#cpt_title_" + clicked_title_id).addClass("ty-cpt-td-active");
                    context.find("#cpt_content_" + clicked_title_id).removeClass("hidden");
                    context.find("#cpt_content_" + active_section_id).addClass("hidden");
                    context.find("#cpt_title_" + active_section_id).removeClass("ty-cpt-td-active");
                    context.find("#cpt_title_" + active_section_id).addClass("ty-cpt-td");
                    active_section_id = clicked_title_id;
                }
            });
        }
    }
});
