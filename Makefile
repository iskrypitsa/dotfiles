localfiles = .tmux.conflocal .vimrclocal .bashrclocal
files = .tmux.conf .vimrc .bashrc

all : colorschemes

.PHONY = colorschemes
colorschemes : $(files)
		mkdir -p ~/.vim/colors/
		cp colors/* ~/.vim/colors/

$(localfiles): % :
		touch ~/$@

$(files): % : %local
		cp --remove-destination $@ ~/
