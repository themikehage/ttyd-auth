FROM tsl0922/ttyd:latest

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

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
