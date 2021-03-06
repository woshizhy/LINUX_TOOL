# 为原来文件备份
mv $HOME/.vim						$HOME/.vim_backup
mv $HOME/.vimrc						$HOME/.vimrc_backup
mv $HOME/.oh-my-zsh					$HOME/.oh-my-zsh_backup
mv $HOME/.zshrc						$HOME/.zshrc_backup
mv $HOME/.tmux.conf					$HOME/.tmux.conf_backup
# 在$HOME下创建快捷方式
tool_path=$(cd "$(dirname "$0")"; pwd)
ln -s $tool_path/vim/.vim					$HOME/
ln -s $tool_path/vim/.vimrc					$HOME/
ln -s $tool_path/zsh/.oh-my-zsh				$HOME/
ln -s $tool_path/zsh/.zshrc					$HOME/
ln -s $tool_path/zsh/.tmux					$HOME/
ln -s $tool_path/zsh/.tmux/.tmux.conf		$HOME/
# 在$HOME下创建tmux工作区间保存目录
rm -rf	$HOME/.tmux_workspace_save
mkdir 	$HOME/.tmux_workspace_save
# 在$HOME下创建undo历史保存目录
rm -rf	$HOME/.undo_history
mkdir 	$HOME/.undo_history
#自动安装zshell autojump插件
python $HOME/.oh-my-zsh/custom/plugins/autojump/install.py
