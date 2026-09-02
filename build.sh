#!/bin/zsh
set -e
SITE="$HOME/home/nano/fortune-site"
BASE="https://chuljin1.github.io/daily-fortune"
cd "$SITE"
TITLE_SITE="오늘의 종합운세"
: > sitemap_urls.tmp
echo "$BASE/" >> sitemap_urls.tmp
# 각 md -> post html
for md in md/*.md; do
  d=$(basename "$md" .md); date="${d%-운세}"
  body=$(pandoc "$md" -f gfm -t html5)
  desc=$(pandoc "$md" -t plain | tr '\n' ' ' | sed 's/  */ /g' | cut -c1-150)
  cat > "posts/$date.html" <<HTML
<!doctype html><html lang="ko"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>오늘의 종합운세 $date | $TITLE_SITE</title>
<meta name="description" content="$desc">
<link rel="canonical" href="$BASE/posts/$date.html">
<meta property="og:type" content="article"><meta property="og:title" content="오늘의 종합운세 $date">
<meta property="og:description" content="$desc"><meta property="og:url" content="$BASE/posts/$date.html">
<meta name="robots" content="index,follow">
<link rel="stylesheet" href="../style.css">
<script type="application/ld+json">{"@context":"https://schema.org","@type":"BlogPosting","headline":"오늘의 종합운세 $date","datePublished":"$date","inLanguage":"ko","description":"$desc"}</script>
</head><body><div class="wrap">
<header class="site"><h1><a href="../index.html">🔮 $TITLE_SITE</a></h1></header>
<article>$body<hr><p class="date"><a href="../index.html">← 전체 운세 보기</a></p></article>
<footer>© 오늘의 종합운세 · 재미로 보는 운세입니다.</footer>
</div></body></html>
HTML
  echo "$BASE/posts/$date.html" >> sitemap_urls.tmp
done
# index.html (최신순)
items=""
for f in $(ls -r posts/*.html); do d=$(basename "$f" .html); items="$items<li><a href=\"posts/$d.html\">🔮 $d 오늘의 종합운세</a></li>"; done
cat > index.html <<HTML
<!doctype html><html lang="ko"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>$TITLE_SITE — 매일 아침 새로 올라오는 오늘의 운세</title>
<meta name="description" content="매일 아침 업데이트되는 오늘의 종합운세. 총운·애정운·금전운·직장운·건강운과 행운의 숫자·색·방향까지 한눈에.">
<link rel="canonical" href="$BASE/">
<meta property="og:title" content="$TITLE_SITE"><meta property="og:description" content="매일 아침 새로 올라오는 오늘의 종합운세">
<meta property="og:url" content="$BASE/"><meta name="robots" content="index,follow">
<link rel="stylesheet" href="style.css">
</head><body><div class="wrap">
<header class="site"><h1>🔮 $TITLE_SITE</h1><p>매일 아침, 오늘의 기운을 한눈에</p></header>
<ul class="postlist">$items</ul>
<footer>© 오늘의 종합운세 · 재미로 보는 운세입니다.</footer>
</div></body></html>
HTML
# sitemap.xml + robots.txt
{ echo '<?xml version="1.0" encoding="UTF-8"?>'; echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
  while read u; do echo "<url><loc>$u</loc></url>"; done < sitemap_urls.tmp; echo '</urlset>'; } > sitemap.xml
rm -f sitemap_urls.tmp
printf 'User-agent: *\nAllow: /\nSitemap: %s/sitemap.xml\n' "$BASE" > robots.txt
touch .nojekyll
echo "BUILT site: $(ls posts | wc -l | tr -d ' ') posts"
