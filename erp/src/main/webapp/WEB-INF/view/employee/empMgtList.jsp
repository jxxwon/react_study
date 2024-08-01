<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<!-- 갯수가 0인 경우  -->
		<c:if test="${empMgtCnt eq 0 }">
			<tr>
				<td colspan="10">등록된 사원이 없습니다.</td>
			</tr>
		</c:if>
		

		<!-- 갯수가 있는 경우  -->
		<c:if test="${empMgtCnt > 0 }">
			<c:set var="nRow" value="${pageSize*(currentPage-1)}" /> 
			<c:forEach items="${empMgtList}" var="list">
				<tr>
					<td><a href = "javascript:empMgtdetailModal('${list.loginId}');">${list.loginId}</a></td>
					<td>${list.name}</td>
					<td>${list.deptCode}</td>
					<td>${list.deptName}</td>
					<td>${list.posName}</td>
					<td>${list.empDate}</td>
					<td>
						<c:if test = "${list.emplStatus == 'W' || list.emplStatus == 'O'}">재직</c:if>
						<c:if test = "${list.emplStatus == 'R'}">퇴직</c:if>
					</td>
					<td>
						<c:choose>
							<c:when test = "${list.emplStatus == 'O' }">Y</c:when>
							<c:otherwise>N</c:otherwise>
						</c:choose>
					</td>
					<td>${list.leaveDate}</td>
					<td>
						<c:if test = "${list.emplStatus != 'R'}">
							<a href="javascript:empRetireModal('${list.loginId}')" class="btnType"><span>퇴직처리</span></a>
						</c:if>
					</td>
				</tr>
				 <c:set var="nRow" value="${nRow + 1}" /> 
			</c:forEach>
		</c:if>
		
		<input type="hidden" id="totcnt" name="totcnt" value="${empMgtCnt}">
		<!-- 이거 중간에 있으면 table 안먹힘  -->
