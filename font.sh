#!/bin/sh

grep -r "helvetica" /usr/lib/python3.6/site-packages | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|helvetica|dejavusans|g" "$FILE"
done

grep -r "Helvetica" /usr/lib/python3.6/site-packages | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Helvetica|DejaVuSans|g" "$FILE"
done

find /usr/lib/python3.6/site-packages -name "*helvetica*.py" | while read -r FILE; do
    echo "$FILE"
    echo "${FILE//helvetica/dejavusans}"
    mv "$FILE" "${FILE//helvetica/dejavusans}"
done

grep -r "/usr/share/fonts/dejavu" /usr/lib/python3.6/site-packages | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|/usr/share/fonts/dejavu|/usr/share/fonts/ttf-dejavu|g" "$FILE"
done

grep -r "DEFAULT_CSS = \"\"\"" /usr/lib/python3.6/site-packages | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/share/fonts/ttf-dejavu'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: %s; src: url(\"%s\"); }' % (name, file) for name, file in fonts.items())) + \"\"\"" "$FILE"
done
