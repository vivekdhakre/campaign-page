<%@page import="org.slf4j.Logger"%>
<%@page import="org.slf4j.LoggerFactory"%>

<%!private static final Logger logger = LoggerFactory.getLogger("mintmaid.jsp");%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>

<html>
<!--<![endif]-->
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Mintmaid Pulpy Orange</title>
	<link href="<%=request.getContextPath()%>/css/boilerplate.css" rel="stylesheet" type="text/css">
	<link href="<%=request.getContextPath()%>/css/surf.css" rel="stylesheet" type="text/css">
	<script>

		$( document ).ready(function() {

			$('#submit').click(function(){

				$('.page-loader').css("display","flex");

				var msisdn = $('#inputMsisdn').val();
				if(msisdn==null){
					$('.page-loader').hide();
					alert("Please Enter Msisdn");
					$('#inputMsisdn').focus();
					$('.page-loader').hide();
					return false;

				}else{
					if(msisdn.length!=10 || msisdn<=6999999999){
						$('.page-loader').hide();
						alert("Please Enter Valid Msisdn");
						$('#inputMsisdn').focus();
						return false;

					}else{

						$.ajax({
							url: "sotp?cid=1767725&m="+msisdn,
							data: "",
							type: 'POST',
							success: function (resp) {
								if(resp = "Success"){
									$('#inputMsisdn').attr("readonly","true");
									$("#submit").hide();
									$('#inputotp').show();
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

				if(otp==null || otp.length!=4){
					$('.page-loader').hide();
					alert("Please Enter Valid OTP");
					$('#inputotp').focus();
					return false;
				}else{

					$.ajax({
						url: "gc?m="+msisdn+"&o="+otp+"&cid=1767725",
						data: "",
						type: 'POST',
						success: function (resp) {

							if(resp.length == 10){
								$('#inputotp').hide();
								$('#submit-otp').hide();
								$('#inputcoupon').text(resp);
								$('#coupon-div').show();
								$('.page-loader').hide();
							}else if(resp ==="read timed out" || resp === "connect timed out") {
								$('.page-loader').hide();
								alert("Retry again, Coupon Fetching process taking long time");

							}else if(resp == 401){

								$('#inputMsisdn').show();
								$('#submit').show();

								$('#inputotp').val('');
								$('#inputotp').hide();
								$('#submit-otp').hide();
								$('.page-loader').hide();

								alert("Session Expired. Try again");


							}else if(resp == 403){
								$('.page-loader').hide();
								alert("Please Enter Valid OTP");

							}else if(resp == 500){
								$('.page-loader').hide();
								alert("Internal Problem is Coming..");

							}else{
								if(resp!=''){
									$('.page-loader').hide();
									alert(resp);
								}
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

		function validateMsisdn() {
			var msisdn = document.getElementById("inputMsisdn").value;
			if (msisdn.length != 10) {
				alert('Invalid Mobile Number');
				return false;
			}
			return true;
		}
		function numeric(e) {
			e.value = e.value.replace(/[^0-9]+/g, '');
		}

	</script>

</head>
<body>
<%
	logger.info("ip: " + request.getRemoteAddr()+ " | ua: " + request.getHeader("User-Agent"));
%>

<div class="page-loader">
	<div class="page-loader-container">
		<img src="<%=request.getContextPath()%>/img/loader.gif" width="100px">
	</div>
</div>

<div class="gridContainer clearfix">
	<div id="LayoutDiv1">
		<div id="header">
			<div id="logo-itc">
				<img src="<%=request.getContextPath()%>/campimg/mmaid-logo.png" width="74px">
			</div>
			<div id="logo-uahoy"><img style="float: right;" src="<%=request.getContextPath()%>/img/ahoy-logo.png"></div>
		</div>
	</div>
	<div id="bg-container">
		<div id="bg"><img src="<%=request.getContextPath()%>/campimg/mmaid_banner.png"></div>
	</div>
	<div id="LayoutDiv2">
		<div id="LayoutDiv4">
			<div class="layoutdiv4-container">


				<%
					String coupon = (String)request.getAttribute("coupon");

					if(coupon!=null && coupon.length()==10){
				%>


				<div class="mobile-text-box">
					<div class="coupon-code-conatiner">
						<h3>Your Unique Discount Code is:</h3>
						<div class="code-section">
							<h3 class="coupon-code"><%=coupon%></h3>
						</div>
						<!-- <span>Same is being sent over SMS on your verified no. as well</span> -->
					</div>
				</div>

				<div class="otp-submit-button"></div>
				<%
				}else{
				%>
				<div id="call">
					<div class="call-container">
						<div id="call-icon"><img src="<%=request.getContextPath()%>/img/arrowhead.png"></div>
						<div id="click2call"><h2>Enter Following Details</h2></div>
					</div>
				</div>
				<div class="mobile-text-box">

					<input name="msisdn" style="margin-top: 2px;" id="inputMsisdn" type="text" onkeyup="numeric(this)" placeholder="Enter Mobile No">
				</div>
				<div class="mobile-text-box">

					<input name="otp" style="margin-top: 2px;display:none;" id="inputotp" type="text" onkeyup="numeric(this)" placeholder="Enter OTP">

				</div>
				<div class="mobile-text-box" id="coupon-div" style="display:none;">
					<div class="coupon-code-conatiner">
						<h3>Your Unique Discount Code is:</h3>
						<div class="code-section">
							<h3 class="coupon-code" id="inputcoupon"></h3>
						</div>
						<span>Same is being sent over SMS on your verified no. as well</span>
					</div>
				</div>

				<div class="otp-submit-button">
					<input name="btn" style="margin-top: 2px;" id="submit" type="submit" value="Send OTP">
					<input name="btn" style="margin-top: 2px;display:none;" id="submit-otp" type="submit" value="Get Coupon">
				</div>
				<%
					}
				%>




			</div>
			<div id="LayoutDiv4" style="margin-top: 2px;">
				<div id="ins">
					<div id="call-icon"><img src="<%=request.getContextPath()%>/img/arrowhead.png"></div>
					<span><h2>Instructions</h2></span>
				</div>

				<ul id="instruction">
					<span><strong><u>HOW TO REDEEM:</u></strong></span>
					<li>Offer is applicable on Minute Maid Pulpy Orange 400ml only, which now you'll get just for Rs. 10</li>
					<li>Coupon received via SMS is Redeemable at SPENCERS outlet in AP and Telangana only, along with purchase of the product.</li>
					<li>Show the COUPON CODE while BILLING. Discount will be applied on valid coupons only</li>
					<li>In case of any issues kindly email to <a href="mailto:feedback@ahoy.co.in">feedback@ahoy.co.in</a></li>
					<br>

					<span><strong><u>TERMS:</u></strong></span>
					<li>Offer Valid in Spencers in AP &amp; Telangana Only.</li>
					<li>Offer valid till stock last.</li>
					<li>One Coupon per mobile number only.</li>
					<li>Maximum 2 units can be availed under offer in one bill only</li>
					<li>Offer can't be clubbed with other offers.</li>

				</ul>
			</div>
			<div id="LayoutDiv5">
				<div class="footer">
					©2016 <a href="http://uahoy.com/">uahoy.com</a><br> All
					Rights Reserved by Ahoy Telecom Pvt. Ltd.<br>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>