<%@page import="com.novell.nidp.wsfed.protocol.WSFedAuthnRequest"%>
<%@page import="com.novell.nidp.common.protocol.AuthnRequest"%>
<%@ page language="java" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.novell.nidp.*" %>
<%@ page import="com.novell.nidp.servlets.*" %>
<%@ page import="com.novell.nidp.resource.*" %>
<%@ page import="com.novell.nidp.resource.jsp.*" %>
<%@ page import="com.novell.nidp.ui.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>


<%
    ContentHandler handler = new ContentHandler(request,response);
    String target = (String) request.getAttribute("target");
    String uname = (String)request.getAttribute("username");
    
    NIDPSessionData sData = NIDPContext.getNIDPContext().getSession(request).getSessionData(request.getParameter("sid"));
    AuthnRequest proxyReq = sData.getProxiedRequest();
    if(proxyReq instanceof WSFedAuthnRequest)
    	uname = ((WSFedAuthnRequest)proxyReq).getParameter("username");
    
    if ( uname == null )
        uname = "";
    
    uname = StringEscapeUtils.escapeHtml(uname);
    if ( target != null )
        target = StringEscapeUtils.escapeHtml(target);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//<%=handler.getLanguageCode()%>">
<html lang="<%=handler.getLanguageCode()%>">
	<head>
		<title>Rogaland fylkeskommune</title>
		<meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	  	<meta http-equiv="content-type" content="text/html;charset=utf-8">
  	  	<META HTTP-EQUIV="Content-Language" CONTENT="<%=handler.getLanguageCode()%>">

		<link rel="Shortcut icon" href="/nidp/rfk/img/favicon.png"" type="image/x-icon" />
		
        <!-- Bootstrap -->
        <script src="/nidp/rfk/js/jquery.min.js"></script>
        <link href="/nidp/rfk/css/bootstrap.min.css" rel="stylesheet">
        <link href="/nidp/rfk/css/signin.css" rel="stylesheet">
		<script src="/nidp/rfk/js/modernizr.min.js"></script>
		
	  	<script language="JavaScript">
			var i = 0;
			function imageSubmit() {
				if (i == 0) {	
					i = 1;
					document.IDPLogin.submit();
  			    }
  			    return false;
			}

            $(window).load(function() {
                $(document).ready(function() {
                    if (!Modernizr.input.placeholder) {
                        $("input").each(function() {
							if ($(this).val() == "" && $(this).attr("placeholder") != "") {
								$(this).val($(this).attr("placeholder"));
								$(this).focus(function() {
									if ($(this).val() == $(this).attr("placeholder")) $(this).val("");
								});
								$(this).blur(function() {
									if ($(this).val() == "") $(this).val($(this).attr("placeholder"));
								});
							}
						});
                    }
                });
            });
		</script>
  	</head>
    <body>
		<div class="container">
			<form class="form-signin" role="form" name="IDPLogin" enctype="application/x-www-form-urlencoded" method="POST" action="<%= (String) request.getAttribute("url") %>" AUTOCOMPLETE="off">
				<input type="hidden" name="option" value="credential">
<%	if (target != null) { %>
				<input type="hidden" name="target" value="<%=target%>">
<%	} %>
		
				<img src="/nidp/rfk/img/rogfk_farger.jpg" class="form-signin-heading" height="102" width="142" />
				<h2 class="form-signin-heading">Velkommen</h2>
			
<%
	String err = (String) request.getAttribute(NIDPConstants.ATTR_LOGIN_ERROR);
	if (err != null) {
%>
				<div class="alert alert-danger"><%=err%></div>
<%	} %>
<%	if (NIDPCripple.isCripple()) { %>
				<div class="alert alert-danger"><%=NIDPCripple.getCrippleAdvertisement(request.getLocale())%></div>
<%	} %>
				<input type="text" class="form-control" placeholder="Brukernavn" value="<%=uname%>" name="Ecom_User_ID" size="30" required autofocus>
				<input type="password" class="form-control" placeholder="Passord" name="Ecom_Password" size="30" required>
<%
	Object enabled = (Boolean) request.getAttribute(NIDPConstants.ATTR_REMEMBERME_OPTION);
	if(enabled != null && (Boolean) enabled) {
%>
				<label class="checkbox-inline">
					<input type="checkbox" class="checkbox-inline" name="EnableCookieAuth" value="true" /> Remember Me
				</label>
				<div class="alert alert-warning">
					<label>(Do not check this box if you are using public computer.)</label>
				</div>
<%	} %>
			
				<button class="btn btn-lg btn-primary btn-block" type="submit" onClick="return imageSubmit()">Logg inn</button>
				<br>
				<a href="https://glemtpassord.rogfk.no/" target="_blank" role="button" class="btn btn-info btn-block">Glemt passord?</a>
			</form>
		</div> <!-- /container -->
	</body>
</html>
