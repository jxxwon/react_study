<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:if test="${list.size() eq 0 }">
	<tr>
		<td colspan="11">데이터가 존재하지 않습니다.</td>
	</tr>
</c:if>

<c:if test="${list.size() > 0 }">
	<c:forEach items="${list}" var="item">
		<tr class="revenue-item">
			<td>${item.bookDate}</td>
			<td><fmt:formatNumber value="${item.amount}" pattern="#,###" /></td>
			<td><fmt:formatNumber value="${item.payAmount}" pattern="#,###" /></td>
			<td><fmt:formatNumber value="${item.unpaidAmount}" pattern="#,###" /></td>
		</tr>
	</c:forEach>
</c:if>

<input type="hidden" id="totalAmount" name="totalAmount" value="${totalAmount}"/>
<input type="hidden" id="totalPayAmount" name="totalPayAmount" value="${totalPayAmount}"/>
<input type="hidden" id="totalUnpaidAmount" name="totalUnpaidAmount" value="${totalUnpaidAmount}"/>
