/**
 * 
 */
package com.eliteams.pay.web.publicAPI;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;

import com.eliteams.pay.web.publicImpl.TrendChartImpl;
import com.eliteams.pay.web.util.JSONUtil;
import com.eliteams.pay.web.util.URLRequest;

/**
 * TrendChart Copyright 2015 SMM, Inc. All Rights Reserved.
 * 
 * @author Yuanmeng at 2015年10月10日
 */
public class TrendChart implements TrendChartImpl {

    private static final Logger logger            = Logger.getLogger(TrendChart.class);

    private final static String dayTrendByTimeURL = "http://172.16.9.16:8080/smmdb/product/priceTrend";

    /*
     * 传入参数为 产品Id 趋势图开始时间 和 结束时间
     */
    @Override
    public String dayTrendChart(HttpServletRequest req, String productId, String beginTime, String endTime, String unit) {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("productID", productId);
        Map<String, String> requestDate = new HashMap<>();

        requestDate.put("productId", productId);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        requestDate.put("beginDate", sdf.format(beginTime));
        requestDate.put("endDate", sdf.format(endTime));

        String resultData = null;

        try {
            resultData = URLRequest.get(dayTrendByTimeURL, requestDate);

            JSONObject jasonObject = JSONObject.fromObject(resultData);
            Map<?, ?> pmt = (Map<?, ?>) jasonObject;
            List<Object[]> seriesVal = new ArrayList<>();

            if (pmt != null) {
                if (pmt.get("code") != null && pmt.get("code").toString().equals("1")) {
                    //数据处理
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> lm = (List<Map<String, Object>>) pmt.get("data");
                    Object series[] = null;

                    if (lm != null && lm.size() > 0) {
                        NumberFormat nbf = NumberFormat.getInstance();
                        nbf.setGroupingUsed(false);
                        double maxPrice = 0;
                        double minPrice = 0;

                        for (int i = 0; i < lm.size(); i++) {
                            series = new Object[2];
                            double price = ((double) lm.get(i).get("highs") + (double) lm.get(i).get("low")) / 2;
                            String date = (String) lm.get(i).get("renew_date");
                            // 							series[0]=Integer.parseInt(date.replace("-", ""));
                            // 							series[1]=price;
                            // 							seriesVal.add(series);

                            series[0] = sdf.parse(date).getTime();
                            series[1] = price;
                            seriesVal.add(series);
                            if (minPrice > price || minPrice == 0) {
                                minPrice = price;
                            }
                            if (maxPrice < price) {
                                maxPrice = price;
                            }
                        }
                        String temp1 = (String) lm.get(lm.size() - 1).get("renew_date");
                        String temp2 = (String) lm.get(0).get("renew_date");
                        //						result.put("minDate",Integer.parseInt(temp1.replace("-", "")));
                        //						result.put("maxDate",Integer.parseInt(temp2.replace("-", "")));
                        result.put("minDate", sdf.parse(temp1).getTime());
                        result.put("maxDate", sdf.parse(temp2).getTime());
                        result.put("unit", unit);
                        result.remove("nodata");

                        result.put("seriesVal", JSONUtil.doConvertObject2Json(seriesVal).replaceAll("\"", ""));
                        result.put("minPrice", minPrice);
                        result.put("maxPrice", maxPrice);
                        result.put("itemName", "thrend chart");
                        return JSONObject.fromObject(result).toString();
                    } else {
                        logger.info("没有数据.....");
                    }

                } else {
                    logger.info(pmt.get("errorMsg"));
                    result.put("msg", pmt.get("errorMsg"));
                }

            } else {
                logger.info("接口调用异常......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("获取指定品类价格走势调用发生异常");
        }
        result.put("nodata", "yes");
        return JSONObject.fromObject(result).toString();

    }

    /*
     * (non-Javadoc)
     * @see
     * com.eliteams.metal3g.web.publicImpl.TrendChartImpl#monthTrendChart(javax
     * .servlet.http.HttpServlet, java.lang.String, int)
     */
    @Override
    public String monthTrendChart(HttpServletRequest req, String productId, int month, String unit) {
        Map<String, Object> result = new HashMap<String, Object>();

        result.put("productID", productId);
        Map<String, String> requestDate = new HashMap<>();

        requestDate.put("productId", productId);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        Date endTime = calendar.getTime();
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH) - month);
        Date startTime = calendar.getTime();
        requestDate.put("beginDate", sdf.format(startTime));
        requestDate.put("endDate", sdf.format(endTime));

        String resultData = null;

        try {
            resultData = URLRequest.get(dayTrendByTimeURL, requestDate);

            JSONObject jasonObject = JSONObject.fromObject(resultData);
            Map<?, ?> pmt = (Map<?, ?>) jasonObject;
            List<Object[]> seriesVal = new ArrayList<>();

            if (pmt != null) {
                if (pmt.get("code") != null && pmt.get("code").toString().equals("1")) {
                    //数据处理
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> lm = (List<Map<String, Object>>) pmt.get("data");
                    Object series[] = null;

                    if (lm != null && lm.size() > 0) {
                        NumberFormat nbf = NumberFormat.getInstance();
                        nbf.setGroupingUsed(false);
                        double maxPrice = 0;
                        double minPrice = 0;

                        for (int i = 0; i < lm.size(); i++) {
                            series = new Object[2];
                            double price = ((double) lm.get(i).get("highs") + (double) lm.get(i).get("low")) / 2;
                            String date = (String) lm.get(i).get("renew_date");
                            // 							series[0]=Integer.parseInt(date.replace("-", ""));
                            // 							series[1]=price;
                            // 							seriesVal.add(series);

                            series[0] = sdf.parse(date).getTime();
                            series[1] = price;
                            seriesVal.add(series);
                            if (minPrice > price || minPrice == 0) {
                                minPrice = price;
                            }
                            if (maxPrice < price) {
                                maxPrice = price;
                            }
                        }
                        String temp1 = (String) lm.get(lm.size() - 1).get("renew_date");
                        String temp2 = (String) lm.get(0).get("renew_date");
                        //						result.put("minDate",Integer.parseInt(temp1.replace("-", "")));
                        //						result.put("maxDate",Integer.parseInt(temp2.replace("-", "")));
                        result.put("minDate", sdf.parse(temp1).getTime());
                        result.put("maxDate", sdf.parse(temp2).getTime());
                        result.put("unit", unit);
                        result.remove("nodata");

                        result.put("seriesVal", JSONUtil.doConvertObject2Json(seriesVal).replaceAll("\"", ""));
                        result.put("minPrice", minPrice);
                        result.put("maxPrice", maxPrice);
                        result.put("itemName", month + " month chart");
                        return JSONObject.fromObject(result).toString();
                    } else {
                        logger.info("没有数据.....");
                    }

                } else {
                    logger.info(pmt.get("errorMsg"));
                    result.put("msg", pmt.get("errorMsg"));
                }

            } else {
                logger.info("接口调用异常......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("获取指定品类价格" + month + "个月走势调用发生异常");
        }
        result.put("nodata", "yes");
        return JSONObject.fromObject(result).toString();

    }

}
