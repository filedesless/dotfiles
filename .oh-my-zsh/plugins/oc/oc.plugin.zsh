# Autocompletion for oc, the command line interface for OpenShift
#
# Author: https://github.com/kevinkirkup

if [ $commands[oc] ]; then
    __OC_COMPLETION_FILE="${ZSH_CACHE_DIR}/oc_completion"

    if [[ ! -f $__OC_COMPLETION_FILE ]]; then
	oc completion zsh >! $__OC_COMPLETION_FILE
    fi

    [[ -f $__OC_COMPLETION_FILE ]] && source $__OC_COMPLETION_FILE

    unset __OC_COMPLETION_FILE
fi
