<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>거래처 관리</title>
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
		
		bizPartnerSearch();
	});
	
	$("a[name=btn]").click(function(e) {
		e.preventDefault();
		
		var btnId = $(this).attr("id");

		switch(btnId) {
		case "btnSavePartner":
			saveBizPartner();
			break;
		case "btnUpdatePartner":
			updateBizPartner();
			break;
		case "btnDeletePartner":
			deleteBizPartner();
			break;
		case "searchZipcode":
			execDaumPostcode("zipCode", "address", "detailAddress");
			break;		
		case "btnClose":
			gfCloseModal();
			break;
		}
	});

}

$(function() {
	bizPartnerSearch();
	registerBtnEvent();
	
	// 공통 코드 목록 불러오는 함수 : comcombo("공통코드", "selectBox아이디", "all(전체) 또는 sel(선택)")
	comcombo("bank_code", "selectBank", "sel");
	comcombo("industry_code", "selectIndustry", "sel");
	
	var selectors = ["#bizNum", "#custAccount", 
	                 "#custPhPre", "#custPhMid", "#custPhSuf",
	                 "#custPersonPhPre", "#custPersonPhMid", "#custPersonPhSuf"];
	restrictToNumbers(selectors);
});

/* input에 숫자만 입력 가능하게 하기 */
function restrictToNumbers(selectors) {
    selectors.forEach(function(selector) {
        $(selector).keyup(function() {
            $(this).val($(this).val().replace(/[^0-9]/g,""));
        });
    });
}

function bizPartnerSearch(currentPage) {
	currentPage = currentPage || 1;
	
	// 검색 및 페이징 관련 파라미터
	var param = {
		searchPartnerName : $("#searchPartnerName").val(),
		searchStDate : $("#searchStDate").val(),
		searchEdDate : $("#searchEdDate").val(),
		currentPage : currentPage,
		pageSize : pageSize
	};
	
	// html 삽입
	var callBackFunction = function(res) {
		// 거래처 목록
		$("#bizPartnerList").html(res);
		
		// 페이지 네비게이션
		var pageNavigateHtml = getPaginationHtml(currentPage, $("#totcnt").val(), pageSize, blockPage, "bizPartnerSearch");
		$("#pagingNavi").html(pageNavigateHtml);
		$("#currentPage").val(currentPage);
	};

	callAjax("/business/bizPartnerList.do", "post", "text", false, param, callBackFunction);
};

/* 거래처 등록 모달 */
function partnerInsertModal() {
	
	// 특정 폼 하나 리셋
	$('#bizPartnerForm')[0].reset();

	$("#btnSavePartner").show();
	$("#btnUpdatePartner").hide();
	$("#btnDeletePartner").hide();
	
	gfModalPop("#partnerInsertModal");
};

/* 거래처 등록 */
function saveBizPartner() {
	if(!registerVal()){
		return;
	}
	
	var formData = $("#bizPartnerForm").serialize();
	
	$.ajax({
		type : 'post',
		data : formData,
		url : '/business/saveBizPartner.do',
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		success : function(res) {
			if (res.result === "Success") {				
				swal("저장되었습니다.");
				gfCloseModal();
				bizPartnerSearch();
			}
		}
	});

}

/* 거래처 상세 */
function bizPartnerDetailModal(custId) {
	var param = {
			custId : custId
	}
	
	var callBackFunction = function (data) {

		$("#custId").val(data.custId);
		$("#custName").val(data.custName);
		$("#custPerson").val(data.custPerson);
		$("#zipCode").val(data.custZip);
		$("#address").val(data.custAddr);
		$("#detailAddress").val(data.custDetailAddr);
		$("#custEmail").val(data.custEmail);
		$("#selectIndustry").val(data.industryCode);
		$("#bizNum").val(data.bizNum);
		$("#selectBank").val(data.bankCode);
		$("#custAccount").val(data.custAccount);
		$("#custMemo").val(data.custMemo);

		// 회사전화
		telHyphenSplit(data.custPh, "custPhPre", "custPhMid", "custPhSuf");
		if (data.custPersonPh === '') {
			// 담당자 휴대전화
			telHyphenSplit(data.custPersonPh, "custPersonPhPre", "custPersonPhMid", "custPersonPhSuf");
		}
		
		// 버튼 설정
		$("#btnSavePartner").hide();
		$("#btnUpdatePartner").show();
		$("#btnDeletePartner").show();
		
		gfModalPop("#partnerInsertModal");
	}
	
	callAjax("/business/bizPartnerDetail.do", "post", "json", false, param, callBackFunction);
	
}

/* 거래처 수정 */
function updateBizPartner() {
	
	if(!registerVal()){
		return;
	}
	
	var formData = $("#bizPartnerForm").serialize();
	
	$.ajax({
		type : 'post',
		data : formData,
		url : '/business/updateBizPartner.do',
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		success : function(res) {
			if (res.result === "Success") {				
				swal("수정되었습니다.");
				gfCloseModal();
				bizPartnerSearch();
			}
		}
	});

}

function deleteBizPartner() {
	
	var chk = confirm("삭제하시겠습니까?");
	if(!chk) {
		return;
	}
	var param = {
			custId : $("#custId").val()
	}
	
	var callBackFunction = function(data) {
		swal("삭제되었습니다.");
		gfCloseModal();
		bizPartnerSearch();
	}
	
	callAjax("/business/deleteBizPartner.do", "post", "json", false, param, callBackFunction);

}

/* 거래처 validation */
function registerVal(){
	
	var chkNE = checkNotEmpty([
        	[ "custName", "업체명 입력해 주세요." ],  
            [ "custPerson", "담당자를 입력해 주세요" ],
            [ "zipCode", "주소를 입력해 주세요" ],
            [ "custEmail", "이메일을 입력해 주세요" ],
            [ "bizNum", "사업자 등록번호를 입력해 주세요" ],
            [ "custAccount", "계좌번호를 입력해 주세요" ]            
	]);
	
	var chkNV = checkNotValue([
           	[ "selectIndustry", "업종을 선택해 주세요." ],  
            [ "selectBank", "은행을 선택해 주세요" ] 
	]);
	
	if (!chkNE || !chkNV) {
		return;
	}
	
	// 이메일 형식 체크
	var email = $("#custEmail").val();
	var emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
	if(!emailRegex.test(email)){ 
		swal("유효하지 않은 이메일 주소입니다.").then(function() {
			$("input[name=custEmail]").focus();
		});
		return false;
	}
	
	var custPhPre = $("input[name=custPhPre]").val();
	var custPhMid = $("input[name=custPhMid]").val();
	var custPhSuf = $("input[name=custPhSuf]").val();

	if(custPhPre.length < 1){
		swal("회사 전화번호를 입력하세요.").then(function() {
			$("input[name=custPhPre]").focus();
		});
		return false;
	}
	
	if(custPhMid.length < 1){
		swal("회사 전화번호를 입력하세요.").then(function() {
			$("input[name=custPhMid]").focus();
		});
		return false;
	}
	
	if(custPhSuf.length < 1){
		swal("회사 전화번호를 입력하세요.").then(function() {
			$("input[name=custPhSuf]").focus();
		});
		return false;
	}
	
	return true;
}

/* 전화번호 Hypen(-)으로 분리 */
function telHyphenSplit(totalString, inputName1, inputName2, inputName3) {
	var tel = totalString.split('-');
	$("input[name=" + inputName1 + "]").val(tel[0]);
	$("input[name=" + inputName2 + "]").val(tel[1]);
	$("input[name=" + inputName3 + "]").val(tel[2]);
}

/* 우편번호 찾기 API */
function execDaumPostcode(zipcode, address, detailAddr) {
	new daum.Postcode({
		oncomplete : function(data) {
			// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

			// 각 주소의 노출 규칙에 따라 주소를 조합한다.
			// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
			var addr = ''; // 주소 변수
			var extraAddr = ''; // 참고항목 변수

			//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
			if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
				addr = data.roadAddress;
			} else { // 사용자가 지번 주소를 선택했을 경우(J)
				addr = data.jibunAddress;
			}

			// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
			if (data.userSelectedType === 'R') {
				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraAddr += (extraAddr !== '' ? ', '
							+ data.buildingName : data.buildingName);
				}
			}

			// 우편번호와 주소 정보를 해당 필드에 넣는다.
			document.getElementById(zipcode).value = data.zonecode;
			document.getElementById(address).value = addr;
			// 커서를 상세주소 필드로 이동한다.
			document.getElementById(detailAddr).focus();
		}
	}).open();
}
</script>
</head>
<body>
	<input type="hidden" id="currentPage" value="1">
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
						
						<%-- 상단 메뉴 : 홈 / 영업 / 거래처 관리 --%>
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a> 
							<a href="#" class="btn_nav bold">영업</a> 
							<span class="btn_nav bold">거래처 관리</span> 
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>
						
						<%-- 컨텐츠 타이틀 --%>		
						<p class="conTitle">
							<span>거래처 관리</span> 
							<%-- .fr {float: right;} : 오른쪽에 배치 --%>				
							<span class="fr"> 
								<a class="btnType blue" href="javascript:partnerInsertModal();" name="modal"><span>거래처 신규 등록</span></a>
							</span>
						</p>
						
						<p class="fr" style="margin-bottom: 10px;">
							<span>업체명&nbsp;</span>
							<input type="text" id="searchPartnerName" name="searchPartnerName" style="height: 25px; margin-right: 10px;" /><span>기간 &nbsp;</span>
							<input type="date" id="searchStDate" name="searchStDate" style="height: 25px; margin-right: 10px;" /><span>~ &nbsp;</span> 
							<input type="date" id="searchEdDate" name="searchEdDate" style="height: 25px; margin-right: 10px;" />
														
							<a class="btnType red" href="" name="searchbtn" id="searchBtn"><span>검색</span></a>
						</p>
					
						<div class="divBizPartnerList">
							<table class="col">
								<colgroup>
									<col width="10%">
									<col width="20%">
									<col width="20%">
									<col width="10%">
									<col width="12%">
									<col width="12%">
									<col width="16%">
								</colgroup>
								<thead>
									<tr>
						              <th scope="col">날짜</th>
						              <th scope="col">거래처</th>
						              <th scope="col">주소</th>
						              <th scope="col">담당자</th>
						              <th scope="col">전화번호</th>
						              <th scope="col">핸드폰번호</th>
						              <th scope="col">이메일</th>	              
									</tr>
								</thead>
								<tbody id="bizPartnerList"></tbody>
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

	<%-- 거래처 등록 모달 / 폼 --%>
	<form id="bizPartnerForm" action="" method="">
		<input type="hidden" id="custId" name="custId">
		<div id="partnerInsertModal" class="layerPop layerType2" style="width: 900px;">
			<dl>
				<dt>
					<strong>거래처 등록</strong>
				</dt>
				<dd class="content">
					<table class="row">
						<colgroup>
		                    <col width="15%">
		                    <col width="35%">
		                    <col width="15%">
		                    <col width="35%">
	                    </colgroup>
						<tbody>
							<tr>
								<th scope="row">업체명 <span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt" name="custName" id="custName" />
								</td>
								<th scope="row">회사전화 <span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt" name="custPhPre" id="custPhPre" maxlength="3" style="width: 70px" />
									- <input type="text" class="inputTxt" name="custPhMid" id="custPhMid" maxlength="4" style="width: 70px" />					
									- <input type="text" class="inputTxt" name="custPhSuf" id="custPhSuf" maxlength="4" style="width: 70px" />
								</td>
							</tr>
							<tr>
								<th scope="row">담당자 <span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt" name="custPerson" id="custPerson" />
								</td>
								<th scope="row">휴대전화</th>
								<td>
									<input type="text" class="inputTxt" name="custPersonPhPre" id="custPersonPhPre" value="010" maxlength="3" style="width: 70px" readonly="readonly"/>
									- <input type="text" class="inputTxt" name="custPersonPhMid" id="custPersonPhMid" maxlength="4" style="width: 70px" />
									- <input type="text" class="inputTxt" name="custPersonPhSuf" id="custPersonPhSuf" maxlength="4" style="width: 70px" />
								</td>
							</tr>
							<tr>
								<th scope="row">주소 <span class="font_red">*</span></th>
								<td colspan="3">
									<a class="btnType gray" name="btn" id="searchZipcode" value="우편번호 찾기"><span>우편변호 찾기</span></a>
									<input type="text" class="inputTxt" name="custZip" id="zipCode" style="width: 120px" placeholder="우편번호" readonly /><br>
									<input type="text" class="inputTxt" name="custAddr" id="address" placeholder="주소" readonly /><br>
									<input type="text" class="inputTxt" name="custDetailAddr" id="detailAddress" placeholder="상세주소를 입력해주세요."></input>
								</td>
							</tr>
							<tr>
								<th scope="row">이메일 <span class="font_red">*</span></th>
								<td colspan="3">
									<input type="text" class="inputTxt" name="custEmail" id="custEmail" style="width: 270px" />
								</td>
							</tr>
							<tr>
								<th scope="row">업종 <span class="font_red">*</span></th>
								<td colspan="3">
									<select class="inputTxt" name="industryCode" id="selectIndustry" style="width: 270px">
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">사업자 등록번호 <span class="font_red">*</span></th>
								<td colspan="3">
									<input type="text" class="inputTxt" name="bizNum" id="bizNum" style="width: 270px" maxlength="10" placeholder="'-' 빼고 입력해주세요." />
								</td>
							</tr>
							<tr>
								<th scope="row">은행 <span class="font_red">*</span></th>
								<td>
									<select class="inputTxt" name="bankCode" id="selectBank" style="width: 90px">
									</select>
								</td>
								<th scope="row">계좌번호 <span class="font_red">*</span></th>
								<td>
									<input type="text" class="inputTxt" name="custAccount" id="custAccount" placeholder="'-' 빼고 입력해주세요." />
								</td>
							</tr>
							<tr>
								<th scope="row">메모</th>
								<td colspan="3">
									<textarea class="inputTxt p100" name="custMemo" id="custMemo">
									</textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSavePartner" name="btn"><span>저장</span></a>
						<a href="" class="btnType blue" id="btnUpdatePartner" name="btn"><span>수정</span></a>
						<a href="" class="btnType blue" id="btnDeletePartner" name="btn"><span>삭제</span></a>
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
			<a href="" class="closePop"><span class="hidden">닫기</span></a>
		</div>
	</form>

</body>
</html>
