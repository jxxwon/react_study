<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


				
		<!-- 갯수가 0인 경우  -->
		<c:if test="${empSalaryCnt eq 0 }">
			<tr>
				<td colspan="10">등록된 연봉이 없습니다.</td>
			</tr>
		</c:if>
		

		<!-- 갯수가 있는 경우  -->
		<c:if test="${empSalaryCnt > 0 }">
			<c:forEach items="${empSalaryList}" var="list">
				<tr>
				    <td>${list.posName}</td>
					<td>${list.year1}</td>
					<td>${list.year2}</td>
					<td>${list.year3}</td>
					<td>${list.year4}</td>
					<td>${list.year5}</td>
				</tr>
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="totcnt" name="totcnt" value="${empSalaryCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->
