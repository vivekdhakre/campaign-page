<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Judd's Chemist</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
	<link rel="stylesheet" href="judds/css/style.css">
	<link rel="stylesheet" href="judds/mdl/material.min.css">
	<script type="text/javascript" src="judds/js/jquery-2.2.2.min.js"></script>
	<script type="text/javascript" src="judds/mdl/material.min.js"></script>
</head>
<body>

<%

	String coupon = session.getAttribute("coupon").toString();
	if(coupon!=null && !"".equals(coupon.trim())){

%>


<div class="mdl-layout mdl-js-layout mdl-layout--fixed-header">
	<!-- #### Header Starts Here #### -->

	<header class="brand-header mdl-layout__header is-casting-shadow">
		<div class="mdl-layout__header-row before-scroll">

            <span>
                judd's Chemist
            </span>

			<!-- #### Navigation ends here -->

		</div>
	</header>

	<main class="mdl-layout__content">

		<div class="container">
			<div class="offer-image">
				<div class="offer-container">
					<img src="judds/images/banner.png">
				</div>
			</div>

			<div class="coupon-code-container">
				<div class="coupon-code-section">
					<div class="code-head">
						<h5>Your Unique Discount Code is:</h5>
					</div>
					<div class="code-section">
						<h3 class="coupon-code"><%=coupon%></h3>
					</div>
				</div>
				<div class="brand-details">
					<div class="brand-address">
						<i class="material-icons">business</i>
						<span class="address">Judd's Chemist, 264 Kingsbury Rd<br>London NW9 0BT</span>
					</div>
					<div class="telephone-section">
						<i class="material-icons">phone</i>
						<div class="call-number">
							<span>020 8204 8665</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
</div>
<%}else{
	response.getWriter().println("Bad Request");
}%>
</body>
</html>