#!/bin/bash

# 加载 .env 配置
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"
if [ -f "$ENV_FILE" ]; then
  set -a; source "$ENV_FILE"; set +a
else
  echo "❌ 未找到 .env 文件，请先配置："
  echo "   cp .env.example .env && vim .env"
  exit 1
fi

PROMPT="$1"
RESOLUTION="${2:-1K}"
API_ENDPOINT="https://api.apimart.ai/v1/images/generations"
POLL_ENDPOINT="https://api.apimart.ai/v1/tasks"
OUTPUT_DIR="${3:-$HOME/projects/todohub/generated_images}"

unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY

# Submit task
RESPONSE=$(curl -s --max-time 30 -X POST "$API_ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{\"model\":\"gemini-3-pro-image-preview\",\"prompt\":$(echo "$PROMPT" | jq -Rs .),\"resolution\":\"$RESOLUTION\"}")

TASK_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['data'][0]['task_id'])" 2>/dev/null)
if [ -z "$TASK_ID" ]; then
  echo "Failed to get task ID"
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
    
    # Send to Feishu
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
    
    echo "$OUTPUT_DIR/$FILENAME"
    exit 0
  elif [ "$STATUS" = "failed" ]; then
    echo "Task failed"
    exit 1
  fi
done

echo "Timeout"
exit 1
