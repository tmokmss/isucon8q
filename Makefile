all:
	make db-backup
	make ruby
	make db
	make reset-log

init:
	@sudo systemctl stop torb.perl
	@sudo systemctl disable torb.perl
	@sudo systemctl enable torb.ruby
	make ruby

ruby:
	@sudo systemctl restart torb.ruby

db:
	@sudo systemctl restart mariadb

db-backup:
	@sudo mysqldump -u isucon --password=isucon torb > /var/log/mariadb/backup-`date +%m%d-%H%M%S`

mariadb:
	@sudo systemctl restart mariadb.service
h2o:
	@sudo systemctl restart h2o.service

systemctl-list:
	systemctl list-unit-files --type=service
alp:
	cat /var/log/h2o/access.log | alp --aggregates="/api/users/.*","/api/events/.*","/admin/api/reports/events/.*" --sum -r
pt-query-digest:
	pt-query-digest --limit 10 /var/log/mariadb/mariadb-slow.log 

reset-log:
	@sudo rm /var/log/mariadb/mariadb-slow.log 
	@sudo rm /var/log/h2o/access.log
	make h2o
	make mariadb

lineprof:
	export LESS='-R'
	less /home/isucon/log/stdout

err:
	less /home/isucon/log/stderr
