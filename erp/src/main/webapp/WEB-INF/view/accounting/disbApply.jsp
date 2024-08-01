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
		case "btnSaveDisb":
			saveDisb();
			break;
		case "btnDeleteDisb":
			deleteDisb();
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
	filePreview();
	
	$("#amount").on("keyup", function() {
		$(this).val($(this).val().replace(/[^0-9]/g, '').replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
	});
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

	callAjax("/accounting/disbList.do", "post", "text", false, param, callBackFunction);
};

/* 지출결의서 등록 모달 */
function disbInsertModal() {
	
	$("#disbApplyFormTitle").text("지출결의서 신청");

	// 특정 폼 리셋
	$('#disbApplyForm')[0].reset();
	$("#trPreview").attr('style', "display: none;");
	$("#amount").prop('readonly', false);
	$("#disbContent").prop('readonly', false);
	$("#useDate").prop('readonly', false);
	$("#selAccGroupCode").prop("disabled", false);
	$("#custId").prop("disabled", false);
	
	$("#inputAcctCode").remove();
	$("#selAcctCode").find("option").remove();
	$("#selAcctCode").append("<option value='' selected='selected' disabled='disabled'>선택</option>").show();
	
	// 사용일자 오늘 이후로 선택 못하게 하기
	var now_utc = Date.now() // 지금 날짜를 밀리초로
	// getTimezoneOffset()은 현재 시간과의 차이를 분 단위로 반환
	var timeOff = new Date().getTimezoneOffset()*60000; // 분단위를 밀리초로 변환
	// new Date(now_utc-timeOff).toISOString()은 '2022-05-11T18:09:38.134Z'를 반환
	var today = new Date(now_utc-timeOff).toISOString().split("T")[0];
	document.getElementById("useDate").setAttribute("max", today);
	
    // 신청일자 오늘로 설정
    var date = new Date();
    var year = date.getFullYear();
    var month = (date.getMonth()+1).toString().padStart(2,'0');
    var day = date.getDate().toString().padStart(2,'0');
    $("#applyDate").val(year + "-" + month + "-" + day);

	$("#btnSaveDisb").show();
	$("#btnDeleteDisb").hide();
	
	gfModalPop("#disbInsertModal");
};

/* 지출결의서 등록 */
function saveDisb() {
	if(!disbVal()) {
		return;
	}
	
	var getForm = document.getElementById("disbApplyForm");
	var formData = new FormData(getForm);

	var callBackFunction = function(res) {
		if (res.result === "Success") {
			swal("신청되었습니다.");
			gfCloseModal();
			disbSearch($("#currentPage").val());
		}
	}
	
	callAjaxFileUploadSetFormData("/accounting/saveDisb.do", "post", "json", false, formData, callBackFunction)
}

/* 지출결의서 validation */
function disbVal() {
	
	var chkNV = checkNotValue([
           	[ "selAccGroupCode", "계정대분류명을 선택해 주세요." ]
	]);
	
	var chkNE = checkNotEmpty([
           	[ "useDate", "사용일자를 선택해 주세요." ],
           	[ "amount", "금액을 입력해 주세요." ]
   	]);	
	
	if (!chkNV || !chkNE) {
		return;
	}
	
	return true;
}

/* 지출결의서 상세 */
function disbDetailModal(resoNum) {
	
	var param = {
		resoNum: resoNum
	}
	
	var callBackFunction = function(data) {
	
		$("#disbApplyFormTitle").text("지출결의서 상세");
		
		$('#disbApplyForm')[0].reset();
		$("#btnSaveDisb").hide();
		$("#btnDeleteDisb").show();
		
		$("#resoNum").val(data.resoNum);
		$("#applyDate").val(data.applyDate);
		$("#useDate").val(data.useDate).prop('readonly', true);
		$("#applyId").val(data.applyId);
		$("#applyName").val(data.applyName);
		$("#applyDept").val(data.applyDept);
		$("#amount").val(data.amount).prop('readonly', true);
		$("#disbContent").val(data.disbContent).prop('readonly', true);
		$("#selAccGroupCode").val(data.groupCode).prop("disabled", true);
		
		// 계정과목 selBox 숨김
		$("#selAcctCode").hide();
		
		// 계정과목 input이 있다면 지움(초기화)
		$("#inputAcctCode").remove();
		$("#acctCode").append("<input type='text' class='inputTxt' id='inputAcctCode' value="+data.acctCodeNm+" readonly='readonly' style='background-color: #eee;' />");
		if (data.custId) {
			$("#custId").val(data.custId).prop("disabled", true);
		} else {
			$("#custId").val("").prop("disabled", true);
		}
	
		if (data.apprYn === "Y") {
			$("#apprYn").val("승인");
			$("#apprDate").val(data.apprDate);
			$("#btnDeleteDisb").hide();
		} else if (data.apprYn === "N") {
			$("#apprYn").val("반려");
			$("#apprDate").val(data.apprDate);
			$("#btnDeleteDisb").hide();
		} else {
			$("#apprYn").val("승인대기");
		}			
		
		if (data.eviMaterial) {
			$("#trPreview").attr('style', "display:'';");
			
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
	
		gfModalPop("#disbInsertModal");
	} 
	
	callAjax("/accounting/disbDetail.do", "post", "json", false, param, callBackFunction);
}

/* 지출결의서 삭제 */
function deleteDisb() {
	var param = {
		resoNum: $("#resoNum").val()
	}
	
	var chk = confirm("삭제하시겠습니까?");
	if(!chk) {
		return;
	}

	var callBackFunction = function(res) {
		if (res.result === "Success") {
			swal("삭제되었습니다.");
			gfCloseModal();
			disbSearch($("#currentPage").val());
		} else if (res.result === "Fail") {
			swal("삭제할 수 없습니다.");
			gfCloseModal();
			disbSearch($("#currentPage").val());
		} 
	}
	
	callAjax("/accounting/deleteDisb.do", "post", "json", false, param, callBackFunction);		

}

/* 파일 미리보기 */
function filePreview() {
	$("#fileInput").change(function(e) {
		e.preventDefault();
		$("#trPreview").attr('style', "display: none;");
		
		if ($(this)[0].files[0]) {
			var fileInfo = $("#fileInput").val();
			var fileInfoSplit = fileInfo.split(".");
			var fileLowerCase = fileInfoSplit[1].toLowerCase();
			
			var imgPath = "";
			var previewHtml = "";
			
			if (fileLowerCase === "jpg" || fileLowerCase === "gif" || fileLowerCase === "png") {
				$("#trPreview").attr('style', "display:'';");
				imgPath = window.URL.createObjectURL($(this)[0].files[0]);
				
				previewHtml = "<img src='" + imgPath + "' id='imgFile' style='width: 100px; height: 100px;' />";
			}
			
			$("#preview").html(previewHtml);
		}
	});
}

/* 파일 다운로드 */
function download() {
	var resoNum = $("#resoNum").val()
	
	var params = "<input type='hidden' name='resoNum' value='"+ resoNum +"' />";
	
	$("<form action='disbDownload.do' method='post' id='fileDownload'>" + params + "</form>"
    ).appendTo('body').submit().remove();
}

/* 계정과목 리스트 */
function acctCodeList(accGroupCodeSelBox) {

	// 계정대분류명 selectBox에 따라 계정과목(acct) selectBox 선택 
	var acctSelBox = accGroupCodeSelBox.name === "selAccGroupCode" ?
			document.querySelector("select[name=selAcctCode]") :
			document.querySelector("select[name=searchAcctCode]");
	
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
		// 계정과목 selectBox가 searchAcctCode인 경우 전체 선택 옵션을 추가
		if(acctSelBox.name === "searchAcctCode") {
			$(acctSelBox).append("<option value='ALL' selected>전체</option>");
		}
		
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
						
						<%-- 상단 메뉴 : 홈 / 회계 / 지출결의서 신청 --%>
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a> 
							<a href="#" class="btn_nav bold">회계</a> 
							<span class="btn_nav bold">지출결의서 조회 및 신청</span> 
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>
						
						<%-- 컨텐츠 타이틀 --%>		
						<p class="conTitle">
							<span>지출결의서 조회 및 신청</span> 
							<%-- .fr {float: right;} : 오른쪽에 배치 --%>				
							<span class="fr"> 
								<a class="btnType blue" href="javascript:disbInsertModal();" name="modal"><span>신규 등록</span></a>
							</span>
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
					
						<div class="divdisbApplyList">
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

	<%-- 지출결의서 등록 모달 / 폼 --%>
	<form id="disbApplyForm" action="" method="post" enctype="multipart/form-data">
		<input type="hidden" id="currentPage" value="1">
		<div id="disbInsertModal" class="layerPop layerType2" style="width: 1000px;">
			<dl>
				<dt>
					<strong id="disbApplyFormTitle">지출결의서 신청</strong>
				</dt>
				<dd class="content">
					<table class="row" id="disbApplyTable">
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
									<input type="text" class="inputTxt" name="resoNum" id="resoNum" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">신청일자</th>
								<td>
									<input type="date" class="inputTxt" name="applyDate" id="applyDate" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">사용일자 <span class="font_red">*</span></th>
								<td>
									<input type="date" class="inputTxt" name="useDate" id="useDate" />
								</td>
							</tr>
							<tr>
								<th scope="row">사번</th>
								<td>
									<input type="text" class="inputTxt" name="applyId" id="applyId" value="${userInfo.loginId}" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">사원명</th>
								<td>
									<input type="text" class="inputTxt" name="applyName" id="applyName" value="${userInfo.name}" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">사용부서</th>
								<td>
									<input type="text" class="inputTxt" name="applyDept" id="applyDept" value="${userInfo.deptName}" readonly="readonly" style="background-color: #eee;" />
								</td>
							</tr>
							<tr>
								<th scope="row">계정대분류명 <span class="font_red">*</span></th>
								<td>
									<select class="inputTxt" name="selAccGroupCode" id="selAccGroupCode" onchange="acctCodeList(this)">
									<option value="" selected="selected" disabled="disabled">선택</option>
										<c:forEach items="${accGrpCodList}" var="accGrpCod">
											<option value="${accGrpCod.grp_cod}">${accGrpCod.grp_cod_nm} </option>
										</c:forEach>
									</select>
								</td>
								<th scope="row">계정과목 <span class="font_red">*</span></th>
								<td id="acctCode">
									<select class="inputTxt" name="selAcctCode" id="selAcctCode">
									<option value="" selected="selected" disabled="disabled">선택</option>
									</select>
								</td>
								<th scope="row">거래처명</th>
								<td>
									<select class="inputTxt" name="custId" id="custId">
										<option value="" selected="selected">선택</option>
										<c:forEach items="${bizPartnerList}" var="bizPartner">
											<option value="${bizPartner.custId}">${bizPartner.custName} </option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">결의금액 <span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt" name="amount" id="amount" />
								</td>
								<th scope="row">승인여부</th>
								<td>
									<input type="text" class="inputTxt" name="apprYn" id="apprYn" readonly="readonly" style="background-color: #eee;" />
								</td>
								<th scope="row">승인일자</th>
								<td>
									<input type="date" class="inputTxt" name="apprDate" id="apprDate" readonly="readonly" style="background-color: #eee;" />
								</td>
							</tr>
							<tr>
		                        <th scope="row">첨부파일</th>
		                        <td colspan="5">
		                        	<input type="file" class="inputTxt p100" name="eviMaterial" id="fileInput" />
		                        </td>
                    		</tr>
                    		<tr id="trPreview" style="display: none">
		                        <th scope="row">미리보기</th>
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
						<a href="" class="btnType blue" id="btnSaveDisb" name="btn"><span>신청</span></a>
						<a href="" class="btnType blue" id="btnDeleteDisb" name="btn"><span>삭제</span></a>
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>
	</form>

</body>
</html>