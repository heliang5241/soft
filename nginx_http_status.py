#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import re
import time 
import datetime
import sys
import smtplib
reload(sys)
sys.setdefaultencoding("utf-8")
from email.mime.text import MIMEText
from email.MIMEMultipart import MIMEMultipart

host = '0002'
logfile = '/usr/local/nginx/logs/access.log'
offset_file = '/home/monitor/file/nginx_http_status.offset'
monitor_nginx_status = '/home/monitor/file/monitor_nginx_status.csv'
monitor_nginx_ip = '/home/monitor/file/monitor_nginx_ip.csv'


def send_mail(p_sub, p_message, p_attachments=[]):
    msg = MIMEMultipart()
    body = MIMEText(p_message, _subtype="plain")
    msg.attach(body)
    if p_attachments:
        for i in p_attachments:
            file_name = os.path.basename(i)
            att = MIMEText(open(i, 'rb').read(), 'base64', 'gb2312')
            att["Content-Type"] = 'application/octet-stream'
            att["Content-Disposition"] = 'attachment; filename="%s"' % file_name
            msg.attach(att)
    mailto_list = [
                   'luyuye@yinpiao.com',
                   'dept.group.ngxmonitor@yinpiao.com',
#                    'lusijie@yinpiao.com',
#                    'itmonitor@yinpiao.com',
                   ] 
    msg['from'] = 'dbamonitor_group@yinpiao.com'
    msg['subject'] = p_sub
    try:
        server = smtplib.SMTP()
        server.connect('mail.yinpiao.com')
        server.sendmail(msg['from'], mailto_list, msg.as_string())
        server.quit()
        print 'send successed'
    except Exception, e:  
        print str(e)
        
def main():
    F = open(offset_file, 'rw+')
    line = F.readline()
    pos = int(line)
    sts = int(os.stat(logfile).st_size)
    FILE = open(logfile)
    if sts < pos:
        FILE.seek(0, 0)
    else:
        FILE.seek(pos)
    monitor_nginx_status_list = []
    ip_dict = {}
    count = 0 
    status_count = 0
    
    line = FILE.readline()
    while line:
        count += 1
        line = line.replace('\n', '').strip()
        matched = re.match(r'^(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})\s(.*?)\s\[(.*?)\]\s"(.*?)\s(.*?)\s(.*?)"\s(\d+)\s"(.*?)"\s"(.*?)"\s"(.*?)"\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s(.*?)\s"(.*?)"\s"(.*?)"', line)
        if matched:
            (ip, date_str, status, http_referer, upstream_addr, request_2) = matched.group(1, 3, 7, 8, 18, 5)
            if '172.20' not in ip and ip not in ['101.95.170.42', '180.168.96.186', '180.168.96.182']:
                ip_key = ip + "," + http_referer + request_2
                ip_dict.setdefault(ip_key, 0)
                ip_dict[ip_key] += 1
            if status in ('500', '499', '400', '404',):
                monitor_nginx_status_list.append(",".join([date_str, ip, status, upstream_addr, http_referer, request_2, ]))
                status_count += 1
        if count > 200000:
            send_mail('nginx monitor error', "too much rows \n\nrows count ==> " + str(count))
            break
        line = FILE.readline()
    sorted_x = sorted(ip_dict.iteritems(), key=lambda x:x[1], reverse=True)
    ip_count = int(sorted_x[0][1])
    if ip_count > 200:
        v_sub = '(Alert) Nginx Issue External IPs to Access URL' + host
        v_message = '''
        Alarm Issued IPs to access internal URL. If you received this kind of alerts, please check NGX/Accessed URLs/External IPs, then blocked weird IPs on Blocked lists of FW ASAP. Thank you. 

        Created by: Jack Lu
        '''
        monitor_nginx_ip_handle = open (monitor_nginx_ip, 'w')
        monitor_nginx_ip_handle.write(",".join(('ip', 'total', 'url', '\n')))
        for i in sorted_x:
            (ip, url) = i[0].split(",", 1)
            monitor_nginx_ip_handle.write(",".join((ip, str(i[1]), url)) + '\n')
        monitor_nginx_ip_handle.close()
        send_mail(v_sub, v_message, [monitor_nginx_ip, ])
    if status_count > 100:
        v_sub = '(Alert) Nginx Upstream Issue Status' + host
        v_message = '''
         Alarm HTTP Status on 404/500/499 and etc. If you received this kind of alerts, please check NGX and Upstream server ASAP. Thank you. 
         
         Created by: Jack Lu
         '''
        monitor_nginx_status_handle = open (monitor_nginx_status, 'w')
        monitor_nginx_status_handle.write(",".join(('datetime', 'ip', 'status', 'upstream_address', 'http_referer', 'request_2', '\n')))
        for i in monitor_nginx_status_list:
            monitor_nginx_status_handle.write(i + '\n')
        monitor_nginx_status_handle.close()
        send_mail(v_sub, v_message, [monitor_nginx_status, ])
    endpos = FILE.tell() 
    FILE.close()
    F.seek(0)
    F.truncate()
    F.write(str(endpos))
    F.close()
    
if __name__ == '__main__':
    main()
    print "ok"
