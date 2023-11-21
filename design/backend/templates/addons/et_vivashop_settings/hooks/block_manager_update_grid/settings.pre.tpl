{assign var="ef_ids" value=","|explode:$grid.et_grid}
<div class="control-group cm-no-hide-input">
  <label class="control-label" for="elm_grid_et_grid_{$id}">{__("et_full_grid")}:</label>
  <div class="controls">
    <input type="hidden" name="elm_grid_et_grid_{$id}" value="">
    <label class="radio inline-block" for="elm_grid_et_grid_{$id}_1">
      <input type="radio" name="et_grid" value="Y" id="elm_grid_et_grid_{$id}_1" {if 'Y'|in_array:$ef_ids}checked="checked"{/if}>{__("yes")}<br>
    </label>
    <label class="radio inline-block" for="elm_grid_et_grid_{$id}_2">
      <input type="radio" name="et_grid" value="N" id="elm_grid_et_grid_{$id}_2" {if !('Y'|in_array:$ef_ids)}checked="checked"{/if}>{__("no")}<br>
    </label>
  </div>
</div>