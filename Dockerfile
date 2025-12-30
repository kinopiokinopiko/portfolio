# render.yamlに合わせてPython 3.11を使用
FROM python:3.11-slim

# PostgreSQLの接続ライブラリに必要なものをインストール
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# 依存パッケージをインストール
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

# すべてのファイルをコピー
COPY . .

# render.yamlのstartCommandを参考に設定
# ポートは5000番で待ち受けます
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "4", "app:app"]