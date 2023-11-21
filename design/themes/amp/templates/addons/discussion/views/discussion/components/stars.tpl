<div class="stars">
{section name="full_star" loop=$stars.full}
    <i class="fas fa-star icon-star"></i>
{/section}

{if $stars.part}
    <i class="fas fa-star-half-alt icon-star"></i>
{/if}

{section name="full_star" loop=$stars.empty}
    <i class="far fa-star icon-star"></i>
{/section}
</div>