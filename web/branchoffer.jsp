<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${merchantName}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
    <link rel="stylesheet" href="hsbc/mdl/material.min.css">
    <link rel="stylesheet" href="hsbc/css/style.css" media="screen">
    <script type="text/javascript" src="hsbc/js/jquery-2.2.2.min.js"></script>
    <script type="text/javascript" src="hsbc/mdl/material.min.js"></script>
    <script src="hsbc/js/getmdl-select.min.js"></script>

    <script>

        $(document).ready(function(){

            if (!navigator.geolocation){
                console.log("Geolocation is not supported by your browser");
                $('.page-loader').css("display","flex");
                $.ajax({
                    url: "https://ads.uahoy.in/campaign/marketeer/fetchcities?mid=${mid}&cid=${cid}",
                    data: "",
                    type: 'POST',
                    success: function (response) {
                        var jsonData = JSON.parse(response);
                        if(jsonData !=null && jsonData.length>0) {
                            $('#select-ul').empty();
                            for (var i = 0; i < jsonData.length; i++) {
                                $('#select-ul').append('<li class="mdl-menu__item" data-val="'+jsonData[i]+'">'+jsonData[i]+'</li>')
                            }
                            getmdlSelect.init("#cityselector");
                        }
                        $('.page-loader').css("display","none");
                    },
                    error: function(e){
                        console.log("Error");
                        $('.page-loader').css("display","none");
                    }
                });
            }else{
                function success(position) {
                    var latitude  = position.coords.latitude;
                    var longitude = position.coords.longitude;

                    longitude = position.coords.longitude;

                    $('.page-loader').css("display","flex");
                    $.ajax({
                        url: "https://ads.uahoy.in/campaign/marketeer/fetchbranches?mid=${mid}&lat="+latitude+"&lng="+longitude+"&cid=${cid}",
                        data: "",
                        type: 'POST',
                        success: function (response) {
                            var jsonData = JSON.parse(response);

                            if(jsonData !=null && jsonData.length>0) {
                                $('#Locations-div').empty();
                                for (var i = 0; i < jsonData.length; i++) {
                                    if(jsonData.length==1){
                                        $('#Locations-div').append('<span class="address-select lite-grey"><div class="address-option">' + jsonData[i].address + ', ' + jsonData[i].city + ', ' + jsonData[i].state + ' ' + jsonData[i].pincode + '</div></span>');
                                    }else {
                                        $('#Locations-div').append('<span class="address-select lite-grey"><span><i class="material-icons">business</i></span><div class="address-option">' + jsonData[i].address + ', ' + jsonData[i].city + ', ' + jsonData[i].state + ' ' + jsonData[i].pincode + '</div></span>');
                                    }
                                }
                                $('#bank-address-div').show();
                            }else{
                                //$('.page-loader').css("display","flex");
                                $.ajax({
                                    url: "https://ads.uahoy.in/campaign/marketeer/fetchcities?mid=${mid}&cid=${cid}",
                                    data: "",
                                    type: 'POST',
                                    success: function (response) {
                                        var jsonData = JSON.parse(response);
                                        if(jsonData !=null && jsonData.length>0) {
                                            $('#select-ul').empty();
                                            for (var i = 0; i < jsonData.length; i++) {
                                                $('#select-ul').append('<li class="mdl-menu__item" data-val="'+jsonData[i]+'" onClick="findLoc(1)">'+jsonData[i]+'</li>')
                                            }
                                            getmdlSelect.init("#cityselector");
                                        }
                                        $('#city-div').show();
                                        $('.page-loader').css("display","none");
                                    },
                                    error: function(e){
                                        console.log(" Error to fetch cities");
                                    }
                                });
                            }

                            $('.page-loader').css("display","none");
                        },
                        error: function(e){
                            $('.page-loader').css("display","none");
                            console.log(" Error to send OTP"+JSON.stringify(e));
                        }
                    });
                }
                function error() {
                    console.log("Unable to retrieve your location");
                    $('.page-loader').css("display","flex");
                    $.ajax({
                        url: "https://ads.uahoy.in/campaign/marketeer/fetchcities?mid=${mid}&cid=${cid}",
                        data: "",
                        type: 'POST',
                        success: function (response) {
                            var jsonData = JSON.parse(response);
                            if(jsonData !=null && jsonData.length>0) {
                                $('#select-ul').empty();
                                for (var i = 0; i < jsonData.length; i++) {
                                    console.log(jsonData[i]);
                                    $('#select-ul').append('<li class="mdl-menu__item" data-val="'+jsonData[i]+'">'+jsonData[i]+'</li>')
                                }
                                getmdlSelect.init("#cityselector");
                            }
                            $('#city-div').show();
                            $('.page-loader').css("display","none");
                        },
                        error: function(e){
                            console.log(" Error");
                            $('.page-loader').css("display","none");
                        }
                    });
                }
                navigator.geolocation.getCurrentPosition(success, error);
            }

            $('ul#select-ul').on('click', 'li', function() {
                $('.mdl-menu__container').removeClass('is-visible');

                var cityName = $('#city-selector').val();
                $('.page-loader').css("display","flex");
                $.ajax({
                    url: "https://ads.uahoy.in/campaign/marketeer/fetchbranches?mid=${mid}&city="+cityName+"&cid=${cid}",
                    data: "",
                    type: 'POST',
                    success: function (response) {
                        var jsonData = JSON.parse(response);
                        console.log(jsonData[0].address);

                        if(jsonData !=null && jsonData.length>0) {
                            $('#Locations-div').empty();
                            for (var i = 0; i < jsonData.length; i++) {
                                if(jsonData.length==1){
                                    $('#Locations-div').append('<span class="address-select lite-grey"><div class="address-option">' + jsonData[i].address + ', ' + jsonData[i].city + ', ' + jsonData[i].state + ' ' + jsonData[i].pincode + '</div></span>');
                                }else {
                                    $('#Locations-div').append('<span class="address-select lite-grey"><span><i class="material-icons">business</i></span><div class="address-option">' + jsonData[i].address + ', ' + jsonData[i].city + ', ' + jsonData[i].state + ' ' + jsonData[i].pincode + '</div></span>');
                                }
                            }
                            $('#bank-address-div').show();
                        }

                        $('.page-loader').css("display","none");
                    },
                    error: function(e){
                        console.log(" Error ");
                        $('.page-loader').css("display","none");
                    }
                });

            });

        });
    </script>
</head>
<body>

<div class="page-loader" id="page-loader-div">
    <div class="page-loader-container">
        <img src="hsbc/images/loader.gif" width="100px">
    </div>
</div>


<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
    <!-- #### Header Starts Here #### -->

    <header class="brand-header mdl-layout__header">
        <div class="mdl-layout__header-row">

            <span class="mdl-layout-title">
                ${merchantName}
            </span>

            <div class="mdl-layout-spacer"></div>
        </div>
    </header>

    <main class="mdl-layout__content">

        <div class="bank-layout">
            <div class="bank-image">
                <img src="${imageUrl}" width="100%">
            </div>

            <div class="bank-details">
                <%--<span class="lite-grey">Apply for an HSBC Credit Card to avail the <br>exciting offers!</span>--%>
                <span class="lite-grey">${campaignName}</span>
            </div>

            <div class="bank-address" id="city-div" style="display:none;">
                <div class="to-apply">
                    <span>Kindly select below location</span>
                </div>
                <span class="address lite-grey">
                    <div id="cityselector" class="mdl-textfield mdl-js-textfield customised-textfield mdl-textfield--floating-label getmdl-select getmdl-select__fix-height">
                        <input class="mdl-textfield__input" type="text" id="city-selector" value="" readonly>
                        <label class="customised-label" for="city-selector">
                            <i class="mdl-icon-toggle__label material-icons">keyboard_arrow_down</i>
                        </label>
                        <label for="city-selector" class="mdl-textfield__label">City</label>
                        <ul for="city-selector" class="mdl-menu customised-menu mdl-menu--bottom-left mdl-js-menu" id="select-ul">                           
                        </ul>
                    </div>
                </span>
            </div>

            <div class="bank-address" id="bank-address-div" style="display:none;">
                <div class="to-apply">
                    <span>Kindly visit the below location to apply</span>
                </div>
                <div id="Locations-div">

                </div>
            </div>

            <div class="coupon-code-section">
                <div class="code-head">
                    <h5 class="mdl-typography--text-uppercase">coupon code</h5>
                </div>
                <div class="coupon-code-container">
                    <div class="coupon-code">
                        <span class="mdl-typography--text-uppercase">${coupon}</span>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>