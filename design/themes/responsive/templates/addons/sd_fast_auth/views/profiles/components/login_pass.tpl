{if $runtime.mode == "add" && $settings.General.quick_registration == "Y"}
    <div id="login_pass" class="js-login-pass-reg{if !$show_social} hidden{/if}">
        <div class="ty-account">

            {if $show_social && is_array($providers_list) && $login_position == "bottom"}
                {include "addons/sd_fast_auth/views/auth/components/social_login.tpl"
                    btn=true
                    show_social=$show_social
                    login_position=$login_position
                }
                <p class="ty-center">
                    {__("or_register_now")}:
                </p>
            {/if}

            {if $style == "checkout"}
                <div class="ty-checkout-login-form">
                    {include "common/subheader.tpl"
                        title=__("returning_customer")
                    }
            {/if}

            <form name="profiles_register_form" action="{""|fn_url}" method="post">
                {include "views/profiles/components/profile_fields.tpl"
                    section="C"
                    nothing_extra="Y"
                }
                {include "views/profiles/components/profiles_account.tpl"
                    nothing_extra="Y"
                    location="checkout"
                }

                {if $btn}
                    <p class="ty-center">
                        {__("or")}:
                    </p>
                    <div class="js-show-social-login-reg ty-center sd-show-social-login">
                        <a rel="nofollow" class="ty-btn ty-btn__secondary ty-btn__email sd-fast-auth">
                            <i class="ty-icon-empty"></i>
                            {__("social_login_btn")}
                        </a>
                    </div>
                {elseif !$show_social}
                    <div class="js-show-social-login-reg ty-center sd-show-social-login">
                        <a rel="nofollow">{__("fast_auth_auth.social_login")}</a>
                    </div>
                {/if}

                {if $show_social && is_array($providers_list) && $login_position == "top"}
                    {include "addons/sd_fast_auth/views/auth/components/social_login.tpl"
                        btn=true
                        show_social=$show_social
                        login_position=$login_position
                    }
                {/if}

                {include "common/image_verification.tpl"
                    option="login"
                    align="left"
                }

                {if $style == "checkout"}
                    </div>
                {/if}

                {include "common/image_verification.tpl"
                    option="register"
                    align="left"
                    assign="image_verification"
                }

                {if $image_verification}
                    <div class="ty-control-group">
                        {$image_verification nofilter}
                    </div>
                {/if}

                {hook name="profiles:account_update"}{/hook}

                <div class="ty-profile-field__buttons buttons-container">
                    {include "buttons/register_profile.tpl"
                        but_name="dispatch[profiles.update]"
                    }
                </div>
            </form>
        </div>
        {capture "mainbox_title"}
            {__("register_new_account")}
        {/capture}
    </div>
{else}
    <div id="login_pass" class="js-login-pass-reg{if !$show_social} hidden{/if}">
        {capture "tabsbox"}
            <div class="ty-profile-field ty-account form-wrap" id="content_general">
                {if $show_social && is_array($providers_list) && $login_position == "bottom"}
                    {include "addons/sd_fast_auth/views/auth/components/social_login.tpl"
                        btn=true
                        show_social=$show_social
                        login_position=$login_position
                    }
                    <p class="ty-center">
                        {__("or_register_now")}:
                    </p>
                {/if}

                <form name="profile_form" action="{""|fn_url}" method="post">
                    <input type="hidden"
                        id="selected_section"
                        value="general"
                        name="selected_section"
                    />
                    <input type="hidden"
                        id="default_card_id"
                        value=""
                        name="default_cc"
                    />
                    <input type="hidden"
                        name="profile_id"
                        value="{$user_data.profile_id}"
                    />

                    {capture "group"}
                        {include "views/profiles/components/profiles_account.tpl"}
                        {include "views/profiles/components/profile_fields.tpl"
                            section="C"
                            title=__("contact_information")
                        }

                        {if $profile_fields.B || $profile_fields.S}
                            {if $settings.General.user_multiple_profiles == "Y"
                                && $runtime.mode == "update"
                            }
                                <p>{__("text_multiprofile_notice")}</p>
                                {include "views/profiles/components/multiple_profiles.tpl"
                                    profile_id=$user_data.profile_id
                                }
                            {/if}

                            {if $settings.Checkout.address_position == "billing_first"}
                                {$first_section = "B"}
                                {$first_section_text = __("billing_address")}
                                {$sec_section = "S"}
                                {$sec_section_text = __("shipping_address")}
                                {$body_id = "sa"}
                            {else}
                                {$first_section = "S"}
                                {$first_section_text = __("shipping_address")}
                                {$sec_section = "B"}
                                {$sec_section_text = __("billing_address")}
                                {$body_id = "ba"}
                            {/if}

                            {include "views/profiles/components/profile_fields.tpl"
                                section=$first_section
                                body_id=""
                                ship_to_another=true
                                title=$first_section_text
                            }
                            {include "views/profiles/components/profile_fields.tpl"
                                section=$sec_section
                                body_id=$body_id
                                ship_to_another=true
                                title=$sec_section_text
                                address_flag=$profile_fields|fn_compare_shipping_billing
                                ship_to_another=$ship_to_another
                            }
                        {/if}

                        {if $btn}
                            <p class="ty-center">
                                {__("fast_auth_auth.social_login")}
                            </p>
                            <div class="js-show-social-login-reg ty-center sd-show-social-login">
                                <a rel="nofollow" class="ty-btn ty-btn__secondary ty-btn__email sd-fast-auth">
                                    <i class="ty-icon-empty"></i>
                                    {__("social_login_btn")}
                                </a>
                            </div>
                        {elseif !$show_social}
                            <div class="js-show-social-login-reg ty-center sd-show-social-login">
                                <a rel="nofollow">
                                    {__("fast_auth_auth.social_login")}
                                </a>
                            </div>
                        {/if}

                        {if $show_social && is_array($providers_list) && $login_position == "top"}
                            {include "addons/sd_fast_auth/views/auth/components/social_login.tpl"
                                btn=true
                                show_social=$show_social
                                login_position=$login_position
                            }
                        {/if}

                        {hook name="profiles:account_update"}{/hook}

                        {include "common/image_verification.tpl"
                            option="register"
                            align="center"
                        }
                    {/capture}
                    {$smarty.capture.group nofilter}

                    <div class="ty-profile-field__buttons buttons-container">
                        {if $runtime.mode == "add"}
                            {include "buttons/register_profile.tpl"
                                but_name="dispatch[profiles.update]"
                                but_id="save_profile_but"
                            }
                        {else}
                            {include "buttons/save.tpl"
                                but_name="dispatch[profiles.update]"
                                but_meta="ty-btn__secondary"
                                but_id="save_profile_but"
                            }
                            <input type="reset"
                                class="ty-profile-field__reset ty-btn ty-btn__tertiary"
                                name="reset"
                                value="{__("revert")}"
                                id="shipping_address_reset"
                            />

                            <script>
                                (function(_, $) {
                                    var address_switch = $('input:radio:checked', '.ty-address-switch');
                                    $('#shipping_address_reset').on('click', function(e) {
                                        setTimeout(function() {
                                            address_switch.click();
                                        }, 50);
                                    });
                                }(Tygh, Tygh.$));
                            </script>

                            {if $settings.General.show_delete_account_button == "Y" && $user_data.user_type == "C"}
                                {capture "delete_my_account"}
                                    {include "views/profiles/components/user_action_popup.tpl"
                                        action="anonymization_request"
                                        description=__("delete_my_account_description")
                                        title=__("delete_my_account")
                                        id=$block.block_id
                                    }
                                {/capture}

                                {include "common/popupbox.tpl"
                                    link_text=__("delete_my_account")
                                    title=__("delete_my_account")
                                    id="anonymization_request_dialog_`$block.block_id`"
                                    content=$smarty.capture.delete_my_account
                                    link_meta="ty-ml-s"
                                }
                            {/if}
                        {/if}
                    </div>
                </form>
            </div>

            {capture "additional_tabs"}
                {if $runtime.mode == "update"}
                    {if !"ULTIMATE:FREE"|fn_allowed_for && $usergroups && !$user_data|fn_check_user_type_admin_area}
                        <div id="content_usergroups">
                            <table class="ty-table">
                                <tr>
                                    <th style="width: 30%">
                                        {__("usergroup")}
                                    </th>
                                    <th style="width: 30%">
                                        {__("status")}
                                    </th>

                                    {if $settings.General.allow_usergroup_signup == "Y"}
                                        <th style="width: 40%">
                                            {__("action")}
                                        </th>
                                    {/if}
                                </tr>
                                {foreach $usergroups as $usergroup}
                                    {if $user_data.usergroups[$usergroup.usergroup_id]}
                                        {$ug_status = $user_data.usergroups[$usergroup.usergroup_id].status}
                                    {else}
                                        {$ug_status = "F"}
                                    {/if}
                                    {if $settings.General.allow_usergroup_signup == "Y"
                                        || $settings.General.allow_usergroup_signup != "Y"
                                        && $ug_status == "A"
                                    }
                                        <tr>
                                            <td>
                                                {$usergroup.usergroup}
                                            </td>
                                            <td class="ty-center">
                                                {if $ug_status == "A"}
                                                    {__("active")}
                                                    {$_link_text = __("remove")}
                                                    {$_req_type = "cancel"}
                                                {elseif $ug_status == "F"}
                                                    {__("available")}
                                                    {$_link_text = __("join")}
                                                    {$_req_type = "join"}
                                                {elseif $ug_status == "D"}
                                                    {__("declined")}
                                                    {$_link_text = __("join")}
                                                    {$_req_type = "join"}
                                                {elseif $ug_status == "P"}
                                                    {__("pending")}
                                                    {$_link_text = __("cancel")}
                                                    {$_req_type = "cancel"}
                                                {/if}
                                            </td>
                                            {if $settings.General.allow_usergroup_signup == "Y"}
                                                <td>
                                                    <a class="cm-ajax"
                                                        href="{"profiles.usergroups?usergroup_id={$usergroup.usergroup_id}&type={$_req_type}"|fn_url}"
                                                        data-ca-target-id="content_usergroups"
                                                    >
                                                        {$_link_text}
                                                    </a>
                                                </td>
                                            {/if}
                                        </tr>
                                    {/if}
                                {/foreach}
                            </table>
                        <!--content_usergroups--></div>
                    {/if}

                    {hook name="profiles:tabs"}{/hook}
                {/if}
            {/capture}

            {$smarty.capture.additional_tabs nofilter}
        {/capture}

        {if $smarty.capture.additional_tabs|trim != ""}
            {include "common/tabsbox.tpl"
                content=$smarty.capture.tabsbox
                active_tab=$smarty.request.selected_section
                track=true
            }
        {else}
            {$smarty.capture.tabsbox nofilter}
        {/if}

        {capture "mainbox_title"}
            {__("profile_details")}
        {/capture}
    </div>
{/if}
