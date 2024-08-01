<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>공지사항</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<style>
	
</style>
<script type="text/javascript">

	//그룹코드 페이징 설정
	var pageSizeAccSlip = 10; //네비게이션에 표시할 페이지 수
	var pageBlockSizeAccSlip = 10; //그리드에 출력할 목록 수

	//받아온 리스트데이터 호출
	$(document).ready(function() {
		
		comcombo("cust_name", "cust_name", "all"); 

		fAccSlipList();
		
		$("#to_date").change(function() {
			if ($("#to_date").val() < $("#from_date").val()) {
				swal("최소기간 보다 작을수 없습니다.")
				$("#to_date").val('');
			}
		});
	}); 

	//리스트 데이터 받아오기
	function fAccSlipList(currentPage) {
		
		currentPage = currentPage || 1;
		var cust_name = $('#cust_name').val();
		var acct_code = $('#acct_code').val();
		var from_date = $("#from_date").val();
		var to_date = $("#to_date").val();

		var param = {
			currentPage : currentPage,
			pageSizeAccSlip : pageSizeAccSlip,
			cust_name : cust_name,
			acct_code : acct_code,
			from_date : from_date,
			to_date : to_date
		}

		var resultCallback = function(data) {
			fAccSlipResult(data, currentPage);
		};

		callAjax("/accounting/accSlipCallback.do", "post", "text", true, param,resultCallback);
	}

	
	
	//리스트 데이터 출력
	function fAccSlipResult(data, currentPage) {
		console.log("data 값" + data);
		$('#accSlipList').empty();
		$('#accSlipList').append(data);
		
		var accSlipCnt = $("#totalAccSlipCnt").val();
		console.log("accSlipCnt  :  " + accSlipCnt);
		
		//var paginationHtml = getPaginationHtml(currentPage, totalCntComnGrpCod, pageSizeComnGrpCod, pageBlockSizeComnGrpCod, 'fListComnGrpCod');
		var paginationHtml = getPaginationHtml(currentPage, accSlipCnt, pageSizeAccSlip, pageBlockSizeAccSlip, 'fAccSlipList');
		console.log("paginationHtml : " + paginationHtml);

		//swal(paginationHtml);
		$("#accSlipPagination").empty().append(paginationHtml);

		// 현재 페이지 설정
		$("#currentPageAccSlip").val(currentPage);
	}
	
	
	
	function fPopModalAccSlip() {
		
		var cust_name = $('#cust_name').val();
		var acct_code = $('#acct_code').val();
		var from_date = $("#from_date").val();
		var to_date = $("#to_date").val();

		var param = {
			cust_name : cust_name,
			acct_code : acct_code,
			from_date : from_date,
			to_date : to_date
		}

		var resultCallback = function(data) {
			console.log("data 값" + data);
			fAccSlipModalResult(data);
		};

		callAjax("/accounting/accSlipModal.do", "post", "text", true, param,resultCallback);
	}
	
	
	
	//리스트 데이터 출력
	function fAccSlipModalResult(data, currentPage) {
		

		gfModalPop('#layer2');

		$('#accSlipListModal').empty();
		$('#accSlipListModal').append(data);
		
		
}
</script>

</head>
<body>
	<form id="myForm">
	<input type="hidden" id="currentPageAccSlip" value="1">
		<div id="mask"></div>
		<div id="wrap_area">
			<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
			<div id="container">
				<ul style="background-color:white;">
					<li class="lnb">
						<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
					</li>
					<li class="contents">
						<h3 class="hidden">contents 영역</h3>
						<div class="content">
							<p class="Location">
								<a href="" class="btn_set home">메인으로</a>
								<a href="" class="btn_nav">회계</a> 
								<span class="btn_nav bold">회계전표 조회</span> 
								<a href="" class="btn_set refresh">새로고침</a>
							</p>


							<div class="divfAccSlipList">
								<p class="conTitle">
									<span>회계전표 조회</span> 
									<span class="fr" style="margin-top: 3px;"> 
										<span><input type="date" id="from_date"> ~ <input type="date" id="to_date"></span><br> 
										<span>거래처명 <select id="cust_name" style="width: 90px;"></select>
										
										
		                        			<a class="btnType blue" href="javascript:fAccSlipList()"><span id="searchEnter">조회</span></a>
									</span>
								</p>
								<a href="javascript:fPopModalAccSlip()" class="btnType blue fr" id="submitBtn"><span style="margin-bottom: 10px;">상세조회</span></a>
								<table class="col">
									<caption>caption</caption>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">전표번호</th>
											<th scope="col">수주일자</th>
											<th scope="col">계정과목</th>
											<th scope="col">거래처명</th>
											<th scope="col">수입</th>
											<th scope="col">승인자</th>
										</tr>
									</thead>
									<tbody id="accSlipList">
									</tbody>
								</table>
							</div>
								<div class="paging_area" id="accSlipPagination"></div>

							<br> <br>
						</div>
				</ul>
			</div>
		</div>
	</form>
	<div id="layer1" class="layerPop layerType2" style="width: 650px; overflow: auto;"></div>
	
	<form id="myForm">
		<div id="layer2" class="layerPop layerType2" style="width: 900px; top: 111.5px; left: 220px; display: block;">
			<dl>
				<dt>
					<strong>회계전표</strong>
				</dt>
				<dd style="height: auto;">
					<h1 style="font-size: 50px; height: 40px; padding-top: 2%; width: 50%;">회계전표</h1>
					<table class="scrolltbody col" >
						<colgroup>
								<col width="80px">
								<col width="88.75px">
								<col width="123.88px">
								<col width="86.81px">
								<col width="97px">
								<col width="97px">
								<col width="88px">
						</colgroup>
						<thead>
							<tr>
								<th scope="col">전표번호</th>
								<th scope="col">수주일자</th>
								<th scope="col">담당자</th>
								<th scope="col">거래처명</th>
								<th scope="col">계정과목</th>
								<th scope="col">수입</th>
								<th scope="col">비고</th>
							</tr>
						</thead>
						<tbody  scope="col" id="accSlipListModal" class = "accSlipListModal">
						</tbody>
					</table>
					<table  class="scrolltbody col">
					      
					</table>
					<div class="btn_areaC mt20">
						 <a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>
	</form>
</body>
</html>