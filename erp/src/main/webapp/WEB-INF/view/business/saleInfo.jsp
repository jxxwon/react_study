<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea :: 영업 실적 조회</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

	var pageSize = 5;
	var blockPage = 10;

	$(function(){
		empSearch();
		btnEvent();
				
	})

	// 영업실적 목록 조회
	function empSearch(cpage,searchStatus){
      cpage = cpage || 1;
      searchStatus = searchStatus || '';
      
      var param = {
    		searchloginID : $("#searchloginID").val(),
    		searchManufac : $("#searchManufac").val(),
            searchMajor : $("#searchMajor").val(),
            searchSub : $("#searchSub").val(),
            searchItemName : $("#searchItemName").val(),
            searchDate : $("#searchDate").val(),
            searchStatus : searchStatus,
            cpage : cpage,
            pageSize : pageSize
      };
      
      var callBackFunction = function(res){
         $("#saleInfoList").html(res);
         
         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "empSearch");
         $("#pagingNavi").empty().append(pagieNavigateHtml);
         $("#currentPage").val(cpage);
      }
      
      callAjax("/business/saleInfoList.do", "post", "text", false, param, callBackFunction);
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
			case "btnClose":
				gfCloseModal("#empRegModal");
				break;
			}
		});
	}
	
	// 검색 부분 (선택된 옵션에 따라 불러온다)
	function searchList(element) {
	    var searchManufac = $("#searchManufac").val();
	    var searchMajor = $("#searchMajor").val();
	    var searchSub = $("#searchSub").val();
		
	    // 제조업체 선택 시
	    if (element.id == "searchManufac") {
	        $.ajax({
	            url: "/business/getMajorClasses.do",
	            type: "post",
	            data: { manufac: searchManufac },
	            success: function(data) {
	                var majorOptions = '<option value="">전체</option>';
	                data.forEach(function(item) {
	                    majorOptions += '<option value="' + item.major_class + '">' + item.major_class + '</option>';
	                });
	                $("#searchMajor").html(majorOptions);
	                $("#searchSub").html('<option value="">전체</option>'); // 소분류 리셋
	                $("#searchItemName").html('<option value="">전체</option>'); // 제품이름 리셋
	            }
	        });
	    } else if (element.id == "searchMajor") { // 대분류 선택 시
	        $.ajax({
	            url: "/business/getSubClasses.do",
	            type: "post",
	            data: { manufac: searchManufac, major_class: searchMajor },
	            success: function(data) {
	                var subOptions = '<option value="">전체</option>';
	                data.forEach(function(item) {
	                    subOptions += '<option value="' + item.sub_class + '">' + item.sub_class + '</option>';
	                });
	                $("#searchSub").html(subOptions);
	                $("#searchItemName").html('<option value="">전체</option>'); // 제품이름 리셋
	            }
	        });
	    } else if (element.id == "searchSub") { // 소분류 선택 시
	        $.ajax({
	            url: "/business/getItemNameClasses.do",
	            type: "post",
	            data: { manufac: searchManufac, major_class: searchMajor, sub_class: searchSub},
	            success: function(data) {
	                var itemNameOptions = '<option value="">전체</option>';
	                data.forEach(function(item) {
	                	itemNameOptions += '<option value="' + item.item_name + '">' + item.item_name + '</option>';
	                });
	                $("#searchItemName").html(itemNameOptions);
	            }
	        });
	    }
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
						<span class="btn_nav bold">영업</span>
						<span class="btn_nav bold">영업실적조회</span>
						<a href="../business/bmSalePlan.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span> 영업실적조회 </span> 
					</p>
					
					<div style="width:100%; text-align:right;">
						<table>
							<tr>
								<th scope="row" style="padding: 0 5px 0 3px">사번</th>
								<td height="25" style="font-size: 100%; text-align:center;">
									<input type="text" class="inputTxt" name="searchloginID" id="searchloginID" />
								</td>
						</table>
					</div>
						
					<table style="margin-top:10px; margin-bottom:10px;" width="100%" cellpadding="5" cellspacing="0" border="1"
                        align="left" style="collapse; border: 1px #50bcdf;">
                        <tr style="border: 0px; border-color: blue">
                           <td height="25" style="font-size: 100%; text-align:center;">제조업체</td>
                           <td colspan="2">
                           		<select id="searchManufac" name="searchManufac" onchange="searchList(this)" style="width:150px;">
                           			<option value="" selected="selected">전체</option>
										<c:forEach items="${searchList}" var="list">
											<option value="${list.manufac}">${list.manufac}</option>
										</c:forEach>
                           		</select>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:center;">대분류</td>
                           <td style="padding-right:10px;">
                           		<select id="searchMajor" name="searchMajor" onchange="searchList(this)" style="width:150px;">
	                           		<option value="" selected="selected">전체</option>
                           		</select>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:left;">소분류</td>
                           <td style="padding-right:10px;">
                           		<select id="searchSub" name="searchSub" onchange="searchList(this)" style="width:100px;">
	                           		<option value="" selected="selected">전체</option>
                           		</select>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:left;">제품이름</td>
                           <td style="padding-right:10px;">
                           		<select id="searchItemName" name="searchItemName" style="width:100px;">
	                           		<option value="" selected="selected">전체</option>
                           		</select>
                           </td>
                           <td height="25" style="font-size: 100%; text-align:left;">날짜</td>
                           <td style="padding-right:10px;">
                           		<input type="date" id="searchDate" name="searchDate" style="height: 25px; margin-right: 10px;"/>
                           </td>             
							<td width="100" height="70" style="font-size: 120%">
	                           <a href="" class="btnType blue" id="btnSearchUser" name="btn"><span>검  색</span></a>
                           </td>
                        </tr>
                      </table>
                      					
						<div class="divSaleInfoList">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">사번</th>
										<th scope="col">이름</th>
										<th scope="col">날짜</th>
										<th scope="col">제품코드</th>
										<th scope="col">제조업체</th>
										<th scope="col">대분류</th>
										<th scope="col">소분류</th>
										<th scope="col">제품이름</th>
										<th scope="col">목표수량</th>
										<th scope="col">실적수량</th>
										<th scope="col">달성율</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
 								<tbody id="saleInfoList">
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

</body>
</html>