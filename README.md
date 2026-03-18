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

### 必需：APImart API Key

在 [APImart](https://apimart.ai) 注册获取 API Key，然后设置环境变量：

```bash
export APIMART_API_KEY="your-key-here"
```

### 可选：飞书推送

如果想自动把生成的图片推送到飞书，配置以下环境变量：

```bash
export FEISHU_APP_ID="your-feishu-app-id"
export FEISHU_APP_SECRET="your-feishu-app-secret"
export FEISHU_USER_ID="your-feishu-open-id"
```

## 使用

在 OpenClaw 对话中，直接发文章内容或链接，说"帮我转成图"即可。

## 依赖

- `curl`
- `jq`
- `python3`
