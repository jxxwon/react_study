<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 거래처 목록이 없는 경우  -->
<c:if test="${empty bizPartnerList}">
	<tr>
		<td colspan="7">데이터가 존재하지 않습니다.</td>
	</tr>
</c:if>


<!-- 거래처 목록 있는 경우  -->
<c:if test="${not empty bizPartnerList}">
	<c:set var="nRow" value="${pageSize*(currentPage-1)}" />
	<c:forEach items="${bizPartnerList}" var="bizPartner">
		<tr>
			<td><fmt:formatDate value="${bizPartner.regDate}" pattern="yyyy-MM-dd" /></td>
			<td><a href="javascript:bizPartnerDetailModal(${bizPartner.custId});">${bizPartner.custName}</a></td>
			<c:set var="address" value="${bizPartner.custAddr} ${bizPartner.custDetailAddr}" />
			<td>${address}</td>
			<td>${bizPartner.custPerson}</td>
			<td>${bizPartner.custPh}</td>
			<td>${bizPartner.custPersonPh}</td>
			<td>${bizPartner.custEmail}</td>
			<!-- List에 있는 js 함수 호출가능 이거 그대로 가지고 가기 때문에 !!  -->
		</tr>
		<c:set var="nRow" value="${nRow + 1}" />
	</c:forEach>
</c:if>

<!-- 이거 중간에 있으면 table 안먹힘  -->
<input type="hidden" id="totcnt" name="totalCnt" value="${bizPartnaerCnt}" />