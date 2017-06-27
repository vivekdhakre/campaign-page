package com.uahoy.campaign.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.uahoy.campaign.util.Utility;


@WebServlet("/sendcmobile")
public class SendCouponOnMobile extends HttpServlet{
	
	private static Logger logger = LoggerFactory.getLogger(SendCouponOnMobile.class);
	
	protected void processRequest(HttpServletRequest request, HttpServletResponse response){
		String msisdn = request.getParameter("m");
		String msg = request.getParameter("msg");
		String resp = null;
		String msgApiResponse=null;
		PrintWriter out = null;
		try {
			
			out = response.getWriter();
			URL url = SendOtp.class.getResource("/ahoy.properties");
            Properties properties = new Properties();
            properties.load(url.openStream());            

            String msgpushAPI = properties.getProperty("MSG_PUSH_API")
                    .replace("<MESSAGE>",URLEncoder.encode(msg,"UTF-8"))
                    .replace("<MSISDN>",msisdn);

            msgApiResponse = Utility.processURL(msgpushAPI);
			
            resp = "Success";
			
		}catch(Exception e) {
			resp = "Internal Server Error";
			logger.error("[SendCouponOnMobile] m: "+msisdn+"msg: "+msg+" | "+e.getMessage());
		}finally {
			out.println(resp);
			logger.info("[SendCouponOnMobile] m: "+msisdn+"msg: "+msg+" | msgApiResponse: "+msgApiResponse+" | resp: "+resp);
			
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.processRequest(request,response);
    }

}
