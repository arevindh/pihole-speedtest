FROM pihole/pihole:latest
RUN curl -sSL https://github.com/arevindh/pihole-speedtest/raw/master/mod | sudo bash
