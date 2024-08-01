<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

		<!-- 갯수가 0인 경우  -->
		<c:if test="${salaryManageDetailListCnt eq 0 }">
			<tr>
				<td colspan="14">등록된 데이터가 없습니다.</td>
			</tr>
		</c:if>
		

		<!-- 갯수가 있는 경우  -->
		<c:if test="${salaryManageDetailListCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
			<c:forEach items="${salaryManageDetailList}" var="list">
				<tr>
					<td>${list.salary_year}</td>
					<td>${list.dept_name}</td>
					<td>${list.pos_name}</td>
					<td>${list.loginID}</td>
					<td>${list.name}</td>
					<td><fmt:formatNumber value="${list.annual_salary}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${list.annual_salary / 12}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${list.nation_pens}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${list.health_insur}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${list.empl_insur}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${list.workers_insur}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${list.salary}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${list.pens}" pattern="#,###" /></td>
					<td>${list.pay_status}</td>
				 <c:set var="nRow" value="${nRow + 1}" /> 
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="totcnt_detail" name="totcnt_detail" value="${salaryManageDetailListCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->
