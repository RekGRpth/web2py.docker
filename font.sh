#!/bin/sh

grep -r "Helvetica" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Helvetica|DejaVuSans|g" "$FILE"
done

grep -r "TimesNewRoman" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|TimesNewRoman|DejaVuSerif|g" "$FILE"
done

grep -r "Times New Roman" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Times New Roman|DejaVuSerif|g" "$FILE"
done

grep -r "Times-Roman" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Times-Roman|DejaVuSerif|g" "$FILE"
done

grep -r "Times-" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Times-|DejaVuSerif-|g" "$FILE"
done

grep -r "Arial" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Arial|DejaVuSans|g" "$FILE"
done

grep -r "Courier New" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Courier New|DejaVuSansMono|g" "$FILE"
done

grep -r "Courier" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Courier|DejaVuSansMono|g" "$FILE"
done

grep -r "/usr/share/fonts/dejavu" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|/usr/share/fonts/dejavu|/usr/share/fonts/ttf-dejavu|g" "$FILE"
done

grep -r "DEFAULT_CSS = \"\"\"" /usr/lib/python3.6/site-packages/reportlab /usr/lib/python3.6/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/share/fonts/ttf-dejavu'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: %s; src: url(\"%s\"); }' % (name, file) for name, file in fonts.items())) + \"\"\"" "$FILE"
done
