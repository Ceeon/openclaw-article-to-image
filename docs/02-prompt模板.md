<!--
input: 文章/笔记内容
output: 可直接用于生图 API 的英文 Prompt
pos: 核心创作模板

架构守护者：一旦我被修改，请同步更新：
1. 本文件的头部注释
2. 所属文件夹的 README.md（即 SKILL.md 索引）
-->

# Prompt 模板

## 模板正文

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
