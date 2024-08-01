<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<dl>
	<dt>
		<strong>미수금 관리 상세</strong>
	</dt>
	<dd class="content">
		<table class="row">
			<colgroup>
				<col width="13%">
				<col width="37%">
				<col width="13%">
				<col width="12%">
				<col width="13%">
				<col width="12%">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">수주일자</th>
					<td>${detail.bookDate}</td>
					<th scope="row">납품일자</th>
					<td colspan=3>${detail.expireDate}</td>
				</tr>
				<tr>
					<th scope="row">번호</th>
					<td>${detail.num}</td>
					<th scope="row">처리주체</th>
					<td colspan=3>${type eq "estm" ? "견적서" : "SCM 수주"}</td>
				</tr>
				<tr>
					<th scope="row">납품상태</th>
					<td>${detail.expireState eq "Y" ? "납품완료" : "납품미완료"}</td>
					<th scope="row">수금상태</th>
					<td>${detail.unpaidState eq "Y" ? "수금완료" : "미수금"}</td>
					<th scope="row">미납액</th>
					<td><fmt:formatNumber value="${detail.unpaidState eq 'Y' ? 0 : detail.amount}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th scope="row" colspan=2>입금정보</th>
					<th scope="row" colspan=4>거래처정보</th>
				</tr>
				<tr>
					<th scope="row">입금은행</th>
					<td>${detail.bankName}</td>
					<th scope="row">거래처</th>
					<td colspan=3>${detail.custName}</td>
				</tr>
				<tr>
					<th scope="row">계좌번호</th>
					<td>${detail.custAccount}</td>
					<th scope="row">거래처<br />담당자
					</th>
					<td colspan=3>${detail.custPerson}</td>
				</tr>
				<tr>
					<th scope="row" colspan=2>담당자</th>
					<th scope="row">거래처<br />담당자번호
					</th>
					<td colspan=3>${detail.custPersonPh}</td>
				</tr>
				<tr>
					<th scope="row">담당자</th>
					<td>${detail.userName}</td>
					<th scope="row">비고</th>
					<td colspan=3 style="text-align: center;">
						<c:if test="${type eq 'estm' && sessionScope.userType eq 'C' && detail.unpaidState eq 'N'}">
							<a href="#" class="btnType blue" id="btnSave" onclick="btnDepositHandler(${detail.num})"><span>입금</span></a>
						</c:if>
					</td>
				</tr>
			</tbody>
		</table>
	</dd>
	<dt>
		<strong>제품 목록</strong>
	</dt>
	<dd class="content">
		<table class="col">
			<colgroup>
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="20%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">이름</th>
					<th scope="col">단가</th>
					<th scope="col">부가세액</th>
					<th scope="col">공금가액</th>
					<th scope="col">수량</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${items.size() eq 0 }">
					<tr>
						<td colspan="5">데이터가 존재하지 않습니다.</td>
					</tr>
				</c:if>
				<c:if test="${items.size() > 0 }">
					<c:forEach items="${items}" var="item">
						<tr>
							<td>${item.itemName}</td>
							<td><fmt:formatNumber value="${item.itemPrice}" pattern="#,###" /></td>
							<td><fmt:formatNumber value="${item.itemSurtax}" pattern="#,###" /></td>
							<td><fmt:formatNumber value="${item.provideValue}" pattern="#,###" /></td>
							<td><fmt:formatNumber value="${item.qut}" pattern="#,###" /></td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
		</table>
	</dd>
</dl>
<a href="#" class="closePop" onclick="btnCloseHandler()">
	<span class="hidden">닫기</span>
</a>
