package com.uahoy.campaign.util;

public class GetStackElements {
	
	public static String getRootCause(Exception e, String className) {

        for (StackTraceElement element : e.getStackTrace()) {
            if (element.getClassName().equals(className)) {
                return "Exception : " + e + " at " + element;
            }
        }
        return null;
    }
}
