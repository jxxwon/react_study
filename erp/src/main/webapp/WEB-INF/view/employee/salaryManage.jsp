<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea :: 급여 관리</title>
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
		salarySearch();
		btnEvent();
		
		$("#detailInfo").hide();
		$("#salaryDetailDiv").hide();
		$("#detailPagingNavi").hide();
	})

	// 목록 조회
	function salarySearch(cpage,searchStatus){
      cpage = cpage || 1;
      searchStatus = searchStatus || '';
      
      var param = {
    		searchUser : $("#searchUser").val(),
    		searchDate: $("#searchDate").val(),
    		searchDept : $("#searchDept").val(),
    		searchPos : $("#searchPos").val(),  
    		searchPayStatus : $("#searchPayStatus").val(),   		
    		searchStatus : searchStatus,
            cpage : cpage,
            pageSize : pageSize
      };
      
      var callBackFunction = function(response){
         $("#salaryManageList").empty().append(response);
         
         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "salarySearch");
         $("#pagingNavi").empty().append(pagieNavigateHtml);
         $("#currentPage").val(cpage);
      }
      
      callAjax("/employee/salaryManageList.do", "post", "text", false, param, callBackFunction);
   }

	
	// 버튼 이벤트
	function btnEvent(){
		$("a[name=btn]").click(function(e) {
			e.preventDefault();
			
			var btnId = $(this).attr("id");

			switch(btnId) {
			case "btnSearchUser":
				salarySearch($("#currentPage").val());
				break;
			}
		});
	}
	
	// 급여지급 모달
	function salaryApproveModal(loginID, salary_year){
		if(confirm('급여를 지급하시겠습니까?')){
			var param = {
				loginID : loginID,
				salaryYear : salary_year
			};
			var callback = function(res) {
				if (res.result === "Success") {
					alert("지급완료");
					salarySearch($("#currentPage").val());
					empSalaryDetail($("#currentPage").val());
				}
			}
			callAjax("/employee/salaryApprove.do", "post", "json", true, param, callback);
		} else {
			alert('급여 지급을 취소하였습니다.');
		}
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
	
	// 해당 사원 상세 정보 보기
	function empSalaryDetailModal(loginID, name, deptName, posName){
		$("#detailInfo").show();
		$("#salaryDetailDiv").show();
		$("#detailPagingNavi").show();
		
		
		$("#loginID").val(loginID);
		$("#name").val(name);
		$("#deptName").val(deptName);
		$("#posName").val(posName);

		empSalaryDetail(loginID);
	}
	
	function empSalaryDetail(loginID, cpage){
		  loginID = $("#loginID").val(); 
		  cpage = cpage || 1;
	      
	      var param = {
	            loginID : loginID,
	            cpage : cpage,
	            pageSize : pageSize
	      };
	      
	      var callBackFunction = function(response){
	         $("#salaryManageDetailList").empty().append(response);

	         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt_detail").val(), pageSize, blockPage, "empSalaryDetail");
	         $("#detailPagingNavi").empty().append(pagieNavigateHtml);
	         $("#currentPage").val(cpage);
	      }
	      
	      callAjax("/employee/salaryManageDetailList.do", "post", "text", true, param, callBackFunction);
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
						<span class="btn_nav bold">급여관리</span>
						<a href="../employee/empPayment.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span>급여관리</span> 
					</p>
					<table style="margin-top:10px; margin-bottom:10px; border: 1px solid #e2e6ed;" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left">
                        <tr style="border: 0px; border-color: blue">
                           <td height="70px" style="font-size: 100%; text-align:center;">사원명</td>
                           <td colspan="2">
                           		<input type="text" id="searchUser" name="searchUser" style="height: 25px; margin-right: 10px;"/>
                           </td>
                           <td height="70px" style="font-size: 100%; text-align:center;">급여연월</td>
                           <td style="padding-right:10px;">
                           		<input type="month" id="searchDate" name="searchDate" style="height: 25px; margin-right: 10px;"/>
                           </td>
                           
							<td width="100" height="70px" style="font-size: 120%">
	                           <a href="" class="btnType blue" id="btnSearchUser" name="btn"><span>검  색</span></a>
                           </td>
                        </tr>
                        <tr style="border: 0px; border-color: blue">
                        	<td height="50px" style="font-size: 100%; text-align:center;">부서</td>
                            <td colspan="2">
                           		<select id="searchDept" name="searchDept" style="width:150px;">
                           		</select>
                            </td>
                           	<td height="50px" style="font-size: 100%; text-align:center;">직급</td>
                            <td style="padding-right:10px;">
                           		<select id="searchPos" name="searchPos" style="width:150px;">
                           		</select>
                            </td>
                            <td height="50px" style="font-size: 100%; text-align:center;">지급여부</td>
                            <td style="padding-right:10px;">
                           		<select id="searchPayStatus" name="searchPayStatus" style="width:100px;">
                           			<option value="">전체</option>
                           			<option value="N">미지급</option>
                           			<option value="Y">지급</option>
                           		</select>
                           </td>
                        </tr>
                      </table>
						<div class="divEmpList">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">해당연월</th>
										<th scope="col">부서</th>
										<th scope="col">직급</th>
										<th scope="col">사번</th>
										<th scope="col">사원명</th>
										<th scope="col">연봉</th>
										<th scope="col">기본급</th>
										<th scope="col">국민연금</th>
										<th scope="col">건강보험</th>
										<th scope="col">산재보험</th>
										<th scope="col">고용보험</th>
										<th scope="col">실급여</th>
										<th scope="col">퇴직금</th>
										<th scope="col">지급여부</th>
									</tr>
								</thead>
 								<tbody id="salaryManageList">
 									<tr>
										<td colspan="14">검색결과가 없습니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
	
						<div class="paging_area"  id="pagingNavi"> </div>
						
						<!-- 상세조회 화면 -->
						<table id="detailInfo" style="margin-top:100px; margin-bottom:50px;" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left" style="collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue; width:100%;" >
                           <td height="25" style="font-size: 100%; text-align:center; padding-right:10px;">사번</td>
                           <td style="padding-right:10px;">
                           		<input type="text" id="loginID" style="width: 150px; height:30px; padding-right:10px;" readonly disabled>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:center; padding-right:10px;">사원명</td>
                           <td style="padding-right:10px;">
                           		<input type="text" id="name" style="width: 150px; height:30px;" readonly disabled>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:center; padding-right:10px;">부서명</td>
                           <td style="padding-right:10px;">
                           		<input type="text" id="deptName" style="width: 150px; height:30px;" readonly disabled>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:right; padding-right:10px;">현재 직급</td>
                           <td style="text-align:right; width:150px;">
                           		<input type="text" id="posName" style="width: 150px; height:30px;" readonly disabled>
                           </td>
                        </tr>
                      </table>
       					<div class="divEmpList" id="salaryDetailDiv">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">해당연월</th>
										<th scope="col">부서</th>
										<th scope="col">직급</th>
										<th scope="col">사번</th>
										<th scope="col">사원명</th>
										<th scope="col">연봉</th>
										<th scope="col">기본급</th>
										<th scope="col">국민연금</th>
										<th scope="col">건강보험</th>
										<th scope="col">산재보험</th>
										<th scope="col">고용보험</th>
										<th scope="col">실급여</th>
										<th scope="col">퇴직금</th>
										<th scope="col">지급여부</th>
									</tr>
								</thead>
 								<tbody id="salaryManageDetailList">
 									<tr>
										<td colspan="14">검색결과가 없습니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="paging_area"  id="detailPagingNavi"> </div>
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
</form>
</body>
</html>