<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>
	<c:if test="${isMonthly eq 'Y' }">
		월별 매출 현황
	</c:if>
	<c:if test="${isMonthly eq 'N' }">
		년별 매출 현황
	</c:if>
</title>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.js"></script>
<style>
#totalTable td {
	text-align: end;
}

.year-warn {
	margin-left: 10px;
	color: red;
	font-size: 12px;
}

.hide {
	display: none;
}
</style>
<script type="text/javascript">
var isMonthly;

$(function() {
	var today = new Date();
    var year = today.getFullYear();
    
	isMonthly = $("#isMonthly").val();
	if ('Y' === isMonthly) {
		var month = ("0" + (1 + today.getMonth())).slice(-2);
		
		$("#month").val(year + "-" + month);
	} else {
		$("#year").val(year);
	}
	
	search();
	
	$("#btnSearch").click(function(e){
		e.preventDefault();
		
		search();
	});
	
	$("#btnSearchItem").click(function(e){
		e.preventDefault();
		
		btnSearchItem();
	});
	
	$("#btnSearchCust").click(function(e){
		e.preventDefault();
		
		btnSearchCust();
	});
	
	$("#year").keypress(function(e) {
		if (e.target.value.length > 3) {
			$("#yearMaxWarn")[0].classList.remove("hide");
		} else {
			$("#yearMaxWarn")[0].classList.add("hide");
		}
	});
	
	$("#year").on('input', function(e){
		$("#yearMaxWarn")[0].classList.add("hide");

		if (e.originalEvent.data && !/^\d$/.test(e.originalEvent.data)) {
			$("#yearNumWarn")[0].classList.remove("hide");
        	$("#year").val($("#year").val().replace(e.originalEvent.data, ''));
	    } else {
	    	$("#yearNumWarn")[0].classList.add("hide");
	    }
	})
});

function search() {
	var year = $("#year").val();

	if (year && (year <= 1990 || year >= 2034)) {
		alert("연도를 확인해주세요.");
		return;
	}
	
	var params = isMonthly === "Y" ? {
		isMonthly: isMonthly,
		month: $("#month").val(),
		account: $("#account").val()
	} : {
		isMonthly: isMonthly,
		year: year,
		account: $("#account").val()
	};
	
	function callback(res) {
		$("#list").html(res);
		
		var ta = $("#totalAmount").val();
		var tpa = $("#totalPayAmount").val();
		var tu = $("#totalUnpaidAmount").val();
		
		$("#totalAmountTd").html(numberWithCommas(ta));
		$("#totalPayAmountTd").html(numberWithCommas(tpa));
		$("#totalUnpaidAmountTd").html(numberWithCommas(tu));
		$("#totalProfit").html(numberWithCommas(ta - tpa));
		
		/**
		 * Chart.js 참고  : https://www.chartjs.org/docs/2.7.3/
		 */
		$('#chart').remove();
		$('#chartContainer').append('<canvas id="chart"></canvas>');
		var ctx = document.getElementById('chart');
		var labels = [];
		var amounts = [];
		var pays = [];
		var unpaids = [];
		var profits = [];
		var datasets = [];
		
		var monthlyItems = $(".revenue-item");
		
		for (var i = 0; i < monthlyItems.length; i++) {
			var childs = monthlyItems[i].cells;
			var amount = childs[1].innerText.replaceAll(',', '');
			var pay = childs[2].innerText.replaceAll(',', '');
			
			labels.push(childs[0].innerText);
			amounts.push(amount);
			pays.push(pay);
			unpaids.push(childs[3].innerText.replaceAll(',', ''));
			profits.push(amount - pay)
		}
		
		datasets.push(makeDataset('매출', amounts, 'red'));
		datasets.push(makeDataset('지출', pays, 'blue'));
		datasets.push(makeDataset('미수금', unpaids, 'cadetblue'));
		datasets.push(makeDataset('순이익', profits, '#e5c72a'));

        new Chart(ctx, {
        	type: 'line',
            data: {
            	labels: labels.reverse(),
                datasets: datasets
            },
            options: {
            	scales: {
                    yAxes: [
                        {
                            ticks: {
                                callback: function(label) {
                                    return numberWithCommas(label);
                                }
                            }
                        }
                    ]
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
        
        function makeDataset(label, data, color) {
        	return {
            	label: label,
                data: data.reverse(),
                borderColor: color,
                borderWidth: 1,
                fill: false
            }
        }
	}
	
	callAjax("/sales/searchRevenue.do", "post", "text", false, params, callback);
}

function btnSearchItem() {
	openModal("item");
}

function btnSearchCust() {
	openModal("cust");
}

function openModal(type) {
	var params = isMonthly === "Y" ? {
		type: type,
		isMonthly: isMonthly,
		month: $("#month").val(),
		account: $("#account").val()
	} : {
		type: type,
		isMonthly: isMonthly,
		year: $("#year").val(),
		account: $("#account").val()
	};
	
	function callback(res) {
		$("#modal").html(res);
		
		if ($("#listSize").val() !== '0') {
			var topRevenueList = $(".top-revenue-list");
			var names = [];
			var amounts = [];
			
			$('#topChart').remove();
			$('#topChartContainer').append('<canvas id="topChart"></canvas>');
			var ctx = document.getElementById('topChart');
			
			for (var i = 0; i < topRevenueList.length; i++) {
				var childs = topRevenueList[i].cells;
				
				names.push(childs[1].innerText);
				amounts.push(childs[2].innerText.replaceAll(',', ''));
			}
			
			new Chart(ctx, {
	        	type: 'pie',
	            data: {
	            	datasets: [{
	                    data: amounts,
	                    backgroundColor: ['#fb6868', '#9d9dff', 'cadetblue', '#e5c72a', 'pink']
	                }],
	            	labels: names
	            },
	            options: {
	            	tooltips: {
	                    callbacks: {
	                        label: function(item, chart){
	                        	var index = item.index;
	                        	var data = chart.datasets[0].data[index];
	                            return numberWithCommas(data);
	                        }
	                    }
	                }
	            }
	        });
		}
		
		gfModalPop("#modal");
	}
	
	callAjax("/sales/searchTop.do", "post", "text", false, params, callback);
}

function btnCloseHandler() {
	gfCloseModal();
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
</script>
</head>
<body>
	<input type="hidden" id="isMonthly" name="isMonthly" value="${isMonthly}"/>
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
							<span class="btn_nav bold">
								<c:if test="${isMonthly eq 'Y' }">
									월별 매출 현황
								</c:if>
								<c:if test="${isMonthly eq 'N' }">
									년별 매출 현황
								</c:if>
							</span>
							<a href="#" class="btn_set refresh">새로고침</a>
						</p>

						<div class="content-title">
							<span>
								<c:if test="${isMonthly eq 'Y' }">
									월별 매출 현황
								</c:if>
								<c:if test="${isMonthly eq 'N' }">
									년별 매출 현황
								</c:if>
							</span>
							<div class="container">
								<div class="row">
									<div class="column-25">
										<label>거래처 명</label>
										<input type="text" id="account" />
									</div>
									<div class="column-50">
										<c:if test="${isMonthly eq 'Y' }">
											<label>년-월</label>
											<input type="month" id="month" />
										</c:if>
										<c:if test="${isMonthly eq 'N' }">
											<label>연도</label>
											<input id="year" type="text" maxlength="4"/>
											<span id="yearNumWarn" class="hide year-warn">숫자만 입력할 수 있습니다.</span>
											<span id="yearMaxWarn" class="hide year-warn">4개 이상은  입력되지 않습니다.</span>
										</c:if>
									</div>
									<div class="column-25 align-end">
										<a class="btnType" href="" id="btnSearch"><span>검색</span></a>
									</div>
								</div>
							</div>
						</div>
						
						<div style="margin-bottom: 10px; text-align: end;">
							<a class="btnType" href="" id="btnSearchItem"><span>매출 상위 제품</span></a>
							<a class="btnType" href="" id="btnSearchCust"><span>매출 상위 기업</span></a>
						</div>
						
						<div>
							<table class="col">
								<colgroup>
					            	<col width="25%" />
					            	<col width="25%" />
					            	<col width="25%" />
					            	<col width="25%" />
				                </colgroup>
								<thead>
									<tr>
							            <th scope="col">
								            <c:if test="${isMonthly eq 'Y' }">
												<label>년-월</label>
											</c:if>
											<c:if test="${isMonthly eq 'N' }">
												<label>연도</label>
											</c:if>
							            </th>
							            <th scope="col">매출</th>
							            <th scope="col">지출</th>
							            <th scope="col">미수금</th>
									</tr>
								</thead>
								<tbody id="list"></tbody>
							</table>	
						</div>
						
						<div class="container">
							<div class="row">
								<div id="chartContainer" class="column-50"></div>
								<div class="column-50">
									<table id="totalTable" class="row">
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
												<td id="totalUnpaidAmountTd"></td>
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
	
	<div id="modal" class="layerPop layerType2" style="width: 800px;"></div>
</body>
</html>
