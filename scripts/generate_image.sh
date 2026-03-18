#!/bin/bash
# 文章转图 - 生图脚本
# 使用 APImart 的 Gemini 图片生成 API
#
# 用法: ./generate_image.sh "<prompt>" [resolution] [output_dir]
# resolution: 1K (默认) / 2K / 4K

PROMPT="$1"
RESOLUTION="${2:-1K}"
OUTPUT_DIR="${3:-$HOME/projects/todohub/generated_images}"

# ========== 请填写你的密钥（让 Agent 帮你填即可） ==========
API_KEY="<your-apimart-api-key>"
API_ENDPOINT="https://api.apimart.ai/v1/images/generations"
POLL_ENDPOINT="https://api.apimart.ai/v1/tasks"

# 飞书推送（可选，不需要可留空）
FEISHU_APP_ID=""
FEISHU_APP_SECRET=""
FEISHU_USER_ID=""
# ===========================================================

unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY

mkdir -p "$OUTPUT_DIR"

# Submit task
RESPONSE=$(curl -s --max-time 30 -X POST "$API_ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{\"model\":\"gemini-3-pro-image-preview\",\"prompt\":$(echo "$PROMPT" | jq -Rs .),\"resolution\":\"$RESOLUTION\"}")

TASK_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data'][0]['task_id'])" 2>/dev/null)
if [ -z "$TASK_ID" ]; then
  echo "Failed to get task ID. Response: $RESPONSE"
  exit 1
fi
echo "Task submitted: $TASK_ID"

# Poll for result
for i in $(seq 1 30); do
  sleep 5
  RESULT=$(curl -s --max-time 15 "$POLL_ENDPOINT/$TASK_ID" -H "Authorization: Bearer $API_KEY")
  STATUS=$(echo "$RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data']['status'])" 2>/dev/null)
  echo "Status: $STATUS"

  if [ "$STATUS" = "completed" ]; then
    URL=$(echo "$RESULT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data']['result']['images'][0]['url'])" 2>/dev/null)
    FILENAME="img_$(date +%s).jpg"
    curl -s --max-time 60 "$URL" -o "$OUTPUT_DIR/$FILENAME"
    echo "Saved: $OUTPUT_DIR/$FILENAME"

    # Send to Feishu (optional)
    if [ -n "$FEISHU_APP_ID" ] && [ -n "$FEISHU_APP_SECRET" ] && [ -n "$FEISHU_USER_ID" ]; then
      TOKEN_RESP=$(curl -s --max-time 10 -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
        -H "Content-Type: application/json" \
        -d "{\"app_id\":\"$FEISHU_APP_ID\",\"app_secret\":\"$FEISHU_APP_SECRET\"}")
      FEISHU_TOKEN=$(echo "$TOKEN_RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tenant_access_token',''))" 2>/dev/null)

      if [ -n "$FEISHU_TOKEN" ]; then
        UPLOAD_RESP=$(curl -s --max-time 30 -X POST "https://open.feishu.cn/open-apis/im/v1/images" \
          -H "Authorization: Bearer $FEISHU_TOKEN" \
          -F "image_type=message" \
          -F "image=@$OUTPUT_DIR/$FILENAME")
        IMAGE_KEY=$(echo "$UPLOAD_RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('data',{}).get('image_key',''))" 2>/dev/null)

        if [ -n "$IMAGE_KEY" ]; then
          curl -s --max-time 15 -X POST "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id" \
            -H "Authorization: Bearer $FEISHU_TOKEN" \
            -H "Content-Type: application/json" \
            -d "{\"receive_id\":\"$FEISHU_USER_ID\",\"msg_type\":\"image\",\"content\":\"{\\\"image_key\\\":\\\"$IMAGE_KEY\\\"}\"}" > /dev/null
          echo "Sent to Feishu"
        fi
      fi
    fi

    echo "$OUTPUT_DIR/$FILENAME"
    exit 0
  elif [ "$STATUS" = "failed" ]; then
    echo "Task failed"
    exit 1
  fi
done

echo "Timeout"
exit 1
