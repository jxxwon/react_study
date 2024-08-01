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
<title>Job Korea :: 승진 내역 관리</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">

	var pageSize = 5;
	var blockPage = 10;

	$(function(){
		comcombo("dept_code", "searchDept", "all");
		comcombo("user_position", "searchPos", "all");
		empSearch();
		btnEvent();
		
		$("#detailInfo").hide();
		$("#gradeDetailDiv").hide();
		$("#detailPagingNavi").hide();
	})

	// 목록 조회
	function empSearch(cpage,searchStatus){
		var startDate = $("#searchStDate").val();
		var endDate = $("#searchEdDate").val();
		if(startDate > endDate){
			swal("검색 시작일은 검색 종료일보다 클 수 없습니다.");
			return;
		} else {
		      cpage = cpage || 1;
		      searchStatus = searchStatus || '';
		      
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
		         $("#empGradeList").empty().append(response);
		         
		         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "empSearch");
		         $("#pagingNavi").empty().append(pagieNavigateHtml);
		         $("#currentPage").val(cpage);
		      }
		      callAjax("/employee/empGradeList.do", "post", "text", false, param, callBackFunction);
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
			}
		});
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
	function empGradeDetailModal(loginId, name, deptName, posName){
		$("#detailInfo").show();
		$("#gradeDetailDiv").show();
		$("#detailPagingNavi").show();
		
		
		$("#loginId").val(loginId);
		$("#name").val(name);
		$("#deptName").val(deptName);
		$("#posName").val(posName);

		empGradeDetail(loginId);
	}
	
	function empGradeDetail(loginId, cpage){
		  loginId = $("#loginId").val(); 
		  cpage = cpage || 1;
	      
	      var param = {
	            loginId : loginId,
	            cpage : cpage,
	            pageSize : pageSize
	      };
	      
	      var callBackFunction = function(response){
	         $("#empGradeDetailList").empty().append(response);
	         
	         var pagieNavigateHtml = getPaginationHtml(cpage, $("#detailTotcnt").val(), pageSize, blockPage, "empGradeDetail");
	         $("#detailPagingNavi").empty().append(pagieNavigateHtml);
	         $("#currentPage").val(cpage);
	      }
	      
	      callAjax("/employee/empGradeDetailList.do", "post", "text", false, param, callBackFunction);
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
						<span class="btn_nav bold">승진내역관리</span>
						<a href="../employee/empGrade.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span> 승진내역관리 </span> 
					</p>
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
                        	<td style="padding-left:10px; text-align:right;">
                        		기간별 조회&nbsp;&nbsp;&nbsp;&nbsp;
                        		<input type="date" id="searchStDate" name="searchStDate" style="height: 25px;"/> 
                          		&nbsp;&nbsp;~&nbsp;&nbsp; 
                          		<input type="date" id="searchEdDate" name="searchEdDate" style="height: 25px;"/>
	                            <a href="" class="btnType blue" id="btnSearchUser" name="btn"><span>조  회</span></a>
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
										<th scope="col">발령일자</th>
									</tr>
								</thead>
 								<tbody id="empGradeList">
 									<tr>
										<td colspan="6">검색결과가 없습니다.</td>
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
                           		<input type="text" id="loginId" style="width: 150px; height:30px; padding-right:10px;" readonly>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:center; padding-right:10px;">사원명</td>
                           <td style="padding-right:10px;">
                           		<input type="text" id="name" style="width: 150px; height:30px;" readonly>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:center; padding-right:10px;">부서명</td>
                           <td style="padding-right:10px;">
                           		<input type="text" id="deptName" style="width: 150px; height:30px;" readonly>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:right; padding-right:10px;">현재 직급</td>
                           <td style="text-align:right; width:150px;">
                           		<input type="text" id="posName" style="width: 150px; height:30px;" readonly>
                           </td>
                        </tr>
                      </table>
       					<div class="divEmpList" id="gradeDetailDiv">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">발령일자</th>
										<th scope="col">발령내용</th>
									</tr>
								</thead>
 								<tbody id="empGradeDetailList">
 									<tr>
										<td colspan="6">검색결과가 없습니다.</td>
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