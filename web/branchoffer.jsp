<!DOCTYPE html>

<html lang="en">

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<head>
    <meta charset="UTF-8">
    <title>${merchantName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/materialize.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/js/jquery-2.2.2.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/materialize.js"></script>

</head>
<body>
<c:choose>
    <c:when test="${mid ne null}">
        <div class="loader-container">
            <div class="loader-wrapper">
                <div class="preloader-wrapper small active">
                    <div class="spinner-layer spinner-green-only">
                        <div class="circle-clipper left">
                            <div class="circle"></div>
                        </div>
                        <div class="gap-patch">
                            <div class="circle"></div>
                        </div>
                        <div class="circle-clipper right">
                            <div class="circle"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="parallax-container">
            <div class="parallax"><img src="${imageUrl}"></div>
            <h4 class="deal-title">${campaignName}</h4>
        </div>

        <div class="card offer-card">
            <div class="card-image waves-effect waves-block waves-light">
                <span class="card-title medium">I am a very simple card. I am good at containing small bits of information</span>
            </div>
            <div class="card-tabs">
                <ul class="tabs tabs-fixed-width">
                    <li class="tab"><a class="active" href="#Coupon">Coupon</a></li>
                    <li class="tab"><a href="#Location">Location</a></li>
                    <li class="tab"><a href="#tandc">T &amp; C</a></li>
                </ul>
            </div>

            <div class="card-content white lighten-4">
                <div id="Coupon">
                    <div class="row">
                        <c:choose>
                            <c:when test="${coupon ne null}">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(coupon, 'expired')}">
                                        <div class="col s12 center">
                                            <div class="coupon-container coupon-expired">
                                                <input type="text" id="textCouponCode" hidden value="${coupon}">
                                                <canvas class="text-coupon coupon active" width="100%" height="50"
                                                        id="textcode">Sorry, no canvas available
                                                </canvas>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="input-field col s12">
                                            <select id="couponTypeSelect" onchange="selectCouponType(this)">
                                                <option value="textcode" selected>Text</option>
                                                <option value="barcode">Barcode</option>
                                                <option value="qrcode">QR Code</option>
                                            </select>
                                            <label class="teal-text">Select Your Coupon Type</label>
                                        </div>

                                        <div class="col s12 center">
                                            <div class="coupon-container">
                                                <input type="text" id="textCouponCode" hidden value="${coupon}">
                                                <!--<h5  id="textcode">AH00000000</h3>-->
                                                <canvas class="text-coupon coupon active" width="100%" height="50"
                                                        id="textcode">Sorry, no canvas available
                                                </canvas>
                                                <img class="coupon" id="barcode" src="" alt="">
                                                <img class="coupon" id="qrcode" src="" alt="">
                                            </div>
                                        </div>
                                        <div class="input-field col s6 center">
                                            <a href="#" class="btn waves-effect waves-light size-12"
                                               data-target="modal1" id="getSms">Get Coupon</a>
                                        </div>
                                        <div class="input-field col s6 center">
                                            <a href="#" class="btn waves-effect waves-light size-12" id="saveCoupon"
                                               download="image.png">Save Coupon</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <script>
                                    var e = document.getElementById("couponTypeSelect");
                                    var couponType = "${fn:containsIgnoreCase(coupon, 'expired')}" ? 'textcode' : e.options[e.selectedIndex].value;
                                    var stringTitle = document.getElementById('textCouponCode').value;

                                    const fileName = stringTitle + '.png';
                                    const anchor = document.querySelector('#saveCoupon');

                                    var barcodeAPI = "${serverPath}/bar/${coupon}.png?ctype=1";
                                    var qrAPI = "${serverPath}/qr/${coupon}.png?ctype=2";

                                    if (${!fn:containsIgnoreCase(coupon, 'expired')}) {

                                        document.getElementById("barcode").setAttribute('src', barcodeAPI);
                                        document.getElementById("qrcode").setAttribute('src', qrAPI);

                                        anchor.addEventListener('click', onClickAnchor);
                                    }


                                    var canvas = document.getElementById('textcode'),
                                        ctx = canvas.getContext('2d');
                                    var c = $('#textcode');
                                    var container = $(c).parent();
                                    // text code to canvas


                                    // save coupon event handler
                                    function onClickAnchor(e) {
                                        if (couponType === 'textcode') {
                                            if (window.navigator.msSaveBlob) {
                                                window.navigator.msSaveBlob(canvas.msToBlob(), fileName);
                                                e.preventDefault();
                                            } else {
                                                anchor.setAttribute('download', fileName);
                                                anchor.setAttribute('href', canvas.toDataURL());
                                            }
                                        } else if (couponType === 'barcode') {
                                            anchor.setAttribute('download', fileName);
                                            anchor.setAttribute('href', barcodeAPI);
                                        } else if (couponType === 'qrcode') {
                                            anchor.setAttribute('download', fileName);
                                            anchor.setAttribute('href', qrAPI);
                                        }
                                    }

                                    function createCanvas() {
                                        // rendring canvas
                                        ctx.fillStyle = '#ffffff';
                                        ctx.fillRect(0, 0, canvas.width, canvas.height);
                                        ctx.fillStyle = '#000';
                                        ctx.font = '30px "Roboto", sans-serif';
                                        ctx.textAlign = 'center';
                                        ctx.textBaseline = 'middle';
                                        var text_title = stringTitle;
                                        ctx.fillText(stringTitle, canvas.width / 2, canvas.height / 2);
                                    }

                                    // getting window is resized?
                                    $(window).resize(respondCanvas);
                                    // canavas resizing handler on window resize
                                    function respondCanvas() {
                                        c.attr('width', $(container).width()); //max width
                                        c.attr('height', $(container).height()); //max height
                                        //Call a function to redraw other content (texts, images etc)
                                        createCanvas();
                                    }

                                    //Initial call
                                    respondCanvas();

                                    function sendSMS() {

                                        var msisdn = $('#msisdn').val();
                                        var msg = $('#msg').val();

                                        $('.errorTxt1').hide();
                                        if (msisdn == '') {
                                            $('.errorTxt1').show();
                                            $('#msisdn').focus();
                                            return false;
                                        } else if (msisdn.length != 10) {
                                            $('.errorTxt1').show();
                                            $('#msisdn').focus();
                                            return false;
                                        } else {
                                            $('.loader-container').addClass("active");
                                            $.ajax({
                                                url: "${serverPath}/sendcmobile?m=" + msisdn + "&msg=" + escape(msg),
                                                data: "",
                                                type: 'POST',
                                                success: function (response) {
                                                    Materialize.toast(response, 4000);
                                                    $('#msisdn').val();
                                                    $('.loader-container').removeClass("active");
                                                    $('.modal').modal('close');
                                                },
                                                error: function (e) {
                                                    console.log(" Error");
                                                    $('.loader-container').removeClass("active");
                                                }
                                            });
                                        }

                                    }

                                    function selectCouponType(el) {
                                        $('.coupon').removeClass('active');
                                        couponType = e.value;
                                        $('#' + el.value).addClass('active');
                                    }
                                    // console.log(couponType);


                                </script>


                            </c:when>
                            <c:otherwise>
                                <div class="row">
                                    <form class="col s12" autocomplete="off">
                                        <p>Enter mobile number get coupon code</p>
                                        <div class="input-field">
                                            <input id="inputMsisdn" type="text" autocomplete="off">
                                            <label for="inputMsisdn" data-error="wrong" data-success="right">Mobile
                                                Number</label>
                                            <div class="error-div" id="error_msisdn" style="display:none;color:red;">
                                                Enter Valid Mobile No
                                            </div>
                                        </div>

                                        <div class="input-field otp-div" style="display: none;">
                                            <input id="inputotp" type="password" autocomplete="off">
                                            <label for="inputotp" data-error="wrong" data-success="right">OTP</label>
                                            <div class="error-div" id="error_otp" style="display:none;color:red;">Enter
                                                Valid Mobile No
                                            </div>
                                        </div>
                                        <div class="input-field" style="width: 100%;">
                                            <button id="submit" type="button" style="width: 100%;"
                                                    class="modal-action waves-effect teal white-text waves-green btn">
                                                Send OTP
                                            </button>

                                            <button id="submit-otp" type="button" style="width: 100%;display:none;"
                                                    class="modal-action waves-effect teal white-text waves-green btn otp-div">
                                                Get Coupon
                                            </button>

                                        </div>
                                    </form>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div id="Location">
                    <div class="row">
                        <div class="input-field col s12">
                            <select id="cityTypeSelect" onchange="selectCityType(this)">
                                <option value="">--Please-Select--</option>
                            </select>
                            <label class="teal-text">Select Your City Below :</label>
                        </div>
                        <div class="col s12 city-list" style="display: none;">
                            <span class="city-list-title">Kindly visit the below location to apply</span>
                            <ul class="collection" id="location-ul">


                            </ul>
                        </div>
                    </div>
                </div>
                <div id="tandc">
                    <div class="row">
                        <ul class="col s12 collection condition">
                            <li class="collection-item">Show Coupon Code (wherever provided) to avail the Offer</li>
                            <li class="collection-item">Can't be combined with any other existing offers/ promotions
                            </li>
                            <li class="collection-item">Only one Coupon applies for a Mobile Number /Registered User
                            </li>
                            <li class="collection-item">Coupon Code is Non Transferable and can be consumed once only
                            </li>
                            <li class="collection-item">Deal provider reserves the rights to Alter/Stop the Offer at any
                                time. You are advised to Kindly Call &amp; Check the outlet before availing the coupon.
                            </li>
                            <li class="collection-item">Ahoy can't be held responsible, if the Coupon can't be availed
                                because of any reason.
                            </li>
                            <li class="collection-item">Coupon can be redeemed at any Big Bazaar, Spencer</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>


        <!--modal box-->

        <div id="modal1" class="modal">
            <div class="modal-content">
                <h4 class="size-16">Get Coupon in SMS</h4>
                <p>Please enter your mobile number</p>
                <div class="row">
                    <form class="col s12">
                        <div class="input-field">
                            <input id="msisdn" type="text" onkeyup="numeric(this)">
                            <label for="msisdn" data-error="wrong" data-success="right">Mobile Number</label>
                            <div class="errorTxt1" style="display:none;color:red;">Enter Valid Mobile No</div>
                            <input id="msg" type="text" value="${campaignName}. Use Coupon ${coupon}. T&C apply" hidden>

                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <a href="#!" class="modal-action waves-effect waves-green btn-flat" onclick="sendSMS()">Send</a>
            </div>
        </div>
        <script>
            $(document).ready(function () {

                $('.parallax').parallax();
                $('select').material_select();
                $('.modal').modal();

                if (!navigator.geolocation) {
                    $('.loader-container').addClass("active");
                    getCity();
                } else {
                    function success(position) {
                        var latitude = position.coords.latitude;
                        var longitude = position.coords.longitude;

                        $('.loader-container').addClass("active");
                        getBranches(latitude, longitude, null, function (res) {
                            if (res) {
                                $('#cityTypeSelect').parent().hide();
                            } else {
                                $('.loader-container').addClass("active");
                                getCity();
                            }
                        })

                    }

                    function error() {
                        // console.log("Unable to retrieve your location");
                        $('.loader-container').addClass("active");
                        getCity();

                    }

                    navigator.geolocation.getCurrentPosition(success, error);
                }


                var cid = '${cid}';

                $('#submit').click(function () {

                    $('.loader-container').css("display", "flex");
                    $('.error-div').hide();

                    var msisdn = $('#inputMsisdn').val();

                    if (msisdn == null || msisdn == '') {
                        $('#error_msisdn').text("Please Enter Msisdn");
                        $('#error_msisdn').show();
                        $('#inputMsisdn').focus();
                        $('.loader-container').hide();
                        return false;

                    } else {
                        if (msisdn.length != 10 || msisdn <= 6999999999) {
                            $('#error_msisdn').text("Please Enter Msisdn");
                            $('#error_msisdn').show();
                            $('#inputMsisdn').focus();
                            $('.loader-container').hide();
                            return false;

                        } else {

                            $.ajax({
                                url: "${pageContext.request.contextPath}/sotp?cid=" + cid + "$&m=" + msisdn,
                                data: "",
                                type: 'POST',
                                success: function (resp) {
                                    if (resp = "Success") {
                                        $('#inputMsisdn').attr("readonly", "true");
                                        $("#submit").hide();
                                        $('.otp-div').show();
                                        $('#submit-otp').show();
                                        $('.loader-container').hide();
                                    } else if (resp = "Fail") {

                                    } else {
                                        $('.loader-container').hide();
                                        alert(resp);
                                    }
                                },
                                error: function (e) {
                                    $('.loader-container').hide();

                                    console.log(" Error to send OTP");
                                }
                            });
                        }
                    }


                });

                $('#submit-otp').click(function () {

                    $('.loader-container').css("display", "flex");
                    $('.error-div').hide();

                    var msisdn = $('#inputMsisdn').val();
                    var otp = $('#inputotp').val();

                    if (otp == null || otp == '' || otp.length != 4) {
                        $('.loader-container').hide();
                        $('#error_otp').text("Please Enter Valid otp");
                        $('#error_otp').show();
                        $('#inputotp').focus();
                        return false;
                    } else {

                        $.ajax({
                            url: "${pageContext.request.contextPath}/gc?m=" + msisdn + "&o=" + otp + "&cid=${cid}",
                            data: "",
                            type: 'POST',
                            success: function (resp) {

                                if (resp === "read timed out" || resp === "connect timed out") {
                                    $('#error_otp').text("Retry again, Taking time..");
                                    $('#error_otp').show();
                                    $('#inputotp').focus();
                                    $('.loader-container').hide();

                                } else if (resp == 401) {
                                    $('#inputMsisdn').show();
                                    $('#submit').show();
                                    $('#inputotp').val('');
                                    $('#inputotp').hide();
                                    $('#submit-otp').hide();
                                    $('.loader-container').hide();
                                    alert("Session Expired. Try again..");
                                } else if (resp == 403) {
                                    $('#error_otp').text("Please Enter Valid otp");
                                    $('#error_otp').show();
                                    $('#inputotp').focus();
                                    $('.loader-container').hide();

                                } else if (resp == 500) {
                                    $$('#error_otp').text("Internal Error");
                                    $('#error_otp').show();
                                    $('#inputotp').focus();
                                    $('.loader-container').hide();

                                } else {
                                    location.reload();
                                }
                            },
                            error: function (e) {
                                $('.loader-container').hide();
                                console.log(" Error to send OTP");
                            }
                        });

                    }
                });
            });

            function selectCityType(ele) {
                var cityName = ele.value;
                getBranches(null, null, cityName, function (res) {
                    // console.log(res);
                })
            }
            //###### input restriction-allow only numeric ######
            function numeric(e) {
                e.value = e.value.replace(/[^0-9]+/g, '');
            }

            function getCity() {
                $.ajax({
                    url: "${serverPath}/marketeer/fetchcities?mid=${mid}&cid=${cid}",
                    data: "",
                    type: 'POST',
                    success: function (response) {
                        var jsonData = JSON.parse(response);
                        if (jsonData != null && jsonData.length > 0) {
                            for (var i = 0; i < jsonData.length; i++) {
                                console.log(jsonData[i]);
                                $('#cityTypeSelect').append('<option value="' + jsonData[i] + '">' + jsonData[i] + '</option>')
                            }
                            $('select').material_select();
                        }
                        $('#city-div').show();
                        $('.loader-container').removeClass("active");
                    },
                    error: function (e) {
                        console.log(" Error");
                        $('.loader-container').removeClass("active");
                    }
                });
            }

            function getBranches(latitude, longitude, cityName, callback) {

                $.ajax({
                    url: "${serverPath}/marketeer/fetchbranches?mid=${mid}&lat=" + latitude + "&lng=" + longitude + "&city=" + cityName + "&cid=${cid}",
                    data: "",
                    type: 'POST',
                    success: function (response) {
                        var jsonData = JSON.parse(response);

                        if(jsonData !=null && jsonData.length>0) {
                            $('#location-ul').empty();
                            for (var i = 0; i < jsonData.length; i++) {
                                var a = jsonData[i];
                                $('#location-ul').append('<li class="collection-item avatar"><i class="material-icons circle">store</i><span class="title grey-text text-darken-1">' + a.branchname + '</span><p class="grey-text">' + a.address + ', ' + a.city + ', ' + a.state + ', ' + a.pincode + '</p></li>');
                            }
                            $('.city-list').show();
                            callback(true);
                        } else {
                            callback(false);
                        }

                        $('.loader-container').removeClass("active");
                    },
                    error: function(e){
                        console.log(" Error ");
                        $('.loader-container').removeClass("active");
                        callback(false);
                    }
                });
            }

        </script>
    </c:when>
    <c:otherwise>
        <c:set var="req" value="${pageContext.request}"/>
        <c:set var="dateParts" value="${fn:split(req.requestURI, '/')}"/>
        <c:choose>
            <c:when test="${fn:length(dateParts) eq 3}">
                <c:set var="baseURL" value="${fn:replace(req.requestURL, req.requestURI, '')}"/>
                <c:set var="finalUrl"
                       value="${baseURL}${pageContext.request.contextPath}/cl/${dateParts[fn:length(dateParts)-1]}"/>
                <c:redirect url="${finalUrl}"/>
            </c:when>
            <c:otherwise>
                Bad Request
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
</body>
</html>