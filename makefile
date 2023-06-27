default:
	@echo "这个达子就逊了"
	@echo "USAGE : make [cmd]"
	@echo "COMMANDS: "
	@echo "  h  : for hexo without server"
	@echo "  g  : for github"
	@echo "  hs : for hexo with server"
	@echo " "
h:
	hexo cl
	hexo g
hs:
	hexo cl
	hexo g
	hexo s
gc:
	git status
	git logs
	git add .

gp:
	git push -u origin master
