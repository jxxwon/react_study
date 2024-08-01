<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<title> 급여내역서  </title>

<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">

$(function() {
	salarySearch();
	registerBtnEvent();
});

// 검색 버튼 눌렀을 때
function registerBtnEvent() {
	$("#searchBtn").click(function(e) {
		e.preventDefault();
		
		salarySearch();
	});
}

//오늘 날짜 계산
var date = new Date();
var year = date.getFullYear();
var month = (date.getMonth()+1).toString().padStart(2,'0');
var day = date.getDate().toString().padStart(2,'0');
var currentMonth = year + "-" + month;

// 근무연차 계산
function calculateWorkDuration(joinDateStr) {
    var joinDate = new Date(joinDateStr);
    var currentDate = new Date();
    
    var years = currentDate.getFullYear() - joinDate.getFullYear();
    var months = currentDate.getMonth() - joinDate.getMonth();
    var days = currentDate.getDate() - joinDate.getDate();

    // 월, 일 차이를 조정
    if (days < 0) {
        months -= 1;
        days += new Date(currentDate.getFullYear(), currentDate.getMonth(), 0).getDate();
    }
    if (months < 0) {
        years -= 1;
        months += 12;
    }

    return { years: years, months: months, days: days };
}

function salarySearch() {
    searchDate = $("#searchDate").val() || currentMonth;
    $("#searchDate").val(searchDate);

    var param = {
        searchDate: searchDate
    };

    var callback = function(res) {
        // 테이블 초기화
        $("#deduct").html('');
        $("#payment").html('');

        // 입사일자
        var joinDateStr = res.emp_date;
        
        // 근무연차
        var workDuration = calculateWorkDuration(joinDateStr);
        
        // 해당년월에 급여 내역이 없는 경우
        if (res.salary_year == 0) {
            var noData = '<tr><td colspan="2">데이터가 존재하지 않습니다.</td></tr>';
            
            $("#user_name").val(res.name);
            $("#deduct").html(noData);
            $("#payment").html(noData);
                    
        } else {
            // 공제 항목 업데이트
            $("#deduct").append(
                '<tr>' +
                '    <th scope="col">국민연금</th>' +
                '    <td>' + res.nation_pens.toLocaleString() + '</td>' +
                '</tr>' +
                '<tr>' +
                '    <th scope="col">건강보험</th>' +
                '    <td>' + res.health_insur.toLocaleString() + '</td>' +
                '</tr>' +
                '<tr>' +
                '    <th scope="col">고용보험</th>' +
                '    <td>' + res.empl_insur.toLocaleString() + '</td>' +
                '</tr>' +
                '<tr>' +
                '    <th scope="col">산재보험</th>' +
                '    <td>' + res.workers_insur.toLocaleString() + '</td>' +
                '</tr>'
            );
            // 지급 항목 업데이트
            $("#payment").append(
                '<tr>' +
                '    <th scope="col">실급여</th>' +
                '    <td>' + res.salary.toLocaleString() + '</td>' +
                '</tr>' +
                '<tr>' +
                '    <th scope="col">연봉</th>' +
                '    <td>' + res.annual_salary.toLocaleString() + '</td>' +
                '</tr>'
            );

            $("#user_name").val(res.name);
            $("#pos_name").val(res.pos_name);
            $("#year").val(workDuration.years + "년차");
        }
        
    };

    callAjax("/employee/salaryList.do", "post", "json", false, param, callback);
}

</script>
</head>
<body>
	<input type="hidden" id="currentPage" value="1">
	<input type="hidden" name="action" id="action" value=""> 

	<div id="wrap_area">
		<h2 class="hidden">header 영역</h2> 
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> 
					<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a> 
							<a href="#" class="btn_nav bold">인사/급여</a> 
							<span class="btn_nav bold">급여 조회</span> 
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>
						
					<p class="conTitle">
						<span>급여내역서</span> 
						<span class="fr">
                          	기준년월
                          <input type="month" id="searchDate" name="searchDate" style="height: 25px; margin-right: 10px;"/> 

						  <a class="btnType red" href="" name="searchbtn"  id="searchBtn"><span>검색</span></a>
						</span>
					</p> 
						
						<div class="listContainer" >
							<p class="userInput">
								<span>
								 	사원명 
		                          <input type="text" id="user_name" name="name" style="height: 25px; margin-right: 10px;" readonly disabled/>
		                          	 직급 
		                          <input type="text" id="pos_name" name="pos" style="height: 25px; margin-right: 10px;" readonly disabled/>
		                         	 근무연차 
		                          <input type="text" id="year" name="year" style="height: 25px;" readonly disabled/>
								</span>
							</p>
							<div class="deductList">
								<table class="col salarytable">
									<caption>caption</caption>
			                            <colgroup>
							                   <col width="30%">
							                   <col width="70%">
						                 </colgroup>
									<thead>
										<tr>
								              <th scope="col">공제항목</th>
								              <th scope="col">금액</th>								              
										</tr>
									</thead>
									<tbody id="deduct"></tbody>
								</table>
							</div> <!-- deductList -->
							
							<div class="paymentList">
								<table class="col salarytable">
									<caption>caption</caption>
			                            <colgroup>
							                   <col width="30%">
							                   <col width="70%">
						                 </colgroup>
									<thead>
										<tr>
								              <th scope="col">지급항목</th>
								              <th scope="col">금액(원)</th>							              
										</tr>
									</thead>
									<tbody id="payment"></tbody>
								</table>																											
							 </div>  <!-- paymentList -->
						</div> <!-- listContainer -->
		
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

</body>
</html>
