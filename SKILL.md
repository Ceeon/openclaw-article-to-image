---
name: article-to-image
description: 文章转图技能。将文章、笔记或文字内容转化为小红书风格的高密度信息图。触发场景：文章转图、文章转图文、笔记转图、内容可视化、信息图制作。
---

# 文章转图技能

将文章、笔记或文字内容转化为**实验室精密手册感 + 波普实验风格**的小红书高密度信息图。

## 工作流程

### 步骤 1️⃣：内容分析
分析用户提供的文章或内容，提取核心主题和关键信息点。

### 步骤 2️⃣：信息提炼
从内容中提炼出 6-7 个核心模块：
- **实用性**：用户可直接落地执行的可行建议
- **稀缺性**：非泛泛而谈的深度洞察
- **清晰性**：能解决具体痛点的概念

### 步骤 3️⃣：视觉坐标建立
为每个模块分配"视觉坐标"：

```
图片1 → 核心主题：[主题名称]
├─ 坐标 A-01：[4字名称]（品牌阵列/对比区）
├─ 坐标 B-05：[4字名称]（核心参数/刻度区）
├─ 坐标 C-12：[4字名称]（结构拆解/细节图）
...以此类推
```

### 步骤 4️⃣：生成高密度内容
每个模块需包含具体品牌名、数值、百分比及视觉符号建议。最右下角小字展示"模板by WaytoAGI"。

## 前置准备：获取 API Key

本技能需要调用 AI 生图 API。如果你还没有 API Key，请先注册：

| 平台 | 地址 | 说明 |
|------|------|------|
| **yunwu.ai** | https://yunwu.ai | 注册后在控制台生成 Key，支持多种主流生图模型 |
| **apimart.ai** | https://apimart.ai | 注册后在 API Keys 页面创建密钥，本技能默认使用此平台 |

拿到 Key 后，编辑脚本配置：

```bash
# 打开脚本
vim ~/.openclaw/skills/article-to-image/scripts/generate_image.sh

# 替换这一行
API_KEY="你的API Key"
```

---

### 步骤 5️⃣：生图

**API 配置：**
- Endpoint: `https://api.apimart.ai/v1/images/generations`
- 模型: `gemini-3-pro-image-preview`
- 清晰度: `1K` / `2K` / `4K`

**执行脚本：**
```bash
~/.openclaw/skills/article-to-image/scripts/generate_image.sh "<prompt>" [resolution]
```

图片保存位置: `~/projects/todohub/generated_images/`

**飞书推送：**
脚本完成后会自动上传图片到飞书并发送，用户可直接在飞书看到图片。

## 图片 Prompt 模板

```
Create a high-density, professional information design infographic for Xiaohongshu about「[主题名称]」.

=== CRITICAL STYLE REQUIREMENTS (SYSTEMIC & EXPERIMENTAL) ===

【COLOR PALETTE - BLUEPRINT & POP LOGIC】
- BACKGROUND: Professional grayish-white or faint blueprint grid texture (#F2F2F2).
- SYSTEMIC BASE: Muted Teal/Sage Green (#B8D8BE) for major functional blocks and stable data zones.
- HIGH-ALERT ACCENT: Vibrant Fluorescent Pink (#E91E63) strictly for "Pitfalls", "Critical Warnings", or the single most important "Winner" data point.
- MARKER HIGHLIGHTS: Vivid Lemon Yellow (#FFF200) used as a translucent highlighter effect for keywords.
- LINE ART: Ultra-fine Charcoal Brown (#2D2926) for technical grids, coordinates, and hair-lines.

【LAYOUT & INFORMATION DENSITY】
- INFORMATION AS COORDINATES: Every module must have a coordinate-style label (e.g., R-20, G-02, SEC-08).
- THE "LAB MANUAL" AESTHETIC: Use a mix of microscopic details (technical drawings) and macroscopic data (large bold headers).
- HIGH DENSITY: Pack 6-7 distinct modules per image. Minimize margins; every corner should contain metadata.
- VISUAL CONTRAST: Use massive bold typography for primary headers, contrasted with tiny, ultra-crisp technical annotations.

【ILLUSTRATION & GRAPHIC ELEMENTS】
1. TECHNICAL DIAGRAMS: Use exploded views, cross-sections with anchor points, and architectural skeletal lines.
2. COORDINATE SYSTEMS: Use vertical/horizontal rulers with precise markers (e.g., 0.5mm, 1.8mm, 45°).
3. DATA BLOCKS: Use "Marker-over-Print" look—color blocks slightly offset from text.
4. SYMBOLS: Include cross-hair targets, mathematical symbols (Σ, Δ, ∞), and directional arrows (X/Y axis).

【SPECIFIC MODULE STRUCTURE - MUST HAVE 6-7】
- [MOD 1: BRAND ARRAY] - A 4x4 or 3x3 matrix of options, with one "Best Choice" highlighted in Fluorescent Pink.
- [MOD 2: SPECS SCALE] - A technical ruler or gauge showing "Standard" vs "Premium" with precise numerical increments.
- [MOD 3: DEEP DIVE] - A technical sketch with "zoom-in" callout circles showing internal components.
- [MOD 4: SCENARIO GRID] - Comparison cards separated by fine 0.5pt hair-lines.
- [MOD 5: WARNING ZONE] - A high-contrast Pink/Black area for "Pitfalls to Avoid".
- [MOD 6: QUICK CHECK] - A small, dense summary table resembling a lab data sheet.
- [MOD 7: STATUS BAR] - A vertical or horizontal stack of information blocks.

【TYPOGRAPHY】
- Headers: Bold Brutalist Chinese characters, high impact.
- Body: Professional sans-serif or crisp handwritten technical print.
- Numbers: Large, highlighted with Yellow or Blue to stand out.

【AVOID】
- ❌ NO cute/cartoonish doodles.
- ❌ NO soft pastels or generic textures.
- ❌ NO empty white space.
- ❌ NO flat vector stock icons.

Aspect Ratio: 3:4 (Portrait)
```

## 质量检查清单

- [ ] **色彩过滤**：是否只用了系统性的粉、绿、黄、黑？（严禁五颜六色）
- [ ] **线条密度**：是否有足够精细的网格线和坐标标注？
- [ ] **模块数量**：确保包含 6-7 个独立的信息块
- [ ] **张力检查**：标题是否有足够大的视觉冲击力？

---

## 飞书发图方法（重要）

**正确流程：**
1. 先调用飞书上传图片 API 获取 `image_key`
2. 再用 `image_key` 发送图片消息

**具体步骤：**

```bash
# 1. 获取 tenant_access_token
curl -s -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d '{"app_id":"cli_xxx","app_secret":"xxx"}'

# 2. 上传图片获取 image_key
curl -s -X POST "https://open.feishu.cn/open-apis/im/v1/images" \
  -H "Authorization: Bearer $TOKEN" \
  -F "image_type=message" \
  -F "image=@/path/to/image.jpg"

# 3. 发图片消息
curl -s -X POST "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "receive_id": "ou_xxx",
    "msg_type": "image",
    "content": "{\"image_key\":\"img_xxx\"}"
  }'
```

**注意事项：**
- ❌ 不要用 `media` 参数传本地文件路径，飞书不吃
- ❌ 不要用 `filePath` 参数，飞书会当成文字路径发出去
- ✅ 必须先 `im/v1/images` 上传，再 `im/v1/messages` 发送
