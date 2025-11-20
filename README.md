# Kaggle Template Environment

Kaggle 公式の Python イメージをベースに、Kaggle と同じディレクトリ構造（`/kaggle/working` / `/kaggle/input`）で作業できる開発用テンプレートです。CPU/GPU どちらのサービスも `docker-compose` で用意しており、VS Code の Dev Container からすぐに使えます。

## 事前準備
- Docker と docker compose
- VS Code と Dev Containers 拡張機能（Dev Container で開く場合）
- Kaggle API トークンを `~/.kaggle/kaggle.json` に保存し、`chmod 600 ~/.kaggle/kaggle.json` を実行

## 使い方
### VS Code Dev Container で開く（推奨）
1. 上記の Kaggle API トークンを配置。
2. VS Code でこのリポジトリを開き、「Reopen in Container」を実行。
   - デフォルトは CPU サービス（`kaggle-cpu`）で起動します。
   - GPU を使いたい場合は `devcontainer/devcontainer.json` の `service` を `kaggle-gpu` に変更するか、下記の docker compose 手順で GPU サービスを立ち上げてから VS Code でアタッチしてください。

### docker compose だけで使う
1. Kaggle トークンを配置後、コンテナを起動：
   ```bash
   docker compose up -d kaggle-cpu
   # GPU の場合
   # docker compose up -d kaggle-gpu
   ```
2. シェルに入る（必要ならポートを開けて Jupyter なども実行できます）：
   ```bash
   docker compose run --rm kaggle-cpu bash
   # 例: JupyterLab を使う場合
   # docker compose run --rm -p 8888:8888 kaggle-cpu jupyter lab --ip 0.0.0.0 --port 8888 --no-browser --NotebookApp.token=''
   ```
3. Kaggle データのダウンロード例：
   ```bash
   kaggle competitions download -c <competition> -p /kaggle/input
   unzip <downloaded-file> -d /kaggle/input/<competition>
   ```

## ローカル環境（uv）での開発
Dev Container を使わず手元で開発するときは、uv で仮想環境を作成して依存関係を管理します。
1. uv をインストール（未導入なら）：
   ```bash
   curl -Ls https://astral.sh/uv/install.sh | sh
   # または pip: pip install uv
   ```
2. 仮想環境を作成して有効化：
   ```bash
   uv venv .venv
   source .venv/bin/activate
   ```
3. 依存関係を同期：
   ```bash
   uv sync
   ```
   `pyproject.toml` / `uv.lock` に従ってパッケージがインストールされます。
   
   **プロジェクトごとに`uv add` で必要なパッケージを追加インストールしてください。**

4. VS Code を使う場合、`.vscode/setting.json` が `.venv/bin/python` を既定のインタープリタとして参照し、`ruff` でのフォーマット設定も含まれています。`.vscode/extensions.json` には推奨拡張がまとまっています。

## ディレクトリ構成
- `working/` → ホスト側のカレントが `/kaggle/working` にマウントされます（ノートブックやスクリプトはここで作業）。
- `input/` → `/kaggle/input` にマウントされるデータ配置用ディレクトリ。
- `.kaggle/` → ホスト側の `~/.kaggle` を `/root/.kaggle` にマウント（読み取り専用）。プロジェクト直下には置かないでください。

## 主要構成
- `Dockerfile`, `Dockerfile.gpu`：Kaggle 公式 CPU/GPU イメージ + `kaggle` CLI + `ruff` を追加。
- `docker-compose.yml`：CPU/GPU サービスとボリュームマウント設定。
- `devcontainer/devcontainer.json`：VS Code Dev Container 設定（`/kaggle/working` をワークスペースに設定）。

好みのライブラリはコンテナ内で `pip install` するか、`pyproject.toml` に追記してください。
