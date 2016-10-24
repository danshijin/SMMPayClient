/**
 * 
 */
package com.eliteams.pay.web.publicImpl;

import javax.servlet.http.HttpServletRequest;

/**
 * TrendChart Copyright 2015 SMM, Inc. All Rights Reserved.
 * 
 * @author Yuanmeng at 2015年10月10日
 */
public interface TrendChartImpl {

    public String dayTrendChart(HttpServletRequest req, String productId, String beginTime, String endTime, String unit);

    public String monthTrendChart(HttpServletRequest req, String productId, int month, String unit);

}
