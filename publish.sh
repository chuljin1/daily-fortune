#!/bin/zsh
set -e
SITE="$HOME/home/nano/fortune-site"
DATE=$(date +%F)
# 오늘 운세 md를 사이트 소스로 복사(없으면 스킵)
cp "$HOME/.openclaw/workspace/blog/${DATE}-운세.md" "$SITE/md/" 2>/dev/null || true
"$SITE/build.sh"
cd "$SITE"
git add -A
git -c user.name=chuljin100 -c user.email=chuljin100@gmail.com commit -q -m "운세 ${DATE}" 2>/dev/null || echo "noop"
git push -q origin main 2>&1 | tail -1 || true
echo "PUBLISHED ${DATE} -> https://chuljin1.github.io/daily-fortune/posts/${DATE}.html"
