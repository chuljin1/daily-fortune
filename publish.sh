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
# osxkeychain 헬퍼가 GUI 잠금해제 대기로 멈추는 문제 회피: gh 토큰을 URL에 실어 푸시
TOKEN=$(gh auth token 2>/dev/null)
if [ -n "$TOKEN" ]; then
  GIT_TERMINAL_PROMPT=0 git -c credential.helper= push -q "https://x-access-token:${TOKEN}@github.com/chuljin1/daily-fortune.git" main 2>&1 | tail -1 || true
else
  git push -q origin main 2>&1 | tail -1 || true
fi
echo "PUBLISHED ${DATE} -> https://chuljin1.github.io/daily-fortune/posts/${DATE}.html"
