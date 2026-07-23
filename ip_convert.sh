#!/bin/bash

API="https://siberguvenlik.gov.tr/api/address/index?type=ip"

OUTFILE="ipler.txt"

> "$OUTFILE"

# İlk sayfadan toplam sayfa sayısını öğren
FIRST=$(curl -s "$API")

PAGECOUNT=$(echo "$FIRST" | jq -r '.pageCount')

echo "$FIRST" | jq -r '.models[].url' >> "$OUTFILE"

echo "Toplam sayfa: $PAGECOUNT"

for ((page=1; page<PAGECOUNT; page++)); do
    echo "Sayfa $page / $((PAGECOUNT-1)) indiriliyor..."

    curl -s "${API}&page=${page}" \
        | jq -r '.models[].url' >> "$OUTFILE"

    sleep 0.2
done

sort -u "$OUTFILE" -o "$OUTFILE"

echo
echo "Tamamlandı."
echo "Toplam IP: $(wc -l < "$OUTFILE")"
echo "Dosya: $OUTFILE"