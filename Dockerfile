FROM alpine:latest

ENV LANG=en_US.UTF-8 \
    PATH="/usr/glibc-compat/sbin:/usr/glibc-compat/bin:$PATH"

RUN apk update && apk add --no-cache --virtual=.build-dependencies wget grep curl ca-certificates && \
    latestUrl=$(curl -s https://github.com/sgerrand/alpine-pkg-glibc/releases/latest | grep -oP '"\K[^"\047]+(?=["\047])') && \
    latestVer=${latestUrl##*/} && \
    downloadUrl=$(echo $latestUrl | sed 's/tag/download/') && \
    glibcBaseFileName="glibc-${latestVer}.apk" && \
    glibcBinFileName="glibc-bin-${latestVer}.apk" && \
    glibcI18nFileName="glibc-i18n-${latestVer}.apk" && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget \
        "$downloadUrl/$glibcBaseFileName" \
        "$downloadUrl/$glibcBinFileName" \
        "$downloadUrl/$glibcI18nFileName" && \
    apk add --no-cache \
        "$glibcBaseFileName" \
        "$glibcBinFileName" \
        "$glibcI18nFileName" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    (/usr/glibc-compat/bin/localedef --force -i en_US -f UTF-8 "$LANG" || true) && \
    echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$glibcBaseFileName" \
        "$glibcBinFileName" \
        "$glibcI18nFileName"
