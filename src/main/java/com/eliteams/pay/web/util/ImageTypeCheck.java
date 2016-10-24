package com.eliteams.pay.web.util;


public class ImageTypeCheck {

	public static String bytesToHexString(byte[] src) {

		StringBuilder stringBuilder = new StringBuilder();
		if (src == null || src.length <= 0) {
			return null;
		}
		for (int i = 0; i < src.length; i++) {
			int v = src[i] & 0xFF;
			String hv = Integer.toHexString(v);
			if (hv.length() < 2) {
				stringBuilder.append(0);
			}
			stringBuilder.append(hv);
		}
		return stringBuilder.toString();
	}

	
	public static String getPicType(byte[] b) {
		try {
			String type = bytesToHexString(b).toUpperCase();
			if (type.contains("FFD8FF")) {
				return "jpg";
			} else if (type.contains("89504E47")) {
				return "png";
			} else if (type.contains("47494638")) {
				return "gif";
			}else if (type.contains("424D")) {
				return "bmp";
			}else{
				return "noimg";
			}
			//tif tiff
			/*else if (type.contains("49492A00")) {
				return "tif";
			}*/ 
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return null;
	}
}
