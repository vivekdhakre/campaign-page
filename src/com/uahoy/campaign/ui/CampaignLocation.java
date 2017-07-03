package com.uahoy.campaign.ui;

import com.uahoy.campaign.util.GetStackElements;
import com.uahoy.campaign.util.Utility;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

/**
 * Created by vivek on 3/12/16.
 */

@WebServlet("/cl/*")
public class CampaignLocation extends HttpServlet{


    private static Logger logger = LoggerFactory.getLogger(CampaignLocation.class);

    private void process(HttpServletRequest request, HttpServletResponse response){

        long startTime = System.currentTimeMillis();

        String idType = request.getParameter("type");
        String id = request.getParameter("id");
        String resp = null;
        PrintWriter out = null;

        try{
            out = response.getWriter();
            String pathInfo =request.getPathInfo();
            String[] pathParts = pathInfo.split("/");

            long cid = pathParts.length==2 && pathParts[1].matches("[0-9]+")?Long.valueOf(pathParts[1]):0;

            if(cid>0) {

//                if (idType != null && idType.matches("devid|gid") && id != null && !"".equals(id.trim())) {

                URL url = CampaignLocation.class.getResource("/offers.properties");
                Properties properties = new Properties();
                properties.load(url.openStream());

                String getCidDetail = properties.getProperty(cid+"");

                if(getCidDetail!=null && !"".equals(getCidDetail.trim())) {
                    request.getSession().invalidate();
                    HttpSession session = request.getSession();

                    String serverPath = Utility.getServerPath(request);
                    session.setAttribute("serverPath", serverPath);

                    String [] cidDetailPart = getCidDetail.split("~");

                    String merchantName = cidDetailPart[0];
                    String imageUrl = cidDetailPart[1];
                    String campaignName=cidDetailPart[3];
                    String mid = cidDetailPart[4];


                    session.setAttribute("merchantName",merchantName);
                    session.setAttribute("campaignName",campaignName);
                    session.setAttribute("imageUrl",imageUrl.startsWith("https")?imageUrl:("https://ads.uahoy.in"+request.getContextPath()+"/image/"+imageUrl));
                    session.setAttribute("cid",cid);
                    session.setAttribute("mid",mid);

                    if (idType != null && idType.matches("devid|gid") && id != null && !"".equals(id.trim())) {
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
                    }else {
                        resp = "something mismatched";
                    }

                    response.sendRedirect(serverPath+"/bo/"+cid);

                }else {
                    resp = "cid is not configured";
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
