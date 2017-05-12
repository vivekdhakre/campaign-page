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
import java.util.Enumeration;

/**
 * Created by rtbkit on 16/3/17.
 */

@WebServlet("/marketeer/*")
public class MarketeerApiHit extends HttpServlet {

    private static Logger logger = LoggerFactory.getLogger(MarketeerApiHit.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resp = null;
        PrintWriter out = null;

        try{

            out = response.getWriter();
            String pathInfo =request.getPathInfo();
            String[] pathParts = pathInfo.split("/");

            String apiName = pathParts.length==2 ?pathParts[1]:null;


            String api = "http://marketeer.uahoy.com/ahoy/"+apiName+"?";

            Enumeration<String> parameterNames = request.getParameterNames();

            StringBuilder builder = new StringBuilder();
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                if(builder.length()==0) {
                    builder.append(paramName + "=" + request.getParameter(paramName));
                }else{
                    builder.append("&"+paramName + "=" + request.getParameter(paramName));
                }
            }

            api+=builder.toString();
            resp = Utility.post(api);
        }catch (Exception e){
            resp = "500";
            logger.info(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            out.println(resp);
        }


    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.processRequest(request,response);
    }
}
