<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>지출결의서</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

var pageSize = 10;
var blockPage = 5;

/* 버튼 클릭 이벤트 등록 */
function registerBtnEvent() {
	$("#searchBtn").click(function(e) {
		e.preventDefault();
		
		var stDate = document.querySelector('input[name="searchStDate"]');	//시작일
		var edDate = document.querySelector('input[name="searchEdDate"]');	//종료일
		
		//날짜 조회 시, 시작일이 비어있지 않은 경우 종료일은 시작일보다 커야한다.
		if(stDate.value != '' && edDate.value != '' && edDate.value < stDate.value){
			swal("해당 기간의 조회가 불가능합니다.");
			return false;
		}
		
		disbSearch();
	});
	
	$("a[name=btn]").click(function(e) {
		e.preventDefault();
		
		var btnId = $(this).attr("id");

		switch(btnId) {
		case "btnUpdateDisb":
			updateDisb();
			break;	
		case "btnClose":
			gfCloseModal();
			break;
		}
	});

}

$(function() {
	disbSearch();
	registerBtnEvent();
});

function disbSearch(currentPage) {
	currentPage = currentPage || 1;
	
	// 검색 및 페이징 관련 파라미터
	var param = {
		searchStDate : $("#searchStDate").val(),
		searchEdDate : $("#searchEdDate").val(),
		searchAccGroupCode : $("#searchAccGroupCode").val(),
		searchAcctCode : $("#searchAcctCode").val(),
		searchApprYn : $("#searchApprYn").val(),
		currentPage : currentPage,
		pageSize : pageSize
	};
	
	// html 삽입
	var callBackFunction = function(res) {
		// 거래처 목록
		$("#disbList").html(res);
		
		// 페이지 네비게이션
		var pageNavigateHtml = getPaginationHtml(currentPage, $("#totcnt").val(), pageSize, blockPage, "disbSearch");
		$("#pagingNavi").html(pageNavigateHtml);
		$("#currentPage").val(currentPage);
	};

	callAjax("/accounting/disbApprList.do", "post", "text", false, param, callBackFunction);
};

/* 지출결의서 상세 */
function disbDetailModal(resoNum) {
	
	var param = {
		resoNum: resoNum
	}
	
	var callBackFunction = function(data) {
		
		$('#disbApprovalForm')[0].reset();
		$("#preview").empty();
		
		$("#resoNum").val(data.resoNum);
		$("#applyDate").val(data.applyDate);
		$("#useDate").val(data.useDate);
		$("#applyId").val(data.applyId);
		$("#applyName").val(data.applyName);
		$("#applyDept").val(data.applyDept);
		$("#amount").val(data.amount);
		$("#disbContent").val(data.disbContent);
		$("#accGroupCodeNm").val(data.grCodeNm);
		$("#acctCodeNm").val(data.acctCodeNm);
		$("#custName").val(data.custName);

		$("input:radio[name='apprYn']").prop('checked', false);
		if (data.apprYn !== "W") {
			$("input:radio[name='apprYn']:radio[value='"+data.apprYn+"']").prop('checked', true);
		}
		
		if (data.apprDate) {
			$("#apprDate").val(data.apprDate);
		} else {			
			// 승인일자 오늘로 설정
		    var date = new Date();
		    var year = date.getFullYear();
		    var month = (date.getMonth()+1).toString().padStart(2,'0');
		    var day = date.getDate().toString().padStart(2,'0');
		    $("#apprDate").val(year + "-" + month + "-" + day);
		}
		
		if (data.eviMaterial) {		
			var ext = data.fileExt.toLowerCase();
			var imgPath = "";
			var previewHtml = "<a href='javascript:download()'>";
			
			if (ext === "jpg" || ext === "gif" || ext === "png") {
				imgPath = data.logicalPath;
				previewHtml += "<img src='" + imgPath + "' id='imgFile' style='width: 100px; height: 100px;' />";
			} else {
				previewHtml += data.eviMaterial;
			}
			
			previewHtml += "</a>";
			
			$("#preview").html(previewHtml);
		}
	
		gfModalPop("#disbDetailModal");
	} 
	
	callAjax("/accounting/disbDetail.do", "post", "json", false, param, callBackFunction);
}

/* 파일 다운로드 */
function download() {
	var resoNum = $("#resoNum").val()
	
	var params = "<input type='hidden' name='resoNum' value='"+ resoNum +"' />";
	
	$("<form action='disbDownload.do' method='post' id='fileDownload'>" + params + "</form>"
    ).appendTo('body').submit().remove();
}

/* 지출결의서 승인 또는 반려(지출결의서 수정) */
function updateDisb() {
	
	var chk = $('input:radio[name=apprYn]').is(':checked');
	if (!chk) {
		swal("승인여부를 선택하세요.");
		return;
	}
	
	// 승인일자는 항상 오늘 날짜
	var today = new Date();
	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);
	var dateString = year + '-' + month  + '-' + day;
	
	var param = { 
		resoNum : $("#resoNum").val(),
		apprYn : $(":input:radio[name='apprYn']:checked").val(),
		apprDate : dateString,
		disbContent : $("#disbContent").val()
	};
	
	var callBackFunction = function(res) {
		if (res.result === "Success") {
			swal("승인여부가 저장되었습니다.");
			gfCloseModal();
			disbSearch($("#currentPage").val());
		}
	}
	
	callAjax("/accounting/updateDisb.do", "post", "json", false, param, callBackFunction);
}

/* 계정과목 리스트 */
function acctCodeList(accGroupCodeSelBox) {

	// 계정대분류명 selectBox에 따라 계정과목(acct) selectBox 선택 
	var acctSelBox = document.querySelector("select[name=searchAcctCode]");
	
	// 계정과목 select option 목록을 초기화
	$(acctSelBox).find("option").remove();
	
	// 선택된 계정대분류명의 값
	var selectAccGrpCod = accGroupCodeSelBox.value;
	// 계정대분류명의 값이 ALL인 경우, 계정과목 option을 전체로 초기화 후 함수를 빠져나감
	if(selectAccGrpCod === "ALL") {
		$(acctSelBox).append("<option value='ALL' selected>전체</option>");
		return;
	}

	var param = {
			selectAccGrpCod : selectAccGrpCod
	}
	
	var callBackFunction = function(res) {

		$(acctSelBox).append("<option value='ALL' selected>전체</option>");	
		for (var index = 0; index < res.length; index++) {
			var item = res[index];
			
			$(acctSelBox).append("<option value='"+ item.dtl_cod + "' selected>" + item.dtl_cod_nm + "</option>");
		}
		
	};

	callAjax("/accounting/acctCodeList.do", "post", "json", false, param, callBackFunction);
}
</script>
</head>
<body>

	<div id="wrap_area">
		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> 
					<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
				</li>
				
				<li class="contents">
					<!-- content 영역 시작 -->
					<h3 class="hidden">contents 영역</h3>
					<div class="content">
						
						<%-- 상단 메뉴 : 홈 / 회계 / 지출결의서 승인 --%>
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a> 
							<a href="#" class="btn_nav bold">회계</a> 
							<span class="btn_nav bold">지출결의서 조회 및 승인</span> 
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>
						
						<%-- 컨텐츠 타이틀 --%>		
						<p class="conTitle">
							<span>지출결의서 조회 및 승인</span>
						</p>
						
						<div class="container" style="margin-bottom: 10px;">
							<div class="row">
								<div class="col-lg-12">
									<label>신청일자</label>
									<input type="date" id="searchStDate" name="searchStDate" /><span>&nbsp;~&nbsp;</span> 
									<input type="date" id="searchEdDate" name="searchEdDate" />
								</div>
							</div>
							<div class="row">
								<div class="col-lg-3">
									<label>계정대분류명</label>
									<select name="searchAccGroupCode" id="searchAccGroupCode" onchange="acctCodeList(this)">
										<option value="ALL" selected="selected">전체</option>
										<c:forEach items="${accGrpCodList}" var="accGrpCod">
											<option value="${accGrpCod.grp_cod}">${accGrpCod.grp_cod_nm} </option>
										</c:forEach>
									</select>
								</div>
								<div class="col-lg-3">
									<label>계정과목</label>
									<select name="searchAcctCode" id="searchAcctCode">
										<option value="ALL">전체</option>
									</select>
								</div>
								<div class="col-lg-3">
									<label>승인여부</label>
									<select id="searchApprYn">
										<option value="ALL">전체</option>
										<option value="W">승인대기</option>
										<option value="Y">승인</option>
										<option value="N">반려</option>
									</select>
								</div>
								<div class="col-lg-3" style="padding-left: 80px;">
									<a class="btnType gray" name="searchBtn" id="searchBtn"><span>검색</span></a>
								</div>
							</div>
						</div>
					
						<div>
							<table class="col">
								<colgroup>
									<col width="10%">
									<col width="10%">
									<col width="10%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="15%">
									<col width="10%">
								</colgroup>
								<thead>
									<tr>
						              <th scope="col">결의번호</th>
						              <th scope="col">신청일자</th>
						              <th scope="col">사용일자</th>
						              <th scope="col">계정대분류명</th>
						              <th scope="col">계정과목</th>
						              <th scope="col">사용부서</th>
						              <th scope="col">결의금액</th>
						              <th scope="col">승인여부</th>
									</tr>
								</thead>
								<tbody id="disbList"></tbody>
							</table>
							
							<!-- 페이징 영역 -->
							<div class="paging_area" id="pagingNavi">
							</div>				
						</div>
					</div> 
					<!-- content 영역 끝 -->

					<h3 class="hidden">풋터 영역</h3> 
					<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<%-- 지출결의서 상세 모달 / 폼 --%>
	<form id="disbApprovalForm" action="" method="" enctype="multipart/form-data">
		<input type="hidden" id="currentPage" value="1">
		<div id="disbDetailModal" class="layerPop layerType2" style="width: 1000px;">
			<dl>
				<dt>
					<strong>지출결의서 상세</strong>
				</dt>
				<dd class="content">
					<table class="row">
						<colgroup>
		                    <col width="15%">
		                    <col width="20%">
		                    <col width="15%">
		                    <col width="20%">
		                    <col width="15%">
		                    <col width="20%">
	                    </colgroup>
						<tbody>
							<tr>
								<th scope="row">결의번호</th>
								<td>
									<input type="text" class="inputTxt" name="resoNum" id="resoNum" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">신청일자</th>
								<td>
									<input type="date" class="inputTxt" name="applyDate" id="applyDate" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">사용일자 </th>
								<td>
									<input type="date" class="inputTxt" name="useDate" id="useDate" value="" readonly="readonly" style="background-color: #eee;"/>
								</td>
							</tr>
							<tr>
								<th scope="row">사번</th>
								<td>
									<input type="text" class="inputTxt" name="applyId" id="applyId" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">사원명</th>
								<td>
									<input type="text" class="inputTxt" name="applyName" id="applyName" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">사용부서</th>
								<td>
									<input type="text" class="inputTxt" name="applyDept" id="applyDept" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
							</tr>
							<tr>
								<th scope="row">계정대분류명</th>
								<td>
									<input type="text" class="inputTxt" name="accGroupCodeNm" id="accGroupCodeNm" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">계정과목</th>
								<td>
									<input type="text" class="inputTxt" name="acctCodeNm" id="acctCodeNm" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">거래처명</th>
								<td>
									<input type="text" class="inputTxt" name="custName" id="custName" value="" readonly="readonly" style="background-color: #eee;" />
								</td>
							</tr>
							<tr>
								<th scope="row">결의금액</th>
								<td>
									<input type="text" class="inputTxt" name="amount" value="" id="amount" />
								</td>
								<th scope="row">승인여부</th>
								<td>
									<input type="radio" id="apprY" name="apprYn" value="Y" /> <label>승인</label>&nbsp;
									<input type="radio" id="apprN" name="apprYn" value="N" /> <label>반려</label>
								</td>
								<th scope="row">승인일자</th>
								<td>
									<input type="date" class="inputTxt" name="apprDate" id="apprDate" readonly="readonly" style="background-color: #eee;" />
								</td>
							</tr>
                    		<tr>
		                        <th scope="row">첨부파일</th>
		                        <td colspan="5">
		                           <div id="preview"></div>
		                        </td>
	                     	</tr>
                    		<tr>
								<th scope="row">비고</th>
								<td colspan="5">
									<textarea class="inputTxt p100" name="disbContent" id="disbContent">
									</textarea>
								</td>
							</tr>
						</tbody>
					</table>

					<%-- 저장/수정/삭제 버튼 --%>
					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnUpdateDisb" name="btn"><span>저장</span></a>
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>
	</form>

</body>
</html>