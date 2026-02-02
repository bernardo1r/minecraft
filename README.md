# Minecraft container facilitated

Simple minecraft image, only need a docker compose file to run. Server accessible via screen command.

You can add any [server.properties](https://minecraft.fandom.com/wiki/Server.properties) variable in the `environment` key in the compose yaml.

To run a simple creative vanilla 1.21.1 server:
```yaml
services:
  minecraft:
    build:
      args:
        - "WORKDIR=/minecraft"
    image: bernardo1r/minecraft
    container_name: minecraft
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

To run an vanilla 1.21.1 server with custom memory settings add the key `RUN_COMMAND_ARGS`:
```yaml
services:
  minecraft:
    build:
      args:
        - "WORKDIR=/minecraft"
    image: bernardo1r/minecraft
    container_name: minecraft
    ports:
      - 25565:25565
    tty: true
    restart: always
    volumes:
      - "minecraft-server:/minecraft"
    environment:
      DOWNLOAD_URL: "https://piston-data.mojang.com/v1/objects/64bb6d763bed0a9f1d632ec347938594144943ed/server.jar"
      RUN_COMMAND_ARGS: "-Xmx10G"
      EULA: true

volumes:
  minecraft-server:
    name: "minecraft-server"
```

To run an OceanBlock 2 server from FTB modpack:
```yaml
services:
  minecraft:
    build:
      args:
        - "WORKDIR=/minecraft"
    image: bernardo1r/minecraft
    container_name: minecraft
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

To run a Cobbleverse from Modrinth modpacks:
```yaml
services:
  minecraft:
    build:
      args:
        - "WORKDIR=/minecraft"
    image: bernardo1r/minecraft
    container_name: minecraft
    ports:
      - 25565:25565
    tty: true
    restart: always
    volumes:
      - "minecraft-server:/minecraft"
    environment:
      DOWNLOAD_URL: "https://cdn.modrinth.com/data/Jkb29YJU/versions/ERxm2is0/COBBLEVERSE%201.7.2.mrpack"
      DOWNLOAD_SERVER_URL: "https://meta.fabricmc.net/v2/versions/loader/1.21.1/0.18.4/1.1.1/server/jar"
      SERVER_TYPE: "MODRINTH"
      EULA: true

volumes:
  minecraft-server:
    name: "minecraft-server"
```
