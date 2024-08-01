<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>일별 매출 현황</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.js"></script>
<script type="text/javascript">
var pageSize = 5;
var blockPage = 10;

$(function() {
	$("#date").val(getToday());
	
	search();
	
	$("#btnSearch").click(function(e){
		e.preventDefault();
		
		search();
	});
});

function search(currentPage) {
	currentPage = currentPage || 1;
	
	var params = {
		date: $("#date").val(),
		account: $("#account").val(),
		currentPage: currentPage,
		pageSize: pageSize
	};

	function callback(res) {
		$("#list").html(res);
		
		var pageNavigateHtml = getPaginationHtml(currentPage, $("#totalCount").val(), pageSize, blockPage, "search");
		$("#pagingNavi").html(pageNavigateHtml);
		$("#currentPage").val(currentPage);
		
		var ta = $("#totalAmount").val();
		var tpa = $("#totalPayAmount").val();
		var tu = $("#totalUnpaid").val();
		
		$("#totalAmountTd").html(numberWithCommas(ta));
		$("#totalPayAmountTd").html(numberWithCommas(tpa));
		$("#totalUnpaidTd").html(numberWithCommas(tu));
		$("#totalProfit").html(numberWithCommas(ta - tpa));
		
		/**
		 * 참고  :  https://www.chartjs.org/docs/2.7.3/
		 */
		$('#chart').remove();
		$('#chartContainer').append('<canvas id="chart"></canvas>');
		var ctx = document.getElementById('chart');

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ["총매출액", "총지출액", "총미수금액", "총순이익"],
                datasets: [{
                    label: '#',
                    backgroundColor: ['#fb6868', '#9d9dff', 'cadetblue', '#e5c72a'],
                    data: [ta, tpa, tu, ta - tpa],
                    borderWidth: 1
                }]
            },
            options: {
                layout: {
                	padding: {
                		top: 50
                	}
                },
                legend: {
                    display: false
                },
                scales: {
                	yAxes: [{
                        ticks: {
                            min: 0,
                            callback: function(label) {
                                return numberWithCommas(label);
                            }
                        }
                    }]
                },
                tooltips: {
                    callbacks: {
                        label: function(item){
                            return numberWithCommas(item.yLabel);
                        }
                    }
                }
            }
        });
	}

	callAjax("/sales/searchDaily.do", "post", "text", false, params, callback);
}

function getToday(){
    var date = new Date();
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);

    return year + "-" + month + "-" + day;
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
</script>
</head>
<body>
	<div id="wrap_area">
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<div id="container">
			<ul>
				<li class="lnb">
					<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
				</li>

				<li class="contents">
					<div class="content">
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a>
							<a href="#" class="btn_nav bold">매출</a>
							<span class="btn_nav bold">일별 매출 현황</span>
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>

						<div class="content-title">
							<span>일별 매출 현황</span>
							<div class="container">
								<div class="row">
									<div class="column-25">
										<label>거래처 명</label>
										<input type="text" id="account" />
									</div>
									<div class="column-50">
										<label>날짜</label>
										<input type="date" id="date" />
									</div>
									<div class="column-25 align-end">
										<a class="btnType red" href="" id="btnSearch"><span>검색</span></a>
									</div>
								</div>
							</div>
						</div>
						<div>
							<table class="col">
								<colgroup>
					            	<col width="16%" />
					            	<col width="16%" />
					            	<col width="17%" />
					            	<col width="17%" />
					            	<col width="17%" />
					            	<col width="17%" />
				                </colgroup>
								<thead>
									<tr>
							            <th scope="col">날짜</th>
							            <th scope="col">거래처코드</th>
							            <th scope="col">거래처명</th>
							            <th scope="col">매출액</th>
							            <th scope="col">지출액</th>
							            <th scope="col">미수금액</th>
									</tr>
								</thead>
								<tbody id="list"></tbody>
							</table>
							<div class="paging_area" id="pagingNavi"></div>				
						</div>
						<div class="container">
							<div class="row">
								<div id="chartContainer" class="column-50"></div>
								<div class="column-50">
									<table class="row">
										<colgroup>
							            	<col width="50px" />
							            	<col width="50px" />
						                </colgroup>
										<tbody>
											<tr>
												<th>총매출액</th>
												<td id="totalAmountTd"></td>
											</tr>
											<tr>
												<th>총지출액</th>
												<td id="totalPayAmountTd"></td>
											</tr>
											<tr>
												<th>총미수금액</th>
												<td id="totalUnpaidTd"></td>
											</tr>
											<tr>
												<th>총순이익</th>
												<td id="totalProfit"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>
