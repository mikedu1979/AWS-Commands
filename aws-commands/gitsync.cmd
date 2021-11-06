set CommitMessage=%1
if [%CommitMessage%]==[] set CommitMessage=Anonymous Commit
git add -A
git commit -a -m "%CommitMessage%"
git pull
git push
