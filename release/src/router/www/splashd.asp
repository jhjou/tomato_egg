<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0//EN'>
<!--
	Tomato GUI
	Copyright (C) 2006-2008 Jonathan Zarate
	http://www.polarcloud.com/tomato/

	Copyright (C) 2011 Ofer Chen (Roadkill), Vicente Soriano (Victek)
	Adapted & Modified from Dual WAN Tomato Firmware.

	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html>
<head>
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] Captive Portal</title>
<link rel='stylesheet' type='text/css' href='tomato.css'>
<link rel='stylesheet' type='text/css' href='<% nv('web_css'); %>.css'>
<script type='text/javascript' src='tomato.js'></script>
<style type='text/css'>
textarea {
 width: 98%;
 height: 15em;
}
</style>
<script type='text/javascript'>
//	<% nvram("NC_enable,NC_Verbosity,NC_GatewayName,NC_GatewayPort,NC_ForcedRedirect,NC_HomePage,NC_DocumentRoot,NC_LoginTimeout,NC_IdleTimeout,NC_MaxMissedARP,NC_ExcludePorts,NC_IncludePorts,NC_AllowedWebHosts,NC_MACWhiteList,NC_BridgeLAN,lan_ifname,lan1_ifname,lan2_ifname,lan3_ifname"); %>
function fix(name)
{
 var i;
 if (((i = name.lastIndexOf('/')) > 0) || ((i = name.lastIndexOf('\\')) > 0))
 name = name.substring(i + 1, name.length);
 return name;
}

function uploadButton()
{
 var fom;
 var name;
 var i;
 name = fix(E('upload-name').value);
 name = name.toLowerCase();
 if ((name.length <= 5) || (name.substring(name.length - 5, name.length).toLowerCase() != '.html')) {
 alert('Wrong filename, the correct extension is ".html".');
 return;
 }
 if (!confirm('Upload file ' + name + ' to replace the default splash page?')) return;
 E('upload-button').disabled = 1;
 fields.disableAll(E('config-section'), 1);
 fields.disableAll(E('footer'), 1);
 E('upload-form').submit();
}

function verifyFields(focused, quiet)
{
	var a = E('_f_NC_enable').checked;

	E('_NC_Verbosity').disabled = !a;
	E('_NC_GatewayName').disabled = !a;
	E('_NC_GatewayPort').disabled = !a;
	E('_f_NC_ForcedRedirect').disabled = !a;
	E('_NC_HomePage').disabled = !a;
	E('_NC_DocumentRoot').disabled = !a;
	E('_NC_LoginTimeout').disabled = !a;
	E('_NC_IdleTimeout').disabled = !a;
	E('_NC_MaxMissedARP').disabled = !a;
	E('_NC_ExcludePorts').disabled = !a;
	E('_NC_IncludePorts').disabled = !a;
	E('_NC_AllowedWebHosts').disabled = !a;
	E('_NC_MACWhiteList').disabled = !a;
/* VLAN-BEGIN */
	E('_NC_BridgeLAN').disabled = !a;

	var bridge = E('_NC_BridgeLAN');
	if(nvram.lan_ifname.length < 1)
		bridge.options[0].disabled=true;
	if(nvram.lan1_ifname.length < 1)
		bridge.options[1].disabled=true;
	if(nvram.lan2_ifname.length < 1)
		bridge.options[2].disabled=true;
	if(nvram.lan3_ifname.length < 1)
		bridge.options[3].disabled=true;
/* VLAN-END */

	if ( (E('_f_NC_ForcedRedirect').checked) && (!v_length('_NC_HomePage', quiet, 1, 255))) return 0;
	if (!v_length('_NC_GatewayName', quiet, 1, 255)) return 0;	
	if ( (E('_NC_IdleTimeout').value != '0') && (!v_range('_NC_IdleTimeout', quiet, 300))) return 0;
	return 1;
}

function save()
{
  if (verifyFields(null, 0)==0) return;
  var fom = E('_fom');
  fom.NC_enable.value = E('_f_NC_enable').checked ? 1 : 0;
  fom.NC_ForcedRedirect.value = E('_f_NC_ForcedRedirect').checked ? 1 : 0;

  // blank spaces with commas
  e = E('_NC_ExcludePorts');
  e.value = e.value.replace(/\,+/g, ' ');

  e = E('_NC_IncludePorts');
  e.value = e.value.replace(/\,+/g, ' ');

  e = E('_NC_AllowedWebHosts');
  e.value = e.value.replace(/\,+/g, ' ');
  
  e = E('_NC_MACWhiteList');
  e.value = e.value.replace(/\,+/g, ' ');

  fields.disableAll(E('upload-section'), 1);
  if (fom.NC_enable.value == 0) {
	fom._service.value = 'splashd-stop';
  }
	else {
	fom._service.value = 'splashd-restart';
	}
	form.submit('_fom', 1);
}

function init()
{
}
</script>
</head>

<body onLoad="init()">
<table id='container' cellspacing=0>
<tr><td colspan=2 id='header'>
	<div class='title'>Tomato</div>
	<div class='version'>Version <% version(); %></div>
</td></tr>
<tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
<td id='content'>
<div id='ident'><% ident(); %></div>
<div class='section-title'>Captive Portal Management</div>
<div class='section' id='config-section'>
<form id='_fom' method='post' action='tomato.cgi'>
<input type='hidden' name='_nextpage' value='splashd.asp'>
<input type='hidden' name='_service' value='splashd-restart'>
<input type='hidden' name='NC_enable'>
<input type='hidden' name='NC_ForcedRedirect'>
<script type='text/javascript'>
createFieldTable('', [
	{ title: 'Enable Function', name: 'f_NC_enable', type: 'checkbox', value: nvram.NC_enable == '1' },
/* VLAN-BEGIN */
	{ title: 'Interface', multi: [
		{ name: 'NC_BridgeLAN', type: 'select', options: [
			['br0','LAN (br0)*'],
			['br1','LAN1 (br1)'],
			['br2','LAN2 (br2)'],
			['br3','LAN3 (br3)']
			], value: nvram.NC_BridgeLAN, suffix: ' <small>* default</small> ' } ] },
/* VLAN-END */
	{ title: 'Gateway Name', name: 'NC_GatewayName', type: 'text', maxlen: 255, size: 34, value: nvram.NC_GatewayName },
	{ title: 'Captive Site Forwarding', name: 'f_NC_ForcedRedirect', type: 'checkbox', value: (nvram.NC_ForcedRedirect == '1') },
	{ title: 'Home Page', name: 'NC_HomePage', type: 'text', maxlen: 255, size: 34, value: nvram.NC_HomePage },
	{ title: 'Welcome html Path', name: 'NC_DocumentRoot', type: 'text', maxlen: 255, size: 20, value: nvram.NC_DocumentRoot, suffix: '<span>&nbsp;/splash.html</span>' },
	{ title: 'Login Timeout', name: 'NC_LoginTimeout', type: 'text', maxlen: 8, size: 4, value: nvram.NC_LoginTimeout, suffix: ' <small>seconds</small>' },
	{ title: 'Idle Timeout', name: 'NC_IdleTimeout', type: 'text', maxlen: 8, size: 4, value: nvram.NC_IdleTimeout, suffix: ' <small>seconds (0 - unlimited)</small>' },
	{ title: 'Max Missed ARP', name: 'NC_MaxMissedARP', type: 'text', maxlen: 10, size: 2, value: nvram.NC_MaxMissedARP },
	null,
	{ title: 'Log Info Level', name: 'NC_Verbosity', type: 'text', maxlen: 10, size: 2, value: nvram.NC_Verbosity },
	{ title: 'Gateway Port', name: 'NC_GatewayPort', type: 'text', maxlen: 10, size: 7, value: fixPort(nvram.NC_GatewayPort, 5280) },
	{ title: 'Excluded Ports to be redirected', name: 'NC_ExcludePorts', type: 'text', maxlen: 255, size: 34, value: nvram.NC_ExcludePorts },
	{ title: 'Included Ports to be redirected', name: 'NC_IncludePorts', type: 'text', maxlen: 255, size: 34, value: nvram.NC_IncludePorts },
	{ title: 'Excluded URLs', name: 'NC_AllowedWebHosts', type: 'text', maxlen: 255, size: 34, value: nvram.NC_AllowedWebHosts },
	{ title: 'MAC Address Whitelist', name: 'NC_MACWhiteList', type: 'text', maxlen: 255, size: 34, value: nvram.NC_MACWhiteList }
]);
</script>
</form>
</div>
<br>
<div class='section-title'>Customized Splash File Path</div>
<div class='section' id='upload-section'>
 <form id='upload-form' method='post' action='uploadsplash.cgi?_http_id=<% nv(http_id); %>' encType='multipart/form-data'>
 <input type='file' size='40' id='upload-name' name='upload_name'>
 <input type='button' name='f_upload_button' id='upload-button' value='Upload' onclick='uploadButton()'>
 <br>
 </form>
</div>
<br>
<ul>
<span style='color:blue'>
<b>User Guide.</b><br>
</span>
<br>
<li><b> Enable function</b> - The router will show a Welcome banner when a client attempts to access the Internet.<br>
/* VLAN-BEGIN */
<li><b> Interface:</b> - Select one of the bridges on which the Captive Portal will listen.<br>
/* VLAN-END */
<li><b> Gateway name</b> - The name of the Gateway appearing in the welcome banner<br>
<li><b> Gateway port</b> - The port number of the gateway. Default=5280.<br>
<li><b> Captive Site Forwarding</b> - When active, a 'Home Page' will appear after you click "Agree" in the Welcome banner.<br>
<li><b> Home page</b> - The URL for the 'Home Page' mentioned above is located.<br>
<li><b> Welcome html Path</b> - The location where the Welcome banner is stored<br>
<li><b> Login Timeout</b> - The client can use the internet until this time expires. Default=3600sec.<br>
<li><b> Idle Timeout</b> - How often the ARP cache will be checked (seconds). Default=0.<br>
<li><b> Max Missed ARP</b> - Number of lost ARP before considering the client has leaved the connection. Default = 5<br>
<li><b> Log Info Level</b> - Verbosity level for log messages from this module, Level 0=Silent, 10=Verbose, (Default=0).<br>

<li><b> Included ports</b> - TCP ports to allow access to after login, all others will be denied.<br>
<li><b> Excluded ports</b> - TCP ports to denied access to after login, all others will be allowed.<br>
Leave a blank space between each port number. Use only one of these two options to avoid conflicts.<br>

<li><b> Excluded URLs</b> - URLs that can be accessed without the Welcome banner screen appearing. When you set allowed url's also leave a blank space between each url. i.e; http://www.google.com http://www.google.es<br>
<li><b> MAC address whitelist</b> - MAC addresses excluded from the portal. Leave a blank space between each MAC Address, i.e; 11:22:33:44:55:66 11:22:33:44:55:67<br>
<li><b> Customized Splash File Path</b> - Here you can upload your personal Welcome banner that will overwrite the default one.<br><br>
</span>
<br>
<span style='color:red'>
<b> Note: </b> When the client's lease has expired, he must enter the Splash page again to get a new lease. No warning is given, therefore you may wish to give a long lease time to avoid problems.
<br>
</span>
</ul>
<br>
</td></tr>
<tr><td id='footer' colspan=2>
 <form>
 <span id='footer-msg'></span>
 <input type='button' value='Save' id='save-button' onclick='save()'>
 <input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
 </form>
</div>
</td></tr>
</table>
<script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>
