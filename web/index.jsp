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


        $( document ).ready(function() {

            var coupon = '${coupon}';
            var cid = '${cid}';


            if(coupon != null && coupon != ''){
                $('#coupon-div').show();
                $('#input-form-div').hide();
            }else{
                $('#coupon-div').hide();
                $('#input-form-div').show();
            }

            console.log("coupon: "+coupon);

            $('#submit').click(function(){

                $('.page-loader').css("display","flex");

                var msisdn = $('#inputMsisdn').val();

                if(msisdn==null || msisdn == ''){
                    $('#msisdn-error').text("Please Enter Msisdn");
                    $('#inputMsisdn').parent().addClass("is-invalid");
                    $('#inputMsisdn').focus();
                    $('.page-loader').hide();
                    return false;

                }else{
                    if(msisdn.length!=10 || msisdn<=6999999999){
                        $('#msisdn-error').text("Please Enter Msisdn");
                        $('#inputMsisdn').parent().addClass("is-invalid");
                        $('#inputMsisdn').focus();
                        $('.page-loader').hide();
                        return false;

                    }else{

                        $.ajax({
                            url: "sotp?cid="+cid+"$&m="+msisdn,
                            data: "",
                            type: 'POST',
                            success: function (resp) {
                                if(resp = "Success"){
                                    $('#inputMsisdn').attr("readonly","true");
                                    $("#submit").hide();
                                    $('#otp-div').show();
                                    $('#submit-otp').show();
                                    $('.page-loader').hide();
                                }else if(resp ="Fail"){

                                }else{
                                    $('.page-loader').hide();
                                    alert(resp);
                                }
                            },
                            error: function(e){
                                $('.page-loader').hide();

                                console.log(" Error to send OTP");
                            }
                        });
                    }
                }


            });

            $('#submit-otp').click(function(){

                $('.page-loader').css("display","flex");

                var msisdn = $('#inputMsisdn').val();
                var otp = $('#inputotp').val();

                if(otp==null || otp == '' || otp.length!=4){
                    $('.page-loader').hide();
                    $('#otp-error').text("Please Enter Valid otp");
                    $('#inputotp').parent().addClass("is-invalid");
                    $('#inputotp').focus();
                    return false;
                }else{

                    $.ajax({
                        url: "gc?m="+msisdn+"&o="+otp+"&cid=${cid}",
                        data: "",
                        type: 'POST',
                        success: function (resp) {

                            if(resp ==="read timed out" || resp === "connect timed out") {
                                $('#otp-error').text("Retry again, Taking time..");
                                $('#inputotp').parent().addClass("is-invalid");
                                $('#inputotp').focus();
                                $('.page-loader').hide();

                            }else if(resp == 401){
                                $('#inputMsisdn').show();
                                $('#submit').show();
                                $('#inputotp').val('');
                                $('#inputotp').hide();
                                $('#submit-otp').hide();
                                $('.page-loader').hide();
                                alert("Session Expired. Try again..");
                            }else if(resp == 403){
                                $('#otp-error').text("Please Enter Valid otp");
                                $('#inputotp').parent().addClass("is-invalid");
                                $('#inputotp').focus();
                                $('.page-loader').hide();

                            }else if(resp == 500){
                                $('#otp-error').text("Internal Error");
                                $('#inputotp').parent().addClass("is-invalid");
                                $('#inputotp').focus();
                                $('.page-loader').hide();

                            }else{
                                location.reload();
                            }
                        },
                        error: function(e){
                            $('.page-loader').hide();
                            console.log(" Error to send OTP");
                        }
                    });

                }
            });
        });

        function numeric(e) {
            e.value = e.value.replace(/[^0-9]+/g, '');
        }

    </script>
</head>
<body>
<%
    String cid = session.getAttribute("cid")!=null?session.getAttribute("cid").toString():null;
    if(cid !=null && cid.trim().matches("[0-9]+")&& Long.valueOf(cid)>0 ){
%>

<div class="mdl-layout__container">
    <div class="mdl-layout mdl-js-layout mdl-layout--fixed-header is-upgraded is-small-screen" data-upgraded=",MaterialLayout">

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

            <div class="mdl-tabs mdl-js-tabs mdl-js-ripple-effect" id="coupon-div">

                <div class="mdl-tabs__tab-bar">
                    <a href="#coupon-0" style="display:${coupon ne null && coupon.length() ne 10 ? 'none':'block'}" class="mdl-tabs__tab is-active">Text</a>
                    <a href="#coupon-1" style="display:${coupon ne null && coupon.length() ne 10 ? 'none':'block'}" class="mdl-tabs__tab">Barcode</a>
                    <a href="#coupon-2" style="display:${coupon ne null && coupon.length() ne 10 ? 'none':'block'}" class="mdl-tabs__tab">QR Code</a>
                    <a href="#tandc" class="mdl-tabs__tab">T&C</a>
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
                                    <img src="${serverPath}/bar/${coupon}.png?ctype=1" width="100%"/>
                                </h3>
                            </div>
                            <a class="button save-btn" href="${serverPath}/bar/${coupon}.png?ctype=1" id="save-btn-1"
                               download>Save Coupon</a>
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
                                    <img src="${serverPath}/qr/${coupon}.png?ctype=2" width="100%"/>
                                </h3>
                            </div>
                            <a class="button save-btn" href="${serverPath}/qr/${coupon}.png?ctype=2" id="save-btn-2"
                               download>Save Coupon</a>
                        </div>
                    </div>
                </div>

                <div class="mdl-tabs__panel" id="tandc">
                    <ul>
                        <li>Show Coupon Code (wherever provided) to avail the Offer</li>
                        <li>Can't be combined with any other existing offers/ promotions</li>
                        <li>Only one Coupon applies for a Mobile Number /Registered User</li>
                        <li>Coupon Code is Non Transferable and can be consumed once only</li>
                        <li>Deal provider reserves the rights to Alter/Stop the Offer at any time. You are advised to Kindly Call & Check the outlet before availing the coupon.</li>
                        <li>Ahoy can't be held responsible, if the Coupon can't be availed because of any reason.</li>
                        <li>Coupon can be redeemed at any Big Bazaar, Spencer</li>
                    </ul>
                </div>
            </div>

            <div class="mdl-grid" id="input-form-div">
                <div class="mdl-cell mdl-cell--12-col mdl-shadow--2dp">
                    <div class="mdl-grid">
                        <div class="mdl-cell mdl-cell--12-col">
                            <div class="mdl-textfield mdl-textfield--full-width mdl-js-textfield mdl-textfield--floating-label">
                                <input class="mdl-textfield__input" type="text" id="inputMsisdn" onkeyup="numeric(this)">
                                <label class="mdl-textfield__label" for="inputMsisdn">Enter Mobile Number</label>
                                <span class="mdl-textfield__error" id="msisdn-error">Input is not a number!</span>
                            </div>

                            <div class="mdl-textfield mdl-textfield--full-width mdl-js-textfield mdl-textfield--floating-label" id="otp-div" style="display:none;">
                                <input class="mdl-textfield__input" type="text" id="inputotp" onkeyup="numeric(this)">
                                <label class="mdl-textfield__label" for="inputotp">Enter Otp</label>
                                <span class="mdl-textfield__error" id="otp-error">Input is not a number!</span>
                            </div>

                            <div class="mdl-textfield--full-width mdl-typography--text-center">
                                <button type="button" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect" id="submit-otp" style="display:none;">Get Coupon</button>
                                <button type="button" class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect" id="submit" >Send Otp</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<%
    }else{
        out.println("Session Expired or invalid");
    }
%>

</body>
</html>