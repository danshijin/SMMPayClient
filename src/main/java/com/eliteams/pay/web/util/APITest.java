package com.eliteams.pay.web.util;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.junit.Test;

/**
 * Created by zhenghao on 2015/9/29.
 */
public class APITest {

    private static String host = "http://172.16.9.16:8080/smmdb/";

    /**
     * 查询指定产品价格走势，返回结果为每天数据
     * 
     * @throws Exception
     */
    @Test
    public void testPriceTrendByDate() throws Exception {

        String url = "product/priceTrend";

        Map<String, String> map = new HashMap<>();

        map.put("productId", "201102250311");
        map.put("beginDate", "2014-01-01");
        map.put("endDate", "2014-12-31");

        try {

            String result = URLRequest.get(APITest.host + url, map);

            JSONObject jasonObject = JSONObject.fromObject(result);
            Map resultMap = (Map) jasonObject;

            System.out.println(resultMap);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 查询指定产品价格走势，返回结果为每周平均数据
     * 
     * @throws Exception
     */
    @Test
    public void testPriceTrendByWeek() throws Exception {

        String url = "product/priceTrendByWeek";

        Map<String, String> map = new HashMap<>();

        map.put("productId", "201102250311");
        map.put("beginDate", "2014-01-01");
        map.put("endDate", "2014-12-31");

        try {

            String result = URLRequest.get(APITest.host + url, map);

            System.out.println(result);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 查询指定产品价格走势，返回结果为每月平均数据
     * 
     * @throws Exception
     */
    @Test
    public void testPriceTrendByMonth() throws Exception {

        String url = "product/priceTrendByMonth";

        Map<String, String> map = new HashMap<>();

        map.put("productId", "201102250311");
        map.put("beginDate", "2014-01-01");
        map.put("endDate", "2014-12-31");

        try {

            String result = URLRequest.get(APITest.host + url, map);

            System.out.println(result);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
