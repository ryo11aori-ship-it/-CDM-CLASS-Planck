FROM ubuntu:22.04

# 必要最低限
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work

# CLASS を取得（毎回 fresh）
RUN git clone --depth 1 https://github.com/lesgourg/class_public.git class

# スクリプトだけコピー
COPY scripts /work/scripts

# ビルド
RUN make -C class

# 実行権限
RUN chmod +x /work/scripts/alive_check.sh

ENTRYPOINT ["/work/scripts/alive_check.sh"]