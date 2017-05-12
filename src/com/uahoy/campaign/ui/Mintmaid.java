package com.uahoy.campaign.ui;

import com.uahoy.campaign.util.GetStackElements;
import com.uahoy.campaign.util.Utility;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by vivek on 3/12/16.
 */

@WebServlet("/mintmaid")
public class Mintmaid extends HttpServlet{


    private static Logger logger = LoggerFactory.getLogger(Mintmaid.class);

    private void process(HttpServletRequest request, HttpServletResponse response){

        String idType = request.getParameter("type");
        String id = request.getParameter("id");
        long cid = 1767725;
        String coupon = null;
        try{

            if (idType!=null && idType.matches("devid|gid") && id != null && !"".equals(id.trim())) {
                String api = "http://uahoy.com/mobilecoupon/getcpnbyid?cid="+cid+"&idtype="+idType+"&id="+id;
                coupon = Utility.processURL(api);
                request.setAttribute("coupon",coupon);
            }
            RequestDispatcher rd = request.getRequestDispatcher("/mintmaid.jsp");
            rd.forward(request,response);

        }catch(Exception e){
            logger.error(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            logger.info("ip: " + request.getRemoteAddr()+ " | ua: " + request.getHeader("User-Agent")+ (idType!=null?" | idType: "+idType:"")+(id!=null?" | id: "+id:"")+(coupon!=null?" | coupon: "+coupon:""));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.process(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.process(request, response);
    }

}
