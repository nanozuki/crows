set dir $argv[1]
echo "Import gpg public keys from $dir"
for file in (ls $dir/*pub.gpg)
    gpg --import $file
end
echo "Import secret keys from $dir"
for file in (ls $dir/*sec.gpg)
    gpg --allow-secret-key-import --import $file
end
