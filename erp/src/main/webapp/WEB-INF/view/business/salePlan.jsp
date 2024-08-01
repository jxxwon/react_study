<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Job Korea :: 영업 계획</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">

	var pageSize = 5;
	var blockPage = 10;
	
	//오늘 날짜 계산
	var date = new Date();
	var year = date.getFullYear();
	var month = (date.getMonth()+1).toString().padStart(2,'0');
	var day = date.getDate().toString().padStart(2,'0');
	var currentDate = year + "-" + month + "-" + day;

	$(function(){
		empSearch();
		btnEvent();
				
	})

	// 영업계획서 목록 조회
	function empSearch(cpage,searchStatus){
      cpage = cpage || 1;
      searchStatus = searchStatus || '';
      
      var param = {
    		searchManufac : $("#searchManufac").val(),
            searchMajor : $("#searchMajor").val(),
            searchSub : $("#searchSub").val(),
            searchItemName : $("#searchItemName").val(),
            searchDate : $("#searchDate").val(),
            searchStatus : searchStatus,
            loginID : "${loginID}",
            cpage : cpage,
            pageSize : pageSize
      };
      
      var callBackFunction = function(res){
         $("#salePlanList").html(res);
         
         var pagieNavigateHtml = getPaginationHtml(cpage, $("#totcnt").val(), pageSize, blockPage, "empSearch");
         $("#pagingNavi").empty().append(pagieNavigateHtml);
         $("#currentPage").val(cpage);
      }
      
      callAjax("/business/salePlanList.do", "post", "text", false, param, callBackFunction);
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
			case "btnEmpReg":
				empSaleModal();
				break;
			case "btnSaveEmp":
				saveEmp();
				break;
			case "btnUptEmp":
				updateEmp();
				break;
			case "btnDelEmp":
				deleteEMP();
				break;
			case "btnClose":
				gfCloseModal("#empSaleModal");
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
	
	// 영업계획서 모달 열기
	function empSaleModal(){
		
		// 초기화		
		$("#loginID").val("${loginID}");
		$("#name").val("${searchName.name}");
		$("#custName").val("");
		
		$("#detailManufac").val("");
		$("#detailMajor").val("");
		$("#detailSub").val("");
		
		$("#detailItemName").val("");
	    $("#targetDate").val("");
	    
	    $("#goalQut").val("");
		$("#performQut").val("");
		
		$("#planNote").val("");
				
		gfModalPop("#empSaleModal");
	    
	    // 버튼
	    $("#btnSaveEmp").show();
	    $("#btnUptEmp").hide();
	    $("#btnDelEmp").hide();
		
	}
				
	// 영업계획서 등록
	function saveEmp() {
			
		if(!saleVal()) {
			return;
		}
		
		if(!checkDate()) {
			return;
		}
		
		var param = {
			loginID : "${loginID}",
			cust_id : $("#custName").find("option:selected").data("id"),
			item_code : $("#detailItemName").find("option:selected").data("id"),
			target_date : $("#targetDate").val(),
			goal_qut : $("#goalQut").val() || 0,	
			perform_qut : $("#performQut").val() || 0,
			plan_note : $("#planNote").val()
		};
		
		var callback = function(res) {
			if (res.result === "Success") {
				
				swal("등록되었습니다.");
				gfCloseModal();
				empSearch($("#currentPage").val());
			}
		}
		
		callAjax("/business/salePlanSave.do", "post", "json", false, param, callback);
		
	}
	
	// 목표날짜 체크
	function checkDate() {
		
		// 목표날짜
		var targetDate = $("#targetDate").val();
		
		// 목표날짜가 현재날짜보다 이전일 때 알림
		if (targetDate < currentDate) {
			swal("목표날짜를 오늘이후로 설정해 주세요.");
			$("#targetDate").val(""); // 초기화
			return;
		}
		return true;
	}
	
	// 영업계획서 유효성 검사
	function saleVal() {
		
		var chkNV = checkNotValue([
	           	[ "custName", "거래처이름을 선택해 주세요." ],
	           	[ "detailManufac", "제조업체를 선택해 주세요." ],
	           	[ "detailMajor", "대분류를 선택해 주세요." ],
	           	[ "detailSub", "소분류를 선택해 주세요." ],
	           	[ "detailItemName", "제품이름을 선택해 주세요." ]
		]);
		
		var chkNE = checkNotEmpty([
	           	[ "targetDate", "목표날짜를 선택해 주세요." ]
	   	]);	
				
		if (!chkNV || !chkNE) {
			return;
		}
		
		return true;
	}
	
	// 모달창 select box 제조업체, 대분류, 소분류, 제품이름  (선택된 옵션에 따라 불러온다)
	function detailList(element) {
	    var detailManufac = $("#detailManufac").val();
	    var detailMajor = $("#detailMajor").val();
	    var detailSub = $("#detailSub").val();
	    
	    // 옵션 초기화 및 기본 옵션 추가
	    function resetSelect(selector) {
	        $(selector).empty();
	        $(selector).append('<option value="" selected="selected" disabled>선택해주세요</option>');
	    }

	    if (element.id == "detailManufac") {
	        $.ajax({
	            url: "/business/getMajorClasses.do",
	            type: "post",
	            data: { manufac: detailManufac },
	            success: function(data) {
	                resetSelect("#detailMajor");
	                resetSelect("#detailSub");
	                resetSelect("#detailItemName");

	                data.forEach(function(item) {
	                    $("#detailMajor").append('<option value="' + item.major_class + '">' + item.major_class + '</option>');
	                });
	            }
	        });
	    } else if (element.id == "detailMajor") {
	        $.ajax({
	            url: "/business/getSubClasses.do",
	            type: "post",
	            data: { manufac: detailManufac, major_class: detailMajor },
	            success: function(data) {
	                resetSelect("#detailSub");
	                resetSelect("#detailItemName");

	                data.forEach(function(item) {
	                    $("#detailSub").append('<option value="' + item.sub_class + '">' + item.sub_class + '</option>');
	                });
	            }
	        });
	    } else if (element.id == "detailSub") {
	        $.ajax({
	            url: "/business/getItemNameClasses.do",
	            type: "post",
	            data: { manufac: detailManufac, major_class: detailMajor, sub_class: detailSub },
	            success: function(data) {
	                resetSelect("#detailItemName");

	                data.forEach(function(item) {
	                    $("#detailItemName").append('<option value="' + item.item_name + '" data-id="' + item.item_code + '">' + item.item_name + '</option>');
	                });
	            }
	        });
	    }
	}

	// 영업계획서 상세조회
	function empSaledetailModal(loginID, detailPlanNum){
		$("#btnUptEmp").show();
		$("#btnDelEmp").show();
		$("#btnSaveEmp").hide();
		
		var param = {
				loginID: loginID,
				detailPlanNum: detailPlanNum
			}
			
			var callback = function(data) {
			
				var detail = data.salePlanDetail;
				
				// Unix 타임스탬프를 Date 객체로 변환
		        var targetDate = new Date(detail.target_date);
		        // 년-월-일 형식으로 변환
		        var formattedDate = targetDate.getFullYear() + '-' +
		            ('0' + (targetDate.getMonth() + 1)).slice(-2) + '-' +
		            ('0' + targetDate.getDate()).slice(-2);

				$("#detailPlanNum").val(detail.plan_num);
				$("#loginID").val(detail.loginID);
				$("#name").val(detail.name);
				
				$("#custName").append('<option value="' + detail.cust_id + '">' + detail.cust_name + '</option>');
				$("#custName").val(detail.cust_name);
				
				$("#detailManufac").val(detail.manufac);
				
				$("#detailMajor").html('<option value="' + detail.major_class + '">' + detail.major_class + '</option>');
				$("#detailMajor").val(detail.major_class);
				
				$("#detailSub").html('<option value="' + detail.sub_class + '">' + detail.sub_class + '</option>');
				$("#detailSub").val(detail.sub_class);
				
				$("#detailItemName").html('<option value="' + detail.item_name + '">' + detail.item_name + '</option>');
			    $("#detailItemName").val(detail.item_name);
			    
			    $("#targetDate").val(formattedDate);
			    
				$("#goalQut").val(detail.goal_qut);
				$("#performQut").val(detail.perform_qut);
				
				$("#planNote").val(detail.plan_note);
				
				$("#itemCode").val(detail.item_code);
				
				gfModalPop("#empSaleModal");
			}
			
			callAjax("/business/salePlanDetail.do", "post", "json", true, param, callback);
	}
	
	// 영업계획서 수정
	function updateEmp(){
		
		if (confirm("영업계획을 수정하시겠습니까?")) {
			var param = {
				
				cust_id : $("#custName").find("option:selected").data("id"),
				item_code : $("#detailItemName").find("option:selected").data("id") || $("#itemCode").val(),
				target_date : $("#targetDate").val(),
				goal_qut : $("#goalQut").val(),				
				perform_qut : $("#performQut").val(),
				plan_note : $("#planNote").val(),
				detailPlanNum : $("#detailPlanNum").val()
			};
			
			var callback = function(res) {
				if (res.result === "Success") {
					swal("수정되었습니다.");
					gfCloseModal();
					empSearch($("#currentPage").val());
				}
			}
			
			callAjax("/business/salePlanUpdate.do", "post", "json", false, param, callback);
		}
	}
	
	// 영업계획서 삭제
	function deleteEMP() {
		
		if (confirm("영업계획을 삭제하시겠습니까?")) {
			var param = {
					detailPlanNum : $("#detailPlanNum").val()
				}
				
				var callback = function(data) {
					if (data.result === "Success") {
						swal("삭제되었습니다.");
						gfCloseModal();
						empSearch($("#currentPage").val());			
					}
								
				}
				
				callAjax("/business/salePlanDelete.do", "post", "json", false, param, callback);
			
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
						<span class="btn_nav bold">영업계획</span>
						<a href="../business/empSalePlan.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span> 영업계획서 </span> 
					</p>
					
					<div style="width:100%; text-align:right;">
						<a href="#" class="btnType blue" id="btnEmpReg" name="btn"><span>영업계획등록</span></a>
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
                      					
						<div class="divSalePlanList">
							<table class="col">
								<caption>caption</caption>
								<thead>
									<tr>
										<th scope="col">목표날짜</th>
										<th scope="col">거래처이름</th>
										<th scope="col">제조업체</th>
										<th scope="col">대분류</th>
										<th scope="col">소분류</th>
										<th scope="col">제품이름</th>
										<th scope="col">목표수량</th>
										<th scope="col">실적수량</th>
										<th scope="col">비고</th>
									</tr>
								</thead>
 								<tbody id="salePlanList">
 									<tr>
										<td colspan="9">검색결과가 없습니다.</td>
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

	<!-- 영업계획 모달팝업 -->
	<form id="empSaleForm">
		<div id="empSaleModal" class="layerPop layerType2" style="width:1000px;">
			<dl>
				<dt>
					<strong>영업계획</strong>
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
								<th scope="row">사번</th>
								<td>
									<input type="text" id="loginID" name="loginID" class="inputTxt valid" style="background-color: #eee;" readonly disabled>
								</td>
								<th scope="row">직원명</th>
								<td>
									<input type="text" id="name" name="name" class="inputTxt" style="background-color: #eee;" readonly disabled>
								</td>
								<th scope="row">거래처이름<span class="font_red">*</span></th>								
								<td>
									<select id="custName" name="custName">
	                         			<option value="" selected="selected" disabled>선택해주세요</option>
									<c:forEach items="${custNameList}" var="list">
										<option value="${list.cust_name}" data-id="${list.cust_id}">${list.cust_name}</option>
									</c:forEach>
	                         		</select>
								</td>
							</tr>
							<tr>
								<th scope="row">제조업체<span class="font_red">*</span></th>
								<td>
	                         		<select id="detailManufac" name="detailManufac" onchange="detailList(this)">
	                         			<option value="" selected="selected" disabled>선택해주세요</option>
									<c:forEach items="${searchList}" var="list">
										<option value="${list.manufac}">${list.manufac}</option>
									</c:forEach>
	                         		</select>
		                        </td>
								<th scope="row">대분류<span class="font_red">*</span></th>
								<td style="padding-right:10px;">
	                         		<select id="detailMajor" name="detailMajor" onchange="detailList(this)">
		                          		<option value="" selected="selected" disabled>선택해주세요</option>
	                         		</select>
		                        </td>
								<th scope="row">소분류<span class="font_red">*</span></th>
								<td style="padding-right:10px;">
	                         		<select id="detailSub" name="detailSub" onchange="detailList(this)">
		                          		<option value="" selected="selected" disabled>선택해주세요</option>
	                         		</select>
		                        </td>
							</tr>
							<tr>
								<th scope="row">제품이름<span class="font_red">*</span></th>
								<td>
	                         		<select id="detailItemName" name="detailItemName" onchange="detailList(this)">
	                         			<option value="" selected="selected" disabled>선택해주세요</option>
	                         		</select>
		                        </td>
								<th scope="row">목표날짜<span class="font_red">*</span></th>
								<td>
									<input type="date" class="inputTxt" name="targetDate" id="targetDate" onchange="checkDate(this)"/>
								</td>
							</tr>
							<tr>
								<th scope="row">목표수량</th>
								<td>
									<input type="text" class="inputTxt" name="goalQut" id="goalQut" />
								</td>
								<th scope="row">실적수량</th>
								<td>
									<input type="text" class="inputTxt" name="performQut" id="performQut" />
								</td>
							</tr>
                    		<tr>
								<th scope="row">비고</th>
								<td colspan="5">
									<textarea class="inputTxt p100" name="planNote" id="planNote">
									</textarea>
								</td>
							</tr>
						</tbody>
					</table>
					
					<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSaveEmp" name="btn"><span>등록</span></a> 
						<a href="" class="btnType blue" id="btnUptEmp" name="btn"><span>수정</span></a>
						<a href="" class="btnType blue" id="btnDelEmp" name="btn"><span>삭제</span></a>  
						<a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
					</div>
					<input type="hidden" name="detailPlanNum" id="detailPlanNum" value=""/>
					<input type="hidden" name="itemCode" id="itemCode" value=""/>
				</dd>
			</dl>
		</div>
	</form>
</body>
</html>