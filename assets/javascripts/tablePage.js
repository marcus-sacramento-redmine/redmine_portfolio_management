function pageTable(page,pageId) {
	var t = document.getElementById(pageId);
	var res;
	if (page=="previous") {
		res=Table.pagePrevious(t);
	}
	else if (page=="next") {
		res=Table.pageNext(t);
	}
	else {
		res=Table.page(t,page);
	}
	var currentPage = res.page+1;
	$('.pagelink').removeClass('currentpage');
	$('#page'+currentPage).addClass('currentpage');
}
