<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:variable name="title" select="/atom:feed/atom:title"/>
    <xsl:variable name="description" select="/atom:feed/atom:subtitle"/>
    <xsl:variable name="home" select="/atom:feed/atom:link[@rel='alternate']/@href"/>
    <html lang="zh-CN">
      <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="theme-color" content="#f2f0e8"/>
        <link rel="icon" href="/favicon.ico"/>
        <title><xsl:value-of select="$title"/> · Atom 订阅</title>
        <style>
          :root {
            --bg: #f2f0e8;
            --paper: #fbfaf5;
            --surface: #dfe8db;
            --ink: #173f35;
            --muted: #577068;
            --accent: #ef8d6a;
            --accent-ink: #173f35;
            --line: rgba(23, 63, 53, .18);
            --radius: 22px;
            color-scheme: light;
          }
          html[data-theme="dark"] {
            --bg: #112e27;
            --paper: #17372f;
            --surface: #193d34;
            --ink: #f4f0e4;
            --muted: #b2c4bb;
            --accent: #ff8a5f;
            --accent-ink: #112e27;
            --line: rgba(244, 240, 228, .16);
            color-scheme: dark;
          }
          * { box-sizing: border-box; }
          body { margin: 0; color: var(--ink); background: var(--bg); font-family: "Avenir Next", Avenir, "PingFang SC", "Microsoft YaHei", sans-serif; -webkit-font-smoothing: antialiased; }
          a { color: inherit; text-decoration: none; }
          .shell { width: min(940px, calc(100% - 3rem)); margin-inline: auto; }
          .feed-header { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: 2rem; align-items: end; padding: clamp(4rem, 10vw, 7rem) 0 3rem; }
          .brand { display: flex; gap: 1rem; align-items: center; }
          .brand img { width: 5rem; height: 5rem; object-fit: contain; }
          h1 { margin: 0; font-size: clamp(2.8rem, 8vw, 5.8rem); line-height: .9; letter-spacing: -.07em; }
          .feed-header p { max-width: 34rem; margin: 1.2rem 0 0; color: var(--muted); line-height: 1.7; }
          .feed-home { align-self: center; padding: .75rem 1rem; border: 1px solid var(--line); border-radius: 999px; font-size: .75rem; font-weight: 750; transition: border-color .25s, transform .25s; }
          .feed-home:hover { border-color: var(--accent); transform: translateY(-1px); }
          .feed-note { display: grid; grid-template-columns: minmax(0, 1fr) auto; gap: .8rem 1.2rem; align-items: center; margin: 0 0 2rem; padding: 1.2rem 1.4rem; color: var(--muted); background: var(--surface); border-radius: var(--radius); font-size: .82rem; line-height: 1.65; }
          .feed-note p { margin: 0; }
          .feed-copy { display: flex; flex-wrap: wrap; gap: .6rem .8rem; align-items: center; }
          .feed-copy-button { min-height: 38px; padding: .65rem 1rem; color: var(--accent-ink); background: var(--accent); border: 0; border-radius: 999px; cursor: pointer; font: inherit; font-size: .72rem; font-weight: 750; white-space: nowrap; transition: background-color .25s, transform .25s, opacity .25s; }
          .feed-copy-button:hover:not(:disabled) { background: color-mix(in srgb, var(--accent) 86%, var(--paper)); }
          .feed-copy-button:active:not(:disabled) { transform: scale(.98); }
          .feed-copy-button:focus-visible { outline: 2px solid var(--ink); outline-offset: 3px; }
          .feed-copy-button:disabled { cursor: wait; opacity: .72; }
          .feed-copy-status { min-height: 1rem; font-size: .68rem; }
          .entries { display: grid; gap: .65rem; padding-bottom: 5rem; }
          .entry { overflow: hidden; background: var(--paper); border-radius: calc(var(--radius) * .7); }
          .entry summary { display: grid; grid-template-columns: minmax(0, 1fr) auto auto; gap: 1rem; align-items: center; padding: 1.15rem 1.3rem; cursor: pointer; list-style: none; }
          .entry summary::-webkit-details-marker { display: none; }
          .entry summary::after { content: "展开"; color: var(--muted); font-size: .68rem; }
          .entry[open] summary::after { content: "收起"; }
          .entry-title { margin: 0; font-size: 1.05rem; line-height: 1.35; letter-spacing: -.025em; }
          .entry-date { color: var(--muted); font-size: .68rem; font-variant-numeric: tabular-nums; white-space: nowrap; }
          .entry-body { padding: 0 1.3rem 1.3rem; border-top: 1px solid var(--line); }
          .entry-tags { display: flex; flex-wrap: wrap; gap: .7rem; padding-top: 1rem; color: var(--muted); font-size: .66rem; }
          .entry-summary { margin: 1rem 0; color: var(--muted); font-size: .82rem; line-height: 1.7; }
          .read-more { display: inline-block; padding-bottom: .15rem; border-bottom: 1px solid var(--accent); font-size: .76rem; font-weight: 750; }
          .feed-footer { padding: 2.5rem 0; border-top: 1px solid var(--line); color: var(--muted); font-size: .72rem; line-height: 1.7; }
          .feed-footer a { color: var(--ink); }
          @media (max-width: 640px) {
            .shell { width: min(100% - 2rem, 940px); }
            .feed-header { grid-template-columns: 1fr; padding-top: 3rem; }
            .brand { align-items: flex-end; }
            .brand img { width: 4rem; height: 4rem; }
            .feed-home { justify-self: start; }
            .feed-note { grid-template-columns: 1fr; }
            .entry summary { grid-template-columns: minmax(0, 1fr) auto; }
            .entry summary::after { grid-column: 2; grid-row: 1; }
            .entry-date { grid-column: 1 / -1; }
          }
        </style>
        <script>
          (function() {
            var theme = 'light';
            try {
              if (localStorage.getItem('corgi-theme') === 'dark') theme = 'dark';
            } catch (error) {}
            document.documentElement.dataset.theme = theme;

            document.addEventListener('DOMContentLoaded', function() {
              var button = document.querySelector('[data-copy-feed]');
              var status = document.querySelector('[data-copy-feed-status]');
              if (!button || !status) return;
              var defaultLabel = button.textContent;
              var restoreTimer;

              function copyFeedUrl() {
                var feedUrl = window.location.href.split('#')[0];
                if (navigator.clipboard) {
                  if (window.isSecureContext) return navigator.clipboard.writeText(feedUrl);
                }
                return new Promise(function(resolve, reject) {
                  var textarea = document.createElement('textarea');
                  textarea.value = feedUrl;
                  textarea.setAttribute('readonly', '');
                  textarea.style.position = 'fixed';
                  textarea.style.opacity = '0';
                  document.body.appendChild(textarea);
                  textarea.select();
                  var copied = document.execCommand('copy');
                  textarea.remove();
                  if (copied) resolve();
                  else reject(new Error('copy failed'));
                });
              }

              button.addEventListener('click', function() {
                window.clearTimeout(restoreTimer);
                button.disabled = true;
                button.textContent = '正在复制';
                status.textContent = '';
                copyFeedUrl().then(function() {
                  button.textContent = '已复制';
                  status.textContent = '订阅源地址已复制。';
                }).catch(function() {
                  button.textContent = '再试一次';
                  status.textContent = '复制失败，请手动复制当前地址。';
                }).finally(function() {
                  button.disabled = false;
                  restoreTimer = window.setTimeout(function() {
                    button.textContent = defaultLabel;
                    status.textContent = '';
                  }, 3200);
                });
              });
            });
          })();
        </script>
      </head>
      <body>
        <header class="feed-header shell">
          <div>
            <div class="brand">
              <img src="/images/brand-mark.png" alt=""/>
              <h1><xsl:value-of select="$title"/></h1>
            </div>
            <p><xsl:value-of select="$description"/></p>
          </div>
          <a class="feed-home" href="{$home}">返回博客</a>
        </header>

        <main class="shell">
          <div class="feed-note">
            <p>这是本站的 Atom 订阅源。复制当前地址并添加到阅读器，就能及时收到新文章。</p>
            <div class="feed-copy">
              <button class="feed-copy-button" type="button" data-copy-feed="">复制订阅源</button>
              <span class="feed-copy-status" role="status" aria-live="polite" data-copy-feed-status=""></span>
            </div>
          </div>
          <div class="entries">
            <xsl:for-each select="/atom:feed/atom:entry">
              <xsl:variable name="entryLink" select="atom:link[@rel='alternate']/@href"/>
              <details class="entry">
                <summary>
                  <h2 class="entry-title"><xsl:value-of select="atom:title"/></h2>
                  <time class="entry-date"><xsl:value-of select="substring(atom:published, 1, 10)"/></time>
                </summary>
                <div class="entry-body">
                  <xsl:if test="atom:category">
                    <div class="entry-tags">
                      <xsl:for-each select="atom:category"><span><xsl:value-of select="@term"/></span></xsl:for-each>
                    </div>
                  </xsl:if>
                  <p class="entry-summary"><xsl:value-of select="atom:summary"/></p>
                  <a class="read-more" href="{$entryLink}">阅读全文</a>
                </div>
              </details>
            </xsl:for-each>
          </div>
        </main>

        <footer class="feed-footer">
          <div class="shell">© <xsl:value-of select="substring(/atom:feed/atom:updated, 1, 4)"/> <a href="{$home}"><xsl:value-of select="$title"/></a></div>
        </footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
