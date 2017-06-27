package com.uahoy.campaign.api;


import com.uahoy.campaign.util.GetStackElements;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;


/**
 * Created by rtbkit on 16/3/17.
 */

@WebServlet("/image/*")
public class ImageRender extends HttpServlet {

    private static Logger logger = LoggerFactory.getLogger(ImageRender.class);

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        OutputStream out = null;
        InputStream in = null;
        try{

            String pathInfo =request.getPathInfo();
            String[] pathParts = pathInfo.split("/");
            String imageName = pathParts.length==2 ?pathParts[1]:null;

            if(imageName!=null && !"".equals(imageName.trim()) && !"null".equalsIgnoreCase(imageName.trim())) {

                out = response.getOutputStream();
                in = new FileInputStream(new File("/home/apache-tomcat-8.0.35/marketeerapps/ahoy/dealImages/" + imageName));
                int size = in.available();
                byte[] content = new byte[size];
                in.read(content);
                out.write(content);
            }

        }catch (Exception e){
            logger.error(GetStackElements.getRootCause(e,getClass().getName()));
        }finally{
            if (in != null)
                in.close();
            if (out != null)
                out.close();
        }


    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.processRequest(request,response);
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        this.processRequest(request,response);
    }

    public static void main(String[] args) {
        try {
//            System.out.println(URLEncoder.encode("http://marketeer.uahoy.com/ahoy/dealImages/_1489664459154_4213_TheYellowChilli-500x500_new(1).png", "UTF-8"));


            URL url = new URL("http://marketeer.uahoy.com/ahoy/dealImages/_1489664459154_4213_TheYellowChilli-500x500_new(1).png");
            BufferedImage bImageFromConvert = ImageIO.read(url);
            //String dealImage = UUID.randomUUID().toString().replaceAll(" ", "");
            String tempFile = "abc.png";
            ImageIO.write(bImageFromConvert, "jpg", new File("/home/applogs/"+tempFile));
            System.out.println("Success");

        }catch (Exception e){
            System.out.println(e);
        }
    }
}
