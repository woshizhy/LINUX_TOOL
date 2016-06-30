# 相对路径快捷命令(进入相应路径时只要 cd ~xxx)
hash -d svn_addr="https://192.168.8.211:9001/svn"
hash -d svn_addr_br17_branches="https://192.168.8.211:9001/svn/BR17/branches/FPGA/dual_single_thread/code"
hash -d svn_addr_br17_trunk="https://192.168.8.211:9001/svn/BR17/trunk/FPGA/dual_single_thread/code"
# 快捷命令
alias sll="svn log -l"
alias slv="svn log -l 1 -v"
alias si="svn info"
alias st="svn status"
alias sh="svn log -r HEAD"
alias su="svn update"
alias sr="svn revert -R"
alias sm="svn merge"
alias sci="svn ci"
alias svn_br17="svn co https://192.168.8.211:9001/svn/BR17 ./BR17"
alias svn_br16="svn co https://192.168.8.211:9001/svn/br16_verify ./BR16"
alias svn_bt15="svn co https://192.168.8.211:9001/svn/AC4600_SDK ./BT15"
alias svn_bc51="svn co https://192.168.8.211:9001/svn/BC51 ./BC51"

# vim:ft=zsh ts=2 sw=2 sts=2
#
function svn_prompt_info() {
  local _DISPLAY
  if in_svn; then
    if [ "x$SVN_SHOW_BRANCH" = "xtrue" ]; then
      unset SVN_SHOW_BRANCH
      _DISPLAY=$(svn_get_branch_name)
    else
      _DISPLAY=$(svn_get_repo_name)
      _DISPLAY=$(omz_urldecode "${_DISPLAY}")
    fi
    echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$_DISPLAY$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR$(svn_dirty)$(svn_dirty_pwd)$ZSH_PROMPT_BASE_COLOR"
  fi
}


function in_svn() {
  if $(svn info >/dev/null 2>&1); then
    return 0
  fi
  return 1
}

function svn_get_repo_name() {
  if in_svn; then
    svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
    svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p"
  fi
}

function svn_get_branch_name() {
  local _DISPLAY=$(
    svn info 2> /dev/null | \
      awk -F/ \
      '/^URL:/ { \
        for (i=0; i<=NF; i++) { \
          if ($i == "branches" || $i == "tags" ) { \
            print $(i+1); \
            break;\
          }; \
          if ($i == "trunk") { print $i; break; } \
        } \
      }'
  )
  
  if [ "x$_DISPLAY" = "x" ]; then
    svn_get_repo_name
  else
    echo $_DISPLAY
  fi
}

function svn_get_rev_nr() {
  if in_svn; then
    svn info 2> /dev/null | sed -n 's/Revision:\ //p'
  fi
}

function svn_dirty_choose() {
  if in_svn; then
    local root=`svn info 2> /dev/null | sed -n 's/^Working Copy Root Path: //p'`
    if $(svn status $root 2> /dev/null | command grep -Eq '^\s*[ACDIM!?L]'); then
      # Grep exits with 0 when "One or more lines were selected", return "dirty".
      echo $1
    else
      # Otherwise, no lines were found, or an error occurred. Return clean.
      echo $2
    fi
  fi
}

function svn_dirty() {
  svn_dirty_choose $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}

function svn_dirty_choose_pwd () {
  if in_svn; then
    local root=$PWD
    if $(svn status $root 2> /dev/null | command grep -Eq '^\s*[ACDIM!?L]'); then
      # Grep exits with 0 when "One or more lines were selected", return "dirty".
      echo $1
    else
      # Otherwise, no lines were found, or an error occurred. Return clean.
      echo $2
    fi
  fi
}

function svn_dirty_pwd () {
  svn_dirty_choose_pwd $ZSH_THEME_SVN_PROMPT_DIRTY_PWD $ZSH_THEME_SVN_PROMPT_CLEAN_PWD
}


