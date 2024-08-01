<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<c:forEach items="${vctnCalendarApplyList}" var="list">
	<tr>
		<td>${list.deptName}</td>
		<td>${list.name}</td>
		<td>${list.vctnName}</td>
	</tr>
</c:forEach>

<!-- 이거 중간에 있으면 table 안먹힘  -->
