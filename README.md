# Minecraft container facilitated

Simple minecraft image, only need a docker compose file to run. Server accessible via screen command.

You can add any [server.properties](https://minecraft.fandom.com/wiki/Server.properties) variable in the `environment` key in the compose yaml.

To run a simple creative vanilla 1.21.1 server:
```yaml
services:
  minecraft:
    image: bernardo1r/minecraft
    container_name: minecraft-server
    build:
      args:
        - "WORKDIR=/minecraft"
    ports:
      - 25565:25565
    tty: true
    restart: always
    volumes:
      - "minecraft-server:/minecraft"
    environment:
      DOWNLOAD_URL: "https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar"
      EULA: true
      GAMEMODE: "creative"

volumes:
  minecraft-server:
    name: "minecraft-server"
```

To run an vanilla 1.21.1 server with custom memory settings add the keys `SERVER_NAME` and `RUN_COMMAND`:
```yaml
services:
  minecraft:
    image: bernardo1r/minecraft
    container_name: minecraft-server
    build:
      args:
        - "WORKDIR=/minecraft"
    ports:
      - 25565:25565
    tty: true
    restart: always
    volumes:
      - "minecraft-server:/minecraft"
    environment:
      DOWNLOAD_URL: "https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar"
      SERVER_NAME: "server.jar"
      RUN_COMMAND: "java -Xmx2G -Xms512M -jar server.jar nogui"
      EULA: true

volumes:
  minecraft-server:
    name: "minecraft-server"
```

To run an server for FTB modpack:
```yaml
services:
  minecraft:
    image: bernardo1r/minecraft
    container_name: minecraft-server
    build:
      args:
        - "WORKDIR=/minecraft"
    ports:
      - 25565:25565
    tty: true
    restart: always
    volumes:
      - "minecraft-server:/minecraft"
    environment:
      DOWNLOAD_URL: "https://api.feed-the-beast.com/v1/modpacks/public/modpack/128/100170/server/linux"
      SERVER_TYPE: "FTB"
      EULA: true

volumes:
  minecraft-server:
    name: "minecraft-server"
```

If this setup fails or you need another modpack, you will need to use the keys `SERVER_SETUP_ARGS` and `SERVER_COMMAND`:
```yaml
services:
  minecraft:
    image: bernardo1r/minecraft
    container_name: minecraft-server
    build:
      args:
        - "WORKDIR=/minecraft"
    ports:
      - 25565:25565
    tty: true
    restart: always
    volumes:
      - "minecraft-server:/minecraft"
    environment:
      DOWNLOAD_URL: "https://api.feed-the-beast.com/v1/modpacks/public/modpack/128/100170/server/linux"
      SERVER_SETUP_ARGS: "-auto -force -pack 128 -version 100170"
      SERVER_COMMAND: "./run.sh"
      EULA: true

volumes:
  minecraft-server:
    name: "minecraft-server"
```
