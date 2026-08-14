FROM tsl0922/ttyd:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        unzip \
        usbutils \
        && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://dl.google.com/android/repository/platform-tools-latest-linux.zip -o /tmp/platform-tools.zip \
    && unzip -q /tmp/platform-tools.zip -d /opt \
    && rm /tmp/platform-tools.zip

RUN curl -fsSL https://opencode.ai/install | bash

RUN printf '%s\n' \
    '#!/bin/bash' \
    'set -euo pipefail' \
    'if [ -z "${TTYD_USER:-}" ] || [ -z "${TTYD_PASS:-}" ]; then' \
    '  echo "FATAL: TTYD_USER and TTYD_PASS environment variables must be set" >&2' \
    '  exit 1' \
    'fi' \
    'exec /usr/bin/ttyd -c "${TTYD_USER}:${TTYD_PASS}" -W bash' \
    > /entrypoint.sh \
    && chmod +x /entrypoint.sh

ENV PATH="/opt/platform-tools:/root/.opencode/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
