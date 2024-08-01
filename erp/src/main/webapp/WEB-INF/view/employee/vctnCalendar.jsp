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
<style>
	tbody tr {
		height:100px;
	}
	
	tbody tr td ul{
		height:100%;
	}
	
	.date{
		height:20%;
		text-align:left;
	}
	
	.vctn{
		height:80%;
	}
	
</style>
<title>Job Korea :: 근태 신청</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>


<script type="text/javascript">
    var today = new Date();
    var currentMonth = today.getMonth(); // 0부터 시작 ex.1월은 0
    var currentYear = today.getFullYear();
    var formattedMonth = currentYear.toString() + "-" + (currentMonth+1).toString().padStart(2,'0');

    $(document).ready(function() {
        renderCalendar();

        $("#preBtn").click(function(e) {
            e.preventDefault();
            currentMonth--;
            if (currentMonth < 0) {
                currentMonth = 11;
                currentYear--;
            }
            renderCalendar();
        });

        $("#nextBtn").click(function(e) {
            e.preventDefault();
            currentMonth++;
            if (currentMonth > 11) {
                currentMonth = 0;
                currentYear++;
            }
            renderCalendar();
        });
        
        btnEvent();
    });


    function renderCalendar() {
    	formattedMonth = currentYear.toString() + "-" + (currentMonth+1).toString().padStart(2,'0');
    	
        var firstDayOfMonth = new Date(currentYear, currentMonth, 1);
        var daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();
        var startDayOfWeek = firstDayOfMonth.getDay(); // 0 (Sunday) to 6 (Saturday)

        $("#currentMonth").text(currentMonth + 1);

        var calendarDates = $("#calendarDates");
        calendarDates.empty();
        
        var result = vctnCalendar(formattedMonth);
       	

        var date = 1;
        
        for (var i = 0; date <= daysInMonth; i++) {
            var row = $("<tr></tr>");
            
            for (var j = 0; j < 7; j++) {
                if (i === 0 && j < startDayOfWeek) {
                    row.append('<td class="date empty"></td>');
                } else if (date > daysInMonth) {
                    row.append('<td class="date empty"></td>');
                } else {
                    var vctn = "";
                    var applyW = 0;
                    var applyY = 0;
                    var applyN = 0;
                    for (var k = 0; k < result.length; k++) {
                        var apply = result[k].applyYn;
                        
                        var vctnStrDate = result[k].vctnStrDate;
                        var vctnEndDate = result[k].vctnEndDate;
                        
                        var strMonth = parseInt(vctnStrDate.slice(5,7),10);
                        var endMonth = parseInt(vctnEndDate.slice(5,7),10);
                        var strDate = parseInt(vctnStrDate.slice(-2),10);
                        var endDate = parseInt(vctnEndDate.slice(-2),10);
                        
                        if (endMonth != currentMonth + 1 && endMonth != strMonth) {
                            endDate += daysInMonth;
                        }
                        if (strMonth != currentMonth + 1 && strMonth != endMonth){
                        	strDate -= daysInMonth;
                        }
                        
                        if (date >= strDate && date <= endDate) {
	                        var size = 0;
	                        var count = 0;
	                        
	                        if (result[k].applyYn === 'W') {
	                            applyW++;
	                        }
	                        if (result[k].applyYn === 'Y') {
	                            applyY++;
	                        }
	                        if (result[k].applyYn === 'N') {
	                            applyN++;
	                        }
	                        
                            if (apply == "W") {
                                size++;
                            }
                            if (size > 0 && apply == "W") {
                                vctn += "<li><a href='' class='btnType2 color1' id='btnWDetailVctn' name='btn' value='" + formattedMonth + "-" + date.toString().padStart(2, '0') + "'><span>미승인</span>"+ applyW +"건</a></li>";
                            }
                            if (apply == "Y") {
                                size++;
                            }
                            if (size > 0 && apply == "Y") {
                                vctn += "<li><a href='' class='btnType2 color2' id='btnYDetailVctn' name='btn' value='" + formattedMonth + "-" + date.toString().padStart(2, '0') + "'><span>승인</span>"+ applyY +"건</a></li>";
                            }
                            if (apply == "N") {
                                size++;
                            }
                            if (size > 0 && apply == "N") {
                                vctn += "<li><a href='' class='btnType2 color3' id='btnNDetailVctn' name='btn' value='" + formattedMonth + "-" + date.toString().padStart(2, '0') + "'><span>반려</span>"+ applyN +"건</a></li>";
                            }
                            $("#applyYn").text("");
                        }
                    }
                    row.append('<td><ul><li class="date">' + date + '</li>' + vctn + '</ul></td>');
                    date++;
                }
            }

            calendarDates.append(row);
        }
    }
    
    // 불러오기
    function vctnCalendar(formattedMonth){
    	var detail = {};
    	
    	var param = {
    			formattedMonth: formattedMonth
		};
    	
    	var callback = function(data) {
    		detail = data.detailValue;
    	};
    	
    	callAjax("/employee/vctnCalendarList.do", "post", "json", false, param, callback);
    	
    	return detail;
    }
    
    // 버튼 이벤트
    function btnEvent(){
    	$(document).on('click', 'a[name=btn]', function(e) {
			e.preventDefault();
			
			var btnId = $(this).attr("id");

			switch(btnId) {
			case "btnYDetailVctn":
				var date = $(this).attr("value");
				vctnDetail('Y', date);
				break;
			case "btnNDetailVctn":
				var date = $(this).attr("value");
				vctnDetail('N', date);
				break;
			case "btnWDetailVctn":
				var date = $(this).attr("value");
				vctnDetail('W', date);
				break;
			case "btnClose" :
				gfCloseModal("#vctnApplyModal");
			}
		});
	}
    
    // 모달 불러오기
    function vctnDetail(applyYn, date){
    	
    	var applyYn = applyYn;
    	
    	if(applyYn == 'N'){
	    	$("#title").text(date + " 반려건 현황");
    	}
    	if(applyYn == 'W'){
	    	$("#title").text(date + " 미승인건 현황");
    	}
    	if(applyYn == 'Y'){
	    	$("#title").text(date + " 승인건 현황");
    	}
    	
    	searchVctn(applyYn, date);
    	
		gfModalPop("#applyModal");    	
    }
    
    function searchVctn(applyYn, date){
    	
    	var applyYn = applyYn;
    	var date = date;
    	
    	var param = {
    			applyYn : applyYn,
    			date : date,
          };
          
    	var callBackFunction = function(response){
			$("#applyList").empty().append(response);
		}
          
    	callAjax("/employee/vctnCalendarApplyList.do", "post", "text", false, param, callBackFunction);
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
						<span class="btn_nav bold">근태현황조회</span>
						<a href="../employee/vctnCalendar.do" class="btn_set refresh">새로고침</a>
					</p>
						
					<p class="conTitle">
						<span> 근태현황조회 </span> 
					</p>
					
					<div id="calendar" style="width:100%;">
						<div id="header" style="width:100%; display:flex; justify-content:center; align-items:center;">
							<a href="" class="btnType" id="preBtn" name="btn"><span>&lt;</span></a>
							<div id="currentMonth" style="width:100px; height:31px; text-align:center; line-height:31px; font-size:30px;"></div>
							<a href="" class="btnType" id="nextBtn" name="btn"><span>&gt;</span></a> 
						</div>
						<table style="margin-top:10px; margin-bottom:10px; text-align:center;" width="100%" cellpadding="5" cellspacing="0" border="1"
                        style="collapse; border: 1px #50bcdf;" class="col">
                        	<colgroup>
                        		<col style="width:140px;"></col>
                        		<col style="width:140px;"></col>
                        		<col style="width:140px;"></col>
                        		<col style="width:140px;"></col>
                        		<col style="width:140px;"></col>
                        		<col style="width:140px;"></col>
                        		<col style="width:140px;"></col>
                        	</colgroup>
							<thead>
								<tr>
									<th class="day">일</th>
									<th class="day">월</th>
									<th class="day">화</th>
									<th class="day">수</th>
									<th class="day">목</th>
									<th class="day">금</th>
									<th class="day">토</th>
								</tr>
							</thead>
							<tbody id="calendarDates">
							</tbody>
						</table>
					</div>
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>
</form>

	
	<!-- 승인/반려/미승인 모달  -->
	<div id="applyModal" class="layerPop layerType2" style="width:600px;">
		<input type="hidden" id="applyYn">
		<dl>
			<dt>
				<strong id="title"></strong>
			</dt>
			<dd class="content">
				<table class="col" style="width:100%;">
					<thead>
						<tr>
							<th scope="col">부서</th>
							<th scope="col">사원명</th>
							<th scope="col">신청구분</th>
						</tr>
					</thead>
					<tbody id="applyList">
						<tr>
							<td></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_areaC mt30">
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>닫기</span></a>
				</div>
			</dd>
		</dl>
	</div>
</body>
</html>