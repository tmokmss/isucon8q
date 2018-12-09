all:
	make ruby
	make db

init:
	@sudo systemctl stop torb.perl
	@sudo systemctl disable torb.perl
	@sudo systemctl enable torb.ruby
	make ruby

ruby:
	@sudo systemctl restart torb.ruby

db:
	@sudo systemctl restart mariadb

systemctl-list:
	systemctl list-unit-files --type=service
