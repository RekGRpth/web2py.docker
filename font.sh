#!/bin/sh

grep -r "Helvetica" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Helvetica|LiberationSans-Regular|g" "$FILE"
done

grep -r "TimesNewRoman" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|TimesNewRoman|LiberationSerif-Regular|g" "$FILE"
done

grep -r "Times New Roman" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Times New Roman|LiberationSerif-Regular|g" "$FILE"
done

grep -r "Times-Roman" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Times-Roman|LiberationSerif-Regular|g" "$FILE"
done

grep -r "Times-" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Times-|LiberationSerif-|g" "$FILE"
done

grep -r "Arial" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Arial|LiberationSans-Regular|g" "$FILE"
done

grep -r "Courier New" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Courier New|LiberationMono-Regular|g" "$FILE"
done

grep -r "Courier" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|Courier|LiberationMono-Regular|g" "$FILE"
done

grep -r "/usr/share/fonts/dejavu" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|/usr/share/fonts/dejavu|/usr/share/fonts/ttf-liberation|g" "$FILE"
done

grep -r "DEFAULT_CSS = \"\"\"" /usr/local/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do
    echo "$FILE"
    sed -i "s|font-weight:bold;|font-weight:bold;font-family: LiberationSans-Bold;|g" "$FILE"
    sed -i "s|font-weight: bold;|font-weight:bold;font-family: LiberationSans-Bold;|g" "$FILE"
    sed -i "s|font-style: italic;|font-style: italic;font-family: LiberationSans-Italic;|g" "$FILE"
    sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/share/fonts/ttf-liberation'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"
done
