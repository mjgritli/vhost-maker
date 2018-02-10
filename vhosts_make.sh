#!/usr/bin/env bash
function usage() {
  echo ""
  echo "#vhosts-maker"
  echo "This script helps you create all essential vhosts parameters in Linux OS.
  Author: Mohammed Griti <newton>

Before diving into the virtual host configuration itself, we have to make sure that virtual hosts are enabled on our server. Open up the apache configuration:

in XAMPP 
sudo nano /opt/lampp/etc/httpd.conf 
in pure Apache 
sudo nano /etc/httpd/conf/httpd.conf 

Make sure that this line is uncommented (it is located at the very end of the file):
#Virtual hosts
Include conf/extra/httpd-vhosts.conf

Usage: sudo <script name> <website_name> <options>

 - It creates the required vhost lines in httpd-vhosts.conf
 - It creates a default index.html page
 - It creates the required DNS entries in /etc/hosts
 - Restarts apache
 - run as root if you need permissions


<h2># Options</h2>
-n  specifies web-host name
-a  specifies application name <apache|xampp> for the default files location
-d  specifies web-host domain ex: .com, .local <default>
-f  identifies folder name in www|htdocs directory, default is the same as -n value
-h  print this help guide


Ex-usage: sudo <script name> -n cisco -d local -f ciscoweb -a xampp"
  # exit();
}

#check if script is running by root sudo
# if [ "$EUID" -ne 0 ]
#   then echo "Please run as root"
#   exit
# fi
name=""
domain="local" #default domain
www="/opt/lampp/htdocs" #defauly www
vhosts="/opt/lampp/etc/extra/httpd-vhosts.conf" #default vhosts

while  getopts n:a:d:f:h args ; do
  case $args in
    n)
      name=$OPTARG
      folder=$name
      # echo "name: $name"
      ;;
    a)
      if [ $OPTARG == "xampp" ]
        then
        app="xampp"
        www="/opt/lampp/htdocs"
        vhosts="/opt/lampp/etc/extra/httpd-vhosts.conf"
      elif [ $OPTARG == "apache" ]
        then
        app="apache"
        www="/var/www/html"
        vhosts="/etc/httpd/conf/extra/httpd-vhosts.conf"
      else
        echo "Unknown folder option value"
        usage
        exit
      fi
      ;;
    d)
      domain=$OPTARG
      ;;
    f)
      folder=$OPTARG
      ;;
    h)
      usage
      exit
      ;;
    \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    *)
      echo "Invalid argument"
      usage
      ;;
  esac
done

if [ $OPTIND -eq 1 ]; then
  echo "No options were passed";
  usage;
  exit
fi
if [[ $name == "" ]]; then
  echo "At least -n must be specified"
  usage;
  exit
else
  echo "name: $name"
  echo "Creating the web-host folder $folder"
  sudo mkdir $www/$folder
  # sudo chown newton:newton $www/$name
  echo "Creating HTML Page"
  echo "
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <title>$name</title>
  </head>
  <body>
    <center><h1>welcome to $name website </h1></center>
  </body>
</htm>" >> $www/$folder/index.html

  echo "Creating httpd-vosts entiry:"

  echo "
<VirtualHost *:80>
   DocumentRoot '$www/$folder'
   ServerName $name.$domain
</VirtualHost>" | sudo tee -a $vhosts > /dev/null

  echo "Adding domain name entires"
  echo "127.0.0.1       $name.$domain" | sudo tee -a /etc/hosts > /dev/null
  echo "::1             $name.$domain" | sudo tee -a /etc/hosts > /dev/null

  echo "Restarting apache ..."

  if [ $app == "xampp" ]
        then
        sudo /opt/lampp/lampp reloadapache
      elif [ $app == "apache" ]
        then
        sudo service apache2 restart
      else
        echo "Unknown folder option value"
        usage
        exit
  fi
      
  echo "done, enjoy..."
fi

shift $((OPTIND-1))
#echo "$# non-option arguments"
