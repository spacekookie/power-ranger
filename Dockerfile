# Usage instructions:
# 1. "docker build -t power-ranger/power-ranger:latest ."
# 2. "docker run -it power-ranger/power-ranger"

FROM debian

RUN apt-get update && apt-get install -y power-ranger
ENTRYPOINT ["power-ranger"]
