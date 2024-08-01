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
			<td><a href="javascript:openModal('${item.type}', ${item.num});">${item.num}</a></td>
			<td>${item.type eq "estm" ? "견적서" : "SCM 수주"}</td>
			<td>${item.custName}</td>
			<td><fmt:formatNumber value="${item.amount}" pattern="#,###" /></td>
			<td>${item.bookDate}</td>
			<td>${item.expireState eq "Y" ? "납품완료" : "납품미완료"}</td>
			<td>${item.unpaidState eq "Y" ? "수금완료" : "미수금"}</td>
			<td>${item.userName}</td>
		</tr>
		<c:set var="nRow" value="${nRow + 1}" /> 
	</c:forEach>
</c:if>

<input type="hidden" id="totalCount" name="totalCount" value="${totalCount}"/>
