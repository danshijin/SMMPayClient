package com.eliteams.pay.web.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;

/**
 * 远程接口请求辅助类 Created by zhenghao on 2015/9/15.
 */
public class URLRequest {

    /**
     * 发送get请求
     * 
     * @param url 请求地址
     * @param parameters 请求参数
     * @return
     * @throws Exception
     */
    public static String get(String url, Map<String, String> parameters) throws Exception {

        url = url + "?1=1";

        //处理请求参数
        for (Map.Entry<String, String> entry : parameters.entrySet()) {

            url += "&" + entry.getKey() + "=" + URLEncoder.encode(entry.getValue(), "UTF-8");

        }

        //发送请求
        URL remote = new URL(url);

        HttpURLConnection connection = (HttpURLConnection) remote.openConnection();

        connection.setRequestProperty("contentType", "UTF-8");

        //设置超时时间
        connection.setConnectTimeout(5 * 1000);

        //设置请求方式
        connection.setRequestMethod("GET");

        //接收返回值
        BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
        String line;

        String result = "";

        while ((line = in.readLine()) != null) {
            result += line;
        }

        return result;

    }

    /**
     * 发送post请求
     * 
     * @param url
     * @param parameters
     * @return
     * @throws Exception
     */
    public static String post(String url, Map<String, String> parameters) throws Exception {

        URL remote = new URL(url);

        HttpURLConnection connection = (HttpURLConnection) remote.openConnection();

        connection.setRequestProperty("contentType", "UTF-8");

        connection.setRequestMethod("POST");// 提交模式
        //设置超时时间
        connection.setConnectTimeout(5 * 1000);

        connection.setDoOutput(true);// 是否输入参数

        StringBuilder params = new StringBuilder();

        params.append("1=1");

        //处理请求参数
        for (Map.Entry<String, String> entry : parameters.entrySet()) {

            String temp = "&" + entry.getKey() + "=" + URLEncoder.encode(entry.getValue(), "UTF-8");

            params.append(temp);

        }

        byte[] bypes = params.toString().getBytes();

        connection.getOutputStream().write(bypes);// 输入参数

        //读取返回值
        BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));

        String line;

        String result = "";

        while ((line = in.readLine()) != null) {

            result += line;
        }

        return result;

    }
}
