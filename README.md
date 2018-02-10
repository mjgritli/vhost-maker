# vhost-maker

This script helps you create all essential vhosts parameters in Linux OS.

Before diving into the virtual host configuration itself, we have to make sure that virtual hosts are enabled on our server. Open up the apache configuration:

in XAMPP <br>
sudo nano /opt/lampp/etc/httpd.conf <br>
in pure Apache <br>
sudo nano /etc/httpd/conf/httpd.conf <br>

Make sure that this line is uncommented (it is located at the very end of the file):<br>
#Virtual hosts<br>
Include conf/extra/httpd-vhosts.conf<br>

Usage: sudo <script name> <website_name> <options>

<ul>
 <li>It creates the required vhost lines in httpd-vhosts.conf</li>
 <li>It creates a default index.html page</li>
 <li>It creates the required DNS entries in /etc/hosts</li>
 <li>Restarts apache</li>
</ul>

<h2># Options</h2>
<ul>
 <li>-n  specifies web-host name</li>
 <li>-a  specifies application name <apache|xampp> for the default files location</li>
 <li>-d  specifies web-host domain ex: .com, .local <default></li>
 <li>-f  identifies folder name in www|htdocs directory, default is the same as -n value</li>
 <li>-h  print this help guide</li>
</ul>

Ex-usage: sudo <script name> -n cisco -d local -f ciscoweb -a xampp
