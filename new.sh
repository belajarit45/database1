services:
  earnapp1:
    container_name: earnapp1
    image: fazalfarhan01/earnapp:lite
    restart: always
    environment:
      - EARNAPP_UUID=sdk-node-a4440cfc329f49ecbc349e43f90c9c25

  earnapp2:
    container_name: earnapp2
    image: fazalfarhan01/earnapp:lite
    restart: always
    environment:
      - EARNAPP_UUID=sdk-node-a5d04caa43a64867bc008c0f533e33b6

  earnapp3:
    container_name: earnapp3
    image: fazalfarhan01/earnapp:lite
    restart: always
    environment:
      - EARNAPP_UUID=sdk-node-693434f335914a07872ca17b554c5748

  earnapp4:
    container_name: earnapp4
    image: fazalfarhan01/earnapp:lite
    restart: always
    environment:
      - EARNAPP_UUID=sdk-node-80b9d5b677a94bd68c3baaa77511cea7

  earnapp5:
    container_name: earnapp5
    image: fazalfarhan01/earnapp:lite
    restart: always
    environment:
      - EARNAPP_UUID=sdk-node-6c6a7d495c0843e5bdc3b869bdaf5a05
