{style src="addons/energothemes_search/styles.less"}
{assign var="custom_width" value=$addons.et_search.custom_width|default:"148"}
<style>
	.row-fluid .energo-searchbox{ldelim}
		width: {math equation="a-b" a=$custom_width b=1}px;
	{rdelim}
	.energo-searchbox+.ty-search-block__input{ldelim}
		padding-right: {math equation="a+b" a=$custom_width b=45}px;
	{rdelim}
</style>