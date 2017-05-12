package com.uahoy.campaign.api;

import com.uahoy.campaign.util.GetStackElements;
import com.uahoy.campaign.util.Utility;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.net.URLEncoder;

/**
 * Created by ahoy on 12/5/17.
 */

@WebServlet({"/bar.png","/qr.png"})
public class GetBarOrQrCode extends HttpServlet{

    private static Logger logger = LoggerFactory.getLogger(GetBarOrQrCode.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response){

        String ctype = request.getParameter("ctype");
        HttpSession session = request.getSession();
        String uid = session.getAttribute("uid").toString();
        String cid = session.getAttribute("cid").toString();
        String coupon = session.getAttribute("coupon").toString();
        String resp = null;
        try{

            if(cid!=null && cid.trim().matches("[0-9]+")
                    && ctype!=null && ctype.trim().matches("[1-2]{1}")
                    && uid!=null && uid.trim().contains("@")){


                File f = null;
                if(ctype.equalsIgnoreCase("1")){
                    f = new File("/home/apache-tomcat-8.0.35/uahoyapps/ROOT/coupon/1D/"+coupon+".png");
                }else{
                    f = new File("/home/apache-tomcat-8.0.35/uahoyapps/ROOT/coupon/QR/"+coupon+".png");
                }

                if(!f.exists()){
                    String cpnurl1 = "http://uahoy.com/uahoy/couponFetch?cid=" + cid + "&ctype=" + ctype + "&uid=" + URLEncoder.encode(uid,"UTF-8");
                    Utility.processURL(cpnurl1);
                }

                writeImage(response,f);
                resp = "Success";

            }else{
                resp = "Bad Request";
            }

        }catch (Exception e){
            resp = "Internal Error";
            logger.error("cid: "+cid+" | ctype: "+ctype+" | uid: "+uid+" | "+ GetStackElements.getRootCause(e,getClass().getName()));
        }finally {
            logger.info("ctype: "+ctype+" | uid: "+uid+" | cid: "+cid+" | coupon: "+coupon+" | resp: "+resp);
        }
    }

    public static void  writeImage(HttpServletResponse response, File image) throws Exception {

        OutputStream out = null;
        FileInputStream in = null;
        try {
            out = response.getOutputStream();
            response.setContentType("image/png");
            in = new FileInputStream(image);
            int size = in.available();
            byte[] content = new byte[size];
            in.read(content);
            out.write(content);
        } catch (Exception e) {
            throw e;
        } finally {
            if (in != null)
                in.close();
            if (out != null)
                out.close();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.processRequest(request,response);
    }

}
