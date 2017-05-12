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
import java.io.PrintWriter;
import java.util.Scanner;

/**
 * Created by vivek on 3/12/16.
 */

@WebServlet("/judds")
public class JuddsChemist extends HttpServlet{


    private static Logger logger = LoggerFactory.getLogger(JuddsChemist.class);

    private void process(HttpServletRequest request, HttpServletResponse response){

        long startTime = System.currentTimeMillis();

        String idType = request.getParameter("type");
        String id = request.getParameter("id");
        String resp = null;
        PrintWriter out = null;

        long cid = 1767725;
        try{
            out = response.getWriter();
            String pathInfo =request.getPathInfo();
            String[] pathParts = pathInfo.split("/");



                if (idType != null && idType.matches("devid|gid") && id != null && !"".equals(id.trim())) {
                    String api = "http://uahoy.com/mobilecoupon/getcpnbyid?cid=" + cid + "&idtype=" + idType + "&id=" + id;
                    int i = 0;
                    do {
                        resp = Utility.processURL(api);
                        i++;
                    } while (i < 2 && (resp == null || "".equals(resp.trim()) || "Read timed out".equals(resp.trim())));

                    if (resp != null && !"".equals(resp.trim()) && !"Read timed out".equals(resp.trim())) {
                        request.getSession().setAttribute("coupon", resp);
                        response.sendRedirect("./juddschemist");
                    } else {
                        response.setContentType("text/html");
                        String url1 = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "?id=" + id + "&type=" + idType;
                        resp = "<a href='" + url1 + "'>Retry Again</a>";
                    }
                } else {
                    resp = "Bad Request";
                }


        }catch(Exception e){
            resp = "Internal Error";
            logger.error(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            out.print(resp);
            if(out!=null)out.close();
            logger.info("Total Timetaken: "+(System.currentTimeMillis()-startTime)+" | ip: " + request.getRemoteAddr()+ " | ua: " + request.getHeader("User-Agent")+ (idType!=null?" | idType: "+idType:"")+(id!=null?" | id: "+id:"")+(resp!=null?" | resp: "+resp:""));
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
