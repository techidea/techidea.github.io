hexo generate
cp -R public/* .deploy/techidea.github.io
cd .deploy/techidea.github.io
git add .
git commit -m   “first”
git push origin master