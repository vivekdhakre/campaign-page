package com.uahoy.campaign.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.security.SecureRandom;

import javax.servlet.http.HttpServletRequest;

import java.net.HttpURLConnection;

/**
 * Created by vivek on 30/11/16.
 */
public class Utility {

    private static Logger logger = LoggerFactory.getLogger(Utility.class);

    public static String serverPath = "http://localhost:8080";
//    public static String serverPath = "https://ads.uahoy.in";
    
    public static String getServerPath(HttpServletRequest request) {
    	return serverPath+request.getContextPath();
    }

    public static String getOtp(int size) {

        StringBuilder generatedToken = new StringBuilder();
        try {
            SecureRandom number = SecureRandom.getInstance("SHA1PRNG");
            for (int i = 0; i < size; i++) {
                generatedToken.append(number.nextInt(9));
            }
        } catch (Exception e) {
            logger.error(GetStackElements.getRootCause(e,Utility.class.getName()));
        }
        return generatedToken.toString();
    }

    public static String processURL(String paramString){
        StringBuilder builder = new StringBuilder();
        BufferedReader br = null;
        try
        {
            URL url = new URL(paramString);
            URLConnection urlConnection = url.openConnection();
            urlConnection.setConnectTimeout(10000);
            urlConnection.setReadTimeout(25000);

            br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
            String str;
            while ((str = br.readLine()) != null)
                builder.append(str);

        }catch (Exception e){
            builder.append(e.getMessage());
            logger.error(GetStackElements.getRootCause(e,Utility.class.getName()));
        }finally {
            try{if(br!=null)br.close();}catch(Exception e){}
        }
        return builder.toString();
    }

    public static String post(String paramString){
        StringBuilder builder = new StringBuilder();
        BufferedReader br = null;
        try
        {
            URL url = new URL(paramString);
            HttpURLConnection urlConnection =(HttpURLConnection) url.openConnection();
            urlConnection.setConnectTimeout(10000);
            urlConnection.setReadTimeout(25000);
            urlConnection.setRequestMethod("POST");

            br = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
            String str;
            while ((str = br.readLine()) != null)
                builder.append(str);

        }catch (Exception e){
            builder.append(e.getMessage());
            logger.error(GetStackElements.getRootCause(e,Utility.class.getName()));
        }finally {
            try{if(br!=null)br.close();}catch(Exception e){}
        }
        return builder.toString();
    }
}
