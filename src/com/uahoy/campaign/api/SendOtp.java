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
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.util.Properties;

/**
 * Created by vivek on 29/11/16.
 */

@WebServlet("/sotp")
public class SendOtp extends HttpServlet{

    private static Logger logger = LoggerFactory.getLogger(SendOtp.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PrintWriter out =null;

        String msisdn = request.getParameter("m");
        String cid = request.getParameter("cid");
        String otp = "";
        String resp = "";
        String msgPushResponse = "";
        try{

            out = response.getWriter();
            if(msisdn!=null && msisdn.trim().matches("[0-9]{10}") && Long.valueOf(msisdn.trim())>6999999999l){
                otp = Utility.getOtp(4);
                if(otp!=null && otp.length()==4){
                    request.getSession().setAttribute("_otp",otp);

                    msgPushResponse = this.sendOTP(msisdn,otp,cid);

                    resp = "Success";
                }else{
                    resp = "Fail";
                }
            }else{
                resp = "Please Enter valid Msisdn";
            }



        }catch(Exception e){
            resp = "Internal Error";
            logger.error(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            out.println(resp);
            logger.info("msisdn: "+msisdn+" | otp: "+otp+" | msgPushResponse: "+msgPushResponse+" | resp: "+resp);
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        this.processRequest(request,response);

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.processRequest(request,response);
    }

    public String sendOTP(String msisdn, String otp, String cid){
        String resp = "";
        try{

            URL url = SendOtp.class.getResource("/ahoy.properties");
            Properties properties = new Properties();
            properties.load(url.openStream());

            String msg = properties.getProperty("OTP").replace("XXXX",otp);

            String msgpushAPI = properties.getProperty("MSG_PUSH_API")
                    .replace("<MESSAGE>",URLEncoder.encode(msg,"UTF-8"))
                    .replace("<CLI>", properties.getProperty(cid).split("~")[0])
                    .replace("<MSISDN>",msisdn);

            resp = Utility.processURL(msgpushAPI);

        }catch (Exception e){
            resp = "Internal Server Error";
            logger.error("msisdn: "+msisdn+" | otp: "+otp+" | "+GetStackElements.getRootCause(e,getClass().getName()));
        }
        return resp;
    }

}
