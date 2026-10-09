# On interactive startup, report when the dotfiles repo has local changes to
# commit, commits to push, or upstream commits to pull, and offer to sync when
# that can be done without conflicts. The upstream check uses the last fetch;
# a throttled background fetch refreshes it for later shells.
status is-interactive; or return

function __dotfiles_status
    # This file is symlinked from the repo, so resolve it to find the repo.
    set -l repo (path normalize (path dirname (path resolve (status filename)))/../../..)
    command git -C $repo rev-parse --git-dir &>/dev/null; or return

    set -l msgs
    set -l dirty (command git -C $repo status --porcelain 2>/dev/null | count)
    test $dirty -gt 0; and set -a msgs "$dirty uncommitted change(s)"

    set -l ahead 0
    set -l behind 0
    set -l counts (command git -C $repo rev-list --left-right --count HEAD...@{u} 2>/dev/null | string split \t)
    if test (count $counts) -eq 2
        set ahead $counts[1]
        set behind $counts[2]
        test $ahead -gt 0; and set -a msgs "$ahead commit(s) to push"
        test $behind -gt 0; and set -a msgs "$behind commit(s) to pull"
    end

    if set -q msgs[1]
        set_color yellow
        echo "dotfiles: "(string join ', ' $msgs)" ($repo)"
        set_color normal
    end

    # Offer to sync when neither a rebase onto upstream nor restoring the
    # autostashed working tree can conflict.
    if test $ahead -gt 0 -o $behind -gt 0
        set -l blocker
        if test $behind -gt 0
            set -l incoming (command git -C $repo diff --name-only HEAD...@{u})
            set -l local (command git -C $repo diff --name-only HEAD) \
                (command git -C $repo ls-files --others --exclude-standard)
            set -l overlap (printf '%s\n' $incoming $local | sort | uniq -d)
            if set -q overlap[1]
                set blocker "upstream changes touch uncommitted file(s): "(string join ', ' $overlap)
            else if test $ahead -gt 0; and not command git -C $repo merge-tree --write-tree HEAD @{u} &>/dev/null
                set blocker "local and upstream commits conflict"
            end
        end

        if set -q blocker[1]
            set_color red
            echo "dotfiles: can't sync automatically: $blocker"
            set_color normal
        else if read -n1 -P "dotfiles: sync with upstream? [y/N] " answer; and string match -qi y -- $answer
            if test $behind -gt 0
                if not command git -C $repo pull --rebase --autostash --quiet
                    command git -C $repo rebase --abort &>/dev/null
                    set_color red
                    echo "dotfiles: pull failed, repo left as it was"
                    set_color normal
                    return
                end
            end
            if test $ahead -gt 0
                command git -C $repo push --quiet; or return
            end
            set_color green
            echo "dotfiles: synced"
            set_color normal
            return
        end
    end

    # Refresh remote refs at most every 10 minutes, without blocking or prompting.
    set -l fetch_head (command git -C $repo rev-parse --path-format=absolute --git-path FETCH_HEAD)
    if not test -e $fetch_head; or test (path mtime --relative $fetch_head) -gt 600
        GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes" \
            command git -C $repo fetch --quiet &>/dev/null &
        disown
    end
end

__dotfiles_status
functions -e __dotfiles_status
