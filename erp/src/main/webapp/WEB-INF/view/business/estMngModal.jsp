<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
#cust_name22, #erp_copnm {
	background-color: #BBC1CD;
	font-weight: bolder;
	text-align: center;
}
</style>

<!-- 모달이 여러개라 id값 name값 다르게-->


<!-- 모달팝업2 ==  readOnly -->
<div id="layer2" class="layerPop layerType2" style="width: 800px;">
	<dl>
		<dt>
			<div id="divtitle" style="color: white">
				<b>견적서 상세 조회</b>
			</div>
		</dt>
		<dd class="content">
			<!-- s : 여기에 내용입력 -->
			<table class="row">
				<caption>caption</caption>
				<colgroup>
					<col width="120px">
					<col width="200px">
					<col width="120px">
					<col width="200px">
				</colgroup>

				<tbody>

					<tr>
						<th scope="row" colspan="2"><input type="text"
							name="cust_name" id="cust_name22" readOnly /></th>
						<th scope="row" colspan="2"><input type="text"
							name="erp_copnm" id="erp_copnm" readOnly /></th>
					</tr>

					<tr>
						<!-- 목록조회 외에 UPDATE, INSERT , DELETE 등을 위해 필요함  hidden 값  // INT가 아닌것도 있음  -->
						<td hidden=""><input type="text" class="inputTxt p100"
							name="estm_num" id="estm_num" /></td>

						<th scope="row">사업자등록번호</th>
						<td class="inputTxt p100"><input type="text"
							class="inputTxt p100" name="biz_num" id="biz_num" readOnly />
						<th scope="row">사업자등록번호</th>
						<td class="inputTxt p100"><input type="text"
							name="erp_copnum1" id="erp_copnum1"
							style="width: 20%; height: 70%" maxlength="4" readOnly> -
							<input type="text" name="erp_copnum2" id="erp_copnum2"
							style="width: 20%; height: 70%" maxlength="4" readOnly>
							- <input type="text" name="erp_copnum3" id="erp_copnum3"
							style="width: 20%; height: 70%" maxlength="4" readOnly />
					</tr>

					<tr>
						<th scope="row">담당자</th>
						<td><input type="text" class="inputTxt p100"
							name="cust_person" id="cust_person" readOnly /></td>
						<th scope="row">담당자</th>
						<td><input type="text" class="inputTxt p100" name="emp_name"
							id="emp_name" readOnly /></td>
					</tr>

					<tr>
						<th scope="row">주소</th>
						<td><input type="text" class="inputTxt p100"
							name="cust_addr" id="cust_addr" readOnly /></td>
						<th scope="row">주소</th>
						<td><input type="text" class="inputTxt p100" name="erp_addr"
							id="erp_addr" readOnly /></td>
					</tr>
					<tr>
						<th scope="row">나머지 주소</th>
						<td><input type="text" class="inputTxt p100"
							name="cust_detail_addr" id="cust_detail_addr" readOnly /></td>
						<th scope="row">나머지주소</th>
						<td><input type="text" class="inputTxt p100"
							name="erp_addr_other" id="erp_addr_other" readOnly /></td>
					</tr>
					<tr>
						<th scope="row">TEL</th>
						<td><input type="text" class="inputTxt p100"
							name="cust_person_ph" id="cust_person_ph" readOnly /></td>

						<th scope="row">TEL</th>
						<td><input type="text" class="inputTxt p100" name="erp_tel"
							id="erp_tel" readOnly /></td>

					</tr>


					

					<!--  한 칸 띄우기  -->
					<tr>
						<td colspan="4" class="inputTxt p100">
						<div class="btn_areaC mt30" id="test"></div>
						<%-- <c:if test="${estpart[0].apply_yn eq 'W'}">
			  					<div class="btn_areaC mt30" id="test">
			  							<input value="${estm_num}" type="hidden" id="estm_num">
						               <a href=""   class="btnType blue" id="btnApplyYes" name="btn"><span>승인</span></a>
						       	</div>
						</c:if> --%>
					</tr>
					
					<tr>
						<td scope="row" colspan="4"><br> 1. 귀사의 일익 번창하심을 기원합니다.
							<br> 2. 하기와 같이 견적드리오니 검토하기 바랍니다.<br>
					</tr>
					<tr>
						<th scope="row">견적작성일</th>
						<td class="inputTxt p100"><input type="text" name="estm_date"
							id="estm_date" style="width: 70%; height: 70%" readOnly />
					</tr>


					<table class="col">
						<caption>caption</caption>
						<colgroup>
							<col width="10%">
							<col width="15%">
							<col width="15%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
						</colgroup>
						<thead>

							<tr>
								<th scope="col">제품명</th>
								<th scope="col">공급가액</th>
								<th scope="col">세액</th>
								<th scope="col">제품단가</th>
								<th scope="col">수량</th>
							</tr>
						</thead>
						<tbody id="EstDetaillist">
						</tbody>
						<!--  detail 끼워넣기  -->
					</table>
					<div class="btn_areaC mt30">

						<a href="" class="btnType gray" id="btnCloseEst" name="btn"><span>닫기</span></a>
					</div>
					</dd>
					</dl>
					</div>
				</tbody>
			</table>
		</dd>
	</dl>
</div>




<!-- 모달2 끝 -->


