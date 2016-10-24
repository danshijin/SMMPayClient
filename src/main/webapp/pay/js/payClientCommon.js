function makeDivCenterInWindow(elementId){
	elementId = "#" + elementId;
	var top = ($(window).height() - $(elementId).outerHeight()) / 2;
	var left = ($(window).width() - $(elementId).outerWidth()) / 2;
	top = top < 0 ? 0 : top;
	left = left < 0 ? 0 : left;
	$(elementId).css("top", top + "px");
	$(elementId).css("left", left + "px");
}