package com.uahoy.campaign.api;

import com.uahoy.campaign.util.GetStackElements;
import com.uahoy.campaign.util.Utility;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Properties;

import javax.ws.rs.core.Response;

/**
 * Created by vivek on 29/11/16.
 */

@WebServlet("/gc")
public class GetCoupon extends HttpServlet{

    private static Logger logger = LoggerFactory.getLogger(GetCoupon.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out = null;

        String msisdn = request.getParameter("m");
        String otp = request.getParameter("o");
        String cid = request.getParameter("cid");
        String sessionOtp = request.getSession().getAttribute("_otp").toString();

        String resp = "";
        String msgPushResponse="";
        try{

            out = response.getWriter();


            if(sessionOtp==null||"null".equalsIgnoreCase(sessionOtp.trim())) {
                resp = Response.Status.UNAUTHORIZED.getStatusCode()+"";
            }else{
                if(sessionOtp.equalsIgnoreCase(otp)){
                    if(msisdn!=null && msisdn.trim().matches("[0-9]{10}") && cid!=null && cid.trim().matches("[0-9]+")){
                        String couponUrl = "http://uahoy.com/mobilecoupon/mcoupon?cid="+cid+"&msisdn="+msisdn+"&rname=campaignpage&platform=web";
                        String coupon = Utility.processURL(couponUrl);

                        resp = coupon;
//                        if(coupon!=null && coupon.trim().length()==10) {
//                            msgPushResponse = this.msgCoupon(msisdn, coupon, cid);
//                            request.getSession().invalidate();
                            javax.servlet.http.HttpSession hs = request.getSession();
                            hs.setAttribute("coupon",resp);
                            hs.setAttribute("uid",msisdn+"9");

//                        }
                    }else{
                        resp = Response.Status.BAD_REQUEST.getStatusCode()+"";
                    }
                }else{
                    resp = Response.Status.FORBIDDEN.getStatusCode()+"";
                }
            }
        }catch(Exception e){
            resp =Response.Status.INTERNAL_SERVER_ERROR.getStatusCode()+"";
            logger.error(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            logger.info("msisdn: "+msisdn+" | cid: "+cid+" | Otp: "+otp+" | sessionOtp: "+sessionOtp+" | msgPushResponse: "+msgPushResponse+" | resp: "+resp);
            out.print(resp);
            out.close();

        }

    }

//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        this.processRequest(request,response);
//    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.processRequest(request,response);
    }

    public String msgCoupon(String msisdn,String coupon,String cid){
        String resp = "";

        try {

            URL url = SendOtp.class.getResource("/ahoy.properties");
            Properties properties = new Properties();
            properties.load(url.openStream());

            String getCidDetail = properties.getProperty(cid);
            String cli = getCidDetail.split("~")[0];
            String msg = getCidDetail.split("~")[1].replace("xxxxxxxxxx",coupon);

            String msgpushAPI = properties.getProperty("MSG_PUSH_API")
                    .replace("<MESSAGE>", URLEncoder.encode(msg,"UTF-8"))
                    .replace("<CLI>", cli)
                    .replace("<MSISDN>",msisdn);

            resp = Utility.processURL(msgpushAPI);


        }catch (Exception e){
            logger.error("msisdn: "+msisdn+" | coupon: "+coupon+" | cid: "+cid+" | "+GetStackElements.getRootCause(e,getClass().getName()));
        }

        return resp;
    }


}
