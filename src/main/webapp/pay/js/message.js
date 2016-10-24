function alertWin(title, msg, w, h, fun){     
    var titleheight = 23; // 提示窗口标题高度     
    var bordercolor = "#3A9D9A"; // 提示窗口的边框颜色     
    var titlecolor = "#FFFFFF"; // 提示窗口的标题颜色     
    var titlebgcolor = "#3A9D9A"; // 提示窗口的标题背景色    
    var bgcolor = "#FFFFFF"; // 提示内容的背景色    
    var bottomheight=35;
    var iWidth = document.documentElement.offsetWidth;    
    var iHeight =document.body.scrollTop | document.documentElement.scrollTop;  
    iHeight=iHeight+100;
    var bgObj = document.createElement("div");     
    bgObj.style.cssText = "position:absolute;left:0px;top:0px;width:"+document.documentElement.scrollWidth+"px;height:"+document.body.scrollHeight+"px;opacity:0.6;background-color:#000000;z-index:101;";    
    document.body.appendChild(bgObj);     //设置遮罩层
    var msgObj=document.createElement("div");  
    var widths=iWidth/2-120;
    msgObj.style.cssText = "position:absolute;font:11px;top:"+iHeight+"px;left:"+widths+"px;width:"+w+"px;height:"+h+"px;text-align:center;border:0px solid "+bordercolor+";background-color:"+bgcolor+";line-height:22px;z-index:102;font-family: Helvetica;font-weight:bold;";    
    document.body.appendChild(msgObj);    //设置弹出层
//    var table = document.createElement("table");    
//    msgObj.appendChild(table);    
//    table.style.cssText = "margin:0px;border:0px;padding:0px;";    
//    table.cellSpacing = 0;    
//    var tr = table.insertRow(-1);    
//    var titleBar = tr.insertCell(-1);    
//    titleBar.style.cssText = "width:100%;height:"+titleheight+"px;text-align:left;padding-top:0px;margin:0px;font:bold 13px 'Helvetica';color:"+titlecolor+";border:1px solid " + bordercolor + ";cursor:move;background-color:" + titlebgcolor;    
//    titleBar.style.paddingLeft = "10px";    
//    titleBar.innerHTML = title;    //设置table标题
//
//        
//    var closeBtn = tr.insertCell(-1);    
//    closeBtn.style.cssText = "cursor:pointer; padding:2px;background-color:" + titlebgcolor;    
//    closeBtn.innerHTML = "<span id='closebtn1' style='font-size:15pt; color:"+titlecolor+";'>×</span>";  //设置关闭图标  
//
//
//    var msgBox = table.insertRow(-1).insertCell(-1);    
//    msgBox.style.cssText = "font:10pt 'Helvetica';";    
//    msgBox.colSpan  = 2;    
//    msgBox.innerHTML ="<br/><center>"+msg+ "</center><button id='closebtn' style=' height:22px;width:50px;background:#3A9D9A;color:#FFFFFF;border-radius: 2px;float:left;margin-top:10%;margin-left:10px;border:0px' />OK</botton>";
//       
    var titlediv= document.createElement("div");    
    msgObj.appendChild(titlediv); 
    titlediv.style.cssText = "background-color:"+bordercolor+";width:100%;height:"+titleheight+"px;text-align:left;font:bold 13px 'Helvetica';color:"+titlecolor+";line-height:23px;padding-left:15px";    
    titlediv.innerHTML = title; 
    var closediv= document.createElement("div");  
    titlediv.appendChild(closediv); 
    closediv.style.cssText = "float:right;margin-right:10px";
    closediv.innerHTML = "<span id='closebtn1' style='font-size:15pt; color:"+titlecolor+";'>×</span>";  //设置关闭图标  
    
    var contentdiv= document.createElement("div");  
    msgObj.appendChild(contentdiv); 
    var contentheight=h-titleheight-bottomheight-15;
    contentdiv.style.cssText ="margin-top:15px;margin-left:15px;margin-right:15px;width:220px;height:"+contentheight+"px;word-wrap: break-word;font:10pt 'Helvetica';";
    contentdiv.innerHTML =msg;
    
    var closebuttom= document.createElement("div");  
    msgObj.appendChild(closebuttom); 
    closebuttom.style.cssText ="width:220px;height:"+bottomheight+"px;font:10pt 'Helvetica';position:absolute;padding-left:15px;padding-right:15px;padding-buttom:15px;";
    closebuttom.innerHTML ="<button id='closebtn' style=' height:20px;width:50px;background:#3A9D9A;color:#FFFFFF;border-radius: 2px;float:left;border:0px' />OK</botton>";
    
    
    document.getElementById("closebtn").onclick = function(){     
        document.body.removeChild(bgObj);     
        document.body.removeChild(msgObj);   
        if(fun != null){
        	fun();
        }
    }  
    
    document.getElementById("closebtn1").onclick = function(){     
        document.body.removeChild(bgObj);     
        document.body.removeChild(msgObj);     
    }  
    // 获得事件Event对象，用于兼容IE和FireFox    
    function getEvent() {    
        return window.event || arguments.callee.caller.arguments[0];    
    }    
}     
