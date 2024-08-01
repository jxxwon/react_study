<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${sessionScope.userType ne 'A' && sessionScope.userType ne 'C'}">
    <c:redirect url="/dashboard/dashboard.do"/>
</c:if>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea :: 인사 관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

	var pageSize = 5;
	var blockPage = 10;

	$(function(){
		comcombo("dept_code", "searchDept", "all");
		comcombo("user_position", "searchPos", "all");
		empSearch();
		btnEvent();
		
		// 유효성 검사
		$("#birthday").on('input', function() {
			var input = this.value;
	        input = input.replace(/[^0-9]/g, '');
	        if (input.length >= 5) {
	            input = input.substring(0, 4) + '-' + input.substring(4);
	        }
	        if (input.length >= 8) {
	            input = input.substring(0, 7) + '-' + input.substring(7, 10);
	        }
	        if (input.length > 10) {
                input = input.substring(0, 10);
            }
	        this.value = input;
	    });
		
		$("#hpMid, #hpLst").on('input', function(){
			var input = this.value;
			input = input.replace(/[^0-9]/g, '');
			if(input.length > 4){
				input = input.substring(0,4);
			}
			this.value = input;
		});
		
		$("#salaryAccount, #annualSalary, #pens, #availDay").on('input', function(){
		    var input = this.value;
			input = input.replace(/[^0-9]/g, '');
		    this.value = input;
		});
		
	})

	// 사원목록 조회
	function empSearch(cpage,searchStatus){
		
		var startDate = $("#searchStDate").val();
		var endDate = $("#searchEdDate").val();
		if(startDate > endDate){
			swal("검색 시작일자는 종료일자보다 클 수 없습니다.");
			return;
		} else {
		      cpage = cpage || 1;
		      searchStatus = searchStatus || $("#searchStatus").val() || '';
		      
		      var param = {
		    		searchDept : $("#searchDept").val(),
		            searchPos : $("#searchPos").val(),
		            searchUser : $("#searchUser").val(),
		            search : $("#search").val(),
		            searchStDate : $("#searchStDate").val(),
		            searchEdDate : $("#searchEdDate").val(),
		            searchStatus : searchStatus,
		            cpage : cpage,
		            pageSize : pageSize
		      };
		      
		      var callBackFunction = function(response){
		         $("#empList").empty().append(response);
		         
		         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "empSearch");
		         $("#pagingNavi").empty().append(pagieNavigateHtml);
		         $("#currentPage").val(cpage);
		         $("#searchStatus").val(searchStatus);
		      }
		      
		      callAjax("/employee/empMgtList.do", "post", "text", false, param, callBackFunction);
			
		}
   }

	
	// 버튼 이벤트
	function btnEvent(){
		$("a[name=btn]").click(function(e) {
			e.preventDefault();
			
			var btnId = $(this).attr("id");

			switch(btnId) {
			case "btnSearchUser":
				empSearch($("#currentPage").val());
				break;
			case "btnSearchWork" :
				empSearch(1,'W');
				break;
			case "btnSearchRetire" :
				empSearch(1,'R');
				break;
			case "btnEmpReg":
				empRegModal();
				break;
			case "btnAddr":
				addrSearch();
				break;
			case "btnSaveEmp":
				loginIdChk();
				break;
			case "btnUptEmp":
				updateEmp();
				break;
			case "btnClose":
				gfCloseModal("#empRegModal");
				break;
			case "btnRetire":
				empRetireModal(loginId);
				break;
			case "btnRetireClose":
				gfCloseModal("#empRetireModal");
				break;
			case "btnRetireSave":
				saveRetire($("#retireLoginId").val());
				break;
			}
		});
	}
	
	// 선택된 사진을 저장할 변수
	var selectedFile = null;
	
	// 사원등록 모달 열기
	function empRegModal(){
		// 초기화
		$("#loginId").val("");
		$("#name").val("");
		$('input[name="sex"]').prop('checked', false);
		$("#birthday").val("");
		$("#school").val("");
		$("#email").val("");
		$("#hpMid").val("");
		$("#hpLst").val("");
		$("#zcd").val("");
		$("#adrs").val("");
		$("#addrDetail").val("");
		$("#bankCode").val("");
		$("#salaryAccount").val("");
		$("#dept").val("");
		$("#deptCode").val("");
		$("#job").val("");
		$("#pos").val("");
		$("#posCode").val("");
		$("#empDate").val("");
		$("#annualSalary").val("");
		$("#availDay").val("");
		$("#years").val("");
		
		gfModalPop("#empRegModal");
		comcombo("bank_code", "bank", "sel"); //은행명 불러오기
		comcombo("dept_code", "dept", "sel"); //부서명 불러오기
		comcombo("job_code", "job", "sel"); //직무 불러오기
		comcombo("user_position", "pos", "sel"); //직급 불러오기
		selectCode(); // 상세코드 불러오기
		salaryModal(); // 호봉 모달 열기
		
		// 이미지 업로드 초기화 및 설정
	    resetUploadFile(); // 업로드 필드 초기화 함수 호출
	    
	    comcombo("user_role", "userType", "sel");
	    // 버튼
	    $("#btnSaveEmp").show();
	    $("#btnUptEmp").hide();
		
		// 입사일자 오늘로 설정
		var date = new Date();
		var year = date.getFullYear();
		var month = (date.getMonth()+1).toString().padStart(2,'0');
		var day = date.getDate().toString().padStart(2,'0');
		$("#empDate").val(year + "-" + month + "-" + day);
	}
	
	// 이미지 업로드 필드 초기화 및 설정
	function resetUploadFile() {
	    $("#uploadFile").off('click'); 
	    $("#uploadFile").val(""); 
	    
	    $('#default').attr('src', '../images/employee/default.png');
	    
	    $("#uploadFile").click(function() {
	        var input = document.createElement('input');
	        input.type = 'file';
	        input.onchange = function(e) {
	            selectedFile = e.target.files[0];
	            var reader = new FileReader();
	            reader.onload = function() {
	                $('#default').attr('src', reader.result);
	            }
	            reader.readAsDataURL(selectedFile);
	        }
	        input.click();
	    });
	}
	
	// 주소 찾기
	function addrSearch(){
		new daum.Postcode({
			oncomplete: function(data){
				if(data.userSelectedType ==='R'){
            		$("#adrs").val(data.roadAddress);
            	} else {
            		$("#adrs").val(data.jibunAddress);
            	}
            		$("#zcd").val(data.zonecode);
			}
		}).open();
	}
	
	// 상세코드 불러오기
	function selectCode(groupCode){
		$("#dept").change(function(e){
			e.preventDefault();
			$("#deptCode").val($("#dept").val());
		})
		
		$("#pos").change(function(e){
			e.preventDefault();
			$("#posCode").val($("#pos").val());
		})
		
	}
	
	// 근무연차 계산
	function calYears(startDate, endDate){
		
		var start = new Date(startDate);
		var end = new Date(endDate);
		
		// 계산
		var years = end.getFullYear() - start.getFullYear();
		var monthDiff = end.getMonth() - start.getMonth();
		var dayDiff = end.getDate() - start.getDate();
		
		// 월 또는 일이 현재 날짜보다 크다면 연차수에서 1년 빼기
		if(monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)){
			years--;
		}
		
		return years;
	}
	
	function showYears(){
		var startDate = $("#empDate").val();
		var endDate = $("#leaveDate").val();
		
		if(!endDate){
			endDate = new Date();
		}
		
		if(startDate){
			var years = calYears(startDate, endDate);
			$("#years").val(years + "년차");
		}
	}
	
	// 호봉 모달
	function salaryModal() {
	    $("#btnSalary").click(function() {
	        // 모달 위치 조정
	        var empRegModalPos = $("#empRegModal").offset();
	        var empRegModalWidth = $("#empRegModal").outerWidth();
	        
	        var salaryModalLeft = empRegModalPos.left + (empRegModalWidth - $("#salaryModal").outerWidth()) / 2;
	        var salaryModalTop = empRegModalPos.top + 50;
	        
	        $("#salaryModal").css({
	            left: salaryModalLeft,
	            top: salaryModalTop
	        });
	        
	        $("#salaryModal").modal('show');
	        // 호봉 목록 조회
			var callBackFunction = function(response){
				$("#salaryList").empty().append(response);
			}
					      
			callAjax("/employee/empSalaryList.do", "post", "text", false, '', callBackFunction);
					        
	        $("#btnSalaryClose").click(function(){
		        $("#salaryModal").modal('hide');
        	})
	    });
	}
	
	// 사원 저장
	function saveEmp() {
	    if (validChk()) {
	        var getForm = document.getElementById("empRegForm");
	        getForm.enctype = 'multipart/form-data';
	
	        var pattern = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-za-z0-9\-]+/;
	        var email = $("#email").val();
	        if (!pattern.test(email)) {
	            swal('이메일 형식이 올바르지 않습니다.');
	            return;
	        } else {
                // FormData 객체 생성
                var formData = new FormData();

                if (selectedFile) {
                    formData.append('file', selectedFile);
                }

                formData.append('loginId', $("#loginId").val());
                formData.append('name', $("#name").val());
                formData.append('sex', $('input[name="sex"]:checked').val());
                formData.append('birthday', $("#birthday").val());
                formData.append('school', $("#school").val());
                formData.append('email', $("#email").val());
                var hp = $("#hpFst").val() + "-" + $("#hpMid").val() + "-" + $("#hpLst").val();
                formData.append('hp', hp);
                formData.append('zipCode', $("#zcd").val());
                formData.append('addr', $("#adrs").val());
                formData.append('addrDetail', $("#addrDetail").val());
                formData.append('bankCode', $("#bank").val());
                formData.append('salaryAccount', $("#salaryAccount").val());
                formData.append('deptCode', $("#deptCode").val());
                formData.append('jobCode', $("#job").val());
                formData.append('posCode', $("#posCode").val());
                formData.append('emplStatus', $('input[name="emplStatus"]:checked').val());
                formData.append('empDate', $("#empDate").val());
                formData.append('annualSalary', $("#annualSalary").val());
                var pens = $.trim($("#pens").val());
                formData.append('pens', pens != '' ? pens : 0);
                var availDay = $.trim($("#availDay").val());
                formData.append('availDay', availDay != '' ? availDay : 0);
                
                formData.append('userType', $("#userType").val());

                var callback = function(res) {
                    if (res.result === "Success") {
                        swal("등록되었습니다.");
                        gfCloseModal();
                        empSearch($("#currentPage").val());
                    }
                };
                callAjaxFileUploadSetFormData("/employee/empSave.do", "post", "json", false, formData, callback);
            }
     }
	}

	
	// 퇴사처리 모달
	function empRetireModal(loginId){
		
		$("#retireLeaveDate").val("");
		$("#retireLeaveReason").val("");
		
		var param = {
				loginId: loginId
			}
		
		var callback = function(data) {
			var detail = data.detailValue;
			$("#retireLoginId").val(detail.loginId);
			$("#retireName").val(detail.name);
			$("#retireEmpDate").val(detail.empDate);
			
			gfModalPop("#empRetireModal");
		}
		
		callAjax("/employee/empDetail.do", "post", "json", false, param, callback);
		
	}
	
	// 퇴사처리
	function saveRetire(loginId){
		if($("#retireLeaveDate").val().trim() != ''){
		 if(confirm('사번 : ' + loginId + ' 을 퇴사처리하시겠습니까?')){
			 
			var leaveDate = $("#retireLeaveDate").val();
			 
		 	var leaveReason = $("#retireLeaveReason").val();
		 	
			var param = {
				loginId : loginId,
				leaveDate : leaveDate,
				leaveReason : leaveReason
			};
			
			var callback = function(res) {
				if (res.result == "Success") {
					swal("퇴사처리하였습니다.");
					empSearch($("#currentPage").val());
				}
			}
			callAjax("/employee/empRetire.do", "post", "json", false, param, callback);
		} else {
			swal('퇴사처리를 취소하였습니다.');
		} 
	  } else {
		  swal("퇴사일을 입력하세요.");
	  }
	}
	
	
	// 사원 상세조회
	function empMgtdetailModal(loginId){
		$("#btnUptEmp").show();
		$("#btnSaveEmp").hide();
		
		var param = {
				loginId: loginId
			}
			
			var callback = function(data) {
				var detail = data.detailValue;
				
				resetUploadFile();
				$("#default").attr('src', '');
				if(detail.logicalPath != null && detail.logicalPath != ''){
					var userPhoto = detail.logicalPath;
					$("#default").attr('src', detail.logicalPath);
				} else {
					$("#default").attr('src', '../images/employee/default.png');
				}
				
				$("#loginId").val(detail.loginId).prop('readonly', true);
				$("#name").val(detail.name);
				$("input[name='sex'][value='" + detail.sex + "']").prop("checked", true);
				$("#birthday").val(detail.birthday);
				$("#school").val(detail.school);
				$("#email").val(detail.email);
				
				var hp = detail.hp.split('-');
			    $("#hpFst").val(hp[0]);
			    $("#hpMid").val(hp[1]);
			    $("#hpLst").val(hp[2]);
			    
			    $("#zcd").val(detail.zipCode);
				$("#adrs").val(detail.addr);
				$("#addrDetail").val(detail.addrDetail);
				comcombo('bank_code', 'bank', 'sel', detail.bankCode);
				$("#salaryAccount").val(detail.salaryAccount);
				comcombo('dept_code', 'dept', 'sel', detail.deptCode);
				$("#deptCode").val(detail.deptCode);
				selectCode();
				comcombo("job_code", "job", "sel", detail.jobCode);
				comcombo("user_position", "pos", "sel", detail.posCode);
				$("#posCode").val(detail.posCode);
				$("input[name='emplStatus'][value='" + detail.emplStatus + "']").prop("checked", true);
				$("#empDate").val(detail.empDate);
				$("#leaveDate").val(detail.leaveDate);
				showYears();
				$("#annualSalary").val(detail.annualSalary);
				$("#pens").val(detail.pens);
				$("#availDay").val(detail.availDay);
				comcombo('user_role', 'userType', 'sel', detail.userType);
				
				//퇴직인 경우 퇴사사유 표시
				if(detail.leaveReason != null && detail.leaveReason.trim() != ''){
					$("#leaveReasonTr").css("display", "table-row");
					$("#leaveReason").val(detail.leaveReason);
				}
				gfModalPop("#empRegModal");
			}
			
			callAjax("/employee/empDetail.do", "post", "json", false, param, callback);
	}
	
	// 사원 수정
	function updateEmp(){
		
		if(validChk()){
			var getForm = document.getElementById("empRegForm");
			getForm.enctype = 'multipart/form-data';
			
			var hp = $("#hpFst").val() + "-" + $("#hpMid").val() + "-" + $("#hpLst").val();
			
			// FormData 객체 생성
		    var formData = new FormData();
			if(selectedFile){
				formData.append('file', selectedFile);
			}
		    formData.append('loginId', $("#loginId").val());
		    formData.append('name', $("#name").val());
		    formData.append('sex', $('input[name="sex"]:checked').val());
		    formData.append('birthday', $("#birthday").val());
		    formData.append('school', $("#school").val());
		    formData.append('email', $("#email").val());
		    formData.append('hp', hp);
		    formData.append('zipCode', $("#zcd").val());
		    formData.append('addr', $("#adrs").val());
		    formData.append('addrDetail', $("#addrDetail").val());
		    formData.append('bankCode', $("#bank").val());
		    formData.append('salaryAccount', $("#salaryAccount").val());
		    formData.append('deptCode', $("#deptCode").val());
		    formData.append('jobCode', $("#job").val());
		    formData.append('posCode', $("#posCode").val());
		    formData.append('emplStatus', $('input[name="emplStatus"]:checked').val());
		    formData.append('empDate', $("#empDate").val());
		    formData.append('annualSalary', $("#annualSalary").val());
		    var pens = $.trim($("#pens").val());
            formData.append('pens', pens != '' ? pens : 0);
            formData.append('availDay', $("#availDay").val());
            formData.append('userType', $("#userType").val());
	
			var callback = function(res) {
				if (res.result === "Success") {
					swal("수정되었습니다.");
					gfCloseModal();
					empSearch($("#currentPage").val());
				}
			}
			
			callAjaxFileUploadSetFormData("/employee/empUpdate.do", "post", "json", false, formData, callback);
		}
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
	
	// 사번 중복 체크 함수
	function loginIdChk() {
	    var loginId = $("#loginId").val();
	
	    var param = {
	        loginId: loginId
	    };
	
	    var callback = function(res) {
	        if (res.result == "Success") {
	        	saveEmp();
	        } else {
	            swal("중복된 사번입니다.");
	            return;
	        }
	    };
	
	    callAjax("/employee/empUserIdChk.do", "post", "json", false, param, callback);
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
						<span class="btn_nav bold">인사관리</span>
						<a href="../employee/empMgt.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span> 인사관리 </span> 
					</p>
					
					<div style="width:100%; text-align:right;">
						<a href="#" class="btnType blue" id="btnEmpReg" name="btn"><span>사원등록</span></a>
					</div>
						
					<table style="margin-top:10px; margin-bottom:10px;" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left" style="collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                           <td height="25" style="font-size: 100%; text-align:center;">부서</td>
                           <td colspan="2">
                           		<select id="searchDept" name="searchDept" style="width:150px;">
                           		</select>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:center;">직급</td>
                           <td style="padding-right:10px;">
                           		<select id="searchPos" name="searchPos" style="width:150px;">
                           		</select>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:left;">
                           		<select id="searchUser" name="searchUser" style="width:100px;">
                           			<option value="loginId">사번</option>
                           			<option value="name">사원명</option>
                           		</select>
                           </td>
                           	<td>
     	                      	<input type="text" style="width: 200px; height:30px;" id="search" name="search">              
                           </td> 
							<td width="100" height="70" style="font-size: 120%">
	                           <a href="" class="btnType blue" id="btnSearchUser" name="btn"><span>검  색</span></a>
                           </td>
                        </tr>
                      </table>
                      <table style="width:100%; margin-bottom:10px;">
                        <tr>
                        	<td style="width:120px; padding-right:10px;">
                        		<a href="" class="btnType" id="btnSearchWork" name="btn"><span>재직자</span></a>
                        	</td>
                        	<td>
                        		<a href="" class="btnType" id="btnSearchRetire" name="btn"><span>퇴직자</span></a>
                        	</td>
                        	<td style="padding-left:10px; text-align:right;">
                        		입사일 조회&nbsp;&nbsp;&nbsp;&nbsp;
                        		<input type="date" id="searchStDate" name="searchStDate" style="height: 25px;"/> 
                          		&nbsp;&nbsp;~&nbsp;&nbsp; 
                          		<input type="date" id="searchEdDate" name="searchEdDate" style="height: 25px;"/>
                        	</td>
                        </tr>
                     </table> 
					
						<div class="divEmpList">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">사번</th>
										<th scope="col">사원명</th>
										<th scope="col">부서코드</th>
										<th scope="col">부서명</th>
										<th scope="col">직급</th>
										<th scope="col">입사일자</th>
										<th scope="col">재직/퇴직</th>
										<th scope="col">휴직</th>
										<th scope="col">퇴사일자</th>
										<th scope="col">퇴직처리</th>
									</tr>
								</thead>
 								<tbody id="empList">
 									<tr>
										<td colspan="12">검색결과가 없습니다.</td>
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

	<!-- 사원등록 모달팝업 -->
	<form id="empRegForm">
		<div id="empRegModal" class="layerPop layerType2" style="width:1000px;">
			<dl>
				<dt>
					<strong>사원등록</strong>
				</dt>
				<dd class="content">
					<table class="row" style="width:100%;">
						<colgroup>
							<col width="100px;"></col>
							<col width="100px;"></col>
							<col></col>
							<col width="80px;"></col>
							<col width="80px;"></col>
							<col></col>
							<col></col>
							<col width="100px;"></col>
							<col></col>
						</colgroup>
						<tbody>
							<tr>
								<td rowspan="3" width="100px;">
									<a id="uploadFile">
										<img id="default" src="../images/employee/default.png" style="width:100px; height:100px;">
									</a>
								</td>
								<th>사번<span class="font_red">*</span></th>
								<td colspan="3"><input type="text" id="loginId" name="loginId" class="inputTxt valid"></td>
								<th colspan="2">성명<span class="font_red">*</span></th>
								<td colspan="3"><input type="text" id="name" name="name" class="inputTxt" width="100px;"></td>
							</tr>
							<tr>
								<th>성별<span class="font_red">*</span></th>
								<td colspan="8">
									<input type="radio" id="M" name="sex" value="M" class="valid"> <label for="M">남</label>&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" id="F" name="sex" value="F" class="valid"> <label for="F">여</label>
								</td>
							</tr>
							<tr>
								<th>생년월일</th>
								<td colspan="3"><input type="text" id="birthday" name="birthday" class="inputTxt" placeholder="YYYY-MM-DD" required></td>
								<th colspan="2">최종학력</th>
								<td colspan="3"><input type="text" id="school" name="school" class="inputTxt"></td>
							</tr>
							<tr>
								<th>이메일<span class="font_red">*</span></th>
								<td colspan="4">
									<input type="text" id="email" name="email" class="inputTxt valid">
								</td>
								<th colspan="2">연락처<span class="font_red">*</span></th>
								<td colspan="3">
									<input type="text" id="hpFst" name="hp" class="inputTxt" style="width:55px;" value="010" readonly>
									-
									<input type="text" id="hpMid" name="hp" class="inputTxt valid" style="width:100px;">
									-
									<input type="text" id="hpLst" name="hp" class="inputTxt valid" style="width:100px;">
								</td>
							</tr>
							<tr>
								<th>주소</th>
								<td id="addrSearch" colspan="4">
									<input type="text" id="zcd" name="zcd" class="inputTxt" style="width:100px;" placeholder="우편번호" readonly>
									<a id="btnAddr" name="btn" class="btnType"><span>우편번호</span></a><br>
									<input type="text" id="adrs" name="adrs" class="inputTxt" style="width:250px;" readonly><br>
									<input type="text" id="addrDetail" name="addrDetail" class="inputTxt" style="width:250px;" placeholder="상세주소 입력">
								</td>
								<th colspan="2">은행계좌<span class="font_red">*</span></th>
								<td colspan="3">
									<select id="bank" class="valid" style="width:100px;"></select>
									<input type="text" id="salaryAccount" name="salaryAccount" class="inputTxt valid" style="width:200px;" placeholder="숫자만 입력해주세요.">
								</td>
							</tr>
							<tr>
								<th>부서<span class="font_red">*</span></th>
								<td colspan="4">
									<select id="dept" style="width:200px;" class="valid"></select>
								</td>
								<th colspan="2">부서코드</th>
								<td>
									<input type="text" id="deptCode" name="deptCode" class="inputTxt" readonly>
								</td>
								<th>직무</th>
								<td>
									<select id="job" style="width:100px;"></select>
								</td>
							</tr>
							<tr>
								<th>직급<span class="font_red">*</span></th>
								<td colspan="4">
									<select id="pos" class="valid" style="width:200px;"></select>
								</td>
								<th colspan="2">직급코드</th>
								<td>
									<input type="text" id="posCode" name="posCode" class="inputTxt" readonly>
								</td>
								<th>재직구분<span class="font_red">*</span></th>
								<td colspan="2">
									<input type="radio" id="W" name="emplStatus" class="valid" value="W" checked> <label for="W">재직</label>&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" id="O" name="emplStatus" class="valid" value="O"> <label for="O">휴직</label>&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" id="R" name="emplStatus" class="valid" value="R" disabled> <label for="R">퇴직</label>
								</td>
							</tr>
							<tr>
								<th>입사일<span class="font_red">*</span></th>
								<td colspan="4">
									<input type="date" id="empDate" name="empDate" class="valid" style="height: 25px; width:200px;">
								</td>
								<th colspan="2">퇴사일</th>
								<td>
									<input type="date" id="leaveDate" name="leaveDate" style="height: 25px; width:100px;" readonly>
								</td>
								<th>근무연차</th>
								<td colspan="2">
									<input type="text" id="years" class="inputTxt" readonly>
								</td>
							</tr>
							<tr>
								<th>연봉<span class="font_red">*</span></th>
								<td colspan="3" style="border-right:0px;">
									<input type="text" id="annualSalary" name="annualSalary" class="inputTxt valid" style="width:170px;" placeholder="숫자만 입력해주세요.">
								</td>
								<td style="padding:0px; margin:0px; border-left:0px;">
									<a href="#" id="btnSalary" name="btn" class="btnType"><span>호봉</span></a>
								</td>
								<th colspan="2">퇴직금</th>
								<td colspan="3">
									<input type="text" id="pens" name="pens" class="inputTxt" placeholder="숫자만 입력하세요.">
								</td>
							</tr>
							<tr>
								<th>연차일수<span class="font_red">*</span></th>
								<td colspan="4">
									<input type="text" id="availDay" name="availDay" class="inputTxt" style="width:170px;" placeholder="숫자만 입력하세요.">
								</td>
								<th colspan="2">권한<span class="font_red">*</span></th>
								<td colspan="3">
									<select id="userType" style="width:200px;" class="valid"></select>
								</td>
							</tr>
							<tr id="leaveReasonTr" style="display:none">
								<th>퇴사사유</th>
								<td colspan="9">
									<textarea id="leaveReason" style="overflow-y:hidden; overflow-x:hidden; resize:none;" readonly></textarea>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSaveEmp" name="btn"><span>등록</span></a> 
						<a href="" class="btnType blue" id="btnUptEmp" name="btn"><span>수정</span></a> 
						<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
					</div>
				</dd>
			</dl>
		</div>
	</form>
	
	<!-- 호봉 모달 팝업  -->
	<div id="salaryModal" class="layerPop layerType2" style="width:600px;">
		<dl>
			<dt>
				<strong>호봉</strong>
			</dt>
			<dd class="content">
				<table class="col" style="width:100%;">
					<thead>
						<tr>
							<th scope="col">직급명</th>
							<th scope="col">1년차</th>
							<th scope="col">2년차</th>
							<th scope="col">3년차</th>
							<th scope="col">4년차</th>
							<th scope="col">5년차</th>
						</tr>
					</thead>
					<tbody id="salaryList">
						<tr>
							<td colspan="6">내용이 없습니다.</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href=""	class="btnType gray"  id="btnSalaryClose" name="btn"><span>닫기</span></a>
				</div>
			</dd>
		</dl>
	</div>
	
	<!-- 퇴직처리 모달 팝업  -->
	<div id="empRetireModal" class="layerPop layerType2" style="width:600px;">
		<dl>
			<dt>
				<strong>퇴직처리</strong>
			</dt>
			<dd class="content">
				<table class="row" style="width:100%;">
					<tbody>
						<tr>
							<th>사번</th>
							<td>
								<input type="text" id="retireLoginId" name="retireLoginId" class="inputTxt" style="width:170px;" readonly>
							</td>
							<th>사원명</th>
							<td>
								<input type="text" id="retireName" name="retireName" class="inputTxt" style="width:170px;" readonly>
							</td>
						</tr>
						<tr>
							<th>입사일</th>
							<td>
								<input type="date" id="retireEmpDate" name="retireEmpDate" style="width:170px; height:31px;" readonly>
							</td>
							<th>퇴사일<span class="font_red">*</span></th>
							<td>
								<input type="date" id="retireLeaveDate" name="retireLeaveDate" style="width:170px; height:31px;">
							</td>
						</tr>
						<tr>
							<th colspan="6" style="text-align:left;">퇴사사유</th>
						</tr>
						<tr>
							<td colspan="6">
								<textarea id="retireLeaveReason" name="retireLeaveReason" style="overflow-y:hidden; overflow-x:hidden; resize:none;"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href=""	class="btnType blue"  id="btnRetireSave" name="btn"><span>저장</span></a>
					<a href=""	class="btnType gray"  id="btnRetireClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
	</div>

</body>
</html>