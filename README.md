# OpenClaw Skill: Article to Image

将文章、笔记或文字内容转化为小红书风格的高密度信息图。

## 效果

发一篇文章给 OpenClaw，它自动提炼核心信息，生成一张可以直接发小红书的信息图。

## 安装

将 `SKILL.md` 和 `scripts/` 放到你的 OpenClaw Skills 目录：

```bash
cp -r . ~/.openclaw/skills/article-to-image/
chmod +x scripts/generate_image.sh
```

## 配置

安装后让 Agent 帮你填写 `scripts/generate_image.sh` 里的密钥即可。

### 必需：APImart API Key

在 [APImart](https://apimart.ai) 注册获取 API Key，填入脚本中的 `API_KEY` 字段。

### 可选：飞书推送

如果想自动把生成的图片推送到飞书，在脚本中填写 `FEISHU_APP_ID`、`FEISHU_APP_SECRET`、`FEISHU_USER_ID`。不需要可留空。

## 使用

在 OpenClaw 对话中，直接发文章内容或链接，说"帮我转成图"即可。

## 依赖

- `curl`
- `jq`
- `python3`
