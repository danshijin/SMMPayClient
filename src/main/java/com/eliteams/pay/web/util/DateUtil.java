package com.eliteams.pay.web.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * @author zengshihua
 */
public class DateUtil {

    // 格式化当前系统日期
    public static String getDateWidthFormat(String format) {
        if (format == null || format.equals("")) {
            format = "yyyy-MM-dd HH:mm:ss";
        }

        SimpleDateFormat dateFm = new SimpleDateFormat(format);
        String dateTime = dateFm.format(new java.util.Date());
        return dateTime;
    }

    // 格式化日期
    public static String doFormatDate(Date date, String format) {
        if (format == null || format.equals("")) {
            format = "yyyy-MM-dd HH:mm:ss";
        }

        if (date == null) {
            date = new Date();
        }

        SimpleDateFormat dateFm = new SimpleDateFormat(format);
        String dateTime = dateFm.format(date);
        return dateTime;
    }

    // 转化时间字符串为日期
    public static Date doSFormatDate(String dateStr, String format) {
        if (dateStr.equals("")) {
            return null;
        }
        if (format == null || format.equals("")) {
            format = "yyyy-MM-dd HH:mm:ss";
        }

        SimpleDateFormat dateFm = new SimpleDateFormat(format);
        Date date = null;
        try {
            date = dateFm.parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }

    public static String doFormatDate(Date oldDate, Date newDate) {
        Calendar oldCal = Calendar.getInstance();
        Calendar newCal = Calendar.getInstance();
        oldCal.setTime(oldDate);
        newCal.setTime(newDate);
        if (oldCal.equals(newCal)) {
            return "";
        } else if (oldCal.before(newCal)) {
            return "";
        } else if (oldCal.after(newCal)) {
            return "";
        } else {
            return "";
        }

    }

    public static int getMinute() {
        Calendar calendar = Calendar.getInstance();
        int minute = calendar.get(Calendar.MINUTE);
        return minute;
    }

    //	public static String dateFormat2En(Date date){
    //		SimpleDateFormat sdf = new SimpleDateFormat("MMM dd,yyyy",Locale.UK);
    //		return sdf.format(date);
    //	};

    public static String dateFormat2En(String time) {
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd,yyyy", Locale.UK);
        return sdf.format(new Date(Long.parseLong(time + "000")));
    };

    /**
     * 天数加减
     * 
     * @param days加减天数，如：+1就是日期的后一天，-1就是日期的前一天
     * @param format 转换的格式
     * @param date 日期
     * @return
     */
    public static String dateAddAndSubtract(String days, String format, String date) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            Date now = sdf.parse(date);
            Calendar cal = Calendar.getInstance();
            cal.setTime(now);
            cal.add(Calendar.DATE, Integer.parseInt(days));//取当前日期的后一天
            return sdf.format(cal.getTime());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    };

    /**
     * 月份加减
     * 
     * @param days加减天数，如：+1就是日期的后一天，-1就是日期的前一天
     * @param format 格式
     * @param date 日期
     * @return
     */
    public static String monthAddAndSubtract(String months, String format, String date) {

        try {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            Date now = sdf.parse(date);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(now);
            calendar.add(Calendar.MONTH, Integer.parseInt(months));
            return sdf.format(calendar.getTime());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;

    }

    public static void main(String[] args) {
        //System.out.println(dateAddAndSubtract("7", "yyyy-MM-dd", "2015-11-11"));
        System.out.println(monthAddAndSubtract("2", "yyyy-MM-dd", "2015-11-11"));
    }

}
