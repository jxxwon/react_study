<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea :: 근태 신청</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">
	
	var pageSize = 5;
	var blockPage = 10;

	$(function(){
		comcombo("vctn_code", "searchVctn", "all");
		
		$("#emgContact").on('input', function() {
			var input = this.value;
	        input = input.replace(/[^0-9]/g, '');
	        if (input.length >= 4) {
	            input = input.substring(0, 3) + '-' + input.substring(3);
	        }
	        if (input.length >= 9) {
	            input = input.substring(0, 8) + '-' + input.substring(8);
	        }
	        if (input.length > 13) {
                input = input.substring(0, 13);
            }
	        this.value = input;
	    });
		
		vctnSearch();
		btnEvent();
	})
	
	// 버튼 이벤트
	function btnEvent(){
		$("a[name=btn]").click(function(e) {
			e.preventDefault();
			
			var btnId = $(this).attr("id");

			switch(btnId) {
			case "btnSearch":
				vctnSearch();
				break;
			case "btnApplyVctn" :
				var remainDay = parseInt($("#remainDay").text(),10);
				if(remainDay <= 0){
					swal("사용 가능한 일수를 초과하였습니다.");
				} else {
					vctnApplyModal();
				}
				break;
			case "btnSaveVctn" :
				vctnSave();
				break;
			case "btnUpdateVctn" :
				vctnUpdate(seq);
				vctnSearch();
				break;
			case "btnDeleteVctn" : 
				vctnDelete(seq);
				vctnSearch();
			case "btnClose" :
				gfCloseModal("#vctnApplyModal");
			}
		});
	}
	
	// 목록조회
	function vctnSearch(cpage){
		var startDate = $("#searchStDate").val();
		var endDate = $("#searchEdDate").val();
		if(startDate > endDate){
			swal("검색 시작일은 검색 종료일보다 클 수 없습니다.");
			return;
		} else {
			cpage = cpage || 1;
		      
		      var param = {
		    		loginId : $("#loginId").val(),
		            searchStDate : $("#searchStDate").val(),
		            searchEdDate : $("#searchEdDate").val(),
		            searchVctn : $("#searchVctn").val(),
		            searchApprove : $("#searchApprove").val(),
		            cpage : cpage,
		            pageSize : pageSize
		      };
		      
		      var callBackFunction = function(response){
		         $("#vctnList").empty().append(response);
		         
		         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "vctnSearch");
		         $("#pagingNavi").empty().append(pagieNavigateHtml);
		         $("#currentPage").val(cpage);
		      }
		      callAjax("/employee/vctnList.do", "post", "text", false, param, callBackFunction);
		}
	}
	
	// 휴가신청서 모달 열기
	function vctnApplyModal(){
		gfModalPop("#vctnApplyModal");
		$("#btnSaveVctn").show();
		$("#btnUpdateVctn").hide();
		$("#btnDeleteVctn").hide();
		
		//초기화
		$("#seq").val("");
		comcombo("vctn_code", "vctnCode", "sel");
		$("#vctnStrDate").val("");
		$("#vctnEndDate").val("");
		$("#vctnReason").val("");
		$("#emgContact").val("");
		
		// 신청일 오늘 날짜로 표시
		var today = new Date();
		
		var year = today.getFullYear();
		var month = ('0' + (today.getMonth() + 1)).slice(-2);
		var day = ('0' + today.getDate()).slice(-2);

		var regDate = year + '-' + month + '-' + day;
		
		$("#regDate").val(regDate);
		
	}
	
	// 휴가 신청
	function vctnSave() {
		vctnChk(function(vctnChkResult) {
            if (vctnChkResult === "등록 가능") {
		        if (validChk()) {
		        	saveVctn();
	        	}
	        }
	    });
	}
	
	function saveVctn(){
		if(calculateDate() == true){
            var useDate = calDates($("#vctnStrDate").val(), $("#vctnEndDate").val());

            var param = { 
                seq: $("#seq").val(),
                loginId: $("#loginId").val(),
                vctnCode: $("#vctnCode").val(),
                vctnStrDate: $("#vctnStrDate").val(),
                vctnEndDate: $("#vctnEndDate").val(),
                useDate: useDate,
                vctnReason: $("#vctnReason").val(),
                emgContact: $("#emgContact").val()
            };

            var callback = function(res) {
                if (res.result === "Success") {
                    swal("신청되었습니다.").then(() => {
                        gfCloseModal();
                        location.reload();
                    });
                }
                if (res.result == "사용 가능한 일수를 초과하였습니다.") {
                    swal("사용 가능한 일수를 초과하였습니다.");
                }
            };

            callAjax("/employee/vctnSave.do", "post", "json", false, param, callback);
        }
	};
	
	// 사용일수 계산
	function calDates(startDate, endDate){
		
		var start = new Date(startDate);
		var end = new Date(endDate);
		
		// 두 날짜의 차이 계산 (밀리초 단위)
    	var difference = end.getTime() - start.getTime();
    
	    // 밀리초를 날짜로 변환
	    var days = Math.floor(difference / (1000 * 60 * 60 * 24));
			
		return days + 1;
	}
	
	// 휴가 상세 조회
	function vctnDetailModal(seq){
		var param = {
				seq: seq
		}
		
		var callback = function(data) {
			var detail = data.detailValue;
			var applyYn = detail.applyYn;
			
			if(applyYn == 'N'){
				$("#applyer").val(detail.applyer);
				$("#rejectNote").val(detail.rejectNote);
				
				gfModalPop("#vctnRejectModal");
			} else {
				if(applyYn == 'W'){
					$("#btnUpdateVctn").show();
					$("#btnDeleteVctn").show();
					
					$("#vctnCode").prop('disabled', false);
					$("#vctnStrDate").val(detail.vctnStrDate).prop('readonly', false);
					$("#vctnEndDate").val(detail.vctnEndDate).prop('readonly', false);
					$("#vctnReason").val(detail.vctnReason).prop('readonly', false);
					$("#emgContact").val(detail.emgContact).prop('readonly', false);
				} else {
					$("#btnUpdateVctn").hide();
					$("#btnDeleteVctn").hide();
					$("#vctnCode").prop('disabled', true);
					
					$("#vctnStrDate").val(detail.vctnStrDate).prop('readonly', true);
					$("#vctnEndDate").val(detail.vctnEndDate).prop('readonly', true);
					$("#vctnReason").val(detail.vctnReason).prop('readonly', true);
					$("#emgContact").val(detail.emgContact).prop('readonly', true);
				}
				$("#deptName").val(detail.deptName);
				comcombo('vctn_code', 'vctnCode', 'sel', detail.vctnCode);
				$("#name").val(detail.name);
				$("#loginId").val(detail.loginId);
				$("#regDate").val(detail.regDate);
				$("#seq").val(seq);
				
				
				$("#btnSaveVctn").hide();
				
				gfModalPop("#vctnApplyModal");
			}
		}
		
		callAjax("/employee/vctnDetail.do", "post", "json", false, param, callback);
	}
	
	// 필수값 검사
	function validChk(){
		var isValid = true;
		$('input.valid, select.valid').each(function(){
			if ($(this).val().trim() === '') {
                isValid = false;
                swal('필수값을 입력하세요.');
                return false;
            }
		})
		
		return isValid;
	}
	
	// 휴가 수정
	function vctnUpdate(seq){
		if(validChk()){
			if(calculateDate()){
				var useDate = calDates($("#vctnStrDate").val(), $("#vctnEndDate").val());
				
				var param = { 
					seq: $("#seq").val(),
					loginId : $("#loginId").val(),
					vctnCode: $("#vctnCode").val(),
					vctnStrDate: $("#vctnStrDate").val(),
					vctnEndDate: $("#vctnEndDate").val(),
					useDate: useDate,
					vctnReason: $("#vctnReason").val(),
					emgContact: $("#emgContact").val()
				};
				
				var callback = function(res) {
					if (res.result === "Success") {
						swal("수정되었습니다.").then(() => {
							gfCloseModal();
							location.reload();
						});
					}
					if (res.result == "사용 가능한 일수를 초과하였습니다."){
						swal("사용 가능한 일수를 초과하였습니다.");
					}
				}
			callAjax("/employee/vctnUpdate.do", "post", "json", false, param, callback);
			}
		}
	}
	
	// 휴가 삭제
	function vctnDelete(seq){
		var useDate = calDates($("#vctnStrDate").val(), $("#vctnEndDate").val());
		
		var availDay = parseInt($("#availDay").text(),10);
		var remainDay = availDay - useDate;
			
		var param = { 
			seq: $("#seq").val(),
			useDate: useDate,
			remainDay: remainDay
		};
		
		var callback = function(res) {
			if (res.result === "Success") {
				swal("삭제되었습니다.").then(() => {
					gfCloseModal();
					location.reload();
				});
			}
		}
		
		callAjax("/employee/vctnDelete.do", "post", "json", false, param, callback);
	}
	
	// 일자 중복 체크
	function vctnChk(callback) {
	    var loginId = $("#loginId").val();
	
	    var param = {
	        loginId: loginId,
	        vctnStrDate: $("#vctnStrDate").val(),
	        vctnEndDate: $("#vctnEndDate").val()
	    };
	
	    callAjax("/employee/vctnChk.do", "post", "json", false, param, function(res) {
	        if (res.result === "Success") {
	            callback("등록 가능");
	        } else {
	            swal("해당 기간 내에 휴가가 등록되어 있습니다.");
	            callback("등록 불가");
	        }
	    });
	}
	
	
	// 날짜 체크
	function calculateDate() {
	    var startDate = new Date($("#vctnStrDate").val());
	    var endDate = new Date($("#vctnEndDate").val());
	    if (endDate < startDate) {
	        swal("종료일은 시작일보다 작을 수 없습니다.");
	        return false;
	    }
	    return true;
	}
	
</script>


</head>
							

<body>
<form id="userInfo" action=""  method="">
	<input type="hidden" id="currentPage" value="1">  <!-- 현재페이지는 처음에 항상 1로 설정하여 넘김  -->
	<input type="hidden" id="tmpList" value="">
	<input type="hidden" id="tmpListNum" value="">
	<input type="hidden" name="action" id="action" value="">

	<input type="hidden" id="searchStatus">
	<input type="hidden" id="loginId" value="${loginId}">
	
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
						<span class="btn_nav bold">근태신청</span>
						<a href="../employee/vctnApply.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span> 근태신청 </span> 
					</p>
					
					<table style="margin-top:10px; margin-bottom:10px;" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left" style="collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                        	<td style="padding-left:10px;">
                        		<input type="date" id="searchStDate" name="searchStDate" style="height: 25px;"/> 
                          		&nbsp;&nbsp;~&nbsp;&nbsp; 
                          		<input type="date" id="searchEdDate" name="searchEdDate" style="height: 25px;"/>
                        	</td>
                           <td height="25" style="font-size: 100%; text-align:center;">근태종류</td>
                           <td colspan="2">
                           		<select id="searchVctn" name="searchVctn" style="width:150px;">
                           		</select>
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
                      <table class="col" style="width:100%; margin-bottom:50px;">
                      	<thead>
	                      	<tr>
	                      		<th>총 연차</th>
	                      		<th>사용연차</th>
	                      		<th>남은연차</th>
	                      	</tr>
                      	</thead>
                      	<tr>
                      		<td id="availDay">${vctnInfo.availDay}</td>
                      		<td id="preUseDate">${vctnInfo.useDate}</td>
                      		<td id="remainDay">${vctnInfo.remainDay}</td>
                      	</tr>
                     </table> 
					
						<div class="divVctnList">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">휴가종류</th>
										<th scope="col">사번</th>
										<th scope="col">사원명</th>
										<th scope="col">시작일</th>
										<th scope="col">종료일</th>
										<th scope="col">결재자</th>
										<th scope="col">결재상태</th>
									</tr>
								</thead>
 								<tbody id="vctnList">
 									<tr>
										<td colspan="8">등록된 휴가가 없습니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="pagingNavi"> </div>
						
       					<div style="width:100%; text-align:right; margin-top:50px;">
							<a href="#" class="btnType blue" id="btnApplyVctn" name="btn"><span>개인근태신청</span></a>
						</div>
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
		<div id="vctnApplyModal" class="layerPop layerType2" style="width:600px;">
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
								<td colspan="3"><input type="text" id="name" name="name" class="inputTxt" value="${vctnInfo.name}" style="width:180px;" readonly></td>
							</tr>
							<tr>
								<th>사번</th>
								<td colspan="3"><input type="text" id="loginId" name="loginId" class="inputTxt" style="width:180px;" value="${vctnInfo.loginId}" readonly></td>
							</tr>
							<tr>
								<th>기간<span class="font_red">*</span></th>
								<td style="border-right:0px;">
									<input type="date" id="vctnStrDate" name="vctnStrDate" class="valid" style="width:180px; height:25px;">
								</td>
								<td style="border-left:0px; border-right:0px;">-</td>
								<td style="border-left:0px;">
									<input type="date" id="vctnEndDate" name="vctnEndDate" class="valid" style="width:180px; height:25px;">
								</td>
							</tr>
							<tr>
								<th>휴가사유</th>
								<td colspan="4">
									<textArea id="vctnReason" style="overflow-y:hidden; overflow-x:hidden; resize:none;"></textArea>
								</td>
							</tr>
							<tr>
								<th>비상연락처</th>
								<td colspan="3">
									<input type="text" id="emgContact" name="emgContact" class="inputTxt" placeholder="000-0000-0000">
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
						</tbody>
					</table>
					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSaveVctn" name="btn"><span>신청</span></a> 
						<a href="" class="btnType blue" id="btnUpdateVctn" name="btn"><span>수정</span></a> 
						<a href="" class="btnType blue" id="btnDeleteVctn" name="btn"><span>삭제</span></a> 
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
					</div>
				</dd>
			</dl>
		</div>
	</form>
	
	<!-- 반려사유 모달 -->
	<div id="vctnRejectModal" class="layerPop layerType2" style="width:600px;">
		<dl>
			<dt>
				<strong>반려사유</strong>
			</dt>
			<dd class="content">
				<table class="row" style="width:100%;">
					<tbody>
						<tr>
							<th>결재자</th>
							<td colspan="3"><input type="text" id="applyer" name="applyer" class="inputTxt" style="width:180px;" readonly></td>
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
</body>
</html>