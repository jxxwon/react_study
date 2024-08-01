<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!-- 갯수가 0인 경우  -->
		<c:if test="${empGradeCnt eq 0 }">
			<tr>
				<td colspan="10">등록된 사원이 없습니다.</td>
			</tr>
		</c:if>
		

		<!-- 갯수가 있는 경우  -->
		<c:if test="${empGradeCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
			<c:forEach items="${empGradeList}" var="list">
				<tr>
					<td><a href = "javascript:empGradeDetailModal('${list.loginId}', '${list.name}', '${list.deptName}', '${list.posName}');">${list.loginId}</a></td>
					<td>${list.name}</td>
					<td>${list.deptCode}</td>
					<td>${list.deptName}</td>
					<td>${list.posName}</td>
					<td>${list.issuDate}</td>
				 <c:set var="nRow" value="${nRow + 1}" /> 
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="totcnt" name="totcnt" value="${empGradeCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->
