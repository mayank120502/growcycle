{assign var=cls_settings value=fn_cls_get_settings()}
<style>
	@cls_base: {$cls_settings.base_text_color|default:"#2a2c47"};
	@cls_background: {$cls_settings.active_elements_background|default:"#eaeaed"};
	@cls_link: {$cls_settings.link_color|default:"#1155bb"};
	@cls_tabs: {$cls_settings.active_elements_color|default:"#029d52"};
	@cls_radius: {$cls_settings.border_radius|default:"5"}px;
	@cls_category: {$cls_settings.category_e|default:"#50AFD6"};
	@cls_desktop_max_width: {$cls_settings.desktop_max_width|default:"700"}px;
</style>
{assign var="cls_theme" value=$cls_settings.theme|default:"csc_live_search/themes/modern.less" }
{style src="addons/csc_live_search/animation.less"}
{style src="addons/csc_live_search/styles.less"}
{style src="addons/`$cls_theme`"}