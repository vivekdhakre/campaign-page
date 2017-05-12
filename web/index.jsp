<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${merchantName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="judds/css/style.css">
    <link rel="stylesheet" href="judds/mdl/material.min.css">
    <script type="text/javascript" src="judds/js/jquery-2.2.2.min.js"></script>
    <script type="text/javascript" src="judds/mdl/material.min.js"></script>


    <script>

        //        function changeCouponType(cid,ctype,uid,coupon){
        ////            if(ctype!=0){
        ////                $('#coupon-'+ctype).html('<img src="https://ads.uahoy.in/campaign/bq?cpn='+coupon+'&cid=' + cid + '&ctype=' + ctype + '&uid=' + uid + '" width="100%"/>');
        ////            }
        //
        //            $('.coupon-code').hide();
        //            $('#coupon-'+ctype).show();
        //            $('.save-btn').hide();
        //            $('#save-btn-'+ctype).show();
        //        }

        function downloadtextcoupon(value){

            var canvas = $('#textCanvas')[0];
            var context = canvas.getContext('2d');
            context.clearRect(0, 0, canvas.width, canvas.height);
            context.textAlign = "center";
            context.fillStyle = 'white';
            context.font = "bold 18pt Arial";
            var width = context.measureText(value).width;
            context.fillText(value, canvas.width * 0.5, 30);
            var a  = document.createElement('a');
            a.href = context.canvas.toDataURL("image/jpeg");
            a.download = 'coupon_'+value+'.jpeg';
            a.click();
        }



    </script>
</head>
<body>

<%

    String coupon = session.getAttribute("coupon").toString();
    if(coupon!=null && !"".equals(coupon.trim()) && !"null".equalsIgnoreCase(coupon.trim())){

%>

<div class="mdl-layout__container"><div class="mdl-layout mdl-js-layout mdl-layout--fixed-header is-upgraded is-small-screen" data-upgraded=",MaterialLayout">

    <!-- #### Header Starts Here #### -->
    <header class="brand-header mdl-layout__header is-casting-shadow">
        <div class="mdl-layout__header-row before-scroll">
            <span>${merchantName}</span>
        </div>
    </header>

    <main class="mdl-layout__content">

        <div class="container">
            <div class="offer-image">
                <div class="offer-container">
                    <img src="${imageUrl}">
                </div>
                <span class="offer-description">${campaignName}</span>
            </div>

        </div>



        <div class="mdl-tabs mdl-js-tabs mdl-js-ripple-effect">
            <div class="mdl-tabs__tab-bar">
                <a href="#coupon-0" class="mdl-tabs__tab is-active">Text</a>
                <a href="#coupon-1" class="mdl-tabs__tab">Barcode</a>
                <a href="#coupon-2" class="mdl-tabs__tab">QR Code</a>
            </div>
            <div class="mdl-tabs__panel is-active" id="coupon-0">
                <div class="coupon-code-container">
                    <div class="coupon-code-section">
                        <div class="code-head">
                            <h5>Show to avail Offer</h5>
                        </div>
                        <div class="code-section">
                            <h3 class="coupon-code">
                                ${coupon}
                                <canvas id='textCanvas' width="320px" height="50px" style="display:none;"></canvas>
                            </h3>
                        </div>
                        <a class="button save-btn" href="#" id="save-btn-0" onclick="downloadtextcoupon('${coupon}')" >Save Coupon</a>
                    </div>
                </div>
            </div>
            <div class="mdl-tabs__panel" id="coupon-1">
                <div class="coupon-code-container">
                    <div class="coupon-code-section">
                        <div class="code-head">
                            <h5>Show to avail Offer</h5>
                        </div>
                        <div class="code-section">
                            <h3 class="coupon-code" style="padding:5px 0;">
                                <img src="https://ads.uahoy.in/campaign/bq?ctype=1" width="100%"/>
                            </h3>
                        </div>
                        <a class="button save-btn" href="https://ads.uahoy.in/campaign/bar.png?ctype=1"  id="save-btn-1" download>Save Coupon</a>
                    </div>
                </div>
            </div>
            <div class="mdl-tabs__panel" id="coupon-2">
                <div class="coupon-code-container">
                    <div class="coupon-code-section">
                        <div class="code-head">
                            <h5>Show to avail Offer</h5>
                        </div>
                        <div class="code-section">
                            <h3 class="coupon-code">
                                <img src="https://ads.uahoy.in/campaign/qr.png?ctype=2" width="100%"/>
                            </h3>
                        </div>
                        <a class="button save-btn" href="https://ads.uahoy.in/campaign/qr.png?ctype=2"  id="save-btn-2"  download>Save Coupon</a>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>
</div>
<%}else{
    response.getWriter().println("Bad Request");
}%>
</body>
</html>