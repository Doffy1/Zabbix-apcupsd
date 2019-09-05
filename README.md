# apcupsd
Monitoring apcupsd with Zabbix.

Collect informations from apcupsd with one query and many answers to trapper items and use Zabbix scheduler.

<b>Details of operation:</b>
1. The "query schedule" item send a request to apcupsd.query agent key.
2. The agent run the assigned key command (dfy_split.pl) with given parameters.
3. The command script get all apcupsd status values, format them for the zabbix_sender and send.
4. The Zabbix server receives the values and work with defined trapper items. Items not defined discarded.

<b>Install:</b>
1. Copy "userparameter_apcupsd.conf" on apcupsd server to Zabbix agent userparameter config directory.
2. Copy "dfy_split.pl" to apcupsd server /usr/bin/. If use other directory, then please modify the path in userparameter_apcupsd.conf.
3. Load the "apcupsd_template.xml" in Zabbix server and assign it to apcupsd server.
4. Enjoy! And add custom triggers, graphs as needed.

<b>Tested environment:</b>
Centos7, Zabbix 4.2

In my case the apcupsd running on Zabbix server, so for sending datas and item allowed host used the "localhost". 
On distributed confifguration change it to Zabbix host name (in schedule item) and the agent host name (as item allowed host).
