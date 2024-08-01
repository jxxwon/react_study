<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${sessionScope.userType ne 'A' && sessionScope.userType ne 'C' && sessionScope.userType ne 'E'}">
    <c:redirect url="/dashboard/dashboard.do"/>
</c:if>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea :: 근태 관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">
	
	var pageSize = 5;
	var blockPage = 10;

	$(function(){
		vctnApproveSearch();
		btnEvent();
	})
	
	// 버튼 이벤트
	function btnEvent(){
		$("a[name=btn]").click(function(e) {
			e.preventDefault();
			
			var btnId = $(this).attr("id");

			switch(btnId) {
			case "btnSearch":
				vctnApproveSearch();
				break;
			case "btnApproval":
				vctnApproval();
				vctnApproveSearch();
				break;
			case "btnReject":
				vctnViewNote();
				break;
			case "btnClose":
				gfCloseModal("#vctnApplyModal");
			}
		});
	}
	
	// 목록조회
	function vctnApproveSearch(cpage){
		var startDate = $("#searchStDate").val();
		var endDate = $("#searchEdDate").val();
		if(startDate > endDate){
			swal("검색 시작일은 검색 종료일보다 클 수 없습니다.");
			return;
		} else {
			cpage = cpage || 1;
		      
		      var param = {
		    		searchLoginId : $("#searchLoginId").val(),
		            searchStDate : $("#searchStDate").val(),
		            searchEdDate : $("#searchEdDate").val(),
		            searchLoginId : $("searchLoginId").val(),
		            searchName : $("searchName").val(),
		            searchApprove : $("#searchApprove").val(),
		            cpage : cpage,
		            pageSize : pageSize
		      };
		      
		      var callBackFunction = function(response){
		         $("#vctnApproveList").empty().append(response);
		         
		         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "vctnSearch");
		         $("#pagingNavi").empty().append(pagieNavigateHtml);
		         $("#currentPage").val(cpage);
		      }
		      callAjax("/employee/vctnApproveList.do", "post", "text", false, param, callBackFunction);
		}
	}
	
	// 휴가 모달 열기
	function vctnApproveModal(){
		// 초기화
		$("#rejectNote").val("");
		gfModalPop("#vctnApproveModal");
		
	}
	
	// 반려 클릭해야 반려 사유 입력 가능
	function vctnViewNote(){
		$("#rejectNote").removeAttr("readonly");
		var rejectNote = $("#rejectNote").val();
		
		// 문자열의 앞뒤 공백을 제거하고 빈 값인지 확인
		if ($.trim(rejectNote) === "") {
			swal("반려사유를 입력하세요.");
			return;
		} else {
			vctnReject();
			vctnApproveSearch();
		}
	}
	
	// 휴가 승인
	function vctnApproval(){
		var param = { 
			seq: $("#seq").val(),
		};
		
		var callback = function(res) {
			if (res.result === "Success") {
				alert("승인되었습니다.");
				gfCloseModal();
			}
		}
		
		callAjax("/employee/vctnApproval.do", "post", "json", false, param, callback);
	}
	
	// 휴가 반려
	function vctnReject(){
		var param = { 
			seq: $("#seq").val(),
			rejectNote: $("#rejectNote").val(),
		};
		
		var callback = function(res) {
			if (res.result === "Success") {
				alert("반려하였습니다.");
				gfCloseModal();
			}
		}
		
		callAjax("/employee/vctnReject.do", "post", "json", false, param, callback);
	}
	
	// 휴가 상세 조회
	function vctnApproveDetailModal(seq){
		var param = {
				seq: seq
		}
		
		var callback = function(data) {
			var detail = data.detailValue;
			
			$("#deptName").val(detail.deptName);
			comcombo('vctn_code', 'vctnCode', 'sel', detail.vctnCode);
			$("#name").val(detail.name);
			$("#loginId").val(detail.loginId);
			$("#vctnStrDate").val(detail.vctnStrDate);
			$("#vctnEndDate").val(detail.vctnEndDate);
			$("#vctnReason").val(detail.vctnReason);
			$("#emgContact").val(detail.emgContact);
			$("#regDate").val(detail.regDate);
			$("#rejectNote").val(detail.rejectNote);
			$("#seq").val(seq);
			
			gfModalPop("#vctnApproveModal");
		}
		
		callAjax("/employee/vctnApproveDetail.do", "post", "json", false, param, callback);
	}
	
</script>


</head>
							

<body>
<form id="userInfo" action=""  method="">
	<input type="hidden" id="currentPage" value="1">  <!-- 현재페이지는 처음에 항상 1로 설정하여 넘김  -->
	<input type="hidden" id="tmpList" value="">
	<input type="hidden" id="tmpListNum" value="">
	<input type="hidden" name="action" id="action" value="">
	<input type="hidden" id="loginID" value="${loginId}">

	<input type="hidden" id="searchStatus">
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> <jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

					<p class="Location">
						<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
						<span class="btn_nav bold">인사/급여</span>
						<span class="btn_nav bold">근태관리</span>
						<a href="../employee/vctnApprove.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span> 근태관리 </span> 
					</p>
					
					<table style="margin-top:10px; margin-bottom:10px;" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left" style="collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                        	<td style="padding-left:10px;">
                        		<input type="date" id="searchStDate" name="searchStDate" style="height: 25px;"/> 
                          		&nbsp;&nbsp;~&nbsp;&nbsp; 
                          		<input type="date" id="searchEdDate" name="searchEdDate" style="height: 25px;"/>
                        	</td>
                           <td height="25" style="font-size: 100%;">사번</td>
                           <td>
                           		<input type="text" id="searchLoginId" class="inputTxt" style="width:150px;">
                           </td>
                           <td height="25" style="font-size: 100%;">사원명</td>
                           <td>
                           		<input type="text" id="searchName" class="inputTxt" style="width:150px;">
                           </td>
                           <td height="25" style="font-size: 100%; text-align:center;">결재상태</td>
                           <td style="padding-right:10px;">
                           		<select id="searchApprove" name="searchApprove" style="width:150px;">
                           			<option value="">전체</option>
                           			<option value="Y">승인</option>
                           			<option value="WAIT">미승인</option>
                           			<option value="N">반려</option>
                           		</select>
                           </td>
							<td width="100" height="70" style="font-size: 120%">
	                           <a href="" class="btnType blue" id="btnSearch" name="btn"><span>조  회</span></a>
                           </td>
                        </tr>
                      </table>
						<div class="divVctnList">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">사번</th>
										<th scope="col">사원명</th>
										<th scope="col">신청구분</th>
										<th scope="col">시작일자</th>
										<th scope="col">종료일자</th>
										<th scope="col">결재일자</th>
										<th scope="col">결재자</th>
										<th scope="col">승인여부</th>
									</tr>
								</thead>
 								<tbody id="vctnApproveList">
 									<tr>
										<td colspan="9">등록된 휴가가 없습니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="pagingNavi"> </div>
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
</form>

	<!-- 휴가신청서 모달팝업 -->
	<form id="vctnApplyForm">
		<input type="hidden" id="seq" name="seq">
		<input type="hidden" id="useDate" name="useDate">
		<input type="hidden" id="remainDay" name="remainDay">
		<div id="vctnApproveModal" class="layerPop layerType2" style="width:600px;">
			<dl>
				<dt>
					<strong>휴가신청서</strong>
				</dt>
				<dd class="content">
					<table class="row" style="width:100%;">
						<tbody>
							<tr>
								<th>근무부서</th>
								<td style="border-right:0px; width:180px;"><input type="text" id="deptName" name="deptName" class="inputTxt" value="${vctnInfo.deptName}" readonly></td>
								<td style="border-right:0px; border-left:0px;"></td>
								<td style="border-left:0px;">
									<select id="vctnCode" style="width:200px;" class="valid"></select>
								</td>
							</tr>
							<tr>
								<th>성명</th>
								<td colspan="3"><input type="text" id="name" name="name" class="inputTxt" style="width:180px;" readonly></td>
							</tr>
							<tr>
								<th>사번</th>
								<td colspan="3"><input type="text" id="loginId" name="loginId" class="inputTxt" style="width:180px;" readonly></td>
							</tr>
							<tr>
								<th>기간<span class="font_red">*</span></th>
								<td style="border-right:0px;">
									<input type="date" id="vctnStrDate" name="vctnStrDate" class="valid" style="width:180px; height:25px;" readonly>
								</td>
								<td style="border-left:0px; border-right:0px;">-</td>
								<td style="border-left:0px;">
									<input type="date" id="vctnEndDate" name="vctnEndDate" class="valid" style="width:180px; height:25px;" readonly>
								</td>
							</tr>
							<tr>
								<td style="border-right:0px;"></td>
								<td colspan="3" style="border-left:0px;">
									<a href="" class="btnType blue" id="btnApproval" name="btn"><span>승인</span></a> 
									<a href="" class="btnType gray" id="btnReject" name="btn"><span>반려</span></a>
								</td>
							</tr>
							<tr>
								<th>휴가사유</th>
								<td colspan="4">
									<textArea id="vctnReason" style="overflow-y:hidden; overflow-x:hidden; resize:none;" readonly></textArea>
								</td>
							</tr>
							<tr>
								<th>비상연락처</th>
								<td colspan="3">
									<input type="text" id="emgContact" name="emgContact" class="inputTxt" placeholder="숫자만 입력하세요." readonly>
								</td>
							</tr>
							<tr>
								<td colspan="4" style="text-align:center;">
									<br><br><br><br>상기와 같은 사유로 휴가를 신청합니다.<br><br><br><br>
									신청일
									<input type="text" id="regDate" name="regDate" class="inputTxt" style="width:180px; text-align:center;" readonly>
									<br><br><br><br>
								</td>
							</tr>
							<tr>
								<th>반려사유</th>
								<td colspan="4">
									<textArea id="rejectNote" style="overflow-y:hidden; overflow-x:hidden; resize:none;" readonly></textArea>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="btn_areaC mt30">
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
		</div>
	</form>
</body>
</html>