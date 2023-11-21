<div class="ty-qty-discount">
	<div class="ty-qty-discount__label">{__("text_qty_discounts")}:</div>
	<table class="ty-table ty-qty-discount__table">
		<thead>
			<tr>
				<th class="ty-qty-discount__td ty-table-disable-convertation">{__("quantity")}</th>
				<th class="ty-qty-discount__td ty-table-disable-convertation">{__("price")}</th>
			</tr>
		</thead>
		<tbody>
			{foreach from=$product.prices item="price"}
			<tr>
					<td class="ty-qty-discount__td ty-table-disable-convertation">{$price.lower_limit}+</td>
					<td class="ty-qty-discount__td et-qty-discount__price ty-table-disable-convertation">{include file="common/price.tpl" value=$price.price}</td>
				</tr>
				{/foreach}
		</tbody>
	</table>
</div>