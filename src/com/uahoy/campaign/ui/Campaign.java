package com.uahoy.campaign.ui;

import com.uahoy.campaign.api.SendOtp;
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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Properties;
import java.util.Scanner;

/**
 * Created by vivek on 3/12/16.
 */

@WebServlet("/c/*")
public class Campaign extends HttpServlet{


    private static Logger logger = LoggerFactory.getLogger(Campaign.class);

    private void process(HttpServletRequest request, HttpServletResponse response){

        long startTime = System.currentTimeMillis();

        String idType = request.getParameter("type");
        String id = request.getParameter("id");
        String src = request.getParameter("src");
        String resp = null;
        PrintWriter out = null;
        String ip = request.getHeader("X-FORWARDED-FOR") !=null? request.getHeader("X-FORWARDED-FOR") :request.getRemoteAddr();
        try{
            out = response.getWriter();
            String pathInfo =request.getPathInfo();
            String[] pathParts = pathInfo.split("/");

            long cid = pathParts.length==2 && pathParts[1].matches("[0-9]+")?Long.valueOf(pathParts[1]):0;

            if(cid>0) {       
                

                URL url = Campaign.class.getResource("/offers.properties");
                Properties properties = new Properties();
                properties.load(url.openStream());

                String getCidDetail = properties.getProperty(cid+"");
                String [] cidDetailPart = getCidDetail.split("~");

                String merchantName = cidDetailPart[0];
                String imageUrl = cidDetailPart[1];
                String branchName=cidDetailPart[2];
                String campaignName=cidDetailPart[3];
                request.getSession().invalidate();
                HttpSession session = request.getSession();
                session.setAttribute("merchantName",merchantName);
                session.setAttribute("campaignName",campaignName);
                session.setAttribute("imageUrl",imageUrl.trim().startsWith("https")?imageUrl:("https://ads.uahoy.in"+request.getContextPath()+"/image/"+imageUrl));
                session.setAttribute("cid",cid);
                
                String serverPath = Utility.getServerPath(request);
                session.setAttribute("serverPath", serverPath);

                if (idType != null && idType.matches("devid|gid") && id != null && !"".equals(id.trim())) {
                    id = id.replaceAll("[^\\w\\s]","");
                    String api = "http://uahoy.com/mobilecoupon/getcpnbyid?cid=" + cid + "&idtype=" + idType + "&id=" + id;
                    int i = 0;
                    do {
                        resp = Utility.processURL(api);
                        i++;
                    } while (i < 2 && (resp == null || "".equals(resp.trim()) || "Read timed out".equals(resp.trim())));

                    if (resp != null && !"".equals(resp.trim()) && !"Read timed out".equals(resp.trim())) {
                        session.setAttribute("coupon", resp);
                        session.setAttribute("uid",id.replaceAll("[^\\w\\s]","")+"@"+idType+".com");
                    } else {
                      resp ="coupon api is taking time";
                    }
                } else {
                    resp = "id or idtype not found";
                }

                response.sendRedirect(serverPath+"/offer");
                
            }else{
                resp = "Invalid Path "+pathInfo;
            }

        }catch(Exception e){
            resp = "Internal Error";
            logger.error(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            out.print(resp);
            if(out!=null)out.close();
            logger.info("Total Timetaken: "+(System.currentTimeMillis()-startTime)+" | ip: " + ip+ " | ua: " + request.getHeader("User-Agent")+" | src: "+src+ (idType!=null?" | idType: "+idType:"")+(id!=null?" | id: "+id:"")+(resp!=null?" | resp: "+resp:""));

        }
    }

    public static void main(String[] args) {
        String id = "ifa:8bd02234-4b97-4a26-a723-9343689b1b0e";
        id = id.replaceAll("[^\\w\\s]","");
        System.out.println(id);
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
