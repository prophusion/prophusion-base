#!/usr/bin/env bash
export PHPENV_ROOT=${PHPENV_ROOT:-'/usr/local/phpenv'}
export RBENV_ROOT="$PHPENV_ROOT"


# Is the requested version available locally?
if [ "$1" == "global" -o "$1" == "local" -o "$1" == "shell" -o "$1" == "apache-version" ]
then
  req_version="$2"
  if [ "$req_version" != "" ]
  then
    is_available=0
    versions=`$PHPENV_ROOT/bin/phpenv versions 2>/dev/null | grep -oP '[\d\.]{2,}'`
    for avail_version in $versions ; do
      if [ "$avail_version" == $req_version ]
      then
        if [ "$1" == "apache-version" ]
        then
          if [ $(ls "$PHPENV_ROOT/versions/$avail_version/libphp?.so" | wc -l) -eq 1 ]
          then
            is_available=1
          fi
        else
          is_available=1
        fi
      fi
    done

    if [ $is_available -eq 0 ]
    then
      echo "PHP version \"$req_version\" not found locally."
      echo "Checking remote builds..."
      echo "This product includes PHP software, freely available from"
      echo "<http://www.php.net/software/>"
      echo

      version_num=$req_version
      if [ "$1" == "apache-version" ]
      then
        req_version="$req_version-apache"
      fi

      headerfile=`mktemp -t prophusion_headers.XXXX`
      curl -Lf --dump-header "$headerfile" "https://prophusion.org/$req_version" | tee >(sha256sum > "$PHPENV_ROOT/versions/.unverified/${req_version}.sha256") | tar -xj -C "$PHPENV_ROOT/versions/.unverified"
      ps=( ${PIPESTATUS[*]} )
      if [ $? -ne 0 ]
      then
        if [ ${ps[0]} -eq 22 ]
        then
          >&2 echo "PHP \"$req_version\" not found in remote builds. Does it exist?"
          exit 1
        else
          >&2 echo "Unknown error fetching/extracting remote php version \"$req_version\"."
          exit 1
        fi
      else
        # verify hash
        expected_hash=`cat "$headerfile" | grep ^X-Hash-Sha256: | awk '{ print $2 }' | tr -d "\r\n"`
        actual_hash=`cat "$PHPENV_ROOT/versions/.unverified/${req_version}.sha256" | awk '{ print $1 }' | tr -d "\r\n"`

        if [ "$expected_hash" != "" -a "$expected_hash" == "$actual_hash" ]
        then
          # install it
          if [ "$1" == "apache-version" ]
          then
            mkdir "$PHPENV_ROOT/versions/${version_num}"
            mv "$PHPENV_ROOT/versions/.unverified/${req_version}"/* "$PHPENV_ROOT/versions/${version_num}/" \
              && rm -rf "$PHPENV_ROOT/versions/.unverified/${req_version}"
          else
            mv "$PHPENV_ROOT/versions/.unverified/${req_version}" "$PHPENV_ROOT/versions/${req_version}"
          fi
          $PHPENV_ROOT/bin/phpenv rehash

          echo "PHP $req_version downloaded, unpacked, and verified."
        else
          >&2 echo "Failed to verify integrity of downloaded build."
          >&2 echo "Expected sha256: $expected_hash"
          >&2 echo "Actual   sha256: $actual_hash"
          exit 1
        fi
      fi
    fi
  else
    >&2 echo "No PHP version specified. Usage: prophusion [global|local|shell] [php-version]"
  fi
fi

exec "$RBENV_ROOT/libexec/rbenv" "$@"
