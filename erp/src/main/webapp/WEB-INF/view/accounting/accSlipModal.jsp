<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>					
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
							<c:if test="${totalCount eq 0 }">
								<tr>
									<td colspan="7">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							<c:forEach items="${listAccSlipModelModal}" var="list">
									<tr>
										<td>${list.acct_num}</td>					
										<td>${list.book_date}</td>			
										<td>${list.cust_person}</td>				
										<td>${list.cust_name}</td>			
										<td>${list.acct_code}</td>			
										<td>${list.amount}</td>					
										<td>${list.cust_memo}</td>						
									</tr>
							</c:forEach>
