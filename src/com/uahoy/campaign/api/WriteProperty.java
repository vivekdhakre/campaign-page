package com.uahoy.campaign.api;

import com.uahoy.campaign.ui.Campaign;
import com.uahoy.campaign.ui.JuddsChemist;
import com.uahoy.campaign.util.GetStackElements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URL;
import java.util.Properties;

/**
 * Created by vivek on 22/2/17.
 */
@WebServlet("/wp")
public class WriteProperty extends HttpServlet{

    private static Logger logger = LoggerFactory.getLogger(WriteProperty.class);

    //String campaignWritePropertyUrl = "http://uahoy.com/campaign/wp?cid=<CID>&cn=<CAMPAIGN_NAME>&m=<MERCHANT_NAME>&bn=<BRANCH_NAME>&iu=<IMAGE_URL>

    private void process(HttpServletRequest request, HttpServletResponse response){
        String cid = request.getParameter("cid");
        String campaignName = request.getParameter("cn");
        String merchantName =request.getParameter("m");
        String branchName = request.getParameter("bn");
        String imageUrl = request.getParameter("iu");
        String mid = request.getParameter("mid");

        String resp = null;
        PrintWriter out = null;

        try{

            out = response.getWriter();

            if(cid!=null&&cid.trim().matches("[0-9]+")
                    && campaignName!=null && !"".equalsIgnoreCase(campaignName)
                    && imageUrl!=null){

                String path = getServletContext().getRealPath("/");

                FileInputStream in = new FileInputStream(path+"WEB-INF/classes/offers.properties");
                Properties props = new Properties();
                props.load(in);
                in.close();

                FileOutputStream fos = new FileOutputStream(path+"WEB-INF/classes/offers.properties");
                props.setProperty(cid, merchantName+"~"+imageUrl+"~"+branchName+"~"+campaignName+"~"+mid);
                props.store(fos, null);
                out.close();

                resp = "Success";

            }else{
                resp = "Bad Request";
            }
        }catch(Exception e){
            logger.error(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            out.println(resp);
            logger.info("cid: "+cid+" | campaignName: "+campaignName+" | imageUrl: "+imageUrl+" | resp: "+resp);
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
