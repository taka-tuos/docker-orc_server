# docker-orc_server

aarch64(RPiとか)でRC鯖

## いるもの

- `docker`
- `docker-compose`
- `RC鯖が建てられる回線`
- `あきらめない心`

## いれかた

```sh
git clone https://github.com/taka-tuos/docker-orc_server.git
cd docker-orc_server
```

## つかいかた

### ビルド

```sh
docker-compose build
```

### 起動

```sh
docker-compose up -d
```

### 終了

```sh
docker-compose down
```

## 設定

`docker-compose.yml`をこう、直接何とかする。あきらめない心でなんとかしましょう  
`-sv`がポート指定オプションです

