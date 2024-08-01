<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>미수금관리</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<style>
.container label {
	display: inline-block;
	width: 47px;
}

.container input {
	width: 160px;
}
</style>

<script type="text/javascript">
var pageSize = 10;
var blockPage = 10;

$(function() {
	search();

	$("#btnSearch").click(function(e) {
		e.preventDefault();
		
		search();
	});
	
	$("#endDate").change(function(e) {
		var startDate = $("#startDate").val();
		
		if (startDate && startDate > $("#endDate").val()) {
			alert("마지막일은 시작일보다 크거나 같아야합니다.");
			$("#endDate").val('');
		}
	});
	
	$("#startDate").change(function(e) {
		var endDate = $("#endDate").val();
		
		if (endDate && $("#startDate").val() > endDate) {
			alert("시작일은 마지막일보다 작거나 같아야합니다.");
			$("#startDate").val('');
		}
	});
});

function search(currentPage) {
	currentPage = currentPage || 1;
	
	var params = {
		startDate: $("#startDate").val(),
		endDate: $("#endDate").val(),
		expireState: $("#expireState").val(),
		paidState: $("#paidState").val(),
		product: $("#product").val(),
		account: $("#account").val(),
		processObject: $("#processObject").val(),
		currentPage: currentPage,
		pageSize: pageSize
	}
	
	function callback(res) {
		$("#list").html(res);
		
		var pageNavigateHtml = getPaginationHtml(currentPage, $("#totalCount").val(), pageSize, blockPage, "search");
		$("#pagingNavi").html(pageNavigateHtml);
		$("#currentPage").val(currentPage);
	}

	callAjax("/accounting/searchUnpaid.do", "post", "text", false, params, callback);
}

function openModal(type, num) {
	var params = {
		type: type,
		num: num
	}
	
	function callback(res) {
		$("#modal").html(res);
		
		gfModalPop("#modal");
	}
	
	callAjax("/accounting/unpaidDetail.do", "post", "text", false, params, callback);
}

function btnDepositHandler(num) {
	if (window.confirm("입금 처리하시겠습니까?")) {
		var params = {
			num: num
		}
		
		function callback(res) {
			if (res.result === "success") {
				alert('입금 처리가 완료되었습니다.');
				
				gfCloseModal();
				
				search($("#currentPage").val());
			} else {
				alert('입금 처리를 실패했습니다.');
			}
		}
		
		callAjax("/accounting/depositUnpaid.do", "post", "json", false, params, callback);
	}
}

function btnCloseHandler() {
	gfCloseModal();
}
</script>
</head>
<body>
	<input id="currentPage" type="hidden" />
	<div id="wrap_area">
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
		<div id="container">
			<ul>
				<li class="lnb">
					<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
				</li>
				<li class="contents">
					<div class="content">
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a>
							<a href="#" class="btn_nav bold">매출</a>
							<span class="btn_nav bold">미수금관리</span>
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>
						<div class="content-title">
							<span>미수금관리</span>
							<div class="container">
								<div class="row">
									<div class="column-50">
										<label for="startDate">수주일자</label>
										<input type="date" id="startDate" />
										~
										<input type="date" id="endDate" />
									</div>
									<div class="column-25">
										<label for="expireState">납품상태</label>
										<select id="expireState">
											<option value="all">전체</option>
											<option value="N">납품미완료</option>
											<option value="Y">남품완료</option>
										</select>
									</div>
									<div class="column-25">
										<label for="paidState">수금상태</label>
										<select id="paidState">
											<option value="all">전체</option>
											<option value="N">미수금</option>
											<option value="Y">수금완료</option>
										</select>
									</div>
								</div>
								<div class="row">
									<div class="column-25 m-0">
										<label for="product" style="white-space: pre-line; letter-spacing: 4px;">포함된<br />제품명</label>
										<input type="text" id="product" />
									</div>
									<div class="column-25">
										<label for="account" style="width: 50px;">거래처 명</label>
										<input type="text" id="account" />
									</div>
									<div class="column-25">
									<label for="processObject">처리주체</label>
										<select id="processObject">
											<option value="all">전체</option>
											<option value="estm">견적서</option>
											<option value="obtain">SCM 수주</option>
										</select>
									</div>
									<div class="column-25 align-end">
										<a class="btnType red" href="" id="btnSearch"><span>검색</span></a>
									</div>
								</div>
							</div>
						</div>
						<p style="padding: 0 0 8px 8px; font-size: 11px; color: gray;">※  번호 : 처리 주체가 견적서일 때는 견적서 번호, SCM 수주일 때는 수주 시퀀스</p>
						<div>
							<table class="col">
								<colgroup>
					            	<col width="12%" />
					            	<col width="12%" />
					            	<col width="12%" />
					            	<col width="12%" />
					            	<col width="13%" />
					            	<col width="13%" />
					            	<col width="13%" />
					            	<col width="13%" />
				                </colgroup>
								<thead>
									<tr>
							            <th scope="col">번호</th>
							            <th scope="col">처리주체</th>
							            <th scope="col">거래처</th>
							            <th scope="col">금액</th>
							            <th scope="col">수주일</th>
							            <th scope="col">납품상태</th>
							            <th scope="col">수금상태</th>
							            <th scope="col">담당자</th>
									</tr>
								</thead>
								<tbody id="list"></tbody>
							</table>
							<div class="paging_area" id="pagingNavi"></div>				
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="modal" class="layerPop layerType2" style="width: 800px;"></div>
</body>
</html>
