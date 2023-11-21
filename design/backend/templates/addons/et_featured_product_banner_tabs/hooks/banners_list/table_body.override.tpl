<td>
    <input type="checkbox" {if $smarty.request.display=="radio" && $smarty.request.extra==$banner.banner_id}checked{/if} name="{$smarty.request.checkbox_name|default:"banners_ids"}[]" value="{$banner.banner_id}" class="cm-item mrg-check" /></td>
<td id="banner_{$banner.banner_id}" width="80%" data-th="{__("banner")}">{$banner.banner}</td>
<td width="20%" data-th="{__("creation_date")}">
    {$banner.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}
</td>