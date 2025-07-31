
echo "\nListe des répertoires dans \$PATH :"
IFS=':' read -ra DIRS <<< "$PATH"
for dir in "${DIRS[@]}"; do
    echo "$dir"
done



echo "\nListe des répertoires dans \$CLASSPATH :"
IFS=':' read -ra DIRS <<< "$CLASSPATH"
for dir in "${DIRS[@]}"; do
    echo "$dir"
done


echo "\nListe des répertoires dans \$PYTHON_PATH :"
IFS=':' read -ra DIRS <<< "$PYTHON_PATH"
for dir in "${DIRS[@]}"; do
    echo "$dir"
done