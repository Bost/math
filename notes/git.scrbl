#lang notes

@block{@block-name{Git}
  # https://softwaredoug.com/blog/2022/11/09/idiot-proof-git-aliases.html

  # Git Annex - sync large files
  # https://youtu.be/p0eVyhv2rbk

  # OID - Object Identifier

  # gitlab: create pull request: '+' -> 'New merge request'

  # compute sha1 for any file
  git hash-object path/to/file.ext

  # reset current branch to particular state
  # <startpoint> is (probably) <tag/branch/commit id (sha1)>
  git reset --hard <startpoint>
  # reset / move <branch> to <startpoint>, even if <branchname> exists already
  git branch --force <branch> <startpoint>

  # in case of:
  # Your branch is behind 'origin/master' by .. commits, and can be fast-forwarded
  git pull --rebase origin master
  git pull --rebase upstream master

  git submodule add <repo-url> ./path/to/submoduleDir

  # rename submodule
  git mv <old-submodule-name> <new-submodule-name>

  # pull and rebase latest of all submodules
  git submodule foreach git pull --rebase origin master

  # Initialize all submodules for which "git submodule init" has not been called
  # so far before updating
  git submodule update --init

  # remove / delete / uninstall
  set subMod relative/path/to/submodule
  git submodule deinit $subMod && \
  git rm $subMod && \
  git commit -m "Removed submodule" $subMod && \
  rm -rf .git/modules/$subMod

  # change the remote repository for a git submodule:
  # edit the .gitmodules file to update the URL and then run:
  git submodule sync --recursive
  # with git 2.25
  git submodule set-url [--] <path> <newurl>

  # change the name and email in all commits
  # -f, --force : git filter-branch refuses to start with an existing temporary
  #               directory or when there are already refs starting with
  #               refs/original/, unless forced.
  git filter-branch --force --env-filter \
  "GIT_AUTHOR_NAME='Bost'; GIT_AUTHOR_EMAIL='thebost@"@"gmail.com'; GIT_COMMITTER_NAME='Bost'; GIT_COMMITTER_EMAIL='thebost@"@"gmail.com';" \
  HEAD

  # change the name and email in all commits
  # create & run script file git-author-rename.sh with:
  git filter-branch --env-filter 'if [ "$GIT_AUTHOR_EMAIL" = "incorrect@"@"email" ]; then
  GIT_AUTHOR_EMAIL=correct@"@"email;
  GIT_AUTHOR_NAME="Correct Name"
  GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL;
  GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; fi' -- --all'

  # reuse commit message
  git commit --amend --no-edit

  # change the author (name, email) in the last commit
  git commit --amend --author "Bost <thebost@"@"gmail.com>"
  git commit --amend --reset-author

  # assigns the original repo to a remote repo called upstream
  git remote add upstream https://github.com/octocat/Spoon-Knife.git

  # show upstream branches and other info
  git remote show upstream
  git fetch upstream <branch1> <branch2>

  # remove / delete a remote-tracking branch from local repository
  # -r, --remotes
  # -d, --delete
  git branch --remotes --delete <origin/branch>
  # remove / delete a remote branch or tag
  git push --delete <origin> <branch-or-tag>

  # list branches that contain a given commit
  # https://stackoverflow.com/a/1419637/5151982
  # -r, --remotes
  git branch           --contains <commit>
  git branch --remotes --contains <commit>

  # file changes against remote branch
  git diff <branch1> <branch2> <filepath>

  # show particular changed word / staged changes
  git diff --word-diff / --cached

  # no plus minus signs
  git diff --color <sha1> <sha1> | sed -r "s/^([^-+ ]*)[-+ ]/\\1/" | less -r

  # stats/statistics: number of lines changed between two commits
  git diff --stat <commit-ish> <commit-ish>
  git diff --stat cmt..cmt~                  # commit vs.its parent/predecessor

  # files changed between two...
  git diff --name-only HEAD~1                # in last commit
  git diff --name-only <branch1> <branch2>   # between 2 branches
  git diff --name-only <branch1>..<branch2>  # between 2 branches
  git diff --name-only <branch>              # between <branch> and the HEAD
  git diff --name-only 5890e37..ebbf4c0      # between 2 commits
  git diff --name-status <branch1> <branch2> # show status D-deleted M-modified

  # find commit containing last change of a file - as in gitk
  git log   --perl-regexp <filepath>
  git lg-20 --perl-regexp <filepath>

  # count of files changed in the since the <tag>
  git log --format=oneline --patch <tag>..HEAD | wc -l

  #  show only commit-ids (shows only Author and Date / AuthorDate)
  git log --pretty=format:' "%h"' master..dev  # shortened commit id
  git log --pretty=format:' "%H"' master..dev  # full commit id
  # show also Commit and CommitDate
  git log --pretty=fuller --author=<Name>
  # show dates in the local timezone (seems like UTC doesn't work)
  git config log.date local    # don't forget to unset it!
  git log --pretty=format:'%cd' --author=<Name>
  git config --unset log.date

  # count of commits on a branch
  git rev-list --count <branch-name>

  # show content of file in the ...
  git show ff0011:file.txt # ... commit ff0011
  git show :0:file         # ... stage area (i.e. index)
  git show :1:file         # ... common ancestor
  git show :2:file         # ... target on the current branch where I am
  git show :3:file         # ... the one I am bringing in

  # show older version of a file
  git show REVISION:path/to/file

  # copy file from a BRANCH to /path/to/file
  git checkout BRANCH -- /path/to/file

  # :restore :revert - revert uncommited changes in path/to/file
  git checkout path/to/file

  # :reset :revert - restore file from a specific revision
  git checkout <revision> -- file1/to/restore file2/to/restore
  # :reset :revert - restore file from before a specific revision
  git checkout <revision>~1 -- file1/to/restore file2/to/restore

  # show current branch and changes made since last commit
  # -s, --short   Give the output in the short-format.
  # -b, --branch   Show the branch and tracking info even in short-format.
  git status --short --branch

  # interactively choose hunks of patch; see --interactive
  git add --patch # -p, --patch

  # How to apply a patch generated with git format-patch?
  # https://stackoverflow.com/a/2250170
  git apply --stat a_file.patch
  # dry run to detect errors:
  git apply --check a_file.patch
  # apply the patch as a commit. It also allows to sign off an applied patch.
  git am --signoff < a_file.patch

  # amend commit; reuse commit message
  git commit --amend --no-edit

  # a kind of git history / restore deleted branch
  git reflog

  # add all *.txt files under given path; must not be a bare repo
  git ls-files [path] | grep \'\.txt$\' | xargs git add

  # create bare (empty) repo in the...
  git init <dir>
  git init       # ...current dir

  # recursivelly add all *.txt files from src/ to a repo located in path/to/dir
  git --git-dir=path/to/dir add "src/**/*.txt"

  # commit to a repo located in gitDir under given Name
  git --git-dir=<dir> commit --author="Name <noreply@"@"domain.com>" -m "commitMsg"

  # clone a repo from <origRepo> to an (empty) <bareRepoDir>
  git clone --bare <origRepo> <bareRepoDir>

  # shallow clone with a history truncated to the specified number of commits
  # -b, --branch
  git clone --depth=1 --branch <branch> <origRepo> <newRepoName>q

  # After the clone is created, initialize all submodules within, using their
  # default settings. Equivalent to running
  # 'git submodule update --init --recursive'
  # immediately after the clone is finished. This option is ignored if the cloned
  # repository does not have a worktree/checkout (i.e. if any of --no-checkout/-n,
  # --bare, or --mirror is given)
  git clone --recursive
  git clone --recurse-submodules

  # workLocation must not be a bare (empty) repo
  git add --work-tree=workLocation --git-dir=<dir>

  # list contributors / committers / developers
  # git log --pretty=short | git shortlog [<options>]
  # -n, --numbered Sort output according to the number of commits per author
  #                instead of author alphabetic order.
  # -s, --summary Suppress commit description and provide a commit count summary
  #               only.
  # -e, --email    Show the email address of each author.
  git shortlog --summary --numbered --email

  # list all commits for a specific day / date / timestamp
  git log --after="2013-12-11 00:00" --before="2013-12-11 23:57"
  gitk    --since="2013-11-12 00:00"  --until="2013-11-13 00:00" & disown
  # list all commits for a specific committer / user / author on the master
  # branch
  git      log master --author=John
  git shortlog master --author=John

  # show settings
  git config --global --list
  git config  --local --list
  git config --global --list --get <setting>
  git config  --local --list --get <setting>

  # set user.name and user.mail
  git config --global user.name "Bost"
  git config --global user.email thebost@"@"gmail.com

  # help with typos like git comit
  git config --global help.autocorrect 1

  # rebase: remember actions on a particular commit - in case of repeating
  # conflicts when rebasing; long running branches
  git config --global rerere.enabled 1

  # github add new repository: create a new repo on www.github.com, then:
  git remote add origin git@"@"github.com:Bost/<newrepo>.git
  git push -u origin master

  # github: do not ask for username
  .git/config: url = https://Bost@"@"github.com/Bost/reponame.git

  # search entire commit history - only(!) code-changes, not commit messages
  git log -S "textToSearch"  # doesn't work always
  # search entire commit history; also in refs (see git help log)
  git log -S "textToSearch" --source --all
  # search through the gitlog
  git show :/"emacs-magit: Update to"
  # search through not commit messages
  git log --grep <regexp>

  # https://stackoverflow.com/a/7124949
  # search in the commit messages across all branches
  git log --all    --grep="emacs-magit: Update to"
  # -i, --regexp-ignore-case
  git log --all -i --grep="emacs-magit: Update to"  # case insensitive

  # search for occurences of function foo

  # ignore line ending changes
  git config --global core.autocrlf true

  # show formated commit logs
  git log --pretty=format:'%h %s'

  # a kind of 'gitk --all'
  git log --oneline --graph --all --decorate=short

  # show commit messages matching <pattern>
  git log --oneline --grep="<pattern>"

  # find / list all commits changing / touching specific file
  git log --follow --name-only --format='%H' -- path/to/file
  git log --follow --format='%H' \
          --after="2023-04-08 14:04:42" \
          --before="2023-04-12 14:29:23" \
          -- \
          gnu/packages/emacs-xyz.scm

  # set git base directory and working tree
  git --git-dir=path/to/.git --work-tree=path/to/ ...

  # ignore previously tracked path/to/file
  git rm --cached path/to/file && echo "path/to/file" >> .gitignore

  # Use it in case of "You asked me to pull without telling me which branch ..."
  git config branch.master.remote origin

  # git:
  git config branch.master.merge refs/heads/master

  # cygwin: ignore chmod changes
  git config core.fileMode false

  # list the contents of a tree object; like ls -a
  git ls-tree branchName path/to/file

  # show info about files in the index and the working tree
  git ls-files --cached
  git ls-files --deleted
  git ls-files --modified
  git ls-files --ignored
  git ls-files --stage

  # Remove untracked files and dirs from the working tree
  git clean -dxf
  git clean --force -dx

  # undoing: amend / split apart last commit: ... and edit the usual way
  git reset HEAD~

  # show aliases
  git config -l | grep alias | cut -c 7-
  git config --get-regexp alias

  # list all deleted files in the repo
  git log --diff-filter=D --summary

  # bisect: find the first GOOD commit
  # "Maybe you mistook good and bad revs" see http://stackoverflow.com/a/17153598
  git bisect start --term-new=fixed --term-old=unfixed
  git bisect fixed master
  git bisect unfixed <some-old-sha1>

  # checkout as; older revision of a file under a new / different name
  git show HEAD^:main.cpp > old_main.cpp
  git show cef05ce4feceaf6881d78d6ba0a1775d5334bd35:gnu/packages/emacs-xyz.scm > gnu/packages/emacs-xyz.cef.scm

  # prepare release; create an archive of files from a named tree
  git archive --format zip --output "output.zip" master

  # generate build number: nearest tag + nr of commits on top + sha1
  git describe master

  # list tags a given point
  git tag --points-at master
  git tag --points-at emacs-26
  git tag --points-at HEAD

  # workaround for 'ssh error: port 22: no route to host'
  git remote set-url origin https://github.com/<user_name>/<repo_name>.git
  git remote add origin ssh://user@"@"host:1234/srv/git/example

  # run as if started in <path> instead of the cwd current working directory.
  # See `man git` when multiple -C given
  git -C ~/.SpaceVim pull    # update SpaceVim

  # push only tags, not the code
  git push --tags origin

  # create lightweight tag - it won't be pushed by `git push ...`
  git tag <tagname>
  # annotated, signed tag(s) with a message will be pushed by `git push ...`
  git tag --annotate <tagname>

  # merge srcProj into dstProj
  cd path/to/dstProj
  git remote add srcProj /path/to/srcProj
  git fetch srcProj --tags
  git merge --allow-unrelated-histories srcProj/master # or whichever branch you want to merge
  # git merge --continue      # in case any conflicts; after resolving them
  git remote remove srcProj

  # Sign git commits
  gpg --list-secret-keys --keyid-format=long
  set --local keyId <secret-key-id>
  # Sign all commits by default
  git config --file $dotf/.gitconfig user.signingkey --gpg-sign=$keyId
  # Repeat following two commands for every commit
  git commit --amend --no-edit --gpg-sign=$keyId
  git rebase --continue
  # Verify last <number> commits
  git log --oneline --show-signature --max-count=<number>
  #
  # Analyze problems
  # GIT_TRACE=1 shows what git is actually doing. Only in bash. In the fish-shell
  # following doesn't work:
  #    set --local GIT_TRACE 1 git commit --amend --no-edit --gpg-sign
  GIT_TRACE=1 git commit --amend --no-edit --gpg-sign | rg
  echo "dummy" | <put-here-the-gpg-run_command-shown-above'
}

@block{@block-name{Mercurial}
  guix install mercurial
  hg clone https://hg.sr.ht/~yoctocell/guixrc
}
