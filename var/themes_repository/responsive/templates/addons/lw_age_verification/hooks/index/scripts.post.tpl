<script>
	function setCookie(name,value,days) {
        var expires = "";
        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days*24*60*60*1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "")  + expires + "; path=/";
    }
    function getCookie(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    }
    function eraseCookie(name) {   
        document.cookie = name +'=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    }

    if (getCookie('lw_av_overage')) {
        $(".lw_age_verification_popup").css('display','none');
        $('body').css('overflow', 'inherit');
    }else{
        $(".lw_age_verification_popup").css('display','block');
        $('body').css('overflow', 'hidden');
    }

    $("#lw_av_underage").click(function() {
        $(".lw_av_check_verification").fadeOut(1000);
        $(".lw_av_verification_failed").fadeIn(1000);
    });

    $("#lw_av_overage").click(function() {
        setCookie('lw_av_overage', true, 7);

        $(".lw_age_verification_popup").css('display','none');
        $('body').css('overflow', 'inherit');
    });
</script>