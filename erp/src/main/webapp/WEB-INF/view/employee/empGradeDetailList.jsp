<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!-- 갯수가 0인 경우  -->
		<c:if test="${empGradeDetailCnt eq 0 }">
			<tr>
				<td colspan="10">등록된 사원이 없습니다.</td>
			</tr>
		</c:if>
		

		<!-- 갯수가 있는 경우  -->
		<c:if test="${empGradeDetailCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
			<c:forEach items="${empGradeDetailList}" var="list">
				<tr>
					<td>${list.issuDate}</td>
					<td>${list.posName}</td>
				 <c:set var="nRow" value="${nRow + 1}" /> 
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="detailTotcnt" name="detailTotcnt" value="${empGradeDetailCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->
