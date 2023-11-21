{include file="common/letter_header.tpl"}

{__("hello")},<br><br>

{__("addons.sd_affiliate.new_affiliate_mail_text")}<br><br>

<table cellpadding="0" cellspacing="0" border="0">
<tr>
    <td valign="top">
        <table cellpadding="1" cellspacing="1" border="0" width="100%">
        <tr>
            <td colspan="2" class="form-title">{__("user_account_info")}<hr size="1" noshade></td>
        </tr>
        <tr>
            <td class="form-field-caption" nowrap>{__("email")}:&nbsp;</td>
            <td>{$user_data.email}</td>
        </tr>
        </table>
    </td>
    <td colspan="2">&nbsp;</td>
</tr>
<tr>
    <td colspan="3">&nbsp;</td>
</tr>
</table>

{include file="common/letter_footer.tpl" user_type='A'}