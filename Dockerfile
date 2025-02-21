# Ubuntu 24.04を使う
FROM ubuntu:24.04

# 必要パッケージのインストール
RUN apt-get update
RUN apt-get install -y tzdata wget cabextract unzip busybox

# Asia/Tokyoにセット
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# にほんご
RUN apt-get -y install language-pack-ja-base language-pack-ja
RUN locale-gen ja_JP.UTF-8 en_US.UTF-8
RUN update-locale LANG=ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# ワークディレクトリに遷移
WORKDIR /tmp/work

# Hangoverをダウンロード
RUN wget https://github.com/AndreRH/hangover/releases/download/hangover-10.0/hangover_10.0_ubuntu2404_noble_arm64.tar

# 展開
RUN tar xvf hangover_10.0_ubuntu2404_noble_arm64.tar

# インストール
RUN apt install -y ./hangover-libqemu_10.0~noble_arm64.deb ./hangover-wine_10.0~noble_arm64.deb ./hangover-libwow64fex_10.0_arm64.deb ./hangover-libarm64ecfex_10.0_arm64.deb

# ユーザーの作成
RUN groupadd -g 1001 user && useradd -m -u 1001 -g 1001 user

# 切替
USER user
WORKDIR /home/user/

# winetricksのダウンロード
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN chmod +x winetricks

# wineの初期化、DirectPlayのインストール
# RUN行は1行にしておかないと動かない(一通り全部同じwineserverで行う必要があるため)
ENV XDG_RUNTIME_DIR=/tmp
RUN wineboot -i && wineboot -u && ./winetricks directplay && wineserver -w

# winetricksのキャッシュをクリア
RUN rm -rf /home/user/.cache/winetricks/

# orc_serverのディレクトリを作成
WORKDIR /home/user/orc_server

# ↑のディレクトリがrootになってるので直す
# buildkit?とやらを使えば直るらしいが、ここ(Dockerfile)でもdocker-compose.ymlでも指定できないっぽいので筋肉解決
USER root
RUN chown -R user:user /home/user/orc_server 
USER user

# orc_serverを展開
RUN wget https://github.com/taka-tuos/orc_server/releases/download/1.0/orc_server-1.0.zip
RUN unzip orc_server-1.0.zip

# シナリオをコピー
ADD stat_v100.rcs /home/user/orc_server

# statフォルダを作成
RUN mkdir stat

# run.shをコピー
ADD run.sh /home/user/orc_server

# 実行権限を付与
USER root
RUN chown -R user:user /home/user/orc_server/run.sh
USER user
RUN chmod +x /home/user/orc_server/run.sh