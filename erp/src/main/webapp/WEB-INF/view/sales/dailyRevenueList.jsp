<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:if test="${totalCount eq 0 }">
	<tr>
		<td colspan="11">데이터가 존재하지 않습니다.</td>
	</tr>
</c:if>

<c:if test="${totalCount > 0 }">
	<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
	<c:forEach items="${list}" var="item">
		<tr>
			<td>${item.bookDate}</td>
			<td>${item.custId}</td>
			<td>${item.custName}</td>
			<td><fmt:formatNumber value="${item.amount}" pattern="#,###" /></td>
			<td><fmt:formatNumber value="${item.payAmount}" pattern="#,###" /></td>
			<td><fmt:formatNumber value="${item.unpaidState == 'N' ? item.amount : 0}" pattern="#,###" /></td>
		</tr>
		<c:set var="nRow" value="${nRow + 1}" /> 
	</c:forEach>
</c:if>

<input type="hidden" id="totalAmount" name="totalAmount" value="${totalAmount}"/>
<input type="hidden" id="totalPayAmount" name="totalPayAmount" value="${totalPayAmount}"/>
<input type="hidden" id="totalUnpaid" name="totalUnpaid" value="${totalUnpaid}"/>
<input type="hidden" id="totalCount" name="totalCount" value="${totalCount}"/>
